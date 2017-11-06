clear all
close all

Vi=160;
Vimin=40;
Vo=28;
Dnom=Vo/Vi;
Iomax=12;
Pmax=300;
Iimax=Pmax/Vimin;
Lo=12e-6; %output inductor
fsw=425e3; %switching frequency
dIin=0.02; % desired input current ripple
Att=20*log10(Iomax/dIin)

dI=(Vi-Vo)*(Vo./Vi)./(Lo*fsw)


Cout=dI./(8*fsw*0.015); %assume desire 20mV of ripple

fcx=1./(2*pi*sqrt(Lo*Cout))

%use a simple LC filter 40dB/dec
%calculate corner frequency of filter to get desired attenuation
fcfilter=fsw/(10^(Att/40));
%max 250V capacitance available on digikey
C250Vmax=2.2e-6
%step through possible integer number of bulk cap
N=1:8;
Lfilter=(1./(fcfilter*2*pi)).^2./(N.*C250Vmax);
plot(N,Lfilter*1e6);
xlabel('number of 250V 2.2uF');
ylabel('required input inductance uH');

%try to use the same EQ25 core for procurement purpose
turns=round(Iimax*Lfilter(3)./(0.35*89.7e-6));
Lin=turns*0.35*89.7e-6/Iimax;
%Lin=5*0.35*89.7e-6/Iimax;
Cin=6*C250Vmax;

%frequency vector
freq=1e2:1e2:1e6;
w=2.*pi.*freq;
s=j.*w;
fcfilter=1/(2*pi*sqrt(Lin*Cin));
Rfo=sqrt(Lin./Cin);
Zof=1.5.*Rfo; %characteristic impedance of filter
%%optimal ratio Cf2/Cbulk of R-C damping network
%n=(Rfo^2/Zof^2)*(1+sqrt(1+4*Zof^2/Rfo^2)); 
%Rdamp=Rfo*sqrt((2+n)*(4+3*n)/(2*n^2*(4+n))); %optimal Rdamp
%Cdamp=Cin*n; 

%L-RL damping
n=(-2+sqrt(4+16*(Zof/Rfo)^2))/8;
Ldamp=Lin*n;
Rdamp=Rfo*sqrt(n*(3+4*n)*(1+2*n)/(2*(1+4*n)));

% plotting stuff
RL=Rload(300,28);
RL=[0.1 1 10 100 10000];

figure()

for Rx=RL
    ZN=buckZN(Rx,Dnom,s);
    ZD=buckZD(Lo,10e-3,Cout,10e-3,Rx,Dnom,s);
    %ZS=parallel(s.*Lin+20e-3,parallel(Rdamp+1./(s.*Cdamp),1./(s.*Cin)));
    ZS=parallel(s.*Lin+20e-3,parallel(Rdamp+s.*Ldamp,1./(s.*Cin)));
    
    %calculate dB of impedance
    %ZNdB=20.*log10(abs(ZN));
    ZDdB=20.*log10(abs(ZD));
    ZSdB=20.*log10(abs(ZS));
    
    %plot impedances
    semilogx(freq,ZDdB,'r');
    hold on;

end

%semilogx(freq,ZNdB,'g');
semilogx(freq,ZSdB);

axis([100 1e6 -60 100]);
xlabel('frequency (Hz)');
ylabel('impedance (dB)');
legend('RL=0.1','1','10','100','10000','ZS');

hold off;

Hs=(1./(s.*Cin))./(parallel(s.*Lin+20e-3,s.*Ldamp+Rdamp)+1./(s.*Cin));
figure()
semilogx(freq,20.*log10(abs(Hs)));
xlabel('frequency (Hz)');
ylabel('attenuation (dB)');
grid on

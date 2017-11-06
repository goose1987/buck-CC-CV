%%hoang pham

close all
clear all

%design constraint definitions
Vinmax=36; %max input voltage
Vinmin=18; %min input voltage
Vin=28; %nominal input voltage
Vo=5; %nominal output voltage
fsw=100e3; %nominal switching frequency, pretty low frequency recommend raising
Po=100; %output power (W)
Io=Po/Vo; % max output current
RL=Vo/Io;

%assumed constraint to fix buck powertrain output filter
Irip=5; % assume continuous down to 10% load 2.5A, ripple 2x mean, critical conduction, recommend using a swinging choke
Vrip=0.01*Vo; %output ripple at 2% of nominal output

%duty cycle calculations
D=Vo/Vin; %duty cycle for buck converter
Dmin=Vo/Vinmax; %min open loop duty cycle at low line
Dmax=Vo/Vinmin; %max open loop duty cycle at high line

%input current calculations
Iin=Io*D; %input current at nominal duty cycle
Iinmax=Io*Dmax; %max input current at low line 
Iinmin=Io*Dmin; %min input current at high line

%derating for filter components
fderate=0.8;

Vrating=Vinmax/fderate %minimum voltage rating for input filter cap
Irating=Iinmax/fderate %minimum current rating for input inductor


%output filter definition
%Lout=4.7e-6;
Lout=(Vin-Vo)*D*(1/fsw)/Irip; % approximate Lout based on desired Iripple
Loesr=30e-3;
%Cout=100e-6;
Cout=Irip/(8*fsw*Vrip); %approximate Cout with no esr on desired Vripple
Coesr=5e-3;

fRC=1/(2*pi*Rload(50,Vo)*Cout); %RC frequency of output filter, load dependent
fLC=1/(2*pi*sqrt(Lout*Cout)); %LC frequency of output filter, dominant

%frequency vector
freq=1e2:1e2:1e6;
w=2.*pi.*freq;
s=j.*w;

%ZN=RL./(D.^2).*ones(1,length(freq));
%ZD=(RL/D.^2).*(1+s.*Lout./RL+s.^2.*Lout.*Cout)./(1+s.*RL.*Cout);
%ZD=(1./D.^2).*(s.*Lout+Loesr+parallel(RL,Coesr+1./(s.*Cout)));

wfilt=2*pi*fRC; %place filter peak at the break frequency
Rfo=1;%desired characteristic impedance of LC filter

%C=100e-6; %choose C to start 
%L=1/(wfilt^2*C); %calculate inductance requirement for placing corner freq of filter
L=Rfo/wfilt %inductance requirement based on characteristic impedance and corner freq
C=1/(wfilt^2*L) %calculate capacitancce

%pi filter component definition
%Lf=47e-6;
Lf=L;
Lfesr=50e-3;
Cf1=3.3e-6;
Cf1esr=50e-3;
Cbulk=C;

%Cf2=50e-6;
Cf2=C;
%%Rdamp=1.54;
%Cbulk=47e-6;
Cbesr=100e-3;

Zof=1; %characteristic impedance of filter
n=(Rfo^2/Zof^2)*(1+sqrt(1+4*Zof^2/Rfo^2)); %optimal ratio Cf2/Cbulk of R-C damping network
Rdamp=Rfo*sqrt((2+n)*(4+3*n)/(2*n^2*(4+n))); %optimal Rdamp
Cf2=Cbulk*n; 

L=Cbulk*Rfo^2;

%{
N=10;

Citer=linspace(47e-6,50e-6,N);
Liter=linspace(47e-6,50e-6,N);
RLiter=linspace(0.5,2.5,N);

for i=1:2
    ZN=buckZN(RLiter(i),Dmax,s); %input impedance d=0
    ZD=buckZD(Lout,Loesr,Cout,Coesr,RLiter(i),Dmax,s); %input impedance v = 0


    

    ZS=parallel(s.*Liter(i)+Lfesr,parallel(Rdamp+1./(s.*Cf2),Cbesr+1./(s.*Cbulk)));

    ZNdB=20.*log10(abs(ZN));
    ZDdB=20.*log10(abs(ZD));
    ZSdB=20.*log10(abs(ZS));

    semilogx(freq,ZDdB,'r');
    hold on;

    semilogx(freq,ZNdB,'g');
    semilogx(freq,ZSdB);

    


    
    
end
axis([100 1e6 -60 80]);
hold off;
%}

RL=Rload(100,5);

ZN=buckZN(RL,D,s);
ZD=buckZD(Lout,Loesr,Cout,Coesr,RL,D,s);
ZS=parallel(s.*Lf,parallel(Rdamp+1./(s.*Cf2),1./(s.*Cbulk)));


%calculate dB of impedance
ZNdB=20.*log10(abs(ZN));
ZDdB=20.*log10(abs(ZD));
ZSdB=20.*log10(abs(ZS));


%plot impedances
semilogx(freq,ZDdB,'r');
hold on;

semilogx(freq,ZNdB,'g');
semilogx(freq,ZSdB);

axis([100 1e6 -60 100]);
xlabel('frequency (Hz)');
ylabel('impedance (dB)');
legend('ZN','ZD','ZS');

hold off;

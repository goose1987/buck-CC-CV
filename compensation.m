clear all
close all

Vi=160;
Vimin=40;
Vo=28;
Iomax=12;
Pmax=300;
Iimax=Pmax/Vimin;
Lo=12e-6; %output inductor
fsw=425e3; %switching frequency
dIin=0.01; % desired input current ripple
Att=20*log10(Iomax/dIin)

dI=(Vi-Vo)*(Vo./Vi)./(Lo*fsw)


Cout=dI./(8*fsw*0.02); %assume desire 20mV of ripple

fcx=1./(2*pi*sqrt(Lo*Cout))

%use a simple LC filter 40dB/dec
fcfilter=fsw/(10^(Att/40))
C250Vmax=2.2e-6

N=1:8;

Lfilter=(1./(fcfilter*2*pi)).^2./(N.*C250Vmax);
stairs(N,Lfilter*1e6);

turns=round(Iimax*Lfilter(5)./(0.35*89.7e-6));
Lin=turns*0.35*89.7e-6/Iimax


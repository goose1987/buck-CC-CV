% bound switching frequency based on loss of high side mosfet
close all
requirements

Vi=160;
Vo=28;
Vomin=25;
D=Vo/Vi;
Po=300;
Io=Po/Vomin;
fsw=100e3:10e3:1e6;

IG=2


HSFET_rdson=25e-3;
HSFET_QGS=[1.3e-9 3e-9 2.9e-9];
HSFET_QGD=[0.7e-9 1.8e-9 1.8e-9];
LSFET_Coss=[40e-9 75e-9 60e-9]./Vi;


lgan=[3.6 4.6 4.6].*1e-3;
wgan=[1.6 2.6 1.6].*1e-3;
Agan=lgan.*wgan;

figure()
hold all

for idx=1:length(HSFET_QGS)
    Pcond=Io.^2.*HSFET_rdson.*D;
    Psw=Vi.*Io.*fsw.*(HSFET_QGS(idx)+HSFET_QGD(idx))./IG;
    Pcoss=LSFET_Coss(idx).*Vi^2.*fsw./2;
    Pgate =0;

    Phs=Pcond+Psw+Pcoss+Pgate;
    plot(fsw,Phs);
    
    
    
end
legend('EPC2010C','EPC2034','EPC2047');
grid on

xlabel('frequency (Hz)');
ylabel('PlossHS (W)');





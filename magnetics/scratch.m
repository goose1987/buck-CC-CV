clear all
close all

%constants
muo=pi*4e-7;
rhoCu=1.72e-8; % resistivity ohm per meter

%initialize cores
ERcores
EQcores
cores.EQ256=EQ256;
cores.ER32625=ER32625;
cores.ER32521=ER32521;


%initialize materials
epcos
ferrite.N87=N87;
ferrite.N95=N95;
ferrite.N97=N97;
ferrite.N92=N92;


Bmax=0.3; % max flux for design
tCu2=0.075e-3; %2 oz copper thickness 3 mils
tCu3=0.110e-3; %3 oz copper thickness
tCu4=0.140e-3; %4 oz copper
tDie=0.180e-3; % assume minimum dielectric thickness of 7 mils or 180 um
Kp=tCu2/tDie;

x=fieldnames(cores)
Pcu_max=2; % assume 2 W max copper loss DC


%{
for i = 1:length(x)
   corex=cores.(x{i});
   Nt=5;
   Aw=tCu2*corex.Ww; %cross section of copper winding
   %cores.(x{i}).Wh
   %Nmax =  floor((cores.(x{i}).Wh-2e-3).*Kp./tCu2)
   muopt=Bmax*corex.le./(muo.*sqrt(Pcu_max.*Nt.*Aw/(rhoCu.*corex.MLT)))
   gap=corex.le./muopt
   Lopt=muopt.*muo.*Nt^2.*corex.Ae./corex.le
   PlossCu=rhoCu.*Nt.*corex.MLT.*12^2./Aw
end
%}


figure()
hold all
Iout=12;
fsw=400e3;
Pmin=[];
Vcore=[];

for i = 1:length(x)
    
    corex=cores.(x{i}); %step through core
    matx=ferrite.N87; % pick material
    
    Aw=tCu2.*corex.Ww;
    N=2:10;
    PlossCu=rhoCu.*N.*corex.MLT.*Iout.^2./Aw;
    
    dB=(160-28).*(28/160)*(1/500e3)./(N.*corex.Ae);
    
    Pcore=corex.Ve.*matx.Kc.*fsw.^matx.alpha.*dB.^matx.beta;
    Pmin=[Pmin min(Pcore+PlossCu)];
    Vcore=[Vcore corex.Ve];
    plot(N,Pcore+PlossCu,'-o')
end

legend('EQ25/6','ER32/6/25','ER32/5/21')
xlabel('N turns')
ylabel('Ploss DC Copper + Core (W)')
title('loss vs turn N97')
grid on

figure()

bar([Pmin',(Vcore.*1e6)']);
legend('loss (W)','volume (cm^3)');
set(gca,'xticklabel',{'EQ25/6';'ER32/6/25';'ER32/5/21'});

% go with EQ25/6 N95 5 turns
%calculate gap
N=5;
Ioutmax=15; % set max peak current at 15A 12A rms max
Bmax=0.4; % N95 Bsat is 0.4 T at 100C
gap=muo*N*Ioutmax./Bmax

L=muo.*N^2.*cores.EQ256.Ae./gap




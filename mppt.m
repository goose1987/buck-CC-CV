close all
clear all
% solar voltage strong function of temperature
% simple PTC max power point solution

% LT3763 definition
Vth_fbin = 1.206;

% solar definition
VMPP=40:100;

% PTC 
% assume http://www.vishay.com/docs/33017/tfpt.pdf

R_min=7; % -55C kOhms
R_nom=10; % 25C
R_max=16; % 150C
Rptc=7:0.1:16;
Tptc=-55:(150+55)/((16-7)/0.1):150;

%cold array produces high voltage, hot array produces low voltage
%set R_max@hot to the minimum solar voltage to calculate divider

Rdiv=R_max/(Vth_fbin/min(VMPP))-R_max

Vireg=Vth_fbin./(Rptc./(Rptc+Rdiv));
plot(Tptc,Vireg)

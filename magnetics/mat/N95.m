%https://en.tdk.eu/download/528882/3226013b0ed82a6a2af3666f537cbf83/pdf-n87.pdf

N95.ui=3000; %initial permeability at 25C
N95.Bsat=0.410; % Bsat T at 100C
N95.nB=0.6e-6 ; %1/mT hysteresis material constant
N95.Tcur=220; %curie temp
N95.alphaF=2e-6; %1/K
N95.pd = 4900; %kg/m3 density        
N95.p = 6; %resistivity Ohm m

%{
classdef N95 < ferrite

    methods
        function obj=N95()
            obj.ui=3000; %initial permeability at 25C
            obj.Bsat=0.410; % Bsat T at 100C
            obj.nB=0.6e-6 ; %1/mT hysteresis material constant
            obj.Tcur=220; %curie temp
            obj.alphaF=2e-6; %1/K
            obj.pd = 4900; %kg/m3 density
        
            obj.p = 6; %resistivity Ohm m
       
        end

    end
    
end
%}
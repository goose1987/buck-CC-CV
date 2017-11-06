%https://en.tdk.eu/download/528882/3226013b0ed82a6a2af3666f537cbf83/pdf-n87.pdf

N87.ui=2200; %initial permeability at 25C
N87.Bsat=0.390; % Bsat T at 100C
N87.nB=1e-6 ; %1/mT hysteresis material constant
N87.Tcur=210; %curie temp
N87.alphaF=4e-6; %1/K
N87.pd = 4850; %kg/m3 density
N87.p = 10; %resistivity Ohm m

%{
classdef N87 < ferrite


    methods
        function obj=N87()
            obj.ui=2200; %initial permeability at 25C
            obj.Bsat=0.390; % Bsat T at 100C
            obj.nB=1e-6 ; %1/mT hysteresis material constant
            obj.Tcur=210; %curie temp
            obj.alphaF=4e-6; %1/K
            obj.pd = 4850; %kg/m3 density

            obj.p = 10; %resistivity Ohm m

        end

    end

end
%}
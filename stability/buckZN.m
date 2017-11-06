%calculate buck input impedance with v(s)->0
function ZN=buckZN(RL,D,s)

    ZN=RL./(D.^2).*ones(1,length(s));
end
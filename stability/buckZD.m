%calculate buck input impedance with d(s)->0
function ZD=buckZD(L,Lesr,C,Cesr,RL,D,s)


ZD=(1./D.^2).*(s.*L+Lesr+parallel(RL,Cesr+1./(s.*C)));

end
% This function will solve the right hand side of the differential equations
% and provide the next timestep for the number of susc, inf, rec
% Nick Duncan
% 
% January 2018

function dSIR = SIR_rhs(del_t,SIR,pars,capacity)
dSIR = zeros(3,1);
alpha=pars(1);
beta=pars(2);
mu=pars(3);
% mu = 0;
%  dSIR(1) = (-(alpha*SIR(1)*SIR(2))+mu*SIR(1))*del_t; 
dSIR(1) = (-(alpha*SIR(1)*SIR(2))+(mu*((capacity-SIR(4)/capacity))*SIR(4)))*del_t; 
dSIR(2) = (alpha*SIR(1)*SIR(2) - beta*SIR(2))*del_t;
dSIR(3) = (beta*SIR(2))*del_t;
end
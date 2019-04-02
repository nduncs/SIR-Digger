function ESS = error_SSE(pars,SIR, SIR0)
beta = pars(1);
gamma = pars(2);

tspan = [0:13];

data = [3;6;25;73;222;294;258;237;191;125;69;27;11;4];

N = SIR(1)+SIR(2)+SIR(3);

[t,y]=ode45(@SIR_rhs,tspan,SIR0,[],[beta,gamma,N]);

diff = data-SIR(:,2);
ESS=sum(diff.^2);
end
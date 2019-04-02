%% SIR model (Susceptible Infected Recovered)

% January 2018

% Nick Duncan

% Inputs 
% Data from Twitter 
   % Susceptibles - # of followers of tweeters
   % Infected - # of tweets with specific phrase
   
% Outputs
    % A time series of S I and R
    % The infectious parameter beta
    % The recovery parameter gamma
    % The susceptible growth rate mu
    % reproductive # to determine if it is a growning or declining epidemic
    
%% Initialize constants and variables
 function [x,R0, SIR,Rsquared] = SIRmain1(time,dataI,dataS)

alpha           = .000001;               % Infectious rate
beta            = .000001;               % recovery rate 
mu              = 0;                  % growth rate
params          = [alpha, beta, mu];
%% Use a solving routine to determine alpha, beta and mu for minimizing objective function
SSE             = @(params)Error_sum_of_squares1(params,time,dataI,dataS);
% fun             = @(params)SSE(params);
% this sets a constraint for alpha and beta to be positive
A  = [-1, -1, 0]; 
b  = [0; 0; 0];
Aeq = [];
Beq = [];
lb = [0 0 -inf];
ub = [inf inf inf]; 
% objective function is minimized to find the values of alpha and beta
[x,fval]        = fmincon(SSE,params,A,0,Aeq,Beq,lb,ub);


[ESS,time_model,SIR,Rsquared] = Error_sum_of_squares1(x,time,dataI,dataS);
R0              = x(1)/x(2);

%% Plot the results
% figure
% plot(time,dataI,'x','MarkerSize',10);
% hold on
% plot(time_model,SIR(:,2),'r','linewidth',1.5);
% % title('SIR Model for #ClimbtoGlory');
% legend('Infected Data', 'Infected SIR Model','location','Northeast');
% xlabel('Days');
% ylabel('Number of People');
% axis([time(1) time(end) 0 max(SIR(:,2))]);
% figure
% % subplot(3,1,2);
% plot(time, dataS, 'x', 'MarkerSize', 10);
% axis([time(1) time(end) 0 max(SIR(:,1))]);
% hold on
% plot(time_model,SIR(:,1),'r','LineWidth',3);
% % axis([time(1) time(end) 0 max(SIR(:,1))]);
% xlabel('time (days)');
% ylabel('Number of People');
% legend('Susceptible Data','Susceptible SIR Model');
% % subplot(3,1,3);
% figure
% plot(time_model,SIR(:,3),'b');
% % axis([time(1) time(end) 0 max(SIR(:,3))]);
% xlabel('time (days)');
% ylabel('Number of People');
% legend('Recovered SIR Model');
 end




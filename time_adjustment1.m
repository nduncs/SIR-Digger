%% Algorithm to find the epidemic portion of the data

% This will take the collected data and truncate the time period
% To look at the epidemic portion of the idea movement

%% Cut the time down by a factor and solve for the best Rsquared
factor     = 10;
timestep   = 10;
% [dataTime1, dataSusc1, dataInf1, del_t,run_time1,time1,tweet1,follower1]...
%     =time_adjust_SIR(factor,time,tweet,follower,timestep,total_tweets);
%% Solve for the optimal time adjustment to maximize Rsquared

time_solve  = @(factor)Select_Output(factor,time,tweet,follower,timestep,total_tweets);
% fun         = @(factor)time_solve(Rsquared);
A           = -length(time);
B           = 0;
Aeq         = [];  beq = [];
x0          = factor;
lb          = x0;
ub          = 0.5*length(time);
[x,fval]    = fminsearch(time_solve,x0);
% [x,fval]    = fmincon(time_solve,x0,A,B,Aeq,beq,lb,ub);

%% Run the SIR model with actual factor determined

[Rsquared,params1, R01, SIRmodel1,dataTime1, dataSusc1, dataInf1, del_t,run_time1,time1,tweet1,follower1]...
    =time_adjust_SIR(fval,time,tweet,follower,timestep,total_tweets);
%% plot the result
figure
plot(dataTime1,dataInf1,'x','MarkerSize',10);
hold on
plot(SIRmodel(:,5),SIRmodel(:,2),'r','linewidth',1.5);
% title('SIR Model for #ClimbtoGlory');
% legend('Infected Data', 'Infected SIR Model','location','Northeast');
legend('Infected SIR Model','location','Northeast');
xlabel('Days');
ylabel('Number of People');
axis([SIRmodel(1,5) SIRmodel1(end,5) 0 max(SIRmodel(:,2))]);
% dtime(1000) = zeros;
% infected(492:1000) = zeros;
% for i=301:1000
%     infected(i) = infected(i-1)-0.005;
%     dtime(i) = dtime(i-1)+0.001;
% end
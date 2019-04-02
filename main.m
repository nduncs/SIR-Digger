%% this program will utilize the twitty.m function to connect to the twitte
% API and collect tweets

% May 2018 Nick Duncan

clear
clc
%% Set up our crudentials
creds = struct;
[creds.ConsumerKey creds.ConsumerSecret creds.AccessToken creds.AccessTokenSecret] = credentials();

%%collect data

fromdate = 201902150000; %start date of query, has to be < 30 days ago
todate = 201903130000;  % end date of query, has to be < 30 days ago

query = '' ;  % phrase to search for

% [result,time,tweet,follower] = twitter_data_collector(query,fromdate,todate,creds)
tw = twitty(creds);
tw.jsonParser = @loadjson;
result = tw.search30day(query,'fromDate',fromdate,'toDate',todate);
bins = length(result);
bins = length(result{1,bins}.results);
next = result{1,1}.next;
time             = strings(1,bins);
tweet            = strings(1,bins);
follower(1:bins) = zeros();
for i = 1:bins
    time(1,i) = result{1,1}.results{1,i}.created_at;
    tweet(1,i) = result{1,1}.results{1,i}.text;
    follower(1,i) = result{1,1}.results{1,i}.user.followers_count;
end
i = 1;
while i > 0
    i = i+1;
    result{1,i} = tw.search30day(query,'fromDate',fromdate,'toDate',todate,'next',next);
    bins1 = length(result);
    bins1 = length(result{1,bins1}{1,1}.results);
    temp_time              = strings(1,bins1);
    temp_tweet             = strings(1,bins1);
    temp_follower(1:bins1) = zeros();
    for j = 1:bins1
        temp_time(1,j)      = result{1,i}{1,1}.results{1,j}.created_at;
        temp_tweet(1,j)     = result{1,i}{1,1}.results{1,j}.text;
        temp_follower(1,j)  = result{1,i}{1,1}.results{1,j}.user.followers_count;
    end
    time        = [time temp_time];
    tweet       = [tweet temp_tweet];
    follower    = [follower temp_follower];
    clear temp_time temp_tweet temp_follower;
    if isfield(result{1,i}{1,1}, 'next')==0
         break
    end
     next = result{1,i}{1,1}.next;
end


%% divide up the results for the SIR model
total_tweets = length(time);
start = datetime(time(1,total_tweets) ,...
    'TimeZone','Europe/London', 'Inputformat','eee MMM dd HH:mm:ss Z yyyy');
stop = datetime(time(1,1),...
    'TimeZone','Europe/London', 'Inputformat','eee MMM dd HH:mm:ss Z yyyy');
start = datenum(start);
stop = datenum(stop);
run_time = stop - start;
timestep = 10;
del_t = (run_time/timestep); 
[dataTime dataSusc dataInf del_t] = groupcount(time, tweet, follower,...
    timestep,del_t,start,stop,total_tweets);
plot(dataInf);

%% Run the SIR model with the Data
dataTime_temp = datenum(dataTime);
dataTime = datenum(dataTime);
dataTime(1) = 0;
for i = 2:timestep
    dataTime(i) = dataTime(i)-dataTime_temp(i-1);
    dataTime(i) = dataTime(i-1)+ dataTime(i);
end
[SIR, R0, SIRmodel,Rsquared] = SIRmain1(dataTime, dataInf, dataSusc);

figure;
[size, max_breadth, cascade] = MIT_analyze(result,time,timestep,dataTime);
figure
plot(dataTime,dataInf,'x','MarkerSize',10);
hold on
plot(SIRmodel(:,5),SIRmodel(:,2),'r','linewidth',1.5);
% title('SIR Model for #ClimbtoGlory');
legend('Infected Data', 'Infected SIR Model','location','Northeast');
xlabel('Days');
ylabel('Number of People');
axis([SIRmodel(1,5) SIRmodel(end,5) 0 max(SIRmodel(:,2))]);
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

% [SIR, R0, SIRmodel,Rsquared] = SIRmain(dataTime, dataInf, dataSusc);
% dataInf  =dataInf(11:27);
% dataSusc = dataSusc(11:27);
% dataTime = dataTime(11:27);

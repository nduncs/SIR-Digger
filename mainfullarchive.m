%% this program will utilize the twitty.m function to connect to the twitte
% API and collect tweets for the fullarchive,  you can search all the way
%back to the first tweet in 2006

% May 2018 Nick Duncan

clear
clc
%% Set up our crudentials
creds = struct;
[creds.ConsumerKey creds.ConsumerSecret creds.AccessToken creds.AccessTokenSecret] = credentials();

%% initialize parameters

%%collect data
fromdate = 201402010000; %start date of query, has to be < 30 days ago
todate = 201403010000;  % end date of query, has to be < 30 days ago
query = 'power outage';  % phrase to search for
tw = twitty(creds);
tw.jsonParser = @loadjson;
result = tw.searchfullarchive(query,'fromDate',fromdate,'toDate',todate);
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
    result{1,i} = tw.searchfullarchive(query,'fromDate',fromdate,'toDate',todate,'next',next);
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
timestep = 10;
[dataTime dataSusc dataInf del_t] = groupcount(time, tweet, follower,timestep);
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
[size, max_breadth, cascade] = MIT_analyze(result,time,timestep,dataTime);

% dataInf=dataInf(1:10);
% dataSusc = dataSusc(1:10);
% dataTime = dataTime(1:10);
% [SIR, R0, SIRmodel] = SIRmain(dataTime, dataInf, dataSusc);

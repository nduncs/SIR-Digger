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
% I = imread('oilrevenue.png');
% txt = ocr(I,'Language','arabic');
language = 'en';
%% collect data
% query = strjoin(txt.Words);
query = 'describes what it s like to prepare then perform a spacewalk to ';  % phrase to search for
% since_id = 0;
max_id = 0;
tw = twitty(creds);
tw.jsonParser = @loadjson;
time        = 0;
tweet       = 0;
follower    = 0;
i = 0;
while i >= 0
    i = i+1;
    result{1,i} = tw.search(query,'lang',language,'max_id',max_id,'count',100);
    bins1 = length(result);
    bins2 = length(result{1,bins1}{1,1}.statuses);
    temp_time              = strings(1,bins1);
    temp_tweet             = strings(1,bins1);
    temp_follower(1:bins1) = zeros();
    for j = 1:bins2
        temp_time(1,j)      = result{1,i}{1,1}.statuses{1,j}.created_at;
        temp_tweet(1,j)     = result{1,i}{1,1}.statuses{1,j}.text;
        temp_follower(1,j)  = result{1,i}{1,1}.statuses{1,j}.user.followers_count;
    end
    time        = [time temp_time];
    tweet       = [tweet temp_tweet];
    follower    = [follower temp_follower];
    clear temp_time temp_tweet temp_follower;
%      since_id = result{1,bins1}{1,1}.statuses{1,bins2}.id;
   max_id = num2str(result{1,bins1}{1,1}.statuses{1,bins2}.id);
%    max_id = char(max_id);
    if bins2 < 100
         break
    end
end
time     = time(2:end);
tweet    = tweet(2:end);
follower = follower(2:end);

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

[params, R0, SIR,Rsquared] = SIRmain1(dataTime, dataInf, dataSusc);
figure
[size, max_breadth, cascade] = MIT_analyze1(result,time,timestep,dataTime);

figure
plot(dataTime,dataInf,'x','MarkerSize',10);
hold on
plot(SIR(:,5),SIR(:,2),'r','linewidth',1.5);
% title('SIR Model for #ClimbtoGlory');
legend('Infected Data', 'Infected SIR Model','location','Northeast');
xlabel('Days');
ylabel('Number of People');
axis([SIR(1,5) SIR(end,5) 0 max(SIR(:,2))]);



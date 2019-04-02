%% this function takes the results of time and puts counts each tweet in a give time step

function [dataTime dataSusc dataInf,del_t] = groupcount(time, tweet, follower,timestep,del_t,start,stop,total_tweets)

% total_tweets = length(time);
% %   total_tweets = 34940;
% start = datetime(time(1,total_tweets) ,...
%     'TimeZone','Europe/London', 'Inputformat','eee MMM dd HH:mm:ss Z yyyy');
% stop = datetime(time(1,1),...
%     'TimeZone','Europe/London', 'Inputformat','eee MMM dd HH:mm:ss Z yyyy');
% 
% start = datenum(start);
% stop = datenum(stop);
% run_time = stop - start;
% del_t = (run_time/timestep); 

dataTime(1:timestep) = zeros();
dataTime(1) = start;
for i = 2:timestep
    dataTime(i) = dataTime(i-1) + del_t;
end
dataTime = datetime(dataTime,'ConvertFrom','datenum');

dataInf(1:timestep) = zeros();
dataSusc(1:timestep) = zeros();
timeupper = datetime(stop, 'Timezone', 'Europe/London','ConvertFrom','datenum');
timelower = datetime(stop - del_t, 'Timezone' ,'Europe/London','ConvertFrom','datenum');
time = datetime(time,'TimeZone','Europe/London', 'Inputformat'...
        ,'eee MMM dd HH:mm:ss Z yyyy');
for j = timestep:-1:1
    index = isbetween(time,timelower, timeupper); 
    temp_susc = 0;
    temp_inf = 0;
    for i=1:total_tweets
        if index(1,i) == 1
            temp_susc = temp_susc+follower(1,i);
            temp_inf = temp_inf + 1;
        end
    end
    dataInf(j) = temp_inf;
    dataSusc(j) = temp_susc;
    timeupper = timelower;
    timelower = timelower - del_t;
end
end
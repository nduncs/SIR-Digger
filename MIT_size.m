%% this function takes the results of time and  counts each tweet in a given time step

function [size cum_cascade depth dataTime] = MIT_size(time,retweet, cascade, timestep)

total_tweets = length(time);
% total_tweets = 20448;
start = datetime(time(1,total_tweets) ,...
    'TimeZone','Europe/London', 'Inputformat','eee MMM dd HH:mm:ss Z yyyy');
stop = datetime(time(1,1),...
    'TimeZone','Europe/London', 'Inputformat','eee MMM dd HH:mm:ss Z yyyy');

start = datenum(start);
stop = datenum(stop);
run_time = stop - start;
del_t = (run_time/timestep); 
% 
% dataTime(1:timestep) = zeros();
% dataTime(1) = start;
% for i = 2:timestep
%     dataTime(i) = dataTime(i-1) + del_t;
% end
% dataTime = datetime(dataTime,'ConvertFrom','datenum');

size(1:timestep) = zeros();
cum_cascade(1:timestep) = zeros();
depth(1:timestep) = zeros();
timeupper = datetime(stop, 'Timezone', 'Europe/London','ConvertFrom','datenum');
timelower = datetime(stop - del_t, 'Timezone' ,'Europe/London','ConvertFrom','datenum');
time = datetime(time,'TimeZone','Europe/London', 'Inputformat'...
        ,'eee MMM dd HH:mm:ss Z yyyy');
for j = timestep:-1:1
    index = isbetween(time,timelower, timeupper);
    temp_size = 0;
    temp_cascade = 0;
    temp_depth=0;
    for i=1:total_tweets
        if index(1,i) == 1
            temp_size = temp_size+1;
            temp_cascade = temp_cascade+cascade(1,i);
            temp_depth = temp_depth+retweet(1,i);
        end
    end
    size(j) = temp_size;
    cum_cascade(j) = temp_cascade;
    depth(j) = temp_depth;
    timeupper = timelower;
    timelower = timelower - del_t;
end
size(1,:) = size;
cum_cascade(1,:) = cum_cascade;
depth(1,:) = depth;
size(2,:) = zeros();
cum_cascade(2,:) = zeros();
depth(2,:) = zeros();
size(2,1) = size(1,1);
cum_cascade(2,1) = cum_cascade(1,1);
depth(2,1) = depth(1,1);
for i =2:timestep
    size(2,i)=size(2,i-1)+size(1,i);
    cum_cascade(2,i) = cum_cascade(2,i-1)+cum_cascade(1,i);
    depth(2,i) = depth(2,i-1)+depth(1,i);
end
end
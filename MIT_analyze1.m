%% this function will sort through a set of results from a twitter API search
% and determine the depth, size and breadth of the results

% Inputs = results from twitter search
% Outputs 
% depth = # of retweets by unique users
% size  = # of users involved over time
% max_breadth = max # of users in cascade at any depth

% June 2018 Nick Duncan

% function [depth, retweet, size] = MIT_analyze(result,time)

%% initialize parameters
function [size, max_breadth, cascade] = MIT_analyze1(result,time,timestep,dataTime)
bins    = length(result);
% new_result(1,:) = result{1,1}.results;
new_result(1,:) = result{1,1}{1,1}.statuses;
%% create one cell array of all the results
for i = 2:bins
    bins1 = length(new_result);
%     temp_result = result{1,i}{1,1}.results;
    temp_result=result{1,i}{1,1}.statuses;
    bins2 = length(temp_result);
    new_result(1,bins1+1:bins1+bins2)=temp_result;
end
L = length(new_result);
%% search the results for original tweets and retweets to determine cascade and depth
cascade = zeros(1,L);
retweet = zeros(1,L);
for i = 1:L
    index = isfield(new_result{1,i}, 'retweeted_status');
    if index==1
        retweet(1,i)=0;
    else
        cascade(1,i) = 1;
        retweet(1,i)=new_result{1,i}.retweet_count;
    end
end

%% determine depth, size, max_breadth
% timestep = 20;
Total_depth = sum(retweet);
max_breadth = max(retweet); 
% [size cascade depth dataTime] = MIT_size(time,retweet,cascade,timestep);
[size cascade depth] = MIT_size(time,retweet,cascade,timestep);

%% Plot the results

plot(dataTime, cascade(2,:));
xlabel('Date');
ylabel('Number of People');
hold on
plot(dataTime,size(2,:));
hold on
% plot(dataTime, depth(2,:));
legend('# of Cascades','Size','location','northwest', 'orientation', 'horizontal' );
legend('boxoff');
end

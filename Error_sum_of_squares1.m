%% This function is where you input the twitter data to create the SIR Model

% January 2018

% Nick Duncan

% inputs - params(alpha, beta, mu), Twitter data

function [ESS,time_model,SIR,Rsquared] = error_sum_of_squares1(params,time,dataI,dataS)
    tspan           = round(time(end),2);
    dataN(1:length(time)) = zeros();
    dataN(1)        = dataS(1) + dataI(1);
    capacity        = max(dataS);
    SIR0            = [dataS(1),dataI(1),0,dataN(1),time(1)];  % initial conditions
    del_t           = .001;          
    grid_size       = (1/del_t)*tspan;
    time_model(grid_size+1) = zeros();
    for j = 2:grid_size+1;
        time_model(j) = time_model(j-1)+del_t;
    end
    [SIR Imodel] = SIR_Model(del_t,SIR0,params,grid_size,time,capacity);
    I = transpose(Imodel(:,2,:,:));
    diff    =dataI-I;
    ESS     =sum(diff.^2);
    diff    = dataI - mean(dataI);
    SSR     =sum(diff.^2); 
    Rsquared=1-(ESS/SSR);
end
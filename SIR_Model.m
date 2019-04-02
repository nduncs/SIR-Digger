function [SIR I] = SIR_Model(del_t,SIR0,params,grid_size,time,capacity)
    SIR(grid_size+1,5)= zeros();
    SIR(1,:) = SIR0;
    for i = 2:grid_size+1
        dSIR=SIR_rhs(del_t,SIR(i-1,:),params,capacity);
        SIR(i,1)=SIR(i-1,1)+dSIR(1);
        SIR(i,2)=SIR(i-1,2)+dSIR(2);
        SIR(i,3)=SIR(i-1,3)+dSIR(3);
        SIR(i,4)=SIR(i,1)+SIR(i,2)+SIR(i,3);
        SIR(i,5)=SIR(i-1,5)+del_t;
        if SIR(i,:) < 0
            SIR(i,:) = 0;
        end
    end

    %% Find the values of the SIR model that corresponds to the time of the data
    for j = 1:length(time) 
        k = time(j);
        [row column] = find(SIR(:,5)<=k);
        I(j,:) = SIR(row(end),:);
    end
end
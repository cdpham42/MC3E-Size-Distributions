function [liquid] = LWC(data, bin, dbin)

%{
    Liquid Water Content calculation for normalization
    Input: dataset, bin, and dD for bins
    Output: LWC for every second in dataset
%}

%% Converting Bins to meters

bin = bin.*10^(-3); % mm to m
dbin = dbin.*10^(-6); % micron to m

%% Calculating LWC

liquid = zeros(size(data,1),1,size(data,3));

pw = 1000; % kg/m^-3, density of water

for k = 1:size(data,3)  % Per flight
    for i = 1:size(data,1)  % Row
        sum = 0;
        for j = 1:size(data,2)  % Column
            if isnan(data(i,j,k))
                data(i,j,k) = 0;
            end
            sum = sum + data(i,j,k) * bin(j)^3 * dbin(j);
        end
        liquid(i,k) = (pi*pw/6) * sum;
        
        if isnan(liquid(i,1,k))
            fprintf('Row %f    Page %f\n',i,k);
        end
        
    end
end

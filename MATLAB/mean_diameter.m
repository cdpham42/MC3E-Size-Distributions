function [Dm] = mean_diameter(data, bin, dbin)

%{
    Mean Volume Diameter calculation
    Input: Size Distribution, Bin, and Delta D of Bins
    Output: Mean Diameter for every second
%}

%% Converting bins to meters

bin = bin.*10^(-3); % mm to m
dbin = dbin.*10^(-6); % micron to m

%% Calculating mean diameter

Dm = zeros(size(data,1),1,size(data,3));

for k = 1:size(data,3)  % Per flight
    for i = 1:size(data,1)  % Row
        sum1 = 0;
        sum2 = 0;
        for j = 1:size(data,2)  % Column
            if isnan(data(i,j,k))
                data(i,j,k) = 0;
            end
            
            sum1 = sum1 + data(i,j,k) * bin(j)^4 * dbin(j);
            sum2 = sum2 + data(i,j,k) * bin(j)^3 * dbin(j);
        end
        
        if sum2 ~= 0
            Dm(i,1,k) = sum1/sum2;
        end
        
        if isnan(Dm(i,1,k)) % If NaN, something's up. 
            fprintf('Row %f    Page %f\n',i,k);
        end
        
    end
end

function No = scale(data, bin, dbin)

liquid = LWC(data,bin,dbin); % liquid water content
Dm = mean_diameter(data,bin,dbin); % mean volume diameter

pw = 1000; % kg/m^3, density of water

No = (4^4/(pi*pw))*(liquid./Dm.^4);

for k = 1:15
    for i = 1:size(No,1)
        if isnan(No(i,k))
            No(i,k) = 0;
        end
    end
end

function dist = nlogd(data,binend)

% Written for combined spectrum, all other variables commented out

dist = size(data);

%% Bin Data

% Delta D for summation calculations
dbin = zeros(size(binend,2)-1);
for i = 1:size(binend,2)-1
    dbin(i) = binend(i+1) - binend(i);
end


% Converting dbin sizes to meters

dbin = dbin.*10^(-6);

% dlogD

binendlog = log10(binend);

dlogbin = zeros(size(binend,2)-1);
for i = 1:size(binendlog,2)-1;
    dlogbin(i) = binendlog(i+1) - binendlog(i);
end

% Converting dlogbin to meters
dlogbin = dlogbin.*10^(-6);

%% Calculation for converting N(D) to N(logD)

for i = 1:size(data,1);
    for j = 1:size(data,2);
        dist(i,j) = data(i,j) * dbin(j) / dlogbin(j);
    end
end

%% Other Bin Data


% DCbin = [    75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  1900.0];
% 
% CIPbin = [    75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  1900.0];
% 
% HVPSbin = [   300.0   500.0   700.0   900.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];


% DCbinend = [50.0   100.0   150.0   200.0   250.0   300.0   350.0   400.0   475.0   550.0   625.0   700.0   800.0   900.0  1000.0  1200.0  1400.0  1600.0  1800.0  2000.0];
% for i = 1:size(DCbin,2)
%     DCdbin(i) = DCbinend(i+1) - DCbinend(i);
% end
% 
% CIPbinend = [50.0   100.0   150.0   200.0   250.0   300.0   350.0   400.0   475.0   550.0   625.0   700.0   800.0   900.0  1000.0  1200.0  1400.0  1600.0  1800.0  2000.0];
% for i = 1:size(CIPbin,2)
%     CIPdbin(i) = CIPbinend(i+1) - CIPbinend(i);
% end
% 
% HVPSbinend = [ 200.0   400.0   600.0   800.0  1000.0  1200.0  1400.0  1600.0  1800.0  2200.0  2600.0  3000.0  3400.0  3800.0  4200.0  4600.0  5000.0  6000.0  7000.0  8000.0  9000.0 10000.0 12000.0 14000.0 16000.0 18000.0 20000.0 25000.0 30000.0];
% for i = 1:size(HVPSbinend,2)-1
%     HVPSdbin(i) = HVPSbinend(i+1) - HVPSbinend(i);
% end

% DCbin = DCbin .* 10^(-6);
% CIPbin = CIPbin .* 10^(-6);
% HVPSbin = HVPSbin .* 10^(-6);

% DCdbin = DCdbin.*10^(-6);
% CIPdbin = CIPdbin.*10^(-6);
% HVPSdbin = HVPSdbin.*10^(-6);
end
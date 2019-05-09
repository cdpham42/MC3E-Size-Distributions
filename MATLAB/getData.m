% getData Reads in and organizes needed data from open files for mc3e,
% combined spectrum, 2DC, CIP, and HVPS datasets. Returns size
% distributions from probes.
% 
% Input: fopen file IDs
% 
% Output: Size distribution for all data corresponding to above freezing
% temperatures.

function [mc3eData,combData,DCData,CIPData,HVPSData] = getData(mc3e,comb,DC,CIP,HVPS)

mc3eData = textscan(mc3e,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',...
    'HeaderLines',62);

combData = textscan(comb,'%n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n',...
    'Headerlines',40);

DCData = textscan(DC,'%n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n',...
    'Headerlines',40);

CIPData = textscan(CIP,'%n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n',...
    'Headerlines',40);

HVPSData = textscan(HVPS,'%n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n',...
    'Headerlines',38);

%% Organizing Data

%% Relevant Data

combbin = [75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
    % Bin mid-points for diameter in microns
combbin = combbin .* 10^(-3);   % Converting bin sizes to millimeter

DCbin = [    75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  1900.0];
DCbin = DCbin .* 10^(-3);   % Converting bin sizes to millimeter

CIPbin = [    75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  1900.0];
CIPbin = CIPbin .* 10^(-3);   % Converting bin sizes to millimeter

HVPSbin = [   300.0   500.0   700.0   900.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
HVPSbin = HVPSbin .* 10^(-3);   % Converting bin sizes to millimeter

mc3eTime = mc3eData{1};
combTime = combData{1};
DCTime = DCData{1};
CIPTime = CIPData{1};
HVPSTime = HVPSData{1};

AirTemp = mc3eData{2};  % Celsius
PresAlt = mc3eData{6};  % Pressure Altitude [m]
TAS = mc3eData{5};

%% Organizing Data

% Putting Particle Probe data into a matrixed array

for i = 1:45
    temp = mc3eData{i};
    for j = 1:size(temp)
        mc3e(j,i) = temp(j);
    end
end

for i = 1:size(combbin,2)
    j = i+3;

    temp = combData{j};
    for k = 1:size(temp)
        comb(k,i) = temp(k);
    end
end

for i = 1:size(DCbin,2)
    j = i+3;
    temp = DCData{j};
    for k = 1:size(temp)
        DC(k,i) = temp(k);
    end
end

for i = 1:size(CIPbin,2)
    j = i+3;
    temp = CIPData{j};
    for k = 1:size(temp)
       CIP(k,i) = temp(k);
    end
end

for i = 1:size(HVPSbin,2)
    j = i+3;
    temp = HVPSData{j};
    for k = 1:size(temp)
        HVPS(k,i) = temp(k);
    end
end

% Matching mc3e and probe data by time, as there is a difference in the size
% of the AirTemp array and comb array. Time skip exists in some of the the 
% .mc3e data, so probe data must be changed to match, omitting data within
% the time skip

error = size(combTime,1) - size(mc3eTime,1);

for i = 1:size(mc3eTime,1)
    if round(mc3eTime(i)) ~= combTime(i)
        comb = comb([1:i-1,i+error:end],:);
        combTime = combTime([1:i-1,i+error:end],:);
%         disp(i);
        break
    end
end

error = size(DCTime,1) - size(mc3eTime,1);

for i = 1:size(mc3eTime,1)
    if round(mc3eTime(i)) ~= DCTime(i)
        DC = DC([1:i-1,i+error:end],:);
        DCTime = DCTime([1:i-1,i+error:end],:);
%         disp(i);
        break
    end
end

error = size(CIPTime,1) - size(mc3eTime,1);


for i = 1:size(mc3eTime,1)
    if round(mc3eTime(i)) ~= CIPTime(i)
        CIP = CIP([1:i-1,i+error:end],:);
        CIPTime = CIPTime([1:i-1,i+error:end],:);
%         disp(i);
        break
    end
end

error = size(HVPSTime,1) - size(mc3eTime,1);


for i = 1:size(mc3eTime,1)
    if round(mc3eTime(i)) ~= HVPSTime(i)
        HVPS = HVPS([1:i-1,i+error:end],:);
        HVPSTime = HVPSTime([1:i-1,i+error:end],:);
%         disp(i);
        break
    end
end

% for i = 1:size(mc3eTime,1)
%     if round(mc3eTime(i)) ~= combTime(i)
%         fprintf('mc3e Time: %5.0f; comb Time: %5.0f\n',round(mc3eTime(i)),combTime(i));
%     end
% end
        

%% Zeroing all null data, null data = 9.99e30

for i = 1:size(comb,1)
    for j = 1:size(comb,2)
        if comb(i,j) == 9.99e30
            comb(i,j) = 0;
        end
    end
    
    for j = 1:size(DC,2)
        if DC(i,j) == 9.99e30
            DC(i,j) = 0;
        end
    end
    
    for j = 1:size(CIP,2)
        if CIP(i,j) == 9.99e30
            CIP(i,j) = 0;
        end
    end
    
    for j = 1:size(HVPS,2)
        if HVPS(i,j) == 9.99e30
            HVPS(i,j) = 0;
        end
    end
    
end

%% Zeroing all data corresponding to temperatures below N Celsius

N = 5;

for i = 1:size(AirTemp,1)
    if AirTemp(i) <= N
        for j = 1:size(comb,2)
            comb(i,j) = 0;
        end
        for j = 1:size(DC,2)
            DC(i,j) = 0;
        end
        for j = 1:size(CIP,2)
            CIP(i,j) = 0;
        end
        for j = 1:size(HVPS,2)
            HVPS(i,j) = 0;
        end
    end
end

%% Zeroing all data at non-flight level, <60m/s

speed = 60;

for i = 1:size(PresAlt,1)   % Loop through all rows
    if TAS(i) < speed
        for j = 1:size(comb,2)
            comb(i,j) = 0;
        end
        for j = 1:size(DC,2)
            DC(i,j) = 0;
        end
        for j = 1:size(CIP,2)
            CIP(i,j) = 0;
        end
        for j = 1:size(HVPS,2)
            HVPS(i,j) = 0;
        end
    end
end

%% Data Output
mc3eData = zeros(14925,45);
for i = 1:size(mc3e,1)
    for j = 1:size(mc3e,2)
        mc3eData(i,j) = mc3e(i,j);
    end
end

combData = zeros(14925,19);
for i = 1:size(comb,1)
    for j = 1:size(comb,2)
        combData(i,j) = comb(i,j);
    end
end

DCData = zeros(14925,19);
for i = 1:size(DC,1)
    for j = 1:size(DC,2)
        DCData(i,j) = DC(i,j);
    end
end

CIPData = zeros(14925,19);
for i = 1:size(CIP,1)
    for j = 1:size(CIP,2)
        CIPData(i,j) = CIP(i,j);
    end
end

HVPSData = zeros(14925,28);
for i = 1:size(HVPS,1)
    for j = 1:size(HVPS,2)
        HVPSData(i,j) = HVPS(i,j);
    end
end

end
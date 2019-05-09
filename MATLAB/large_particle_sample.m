%% Read large particle sample csv file, output distribution plots.

clc
clear
close all force

fprintf('Running... ');

data = csvread('HVPS 427 1027-1033.csv',1);

% date = data(:,1);
date = 427;
time = data(:,1);
hour = data(:,2);
minute = data(:,3);
second = data(:,4);
temp = data(:,5);
TAS = data(:,6);
PresAlt = data(:,7);
distribution = data(:,8:35);

HVPSbin = [   300.0   500.0   700.0   900.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
HVPSbin = HVPSbin .* 10^(-3);   

for i = 1:size(distribution,1) 
    name = strcat({'Distribution '},num2str(date),{' Time '},num2str(time(i)),{' '},num2str(hour(i)),{'h'},num2str(minute(i)),{'m'},num2str(floor(second(i)),'%02d'),{'s'});
    ndplot(HVPSbin,distribution(i,:),name{1},1);
end

fprintf('Done.\n');
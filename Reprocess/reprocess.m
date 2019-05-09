%% Reprocessed Data

clc
clear
close all force

%% Extract Reprocessed Data

fprintf('Extracting Data...');

% DCre = ncread('sdist.20110427.2DC.cdf','conc_minR');
% DCre = reshape(DCre,[12714,19]);
% DCbin = ncread('sdist.20110427.2DC.cdf','bin_max');
% DCtime = ncread('sdist.20110427.2DC.cdf','time');
% DCtimeinfo = ncinfo('sdist.20110427.2DC.cdf','time');
% 
% CIPre = ncread('sdist.20110427.CIP.cdf','conc_minR');
% CIPre = reshape(CIPre,[12714,19]);
% CIPbin = ncread('sdist.20110427.CIP.cdf','bin_max');
% CIPtime = ncread('sdist.20110427.CIP.cdf','time');
% CIPtimeinfo = ncinfo('sdist.20110427.CIP.cdf','time');
% 
% HVPSre = ncread('sdist.20110427.HVPS.cdf','conc_minR');
% HVPSre = reshape(HVPSre,[12714,28]);
% HVPSbinre = ncread('sdist.20110427.HVPS.cdf','bin_max');
% HVPStime = ncread('sdist.20110427.HVPS.cdf','time');
% HVPStimeinfo = ncinfo('sdist.20110427.HVPS.cdf','time');

dated = '0427';

ncid=netcdf.open(['sdist.2011' dated '.2DC.cdf'],'nowrite');
bins2DC = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'bin_mid'));
PSDs2DC = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'conc_minR'));
netcdf.close(ncid)
PSDs2DC = permute(PSDs2DC,[2,1]);

ncid=netcdf.open(['sdist.2011' dated '.CIP.cdf'],'nowrite');
binsCIP = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'bin_mid'));
PSDsCIP = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'conc_minR'));
netcdf.close(ncid)
PSDsCIP = permute(PSDsCIP,[2,1]);

ncid=netcdf.open(['sdist.2011' dated '.HVPS.cdf'],'nowrite');
binsHVPS = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'bin_mid'));
PSDsHVPS = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'conc_minR'));
netcdf.close(ncid)
PSDsHVPS = permute(PSDsHVPS,[2,1]);

%% Convert distributions to m^-4

PSDs2DC = PSDs2DC.*10^(8);
% CIPre = CIPre.*10^(8);
PSDsHVPS = PSDsHVPS.*10^(8);

%% Extract NCAR Data

importMeta;
combdata = csvread('2011 04 27 Combined Spectrum.csv',1,7);
combdata = combdata(1:12714,:);
HVPS = csvread('2011 04 27 HVPS.csv',1,0);
HVPSdata = HVPS(1:12714,8:end);


combbin = [75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
% combbinmax = [100.0   150.0   200.0   250.0   300.0   350.0   400.0   475.0   550.0   625.0   700.0   800.0   900.0  1000.0  1200.0  1400.0  1600.0  1800.0  2200.0  2600.0  3000.0  3400.0  3800.0  4200.0  4600.0  5000.0  6000.0  7000.0  8000.0  9000.0 10000.0 12000.0 14000.0 16000.0 18000.0 20000.0 25000.0 30000.0];
combbin = combbin .* 10^(-3); % Convert to mm

HVPSbin = [   300.0   500.0   700.0   900.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];  
% HVPSbinmax = [ 400.0   600.0   800.0  1000.0  1200.0  1400.0  1600.0  1800.0  2200.0  2600.0  3000.0  3400.0  3800.0  4200.0  4600.0  5000.0  6000.0  7000.0  8000.0  9000.0 10000.0 12000.0 14000.0 16000.0 18000.0 20000.0 25000.0 30000.0];
HVPSbin = HVPSbin .* 10^(-3); % Convert to mm

HHMMSS = insec2hhmmss(Time);
HHMM = floor(HHMMSS/100);

fprintf('Done.\n');

%% Export to CSV

export = 1;

if export == 1;

    fprintf('Exporting to CSV...');

    HVPSbinhead = { 'Time','HHMMSS','.3mm','.5mm','.7mm','.9mm',' 1.1mm','1.3mm','1.5mm','1.7mm','2.0mm','2.4mm','2.8mm','3.2mm','3.6mm','4.0mm','4.4mm','4.8mm','5.5mm','6.5mm','7.5mm','8.5mm','9.5mm','11mm','13mm','15mm','17mm','19mm','22.5mm','27.5mm'};
    array = cat(2,Time,HHMMSS,PSDsHVPS);
    csvwrite_with_headers('2011 04 27 UIUC HVPS.csv',array,HVPSbinhead);
    
    DChead = {'Time','HHMMSS','.075mm','.125mm','.175mm','.225mm','.275mm','.325mm','.375mm','.4375mm','.5125mm','.5875mm','.6625mm','.75mm','.85mm','.95mm','1.1mm','1.3mm','1.5mm','1.7mm','1.9mm'};
    array = cat(2,Time,HHMMSS,PSDs2DC);
    csvwrite_with_headers('2011 04 27 UIUC 2DC.csv',array,DChead);
    
    CIPhead = {'Time','HHMMSS','.075mm','.125mm','.175mm','.225mm','.275mm','.325mm','.375mm','.4375mm','.5125mm','.5875mm','.6625mm','.75mm','.85mm','.95mm','1.1mm','1.3mm','1.5mm','1.7mm','1.9mm'};
    array = cat(2,Time,HHMMSS,PSDsCIP);
    csvwrite_with_headers('2011 04 27 UIUC CIP.csv',array,CIPhead);
    
    array= cat(2,Time,HHMMSS,HVPSdata);
    csvwrite_with_headers('HVPS NCAR 0427.csv',array,HVPSbinhead);


    fprintf('Done.\n');

end

%% 10-second Averages

NCAR10 = cat(1,combdata,zeros(6,size(combdata,2)));
HVPS10 = cat(1,PSDsHVPS,zeros(6,size(PSDsHVPS,2)));
DC10 = cat(1,PSDs2DC,zeros(6,size(PSDs2DC,2)));

NCAR10avg = zeros(1272,size(combdata,2));
HVPS10avg = zeros(1272,size(PSDsHVPS,2));
DC10avg = zeros(1272,size(PSDs2DC,2));

c = 1;

for i = 0:size(NCAR10avg,1)-1
    for j = 1:size(NCAR10,2)
        NCAR10avg(i+1,j) = mean(NCAR10((i*10)+1:(i*10)+10,j));
    end
    
    for j = 1:size(HVPS10avg,2)
        HVPS10avg(i+1,j) = mean(HVPS10((i*10)+1:(i*10)+10,j));
    end
    
    for j = 1:size(DC10avg,2)
        DC10avg(i+1,j) = mean(DC10((i*10)+1:(i*10)+10,j));
    end
end

%% Manually Combined Spectrum

COMB10avg = cat(2,DC10avg(:,1:14),HVPS10avg(:,5:28));
COMBbin = cat(1,bins2DC(1:14),binsHVPS(5:28));

%% Plotting UIUC vs NCAR 1-Minute Average 1 Time

plot = 0;

%{
    1011: 8357-8416
    1027: 9316-9375
    1118: 12376-12435

%}

if plot == 1;
    
    start = 8357;
    finish = 8416;
    
%     NCARmin = combdata(start:finish,:);
%     HVPSmin = PSDsHVPS(start:finish,:);
%     DCmin = PSDs2DC(start:finish,:);
    
    NCARmin = zeros(size(combbin));
    HVPSmin = zeros(size(binsHVPS));
    DCmin = zeros(size(bins2DC));
    
    for i = 1:size(combbin,2)
        NCARmin(i) = mean(combdata(start:finish,i));
    end
    for i = 1:size(binsHVPS,1)
        HVPSmin(i) = mean(PSDsHVPS(start:finish,i));
    end
    for i = 1:size(bins2DC,1)
        DCmin(i) = mean(PSDs2DC(start:finish,i));
    end
    
    NCARminStairs = permute(NCARmin,[2,1]);
    HVPSminStairs = permute(HVPSmin,[2,1]);
    DCminStairs = permute(DCmin,[2,1]);
    
    figure();
    
    stairs(binsHVPS,HVPSminStairs,'g','LineWidth',0.5);
    hold on
    stairs(bins2DC,DCminStairs,'r','LineWidth',0.5);
    stairs(combbin,NCARminStairs,'k','LineWidth',0.5);
    
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    
    xlabel('Diameter [mm]','FontSize',12);
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);
    
    ylim([10 10^9]);
    
    legend('UIUC HVPS','UIUC 2DC','NCAR Comb');
    
    name = 'NCAR vs UIUC 0427 1011 Minute Average';

    title(name,'FontSize',16);

    set(gca,'fontsize',16)

    saveas(gcf,name,'png');
    
end

%% Plotting UIUC vs NCAR 1-Minute Average

plot = 0;

if plot == 1;

    NCARmin = minavg(combdata);
    HVPSmin = minavg(PSDsHVPS);
    DCmin = minavg(PSDs2DC);
    
    NCARminStairs = permute(NCARmin,[2,1]);
    HVPSminStairs = permute(HVPSmin,[2,1]);
    DCminStairs = permute(DCmin,[2,1]);
    
    figure();
    
    stairs(binsHVPS,HVPSminStairs,'g','LineWidth',0.5);
    hold on
    stairs(bins2DC,DCminStairs,'r','LineWidth',0.5);
    stairs(combbin,NCARminStairs,'k','LineWidth',0.5);
    
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    
    xlabel('Diameter [mm]','FontSize',12);
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);
    
    name = 'NCAR vs UIUC 0427 Minute Averages';

    title(name,'FontSize',16);

    set(gca,'fontsize',16)

    saveas(gcf,name,'png');
    
end
%% Plotting UIUC vs NCAR

plot = 0;

if plot == 1
    
    fprintf('Plotting...');

    figure();

    NCAR10avgStairs = permute(NCAR10avg,[2,1]);
    DC10avgStairs = permute(DC10avg,[2,1]);
    HVPS10avgStairs = permute(HVPS10avg,[2,1]);

    stairs(binsHVPS,HVPS10avgStairs,'g','LineWidth',0.5);
    hold on
    stairs(bins2DC,DC10avgStairs,'r','LineWidth',0.5);
    stairs(combbin,NCAR10avgStairs,'k','LineWidth',0.5);


    set(gca,'xscale','log')
    set(gca,'yscale','log')
    % ylim([1e-8, 1e2])

    xlabel('Diameter [mm]','FontSize',12);
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);

    name = 'NCAR vs UIUC 0427 10s Averages';

    title(name,'FontSize',16);

    set(gca,'fontsize',16)

    saveas(gcf,name,'png');

    fprintf('Done.\n');

end
%% Plotting UIUC vs NCAR with manual combined spectrum

plot = 0;

if plot == 1;

    fprintf('Plotting...');

    figure();

    NCAR10avgStairs = permute(NCAR10avg,[2,1]);
    COMB10avgStairs = permute(COMB10avg,[2,1]);

    stairs(COMBbin,COMB10avgStairs,'r','LineWidth',0.5);
    hold on
    stairs(combbin,NCAR10avgStairs,'b','LineWidth',0.5);


    set(gca,'xscale','log')
    set(gca,'yscale','log')
    % ylim([1e-8, 1e2])

    xlabel('Diameter [mm]','FontSize',12);
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);

    name = 'NCAR vs UIUC Comb 0427 10s Averages';

    title(name,'FontSize',16);

    set(gca,'fontsize',16)

    saveas(gcf,name,'png');

    fprintf('Done.\n');
    
end

%% Plot of index I

plot = 0;

if plot == 1;

    fprintf('Plotting single time...');

%     I = 9328; % 10 27 05
    start = 9316;
    finish = 9735;

    % ndplot2(HVPSbin,HVPSdata(I,:),'NCAR',HVPSbinre,HVPSre(I,:),'Reprocess','NCAR vs Reprocessed HVPS 0427 10h27m05s',0);
    
    combdataStairs = permute(combdata,[2,1]);
    PSDs2DCStairs = permute(PSDs2DC,[2,1]);
    PSDsHVPSStairs = permute(PSDsHVPS,[2,1]);
    
    figure();
    stairs(binsHVPS,PSDsHVPSStairs(:,start:end),'g','LineWidth',0.5);
    hold on
    stairs(bins2DC,PSDs2DCStairs(:,start:end),'r','LineWidth',0.5);
    stairs(combbin,combdataStairs(:,start:end),'k','LineWidth',0.5);
    
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    % ylim([1e-8, 1e2])

    legend('NCAR Comb','UIUC 2DC','UIUC HVPS');

    xlabel('Diameter [mm]','FontSize',12);
    ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);

    name = 'NCAR vs UIUC 0427 1027-1033';

    title(name,'FontSize',16);

    set(gca,'fontsize',16)

    saveas(gcf,name,'png');

    fprintf('Done.\n');

end

%% Plotting

% fprintf('Plotting...');
% 
% figure('visible','off');
% 
% combdata = reshape(combdata,[38,12714]);
% PSDs2DC = reshape(PSDs2DC,[19,12714]);
% PSDsHVPS = reshape(PSDsHVPS,[28,12714]);
% 
% stairs(combbin,combdata(:,Air_Temp>5),'k');
% hold on
% stairs(bins2DC,PSDs2DC(:,Air_Temp>5),'r');
% stairs(binsHVPS,PSDsHVPS(:,Air_Temp>5),'g');
% set(gca,'xscale','log')
% set(gca,'yscale','log')
% 
% legend('NCAR Comb','UIUC 2DC','UIUC HVPS');
% 
% xlabel('Diameter [mm]','FontSize',12);
% ylabel('Raindrop Size Distribution N(D) [m^{-4}]','FontSize',12);
% 
% name = 'NCAR vs UIUC 0427';
% 
% title(name,'FontSize',16);
% 
% set(gca,'fontsize',16)
% 
% saveas(gcf,name,'png');
% 
% fprintf('Done.\n');

%% Stuff

% %% Printing Values
% 
% fprintf('    NCAR Time: %d %d %f\n', HVPS(I,2),HVPS(I,3),HVPS(I,4));
% fprintf('    Reprocess Time: %d\n', HVPStime(I));
% 
% array = [HVPSdata(I,:);HVPSre(I,:)];
% header = {'.3mm','.5mm','.7mm','.9mm',' 1.1mm','1.3mm','1.5mm','1.7mm','2.0mm','2.4mm','2.8mm','3.2mm','3.6mm','4.0mm','4.4mm','4.8mm','5.5mm','6.5mm','7.5mm','8.5mm','9.5mm','11mm','13mm','15mm','17mm','19mm','22.5mm','27.5mm'};
% 
% 
% csvwrite_with_headers('NCAR and Reprocess Data 0427 10h27m12s.csv',array,header)
% 
% %% Flight Averages
% 
% HVPSreavg = zeros(1,size(HVPSre,2));
% for j = 1:size(HVPSre,2)
%     c = 0;
%     sum = 0;
%     for i = 1:size(HVPSre,1)
%         if HVPSre(i,j) ~= 0 && ~isnan(HVPSre(i,j))
%             c = c+1;
%             sum = sum + HVPSre(i,j);
%         end
%         HVPSreavg(j) = sum/c;
%     end
% end
% 
% HVPSavg = zeros(1,size(HVPSdata,2));
% for j = 1:size(HVPSdata,2)
%     c = 0;
%     sum = 0;
%     for i = 1:size(HVPSdata,1)
%         if HVPSdata(i,j) ~= 0 && ~isnan(HVPSdata(i,j))
%             c = c+1;
%             sum = sum + HVPSdata(i,j);
%         end
%         HVPSavg(j) = sum/c;
%     end
% end
% 
% ndplot2(HVPSbin,HVPSavg,'NCAR',HVPSbinre,HVPSreavg,'Reprocessed','NCAR vs Reprocessed HVPS 0427 Flight Average',0);
% 
% 
% 
% %% Average over 10:27-10:33
% 
% start = 9316;
% stop = 9735;
% 
% fprintf('\n    NCAR Time: %d %d %f\n', HVPS(start,2),HVPS(start,3),HVPS(start,4));
% fprintf('    Reprocess Time: %d\n', HVPStime(start));
% fprintf('    NCAR Time: %d %d %f\n', HVPS(stop,2),HVPS(stop,3),HVPS(stop,4));
% fprintf('    Reprocess Time: %d\n', HVPStime(stop));
% 
% HVPSre6 = HVPSre(start:end,:);
% HVPS6 = HVPSdata(start:end,:);
% 
% HVPSre6avg = avg(HVPSre6);
% HVPS6avg = avg(HVPS6);
% 
% ndplot2(HVPSbin,HVPS6avg,'NCAR',HVPSbinre,HVPSre6avg,'Reprocessed','NCAR vs Reprocessed HVPS 0427 1027-1033 Average',0);
% 
% fprintf('Done.\n');
% 
% 
% 
% 
% 
% 

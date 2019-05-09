%% Raindrop Size Distribution Research for Greg McFarquhar
% Casey Pham
%
% Code initially written for all data (Combined Spectrum, 2DC, CIP, HVPS).
% Rewritten for Combined Spectrum only as it contains all needed
% distributions. All data still read in for the time being.

clc
clear
close all force

%% Read data from text files

fprintf('Reading data from text files...');

[mc3e, comb, DC, CIP, HVPS, mc3eAll, combAll, DCAll, CIPAll, HVPSAll, date, prefix, AirTemp, Time, TAS, PresAlt] = data_read();

fprintf('Done.\n');

%% Time

HHMMSS = insec2hhmmss(Time);

%% Bin mid and end points

% Bin mid-points for diameter in microns

combbin = [75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
combbin = combbin .* 10^(-3); % Converting bin sizes to millimeter

DCbin = [    75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  1900.0];
DCbin = DCbin .* 10^(-3); % Converting bin sizes to millimeter

CIPbin = [    75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  1900.0];
CIPbin = CIPbin .* 10^(-3); % Converting bin sizes to millimeter

HVPSbin = [   300.0   500.0   700.0   900.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
HVPSbin = HVPSbin .* 10^(-3); % Converting bin sizes to millimeter
    
% Bin end-points for diameter in microns
combbinend = [50.0   100.0   150.0   200.0   250.0   300.0   350.0   400.0   475.0   550.0   625.0   700.0   800.0   900.0  1000.0  1200.0  1400.0  1600.0  1800.0  2200.0  2600.0  3000.0  3400.0  3800.0  4200.0  4600.0  5000.0  6000.0  7000.0  8000.0  9000.0 10000.0 12000.0 14000.0 16000.0 18000.0 20000.0 25000.0 30000.0];
DCbinend = [50.0   100.0   150.0   200.0   250.0   300.0   350.0   400.0   475.0   550.0   625.0   700.0   800.0   900.0  1000.0  1200.0  1400.0  1600.0  1800.0  2000.0];
CIPbinend = [50.0   100.0   150.0   200.0   250.0   300.0   350.0   400.0   475.0   550.0   625.0   700.0   800.0   900.0  1000.0  1200.0  1400.0  1600.0  1800.0  2000.0];
HVPSbinend = [ 200.0   400.0   600.0   800.0  1000.0  1200.0  1400.0  1600.0  1800.0  2200.0  2600.0  3000.0  3400.0  3800.0  4200.0  4600.0  5000.0  6000.0  7000.0  8000.0  9000.0 10000.0 12000.0 14000.0 16000.0 18000.0 20000.0 25000.0 30000.0];

% Delta D of bins in microns
for i = 1:size(combbin,2)
    combdbin(i) = combbinend(i+1) - combbinend(i);
end
for i = 1:size(DCbin,2)
    DCdbin(i) = DCbinend(i+1) - DCbinend(i);
end
for i = 1:size(CIPbin,2)
    CIPdbin(i) = CIPbinend(i+1) - CIPbinend(i);
end
for i = 1:size(HVPSbinend,2)-1
    HVPSdbin(i) = HVPSbinend(i+1) - HVPSbinend(i);
end

%% Extracting times where raindrops larger than 1cm are present

extract = 0;

if extract == 1
    fprintf('Extracting HVPS large particles...');
    extract_hvps(HVPS, Time, AirTemp, TAS, PresAlt)
    fprintf('Done.\n');
end

%% Log base 10 of size distributions

comblog = log10(comb);
comblog(isinf(comblog)) = 0;
comblog(isnan(comblog)) = 0;

DClog = log10(DC);
DClog(isinf(DClog)) = 0;
DClog(isnan(DClog)) = 0;

CIPlog = log10(CIP);
CIPlog(isinf(CIPlog)) = 0;
CIPlog(isnan(CIPlog)) = 0;

HVPSlog = log10(HVPS);
HVPSlog(isinf(HVPSlog)) = 0;
HVPSlog(isnan(HVPSlog)) = 0;

%% Minute averages

fprintf('Calculating distribution minutely averages...');

combavg = zeros(ceil(size(comb,1)/60), size(combbin,2),15);
DCavg = zeros(ceil(size(DC,1)/60), size(DCbin,2),15);
CIPavg = zeros(ceil(size(CIP,1)/60), size(CIPbin,2),15);
HVPSavg = zeros(ceil(size(HVPS,1)/60), size(HVPSbin,2),15);

combAllavg = zeros(ceil(size(combAll,1)/60), size(combbin,2));
DCAllavg = zeros(ceil(size(DCAll,1)/60), size(DCbin,2));
CIPAllavg = zeros(ceil(size(CIPAll,1)/60), size(CIPbin,2));
HVPSAllavg = zeros(ceil(size(HVPSAll,1)/60), size(HVPSbin,2));

for i = 1:15
    temp = minavg(comb(:,:,i));
    combavg(:,:,i) = temp;
    
    temp = minavg(DC(:,:,i));
    DCavg(:,:,i) = temp;
    
    temp = minavg(CIP(:,:,i));
    CIPavg(:,:,i) = temp;
    
    temp = minavg(HVPS(:,:,i));
    HVPSavg(:,:,i) = temp; 
end

% Combined Arrays

temp = minavg(combAll(:,:));
combAllavg(:,:) = temp;

temp = minavg(DCAll(:,:));
DCAllavg(:,:) = temp;

temp = minavg(CIPAll(:,:));
CIPAllavg(:,:) = temp;

temp = minavg(HVPSAll(:,:));
HVPSAllavg(:,:) = temp;

% [comb501avg] = minavg(comb(:,:,4));

fprintf('Done.\n');

%% Rainrate for raw data, not averaged

fprintf('Calculating rainrate...');

% [combrate501] = rainrate(comb(:,:,4),1);

combrate = zeros(size(comb,1),1);
DCrate = zeros(size(DC,1),1);
CIPrate = zeros(size(CIP,1),1);
HVPSrate = zeros(size(HVPS,1),1);

combAllrate = zeros(size(combAll,1),1);
DCAllrate = zeros(size(DCAll,1),1);
CIPAllrate = zeros(size(CIPAll,1),1);
HVPSAllrate = zeros(size(HVPSAll,1),1);

for i = 1:15
    combrate(:,:,i) = rainrate(comb(:,:,i),1);
    DCrate(:,:,i) = rainrate(DC(:,:,i),2);
    CIPrate(:,:,i) = rainrate(CIP(:,:,i),3);
    HVPSrate(:,:,i) = rainrate(HVPS(:,:,i),4);
end

combAllrate(:,:,i) = rainrate(combAll(:,:),1);
DCAllrate(:,:,i) = rainrate(DCAll(:,:),2);
CIPAllrate(:,:,i) = rainrate(CIPAll(:,:),3);
HVPSAllrate(:,:,i) = rainrate(HVPSAll(:,:),4);

fprintf('Done.\n');

%% Rainrates for minute averages

% [combavgrate501] = rainrate(comb501avg,1);

%% Organizing Data corresponding to rainrates

fprintf('Organizing data corresponding to rainrates...');

combrateorg = zeros(size(combrate,1), size(comb,2),5,15);
DCrateorg = zeros(size(DCrate,1), size(DC,2),5,15);
CIPrateorg = zeros(size(CIPrate,1), size(CIP,2),5,15);
HVPSrateorg = zeros(size(HVPSrate,1), size(HVPS,2),5,15);

combAllrateorg = zeros(size(combAllrate,1), size(combAll,2),5);
DCAllrateorg = zeros(size(DCAllrate,1), size(DCAll,2),5);
CIPAllrateorg = zeros(size(CIPAllrate,1), size(CIPAll,2),5);
HVPSAllrateorg = zeros(size(HVPSAllrate,1), size(HVPSAll,2),5);

combrateTestudDist = zeros(size(combrate,1), size(comb,2),3,15);
DCrateTestudDist = zeros(size(DCrate,1), size(DC,2),3,15);
CIPrateTestudDist = zeros(size(CIPrate,1), size(CIP,2),3,15);
HVPSrateTestudDist = zeros(size(HVPSrate,1), size(HVPS,2),3,15);

combrateTestud = zeros(size(combrate,1), size(combrate,2),3,15);
DCrateTestud = zeros(size(DCrate,1), size(DCrate,2),3,15);
CIPrateTestud = zeros(size(CIPrate,1), size(CIPrate,2),3,15);
HVPSrateTestud = zeros(size(HVPSrate,1), size(HVPSrate,2),3,15);

%{
    Index Assignments, 4th Dimension:
    1: 0-1 mm/hr
    2: 1-5 mm/hr
    3: 5-25 mm/hr
    4: 25-100 mm/hr
    5: 100+ mm/hr
%}

for i = 1:15
    
    [combrateorg(:,:,1,i), combrateorg(:,:,2,i), combrateorg(:,:,3,i), combrateorg(:,:,4,i), combrateorg(:,:,5,i)]...
        = organize(combrate(:,:,i),comb(:,:,i));
    
    [DCrateorg(:,:,1,i), DCrateorg(:,:,2,i) ,DCrateorg(:,:,3,i), DCrateorg(:,:,4,i), DCrateorg(:,:,5,i)]...
        = organize(DCrate,DC(:,:,i));

    [CIPrateorg(:,:,1,i), CIPrateorg(:,:,2,i), CIPrateorg(:,:,3,i), CIPrateorg(:,:,4,i), CIPrateorg(:,:,5,i)]...
        = organize(CIPrate,CIP(:,:,i));

    [HVPSrateorg(:,:,1,i), HVPSrateorg(:,:,2,i), HVPSrateorg(:,:,3,i), HVPSrateorg(:,:,4,i), HVPSrateorg(:,:,5,i)]...
        = organize(HVPSrate,HVPS(:,:,i));
    
    % Testud Rainrate classification (convective)
    [combrateTestudDist(:,:,1,i), combrateTestudDist(:,:,2,i), combrateTestudDist(:,:,3,i)]...
        = organizeTestud(combrate(:,:,i),comb(:,:,i));
    
    [DCrateTestudDist(:,:,1,i), DCrateTestudDist(:,:,2,i) ,DCrateTestudDist(:,:,3,i)]...
        = organizeTestud(DCrate,DC(:,:,i));

    [CIPrateTestudDist(:,:,1,i), CIPrateTestudDist(:,:,2,i), CIPrateTestudDist(:,:,3,i)]...
        = organizeTestud(CIPrate,CIP(:,:,i));

    [HVPSrateTestudDist(:,:,1,i), HVPSrateTestudDist(:,:,2,i), HVPSrateTestudDist(:,:,3,i)]...
        = organizeTestud(HVPSrate,HVPS(:,:,i));
    
    % Organizing rainrate by rainrate
    [combrateTestud(:,:,1,i), combrateTestud(:,:,2,i), combrateTestud(:,:,3,i)]...
        = organizeTestud(combrate(:,:,i),combrate(:,:,i));
    
    [DCrateTestud(:,:,1,i), DCrateTestud(:,:,2,i) ,DCrateTestud(:,:,3,i)]...
        = organizeTestud(DCrate,DCrate(:,:,i));

    [CIPrateTestud(:,:,1,i), CIPrateTestud(:,:,2,i), CIPrateTestud(:,:,3,i)]...
        = organizeTestud(CIPrate,CIPrate(:,:,i));

    [HVPSrateTestud(:,:,1,i), HVPSrateTestud(:,:,2,i), HVPSrateTestud(:,:,3,i)]...
        = organizeTestud(HVPSrate,HVPSrate(:,:,i));


end

[combAllrateorg(:,:,1), combAllrateorg(:,:,2), combAllrateorg(:,:,3), combAllrateorg(:,:,4), combAllrateorg(:,:,5)]...
    = organize(combAllrate(:,:,i),combAll(:,:));
    
[DCAllrateorg(:,:,1), DCAllrateorg(:,:,2) ,DCAllrateorg(:,:,3), DCAllrateorg(:,:,4), DCAllrateorg(:,:,5)]...
    = organize(DCAllrate,DCAll(:,:));

[CIPAllrateorg(:,:,1), CIPAllrateorg(:,:,2), CIPAllrateorg(:,:,3), CIPAllrateorg(:,:,4), CIPAllrateorg(:,:,5)]...
    = organize(CIPAllrate,CIPAll(:,:));

[HVPSAllrateorg(:,:,1), HVPSAllrateorg(:,:,2), HVPSAllrateorg(:,:,3), HVPSAllrateorg(:,:,4), HVPSAllrateorg(:,:,5)]...
    = organize(HVPSAllrate,HVPSAll(:,:));

fprintf('Done.\n');

%% Averaging by rainrate

fprintf('Averaging by rainrate...');

% 1 x bin sizes x rates x dates

combrateavg = zeros(1,size(combbin,2),5,15);
DCrateavg = zeros(1,size(DCbin,2),5,15);
CIPrateavg = zeros(1,size(CIPbin,2),5,15);
HVPSrateavg = zeros(1,size(HVPSbin,2),5,15);

combAllrateavg = zeros(1,size(combbin,2),5);
DCAllrateavg = zeros(1,size(DCbin,2),5);
CIPAllrateavg = zeros(1,size(CIPbin,2),5);
HVPSAllrateavg = zeros(1,size(HVPSbin,2),5);

for i = 1:5
    for j = 1:15
        temp = avg(combrateorg(:,:,i,j));
        combrateavg(:,:,i,j) = temp;
    
        temp = avg(DCrateorg(:,:,i,j));
        DCrateavg(:,:,i,j) = temp;
    
        temp = avg(CIPrateorg(:,:,i,j));
        CIPrateavg(:,:,i,j) = temp;
    
        temp = avg(HVPSrateorg(:,:,i,j));
        HVPSrateavg(:,:,i,j) = temp;
    end
    
    combAllrateavg(:,:,i) = avg(combAllrateorg(:,:,i));
    DCAllrateavg(:,:,i) = avg(DCAllrateorg(:,:,i));
    CIPAllrateavg(:,:,i) = avg(CIPAllrateorg(:,:,i));
    HVPSAllrateavg(:,:,i) = avg(HVPSAllrateorg(:,:,i));
end

fprintf('Done.\n');

%% Converting from N(D) to N(logD)

fprintf('Converting from N(D) to N(logD)...');

combrateavglog = zeros(size(combrateavg));
DCrateavglog = zeros(size(DCrateavg));
CIPrateavglog = zeros(size(CIPrateavg));
HVPSrateavglog = zeros(size(HVPSrateavg));

combAllrateavglog = zeros(size(combAllrateavg));
DCAllrateavglog = zeros(size(DCAllrateavg));
CIPAllrateavglog = zeros(size(CIPAllrateavg));
HVPSAllrateavglog = zeros(size(HVPSAllrateavg));

for i = 1:5
    for j = 1:15
        combrateavglog(:,:,i,j) = nlogd(combrateavg(:,:,i,j),combbinend);
        DCrateavglog(:,:,i,j) = nlogd(DCrateavg(:,:,i,j),DCbinend);
        CIPrateavglog(:,:,i,j) = nlogd(CIPrateavg(:,:,i,j),CIPbinend);
        HVPSrateavglog(:,:,i,j) = nlogd(HVPSrateavg(:,:,i,j),HVPSbinend);
    end
    combAllrateavglog(:,:,i) = nlogd(combAllrateavg(:,:,i),combbinend);
    DCAllrateavglog(:,:,i) = nlogd(DCAllrateavg(:,:,i),DCbinend);
    CIPAllrateavglog(:,:,i) = nlogd(CIPAllrateavg(:,:,i),CIPbinend);
    HVPSAllrateavglog(:,:,i) = nlogd(HVPSAllrateavg(:,:,i),HVPSbinend);
end

combavglog = zeros(size(combavg));
DCavglog = zeros(size(DCavg));
CIPavglog = zeros(size(CIPavg));
HVPSavglog = zeros(size(HVPSavg));

for i = 1:15
    combavglog(:,:,i) = nlogd(combavg(:,:,i),combbinend);
    DCavglog(:,:,i) = nlogd(DCavg(:,:,i),DCbinend);
    CIPavglog(:,:,i) = nlogd(CIPavg(:,:,i),CIPbinend);
    HVPSavglog(:,:,i) = nlogd(HVPSavg(:,:,i),HVPSbinend);
end

combAllavglog = nlogd(combAllavg,combbinend);
DCAllavglog = nlogd(DCAllavg,DCbinend);
CIPAllavglog = nlogd(CIPAllavg,CIPbinend);
HVPSAllavglog = nlogd(HVPSAllavg,HVPSbinend);

fprintf('Done.\n');

%% Export to CSV

export = 0;

if export == 1
    fprintf('Exporting rainrate and distributions to csv...');
    export_rainrate(comb, combrate, date, Time, AirTemp, TAS, PresAlt);
    fprintf('Done.\n');
end

%% NORMALIZATION

fprintf('\nNormalizaion\n');

fprintf('    Normalizing...');

[combNorm, combNormDiam] = normalize(comb, combbin, combdbin);

combNormlog = log10(combNorm);

for k = 1:15
    for j = 1:size(combNormlog,2)
        for i = 1:size(combNormlog,1)
            if isinf(combNormlog(i,j,k))
                combNormlog(i,j,k) = NaN;
            end
        end
    end
end

fprintf('Done.\n');

% Organizing corresponding to rainrate

fprintf('    Organizing data corresponding to rainrates...');

combNormRate = zeros(size(combNorm,1),size(combNorm,2),5,size(combNorm,3));
combNormRatelog = NaN(size(combNormlog,1),size(combNormlog,2),5,size(combNormlog,3));
combNormDiamRate = zeros(size(combNormDiam,1),size(combNormDiam,2),5,size(combNormDiam,3));

for i = 1:15
%     fprintf('%d..',i);
    [combNormRate(:,:,1,i), combNormRate(:,:,2,i), combNormRate(:,:,3,i), combNormRate(:,:,4,i), combNormRate(:,:,5,i)]...
        = organize(combrate(:,:,i),combNorm(:,:,i));
    
    [combNormRatelog(:,:,1,i), combNormRatelog(:,:,2,i), combNormRatelog(:,:,3,i), combNormRatelog(:,:,4,i), combNormRatelog(:,:,5,i)]...
        = organize(combrate(:,:,i),combNormlog(:,:,i));
    
    [combNormDiamRate(:,:,1,i), combNormDiamRate(:,:,2,i), combNormDiamRate(:,:,3,i), combNormDiamRate(:,:,4,i), combNormDiamRate(:,:,5,i)]...
        = organize(combrate(:,:,i),combNormDiam(:,:,i));
end

fprintf('Done.\n');

% Liquid Water Content

fprintf('    Calculating liquid water content...');

combLWC = LWC(comb,combbin,combdbin);

fprintf('Done.\n');

% Mean Diameter

fprintf('    Calculating mean volume diameter...');

combDm = mean_diameter(comb, combbin, combdbin);

fprintf('Done.\n');

% Scaling Parameter No*

fprintf('    Calculating scaling parameter...');

combNo = scale(comb, combbin, combdbin);

combNolog = log10(combNo);

combNolog(isinf(combNolog)) = 0;
combNolog(isnan(combNolog)) = 0;

fprintf('Done.\n');

%% Export Normalization

% Exporting to CSV

export = 0;

if export == 1;
    
    fprintf('    Exporting to CSV...');
    
    combNormcsv = zeros(size(combNorm,1),size(combNorm,2));
    for i = 1:15
        combNormcsv(:,:,i) = combNorm(:,:,i);
    end
    
    combLWCcsv = zeros(size(combLWC,1),15);
    for i = 1:15
        combLWCcsv(:,i) = combLWC(:,1,i);
    end
    
    combDmcsv = zeros(size(combDm,1),15);
    for i = 1:15
        combDmcsv(:,i) = combDm(:,1,i);
    end

    combNocsv = zeros(size(combNo,1),15);
    for i = 1:15
        combNocsv(:,i) = combNo(:,1,i);
    end

    datehead = {'2011 04 22';'2011 04 25';'2011 04 27';'2011 05 01';'2011 05 10';'2011 05 11';...
        '2011 05 18';'2011 05 20';'2011 05 23';'2011 05 24';'2011 05 27';'2011 05 30';...
        '2011 06 01-1';'2011 06 01-2';'2011 06 02'};

    csvwrite_with_headers('Combined Spectrum Liquid Water Content.csv',combLWCcsv,datehead);
    csvwrite_with_headers('Combined Spectrum Mean Volume Diameter.csv',combDmcsv,datehead);
    csvwrite_with_headers('Combined Spectrum Scaling Parameter.csv',combNocsv,datehead);
    
    for i = 1:15
        
       name = strcat(datehead{i},' Combined Spectrum Normalized Size Distribution.csv');
       
       array = cat(2,Time(:,i),HHMMSS(:,i),combLWC(:,1,i),combDm(:,1,i),combNo(:,1,i),combNolog(:,1,i),combNorm(:,:,i));
       
       header = {'Time','HHMMSS','LWC','Dm','No*','log(No*)','.075mm','.125mm','.175mm','.225mm','.275mm','.325mm','.375mm','.4375mm','.5125mm','.5875mm','.6625mm','.75mm','.85mm','.95mm','1.1mm','1.3mm','1.5mm','1.7mm','2.0mm','2.4mm','2.8mm','3.2mm','3.6mm','4.0mm','4.4mm','4.8mm','5.5mm','6.5mm','7.5mm','8.5mm','9.5mm','11mm','13mm','15mm','17mm','19mm','22.5mm','27.5mm'};
       
       csvwrite_with_headers(name,array,header);
        
    end
    
    fprintf('Done.\n');
end

fprintf('Finished Normalization\n');

%% EXPORT DATA TO CSV

% export = 0;
% 
% if export == 1;
%     fprintf('Exporting data to csv...');
%     
%     for k = 1:15
%         
%         array = cat(2,Time(:,k);HHMMSS(:,k);AirTemp(:,k),PresAlt(:,k));
%         
%     end
%     
% end

%% STATISTICAL ANALYSIS

fprintf('\nStatistical Analysis\n');

% Organizing variables corresponding to Testud rainrates

fprintf('    Organizing data corresponding to Testud rainrates...');

combNoRateTestud = zeros(size(combNo,1),size(combNo,2),3,size(combNo,3));
combNoRateTestudlog = zeros(size(combNolog,1),size(combNolog,2),3,size(combNolog,3));
combDmRateTestud = zeros(size(combDm,1),size(combDm,2),3,size(combDm,3));

for k = 1:15
    [combNoRateTestud(:,:,1,i), combNoRateTestud(:,:,2,i), combNoRateTestud(:,:,3,i)]...
        = organizeTestud(combrate(:,:,i),combNo(:,:,i));
    
    [combNoRateTestudlog(:,:,1,i), combNoRateTestudlog(:,:,2,i), combNoRateTestudlog(:,:,3,i)]...
        = organizeTestud(combrate(:,:,i),combNolog(:,:,i));
    
    [combDmRateTestud(:,:,1,i), combDmRateTestud(:,:,2,i), combDmRateTestud(:,:,3,i)]...
        = organizeTestud(combrate(:,:,i),combDm(:,:,i));
end

fprintf('Done.\n');

fprintf('    Calculating Statistics...');

% Mean

NoMean = zeros(3,1,15);
NoSTD = zeros(3,1,15);
RMean = zeros(3,1,15);
RSTD = zeros(3,1,15);
DmMean = zeros(3,1,15);
DmSTD = zeros(3,1,15);
uMean = zeros(3,1,15);
uSTD = zeros(3,1,15);

for k = 1:15
    for i = 1:3

        NoMean(i,1,k) = mean(combNoRateTestudlog(:,:,i,k));
        NoSTD(i,1,k) = std(combNoRateTestudlog(:,:,i,k));
        
        RMean(i,1,k) = mean(combrateTestud(:,:,i,k));
        RSTD(i,1,k) = std(combrateTestud(:,:,i,k));
        
        DmMean(i,1,k) = mean(combDmRateTestud(:,:,i,k));
        DmSTD(i,1,k) = std(combDmRateTestud(:,:,i,k));
        

    end

end

fprintf('Done.\n');

export = 0;

if export == 1
    
    fprintf('    Exporting Statistics...');
    
    for k = 1:15

        header = {'Rain Category','log(No*) Mean','log(No*) Std dev','R Mean','R Std dev','Dm Mean','Dm Std dev'};

        R = [010, 1030, 30100];
        R = permute(R,[2,1]);

        array = cat(2,R,NoMean(:,1,k),NoSTD(:,1,k),RMean(:,1,k),RSTD(:,1,k),DmMean(:,1,k),DmSTD(:,1,k));
        
        name = ['Statistical Characteristics' date{k} '.csv'];
        
        csvwrite_with_headers(name,array,header);

    end
    
    fprintf('Done.\n');

end

plot = 0;

if plot == 1;

    fprintf('    Plotting Statistics...');

    for k = 1:15

        figure('visible','off');

        % Histogram of No*
        subplot(4,2,1);
        hist(combNormlog(:,:,k));
        xlabel('log_{10}(N_{0}^*)');
        ylabel('Counts');

        % Histogram of Dm
        subplot(4,2,2);
        hist(combDm(:,:,k));
        xlabel('D_{m} (mm)');
        ylabel('Counts');

        % Histogram of Rainrate
        subplot(4,2,3);
        hist(combrate(:,:,k));
        xlabel('Rainrate [mm/hr]');
        ylabel('Counts');

        % Histogram of u
        subplot(4,2,4);


        % Scatter of D/Dm x log(N(D)/No*)
        subplot(4,2,5);
        plot(combNormDiam(:,:,k),combNormlog(:,:,k));
        xlabel('Diamater/D_m');
        ylabel('log_{10}(N(D)/N_{0}^*)');

        % Scatter of Diamater
        subplot(4,2,6);
        plot(combbin,comblog(:,:,k));
        xlabel('Diamater [mm]');
        ylabel('log_{10}(N(D))');

        % Average and standard deviation of log(N(D)/No*)
        subplot(4,2,7);


        name = ['Statistics Plots ' date{k}];

    %     set(gca,'fontsize',20);

        saveas(gcf,name,'png');

    end

    fprintf('Done.\n');
    
end
%% PLOTTING 

pltnorm = 0;
plt = 0;

if pltnorm == 1

%% Normalized Distributions

    fprintf('Plotting normalized distributions...');
    
    path = 'Normalized Size Distribution logX';
    
    for k = 1:15
        
        name = strcat(path,date(k));
        plotNorm(combNormDiam(:,:,k), combNormlog(:,:,k), name{1});
        
%         name = strcat(path,' Binned ',date(k));
%         plotNormBin(combbin, combNormlog(:,:,k), name{1});
        
    end
    
    fprintf('Done.\n');
end

if pltnorm == 1

%% Normalized Distribution with Rainrate

    
    fprintf('Plotting normalized distributions with rainrate...\n');
    
    %% Averaged over rain rate
    
    fprintf('    Averaged over rain rate...');
    
    % 1 x bin sizes x rates x dates
    
    combNormRateAvg = zeros(1,38,5,15);

    for k = 1:15 %Date
        for l = 1:5 %Rain Rate
            for j = 1:38 %Column
%                 c = 0;
%                 sum = 0;
%                 for i = 1:size(14925) %Row
%                     if ~isnan(combNormRatelog(i,j,l,k))
%                         c = c+1;
%                         sum = sum + combNormRatelog(i,j,l,k);
%                     end
%                 end
%                 combNormRateAvg(1,j,l,k) = sum/c;
                
                combNormRateAvg(1,j,l,k) = avg(combNormRatelog(:,j,l,k));
            end
        end
    end

    for k = 1:15

        figure('visible','off');

        semilogx(combbin,combNormRateAvg(1,:,1,k),'b-o','MarkerSize',2,'MarkerFaceColor','b');
        
        xlim([.05 50]);
        ylim([-5 4]);

        hold on

        semilogx(combbin,combNormRateAvg(1,:,2,k),'r-o','MarkerSize',2,'MarkerFaceColor','r');
        semilogx(combbin,combNormRateAvg(1,:,3,k),'g-o','MarkerSize',2,'MarkerFaceColor','g');
        semilogx(combbin,combNormRateAvg(1,:,4,k),'c-o','MarkerSize',2,'MarkerFaceColor','c');
        semilogx(combbin,combNormRateAvg(1,:,5,k),'m-o','MarkerSize',2,'MarkerFaceColor','m');

        legend('0-1mm/hr','1-5mm/hr','5-25mm/hr','25-100mm/hr','>100mm/hr');

        xlabel('Diameter [mm]','FontSize',20);

        ylabel('log_{10}(N(D)/N_{0}*)','FontSize',20);

        name = strcat('Normalized Size Distribution Rain Rate ',date(k));
        title(name{1},'FontSize',20);

        set(gca,'fontsize',20);

        saveas(gcf,name{1},'png');

    end
    
    
    
    fprintf('Done.\n');
    
    %% Averaged over rain rate D/Dm
    
    fprintf('    Averaging over rain rate D/Dm...');
    
    combrateavgNorm = NaN(1,38,5,15);
    combrateavgDm = NaN(1,38,5,15);
    
    for k = 1:15
        for l = 1:5
            temp = reshape(combrateavg(:,:,l,k),[1,38,1]);
            [combrateavgNorm(:,:,l,k), combrateavgDm(:,:,l,k)] = normalize(temp,combbin,combdbin);
        end
    end
    
    
    combrateavgNormlog = log10(combrateavgNorm);

    for k = 1:15
        for j = 1:size(combrateavgNormlog,2)
            for i = 1:size(combrateavgNormlog,1)
                if isinf(combrateavgNormlog(i,j,k))
                    combrateavgNormlog(i,j,k) = NaN;
                end
            end
        end
    end
    for k = 1:15
        
        figure('visible','off');

        semilogx(combrateavgDm(:,:,1,k),combrateavgNormlog(1,:,1,k),'b-o','MarkerSize',2,'MarkerFaceColor','b');
        
        xlim([0.01 100]);
        ylim([-3 4]);

        hold on

        semilogx(combrateavgDm(:,:,1,k),combrateavgNormlog(1,:,2,k),'r-o','MarkerSize',2,'MarkerFaceColor','r');
        semilogx(combrateavgDm(:,:,1,k),combrateavgNormlog(1,:,3,k),'g-o','MarkerSize',2,'MarkerFaceColor','g');
        semilogx(combrateavgDm(:,:,1,k),combrateavgNormlog(1,:,4,k),'c-o','MarkerSize',2,'MarkerFaceColor','c');
        semilogx(combrateavgDm(:,:,1,k),combrateavgNormlog(1,:,5,k),'m-o','MarkerSize',2,'MarkerFaceColor','m');

        legend('0-1mm/hr','1-5mm/hr','5-25mm/hr','25-100mm/hr','>100mm/hr');

        xlabel('D/Dm','FontSize',20);

        ylabel('log_{10}(N(D)/N_{0}*)','FontSize',20);

        name = strcat('Normalized Size Distribution Rain Rate',date(k));
        title(name{1},'FontSize',20);
        
        name = strcat('Normalized Size Distribution Rain Rate All DDm logX',date(k));

        set(gca,'fontsize',20);

        saveas(gcf,name{1},'png');
        
        
    end
    
    
    fprintf('Done.\n');
    
    %% Individual rain rate, binned
    
    fprintf('    Individual rain rate, binned...');
    
    rate = {' 0-1mmhr-1',' 1-5mmhr-1',' 5-25mmhr-1',' 25-100mmhr-1',' 100mmhr-1'};
    
    for k = 1:15
        for l = 1:5
            
            name = strcat('Normalized Size Distribution Rain Rate Binned ',date(k),rate(l));
            
            figure('visible','off');
            semilogx(combbin,combNormRatelog(:,:,l,k),'b-o','MarkerSize',2,'MarkerFaceColor','b');
            xlim([.05 50]);
            ylim([-5 4]);
            xlabel('Diameter [mm]','FontSize',12);
            ylabel('log_{10}(N(D)/N_{0}*)');
            title(name{1},'FontSize',16);
            set(gca,'fontsize',16);
            saveas(gcf,name{1},'png');
            
        end
    end
    
    fprintf('Done.\n');
    
    %% Individual rain rate, D/Dm
    
    fprintf('    Individual rain rate, D/Dm...');
    
    path = 'Normalized Size Distribution Rain Rate DDm ';
    
    for k = 1:15
        for l = 1:5
            
            name = strcat(path,date(k),rate(l));
            plotNorm(combNormDiamRate(:,:,l,k), combNormRatelog(:,:,l,k), name{1});
            
        end
    end
    
    fprintf('Done,\n');
    
end

%% Size Distributions

if plt == 1

    fprintf('Plotting...\n');

    %% All flights, single probe per plot

    fprintf('    All flights single probe per plot...');

    % Rainrate

    name = strcat(prefix(1),'Combined Spectrum All Flights');   % Rainrate N(D)
    rainrateplot(combbin, combAllrateavg(:,:,1),combAllrateavg(:,:,2),combAllrateavg(:,:,3),combAllrateavg(:,:,4),...
        combAllrateavg(:,:,5), name{1},0);

    name = strcat(prefix(2),'Combined Spectrum All Flights');   %  Rainrate N(logD)
    rainrateplot(combbin, combAllrateavglog(:,:,1),combAllrateavglog(:,:,2),combAllrateavglog(:,:,3),combAllrateavglog(:,:,4),...
        combAllrateavglog(:,:,5), name{1},1);

    % N(D) Plots

    name = strcat(prefix(3),'Combined Spectrum All Flights');
    ndplot(combbin, combAllavg, name{1}, 0);

    name = strcat(prefix(3),'2DC All Flights');
    ndplot(DCbin, DCAllavg, name{1}, 0);

    name = strcat(prefix(3),'CIP All Flights');
    ndplot(CIPbin, CIPAllavg, name{1}, 0);

    name = strcat(prefix(3),'HVPS All Flights');
    ndplot(HVPSbin, HVPSAllavg, name{1}, 0);

    % N(logD) Plots

    name = strcat(prefix(4),'Combined Spectrum All Flights');
    ndplot(combbin, combAllavglog, name{1}, 1);

    name = strcat(prefix(4),'2DC All Flights');
    ndplot(DCbin, DCAllavglog, name{1}, 1);

    name = strcat(prefix(4),'CIP All Flights');
    ndplot(CIPbin, CIPAllavglog, name{1}, 1);

    name = strcat(prefix(4),'HVPS All Flights');
    ndplot(HVPSbin, HVPSAllavglog, name{1}, 1);

    fprintf('Done.\n');

    %% Rainrate Plots per Flight per Probe

    fprintf('    Rainrate per flight per probe...');

    % N(D)

    for i = 1:15
        name = strcat(prefix(1),'Combined Spectrum ',date(i));
        rainrateplot(combbin,combrateavg(:,:,1,i),combrateavg(:,:,2,i),combrateavg(:,:,3,i),combrateavg(:,:,4,i),combrateavg(:,:,5,i),...
            name{1},0);
    end


    % N(logD)

    for i = 1:15
        name = strcat(prefix(2),'Combined Spectrum ',date(i));
        rainrateplot(combbin,combrateavglog(:,:,1,i),combrateavglog(:,:,2,i),combrateavglog(:,:,3,i),combrateavglog(:,:,4,i),...
            combrateavglog(:,:,5,i),name{1},1);
    end

    fprintf(' Done.\n');

    %% Distribution Plots per Flight per Probe

    fprintf('    Distributions...');

    % N(D)

    for i = 1:15
        name = strcat(prefix(3),'Combined Spectrum',date(i));
        ndplot(combbin,combavg(:,:,i),name{1},0);

        name = strcat(prefix(3),'2DC Probe',date(i));
        ndplot(DCbin,DCavg(:,:,i),name{1},0);

        name = strcat(prefix(3),'CIP Probe',date(i));
        ndplot(CIPbin,CIPavg(:,:,i),name{1},0);

        name = strcat(prefix(3),'HVPS Probe',date(i));
        ndplot(HVPSbin,HVPSavg(:,:,i),name{1},0);
    end


    % N(logD)

    for i = 1:15
        name = strcat(prefix(4),'Combined Spectrum',date(i));
        ndplot(combbin,combavglog(:,:,i),name{1},1);

        name = strcat(prefix(4),'2DC Probe',date(i));
        ndplot(DCbin,DCavglog(:,:,i),name{1},1);

        name = strcat(prefix(4),'CIP Probe',date(i));
        ndplot(CIPbin,CIPavglog(:,:,i),name{1},1);

        name = strcat(prefix(4),'HVPS Probe',date(i));
        ndplot(HVPSbin,HVPSavglog(:,:,i),name{1},1);
    end

    fprintf(' Done.\n');

end

fprintf('\nFinished Running.\n');

%% Troubleshooting

trbl = 0;

if trbl == 1

    fprintf('Running... ');

    for i = 1:15
            name = strcat(' Combined Spectrum',date(i));
            ndplot(combbin,combavglog(:,:,i),name{1},1);
    end

    fprintf('Done.\n');

end
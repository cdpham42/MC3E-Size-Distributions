%% Load NCAR Data

clc
clear
close all force

importMeta;

dated = '0427';
% eval(['load meta' dated '.mat']);
% eval(['load PSDs' dated 'NCAR.mat']);
% load binsNCAR.mat

PSDNCAR = csvread('2011 04 27 Combined Spectrum.csv',1,7);
binsNCAR = [75.0   125.0   175.0   225.0   275.0   325.0   375.0   437.5   512.5   587.5   662.5   750.0   850.0   950.0  1100.0  1300.0  1500.0  1700.0  2000.0  2400.0  2800.0  3200.0  3600.0  4000.0  4400.0  4800.0  5500.0  6500.0  7500.0  8500.0  9500.0 11000.0 13000.0 15000.0 17000.0 19000.0 22500.0 27500.0];
% binsNCAR = binsNCAR*10^(-3);
% Air_Temp = csvread('2011 04 27 Combined Spectrum.csv',2,5,[2,5,12715,5]);


%% Load UIUC Data
ncid=netcdf.open(['sdist.2011' dated '.2DC.cdf'],'nowrite');
bins2DC = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'bin_mid'));
PSDs2DC = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'conc_minR'));
netcdf.close(ncid)

ncid=netcdf.open(['sdist.2011' dated '.HVPS.cdf'],'nowrite');
binsHVPS = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'bin_mid'));
PSDsHVPS = netcdf.getVar(ncid,netcdf.inqVarID(ncid,'conc_minR'));
netcdf.close(ncid)

%% Choose PSDs according to temperature, and average if possible
%plot(Air_Temp)
PSDNCAR(PSDNCAR>1e12)=NaN;

PSDs2DC10 = aven(PSDs2DC, 60);
PSDsHVPS10 = aven(PSDsHVPS, 60);
PSDNCAR10 = aven(PSDNCAR', 60);
Air_Temp10 = aven(Air_Temp', 60);

%%
figure
stairs(bins2DC,PSDs2DC10(:,Air_Temp10>=5),'r')
hold on
stairs(binsHVPS,PSDsHVPS10(:,Air_Temp10>=5),'g')
stairs(binsNCAR'/1000,PSDNCAR10(:,Air_Temp10>=5)/100000000,'k')
set(gca,'xscale','log')
set(gca,'yscale','log')
ylim([1e-8, 1e2])
xlabel('Diameter [mm]','fontsize',12)
ylabel('Number Concentration [cm^{-4}]','fontsize',12)

name = 'Wei NCAR vs UIUC 0427 Minute Average';

title(name);

set(gca,'fontsize',16)

saveas(gcf,name,'png');

%% Plot Profile

POS_Alt(POS_Alt>10000)=NaN;
HGTobs = 0:0.01:6;

meanPSDs1=zeros(38,601);
meanPSDs2=zeros(28,601);
meanPSDs3=zeros(38,601);
PSDNCAR1 = PSDNCAR';

PSDsALL = [PSDs2DC(1:14,:); PSDsHVPS(5:end,:)];

for i=2:length(HGTobs)
   meanPSDs1(:,i) = (nanmean(PSDsALL(:,and(POS_Alt<HGTobs(i)*1000, POS_Alt>HGTobs(i-1)*1000)), 2)/10)'; 
   meanPSDs2(:,i) = (nanmean(PSDsHVPS(:,and(POS_Alt<HGTobs(i)*1000, POS_Alt>HGTobs(i-1)*1000)), 2)/10)'; 
   meanPSDs3(:,i) = (nanmean(PSDNCAR1(:,and(POS_Alt<HGTobs(i)*1000, POS_Alt>HGTobs(i-1)*1000))/1e8, 2)/10)'; 
end

x = input('Break');

%% Plot PSD Profiles
fontsizef = 20;
figure
subplot(1,2,1)
contourf(binsNCAR,HGTobs,log10(meanPSDs1)',-12:0.5:0,'LineColor','none')
ylabel('Height [km]')
set(gca,'xscale','log')
title('UIUC')
ax = gca;
ax.XTick = [1 10 100 1000 10000 100000];
c=colorbar('east','ylim',[-12, 0],'YTick',[-12,-10,-8,-6,-4,-2,0,2],'YTickLabel',{'1e-12','1e-10','1e-8','1e-6','1e-4','1e-2','1','1e2'});
c.Label.String = 'N(D) [L^{-1} \mum^{-1}]';
set(gca,'FontSize',fontsizef)
set(findall(gcf,'type','text'),'FontSize',fontsizef)
set(gca,'ylim',[0, 7])
set(gca,'xlim',[50, 100000])

subplot(1,2,2)
contourf(binsNCAR,HGTobs,log10(meanPSDs3)',-12:0.5:0,'LineColor','none')
%ylabel('Height [km]')
set(gca,'xscale','log')
title('NCAR')
ax = gca;
ax.XTick = [1 10 100 1000 10000 100000];
c=colorbar('east','ylim',[-12, 0],'YTick',[-12,-9,-6,-3,0],'YTickLabel',{'1e-12','1e-9','1e-6','1e-3','1'});
c.Label.String = 'N(D) [L^{-1} \mum^{-1}]';
set(gca,'FontSize',fontsizef)
set(findall(gcf,'type','text'),'FontSize',fontsizef)
set(gca,'ylim',[0, 7])
set(gca,'xlim',[50, 100000])
xlabel('Diameter [\mum]')

%% Plot PSDs with Time
figure
subplot(1,3,1)
contourf(binsNCAR,Time,log10(PSDsALL)',-12:0.5:0,'LineColor','none')
ylabel('Time')
set(gca,'xscale','log')
title('UIUC')
ax = gca;
ax.XTick = [1 10 100 1000 10000 100000];
c=colorbar('east','ylim',[-12, 0],'YTick',[-12,-10,-8,-6,-4,-2,0,2],'YTickLabel',{'1e-12','1e-10','1e-8','1e-6','1e-4','1e-2','1','1e2'});
c.Label.String = 'N(D) [L^{-1} \mum^{-1}]';
set(gca,'FontSize',fontsizef)
set(findall(gcf,'type','text'),'FontSize',fontsizef)
set(gca,'ylim',[28000, 42000])
set(gca,'xlim',[50, 100000])

subplot(1,3,2)
contourf(binsNCAR,Time,log10(PSDNCAR1/1e8)',-12:0.5:0,'LineColor','none')
%ylabel('Height [km]')
set(gca,'xscale','log')
title('NCAR')
ax = gca;
ax.XTick = [1 10 100 1000 10000 100000];
%c=colorbar('east','ylim',[-12, 0],'Ticks',[-12,-9,-6,-3,0],'TickLabels',{'1e-12','1e-9','1e-6','1e-3','1'});
c=colorbar('east','ylim',[-12, 0],'YTick',[-12,-10,-8,-6,-4,-2,0,2],'YTickLabel',{'1e-12','1e-10','1e-8','1e-6','1e-4','1e-2','1','1e2'});
c.Label.String = 'N(D) [L^{-1} \mum^{-1}]';
set(gca,'FontSize',fontsizef)
set(findall(gcf,'type','text'),'FontSize',fontsizef)
set(gca,'ylim',[28000, 42000])
set(gca,'xlim',[50, 100000])
xlabel('Diameter [\mum]')

subplot(1,3,3)
plot(Air_Temp,Time)
xlabel('Temperature')
set(gca,'ylim',[28000, 42000])
grid on
set(gca,'FontSize',fontsizef)
set(findall(gcf,'type','text'),'FontSize',fontsizef)

%% Plot from 10:27-10:33
tstart=hhmmss2insec(102700);
tend=hhmmss2insec(103300);
range = find(Time <=tend & Time >= tstart);

figure
stairs(bins2DC,PSDs2DC(:,range),'r')
hold on
stairs(binsHVPS,PSDsHVPS(:,range),'g')
stairs(binsNCAR'/1000,PSDNCAR(range,:)'/100000000,'k')
set(gca,'xscale','log')
set(gca,'yscale','log')
ylim([1e-8, 1e2])
xlabel('Diameter [mm]')
ylabel('Number Concentration [cm^{-4}]')

stairs(bins2DC,nanmean(PSDs2DC(:,range),2),'r')
stairs(binsHVPS,nanmean(PSDsHVPS(:,range),2),'g')
stairs(binsNCAR'/1000,nanmean(PSDNCAR(range,:),1)'/100000000,'k')
set(gca,'xscale','log')
set(gca,'yscale','log')
ylim([1e-8, 1e2])
xlabel('Diameter [mm]')
ylabel('Number Concentration [cm^{-4}]')
title('Average 10:27-10:33')

%%
tstart=hhmmss2insec(102705);
range = find(Time>tstart & Time<tstart+1);

figure
stairs(bins2DC,PSDs2DC(:,range),'r')
hold on
stairs(binsHVPS,PSDsHVPS(:,range),'g')
stairs(binsNCAR'/1000,PSDNCAR(range,:)'/100000000,'k')
set(gca,'xscale','log')
set(gca,'yscale','log')
ylim([1e-8, 1e2])
xlabel('Diameter [mm]')
ylabel('Number Concentration [cm^{-4}]')
title('102705')

%%
tstart=hhmmss2insec(102712);
range = find(Time>tstart & Time<tstart+1);

figure
stairs(bins2DC,PSDs2DC(:,range),'r')
hold on
stairs(binsHVPS,PSDsHVPS(:,range),'g')
stairs(binsNCAR'/1000,PSDNCAR(range,:)'/100000000,'k')
set(gca,'xscale','log')
set(gca,'yscale','log')
ylim([1e-8, 1e2])
xlabel('Diameter [mm]')
ylabel('Number Concentration [cm^{-4}]')
title('102712')

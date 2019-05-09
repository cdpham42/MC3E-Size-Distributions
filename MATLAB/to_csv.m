%% Transferring data to CSV, including hhmmss time, air temp, pres alt, TAS

clc
clear
close all force

fprintf('Reading data...');
[mc3e, comb, DC, CIP, HVPS, mc3eAll, combAll, DCAll, CIPAll, HVPSAll, date, prefix, AirTemp, Time, TAS, PresAlt] = data_read();

HHMMSS = insec2hhmmss(Time);

date = {'2011 04 22';'2011 04 25';'2011 04 27';'2011 05 01';'2011 05 10';'2011 05 11';...
    '2011 05 18';'2011 05 20';'2011 05 23';'2011 05 24';'2011 05 27';'2011 05 30';...
    '2011 06 01-1';'2011 06 01-2';'2011 06 02'};

fprintf(' Done.\n');

hms = zeros(14925,3,15);

combrate = zeros(size(comb,1),1);
DCrate = zeros(size(DC,1),1);
CIPrate = zeros(size(CIP,1),1);
HVPSrate = zeros(size(HVPS,1),1);

for i = 1:15
    combrate(:,:,i) = rainrate(comb(:,:,i),1);
    DCrate(:,:,i) = rainrate(DC(:,:,i),2);
    CIPrate(:,:,i) = rainrate(CIP(:,:,i),3);
    HVPSrate(:,:,i) = rainrate(HVPS(:,:,i),4);
end

comb_head = {'Time','HHMMSS','Hour','Minute','Second','Air Temp [C]','TAS [m/s]','Pres Alt [m]','Rainrate [mm/hr]','.075mm','.125mm','.175mm','.225mm','.275mm','.325mm','.375mm','.4375mm','.5125mm','.5875mm','.6625mm','.75mm','.85mm','.95mm','1.1mm','1.3mm','1.5mm','1.7mm','2.0mm','2.4mm','2.8mm','3.2mm','3.6mm','4.0mm','4.4mm','4.8mm','5.5mm','6.5mm','7.5mm','8.5mm','9.5mm','11mm','13mm','15mm','17mm','19mm','22.5mm','27.5mm'};
DC_head = {'Time','HHMMSS','Hour','Minute','Second','Air Temp [C]','TAS [m/s]','Pres Alt [m]','Rainrate [mm/hr]','.075mm','.125mm','.175mm','.225mm','.275mm','.325mm','.375mm','.4375mm','.5125mm','.5875mm','.6625mm','.75mm','.85mm','.95mm','1.1mm','1.3mm','1.5mm','1.7mm','1.9mm'};
CIP_head = {'Time','HHMMSS','Hour','Minute','Second','Air Temp [C]','TAS [m/s]','Pres Alt [m]','Rainrate [mm/hr]','.075mm','.125mm','.175mm','.225mm','.275mm','.325mm','.375mm','.4375mm','.5125mm','.5875mm','.6625mm','.75mm','.85mm','.95mm','1.1mm','1.3mm','1.5mm','1.7mm','1.9mm'};
HVPS_head = {'Time','HHMMSS','Hour','Minute','Second','Air Temp [C]','TAS [m/s]','Pres Alt [m]','Rainrate [mm/hr]','.3mm','.5mm','.7mm','.9mm',' 1.1mm','1.3mm','1.5mm','1.7mm','2.0mm','2.4mm','2.8mm','3.2mm','3.6mm','4.0mm','4.4mm','4.8mm','5.5mm','6.5mm','7.5mm','8.5mm','9.5mm','11mm','13mm','15mm','17mm','19mm','22.5mm','27.5mm'};
meta_head = {'Time','HHMMSS','Hour','Minute','Second','Air_Temp','MachNo_N','IAS','TAS','Press_Alt','Pot_Temp_T1','Pitot_Wing','CABIN_PRES','STATIC_PR','DEWPT','MixingRatio','DewPoint','FrostPoint','POS_Roll','POS_Pitch','POS_Head','POSZ_Acc','POS_Lat','POS_Lon','POS_Alt','POS_Spd','POS_Trk','Alpha','Beta',' VERT_VEL','Wind_Z','Wind_M','Wind_D','TURB','King_LWC_ad','Nev_TWC','Nev_LWCcor','CDP_Conc','CDP_LWC','CDP_MenD','CDP_VolDia','CDP_EffRad','2-DC_Conc','2-DC_MenD','2-DC_VolDia','2-DC_EffRad','IceMSOFreq','CPCConc','TSG_Date'};

for k = 1:15
    
    hms(:,1,k) = floor(Time(:,k)./3600);
    hms(:,2,k) = floor(rem(Time(:,k),3600)./60);
    hms(:,3,k) = rem(Time(:,k),60);

end

fprintf('Writing data to csv...');

for k = 1:15
    
    array = [Time(:,k), HHMMSS(:,k), hms(:,1,k), hms(:,2,k), hms(:,3,k), AirTemp(:,k), TAS(:,k), PresAlt(:,k)];
    
    comb_out = cat(2,array,combrate(:,:,k),comb(:,:,k));
    DC_out = cat(2,array,DCrate(:,:,k),DC(:,:,k));
    CIP_out = cat(2,array,CIPrate(:,:,k),CIP(:,:,k));
    HVPS_out = cat(2,array,HVPSrate(:,:,k),HVPS(:,:,k));
    meta_out = cat(2,mc3e(:,1,k),HHMMSS(:,k),hms(:,1,k),hms(:,2,k),hms(:,3,k),mc3e(:,2:end,k));
    
    csvwrite_with_headers(char(strcat(date(k),' Combined Spectrum.csv')),comb_out,comb_head);
    csvwrite_with_headers(char(strcat(date(k),' 2DC.csv')),DC_out,DC_head);
    csvwrite_with_headers(char(strcat(date(k),' CIP.csv')),CIP_out,CIP_head);
    csvwrite_with_headers(char(strcat(date(k),' HVPS.csv')),HVPS_out,HVPS_head);
    csvwrite_with_headers(char(strcat(date(k),' Meta.csv')),meta_out,meta_head);
    
end

fprintf(' Done.\n');

fprintf('Finished.\n');
function [mc3e, comb, DC, CIP, HVPS, mc3eAll, combAll, DCAll, CIPAll, HVPSAll, date, prefix, AirTemp, Time, TAS, PresAlt] = data_read()


% April 22, 2011 - Array Page 1
mc3e = fopen('2011_04_22_21_49_35_v2 mc3e.txt');
comb = fopen('20110422_214938.comb.spectrum.1Hz.txt');
DC = fopen('20110422_214938.2DC.1Hz.txt');
CIP = fopen('20110422_214938.CIP.1Hz.txt');
HVPS = fopen('20110422_214938.HVPS3.1Hz.txt');

[mc3e422,comb422,DC422,CIP422,HVPS422] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');

% April 25, 2011 - Array Page 2
mc3e = fopen('2011_04_25_09_07_51_v2 mc3e.txt');
comb = fopen('20110425_090755.comb.spectrum.1Hz.txt');
DC = fopen('20110425_090755.2DC.1Hz.txt');
CIP = fopen('20110425_090755.CIP.1Hz.txt');
HVPS = fopen('20110425_090755.HVPS3.1Hz.txt');

[mc3e425,comb425,DC425,CIP425,HVPS425] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% April 27, 2011 - Array Page 3
mc3e = fopen('2011_04_27_07_51_41_v2 mc3e.txt');
comb = fopen('20110427_075145.comb.spectrum.1Hz.txt');
DC = fopen('20110427_075145.2DC.1Hz.txt');
CIP = fopen('20110427_075145.CIP.1Hz.txt');
HVPS = fopen('20110427_075145.HVPS3.1Hz.txt');

[mc3e427,comb427,DC427,CIP427,HVPS427] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 01, 2011 - Array Page 4
mc3e = fopen('2011_05_01_16_18_47_v2 mc3e.txt');
comb = fopen('20110501_161850.comb.spectrum.1Hz.txt');
DC = fopen('20110501_161850.2DC.1Hz.txt');
CIP = fopen('20110501_161850.CIP.1Hz.txt');
HVPS = fopen('20110501_161850.HVPS3.1Hz.txt');

[mc3e501,comb501,DC501,CIP501,HVPS501] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 10, 2011 - Array Page 5
mc3e = fopen('2011_05_10_12_40_10_v2 mc3e.txt');
comb = fopen('20110510_214014.comb.spectrum.1Hz.txt');
DC = fopen('20110510_214014.2DC.1Hz.txt');
CIP = fopen('20110510_214014.CIP.1Hz.txt');
HVPS = fopen('20110510_214014.HVPS3.1Hz.txt');

[mc3e510,comb510,DC510,CIP510,HVPS510] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 11, 2011 - Array Page 6
mc3e = fopen('2011_05_11_15_46_09_v2 mc3e.txt');
comb = fopen('20110511_154612.comb.spectrum.1Hz.txt');
DC = fopen('20110511_154612.2DC.1Hz.txt');
CIP = fopen('20110511_154612.CIP.1Hz.txt');
HVPS = fopen('20110511_154612.HVPS3.1Hz.txt');

[mc3e511,comb511,DC511,CIP511,HVPS511] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');

% May 18, 2011 - Array Page 7
mc3e = fopen('2011_05_18_07_08_45_v2 mc3e.txt');
comb = fopen('20110518_070849.comb.spectrum.1Hz.txt');
DC = fopen('20110518_070849.2DC.1Hz.txt');
CIP = fopen('20110518_070849.CIP.1Hz.txt');
HVPS = fopen('20110518_070849.HVPS3.1Hz.txt');

[mc3e518,comb518,DC518,CIP518,HVPS518] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 20, 2011 - Array Page 8
mc3e = fopen('2011_05_20_12_54_03_v2 mc3e.txt');
comb = fopen('20110520_125407.comb.spectrum.1Hz.txt');
DC = fopen('20110520_125407.2DC.1Hz.txt');
CIP = fopen('20110520_125407.CIP.1Hz.txt');
HVPS = fopen('20110520_125407.HVPS3.1Hz.txt');

[mc3e520,comb520,DC520,CIP520,HVPS520] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 23, 2011 - Array Page 9
mc3e = fopen('2011_05_23_21_20_21_v2 mc3e.txt');
comb = fopen('20110523_212025.comb.spectrum.1Hz.txt');
DC = fopen('20110523_212025.2DC.1Hz.txt');
CIP = fopen('20110523_212025.CIP.1Hz.txt');
HVPS = fopen('20110523_212025.HVPS3.1Hz.txt');

[mc3e523,comb523,DC523,CIP523,HVPS523] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 24, 2011 - Array Page 10
mc3e = fopen('2011_05_24_20_09_42_v2 mc3e.txt');
comb = fopen('20110524_200946.comb.spectrum.1Hz.txt');
DC = fopen('20110524_200946.2DC.1Hz.txt');
CIP = fopen('20110524_200946.CIP.1Hz.txt');
HVPS = fopen('20110524_200946.HVPS3.1Hz.txt');

[mc3e524,comb524,DC524,CIP524,HVPS524] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 27, 2011 - Array Page 11
mc3e = fopen('2011_05_27_11_49_26_v2 mc3e.txt');
comb = fopen('20110527_114929.comb.spectrum.1Hz.txt');
DC = fopen('20110527_114929.2DC.1Hz.txt');
CIP = fopen('20110527_114929.CIP.1Hz.txt');
HVPS = fopen('20110527_114929.HVPS3.1Hz.txt');

[mc3e527,comb527,DC527,CIP527,HVPS527] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% May 30, 2011 - Array Page 12
mc3e = fopen('2011_05_30_17_11_33_v2 mc3e.txt');
comb = fopen('20110530_171137.comb.spectrum.1Hz.txt');
DC = fopen('20110530_171137.2DC.1HZ.txt');
CIP = fopen('20110530_171137.CIP.1Hz.txt');
HVPS = fopen('20110530_171137.HVPS3.1Hz.txt');

[mc3e530,comb530,DC530,CIP530,HVPS530] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% June 01, 2011 162026 - Array Page 13
mc3e = fopen('2011_06_01_16_20_26_v2 mc3e.txt');
comb = fopen('20110601_161140.comb.spectrum.1Hz.txt');
DC = fopen('20110601_161140.2DC.1Hz.txt');
CIP = fopen('20110601_161140.CIP.1Hz.txt');
HVPS = fopen('20110601_161140.HVPS3.1Hz.txt');

[mc3e6011,comb6011,DC6011,CIP6011,HVPS6011] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% June 01, 2011 185943 - Array Page 14
mc3e = fopen('2011_06_01_18_59_43_v2 mc3e.txt');
comb = fopen('20110601_185947.comb.spectrum.1Hz.txt');
DC = fopen('20110601_185947.2DC.1Hz.txt');
CIP = fopen('20110601_185947.CIP.1Hz.txt');
HVPS = fopen('20110601_185947.HVPS3.1Hz.txt');

[mc3e6012,comb6012,DC6012,CIP6012,HVPS6012] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');


% June 02, 2011 - Array Page 15
mc3e = fopen('2011_06_02_14_29_55_v2 mc3e.txt');
comb = fopen('20110602_142959.comb.spectrum.1Hz.txt');
DC = fopen('20110602_142959.2DC.1Hz.txt');
CIP = fopen('20110602_142959.CIP.1Hz.txt');
HVPS = fopen('20110602_142959.HVPS3.1Hz.txt');

[mc3e602,comb602,DC602,CIP602,HVPS602] = getData(mc3e,comb,DC,CIP,HVPS);
fclose('all');

%% Arrays for names
date = {' 2011 04 22';' 2011 04 25';' 2011 04 27';' 2011 05 01';' 2011 05 10';' 2011 05 11';...
    ' 2011 05 18';' 2011 05 20';' 2011 05 23';' 2011 05 24';' 2011 05 27';' 2011 05 30';...
    ' 2011 06 01-1';' 2011 06 01-2';' 2011 06 02'};
% date = cellstr(date);

prefix = {'Rainrate N(D) ','Rainrate N(logD) ','Raindrop Size Distribution N(D) ','Raindrop Size Distribution N(logD) '};


%% Organizing into Arrays

%{
    Array Information:
    
    Size: 14925x38x15
    
    Index Values of Each Date:
    01: April 22
    02: April 25
    03: April 27
    04: May 01
    05: May 10
    06: May 11
    07: May 18
    08: May 20
    09: May 23
    10: May 24
    11: May 27
    12: May 30
    13: June 1 Flight 1
    14: June 1 Flight 2
    15: June 2
%}

mc3e = cat(3,mc3e422,mc3e425,mc3e427,mc3e501,mc3e510,mc3e511,mc3e518,mc3e520,...
    mc3e523,mc3e524,mc3e527,mc3e530,mc3e6011,mc3e6012,mc3e602);

DC = cat(3,DC422,DC425,DC427,DC501,DC510,DC511,DC518,DC520,...
    DC523,DC524,DC527,DC530,DC6011,DC6012,DC602);

comb = cat(3,comb422,comb425,comb427,comb501,comb510,comb511,comb518,comb520,...
    comb523,comb524,comb527,comb530,comb6011,comb6012,comb602);

CIP = cat(3,CIP422,CIP425,CIP427,CIP501,CIP510,CIP511,CIP518,CIP520,...
    CIP523,CIP524,CIP527,CIP530,CIP6011,CIP6012,CIP602);

HVPS = cat(3,HVPS422,HVPS425,HVPS427,HVPS501,HVPS510,HVPS511,HVPS518,HVPS520,...
    HVPS523,HVPS524,HVPS527,HVPS530,HVPS6011,HVPS6012,HVPS602);

AirTemp = cat(2,mc3e422(:,2),mc3e425(:,2),mc3e427(:,2),mc3e501(:,2),mc3e510(:,2),mc3e511(:,2),mc3e518(:,2),mc3e520(:,2),...
    mc3e523(:,2),mc3e524(:,2),mc3e527(:,2),mc3e530(:,2),mc3e6011(:,2),mc3e6012(:,2),mc3e602(:,2));

Time = cat(2,mc3e422(:,1),mc3e425(:,1),mc3e427(:,1),mc3e501(:,1),mc3e510(:,1),mc3e511(:,1),mc3e518(:,1),mc3e520(:,1),...
    mc3e523(:,1),mc3e524(:,1),mc3e527(:,1),mc3e530(:,1),mc3e6011(:,1),mc3e6012(:,1),mc3e602(:,1));

TAS = cat(2,mc3e422(:,5),mc3e425(:,5),mc3e427(:,5),mc3e501(:,5),mc3e510(:,5),mc3e511(:,5),mc3e518(:,5),mc3e520(:,5),...
    mc3e523(:,5),mc3e524(:,5),mc3e527(:,5),mc3e530(:,5),mc3e6011(:,5),mc3e6012(:,5),mc3e602(:,5));

PresAlt = cat(2,mc3e422(:,6),mc3e425(:,6),mc3e427(:,6),mc3e501(:,6),mc3e510(:,6),mc3e511(:,6),mc3e518(:,6),mc3e520(:,6),...
    mc3e523(:,6),mc3e524(:,6),mc3e527(:,6),mc3e530(:,6),mc3e6011(:,6),mc3e6012(:,6),mc3e602(:,6));

% Combined into 1 array

mc3eAll = cat(1,mc3e422,mc3e425,mc3e427,mc3e501,mc3e510,mc3e511,mc3e518,mc3e520,...
    mc3e523,mc3e524,mc3e527,mc3e530,mc3e6011,mc3e6012,mc3e602);

combAll = cat(1,comb422,comb425,comb427,comb501,comb510,comb511,comb518,comb520,...
    comb523,comb524,comb527,comb530,comb6011,comb6012,comb602);

DCAll = cat(1,DC422,DC425,DC427,DC501,DC510,DC511,DC518,DC520,...
    DC523,DC524,DC527,DC530,DC6011,DC6012,DC602);

CIPAll = cat(1,CIP422,CIP425,CIP427,CIP501,CIP510,CIP511,CIP518,CIP520,...
    CIP523,CIP524,CIP527,CIP530,CIP6011,CIP6012,CIP602);

HVPSAll = cat(1,HVPS422,HVPS425,HVPS427,HVPS501,HVPS510,HVPS511,HVPS518,HVPS520,...
    HVPS523,HVPS524,HVPS527,HVPS530,HVPS6011,HVPS6012,HVPS602);

# -*- coding: utf-8 -*-
"""
Created on Mon Mar 14 17:06:10 2016

@author: Casey

Research - Mid-latitude Continental Convective Clouds Experiment (MC3E) Analysis

Data read into nested dictionary, sorted by date, then file type (2DC, CIP, HVPS, etc.),
then an array of data. Headers dictionary contains headers for respective files.

mc3eDF is a Pandas DataFrame of all mc3e data.
"""

import numpy as np
import math
import csv
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import re
import statsmodels.formula.api as smf
from sklearn import linear_model

from numpy.testing import assert_array_equal, assert_almost_equal
from nose.tools import assert_equal, assert_is_instance

# Plot label sizes
size = 40
subsize = 20

#%% Read and calculate NCAR data

print('Reading data...',end='')

comp = 0 # 0 = laptop, else desktop

if comp == 0:
    path = r'C:\Users\cdpha\Google Drive\Research\Python\\'
else:
    path = r'C:\Users\Casey Pham\Google Drive\Research\Python\\'
    
data_path = path+'data\\'


dates = ['2011 04 22','2011 04 25','2011 04 27','2011 05 01','2011 05 10',\
'2011 05 11','2011 05 18','2011 05 20','2011 05 23','2011 05 24','2011 05 27',\
'2011 05 30','2011 06 01-1','2011 06 01-2','2011 06 02']

types = ['2DC','CIP','HVPS','Combined Spectrum','Meta']

mc3e = {}

for date in dates: # Loop through dates
    mc3e[date] = {}
    for t in types: # Loop through files (@DC, CIP, HVPS, etc.)
        mc3e[date][t] = []
        file = data_path+date+' '+t+'.csv'
        with open(file) as f: # Open file
            reader = csv.reader(f,delimiter=',') # Read CSV
            rownum = 0
            content = []
            for row in reader:
                if rownum == 0:
                    header = row # Set header row
                else:
                    content.append(row) # Append row
                
                rownum += 1
                
            for i in range(len(content)):
                for j in range(len(content[i])):
                    content[i][j] = float(content[i][j])
            
            mc3e[date][t] = content # Set date's data to be the file:content
      
      
for date in mc3e:
    for file in mc3e[date]:
        mc3e[date][file] = np.array(mc3e[date][file])
        mc3e[date][file] = mc3e[date][file][mc3e[date][file][:,0] != 0]
        
mc3eDF = pd.DataFrame(mc3e)

headersMC3E = {}

with open(data_path+'Headers.csv') as f:
    reader = csv.reader(f,delimiter=',')
    rownum = 0
    for row in reader:
        headersMC3E[types[rownum]] = row
        rownum += 1

#%% Extract data to individual variables

# Bins in mm

bin2DC = headersMC3E['2DC'][9:]
for i in range(len(bin2DC)):
    bin2DC[i] = re.sub("[^0-9.]","",bin2DC[i])
    bin2DC[i] = float(bin2DC[i])

binCIP = headersMC3E['CIP'][9:]
for i in range(len(binCIP)):
    binCIP[i] = re.sub("[^0-9.]","",binCIP[i])
    binCIP[i] = float(binCIP[i])
    
binHVPS = headersMC3E['HVPS'][9:]
for i in range(len(binHVPS)):
    binHVPS[i] = re.sub("[^0-9.]","",binHVPS[i])
    binHVPS[i] = float(binHVPS[i])
    
binComb = headersMC3E['Combined Spectrum'][9:]
for i in range(len(binComb)):
    binComb[i] = re.sub("[^0-9.]","",binComb[i])
    binComb[i] = float(binComb[i])
    
binComb_End = [50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,475.0,550.0,\
625.0,700.0,800.0,900.0,1000.0,1200.0,1400.0,1600.0,1800.0,2200.0,2600.0,\
3000.0,3400.0,3800.0,4200.0,4600.0,5000.0,6000.0,7000.0,8000.0,9000.0,10000.0,\
12000.0,14000.0,16000.0,18000.0,20000.0,25000.0,30000.0] # microns

binComb_End = [x*10**-3 for x in binComb_End] # Convert to mm

binComb_dD = []
for i in range(len(binComb_End)-1):
    binComb_dD.append(binComb_End[i+1]-binComb_End[i])
    
# Extract Variables

Air_Temp = {}
Time = {}
HMS = {}


for date in dates:
    Air_Temp[date] = mc3e[date]['Meta'][:,5]
    Time[date] = mc3e[date]['Meta'][:,0]
    HMS[date] = mc3e[date]['Meta'][:,1]
    
# Extract PSDs 
PSD_2DC = {}
PSD_CIP = {}
PSD_HVPS = {}
PSD_Comb = {}
for date in dates:
    PSD_2DC[date] = mc3e[date]['2DC'][:,9:][Air_Temp[date] > 5]
    PSD_CIP[date] = mc3e[date]['CIP'][:,9:][Air_Temp[date] > 5]
    PSD_HVPS[date] = mc3e[date]['HVPS'][:,9:][Air_Temp[date] > 5]
    PSD_Comb[date] = mc3e[date]['Combined Spectrum'][:,9:][Air_Temp[date] > 5]
    
# Extract times in rain
Time_Rain = {}
HMS_Rain = {}

for date in dates:
    Time_Rain[date] = Time[date][Air_Temp[date]>5]
    HMS_Rain[date] = Time[date][Air_Temp[date]>5]
    
print('Done.')

#%% Calculate NCAR Normalization

print('Calculating NCAR normalization...',end='')

LWC = {}
Dm = {}
No = {}
logNo = {}

for date in dates:
    Dm[date] = np.zeros((PSD_Comb[date].shape[0],1))
    LWC[date] = np.zeros((PSD_Comb[date].shape[0],1))
    No[date] = np.zeros((PSD_Comb[date].shape[0],1))
    logNo[date] = np.zeros((PSD_Comb[date].shape[0],1))
    
    for i in range(PSD_Comb[date].shape[0]):
        
        # LWC
        tot = 0
        
        # Dm
        top = 0
        bot = 0
        
        for j in range(PSD_Comb[date].shape[1]):
            # LWC
            tot = tot + PSD_Comb[date][i,j]*(binComb[j]*.001)**3*(binComb_dD[j]*.001) # Convert bins to meter
            
            # Dm
            top = top + PSD_Comb[date][i,j]*binComb[j]**4*binComb_dD[j]
            bot = bot + PSD_Comb[date][i,j]*binComb[j]**3*binComb_dD[j]
        
        LWC[date][i] = (math.pi*1000/6)*tot
        Dm[date][i] = top/bot
        No[date][i] = (4**4/(math.pi*1000))*(LWC[date][i]/(Dm[date][i]*.001)**4) # Convert Dm to meter
        logNo[date][i] = np.log10(No[date][i])
        
print('Done.')

#%% Dm vs log(No*) Plots
    
plot = 0

if plot == 1:

    print('Plotting Dm vs log(No*)')
    
    for date in dates:
        
        print('    '+date)
        
        fig,ax = plt.subplots(figsize=(26.67,15))
        
        ax.scatter(Dm[date],logNo[date])
        
        ax.set_xlim([0,30])
        
        ax.set_xlabel('$D_{m}\ [mm]$',fontsize=24)
        ax.set_ylabel('$log_{10}(N_{0}^{*}$)',fontsize=24)
        ax.set_title(date + ' $D_{m}$ vs $log_{10}(N_{0}^{*}$)',fontsize=28)
        ax.tick_params(labelsize=20)
        
        fig.savefig(path+'\Dm vs logNo Plots\\'+date+'Dm vs logNo')
        plt.close(fig)
        
    print('Done.')

#%% Read UIUC data

print('Reading UIUC data...',end='')

UIUC = {}
types = ['2DC','HVPS']
headersUIUC = {}


UIUC['2011 04 27'] = {}
for t in types: # Loop through files (2DC, HVPS)
    UIUC['2011 04 27'][t] = []
    file = data_path+'2011 04 27'+' UIUC '+t+'.csv'
    with open(file) as f: # Open file
        reader = csv.reader(f,delimiter=',') # Read CSV
        rownum = 0
        content = []
        for row in reader:
            if rownum == 0:
                headersUIUC[t] = row # Set header row
            else:
                content.append(row) # Append row
            
            rownum += 1
            
        for i in range(len(content)):
            for j in range(len(content[i])):
                content[i][j] = float(content[i][j])
        
        UIUC['2011 04 27'][t] = content # Set date's data to be the file:content
      
      

for file in UIUC['2011 04 27']:
    UIUC['2011 04 27'][file] = np.array(UIUC['2011 04 27'][file])
        
UIUC_DF = pd.DataFrame(UIUC)

UIUC_2DC = UIUC['2011 04 27']['2DC'][:,2:][Air_Temp['2011 04 27'] > 5]
UIUC_HVPS = UIUC['2011 04 27']['HVPS'][:,2:][Air_Temp['2011 04 27'] > 5]

UIUC_Comb = np.concatenate((UIUC_2DC[:,:14],UIUC_HVPS[:,4:]),axis=1)

#binUIUC_Comb = headersUIUC['2DC'][2:16]+headersUIUC['HVPS'][6:]

print('Done')

#%% Calculate UIUC Normalization

print('Calculating UIUC Normalization...',end='')

UIUC_Dm = np.zeros((UIUC_Comb.shape[0],1))
UIUC_LWC = np.zeros((UIUC_Comb.shape[0],1))
UIUC_No = np.zeros((UIUC_Comb.shape[0],1))
UIUC_logNo = np.zeros((UIUC_Comb.shape[0],1))

for i in range(UIUC_Comb.shape[0]):
    
    # LWC
    tot = 0
    
    # Dm
    top = 0
    bot = 0
    
    for j in range(UIUC_Comb.shape[1]):
        # LWC
        tot = tot + UIUC_Comb[i,j]*binComb[j]**3*binComb_dD[j]
        
        # Dm
        top = top + UIUC_Comb[i,j]*binComb[j]**4*binComb_dD[j]
        bot = bot + UIUC_Comb[i,j]*binComb[j]**3*binComb_dD[j]
    
    UIUC_LWC[i] = (math.pi*1000/6)*tot
    UIUC_Dm[i] = top/bot
    UIUC_No[i] = (4**4/(math.pi*1000))*(UIUC_LWC[i]/UIUC_Dm[i]**4)
    UIUC_logNo[i] = np.log10(UIUC_No[i])
    
UIUC_Rate = np.zeros((UIUC_Comb.shape[0],1))
Vt = [970.5208*(1-math.exp( -( (D*0.1)/0.177 )**1.147) ) for D in binComb] # Convert diameters to cm
Vt = np.array(Vt)
Vt = Vt*.01 # Convert to m/s

for i in range(UIUC_Comb.shape[0]):
    R = 0
    for j in range(UIUC_Comb.shape[1]):
        R = R + UIUC_Comb[i,j]*(binComb[j]*0.001)**3*Vt[j]*(math.pi/6)*(binComb_dD[j]*0.001)
        
    UIUC_Rate[i] = R*3600000

print('Done')


#%% Sort by rainrate

print('Sorting by rainrate...',end='')

def TestudRainrate(rate,data):
    # Sorts into rainrate ranges 0-10, 10-30, 30-100 mm/hr

    # Input: Rainrate data, Data to be sorted
    # Output: 3-tuple of arrays of sorted data

    rate_0_10 = []
    rate_10_30 = []
    rate_30_100 = []
    
    for i in range(len(rate)):
        if len(data.shape)==1:
            if rate[i] > 0 and rate[i] <= 10:
                rate_0_10.append(data[i])
        
            if rate[i] > 10 and rate[i] <= 30:
                rate_10_30.append(data[i])
        
            if rate[i] > 30 and rate[i] <= 100:
                rate_30_100.append(data[i])
        else:
            if rate[i] > 0 and rate[i] <= 10:
                rate_0_10.append(data[i,:].tolist())
        
            if rate[i] > 10 and rate[i] <= 30:
                rate_10_30.append(data[i,:].tolist())
        
            if rate[i] > 30 and rate[i] <= 100:
                rate_30_100.append(data[i,:].tolist())
    
    rate_0_10 = np.array(rate_0_10)
    rate_10_30 = np.array(rate_10_30)
    rate_30_100 = np.array(rate_30_100)
    
    return rate_0_10,rate_10_30,rate_30_100
    
rates = ['0-10 mmhr-1','10-30 mmhr-1','30-100 mmhr-1']

CombRate = {}
HVPSRate = {}
DCRate = {}

for date in dates:
    CombRate[date] = mc3e[date]['Combined Spectrum'][:,8][Air_Temp[date] > 5]
    HVPSRate[date] = mc3e[date]['HVPS'][:,8][Air_Temp[date] > 5]
    DCRate[date] = mc3e[date]['2DC'][:,8][Air_Temp[date] > 5]

Testud_Comb = {}
Testud_HVPS = {}
Testud_2DC = {}
Testud_Dm = {}
Testud_No = {}
Testud_logNo = {}
Testud_Rate = {}

for date in dates:
    Testud_Comb[date] = TestudRainrate(CombRate[date],PSD_Comb[date])
    Testud_HVPS[date] = TestudRainrate(HVPSRate[date],PSD_HVPS[date])
    Testud_2DC[date] = TestudRainrate(DCRate[date],PSD_2DC[date])
    Testud_Dm[date] = TestudRainrate(CombRate[date],Dm[date])
    Testud_No[date] = TestudRainrate(CombRate[date],No[date])
    Testud_logNo[date] = TestudRainrate(CombRate[date],logNo[date])
    Testud_Rate[date] = TestudRainrate(CombRate[date],CombRate[date])
    
#UIUC
UIUC_Testud = TestudRainrate(UIUC_Rate,UIUC_Comb)
UIUC_Testud_Dm = TestudRainrate(UIUC_Rate,UIUC_Dm)
UIUC_Testud_No = TestudRainrate(UIUC_Rate,UIUC_No)
UIUC_Testud_logNo = TestudRainrate(UIUC_Rate,UIUC_logNo)
UIUC_Testud_Rate = TestudRainrate(UIUC_Rate,UIUC_Rate)


print('Done.')

#%% Average by rainrate and calculations

Testud_Comb_Avg = {}

for date in dates:
    
    Testud_Comb_Avg[date] = np.zeros((3,len(binComb)))
    
    for j in range(len(binComb)):
        for i in range(3):
            if Testud_Comb[date][i].size: # Test for empty array
                Testud_Comb_Avg[date][i,j] = np.mean(Testud_Comb[date][i][:,j])
            else:
                Testud_Comb_Avg[date][i,j] = 0
                
                
                

Testud_Comb_Avg_LWC = {}
Testud_Comb_Avg_Dm = {}
Testud_Comb_Avg_No = {}
Testud_Comb_Avg_logNo = {}

for date in dates:
    Testud_Comb_Avg_Dm[date] = np.zeros((Testud_Comb_Avg[date].shape[0],1))
    Testud_Comb_Avg_LWC[date] = np.zeros((Testud_Comb_Avg[date].shape[0],1))
    Testud_Comb_Avg_No[date] = np.zeros((Testud_Comb_Avg[date].shape[0],1))
    Testud_Comb_Avg_logNo[date] = np.zeros((Testud_Comb_Avg[date].shape[0],1))
    
    for i in range(Testud_Comb_Avg[date].shape[0]):
        
        # LWC
        tot = 0
        
        # Dm
        top = 0
        bot = 0
        
        for j in range(Testud_Comb_Avg[date].shape[1]):
            # LWC
            tot = tot + Testud_Comb_Avg[date][i,j]*binComb[j]**3*binComb_dD[j]
            
            # Dm
            top = top + Testud_Comb_Avg[date][i,j]*binComb[j]**4*binComb_dD[j]
            bot = bot + Testud_Comb_Avg[date][i,j]*binComb[j]**3*binComb_dD[j]
        
        Testud_Comb_Avg_LWC[date][i] = (math.pi*1000/6)*tot
        Testud_Comb_Avg_Dm[date][i] = top/bot
        Testud_Comb_Avg_No[date][i] = (4**4/(math.pi*1000))*(Testud_Comb_Avg_LWC[date][i]/Testud_Comb_Avg_Dm[date][i]**4)
        Testud_Comb_Avg_logNo[date][i] = np.log10(Testud_Comb_Avg_No[date][i])
        
Testud_Comb_Avg_Rate = {}

Vt = [970.5208*(1-math.exp( -( (D*0.1)/0.177 )**1.147) ) for D in binComb] # Convert diameters to cm
Vt = np.array(Vt)
Vt = Vt*.01 # Convert to m/s

for date in dates:
    Testud_Comb_Avg_Rate[date] = np.zeros((Testud_Comb_Avg[date].shape[0],1))
    for i in range(Testud_Comb_Avg[date].shape[0]):
        R = 0
        for j in range(Testud_Comb_Avg[date].shape[1]):
            R = R + Testud_Comb_Avg[date][i,j]*(binComb[j]*0.001)**3*Vt[j]*(math.pi/6)*(binComb_dD[j]*0.001)
            
        Testud_Comb_Avg_Rate[date][i] = R*3600000
        
for date in dates:
    Testud_Comb_Avg[date] = tuple(Testud_Comb_Avg[date])
    Testud_Comb_Avg_LWC[date] = tuple(Testud_Comb_Avg_LWC[date])
    Testud_Comb_Avg_Dm[date] = tuple(Testud_Comb_Avg_Dm[date])
    Testud_Comb_Avg_No[date] = tuple(Testud_Comb_Avg_No[date])
    Testud_Comb_Avg_logNo[date] = tuple(Testud_Comb_Avg_logNo[date])
    Testud_Comb_Avg_Rate[date] = tuple(Testud_Comb_Avg_Rate[date])
    
#%% UIUC Average by rainrate and calcuations
    
UIUC_Testud_Avg = np.zeros((3,len(binComb)))

for j in range(len(binComb)):
    for i in range(3):
        if UIUC_Testud[i].size: # Test for empty array
            temp = []
            for k in UIUC_Testud[i][:,j]:
                if k != 0:
                    temp.append(k)
                
            UIUC_Testud_Avg[i,j] = np.mean(temp)
        else:
            UIUC_Testud_Avg[i,j] = 0
                
UIUC_Testud_Avg_LWC = {}
UIUC_Testud_Avg_Dm = {}
UIUC_Testud_Avg_No = {}
UIUC_Testud_Avg_logNo = {}


UIUC_Testud_Avg_Dm = np.zeros((UIUC_Testud_Avg.shape[0],1))
UIUC_Testud_Avg_LWC = np.zeros((UIUC_Testud_Avg.shape[0],1))
UIUC_Testud_Avg_No = np.zeros((UIUC_Testud_Avg.shape[0],1))
UIUC_Testud_Avg_logNo = np.zeros((UIUC_Testud_Avg.shape[0],1))

for i in range(UIUC_Testud_Avg.shape[0]):
    
    # LWC
    tot = 0
    
    # Dm
    top = 0
    bot = 0
    
    for j in range(UIUC_Testud_Avg.shape[1]):
        # LWC
        tot = tot + UIUC_Testud_Avg[i,j]*binComb[j]**3*binComb_dD[j]
        
        # Dm
        top = top + UIUC_Testud_Avg[i,j]*binComb[j]**4*binComb_dD[j]
        bot = bot + UIUC_Testud_Avg[i,j]*binComb[j]**3*binComb_dD[j]
    
    UIUC_Testud_Avg_LWC[i] = (math.pi*1000/6)*tot
    UIUC_Testud_Avg_Dm[i] = top/bot
    UIUC_Testud_Avg_No[i] = (4**4/(math.pi*1000))*(UIUC_Testud_Avg_LWC[i]/UIUC_Testud_Avg_Dm[i]**4)
    UIUC_Testud_Avg_logNo[i] = np.log10(UIUC_Testud_Avg_No[i])
        
UIUC_Testud_Avg_Rate = {}

Vt = [970.5208*(1-math.exp( -( (D*0.1)/0.177 )**1.147) ) for D in binComb] # Convert diameters to cm
Vt = np.array(Vt)
Vt = Vt*.01 # Convert to m/s


UIUC_Testud_Avg_Rate = np.zeros((UIUC_Testud_Avg.shape[0],1))

for i in range(UIUC_Testud_Avg.shape[0]):
    R = 0
    for j in range(UIUC_Testud_Avg.shape[1]):
        R = R + UIUC_Testud_Avg[i,j]*(binComb[j]*0.001)**3*Vt[j]*(math.pi/6)*(binComb_dD[j]*0.001)
        
    UIUC_Testud_Avg_Rate[i] = R*3600000
        

UIUC_Testud_Avg = tuple(UIUC_Testud_Avg)
UIUC_Testud_Avg_LWC = tuple(UIUC_Testud_Avg_LWC)
UIUC_Testud_Avg_Dm = tuple(UIUC_Testud_Avg_Dm)
UIUC_Testud_Avg_No = tuple(UIUC_Testud_Avg_No)
UIUC_Testud_Avg_logNo = tuple(UIUC_Testud_Avg_logNo)
UIUC_Testud_Avg_Rate = tuple(UIUC_Testud_Avg_Rate)

#%% Statistics

print('Calculating statistics...',end='')

def stats(data):
    # Calculate means and standard deviations
    # Input Tuple of 3 1-D arrays/list, organized by Testud rainrates
    # Return Dictionary of means and stds.

    mean1 = np.mean(data[0])
    mean2 = np.mean(data[1])
    mean3 = np.mean(data[2])
    
    std1 = np.std(data[0])
    std2 = np.std(data[1])
    std3 = np.std(data[2])
    
    return {'Mean':[mean1, mean2, mean3], 'Std':[std1, std2, std3]}

logNoStats = {}
RateStats = {} # Rainrate
DmStats = {}

for date in dates:
    logNoStats[date] = stats(Testud_logNo[date])
    RateStats[date] = stats(Testud_Rate[date])
    DmStats[date] = stats(Testud_Dm[date])
    
UIUC_logNoStats = stats(UIUC_Testud_logNo)
UIUC_RateStats = stats(UIUC_Testud_Rate)
UIUC_DmStats = stats(UIUC_Testud_Dm)

print('Done.')



#%% Statistics Writing

export = 0

if export == 1:

    print('Exporting Statistics...')
    
    rates = ['0-10 mmhr-1','10-30 mmhr-1','30-100 mmhr-1']
    
    # NCAR
    for date in dates:
        with open('Statistics '+date+'.csv','w', newline='') as f:
            writer = csv.writer(f,delimiter=',')
            writer.writerow(['Rain Category','log(No*) Mean', 'log(No*) Std','R Mean','R Std','Dm Mean','Dm Std'])
            for i in range(3):
                writer.writerow([rates[i],\
                                 logNoStats[date]['Mean'][i], logNoStats[date]['Std'][i],\
                                 RateStats[date]['Mean'][i], RateStats[date]['Std'][i],\
                                 DmStats[date]['Mean'][i],DmStats[date]['Std'][i]])
    
    # UIUC
    with open('Statistics UIUC 2011 04 27.csv','w', newline='') as f:
        writer = csv.writer(f,delimiter=',')
        writer.writerow(['Rain Category','log(No*) Mean', 'log(No*) Std','R Mean','R Std','Dm Mean','Dm Std'])
        for i in range(3):
            writer.writerow([rates[i],\
                             UIUC_logNoStats['Mean'][i], UIUC_logNoStats['Std'][i],\
                             UIUC_RateStats['Mean'][i], UIUC_RateStats['Std'][i],\
                             UIUC_DmStats['Mean'][i],UIUC_DmStats['Std'][i]])
    
    print('Done.')

#%% Statistics Plots

def stat_plot(ND,D,No,Dm,R,date,rate):
    
    # Plots as in Figures 3-6 of Testud et al.
    # Input: N(D), D diameter bin, No scaling parameter, Dm mean volume diameter, R rainrate, Date string, rate string
    # Output: Plot
    
    fig,ax = plt.subplots(3,2,figsize=(26.67,30))
    
    size = 40
    subsize = 20
    
    # Hist of log_10(No*)
    x = np.log10(No)
    if x.size>0:
        if not np.isnan(x[0]):
            ax[0,0].hist(x,bins=50,range=[3,11])
            ax[0,0].set_xlabel('$log_{10}(N_{0}^{*}$)',fontsize=size)
            ax[0,0].set_ylabel('Counts',fontsize=size)
            ax[0,0].tick_params(axis='both', labelsize=subsize)
#            ax[0,0].set_xlim([3,11])
    
    # Hist of Dm
    if x.size>0:
        if not np.isnan(Dm[0]):
            ax[0,1].hist(Dm,bins=30,range=[0,14])
            ax[0,1].set_xlabel('$D_{m}\ [mm]$',fontsize=size)
            ax[0,1].set_ylabel('Counts',fontsize=size)
            ax[0,1].tick_params(axis='both', labelsize=subsize)
#            ax[0,1].set_xlim([0,14])
        
    # Hist of Rainrate
    if x.size>0:
        if not np.isnan(R[0]):
            ax[1,0].hist(R,bins=20,range=[0,100])
            ax[1,0].set_xlabel('$Rainrate\ [mm/hr^{-1}]$',fontsize=size)
            ax[1,0].set_ylabel('Counts',fontsize=size)
            ax[1,0].tick_params(axis='both', labelsize=subsize)
#            ax[1,0].set_xlim([0,100])
    
    # Scatter of D/Dm vs log_10(N(D)/No*)
    x = np.zeros_like(ND)
    if len(x.shape)>1:
        for i in range(x.shape[0]):
            for j in range(x.shape[1]):
                x[i,j] = D[j]/Dm[i]
        
        y = np.zeros_like(ND)
        for i in range(y.shape[0]):
            for j in range(y.shape[1]):
                y[i,j] = ND[i,j]/No[i]
        y = np.log10(y)
        
    else:
        for i in range(x.shape[0]):
            x[i] = D[i]/Dm
        
        y = np.zeros_like(ND)
        for i in range(y.shape[0]):
            y[i] = ND[i]/No
        y = np.log10(y)

    ax[2,0].scatter(x,y)
    ax[2,0].set_xlabel('Diameter/Dm',fontsize=size)
    ax[2,0].set_ylabel('$log_{10}(N(D)/N_{0}^{*})$',fontsize=size)
    ax[2,0].tick_params(axis='both', labelsize=subsize)
    ax[2,0].set_xlim(left=0)
    ax[2,0].set_xlim([0,4])
    ax[2,0].set_ylim([-5,5])
    
    # Scatter of D vs log_10(N(D))
    
    x = np.zeros_like(ND)
    
    if len(x.shape)>1:
        for i in range(x.shape[0]):
            x[i,:] = D
    else:
        for i in range(x.shape[0]):
            x[i] = D[i]
    y = np.log10(ND)
    
    ax[2,1].scatter(x,y)
    ax[2,1].set_xlabel('Diameter [mm]',fontsize=size)
    ax[2,1].set_ylabel('$log_{10}(N(D))$',fontsize=size)
    ax[2,1].tick_params(axis='both', labelsize=subsize)
    ax[2,1].set_xlim(left=0)
    ax[2,1].set_xlim([0,14])
    ax[2,1].set_ylim([2,11])
    ax[2,1].set_xscale('log')
    
    # Whisker plot of D/Dm vs log_10(N(D)/No*)
    
    # Save figure
    fig.suptitle('Statistics '+date+' '+rate,fontsize=size)
    
    savepath = path+'StatPlots\\'
    
    fig.savefig(savepath+'Statistics '+date+' '+rate)
    plt.close(fig)

plot = 0

if plot == 1:
    
    print('Plotting PSD Statistics...')
    
    for date in dates:
        print('    '+date)
        for i in range(3):
            stat_plot(Testud_Comb[date][i],binComb,Testud_No[date][i],Testud_Dm[date][i],Testud_Rate[date][i],date,rates[i])
            
    print('Done.')
    
plot = 0

if plot == 1:
    
    print('Plotting Averaged PSD Statistics...')
    
    for date in dates:
        print('    '+date)
        for i in range(3):
            stat_plot(Testud_Comb_Avg[date][i],binComb,Testud_Comb_Avg_No[date][i],Testud_Comb_Avg_Dm[date][i],Testud_Comb_Avg_Rate[date][i],'Average '+date,rates[i])
    
    print('Done.')
    
plot = 0

if plot == 1:
    
    print('Plotting UIUC PSD Statistics...',end='')
    
    for i in range(3):
        stat_plot(UIUC_Testud[i],binComb,UIUC_Testud_No[i],UIUC_Testud_Dm[i],UIUC_Testud_Rate[i],
        'UIUC 2011 04 27',rates[i])
        
    print('Done')
    
plot = 0

if plot == 1:
    
    print('Plotting Averaged UIUC PSD Statistics...',end='')
    
    for i in range(3):
         stat_plot(UIUC_Testud_Avg[i],binComb,UIUC_Testud_Avg_No[i],UIUC_Testud_Avg_Dm[i],UIUC_Testud_Avg_Rate[i],
                   'UIUC 2011 04 27 Averaged',rates[i])

    print('Done')
#%% Comparison of UIUC and NCAR Data

print('Calculating comparisons...',end='')

def calc_LWC(PSD,D,dD):
    # Calulate liquid water content of a particle size distribution dataset
    # Input: Array of distributions in m^-4, array of bins
    # Output: Array of liquid water content of each distribution

    result = []
    pw = 1000 # kg/m^3, density of water
    
    for row in PSD:
        lwc = 0
        i = 0
        
        for col in row:
            lwc = lwc + col*((D[i]*10**-3)**3)*(dD[i]*10**-3) # Convert diameters to meter
            i += 1
        lwc = lwc*(np.pi*pw/6)
        
        result.append(lwc)
        
    result = np.array(result)
            
    return result

UIUC_LWC = calc_LWC(UIUC_Comb,binComb,binComb_dD)

NCAR_LWC = calc_LWC(PSD_Comb['2011 04 27'],binComb,binComb_dD) # 2011 04 27 for comparison with UIUC 2011 04 27
    
def avg10s(PSD):
    
    # Calculate 10s average of PSDs
    # Input: PSD
    # Output: PSD 10s average

    average = []    
    
    for i in range(math.ceil(PSD.shape[0]/10)):
        
        period = PSD[i*10 : np.min((i*10+10, PSD.shape[0])), :]
        
        avg = np.zeros(period.shape[1])
        
        for col in range(period.shape[1]):
            avg[col] = np.mean(period[:,col])
            
        average.append(avg.tolist())
        
    average = np.array(average)
    
    return average


PSD_Comb10s = {}
LWC10s = {}
Time10s = {}
HMS10s = {}

for date in dates:

    PSD_Comb10s[date] = avg10s(PSD_Comb[date])    
    LWC10s[date] = calc_LWC(PSD_Comb10s[date],binComb,binComb_dD)
    
    Time10s[date] = Time[date][0:-1:10]
    HMS10s[date] = HMS[date][0:-1:10]
    
UIUC_Comb10s = avg10s(UIUC_Comb)
UIUC_LWC10s = calc_LWC(UIUC_Comb10s,binComb,binComb_dD)
            
# Total Concentration of 10s Averages
PSD_Comb10sTotConc = []
UIUC_Comb10sTotConc = []

for row in PSD_Comb10s['2011 04 27']:
    total = 0
    i = 0
    for col in row:
        total = total + col*(binComb_dD[i]*10**-3)
    PSD_Comb10sTotConc.append(total)
    
for row in UIUC_Comb10s:
    total=0
    i = 0
    for col in row:
        total = total + col*(binComb_dD[i]*10**-3)
    UIUC_Comb10sTotConc.append(total)
    
PSD_Comb10sTotConc = np.array(PSD_Comb10sTotConc)
for date in dates:
    LWC10s[date] = np.array(LWC10s[date])
ratio_Conc = PSD_Comb10sTotConc/UIUC_Comb10sTotConc
ratio_LWC = LWC10s['2011 04 27']/UIUC_LWC10s

extrema = []

for i in range(ratio_LWC.shape[0]):
    if (ratio_LWC[i] < 0.5 or ratio_LWC[i] > 1.5) and np.isnan(ratio_LWC[i])==False:
        extrema.append({'LWC Ratio:': ratio_LWC[i], 'LWC NCAR': LWC10s['2011 04 27'][i], 'LWC UIUC': UIUC_LWC10s[i],
                        'NCAR':PSD_Comb10s['2011 04 27'][i,:],'UIUC':UIUC_Comb10s[i,:]})
                        


print('Done.')

#%% Comparison Plots

plot = 0

if plot == 1:
    
    print('Plotting Comparisons...',end='')
    
    UIUC_LWC10sgcm = UIUC_LWC10s*.001 # grams per cubic cm
    LWC10sgcm = LWC10s['2011 04 27']*.001
    
    fig,ax = plt.subplots(figsize=(26.67,15))
    
    ax.scatter(LWC10s['2011 04 27'],UIUC_LWC10s)
    #ax.scatter(UIUC_Comb10sTotConc,UIUC_LWC10s,color='r',label='UIUC')
    
    ax.set_xlabel('NCAR LWC [$kg\ m^{-3}$]',fontsize=24)
    ax.set_ylabel('UIUC LWC [$kg\ m^{-3}$]',fontsize=24)
    ax.set_xlim(xmin=0)
    ax.set_ylim(ymin=0)
    ax.set_title('NCAR vs UIUC, LWC',fontsize=28)
    ax.tick_params(labelsize=20)
    ax.legend(fontsize=30)
    
    fig.savefig('2011 04 27 NCAR vs UIUC LWC.png')
    
    fig,ax = plt.subplots(figsize=(26.67,15))
    
    #ax.scatter(UIUC_LWC10s,LWC10s['2011 04 27'],color='b',label='NCAR')
    ax.scatter(PSD_Comb10sTotConc,UIUC_Comb10sTotConc)
    
    ax.set_xlabel('NCAR Total Concentration [$m^{-3}$]',fontsize=24)
    ax.set_ylabel('UIUC Total Concentration [$m^{-3}$]',fontsize=24)
    ax.set_xlim(xmin=0)
    ax.set_ylim(ymin=0)
    ax.set_title('NCAR vs UIUC Total Concentration',fontsize=28)
    ax.tick_params(labelsize=20)
    ax.legend(fontsize=30)
    
    fig.savefig('2011 04 27 NCAR vs UIUC Total Concentration.png')


    print('Done.')
    

#%% Get random values for indexing
np.random.seed(0)
n = 20
rand = np.random.random_integers(0,UIUC_2DC.shape[0]-1,n)

#%% UIUC vs NCAR 2DC 2011 04 27

UIUC_Sample = UIUC_2DC[rand,:]
NCAR_Sample = PSD_2DC['2011 04 27'][rand,:]
Time_Sample = Time['2011 04 27'][rand]
HMS_Sample = HMS['2011 04 27'][rand]

temp1 = []
temp2 = []
for i in range(n):
    if sum(UIUC_Sample[i,:]) != 0:
        temp1.append(UIUC_Sample[i,:])
    if sum(NCAR_Sample[i,:]) != 0:
        temp2.append(NCAR_Sample[i,:])
UIUC_Sample = temp1
NCAR_Sample = temp2

plot = 0

if plot == 1:

    fig,ax = plt.subplots(figsize=(26.67,15))
    
    x1 = np.zeros_like(UIUC_Sample)
    x2= np.zeros_like(NCAR_Sample)
    for i in range(len(UIUC_Sample)):
        x1[i,:] = bin2DC
    for i in range(len(NCAR_Sample)):
        x2[i,:] = bin2DC
    
    ax.scatter(x1,UIUC_Sample,color='b',alpha=0.75,s=50)
    ax.scatter(x2,NCAR_Sample,color='r',alpha=0.75,s=50)
    
    ax.tick_params(labelsize=subsize)
    ax.set_xlabel('Diameter [mm]',fontsize = size)
    ax.set_ylabel('$log_{10}(N(D))$',fontsize = size)
    ax.set_title('UIUC vs NCAR 2DC Comparison Random Distributions',fontsize = size)
    
    fig.savefig('UIUC vs NCAR 2DC Comparison Random Distributions.png')

export = 0

if export == 1:

    time_out = []
    for i in range(n):
        time_out.append((Time_Sample[i],HMS_Sample[i]))
    
    with open(path + 'Random Sample.txt', 'w') as file:
        file.write('Time        HHMMSS\n')
        for time,hms in time_out:
            file.write('{Time}    {HHMMSS}\n'.format(Time=time, HHMMSS = hms))
            


#%% End
print('End.')
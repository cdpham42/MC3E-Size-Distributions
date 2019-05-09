# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 13:08:09 2016

@author: Casey
"""
#%% Initialization

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

comp = 0 # 0 = laptop, else desktop

if comp == 0:
    path = r'C:\Users\cdpha\Google Drive\Research\Python\\'
else:
    path = r'C:\Users\Casey Pham\Google Drive\Research\Python\\'
    
data_path = path+'data\\'

#%% Needed data

dates = ['2011 04 22','2011 04 25','2011 04 27','2011 05 01','2011 05 10',\
'2011 05 11','2011 05 18','2011 05 20','2011 05 23','2011 05 24','2011 05 27',\
'2011 05 30','2011 06 01-1','2011 06 01-2','2011 06 02']

types = ['2DC','CIP','HVPS','Combined Spectrum','Meta']

headersMC3E = {}

with open(data_path+'Headers.csv') as f:
    reader = csv.reader(f,delimiter=',')
    rownum = 0
    for row in reader:
        headersMC3E[types[rownum]] = row
        rownum += 1

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

#%% Read Reprocessed NCAR Ice/Water

datesNCAR = ['2011 04 27','2011 05 20']
typesNCAR = ['2DC','CIP','HVPS']
phasesNCAR = ['Ice','Water']

NCAR = {}

for date in datesNCAR: # Loop through dates
    NCAR[date] = {}
    
    for p in phasesNCAR: # Loop through Ice/Water
        NCAR[date][p] = {}
        
        for t in typesNCAR: # Loop through files (2DC, CIP, HVPS, etc.)
        
            NCAR[date][p][t] = []
            file = data_path+date+' '+p+' '+t+'.csv'
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
                
                NCAR[date][p][t] = content # Set date's data to be the file:content
      
      
for date in NCAR:
    for phase in NCAR[date]:
        for file in NCAR[date][phase]:
            NCAR[date][phase][file] = np.array(NCAR[date][phase][file])
            NCAR[date][phase][file] = NCAR[date][phase][file][NCAR[date][phase][file][:,0] != 0]


PSD_NCAR = {}

for date in datesNCAR:
    PSD_NCAR[date] = {}
    for phase in phasesNCAR:
        PSD_NCAR[date][phase] = {}
        for t in typesNCAR:
            PSD_NCAR[date][phase][t] = NCAR[date][phase][t][:,2::]
            
#%% Reprocessed NCAR Ice/Water Comparison Distributions

bins = {}
bins['2DC'] = np.array(bin2DC,ndmin=2)
bins['CIP'] = np.array(binCIP,ndmin=2)
bins['HVPS'] = np.array(binHVPS,ndmin=2)

size = 40
subsize = 20

savepath = path+'NCAR Ice Water Plots//'

plot = 0

if plot == 1:
    
    for date in datesNCAR:
        for t in typesNCAR:
                
                fig,[ax1,ax2] = plt.subplots(1,2,figsize=(26.67,15))
                
                x = np.zeros_like(PSD_NCAR[date]['Ice'][t])
        
                if len(x.shape)>1:
                    for i in range(x.shape[0]):
                        x[i,:] = bins[t]
                y1 = np.log10(PSD_NCAR[date]['Ice'][t])
                y2 = np.log10(PSD_NCAR[date]['Water'][t])
                
                ax1.scatter(x,y1)
                ax2.scatter(x,y2)
                
                ax1.set_xlabel('Diameter [mm]',fontsize = size)
                ax1.set_ylabel('$log_{10}(N(D))$',fontsize = size)
                ax1.set_title(t + ' Ice',fontsize = size)
                ax1.tick_params(axis='both', labelsize=subsize)
                
                ax2.set_xlabel('Diameter [mm]',fontsize = size)
                ax2.set_ylabel('$log_{10}(N(D))$]',fontsize = size)
                ax2.set_title(t + ' Water',fontsize = size)
                ax2.tick_params(axis='both', labelsize=subsize)
                
                if not t=='HVPS':
                    ax1.set_xlim((0,2))
                    ax2.set_xlim((0,2))
                if t=='HVPS':
                    ax1.set_xlim((0,12))
                    ax2.set_xlim((0,12))
                ax1.set_ylim((2,11))
                ax2.set_ylim((2,11))
                
                fig.savefig(savepath+date+' NCAR Ice vs Water '+t)
                plt.close(fig)
            
#%% Probe Averages

PSD_NCAR_avg = {}
PSD_NCAR_log = {}
PSD_NCAR_log_avg = {}

for d in datesNCAR:
    PSD_NCAR_avg[d] = {}
    PSD_NCAR_log[d] = {}
    PSD_NCAR_log_avg[d] = {}
    
    for p in phasesNCAR:
        PSD_NCAR_avg[d][p] = {}
        PSD_NCAR_log[d][p] = {}
        PSD_NCAR_log_avg[d][p] = {}
        
        for t in typesNCAR:
            PSD_NCAR_log[d][p][t] = np.log10(PSD_NCAR[d][p][t])
            for x in range(PSD_NCAR_log[d][p][t].shape[0]):
                for y in range(PSD_NCAR_log[d][p][t].shape[1]):
                    if np.isinf(PSD_NCAR_log[d][p][t][x,y]):
                        PSD_NCAR_log[d][p][t][x,y] = 0
            
            avg = np.zeros((1,PSD_NCAR[d][p][t].shape[1]))
            
            log_avg = np.zeros((1,PSD_NCAR[d][p][t].shape[1]))
            
            for col in range(PSD_NCAR[d][p][t].shape[1]):
                avg[0,col] = np.mean(PSD_NCAR[d][p][t][:,col])
                log_avg[0,col] = np.mean(PSD_NCAR_log[d][p][t][:,col])
                
            PSD_NCAR_avg[d][p][t] = avg
            PSD_NCAR_log_avg[d][p][t] = log_avg
            
            
plot = 0

if plot == 1:
    for d in datesNCAR:
        for t in typesNCAR:
            
            fig,[ax1,ax2] = plt.subplots(1,2,figsize=(26.67,15))
            
            ax1.plot(bins[t],np.log10(PSD_NCAR_avg[d]['Ice'][t]),'b-o')
#            ax1.plot(bins[t],PSD_NCAR_log_avg[d]['Ice'][t],'b-o')
            
            ax2.plot(bins[t],np.log10(PSD_NCAR_avg[d]['Water'][t]),'b-o')
#            ax2.plot(bins[t],PSD_NCAR_log_avg[d]['Water'][t],'b-o')
            
            ax1.set_xlabel('Diameter [mm]',fontsize = size)
            ax1.set_ylabel('$log_{10}(N(D))$',fontsize = size)
            ax1.set_title(t + ' Ice',fontsize = size)
            ax1.tick_params(axis='both', labelsize=subsize)
            
            ax2.set_xlabel('Diameter [mm]',fontsize = size)
            ax2.set_ylabel('$log_{10}(N(D))$]',fontsize = size)
            ax2.set_title(t + ' Water',fontsize = size)
            ax2.tick_params(axis='both', labelsize=subsize)
            
            if not t=='HVPS':
                ax1.set_xlim((0,2))
                ax2.set_xlim((0,2))
            if t=='HVPS':
                ax1.set_xlim((0,12))
                ax2.set_xlim((0,12))
            ax1.set_ylim((2,11))
            ax2.set_ylim((2,11))
            
            fig.savefig(savepath+d+' NCAR Ice vs Water '+t+' Average')
            plt.close(fig)

#%% Combined Spectrum for Ice and Water

Comb = {}

for date in datesNCAR:
    
    Comb[date] = {}
    
    Comb[date]['Ice'] = np.concatenate((PSD_NCAR[date]['Ice']['2DC'][:,:14],PSD_NCAR[date]['Ice']['HVPS'][:,4:]),axis=1)

    Comb[date]['Water'] = np.concatenate((PSD_NCAR[date]['Water']['2DC'][:,:14],PSD_NCAR[date]['Water']['HVPS'][:,4:]),axis=1)

#%% Normalization Parameters

print('Calculating Normalization Parameters...',end='')

Dm = {}
LWC = {}
No = {}
logNo = {}
Rate = {}

for date in datesNCAR:
    
    Dm[date] = {}
    LWC[date] = {}
    No[date] = {}
    logNo[date] = {}
    Rate[date] = {}

    for phase in phasesNCAR:
    
        Dm[date][phase] = np.zeros((Comb[date][phase].shape[0],1))
        LWC[date][phase] = np.zeros((Comb[date][phase].shape[0],1))
        No[date][phase] = np.zeros((Comb[date][phase].shape[0],1))
        logNo[date][phase] = np.zeros((Comb[date][phase].shape[0],1))
        
        for i in range(Comb[date][phase].shape[0]): # Go through rows
            
            # LWC
            tot = 0 # Summation total
            
            # Dm
            top = 0
            bot = 0
            
            for j in range(Comb[date][phase].shape[1]): # Go through columns
                # LWC
                tot = tot + Comb[date][phase][i,j]*binComb[j]**3*binComb_dD[j]
                
                # Dm
                top = top + Comb[date][phase][i,j]*binComb[j]**4*binComb_dD[j]
                bot = bot + Comb[date][phase][i,j]*binComb[j]**3*binComb_dD[j]
            
            LWC[date][phase][i] = (math.pi*1000/6)*tot
            Dm[date][phase][i] = top/bot
            No[date][phase][i] = (4**4/(math.pi*1000))*(LWC[date][phase][i]/Dm[date][phase][i]**4)
            logNo[date][phase][i] = np.log10(No[date][phase][i])
            
        Rate[date][phase] = np.zeros((Comb[date][phase].shape[0],1))
        Vt = [970.5208*(1-math.exp( -( (D*0.1)/0.177 )**1.147) ) for D in binComb] # Convert diameters to cm
        Vt = np.array(Vt)
        Vt = Vt*.01 # Convert to m/s
        
        for i in range(Comb[date][phase].shape[0]): # Rows
            R = 0
            for j in range(Comb[date][phase].shape[1]): # Columns
                R = R + Comb[date][phase][i,j]*(binComb[j]*0.001)**3*Vt[j]*(math.pi/6)*(binComb_dD[j]*0.001)
                
            Rate[date][phase][i] = R*3600000

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

Testud_Comb = {}
Testud_Dm = {}
Testud_No = {}
Testud_logNo = {}
Testud_Rate = {}

for date in datesNCAR:
    
    Testud_Comb[date] = {}
    Testud_Dm[date] = {}
    Testud_No[date] = {}
    Testud_logNo[date] = {}
    Testud_Rate[date] = {}
    
    for phase in phasesNCAR:
        
        Testud_Comb[date][phase] = TestudRainrate(Rate[date][phase],Comb[date][phase])
        Testud_Dm[date][phase] = TestudRainrate(Rate[date][phase],Dm[date][phase])
        Testud_No[date][phase] = TestudRainrate(Rate[date][phase],No[date][phase])
        Testud_logNo[date][phase] = TestudRainrate(Rate[date][phase],logNo[date][phase])
        Testud_Rate[date][phase] = TestudRainrate(Rate[date][phase],Rate[date][phase])
        
print('Done.')

#%% Average by rainrate and calcuations

def average(data, dbin, dbin_dD):
    
    # Pass in a tuple of 3 values/arrays for data, indices 0,1,2 corresponding to rainrates
    
    data_avg = np.zeros((3,len(dbin)))
    
    for j in range(len(dbin)):
        for i in range(3):
            if data[i].size: # Test for empty array
                temp = []
                for k in data[i][:,j]:
                    if k != 0:
                        temp.append(k)
                    
                        data_avg[i,j] = np.mean(temp)
                    else:
                        data_avg[i,j] = 0
                    
    LWC = {}
    Dm = {}
    No = {}
    logNo = {}
    
    Dm = np.zeros((data_avg.shape[0],1))
    LWC = np.zeros((data_avg.shape[0],1))
    No = np.zeros((data_avg.shape[0],1))
    logNo = np.zeros((data_avg.shape[0],1))
    
    for i in range(data_avg.shape[0]): # Row
        
        # LWC
        tot = 0
        
        # Dm
        top = 0
        bot = 0
        
        for j in range(data_avg.shape[1]): # Column
            # LWC
            tot = tot + data_avg[i,j]*dbin[j]**3*dbin_dD[j]
            
            # Dm
            top = top + data_avg[i,j]*dbin[j]**4*dbin_dD[j]
            bot = bot + data_avg[i,j]*dbin[j]**3*dbin_dD[j]
        
        LWC[i] = (math.pi*1000/6)*tot
        Dm[i] = top/bot
        No[i] = (4**4/(math.pi*1000))*(LWC[i]/Dm[i]**4)
        logNo[i] = np.log10(No[i])
            
    Rate = {}
    
    Vt = [970.5208*(1-math.exp( -( (D*0.1)/0.177 )**1.147) ) for D in dbin] # Convert diameters to cm
    Vt = np.array(Vt)
    Vt = Vt*.01 # Convert to m/s
    
    
    Rate = np.zeros((data_avg.shape[0],1))
    
    for i in range(data_avg.shape[0]):
        R = 0
        for j in range(data_avg.shape[1]):
            R = R + data_avg[i,j]*(dbin[j]*0.001)**3*Vt[j]*(math.pi/6)*(dbin_dD[j]*0.001)
            
        Rate[i] = R*3600000
            
    
    data_avg = tuple(data_avg)
    LWC = tuple(LWC)
    Dm = tuple(Dm)
    No = tuple(No)
    logNo = tuple(logNo)
    Rate = tuple(Rate)
    
    return {'Avg':data_avg,'LWC':LWC,'Dm':Dm,'No':No,'logNo':logNo,'Rate':Rate}
    
Testud_Comb_avg = {}

for date in datesNCAR:
    Testud_Comb_avg[date] = {}
    for phase in phasesNCAR:
        Testud_Comb_avg[date][phase] = average(Testud_Comb[date][phase],binComb,binComb_dD)

#%% Statistics Plots

def stat_plot(ND,D,No,Dm,R,date,rate,phase):
    
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

    ax[2,1].set_ylim([2,11])
    
    ax[2,1].set_xlim(left=0)
    ax[2,1].set_xlim([0,14])
    
#    ax[2,1].set_xscale('log')
#    ax[2,1].tick_params(axis='x', which='minor')
    
    ax[2,1].tick_params(axis='both', labelsize=subsize)

    
    
    # Whisker plot of D/Dm vs log_10(N(D)/No*)
    
    # Save figure
    fig.suptitle('Statistics '+date+' '+rate+' '+phase,fontsize=size)
    
    fig.savefig(savepath+'Statistics '+date+' '+rate+' '+phase)
    plt.close(fig)
    
plot = 1

if plot == 1:
    
    print('Plotting Statistics...',end='')
    
    for date in datesNCAR:
        for phase in phasesNCAR:
            for i in range(3):
                stat_plot(Testud_Comb[date][phase][i],binComb,\
                Testud_No[date][phase][i],\
                Testud_Dm[date][phase][i],\
                Testud_Rate[date][phase][i],\
                date,rates[i],phase)

plot = 1

if plot == 1:
    
    print('Plotting Averaged Statistics...',end='')
    
    for date in datesNCAR:
        for phase in phasesNCAR:
            for i in range(3):
                stat_plot(Testud_Comb_avg[date][phase]['Avg'][i],binComb,\
                Testud_Comb_avg[date][phase]['No'][i],\
                Testud_Comb_avg[date][phase]['Dm'][i],\
                Testud_Comb_avg[date][phase]['Rate'][i],\
                'Average '+date,rates[i],phase)
#%% Compare New Ice Processing to Old Data


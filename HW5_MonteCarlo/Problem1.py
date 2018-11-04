# -*- coding: utf-8 -*-
"""
Created on Sat Nov  3 16:59:40 2018

@author: Osmaan
"""

from matplotlib import pyplot
import numpy as np

# Part 1
# Hit and miss Monte Carlo integration
ngroups = 16                                 # Number of repeats of code
N = np.zeros(ngroups)                        # Initialize value of acceptances

ILCG = np.zeros(ngroups)                     # Initialize value of integral
ELCG = np.zeros(ngroups)                     # Initialize value of errors

IIBM = np.zeros(ngroups)                     # Initialize value of integral
EIBM = np.zeros(ngroups)                     # Initialize value of errors

n0 = 100                                     # Number of fxn evaluations

x0 = 1     # Seed
a = 5      # Multiplier
c = 0      # Increment
m = 11     # Modulus


for i in range(ngroups):

    N[i] = n0                                # For this cycle, this many fxn evals
    
    # Define x-axis for the linear congruential generator (LCG)
    xLCG = np.zeros(n0)                      # Set all zeros
    xLCG[0] = x0                             # Seed is first value
    for p in range(n0-1):                    # For all values,
        xLCG[p+1] = (a*xLCG[p] + c)%m        # Define next value
    xLCG = xLCG/10                           # Scale so 0 < x < 1
    
    # Define x-axis for the IBM's random number generator
    xIBM = np.zeros(n0)                      # Set all zeros
    xIBM[0] = x0                             # Seed is first value
    for p in range(n0-1):                    # For all values,
        xIBM[p+1] = (65539*xIBM[p])%(2**31)  # Define next value
    xIBM = xIBM/(10**9)                      # Scale so 0 < x < 1
    
    yLCG = np.random.random(n0)              # y-axis for LCG
    yIBM = np.random.random(n0)              # y-axis for IBM
    
    ILCG[i] = 0.                             # Set i-th integral value to 0
    IIBM[i] = 0.                             # Set i-th integral value to 0
    
    NLCG = 0                                 # Initialize number of hits to 0
    NIBM = 0                                 # Initialize number of hits to 0
    
    for j in range(n0-1):                    # For all x,
        if(yLCG[j] < np.sqrt(1-xLCG[j]**2)): # LCG: if y is in the area,
            NLCG += 1                        # count as a hit
        if(yIBM[j] < np.sqrt(1-xIBM[j]**2)): # IBM: if y is in the area,
            NIBM += 1                        # count as a hit
            
    ILCG[i] = 4.*float(NLCG)/float(n0)       # LCG: Calculate integral
    ELCG[i] = abs(ILCG[i]-np.pi)             # LCG: Calculate error
    
    IIBM[i] = 4.*float(NIBM)/float(n0)       # IBM: Calculate integral
    EIBM[i] = abs(IIBM[i]-np.pi)             # IBM: Calculate error
     
    print (n0,NLCG,NIBM,ILCG[i],IIBM[i])     # Print values
    n0 *= 2                                  # Double length of x-axis
    
pyplot.figure(1)
pyplot.plot(N,ELCG,ls='-',c='red',lw=3);
pyplot.plot(N,EIBM,ls='-',c='black',lw=3);
pyplot.plot(N,1/np.sqrt(N),ls='-',c='blue',lw=3);
pyplot.xscale('log')
pyplot.yscale('log')

pyplot.figure(2)
pyplot.plot(N,ILCG)
pyplot.plot(N,IIBM)
pyplot.xscale('log')








# Part 2
# Simple Monte Carlo Integration
ngroups = 16                                 # Number of repeats of code
N = np.zeros(ngroups)                        # Initialize value of acceptances

ILCG = np.zeros(ngroups)                     # Initialize value of integral
ELCG = np.zeros(ngroups)                     # Initialize value of errors

IIBM = np.zeros(ngroups)                     # Initialize value of integral
EIBM = np.zeros(ngroups)                     # Initialize value of errors

n0 = 100                                     # Number of fxn evaluations

for i in range(ngroups):

    N[i] = n0                                # For this cycle, this many fxn evals
    
    # Define x-axis for the linear congruential generator (LCG)
    xLCG = np.zeros(n0)                      # Set all zeros
    xLCG[0] = x0                             # Seed is first value
    for p in range(n0-1):                    # For all values,
        xLCG[p+1] = (a*xLCG[p] + c)%m        # Define next value
    xLCG = xLCG/max(xLCG)                   # Scale so 0 < x < 1
    
    # Define x-axis for the IBM's random number generator
    xIBM = np.zeros(n0)                      # Set all zeros
    xIBM[0] = x0                             # Seed is first value
    for p in range(n0-1):                    # For all values,
        xIBM[p+1] = (65539*xIBM[p])%(2**31)  # Define next value
    xIBM = xIBM/max(xIBM)                    # Scale so 0 < x < 1
    
    ILCG[i] = 0.                             # Set i-th integral value to 0
    IIBM[i] = 0.                             # Set i-th integral value to 0
    
    for j in range(n0-1):
        ILCG[i] += np.sqrt(1-xLCG[j]**2)
        IIBM[i] += np.sqrt(1-xIBM[j]**2)
        
    ILCG[i] *= 4./float(n0)
    IIBM[i] *= 4./float(n0)
    ELCG[i] = abs(ILCG[i]-np.pi)
    EIBM[i] = abs(IIBM[i]-np.pi)
    print(n0,ILCG[i],IIBM[i],ELCG[i],EIBM[i])
    n0 *= 2
    
            
pyplot.figure(1)
pyplot.plot(N,ELCG,ls='-',c='red',lw=3);
pyplot.plot(N,EIBM,ls='-',c='black',lw=3);
pyplot.plot(N,1/np.sqrt(N),ls='-',c='blue',lw=3);
pyplot.xscale('log')
pyplot.yscale('log')

pyplot.figure(2)
pyplot.plot(N,ILCG,c='red')
pyplot.plot(N,IIBM,c='black')
pyplot.xscale('log')







# Part 3 and Part 4
n0 = 100000
I = np.zeros(n0)
r = np.random.random(n0)
for j in range(n0):
    x = r[j]
    I[j] = 4*np.sqrt(1-x**2)

def group_measurements(ngroups):
    global I,n0
    
    nmeasurements = n0/ngroups
    for n in range(ngroups):
        Ig = 0.
        Ig2 = 0.
        for i in range(int(n*nmeasurements),int((n+1)*nmeasurements)):
            Ig += I[i]
            Ig2 += I[i]**2
        Ig /= nmeasurements
        Ig2 /= nmeasurements
        sigma = Ig2-Ig**2
        print(Ig,Ig2,sigma)
        
group_measurements(10)
print("=============================")
group_measurements(20)
print("=============================")
group_measurements(1)





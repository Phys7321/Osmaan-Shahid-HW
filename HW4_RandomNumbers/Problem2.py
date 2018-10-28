# -*- coding: utf-8 -*-
"""
Created on Sat Oct 27 11:19:51 2018

@author: Osmaan
"""

import numpy as np
from matplotlib import pyplot
import time



N = 100000

x = np.zeros(N)
delta = [1, 2, 3, 4, 5, 6, 7, 8, 9]
times = []
sigma = 10.
sigma2 = sigma**2

def metropolis(xold,d):                                     # xold = initial guess
    xtrial = np.random.random()                           # Single random number
    xtrial = xold+(2*xtrial-1)*float(delta[d-1])            #  
    weight = np.exp(-0.5*(xtrial**2-xold**2)/sigma2)      # Gaussian distribution
    xnew = xold                                           #
    if(weight >= 1):                   # Accept
        xnew = xtrial                  #
    else:                              # Otherwise
        r = np.random.random()         # Make new random number, r
        if(r <= weight):               # If new rand (r) < w, 
            xnew = xtrial              # Accept
    return xnew


# Only here to get a better starting point

xwalker = 20.
Nwarmup = 500000
for i in range(Nwarmup):
    xwalker = metropolis(xwalker,2)
###
x[0] = xwalker   # xwalker is a single float


for d in delta:
    start = time.process_time()
    x[0] = xwalker
    for i in range(1,N):
        x0 = x[i-1]
        for j in range(10):
            x0 = metropolis(x0,d)
            x[i] = metropolis(x0,d)
    end = time.process_time()
    times.append(end - start)
    
pyplot.plot(delta,times)
pyplot.xlabel('$\delta$')
pyplot.ylabel('Time')
pyplot.show()

pyplot.figure()    

binwidth=sigma/10
pyplot.hist(x,bins=np.arange(-50,50., binwidth),density=True);

norm = 1./(sigma*np.sqrt(2*np.pi))
pyplot.plot(np.arange(-50.,50.,binwidth),norm*np.exp(-0.5*np.arange(-50.,50.,binwidth)**2/sigma2),ls='-',c='red',lw=3);
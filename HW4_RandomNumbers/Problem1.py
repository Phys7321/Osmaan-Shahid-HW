# -*- coding: utf-8 -*-
"""
Created on Sat Oct 27 10:41:05 2018

@author: Osmaan
"""


'''

Will return later, but the text by Moler (Page 256) mentions the recursion relation
for all of the coefficients for the IBM Linear Congrential Random Number
Generator:
    
x_{k+2} = 6x_{k+1} - 9x_k

For k = 0,

x_2 = 6x_1 - 9 x_0

where x_0 is the seed and x_1 can be found by

x_1 = (ax_0 + c) mod M

so the rest of the sequence is completely determined, and each subsequent index
is highly correlated.

'''






#%matplotlib inline
import numpy as np
from matplotlib import pyplot

N = 1000
r = np.zeros(N+1)

# This is the infamous RANDU
a = 65539
M = 2**31


seed = 1.
r[0] = seed
for i in range(1,N+1):
    r[i] = (a*r[i-1])%M         # This follows r_i = (a*r_{i-1} + c) mod(M) 
        
r1 = np.zeros(int(N/2))
r2 = np.zeros(int(N/2))
for i in range(0,N,2):
    r1[int(i/2)] = float(r[i])/float(M)
    r2[int(i/2)] = float(r[i+1])/float(M)
    
pyplot.plot(r1,r2,marker='o',linestyle='None');
pyplot.show()
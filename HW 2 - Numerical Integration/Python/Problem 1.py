# Calculate electric potential V and field E for
# linear charge density L(x) = 2x, 0 < x < 1

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np

# Linear charge density
L = lambda x: 2*x

def FindPotential():
    xprime = np.linspace(0,1,10) # Describes x-coordinate of charge distribution
    yprime = np.linspace(0,0,10) # Describes y-coordinate of charge distribution
    x = np.linspace(-2,3,10) # Describes x-coordinate in space
    y = np.linspace(-2,2,10) # Describes y-coordinate in space
    for j in range(0,10):           # Sets the y-coordinate 
        for i in range(0,10):       # Sets the x-coordinate
            L = lambda xprime: 2*xprime[i]
            x_dist = x[j] - xprime[i]
            y_dist = y[j] - yprime[i]
            dist = math.sqrt( x_dist**2 + y_dist**2 )
            V[i,j] = sci.romberg(L/dist,0,1)




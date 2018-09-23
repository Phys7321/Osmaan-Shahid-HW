# Calculate electric potential V and field E for
# linear charge density L(x) = 2x, 0 < x < 1

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np

# Linear charge density
L = lambda x: 2*x

def FindPotential(N):
    V = [[0]*N for i in range(N)] # Potential is 2D array with 10 columns, 10 rows
    # xprime = np.linspace(0,1,10) # Describes x-coordinate of charge distribution
    # yprime = np.linspace(0,0,10) # Describes y-coordinate of charge distribution
    x = np.linspace(-0.5,1.5,N) # Describes x-coordinate in space
    y = np.linspace(-0.5,0.5,N) # Describes y-coordinate in space
    for j in range((N-1),-1,-1):           # Decreases in value 
        for i in range(0,N):               # Increases in value
            integrand = lambda z: 2*z/math.sqrt((x[i] - z)**2 + (y[j] - 0)**2)
            # x_dist = x[j] - xprime[i]
            # y_dist = y[j] - yprime[i]
            # dist = math.sqrt( x_dist**2 + y_dist**2 )
            V[i][j] = sci.romberg(integrand,0,1,divmax=20)
    cs = plt.pcolormesh(np.transpose(V))
    #cs = plt.pcolor(np.transpose(V))
    cb = plt.colorbar(cs, orientation = 'horizontal')
    plt.show()
    return V

"""
The function "HorizontalLinePotential" finds the potential V on the xy-axes due to a
linear charge density L(x) that is parallel to the x-axis. The left end of the rod is at
the point (xa,y0) and the right end of the rod is at the point (xb,y0).

The variables x and y are arrays that form the r vector in E&M - specifically, this function
finds the potential V at the points x and y, or V(x,y). You can choose the points over which to
find the potential: the x-axis goes from x1 to x2, and the y-axis goes from y1 to y2.

Below, we define the parameters for the function. The function will plot a 2D histogram of the potential.
"""

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np


# Linear charge density
L = lambda x: 2*x

# Physical dimenstions of the rod
xa = 0                # Left end of rod
xb = 1                # Right end of rod
y0 = 0                # Displacement of rod from x-axis

# Form the r vector, or the sampling space
x1 = -0.5
x2 = 1.5
y1 = -0.5
y2 = 0.5

# Number of data points
N = 100

def HorizontalLinePotential():
    V = [[0]*N for i in range(N)]              # Potential is 2D array with N columns, N rows
    x = np.linspace(x1,x2,N)                   # Describes x-coordinate in space
    y = np.linspace(y1,y2,N)                   # Describes y-coordinate in space
    for j in range((N-1),-1,-1):               # Decreases in value 
        for i in range(0,N):                   # Increases in value
            integrand = lambda z: 2*z/math.sqrt((x[i] - z)**2 + (y[j] - y0)**2)
            V[i][j] = sci.romberg(integrand,xa,xb,divmax=20)
    cs = plt.pcolormesh(np.transpose(V))
    #cs = plt.pcolor(np.transpose(V))
    plt.colorbar(cs, orientation = 'horizontal')
    plt.show()
    return V


# Carry out the function for the previously defined values
# HorizontalLinePotential()



# Now find the electric field, E = - (dV/dx, dV/dy, dV/dz)
V = HorizontalLinePotential()
#x = np.linspace(x1,x2,N)                   # Describes x-coordinate in space
#y = np.linspace(y1,y2,N)                   # Describes y-coordinate in space
#Ex = - np.diff(V)/np.diff(x)
#Ey = - np.diff(V)/np.diff(y)
#plt.quiver(Ex,Ey)
#plt.show

E = np.gradient(np.transpose(V))
plt.quiver(-1*E[0],-1*E[1])
plt.show()

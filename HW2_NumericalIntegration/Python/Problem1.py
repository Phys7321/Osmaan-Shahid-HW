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

# Number of data points
N = 100

# Physical dimenstions of the rod
xa = 0                # Left end of rod
xb = 1                # Right end of rod
y0 = 0                # Displacement of rod from x-axis

# Form the r vector, or the sampling space
x1 = -0.5
x2 = 1.5
y1 = -0.5
y2 = 0.5

x = np.linspace(x1,x2,N)
y = np.linspace(y1,y2,N)

def HorizontalLinePotential():
    V = np.zeros((N,N))              # Potential is 2D array with N columns, N rows
    for j in range(0,N):                       # Sum over y values 
        for i in range(0,N):                   # Sum over x values
            integrand = lambda z: 2*z/math.sqrt((x[i] - z)**2 + (y[j] - y0)**2)
            V[i][j] = sci.romberg(integrand,xa,xb,divmax=20)
    return V

# Define V as electric potential
V = np.transpose(HorizontalLinePotential())

# Prepare the heatmap for the potential using plt.pcolormesh
plt.figure(1)
Vfig = plt.pcolormesh(x,y,V)
plt.colorbar(Vfig, orientation = 'horizontal')

# Now find the electric field, E = - (dV/dx, dV/dy, dV/dz)
E = np.negative(np.gradient(V))
Ex, Ey = E[0], E[1]

# Prepare the 2D electric field using plt.quiver
plt.figure(2)
plt.quiver(x,y,Ey,Ex,np.arctan2(Ex,Ey))

# Plot both of them on separate graphs
plt.show([1,2])

"""
The function "HorizontalLinePotential" finds the potential V on the xy-axes due to a
linear charge density L(x) that is parallel to the x-axis. The left end of the rod is at
the point (xa,y0) and the right end of the rod is at the point (xb,y0).
The variables x and y are arrays that form the r vector in E&M - specifically, this function
finds the potential V at the points x and y, or V(x,y). You can choose the points over which to
find the potential: the x-axis goes from x1 to x2, and the y-axis goes from y1 to y2.

The function "VerticalLinePotential" finds the potential V on the xy-axes due to a
linear charge density L(x) that is parallel to the y-axis. The lower end of the rod is at
the point (x0,ya) and the higher end of the rod is at the point (x0,yb).
The variables x and y are arrays that form the r vector in E&M - specifically, this function
finds the potential V at the points x and y, or V(x,y). You can choose the points over which to
find the potential: the x-axis goes from x1 to x2, and the y-axis goes from y1 to y2.

The function "TotalPotential" combines both of these in order to complete the assignment.

Below, we define the parameters for the function. The function will plot a 2D histogram of the potential.
"""

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np


# Linear charge density
Lx = lambda x: x**2
Ly = lambda y: y

# Number of data points
N = 100

# Physical dimenstions of the rods
# Horizontal rod
xa = 0                 # Left end of rod
xb = 1                 # Right end of rod
y0 = 0                 # Displacement of rod from x-axis

# Vertical rod
ya = 1                 # Lower end of rod
yb = 2                 # Higher end of rod
x0 = 0                 # Displacement of rod from y-axis

# Form the r vector, or the sampling space
x1 = -1.25
x2 = 1.25
y1 = -0.25
y2 = 2.25

x = np.linspace(x1,x2,N)
y = np.linspace(y1,y2,N)

def HorizontalLinePotential():
    Vx = np.zeros((N,N))               # Potential is 2D array with N columns, N rows
    for j in range(0,N):               # Sum over y values 
        for i in range(0,N):           # Sum over x values
            integrand = lambda xp: xp**2/math.sqrt((x[i] - xp)**2 + (y[j] - y0)**2)
            Vx[i][j] = sci.romberg(integrand,xa,xb,divmax=20)
    return Vx


def VerticalLinePotential():
    Vy = np.zeros((N,N))              # Potential is 2D array with N columns, N rows
    for j in range(0,N):              # Sum over y values 
        for i in range(0,N):          # Sum over x values
            integrand = lambda yp: yp/math.sqrt((x[i] - x0)**2 + (y[j] - yp)**2)
            Vy[i][j] = sci.romberg(integrand,ya,yb,divmax=20)
    return Vy


# TotalLinePotential()
Vx = np.transpose(HorizontalLinePotential())
Vy = np.transpose(VerticalLinePotential())
V = Vx + Vy

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

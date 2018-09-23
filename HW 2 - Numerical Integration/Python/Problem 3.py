"""
The function "CylindricalPotential" finds the potential V on the xy-axes due to a
surface charge density S(x) that is in the xy-plane. The center of the circle is at r0.

The variables r and t are arrays that form the r vector in E&M - specifically, this function
finds the potential V at the points r and theta, or V(r,theta). You can choose the points over which to
find the potential: the x-axis goes from x1 to x2, and the y-axis goes from y1 to y2.

Below, we define the parameters for the function. The function will plot a 2D histogram of the potential.
"""

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np


# Linear charge density
S = lambda r,t: r*math.cos(t)

# Physical dimenstions of the surface
r0 = 0                # Center of circle
R = 2                 # Radius of circle

# Form the r vector, or the sampling space
r1 = 0
r2 = 2.5
t1 = 0
t2 = 2*math.pi

# Number of data points
N = 100

def CylindricalPotential():
    V = [[0]*N for i in range(N)]              # Potential is 2D array with N columns, N rows
    r = np.linspace(r1,r2,N)                   # Describes r-coordinate in space
    t = np.linspace(t1,t2,N)                   # Describes theta-coordinate in space
    for j in range((N-1),-1,-1):               # Decreases in value 
        for i in range(0,N):                   # Increases in value
            integrand = lambda z,w: (w**2)*math.cos(z)/math.sqrt((r[j] - w)**2)
            slop = sci.dblquad(integrand,0,2,0,2*math.pi)
            V[i][j] = slop[0]
    r_grid, t_grid = np.meshgrid(r,t)
    #x, y = r_grid*np.cos(t_grid), r_grid*np.sin(t_grid)
    plt.subplot(projection="polar")
    cs = plt.pcolormesh(t_grid, r_grid, V)
    #cs = plt.pcolor(np.transpose(V))
    plt.colorbar(cs, orientation = 'horizontal')
    plt.show()
    return V


# Carry out the function for the previously defined values
CylindricalPotential()

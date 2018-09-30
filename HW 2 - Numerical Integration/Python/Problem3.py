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

# Number of data points
N = 20

# Physical dimenstions of the surface
r0 = 0                # Center of circle
R = 2                 # Radius of circle

# Form the r vector, or the sampling space
r1 = 0
r2 = 2.5
t1 = 0
t2 = 2*math.pi

r = np.linspace(r1,r2,N)                   # Describes r-coordinate in space
t = np.linspace(t1,t2,N)                   # Describes theta-coordinate in space

def CylindricalPotential():
    V = np.zeros((N,N))        # Potential is 2D array with N columns, N rows
    count = 0
    for j in range(0,N):       # Sum over y values 
        for i in range(0,N):   # Sum over x values
            count += 1
            integrand = lambda theta,rad: (rad**2)*math.cos(theta)/math.sqrt(r[i]**2 + rad**2 - 2*r[i]*rad*math.cos(t[j] - theta) + 0.01)
            # Integrand is long because the denominator is the |r - r'| vector
            # in polar coordinates. Also, the +0.01 at the end allows us to
            # find the potential at a point directly above the surface, otherwise
            # the integral diverges.
            slop = sci.dblquad(integrand,r0,R, lambda rad: 0, lambda rad: 2*math.pi)
            V[i][j] = slop[0]
            print("Calculating step " + str(count) + " of " +str(N*N))
    return V


# Define V as electric potential
V = np.transpose(CylindricalPotential())

# Prepare the heatmap for the potential using plt.pcolormesh
plt.figure(1)
r_grid, t_grid = np.meshgrid(r,t)
plt.subplot(projection="polar")
Vfig = plt.pcolormesh(t_grid,r_grid,V)
plt.colorbar(Vfig, orientation = 'horizontal')

# Now find the electric field, E = - (dV/dx, dV/dy, dV/dz)
E = np.negative(np.gradient(V))
Ex, Ey = E[0], E[1]
Er = Ey*np.cos(t_grid) - Ex*np.sin(t_grid)
Et = Ey*np.sin(t_grid) + Ex*np.cos(t_grid) 

# Prepare the 2D electric field using plt.quiver
plt.figure(2)
plt.subplot(projection="polar")
plt.quiver(t_grid,r_grid,Er,Et,np.arctan2(Er,Et))

# Plot both of them on separate graphs
plt.show([1,2])

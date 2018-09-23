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

# Number of data points
N = 100

def HorizontalLinePotential():
    V = [[0]*N for i in range(N)]              # Potential is 2D array with N columns, N rows
    x = np.linspace(x1,x2,N)                   # Describes x-coordinate in space
    y = np.linspace(y1,y2,N)                   # Describes y-coordinate in space
    for j in range((N-1),-1,-1):               # Decreases in value 
        for i in range(0,N):                   # Increases in value
            integrand = lambda z: z**2/math.sqrt((x[i] - z)**2 + (y[j] - y0)**2)
            V[i][j] = sci.romberg(integrand,xa,xb,divmax=20)
    cs = plt.pcolormesh(np.transpose(V))
    #cs = plt.pcolor(np.transpose(V))
    plt.colorbar(cs, orientation = 'horizontal')
    plt.show()
    return V

def VerticalLinePotential():
    V = [[0]*N for i in range(N)]              # Potential is 2D array with N columns, N rows
    x = np.linspace(x1,x2,N)                   # Describes x-coordinate in space
    y = np.linspace(y1,y2,N)                   # Describes y-coordinate in space
    for j in range((N-1),-1,-1):               # Decreases in value 
        for i in range(0,N):                   # Increases in value
            integrand = lambda z: z**2/math.sqrt((x[i] - x0)**2 + (y[j] - z)**2)
            V[i][j] = sci.romberg(integrand,ya,yb,divmax=20)
    cs = plt.pcolormesh(np.transpose(V))
    #cs = plt.pcolor(np.transpose(V))
    plt.colorbar(cs, orientation = 'vertical')
    plt.show()
    return V

def TotalLinePotential():
    V = [[0]*N for i in range(N)]              # Potential is 2D array with N columns, N rows
    Vx = [[0]*N for i in range(N)]             # Potential due to horizontal line
    Vy = [[0]*N for i in range(N)]             # Potential due to vertical line
    x = np.linspace(x1,x2,N)                   # Describes x-coordinate in space
    y = np.linspace(y1,y2,N)                   # Describes y-coordinate in space
    for j in range((N-1),-1,-1):               # Decreases in value 
        for i in range(0,N):                   # Increases in value
            x_integrand = lambda z: z**2/math.sqrt((x[i] - z)**2 + (y[j] - y0)**2)
            y_integrand = lambda z: z/math.sqrt((x[i] - x0)**2 + (y[j] - z)**2)
            Vx[i][j] = sci.romberg(x_integrand,xa,xb,divmax=20)
            Vy[i][j] = sci.romberg(y_integrand,ya,yb,divmax=20)
    Vx = np.array(Vx)
    Vy = np.array(Vy)
    V = Vx + Vy
    V = V.tolist()
    cs = plt.pcolor(np.transpose(V))
    plt.colorbar(cs, orientation = 'horizontal')
    plt.show()
    return V


TotalLinePotential()

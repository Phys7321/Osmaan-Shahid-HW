"""
Do Challenge Problem 2.1 using the 4th order Range-Kutta method.
First we define the RK4 method, then we modify it for our Challenge Problem.
"""

import numpy as np
import math
import matplotlib.pyplot as plt





"""
Define the 4th order Range-Kutta method using Prof. Kelley's code
"""

def rk4(func,a,b,N):   # func is the derivative of y(x), which is f = dy/dx
     # a = Left boundary
     # b = Right boundary
     # N = Number of data points
    h = (b-a)/N    # Equal spacing between points

    xpoints = np.arange(a,b,h)      # Defines x axis
    ypoints = []                    # This will be filled with the values of y, what we're looking for

    y0 = 10                              # Initial value
    y = y0                               # Initial condition: y(a) = y on left boundary
    for x in xpoints:                    # Loop over all x-values
        ypoints.append(y)                # Fill the ypoints list as we integrate each step
        k1 = h*func(y,x)
        k2 = h*func(y+0.5*k1,x+0.5*h)
        k3 = h*func(y+0.5*k2,x+0.5*h)
        k4 = h*func(y+k3,x+h)
        y += (k1+2*k2+2*k3+k4)/6         # y at each point x is a weighted average of slopes

    plt.plot(xpoints,ypoints)   # Plot y(x) vs. x
    plt.xlabel("x")             # Label x-axis
    plt.ylabel("y(x)")          # Label y-axis
    plt.show()                  # Show plot
    #return xpoints             # Return x-axis




"""
Now we modify it and make it specific to our problem, Temperature as a fxn of time
"""

def rk4(func,a,b,N):   # func is the derivative of y(x), which is f = dy/dx
#    a = 0             # Left boundary
#    b = 10            # Right boundary
#    N = 100           # Number of data points
    h = (b-a)/N        # Equal spacing between points

    tpoints = np.arange(a,b,h)           # Defines time axis
    Tpoints = []                         # This will be filled with the values of Temperature, what we're looking for

    T0 = 10                              # Initial Temperature
    T = T0                               # Initial condition: T(a) = T0 on left boundary
    for t in tpoints:                    # Loop over all x-values
        Tpoints.append(T)                # Fill the ypoints list as we integrate each step
        k1 = h*func(T,x)
        k2 = h*func(T+0.5*k1,t+0.5*h)
        k3 = h*func(T+0.5*k2,t+0.5*h)
        k4 = h*func(T+k3,t+h)
        T += (k1+2*k2+2*k3+k4)/6         # Temp at each point t is a weighted average of slopes

#    plt.plot(tpoints,Tpoints)   # Plot T(t) vs. t
#    plt.xlabel("Time (min)")    # Label t-axis
#    plt.ylabel("Temp (C)")      # Label T-axis
#    plt.show()                  # Show plot
    return tpoints, Tpoints     # Return t-axis, T-axis





Tenv = 83                                 # Environmental temperature
k = 0.1                                   # Units are deg C/min
yprime = lambda y,x: -k*(y-Tenv)          # yprime is the derivative of y(x) 

nsteps = 60              # Initialize number of data points
deltaT = np.zeros(4)     # Initialize dt vector
Temp10 = np.zeros(4)     # Temperature at t = 10
totaltime = 60
my_color = ['red', 'green', 'blue', 'orange']
plt.figure()
for i in range(0,4):

    dt = totaltime/nsteps
    xaxis,yaxis = rk4(yprime, a=0 , b=totaltime , N=nsteps)

    plt.plot(xaxis,yaxis,color = my_color[i])
    plt.xlim(0,10)
    plt.xlabel("Time (min)")
    plt.ylabel("Temp (C)")


    deltaT[i] = dt
    nsteps = nsteps*2

    index = np.abs(xaxis-10).argmin()   # Need the index to find yaxis at t = 10
    Temp10[i] = yaxis[index]
plt.show()

deltaT    # For the values of delta t,
Temp10    # these are the temperatures at t = 10

plt.plot(deltaT,Temp10)
plt.xlabel("Delta T (C)")
plt.ylabel("Temp (C) at t = 10 min")
plt.ylim(50,65)
plt.show()


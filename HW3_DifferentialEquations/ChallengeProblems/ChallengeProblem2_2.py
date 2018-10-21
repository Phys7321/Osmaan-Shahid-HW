"""
Challenge Problem 2.2: Do Challenge Problem 2.1 using the 4th order Range-Kutta method.

This program solves the differential equation

dT/dt = -k(T - Tenv)

which is Newton's Law of Cooling.

T0 = initial temperature of object
T = T(t), the temperature at time t
Tenv = environmental temperature
k = constant
nsteps = number of time steps
dt = step size
"""

import numpy as np
import matplotlib.pyplot as plt

T0 = 10                                           # Initial Temperature
Tenv = 83                                         # Environmental temperature, deg C
k = 0.1                                           # Units are deg C/min
nsteps = 1200                                     # Initialize number of data points

'''
Define the 4th order Range-Kutta method
'''

##########################################################

def rk4(func,a,b,N):   # func is the derivative of y(x), which is f = dy/dx
#    a = 0             # Left boundary
#    b = 10            # Right boundary
#    N = 100           # Number of data points
    h = (b-a)/N        # Equal spacing between points

    tpoints = np.arange(a,b,h)           # Defines time axis
    Tpoints = []                         # This will be filled with the values of Temperature, what we're looking for

    T = T0                               # Initial condition: T(a) = T0 on left boundary
    for t in tpoints:                    # Loop over all x-values
        Tpoints.append(T)                # Fill the ypoints list as we integrate each step
        k1 = h*func(T,t)
        k2 = h*func(T+0.5*k1,t+0.5*h)
        k3 = h*func(T+0.5*k2,t+0.5*h)
        k4 = h*func(T+k3,t+h)
        T += (k1+2*k2+2*k3+k4)/6         # Temp at each point t is a weighted average of slopes

    return tpoints, Tpoints      # Return t-axis, T-axis

##########################################################

f = lambda y,x: -k*(y-Tenv)                       # f is the derivative of y(x)

dt = 1                                           # Initialize time step
deltaT = np.zeros(4)                              # Initialize dt vector
Temp10 = np.zeros(4)                              # Temperature at t = 10
totaltime = 60
my_color = ['red', 'green', 'blue', 'orange']     # Vector of colors
for i in range(0,4):
    nsteps = int(totaltime/dt)                    # Number of time steps
    xaxis = np.linspace(0,totaltime,nsteps)       # x-axis from 0 to total time
    yaxis = np.zeros(nsteps)                      # y-axis is temperature
    T = T0                                            
    
    
    xaxis,yaxis = rk4(f, a=0 , b=totaltime , N=nsteps)
    plt.plot(xaxis,yaxis,color = my_color[i],label=dt)  # plot Temp vs. time
    deltaT[i] = dt                                      # update dt vector
    dt = dt/2                                           # cut dt in half for next loop

    index = np.abs(xaxis-10).argmin()             # Need the index to find yaxis at t = 10
    Temp10[i] = yaxis[index]                      # Find temperature at t = 10 min


plt.xlabel("Time (min)")                          # Label x-axis
plt.ylabel("Temp (C)")                            # Label y-axis
plt.title("Temperature (C) vs. Time (min)")       # Give title
plt.legend(framealpha=1, frameon=True);           # Display legend
plt.xlim(0,60)                                    # Plot only from t = 0 to t = 10 min
plt.show()                                        # Show plot in new window

deltaT                                            # For the values of delta t,
Temp10                                            # these are the temperatures at t = 10

plt.figure()                                      # Start new figure
plt.plot(deltaT,Temp10)                           # Plot Temp. vs. dt at t = 10 min
plt.xlabel("$\Delta$t (min)")                     # Label x-axis
plt.ylabel("Temp (C)")                            # Label y-axis
plt.title("Temperature (C) at t = 10 min")        # Give title
plt.ylim(55,57)                                   # Plot only from T = 50 to T = 65 C
plt.show()                                        # Show plot in new window


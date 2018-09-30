"""
Challenge Problem starts at line 48
"""



"""
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

T0 = 10
Tenv = 83
k = 0.1
nsteps = 1200
dt = 0.05
totaltime = dt*nsteps

euler = lambda y, f, dx: y + f*dx  # y is the function y(x), f is dy/dx

xaxis = np.linspace(0,totaltime, nsteps)
yaxis = np.zeros(nsteps)

T = T0
for i in range(0,nsteps):
    T = euler(T, -k*(T - Tenv), dt)
    yaxis[i] = T

plt.plot(xaxis,yaxis)
plt.xlabel("Time (min)")
plt.ylabel("Temp (C)")
plt.show()


"""
Challenge Problem 2.1
"""


dt = 1                   # Initialize time step
deltaT = np.zeros(4)     # Initialize dT vector
Temp10 = np.zeros(4)     # Temperature at t = 10
totaltime = 60
my_color = ['red', 'green', 'blue', 'orange']
for i in range(0,4):
    nsteps = int(totaltime/dt)
    xaxis = np.linspace(0,totaltime,nsteps)
    yaxis = np.zeros(nsteps)
    T = T0
    for j in range(nsteps):
        T = euler(T, -k*(T-Tenv),dt) # euler fxn defined on line 32
        yaxis[j] = T

    plt.plot(xaxis,yaxis,color = my_color[i])
    deltaT[i] = dt
    dt = dt/2

    index = np.abs(xaxis-10).argmin()   # Need the index to find yaxis at t = 10
    Temp10[i] = yaxis[index]
plt.xlabel("Time (min)")
plt.ylabel("Temp (C)")
plt.xlim(0,10)
plt.show()

deltaT    # For the values of delta t,
Temp10    # these are the temperatures at t = 10


"""
Do Challenge Problem 2.1 using the 4th order Range-Kutta method.
"""

import numpy as np
import math
import matplotlib.pyplot as plt

# Define the 4th order Range-Kutta method using Prof. Kelley's code

def rk4(func,a=0,b=10,N=20,):
    h = (b-a)/N

    tpoints = np.arange(a,b,h)
    xpoints = []

    x = 0.0
    for t in tpoints:
        xpoints.append(x)
        k1 = h*func(x,t)
        k2 = h*func(x+0.5*k1,t+0.5*h)
        k3 = h*func(x+0.5*k2,t+0.5*h)
        k4 = h*func(x+k3,t+h)
        x += (k1+2*k2+2*k3+k4)/6

    plt.plot(tpoints,xpoints)
    plt.xlabel("t")
    plt.ylabel("x(t)")
    plt.show()
    return xpoints

fxn = lambda x: x**2
rk4(fxn)

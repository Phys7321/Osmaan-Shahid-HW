# Find the period of an anharmonic oscillator

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np

# Define potential energy, V(x)
V = lambda x: x**4

# Amplitude and mass
a = 4
m = 1

# Integrand
integrand = lambda x: (4/math.sqrt(math.pi))/(math.sqrt( V(a) - V(x) ))

def a_vs_t(a,N):
    x = np.linspace(0,a,N)
    y = np.zeros(N)
    for i in range(0,N):
        integrand = lambda x: (4/math.sqrt(math.pi))/(math.sqrt( V(a*(1/N)-0.01) - V(x) ))
        y[i] = sci.romberg(integrand,0,a*(i/N)-0.01)
    plt.plot(x,y)
    plt.xlabel('Amplitude')
    plt.ylabel('Period')
    plt.show()
    return x,y;

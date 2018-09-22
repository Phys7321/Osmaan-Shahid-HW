# Find the period of an anharmonic oscillator

import scipy.integrate as sci
import math
import matplotlib.pyplot as plt
import numpy as np

# Define potential energy, V(x)
V = lambda x: x**2

# Amplitude and mass
a = 4
m = 1

# Integrand
integrand = lambda x: 1/(math.sqrt( V(a) - V(x) )

def a_vs_t(a):
    x = np.linspace(0,a,100)
    y = np.zeros(100+1)
    for i in range(0,a):
        y[i] = sci.romberg(integrand,0,a-0.01)
    print(x.tolist())
    print(y.tolist())
    plt.plot(x,y)
    plt.xlabel('Amplitude')
    plt.ylabel('Period')
    plt.show()
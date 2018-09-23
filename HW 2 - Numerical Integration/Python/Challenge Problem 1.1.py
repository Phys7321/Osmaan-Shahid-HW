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

# Integrand, to be used in the function
integrand = lambda x: (4/math.sqrt(math.pi))/(math.sqrt( V(a) - V(x) ))

# a_vs_t will calculate the period T for each amplitude a
def t_vs_a(a,N):
    x = np.linspace(0,a,N)              # X-axis is the amplitude
    y = np.zeros(N)                     # Y-axis is the period
    for i in range(1,N):                # N is the number of data points
        integrand = lambda z: (4/math.sqrt(math.pi))/(math.sqrt( V(a*(i/N)) - V(z) ))    # Fxn to be integrated
        y[i-1] = sci.romberg(integrand,0,a*(i/N)-0.0001,divmax=20)         # Y-axis is integral of fxn
    plt.plot(x,y)
    plt.xlabel('Amplitude')
    plt.ylabel('Period')
    plt.show()
    plt.suptitle('T vs. A for V(x) = x^4')
    return x,y


# Define amplitude and number of points
a = 4
N = 25
t_vs_a(a,N)

# -*- coding: utf-8 -*-
"""
Created on Sun Sep  9 16:50:22 2018

@author: Tom K
edited by: Osmaan S
"""

import numpy as np
import matplotlib.pyplot as plt
import math

# Define the function f(x)
def f(x):
    return x**2

# Define forward difference method for derivative, f'(x)
# over the interval [a,b] for N points
# h is spacing between each point




def forwardiff(f,a,b,N):                   # Find f'(x), using forward method
    h = (b-a)/N
    forward_prime=[]                       # Empty list, will become f'(x)
    xaxis = np.linspace(a,b,num=(N-1))     # x-axis
    for k in range(1,N):
        slop = (f(a+k*h)-f(a+(k-1)*h))/h   # Calculate derivative at each point
        forward_prime.append(slop)         # At each point, add f'(x) to list
    plt.plot(xaxis.tolist(),forward_prime) # Plot on xy-axes
    plt.show()
    



def backwardiff(f,a,b,N):                   # Find f'(x), using backward method
    h = (b-a)/N
    backward_prime=[]                       # Empty list, will become f'(x)
    xaxis = np.linspace(a,b,num=(N-1))      # x-axis
    for k in range(0,N-1):
        slop = (f(a+(k+1)*h)-f(a+k*h))/h    # Calculate derivative at each point
        backward_prime.append(slop)         # At each point, add f'(x) to list
    plt.plot(xaxis.tolist(),backward_prime) # Plot on xy-axes
    plt.show()




def centraldiff(f,a,b,N):                         # Find f'(x), using central method
    h = (b-a)/N
    central_prime=[]                              # Empty list, will become f'(x)
    xaxis = np.linspace(a,b,num=N)                # x-axis
    for k in range(0,N):
        slop = (f(a+(k+1/2)*h)-f(a+(k-1/2)*h))/h  # Calculate derivative at each point
        central_prime.append(slop)                # At each point, add f'(x) to list
    plt.plot(xaxis.tolist(),central_prime)        # Plot on xy-axes
    plt.show()




def higherorderdiff(f,a,b,N):                     # Find f'(x), using cubic approximation with central method
    h = (b-a)/N
    higher_prime=[]                              # Empty list, will become f'(x)
    xaxis = np.linspace(a,b,num=N)                # x-axis
    for k in range(0,N):
        slop = ( (1/24)*f(a+(k-3/2)*h) - (27/24)*f(a+(k-1/2)*h) + (27/24)*f(a+(k+1/2)*h) - (1/24)*f(a+(k+3/2)*h) )/h  # Calculate derivative at each point
        higher_prime.append(slop)                # At each point, add f'(x) to list
    plt.plot(xaxis.tolist(),higher_prime)        # Plot on xy-axes
    plt.show()





def secondiff(f,a,b,N):                           # Find f''(x)
    h = (b-a)/N
    second_prime=[]                               # Empty list, will become f''(x)
    xaxis = np.linspace(a,b,num=N)                # x-axis 
    for k in range(0,N):
        slop = (f(a+(k+1)*h) + f(a+(k-1)*h) - 2*f(a+k*h) )/(h**2)   # Calculate derivative at each point
        second_prime.append(slop)                 # At each point, add f''(x) to list
    print(second_prime)
    # print(xaxis.tolist()
    plt.plot(xaxis.tolist(),second_prime)         # Plot on xy-axes
    plt.show()



def f(x):
    return (np.sin(1/(x*(2-x)) ))**2
                                                  # For good results, use a = -2, b = 4, N = 5000
def hw1_part2(f,a,b,N):
    x = np.linspace(a,b,num=N)                    # Define x-axis
    y = (np.sin(1/(x*(2-x)) ))**2                 # Define y-axis, f(x) = sin^2(1/(x*(2-x)))
    plt.plot(x.tolist(),y.tolist(),'b')           # Plot on xy-axes
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('f(x)')
                                                  # Take derivative using centraldiff function
                                                  # Copied and pasted centraldiff function below
    h = (b-a)/N
    y_prime=[]                                    # Empty list, will become f'(x)
    for k in range(0,N):
        slop = (f(a+(k+1/2)*h)-f(a+(k-1/2)*h))/h  # Calculate derivative at each point
        y_prime.append(slop)                      # At each point, add f'(x) to list
    plt.figure(2)
    plt.plot(x.tolist(),y_prime,'r')              # Plot on xy-axes
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title("f'(x)")
                                                  # Take second derivative using secondiff function
                                                 # Copied and pasted seconddiff function below
    second_prime=[]                               # Empty list, will become f''(x) 
    for k in range(0,N):
        slop = (f(a+(k+1)*h) + f(a+(k-1)*h) - 2*f(a+k*h) )/(h**2)   # Calculate derivative at each point
        second_prime.append(slop)                 # At each point, add f''(x) to list
    plt.figure(3)
    plt.plot(x.tolist(),second_prime,'g')        # Plot on xy-axes
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title("f''(x)")
    plt.show()
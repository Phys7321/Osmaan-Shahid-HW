import numpy as np
from matplotlib import pyplot
import matplotlib.animation as animation
from JSAnimation.IPython_display import display_animation

K = 0.12             # cal/(sec * cm * C) 
c = 0.113            # cal/(g * C)
rho = 7.8            # g/(cm^3)
alpha = K/(c*rho)    # (cm^3)/g

L = 50               # length of the bar, in cm
dx = 0.2             # space step, in cm
nx = int(L/dx)       # number of points in space

x = np.arange(0,L+dx,dx) # the +1 is necessary to store the value at l
dt = 0.015           # time step, in sec
C = dx**2/dt         # 
r = alpha/C          # stability

print(r)             # should be less than or equal to 0.5 


t0 = np.zeros(nx+1)
t1 = np.zeros(nx+1)  # these arrays will contain the new displacements at t, and t+delta

#Initial conditions
t0[:] = 100.         # initial temperature across bar
t0[0] = 0.           # initial temperature at x = 0
t0[nx] = 0.          # initial temperature at x = L


fig = pyplot.figure()    # open up a figure
ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define axes
points, = ax.plot([], [], marker='', linestyle='-', lw=3)     # define point style

def evolve():
    global t0, t1
    for ix in range(1,nx):    # updat temperature for each value of x along the bar
        t1[ix] = t0[ix] + r*(t0[ix+1]+t0[ix-1]-2*t0[ix])   # store new temp in t1 

    points.set_data(x, t0)

    for ix in range(nx):      # for each value of x along the bar
        t0[ix] = t1[ix]       # replace old temp in t0 with new temp from t1

    return points


anim = animation.FuncAnimation(fig, evolve, frames = 2000, interval=10)

display_animation(anim, default_mode='once')

#for i in range(20):
#    evolve()   
#pyplot.plot(x, t0, color='blue', ls='-', lw=3);

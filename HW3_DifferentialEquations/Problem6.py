import numpy as np
from matplotlib import pyplot
import matplotlib.animation as animation
from JSAnimation.IPython_display import display_animation

# constants for iron
Ki = 0.49             # cal/(sec * cm * C) 
ci = 0.217            # cal/(g * C)
rhoi = 2.7            # g/(cm^3)
alphai = Ki/(ci*rhoi)    # (cm^3)/g


# constants for aluminum
Ka = 0.49             # cal/(sec * cm * C) 
ca = 0.217            # cal/(g * C)
rhoa = 2.7            # g/(cm^3)
alphaa = Ka/(ca*rhoa)    # (cm^3)/g

L = 50               # length of the bar, in cm
dx = 0.2             # space step, in cm
nx = int(L/dx)       # number of points in space

xi = np.arange(0,L+dx,dx) # the +1 is necessary to store the value at l
xa = np.arange(0,L+dx,dx) # the +1 is necessary to store the value at l
dt = 0.015           # time step, in sec
C = dx**2/dt         # should be > 0.5
ri = alphai/C          # stability
ra = alphaa/C

print(ri,ra,C)           # should be less than or equal to 0.5 

# for iron
t0_i = np.zeros(nx+1)
t1_i = np.zeros(nx+1)  # these arrays will contain the new displacements at t, and t+delta

# for aluminum
t0_a = np.zeros(nx+1)
t1_a = np.zeros(nx+1)  # these arrays will contain the new displacements at t, and t+delta

#Initial conditions for iron
t0_i[:] = 100.         # initial temperature across bar
t0_i[0] = 0.           # initial temperature at x = 0
t0_i[nx] = 0.          # initial temperature at x = L

#Initial conditions for aluminum
t0_a[:] = 50.         # initial temperature across bar
t0_a[0] = 0.           # initial temperature at x = 0
t0_a[nx] = 0.          # initial temperature at x = L

fig, (ax1, ax2) = pyplot.subplots(2,1)

# initialize points as empty vectors
points_i, = ax1.plot([], [], marker='', linestyle='-', lw=3)
points_a, = ax2.plot([], [], marker='', linestyle='-', lw=3)
points = [points_i, points_a]


fig1 = pyplot.figure()    # open up a figure
ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define axes
points_i, = ax.plot([], [], marker='', linestyle='-', lw=3)     # define point style

fig2 = pyplot.figure()    # open up a figure
ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define 
points_a, = ax.plot([], [], marker='', linestyle='-', lw=3)     # define point style

# time evolution for iron bar
def evolve(i):
    global t0_i, t1_i
    global t0_a, t1_a
    
    for ix in range(1,nx):    # update temperature for each value of x along the bar
        t1_i[ix] = t0_i[ix] + ri*(t0_i[ix+1]+t0_i[ix-1]-2*t0_i[ix])   # store new temp in t1 
        t1_a[ix] = t0_a[ix] + ra*(t0_a[ix+1]+t0_a[ix-1]-2*t0_a[ix])   # store new temp in t1 

    points_i.set_data(xi, t0_i)
    points_a.set_data(xi, t0_a)
    
    for ix in range(nx):      # for each value of x along the bar
        t0_i[ix] = t1_i[ix]       # replace old temp in t0 with new temp from t1
        t0_a[ix] = t1_a[ix]       # replace old temp in t0 with new temp from t1
    
    return points_i,
    return points_a,


animi = animation.FuncAnimation(fig, evolve, frames = 200, interval=10)
# anima = animation.FuncAnimation(fig, evolve_a, init_func=init_a, frames = 200, interval=10, blit=True)


pyplot.show()










# display_animation(anim, default_mode='once')

#for i in range(20):
#    evolve()   
#pyplot.plot(x, t0, color='blue', ls='-', lw=3);











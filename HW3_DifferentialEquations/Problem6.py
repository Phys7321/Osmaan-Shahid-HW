import numpy as np
from matplotlib import pyplot
import matplotlib.animation as animation
from JSAnimation.IPython_display import display_animation

# constants for iron (i) and aluminum (a)
K_i, K_a = 0.12, 0.49           # cal/(sec * cm * C) 
c_i, c_a = 0.113, 0.217         # cal/(g * C)
rho_i, rho_a = 7.8, 2.7         # g/(cm^3)

alpha_i = K_i/(c_i*rho_i)       # (cm^3)/g
alpha_a = K_a/(c_a*rho_a)       # (cm^3)/g

L = 50                          # length of the bar, in cm
dx = 0.2                        # space step, in cm
nx = int(L/dx)                  # number of points in space

x_i = np.arange(0,L+dx,dx)      # the +1 is necessary to store the value at l
x_a = np.arange(0,L+dx,dx)      # the +1 is necessary to store the value at l
dt = 0.015                      # time step, in sec
C = dx**2/dt                    # should be > 0.5
r_i = alpha_i/C                 # stability
r_a = alpha_a/C                 # stability

print(r_i,r_a,C)           # should be less than or equal to 0.5 

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
t0_a[:] = 100.         # initial temperature across bar
t0_a[0] = 0.           # initial temperature at x = 0
t0_a[nx] = 0.          # initial temperature at x = L

fig = pyplot.figure()

ax1 = fig.add_subplot(2, 2, 1)
pyplot.xlabel("x (cm)")
pyplot.ylabel("T (C)")
pyplot.title("Iron bar")
ax1.set_xlim(0, L)
ax1.set_ylim(0, 120)
ax1.grid()

ax2 = fig.add_subplot(2, 2, 2)
pyplot.xlabel("x (cm)")
pyplot.title("Aluminum bar")
ax2.set_xlim(0, L)
ax2.set_ylim(0, 120)
ax2.grid()

# initialize points as empty vectors
points_i, = ax1.plot([], [], marker='', linestyle='-', lw=3)
points_a, = ax2.plot([], [], marker='', linestyle='-', lw=3)

#ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define axes
#points_i, = ax1.plot([], [], marker='', linestyle='-', lw=3)     # define point style

#ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define axes
#points_a, = ax2.plot([], [], marker='', linestyle='-', lw=3)     # define point style
'''
for ax in [ax1, ax2]:
    ax.set_xlim(0, L)
    ax.set_ylim(0, 120)
    ax.set_xlabel=("x (cm)")
    ax.ylabel='T (C)'
   ''' 



#fig1 = pyplot.figure()    # open up a figure
#ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define axes
#points_i, = ax.plot([], [], marker='', linestyle='-', lw=3)     # define point style

#fig2 = pyplot.figure()    # open up a figure
#ax = pyplot.axes(xlim=(0, L), ylim=(0, 120), xlabel='x', ylabel='T')   # define 
#points_a, = ax.plot([], [], marker='', linestyle='-', lw=3)     # define point style

# time evolution
def evolve(i):
    global t0_i, t1_i       # iron bar
    global t0_a, t1_a       # aluminum bar
    
    for ix in range(1,nx):    # update temperature for each value of x along the bar
        t1_i[ix] = t0_i[ix] + r_i*(t0_i[ix+1]+t0_i[ix-1]-2*t0_i[ix])   # store new temp in t1 
        t1_a[ix] = t0_a[ix] + r_a*(t0_a[ix+1]+t0_a[ix-1]-2*t0_a[ix])   # store new temp in t1 

    points_i.set_data(x_i, t0_i)
    points_a.set_data(x_a, t0_a)
    
    for ix in range(nx):      # for each value of x along the bar
        t0_i[ix] = t1_i[ix]       # replace old temp in t0 with new temp from t1
        t0_a[ix] = t1_a[ix]       # replace old temp in t0 with new temp from t1
    
    return points_i,
    return points_a,


animi = animation.FuncAnimation(fig, evolve, frames = 200, interval=10)
# anima = animation.FuncAnimation(fig, evolve_a, init_func=init_a, frames = 200, interval=10, blit=True)


pyplot.show()










display_animation(anim, default_mode='once')

#for i in range(20):
#    evolve()   
#pyplot.plot(x, t0, color='blue', ls='-', lw=3);











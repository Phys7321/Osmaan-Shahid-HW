import numpy as np
from matplotlib import pyplot
from matplotlib.colors import ColorConverter as cc
import math


class particle2(object):
    
    def __init__(self, mass=1., x=0., y=0., vx=0., vy=0.):
        self.mass = mass
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
       
    def euler(self, fx, fy, dt):
        self.vx = self.vx + fx/self.mass*dt
        self.vy = self.vy + fy/self.mass*dt
        self.x = self.x + self.vx*dt
        self.y = self.y + self.vy*dt

g = 9.8            # g acceleration
v0 = 30.           # initial velocity

dt = 0.1           # time step

colors = ['red','orange','yellow','green','magenta','cyan','blue','purple','black','red','orange']


"""
Do the problem without air resistance, then add it later to compare.
"""
Ranges = []

for angle in range(1,11):
    x = [0]          # we need to initialize the arrays for each value of the angle
    y = [0]
    vx = [math.cos(angle*0.1*math.pi/2.)*v0] 
    vy = [math.sin(angle*0.1*math.pi/2.)*v0] 
    t = [0.]

    p = particle2(1., 0., 0., vx[0], vy[0])
    while p.y >= 0.:
        fy = -p.mass * g 
        p.euler(0., fy, dt)
        x.append(p.x)
        y.append(p.y)
        vx.append(p.vx)
        vy.append(p.vy)
        t.append(t[-1]+dt)

    Ranges.append(x[-1])   # Add the last value of x array (the range of particle)    
    t_data = np.array(t) # we convert the list into a numpy array for plotting
    x_data = np.array(x)
    y_data = np.array(y)
    vx_data = np.array(vx)
    vy_data = np.array(vy)

    pyplot.figure(1)
    my_plot = pyplot.plot(x_data, y_data, color=(colors[angle]), ls='-', lw=3, label = str(angle))
    pyplot.legend()

pyplot.title('Trajectory without Air Resistance')
pyplot.xlabel('position x(m)')
pyplot.ylabel('position y(m)')

print(Ranges)


"""
Now add air resistance and compare to previous case.
"""

for angle in range(1,11):
    x = [0]          # we need to initialize the arrays for each value of the angle
    y = [0]
    vx = [math.cos(angle*0.1*math.pi/2.)*v0] 
    vy = [math.sin(angle*0.1*math.pi/2.)*v0] 
    t = [0.]

    p = particle2(1., 0., 0., vx[0], vy[0])
    while p.y >= 0.:
        fx = -0.1 * p.mass * math.sqrt(vx[-1]**2 + vy[-1]**2) * vx[-1]
        fy = -p.mass * (g + 0.1 * math.sqrt(vx[-1]**2 + vy[-1]**2) * vy[-1])
        p.euler(fx, fy, dt)
        x.append(p.x)
        y.append(p.y)
        vx.append(p.vx)
        vy.append(p.vy)
        t.append(t[-1]+dt)
    
    t_data = np.array(t) # we convert the list into a numpy array for plotting
    x_data = np.array(x)
    y_data = np.array(y)
    vx_data = np.array(vx)
    vy_data = np.array(vy)

    pyplot.figure(2)
    my_plot = pyplot.plot(x_data, y_data, color=(colors[angle]), ls='-', lw=3, label = str(angle))
    pyplot.legend()

pyplot.title('Trajectory with Air Resistance')
pyplot.xlabel('position x(m)')
pyplot.ylabel('position y(m)')

pyplot.show([1,2])



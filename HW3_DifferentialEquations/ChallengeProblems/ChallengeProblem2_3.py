"""
Challenge Problem 2.3: Find the initial height at which the impact velocity
between the constant and non-constant acceleration conditions differ
by 1 percent.
"""

import numpy as np
import matplotlib.pyplot as plt


"""
Define the object called "particle"
"""

class particle(object):
    
    def __init__(self, mass=1., y=0., v=0.):
        self.mass = mass
        self.y = y
        self.v = v
        
    def euler(self, f, dt):
        self.y = self.y + self.v*dt
        self.v = self.v + f/self.mass*dt


g = 9.8                                      # g acceleration, m/s
mass = 0.01                                  # Mass of the particle
R = 6.37 * 10**6                             # Radius of the Earth, m
y0 = 300.                                    # Initial position
v0 = 0.                                      # Initial velocity
vt = 30.                                     # Terminal velocity
k2 = g*mass/vt**2                            # drag coeff.
dt = 0.1                                     # Time step

p = particle(mass, y0, v0)

gforce = g*mass/(1+p.y/R)**2                 # Define weight


y = [y0] # since we do not know the size of the arrays, we define first a python list
v = [v0] # the append method is more efficient for lists than arrays
t = [0.]

vnormal = [v0]                               # Speed for which a = -g the whole time

while p.y > 0.:                              # While the particle is above the ground,
    fy = -gforce-k2*p.v*abs(p.v)             # Net force = - mg - f_drag
    p.euler(fy, dt)                          # Find new height and velocity
    y.append(p.y)                            # Append new height to old height
    v.append(p.v)                            # Append new velocity to old velocity
    t.append(t[-1]+dt)                       # Increment time by dt
    vnormal.append(vnormal[-1] - g*dt)       # Append new velocity (constant accel.)

    
t_data = np.array(t)                    # Convert the list into a numpy array for plotting
y_data = np.array(y)
v_data = np.array(v)
vnormal_data = np.array(vnormal)

#for i in range(0,t_data.size):
#    print (i,t_data[i], y_data[i], v_data[i])
#print(v_data[-1])
'''
plt.plot(t_data, v_data, color="#FF0000", ls='-', lw=3)
plt.xlabel('Time (s)')
plt.ylabel('Velocity (m/s)')
plt.title('Velocity (m/s) vs. Time (s), non-constant acceleration')
plt.show()

plt.figure()
plt.plot(t_data, vnormal_data, color="#FF0000", ls='-', lw=3)
plt.xlabel('Time (s)')
plt.ylabel('Velocity (m/s) (constant g)')
plt.title('Velocity (m/s) vs. Time (s), constant acceleration')
plt.show()

plt.figure()
plt.plot(t_data, y_data, color="#0000FF", ls='-', lw=3)
plt.xlabel('Time (s)')
plt.ylabel('Position (m)')
plt.title('Position (m) vs. Time (s)')
plt.show()
'''

p = particle(mass, y0, v0)

y0 = list(np.linspace(600000,800000,100))            # Make a list of many different heights

difflist = []

for i in range(0,len(y0)):                   # For each height,
    p = particle(mass,y0[i],v0)              # Initialize particle
    v = [v0]                                 # Define list and then append later
    t = [0.]                                 # Define list and then append later
    vnormal = [v0]                           # Define list and then append later
    y = [y0[i]]                              # Define list and then append later
    while p.y > 0:                           # While the particle is above the ground,
        fy = -gforce#-k2*p.v*abs(p.v)         # Net force = - mg - f_drag
        p.euler(fy, dt)                      # Find new height and velocity
        y.append(p.y)                        # Append new height to old height
        v.append(p.v)                        # Append new velocity to old velocity
        t.append(t[-1]+dt)                   # Increment time by dt
        vnormal.append(vnormal[-1] - g*dt)   # Append new velocity (constant accel.)
    vimpact = v[-1]                          # Impact velocity (non-constant accel.)
    vnormalimpact = vnormal[-1]              # Impact velocity (constant accel.)
    diff = ((vimpact - vnormalimpact)/(vimpact))*100
    difflist.append(diff)
    print(i,diff,vimpact,vnormalimpact,int(y0[i])) # Print various variables

plt.figure()
plt.plot(y0,difflist)
plt.xlabel('Initial height (m)')
plt.ylabel('Percent difference')
plt.title('Percent difference vs. Initial height (m)')
plt.show()

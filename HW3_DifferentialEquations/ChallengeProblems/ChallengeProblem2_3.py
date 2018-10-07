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
        
    def euler_cromer(self, f, dt):
        self.v = self.v + f/self.mass*dt
        self.y = self.y + self.v*dt



"""

"""


g = 9.8            # g acceleration, m/s
mass = 0.01        # mass of the particle
R = 6.37 * 10**6   # Radius of the Earth, m
y0 = 300.          # initial position
v0 = 0.            # initial velocity
vt = 30.           # terminal velocity
k2 = g*mass/vt**2  # drag coeff.

dt = 0.01           # time step


p = particle(mass, y0, v0)

gforce = g*mass/(1+p.y/R)**2    # weight


y = [y0] # since we do not know the size of the arrays, we define first a python list
v = [v0] # the append method is more efficient for lists than arrays
t = [0.]

vnormal = [v0] # speed for which a = -g the whole time

while p.y > 0.:
    fy = -gforce-k2*p.v*abs(p.v)
    p.euler(fy, dt)
    y.append(p.y)
    v.append(p.v)
    t.append(t[-1]+dt)
    vnormal.append(vnormal[-1] - g*dt)

    
t_data = np.array(t) # we convert the list into a numpy array for plotting
y_data = np.array(y)
v_data = np.array(v)
vnormal_data = np.array(vnormal)

#for i in range(0,t_data.size):
#    print (i,t_data[i], y_data[i], v_data[i])
print(v_data[-1])
plt.plot(t_data, v_data, color="#FF0000", ls='-', lw=3)
plt.xlabel('Time (s)')
plt.ylabel('Velocity (m/s)')
plt.show()

plt.plot(t_data, vnormal_data, color="#FF0000", ls='-', lw=3)
plt.xlabel('Time (s)')
plt.ylabel('Velocity (m/s) (constant g)')
plt.show()

plt.plot(t_data, y_data, color="#0000FF", ls='-', lw=3)
plt.xlabel('Time (s)')
plt.ylabel('Position (m)')
plt.show()


p = particle(mass, y0, v0)

y0 = list(np.linspace(1,500,500))
v = [v0]
t = [0.]
vnormal = [v0]

for i in range(0,len(y0)):
    p = particle(mass,y0[i],v0)
    y = [y0[i]]
    while p.y > 0:
        fy = -gforce-k2*p.v*abs(p.v)
        p.euler(fy, dt)
        y.append(p.y)
        v.append(p.v)
        t.append(t[-1]+dt)
        vnormal.append(vnormal[-1] - g*dt)
    vimpact = v[-1]
    vnormalimpact = vnormal[-1]
    diff = np.abs(((vimpact - vnormalimpact)/(vimpact)))*100
    if diff > 1.0 and diff < 1.9:
        print(i,diff,vimpact,vnormalimpact,y[i])



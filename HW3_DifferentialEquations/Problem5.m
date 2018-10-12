function [period,sol] = Problem5(varargin) 
% Finds the period of a damped pendulum for large oscillations given the
% length of the pendulum arm and initial conditions. All angles in radians.
% Use the input "Problem5(L)" where
% L = length of pendulum
% and use L = 9.8/9 = 1.0889 to get g/L = 9


%Setting initial conditions
switch nargin
    case 0
        error('Must input length and initial conditions')
    case 1
       L = varargin{1};
end

g=9.81;
A = 1 ;          % Amplitude of driving force
omega0 = sqrt(g/L);
T0= 2*pi/omega0; % Period of simple harmonic oscillator
N = 15;           % Number of oscillations to graph
m = 1;           % Mass of pendulum bob
theta0 = 0.0 ;         % Initial angle
thetad0 = 0.0 ;        % Initial angular velocity
r0 = [theta0 thetad0]; % Initial conditions
gamma = [0.1 0.5 1.0 2.0] ;   % Damping factor



% Solve differential equation for different driving force frequencies
omega = [0 1 2 2.2 2.4 2.6 2.8 3.0 3.2 3.4] ;

tspan = [0 N*T0];           % Integration time goes from 0 to N*T0
opts = odeset('refine',6);  % Set up options

% Solve the ODE for different omega values
theta0 = 0.0 ;         % Initial angle
thetad0 = 1.0 ;        % Initial angular velocity
r0 = [theta0 thetad0]; % Initial conditions
[t2,w2] = ode45(@proj,tspan,r0,opts,g,L,gamma1,A,omega(2));

% From Problem 4, I would need to calculate the phase shift for each
% frequency, and use that to find A(omega). Then from the maximum value of
% A, find its index to get the resonant frequency.

% Create plots

figure(1)
plot(t3,w3(:,1),'k-',t4,w4(:,1),'c-')  % omega = 2, both initial conditions
legend('\theta_0 = 1','\theta_0 = 0')
title('Angle \theta (t) vs. Time for \omega = 2')
xlabel('t')
ylabel('\theta')
ylim([-1 1])


% From the graph, the steady state solution is a sinusoidal function.
% The transient solution is not immediately obvious as an analytic
% solution.
% This is is true independent of initial conditions, since both graphs
% converge.

% Now we plot these for values of omega = 1 and omega = 4
figure(2)
subplot(1,1,1)
plot(t2,w2(:,1),'k-',t11,w11(:,1),'c-') 
legend('\omega = 1','\omega = 4')
title('Angle \theta (t) vs. Time')
xlabel('t')
ylabel('\theta')
ylim([-0.6 0.6])

% The plots show that higher frequencies will converge to a sinusoidal
% function faster.






% Next I need to find the period as a function of time, and then I can find
% the angular frequency as a function of time. With this, I can calculate
% delta for each frequency of the driving force.


end
%-------------------------------------------



%t = x-axis
%r = column vector: [theta; theta_velocity]
%g = 9.8
%L = length of pendulum
function rdot = proj(t,r,g,L,gamma,A,omega)
    rdot = [r(2); -g/L*sin(r(1)) - gamma*r(2) + A*cos(omega*t)];
end

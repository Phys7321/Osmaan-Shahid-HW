function [period,sol] = Problem1(varargin) 
% Finds the period of a pendulum in simple harmonic motion given the
% length of the pendulum arm and initial conditions. All angles in radians.
% Use the input "Problem1(L,theta0,thetad0)" where
% L = length of pendulum
% theta0 = initial angle
% thetad0 = initial angle velocity

%Setting initial conditions
switch nargin
    case 0
        error('Must input length and initial conditions')
    case 1
       L = varargin{1};
       theta0 = 0.25;
       thetad0 = 0;
    case 2
       L = varargin{1};
       theta0 = varargin{2};
       thetad0 = 0;
    case 3
       L = varargin{1};
       theta0 = varargin{2};
       thetad0 = varargin{3};
end

g=9.81;                                              % Acceleration due to gravity
omega = sqrt(g/L);                                   % Natural angular frequency
T= 2*pi/omega;                                       % Period of simple harmonic oscillator
N = 1;                                               % Number of oscillations to graph
m = 1;                                               % Mass of pendulum bob


tspan = [0 N*T];                                     % Integration time goes from 0 to N*T
opts = odeset('refine',6);                           % Options

r0 = [theta0 thetad0];                               % [initial_angle initial_angle_velocity]
[t,w] = ode45(@proj,tspan,r0,opts,g,L);              % Solve differential equation
sol = [t,w];                                         % t is x-axis, w is y-axis
ind= find(w(:,2).*circshift(w(:,2), [-1 0]) <= 0);
ind = chop(ind,4);
period= 2*mean(diff(t(ind)));                        % Find period

% Define energies
K = m*(L^2)*(w(:,2).^2)/2;   % Kinetic energy
U = m*g*L*(1-cos(w(:,1))) ;  % Potential energy
E = K + U ;                  % Total energy
E0 = E(1);                   % Initial energy
deltaE = E - E0;             % Change in energy over cycle

Kavg = linspace(mean(K),mean(K),length(t));           % Average kinetic energy
Uavg = linspace(mean(U),mean(U),length(t));           % Average potential energy

% Create plots

figure(1)                              
subplot(2,1,1)                                     % Plot Angle and Velocity vs. time
plot(t,w(:,1),'k-',t,w(:,2),'b--') 
legend('Angle','Angular Velocity')
title('Angle and Angular Velocity vs. Time')
xlabel('t (s)')
ylabel('\theta (rad)')

subplot(2,1,2)                                     % Plot Energies vs. Time
plot(t,K,'k-',t,U,'c-',t,Kavg,'r--',t,Uavg,'g--')
legend('Kinetic','Potential','Average Kinetic','Average Potential')
title('Kinetic and Potential Energy')
xlabel('t')
ylabel('Energy')
ylim([-0.5 E0+E0/2])

figure(2)
subplot(2,1,1)                                     % Plot Energy and Energy Change vs. time
plot(t,E,'k-',t,deltaE,'b--')
legend('Total E','Change in E')
title('Total Energy')
xlabel('t')
ylabel('Energy')
ylim([-0.5 E0+E0/2])

subplot(2,1,2)                                     % Plot Velocity vs. Angle
plot(w(:,1),w(:,2),'k-')
title('Phase Space')
xlabel('\theta')
ylabel('\omega')
xlim([-5 5])
ylim([-5 5])

% In phase space, the contours are going in the clockwise direction. I know
% this because at time t = 0, the angle is 1 and the angular velocity will
% be decreasing (which can be seen in Figure 1). Therefore, the path is
% clockwise.






end
%-------------------------------------------


%t = x-axis
%r = column vector: [theta; theta_velocity]
%g = 9.8
%L = length of pendulum
function rdot = proj(t,r,g,L)
    rdot = [r(2); -g/L*r(1)];
end
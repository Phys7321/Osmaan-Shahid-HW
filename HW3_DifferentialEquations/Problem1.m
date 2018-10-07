function [period,sol] = Problem1(varargin) 
% Finds the period of a nonlinear pendulum given the length of the pendulum
% arm and initial conditions. All angles in radians.
% Use the input "Problem1(R,theta0,thetad0)" where
% L = length of pendulum
% theta0 = initial angle
% thetad0 = initial angle velocity

%Setting initial conditions
switch nargin
    case 0
        error('Must input length and initial conditions')
    case 1
       L = varargin{1};
       theta0 = pi/2;
       thetad0 = 0;
    case 2
       L = varargin{1};
       theta0 = varargin{2};
       thetad0 = 0;
    case 3
       L = varargin{1};
       theta0 = varargin{2};
       thetad0 = varagin{3};
end

grph = 1;
g=9.81;
omega = sqrt(g/L);
T= 2*pi/omega;
% number of oscillations to graph
N = 10;


tspan = [0 N*T];           % Time goes from 0 to N*T
%opts = odeset('events',@events,'refine',6); %Here for future event finder
opts = odeset('refine',6);
r0 = [theta0 thetad0];     % [initial_angle initial_angle_velocity]
[t,w] = ode45(@proj,tspan,r0,opts,g,L);
sol = [t,w];    % t is x-axis, w is y-axis
ind= find(w(:,2).*circshift(w(:,2), [-1 0]) <= 0);
ind = chop(ind,4);
period= 2*mean(diff(t(ind)));

% Small-angle approximation solution
delta = atan(theta0/(omega*thetad0));
y = theta0*sin(omega*t+delta);

if grph % Plot Solutions of exact and small angle
    subplot(2,1,1)
    plot(t,w(:,1),'k-',t,y,'b--')
    legend('Exact','Small Angle')
    title('Exact vs Approximate Solutions')
    xlabel('t')
    ylabel('\phi')
    subplot(2,1,2)
    plot(t,w(:,1)-y,'k-')
    title('Difference between Exact and Approximate')
    xlabel('t')
    ylabel( '\Delta\phi')
end
end
%-------------------------------------------
%

%t = x-axis
%r = column vector: [theta; theta_velocity]
%g = 9.8
%L = length of pendulum
function rdot = proj(t,r,g,L)
    rdot = [r(2); -g/L*sin(r(1))];
end

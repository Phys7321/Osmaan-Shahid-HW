function [period,sol] = Problem2(varargin) 
% Finds the period of a pendulum for large oscillations given the
% length of the pendulum arm and initial conditions. All angles in radians.
% Use the input "Problem2(L)" where
% L = length of pendulum
% and use L = 9.8/9 = 1.0889 to get g/L = 9


%Setting initial conditions
switch nargin
    case 0
        error('Must input length and initial conditions')
    case 1
       L = varargin{1};
end

g=9.81;                             % Acceleration due to gravity
omega = sqrt(g/L);                  % Natural angular frequency
T0= 2*pi/omega;                     % Natural period
N = 5;                              % Number of oscillations to graph
m = 1;                              % Mass of pendulum bob
thetad0 = 0 ;                       % Initial angular speed = 0
theta0 = [0.1 0.2 0.4 0.8 1.0];     % Initial angles


% Solve differential equation for 5 different initial angles
% Define structure called "solution" or "sol" with fields 'time', 'velocity', and
% 'angle'
% Define as empty arrays, and then overwrite as we get the solution
% Structure fields are time, velocity, and angle

empty = {[],[],[],[],[]};
sol = struct('time',empty,'velocity',empty,'angle',empty);

tspan = [0 N*T0];               % Integration time goes from 0 to N*T0
opts = odeset('refine',6);      % Options used in the ODE solver

% Solve diff. eq. for five different initial angles
% Takes the form
% [time, angle(t)] = ode45(function,t-axis,[initial_angle initial_speed],options,g,L)

for i = 1:5
    [sol(i).time , v] = ode45(@proj,tspan,[theta0(i) thetad0],opts,g,L);
    sol(i).angle = v(:,1);
    sol(i).velocity = v(:,2);
end

Period = zeros(1,5);       % Preallocate to save computing time
ThetaMax = zeros(1,5);     % Preallocate to save computing time

% Find the period and maximum angle
for i = 1:5
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0);
    Period(i) = 2*mean(diff(sol(i).time(ind)));
    ThetaMax(i) = max(sol(i).angle);
end


% Now define a structure for energies
% Fields are 'Kinetic Energy', 'Potential Energy', and
% 'Total Energy'

energy = struct('KE',empty,'U',empty,'Etot',empty);

% Define energies
for i = 1:5
    energy(i).KE = m*(L^2)*(sol(i).velocity).^2/2 ;   % Kinetic energy
    energy(i).U = m*g*L*(1-cos(sol(i).angle)) ;       % Potential energy
    energy(i).Etot = energy(i).KE + energy(i).U ;     % Total energy
end


% Create plots of angle and angular velocity vs. time

figure(1)
for i = 1:3
    subplot(3,1,i)
    plot(sol(i).time,sol(i).angle,'k-',sol(i).time,sol(i).velocity,'b--');
    legend('Angle','Angular Velocity')
    title(sprintf('Angle and Angular Velocity for \\theta_0 = %0.1f',theta0(i)))
    xlabel('t')
    ylabel('\theta')
    ylim([-2 2])
end

% Not all subplots fit in one figure, so make a second one

figure(2)
for i = 4:5
    subplot(2,1,i-3)
    plot(sol(i).time,sol(i).angle,'k-',sol(i).time,sol(i).velocity,'b--');
    legend('Angle','Angular Velocity')
    title(sprintf('Angle and Angular Velocity for \\theta_0 = %0.1f',theta0(i)))
    xlabel('t')
    ylabel('\theta')
    ylim([-3 3])
end


% Create plot of total energy vs. time

colors = ['k' 'c' 'g' 'y' 'r'];    % Make vector of colors for plot legend

figure(3)
hold on
for i = 1:5                                      % For each initial angle,
    plot(sol(i).time,energy(i).Etot,colors(i))   % Plot(time,total_energy,color)
end
hold off

legend('\theta_0=0.1','\theta_0=0.2','\theta_0=0.4','\theta_0=0.8','\theta_0=1.0')
title('Total Energy')
xlabel('t')
ylabel('Energy')


% Plot period .vs maximum angle
figure(4)
plot(ThetaMax,Period,'k-')
title('Period vs. \theta_{max}')
xlabel('\theta_{max}')
ylabel('T')

% Period should increase for larger angles



end
%-------------------------------------------



%t = x-axis
%r = column vector: [theta; theta_velocity]
%g = 9.8
%L = length of pendulum
function rdot = proj(t,r,g,L)
    rdot = [r(2); -g/L*sin(r(1))];
end
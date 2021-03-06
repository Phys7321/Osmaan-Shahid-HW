function [sol1,sol2] = Problem4(varargin) 
% Finds the period of a damped pendulum for large oscillations with a
% driving force, given the length of the pendulum arm and initial 
% conditions. All angles in radians. % Use the input "Problem4(L)" where
% L = length of pendulum and use L = 9.8/9 = 1.0889 to get g/L = 9.





%                          Setting initial conditions

switch nargin
    case 0                                                   % If no input given
        error('Must input length and initial conditions')    % Give error
    case 1                                                   % If 1 input given
       L = varargin{1};                                      % Input = length of pendulum
end

g=9.81;                                           % Acceleration due to gravity
omega0 = sqrt(g/L);                               % Natural angular frequency
T0= 2*pi/omega0;                                  % Period of simple harmonic oscillator
N = 15;                                           % Number of oscillations to graph
m = 1;                                            % Mass of pendulum bob
A = 1 ;                                           % Amplitude of driving force
gamma1 = 0.5 ;                                    % Damping factor
gamma2 = 1.5 ;                                    % Damping factor
omega = [0 1 2 2.2 2.4 2.6 2.8 3.0 3.2 3.4 4] ;   % Driving force frequencies





% Solve differential equation for different driving force frequencies

% Define structure called "sol" with fields 'time', 'velocity', and
% 'angle'
% Since there are two damping factors (gamma = 0.5 and 1.5), we need two
% structures so we define sol1 and sol2
% Define as empty arrays, and then overwrite as we get the solution
% Structure fields are time, velocity, and angle

empty = {[],[],[],[],[],[],[],[],[],[],[]};                   % 11 sets, one for each gamma
sol1 = struct('time',empty,'velocity',empty,'angle',empty);   % Solution structure for gamma1 = 0.5
sol2 = struct('time',empty,'velocity',empty,'angle',empty);   % Solution structure for gamma2 = 1.5

tspan = [0 N*T0];                                             % Integration time goes from 0 to N*T0
opts = odeset('refine',6);                                    % Set up options

% Solving ODEs for Part (a)
% Solutions take the form
% [time, v] = ode45(function,t-axis,[initial_angle initial_speed],options,g,L,gamma)
% where v = [angle(t), velocity(t)] and 'equil' is time that pendulum reaches equilibrium

% Solve the ODE for omega = 2, one type of initial conditions
theta0 = 0 ;                                                % Initial angle
thetad0 = 1 ;                                               % Initial angular velocity
r0 = [theta0 thetad0];                                        % Initial conditions

% sol1(3) corresponds to the solution when gamma = gamma1 and omega = 2 (see definition of omega above)

[sol1(3).time, v] = ode45(@proj,tspan,r0,opts,g,L,gamma1,A,omega(3));
sol1(3).angle = v(:,1);                                        % angles = first column of v
sol1(3).velocity = v(:,2);                                     % angular velocities = second column of v





%                Create plot of angle vs. time for omega = 2

figure(1)                                                         % Figure 1
plot(sol1(3).time,sol1(3).angle);                                   % Plot angle vs. time
title(sprintf('Angle vs. Time for \\omega = 2, \\theta_0 = 1 '))  % Plot title
xlabel('t (s)')                                                   % Label x-axis
ylabel('\theta (rad)')                                            % Label y-axis





% Find the period as a function of number of cycle for gamma1 = 0.5 and omega = 2
ind = find(sol1(3).angle.*circshift(sol1(3).angle, [-1 0]) <= 0); % Find every turning point in trajectory
Period = zeros(1,length(ind)-1);                                  % Preallocate for speed
for i = 1:(length(ind)-1)                                       % For each cycle in trajectory,
    t1 = ind(i);                                                % First point of cycle
    t2 = ind(i+1);                                              % Second point of cycle
    Period(i) = sol1(3).time(t2) - sol1(3).time(t1);            % Period = Time between turning points
end

Cycles = linspace(1,length(ind)-1,length(ind)-1);               % Number of cycles in trajectory
    
AngFreq = 2*pi./Period;                                         % Angular frequency = 2*pi/T





%      Plot period and angular frequency per cycle for gamma1 = 0.5 and omega = 2

figure(2)                                         % Figure 2
plot(Cycles,Period,'-k',Cycles,AngFreq,'-b');     % Plot energy vs. time (DisplayName->Legend)
title(sprintf('Period and Angular Freq. vs. Cycle Number for \\gamma = 0.5 and \\omega = 2'))  % Plot title
legend('Period','Angular Frequency');             % Plot legend
xlabel('Number of Cycles')                        % Label x-axis
ylabel('Period (s) / Angular Frequency (rad/s)')  % Label y-axis





% Solve the ODE for omega = 2, second type of initial conditions
theta0 = 0.0 ;                                                % Initial angle
thetad0 = 1.0 ;                                               % Initial angular velocity
r0 = [theta0 thetad0];                                        % Initial conditions
[t4,w4] = ode45(@proj,tspan,r0,opts,g,L,gamma1,A,omega(3));


% Solve the ODE for omega = 1
theta0 = 0.0 ;                                 % Initial angle
thetad0 = 1.0 ;                                % Initial angular velocity
r0 = [theta0 thetad0];                         % Initial conditions
[t2,w2] = ode45(@proj,tspan,r0,opts,g,L,gamma1,A,omega(2));



% Solve the ODE for omega = 4
theta0 = 0.0 ;         % Initial angle
thetad0 = 1.0 ;        % Initial angular velocity
r0 = [theta0 thetad0]; % Initial conditions
[t11,w11] = ode45(@proj,tspan,r0,opts,g,L,gamma1,A,omega(11));

%{ 
Find the periods, but will do this code later to find how
period changes over time
ind1 = find(w1(:,2).*circshift(w1(:,2), [-1 0]) <= 0);
ind1 = chop(ind1,4);
period1 = 2*mean(diff(t1(ind1)));  % Find the period
ind2 = find(w2(:,2).*circshift(w2(:,2), [-1 0]) <= 0);
ind2 = chop(ind2,4);
period2 = 2*mean(diff(t2(ind2)));  % Find the period
%}

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
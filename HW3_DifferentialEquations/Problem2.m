function [sol] = Problem2(varargin) 
% Finds the period of a pendulum for large oscillations given the
% length of the pendulum arm and initial conditions. All angles in radians.
% Use the input "Problem2(L)" where
% L = length of pendulum
% and use L = 9.8/9 = 1.0889 to get g/L = 9





%                          Setting initial conditions

switch nargin
    case 0                                                   % If no input given
        error('Must input length and initial conditions')    % Give error
    case 1                                                   % If 1 input given
       L = varargin{1};                                      % Input = length of pendulum
end

g=9.81;                             % Acceleration due to gravity
omega = sqrt(g/L);                  % Natural angular frequency
T0= 2*pi/omega;                     % Period of simple harmonic oscillator
N = 5;                              % Number of oscillations to graph
m = 1;                              % Mass of pendulum bob
theta0 = [0.1 0.2 0.4 0.8 1.0];     % Initial angles
thetad0 = 0 ;                       % Initial angular velocity






%             Solve differential equation for different initial angles

% Define structure called "solution" or "sol" with fields 'time', 'velocity', and
% 'angle'
% Define as empty arrays, and then overwrite as we get the solution
% Structure fields are time, velocity, and angle

empty = {[],[],[],[],[]};                                    % 5 sets, one for each angle
sol = struct('time',empty,'velocity',empty,'angle',empty);   % Solution structure

tspan = [0 N*T0];                                            % Integration time goes from 0 to N*T0
opts = odeset('refine',6);                                   % Options used in the ODE solver

% Solve diff. eq. for 5 different initial angles
% Takes the form
% [time, v] = ode45(function,t-axis,[initial_angle initial_speed],options,g,L)
% where v = [angle(t), velocity(t)]

for i = 1:5                              % For each initial angle, solve ODEs
    [sol(i).time , v] = ode45(@proj,tspan,[theta0(i) thetad0],opts,g,L);
    sol(i).angle = v(:,1);               % angles = first column of v
    sol(i).velocity = v(:,2);            % angular velocities = second column of v
end





%                        Create plot of angle vs. time

colors = ['k' 'c' 'g' 'y' 'r'];                   % Make vector of colors for plot legend

figure(1)                                         % Figure 1
hold on                                           % Allows us to add trajectories to same plot
for i = 1:5                                       % For each initial angle,
    txt = [sprintf('\\theta_0 = '),num2str(theta0(i))];             % Define to use as legend
    plot(sol(i).time,sol(i).angle,colors(i),'DisplayName',txt);     % Plot angle vs. time (DisplayName->Legend)
    title(sprintf('Angle vs. Time'))              % Plot title
    xlabel('t (s)')                               % Label x-axis
    ylabel('\theta (rad)')                        % Label y-axis
    ylim([-2 2])                                  % y-axis range
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% The plots show that the position of the pendulum is clearly sinusoidal in
% nature, specifically that of a cosine function. The larger initial gives
% a slightly longer period, but not by much (at least not too noticeable
% over only a few periods).





%                 Create plot of angular velocity vs. time

figure(2)                                         % Figure 2
hold on                                           % Allows us to add trajectories to same plot
for i = 1:5                                       % For each initial angle,
    txt = [sprintf('\\theta_0 = '),num2str(theta0(i))];                % Define to use as legend
    plot(sol(i).time,sol(i).velocity,colors(i),'DisplayName',txt);     % Plot angle vs. time (DisplayName->Legend)
    title(sprintf('Angular Velocity vs. Time'))   % Plot title
    xlabel('t (s)')                               % Label x-axis
    ylabel('\omega (rad/s)')                      % Label y-axis
    ylim([-4 4])                                  % y-axis range
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% The plots show that the angular velocity of the pendulum is clearly 
% sinusoidal in nature, specifically that of a negative sine function. This
% makes sense since it is the derivative of the cosine function from the
% position of the pendulum.





%         Find the period and maximum angle for each initial angle

Period = zeros(1,5);                                % Preallocate to save computing time
ThetaMax = zeros(1,5);                              % Preallocate to save computing time

% Find the period and maximum angle
for i = 1:5                                         % For each initial angle
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0);
    Period(i) = 2*mean(diff(sol(i).time(ind)));     % Find the period
    ThetaMax(i) = max(sol(i).angle);                % Find the maximum angle
end





%                      Plot period vs. maximum angle

figure(3)                                    % Figure 3
plot(ThetaMax,Period,'ok-')                  % Plot Period (T) vs. Max. Angle
title('Period vs. \theta_{max}')             % Plot title 
xlabel('\theta_{max}')                       % Label x-axis
ylabel('T')                                  % Label y-axis
ylim([1.5 2.5])

% The graph shows an increase in period for larger initial angles. The
% period increases slightly, but not by a lot. This makes sense, since the
% small-angle approximation no longer applies for larger angles, therefore
% the period is not independent of the amplitude.





%                 Define a structure for energies

% Fields are 'Kinetic Energy', 'Potential Energy', and 'Total Energy'
energy = struct('KE',empty,'U',empty,'Etot',empty);

% Define energies
for i = 1:5                                           % For each initial angle,
    energy(i).KE = m*(L^2)*(sol(i).velocity).^2/2 ;   % Kinetic energy = mv^2/2
    energy(i).U = m*g*L*(1-cos(sol(i).angle)) ;       % Potential energy = mgL(1-cos(theta))
    energy(i).Etot = energy(i).KE + energy(i).U ;     % Total energy = KE + U
end





%                  Plot total energy over time

figure(4)                                         % Figure 4
hold on                                           % Allows us to add trajectories to same plot
for i = 1:5                                       % For each initial angle,
    txt = [sprintf('\\theta_0 = '),num2str(theta0(i))];                % Define to use as legend
    plot(sol(i).time,energy(i).Etot,colors(i),'DisplayName',txt);      % Plot angle vs. time (DisplayName->Legend)
    title('Total Energy vs. Time')                % Plot title
    xlabel('t (s)')                               % Label x-axis
    ylabel('Total Energy (J)')                    % Label y-axis
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% The energies are plotted, and do not drift from the initial value by much
% at all. Therefore, the solution is stable.





end
%-------------------------------------------



% t = x-axis
% r = column vector: [theta; theta_velocity]
% g = 9.8
% L = length of pendulum
function rdot = proj(t,r,g,L)
    rdot = [r(2); -g/L*sin(r(1))];
end
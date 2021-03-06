function [sol] = Problem3(varargin) 
% Finds the period of a damped pendulum for large oscillations given the
% length of the pendulum arm and initial conditions. All angles in radians.
% Use the input "Problem3(L)" where
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
theta0 = 1.0 ;                      % Initial angle
thetad0 = 0.0 ;                     % Initial angular velocity
gamma = [0 0.5 1 2 3 4 5 6 7 8 9];  % Damping factor





%              Solve differential equation for different damping factors

% Define structure called "solution" or "sol" with fields 'time', 'velocity', and
% 'angle'
% Define as empty arrays, and then overwrite as we get the solution
% Structure fields are time, velocity, and angle

empty = {[],[],[],[],[],[],[],[],[],[],[]};                  % 11 sets, one for each gamma
sol = struct('time',empty,'velocity',empty,'angle',empty);   % Solution structure

tspan = [0 N*T0];                                            % Integration time goes from 0 to N*T0
opts = odeset('refine',6,'Events',@thetazero);               % Options
equilibrium = zeros(1,11);                                   % Preallocate equilibrium times

% Solve diff. eq. for 11 different damping factors
% Takes the form
% [time, v] = ode45(function,t-axis,[initial_angle initial_speed],options,g,L,gamma)
% where v = [angle(t), velocity(t)] and 'equil' is time that pendulum reaches equilibrium

for i = 1:11                             % For each damping factor, solve ODEs
    [sol(i).time, v,equil] = ode45(@proj,tspan,[theta0 thetad0],opts,g,L,gamma(i));
    sol(i).angle = v(:,1);               % angles = first column of v
    sol(i).velocity = v(:,2);            % angular velocities = second column of v
    if equil > 0                         % If pendulum reaches equilibrium,
        equilibrium(i) = equil;          % Put equilibrium time in vector called 'equilibrium'
    else                                 % If pendulum does not reach equilibrium
        equilibrium(i) = NaN;            % No equilibrium time exists
    end
end





%                        Create plot of angle vs. time

colors = ['k' 'c' 'g' 'y' 'r' 'k' 'c' 'g' 'y' 'r' 'k'];    % Make vector of colors for plot legend

figure(1)                                         % Figure 1
hold on                                           % Allows us to add trajectories to same plot
for i = 1:11                                      % For each gamma/damping factor,
    txt = [sprintf('\\gamma = '),num2str(gamma(i))];                % Define to use as legend
    plot(sol(i).time,sol(i).angle,colors(i),'DisplayName',txt);     % Plot angle vs. time (DisplayName->Legend)
    title(sprintf('Angle vs. Time'))              % Plot title
    xlabel('t (s)')                               % Label x-axis
    ylabel('\theta (rad)')                        % Label y-axis
    ylim([-2 2])                                  % y-axis range
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% The plot shows the motion of a pendulum with no damping, and then the
% motion of a pendulum as we slowly change the damping factor. For no
% damping, the motion is purely sinusoidal. For non-zero damping, the
% solution is sinusoidal with an envelope that decays exponentially, up
% until gamma is about 4 or so. After that, it's mostly just an exponential
% decay.





%             Find the period for each gamma/damping factor

Period = zeros(1,11);                               % Preallocate to save computing time
for i = 1:11                                        % For each initial angle
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0);
    Period(i) = 2*mean(diff(sol(i).time(ind)));     % Find the period
end
Frequency = 1./Period;                              % Define frequency as f = 1/T





%           Plot Period and Frequency vs. gamma (damping factor)
figure(2)                                             % Figure 2
plot(gamma,Period,'ok-',gamma,Frequency,'ob-');       % Plot Period and Frequency vs. gamma
legend('Period','Frequency')                          % Plot legend
title(sprintf('Period and Frequency vs. \\gamma'))    % Plot title
xlabel(sprintf('\\gamma'))                            % Label x-axis
ylabel('Period/Frequency')                            % Label y-axis
ylim([0 4])                                           % y-axis range

% The period is almost constant for low gamma (gamma < 2) but then
% increases after that. After gamma ? 4, the period increases and the
% frequency decreases. Eventually, the period goes to infinity since the
% motion is no longer sinusoidal.





%                 Define a structure for energies

% Fields are 'Kinetic Energy', 'Potential Energy', and 'Total Energy'
energy = struct('KE',empty,'U',empty,'Etot',empty);

% Define energies
for i = 1:11                                          % For each gamma,
    energy(i).KE = m*(L^2)*(sol(i).velocity).^2/2 ;   % Kinetic energy = mv^2/2
    energy(i).U = m*g*L*(1-cos(sol(i).angle)) ;       % Potential energy = mgL(1-cos(theta))
    energy(i).Etot = energy(i).KE + energy(i).U ;     % Total energy = KE + U
end





%                   Find average energies per cycle

% Define average energy structure
% Fields are 'Average Kinetic Energy', 'Average Potential Energy', 
% 'Average Total Energy', and 'Cycles'
avg_energy = struct('Kavg',empty,'Uavg',empty,'Eavg',empty,'Cycles',empty);

% Fill in structures
for i = 1:11                                                     % For each gamma,
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0); % Find every turning point in trajectory
    for j = 1:(length(ind)-1)                                    % For each cycle in trajectory,
        t1 = ind(j);                                             % First point of cycle
        t2 = ind(j+1);                                           % Second point of cycle
        avg_energy(i).Kavg(j) = mean(energy(i).KE(t1:t2));       % Average KE during cycle
        avg_energy(i).Uavg(j) = mean(energy(i).U(t1:t2));        % Average U during cycle
        avg_energy(i).Eavg(j) = mean(energy(i).Etot(t1:t2));     % Average Etot during cycle
    end
    avg_energy(i).Cycles = linspace(1,length(ind)-1,length(ind)-1);  % Number of cycles in trajectory
end





%                  Plot average total energy over time

figure(3)                                         % Figure 3
hold on                                           % Allows us to add trajectories to same plot
for i = 1:11                                      % For each gamma/damping factor,
    txt = [sprintf('\\gamma = '),num2str(gamma(i))];                             % Define to use as legend
    plot(avg_energy(i).Cycles,avg_energy(i).Eavg,colors(i),'DisplayName',txt);   % Plot energy vs. time (DisplayName->Legend)
    title('Average Total Energy vs. Time')        % Plot title
    xlabel('Number of Cycles')                    % Label x-axis
    ylabel('Average Total Energy (J)')            % Label y-axis
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% For gamma = 0, the average total energy is constant. As gamma increases,
% the average total energy decreases in a non-linear behavior, likely an
% exponential decay.





%                  Plot average kinetic energy over time

figure(4)                                         % Figure 4
hold on                                           % Allows us to add trajectories to same plot
for i = 1:11                                      % For each gamma/damping factor,
    txt = [sprintf('\\gamma = '),num2str(gamma(i))];                             % Define to use as legend
    plot(avg_energy(i).Cycles,avg_energy(i).Kavg,colors(i),'DisplayName',txt);   % Plot energy vs. time (DisplayName->Legend)
    title('Average Kinetic Energy vs. Time')      % Plot title
    xlabel('Number of Cycles')                    % Label x-axis
    ylabel('Average Kinetic Energy (J)')          % Label y-axis
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% For gamma = 0, the average kinetic energy is constant. As gamma increases,
% the average kinetic energy decreases in a non-linear behavior, likely an
% exponential decay. This has the same behavior as the average total and
% average potential energy graphs.





%                  Plot average potential energy over time

figure(5)                                         % Figure 5
hold on                                           % Allows us to add trajectories to same plot
for i = 1:11                                      % For each gamma/damping factor,
    txt = [sprintf('\\gamma = '),num2str(gamma(i))];                             % Define to use as legend
    plot(avg_energy(i).Cycles,avg_energy(i).Uavg,colors(i),'DisplayName',txt);   % Plot energy vs. time (DisplayName->Legend)
    title('Average Potential Energy vs. Time')    % Plot title
    xlabel('Number of Cycles')                    % Label x-axis
    ylabel('Average Potential Energy (J)')        % Label y-axis
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% For gamma = 0, the average potential energy is constant. As gamma increases,
% the average potential energy decreases in a non-linear behavior, likely an
% exponential decay. This has the same behavior as the average total and
% average kinetic energy graphs.





%                 Create plot of Equilibrium Time vs. gamma

figure(6)                                         % Figure 6
plot(gamma,equilibrium,'-ok');                    % Plot Equil. Time vs. gamma/damping factor
title(sprintf('Equilibrium Time vs. \\gamma'))    % Plot title
xlabel(sprintf('\\gamma'))                        % Label x-axis
ylabel('Equilibrium Time (s)')                    % Label y-axis
xlim([min(gamma) max(gamma)])                     % x-axis spans all gamma values





%                  Plot phase space (angle, velocity)
figure(7)                                         % Figure 7
hold on                                           % Allows us to add trajectories to same plot
for i = [2 4 6 8 10]                              % For certain gammas (defined in HW)
    txt = [sprintf('\\gamma = '),num2str(gamma(i))];                % Define to use as legend
    plot(sol(i).angle,sol(i).velocity,colors(i),'DisplayName',txt); % Plot velocity vs. angle (DisplayName->Legend)
    title('Velocity vs. Angle')                   % Plot title
    xlabel(sprintf('\\theta (rad)'))              % Label x-axis
    ylabel(sprintf('\\omega (rad/s)'))            % Label y-axis
end                                               % End for loop
hold off                                          % Hold off
legend show                                       % Display the legend

% The phase space paths each depend on gamma. For gamma = 0, the path is an
% ellipse, orbiting around the center. As gamma increases, the path spirals
% towards the center, and for higher values of gamma, the path almost falls
% in towards the center.





%-------------------------------------------



%t = x-axis
%r = column vector: [theta; theta_velocity]
%g = 9.8
%L = length of pendulum
function rdot = proj(t,r,g,L,gamma)
    rdot = [r(2); -g/L*sin(r(1)) - gamma*r(2)];
end

function [check,isterminal,direction] = thetazero(t,r,g,L,gamma)
    direction = []; % Use default settings (detect both increasing and decreasing theta)
    isterminal = 1; % Stop integration once we reach equilibrium
    check = double(abs(r(1)) < 0.0001);  % If magnitude of angle is very small
    % End the calculation

    
end
end
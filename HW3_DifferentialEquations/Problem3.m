function [period,sol] = Problem3(varargin) 
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

% Solve diff. eq. for 11 different damping factors
% Takes the form
% [time, v] = ode45(function,t-axis,[initial_angle initial_speed],options,g,L,gamma)
% where v = [angle(t), velocity(t)]

for i = 1:11                             % For each damping factor, solve ODEs
    [sol(i).time , v] = ode45(@proj,tspan,[theta0 thetad0],opts,g,L,gamma(i));
    sol(i).angle = v(:,1);               % angles = first column of v
    sol(i).velocity = v(:,2);            % angular velocities = second column of v
end





%                       Create plots of angle vs. time

colors = ['k' 'c' 'g' 'y' 'r' 'k' 'c' 'g' 'y' 'r' 'k'];    % Make vector of colors for plot legend

figure(1)                                         % Figure 2
hold on                                           % Allows us to add trajectories to same plot
for i = 1:11                                      % For each gamma/damping factor,
    plot(sol(i).time,sol(i).angle,colors(i));     % Plot angle vs. time
    legend(sprintf('\\gamma = %0.1f',gamma(i)))   % Plot legend
    title(sprintf('Angle vs. Time'))              % Plot title
    xlabel('t (s)')                               % Label x-axis
    ylabel('\theta (rad)')                        % Label y-axis
    ylim([-2 2])                                  % y-axis range
end                                               % End for loop
hold off                                          % Hold off





%             Find the period for each gamma/damping factor

Period = zeros(1,11);                    % Preallocate to save computing time
for i = 1:11
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0);
    Period(i) = 2*mean(diff(sol(i).time(ind)));
end
Frequency = 1./Period;                   % Define frequency as f = 1/T





%           Plot Period and Frequency vs. gamma (damping factor)
figure(2)                                             % Figure 1
plot(gamma,Period,'ok-',gamma,Frequency,'ob-');       % Plot Period and Frequency vs. gamma
legend('Period','Frequency')                          % Plot legend
title(sprintf('Period and Frequency vs. \\gamma'))    % Plot title
xlabel(sprintf('\\gamma'))                            % Label x-axis
ylabel('Period/Frequency')                            % Label y-axis
ylim([0 4])                                           % y-axis range





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
% Define avg energy structure
% Fields are 'Average Kinetic Energy', 'Average Potential Energy',
% and 'Average Total Energy'
avg_energy = struct('Kavg',empty,'Uavg',empty,'Eavg',empty);

% Fill in structures
for i = 1:11                                               % For each gamma,
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0); % Find each cycle
    avg_energy(i).Kavg = mean(energy(i).KE(ind));          % Average KE
    avg_energy(i).Uavg = mean(energy(i).U(ind));           % Average U
    avg_energy(i).Eavg = mean(energy(i).Etot(ind));        % Average Etot
end





%                  Plot average kinetic energy over time

colors = ['k' 'c' 'g' 'y' 'r' 'k' 'c' 'g' 'y' 'r' 'k'];    % Make vector of colors for plot legend

figure(3)                                         % Figure 2
hold on                                           % Allows us to add trajectories to same plot
for i = 1:11                                      % For each gamma/damping factor,
    plot(sol(i).time,avg_energy(i).Kavg,colors(i));     % Plot angle vs. time
    legend(sprintf('\\gamma = %0.1f',gamma(i)))   % Plot legend
    title(sprintf('Angle vs. Time'))              % Plot title
    xlabel('t (s)')                               % Label x-axis
    ylabel('\theta (rad)')                        % Label y-axis
    ylim([-2 2])                                  % y-axis range
end                                               % End for loop
hold off                                          % Hold off





figure(4)
subplot(3,1,1)
plot(t0,w0(:,1),'k-',t1,w1(:,1),'c-',t2,w2(:,1),'r-',t3,w3(:,1),'g-',t4,w4(:,1),'y-')
legend('\gamma = 0','\gamma = 0.5','\gamma = 1','\gamma = 2','\gamma = 3')
title('Angle vs. Time for Different \gamma ''s')
xlabel('t')
ylabel('\theta')
ylim([-1 1])

subplot(3,1,2)
plot(gamma,Period,'k-')
title('Period vs. \gamma')
xlabel('T')
ylabel('\gamma')

AngFreq = zeros(1,11) ;
for i = 1:11
    AngFreq(i) = 2*pi./Period(i) ;
end

subplot(3,1,3)
plot(gamma,AngFreq,'k-')
title('Angular Frequency vs. \gamma')
xlabel('\omega')
ylabel('\gamma')



figure(5)
plot(t1,E1,'k',t4,E4,'c',t6,E6,'g',t8,E8,'y',t10,E10,'r')
legend('\gamma = 0.5','\gamma = 2','\gamma = 4','\gamma = 6','\gamma = 8')
title('Total Energy')
xlabel('t')
ylabel('Energy')

figure(6)
plot(w1(:,1),w1(:,2),'k-',w4(:,1),w4(:,2),'c-',w6(:,1),w6(:,2),'g-',w8(:,1),w8(:,2),'r-',w10(:,1),w10(:,2),'y-')
legend('\gamma = 0.5','\gamma = 2','\gamma = 4','\gamma = 6','\gamma = 8')
title('Phase Space')
xlabel('\theta')
ylabel('\theta dot')
xlim([-1.5 1.5])
ylim([-3 3])










%-------------------------------------------



%t = x-axis
%r = column vector: [theta; theta_velocity]
%g = 9.8
%L = length of pendulum
function rdot = proj(t,r,g,L,gamma)
    rdot = [r(2); -g/L*sin(r(1)) - gamma*r(2)];
end

function [check,isterminal,direction] = thetazero(t,r,g,L,gamma)
    direction = []; % Use default settings
    isterminal = 1;
    check = double(abs(r(1)) < 0.0001);  % If magnitude of angle is too small
    % end the calculation

    
end
end
function [period,sol] = Problem3(varargin) 
% Finds the period of a damped pendulum for large oscillations given the
% length of the pendulum arm and initial conditions. All angles in radians.
% Use the input "Problem3(L)" where
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
T0= 2*pi/omega;                     % Period of simple harmonic oscillator
N = 6;                              % Number of oscillations to graph
m = 1;                              % Mass of pendulum bob
theta0 = 1.0 ;                      % Initial angle
thetad0 = 0.0 ;                     % Initial angular velocity
gamma = [0 0.5 1 2 3 4 5 6 7 8 9];

% Solve differential equation for different damping factors
% Define structure called "solution" or "sol" with fields 'time', 'velocity', and
% 'angle'
% Define as empty arrays, and then overwrite as we get the solution
% Structure fields are time, velocity, and angle

empty = {[],[],[],[],[],[],[],[],[],[],[]};         % 11 sets, one for each gamma
sol = struct('time',empty,'velocity',empty,'angle',empty);

tspan = [0 N*T0];               % Integration time goes from 0 to N*T0
opts = odeset('refine',6,'Events',@thetazero);

% Solve diff. eq. for five different initial angles
% Takes the form
% [time, angle(t)] = ode45(function,t-axis,[initial_angle initial_speed],options,g,L)

for i = 1:11
    [sol(i).time , v] = ode45(@proj,tspan,[theta0(i) thetad0],opts,g,L);
    sol(i).angle = v(:,1);
    sol(i).velocity = v(:,2);
end

Period = zeros(1,11);       % Preallocate to save computing time

% Find the period and maximum angle
for i = 1:11
    ind = find(sol(i).angle.*circshift(sol(i).angle, [-1 0]) <= 0);
    Period(i) = 2*mean(diff(sol(i).time(ind)));
end


% Now define a structure for energies

energy = struct('KE',empty,'U',empty,'Etot',empty);

% Define energies
for i = 1:11
    energy(i).KE = m*(L^2)*(sol(i).velocity).^2/2 ;   % Kinetic energy
    energy(i).U = m*g*L*(1-cos(sol(i).angle)) ;       % Potential energy
    energy(i).Etot = energy(i).KE + energy(i).U ;     % Total energy
end


% Create plots

figure(1)
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



figure(2)
plot(t1,E1,'k',t4,E4,'c',t6,E6,'g',t8,E8,'y',t10,E10,'r')
legend('\gamma = 0.5','\gamma = 2','\gamma = 4','\gamma = 6','\gamma = 8')
title('Total Energy')
xlabel('t')
ylabel('Energy')

figure(3)
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

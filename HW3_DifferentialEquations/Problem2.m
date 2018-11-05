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

g=9.81;
omega = sqrt(g/L);
T0= 2*pi/omega;
N = 5;         % Number of oscillations to graph
m = 1;         % Mass of pendulum bob
thetad0 = 0 ;  % Initial angular speed = 0

theta0 = [0.1 0.2 0.4 0.8 1.0]; % Initial angles

% Solve differential equation for 5 different initial angles

% Define structure called "solution" with fields 'time', 'velocity', and
% 'angle'

% Define as empty arrays, and then overwrite as we get the solution

value = {[],[],[],[],[],[],[],[],[],[]};
solution = structure('time',value,'velocity',value,'angle',value);




r1 = [theta0(1) thetad0];
[t1,w1] = ode45(@proj,tspan,r1,opts,g,L);


theta2 = 0.2 ;
r2 = [theta2 thetad0];

theta3 = 0.4 ;
r3 = [theta3 thetad0];

theta4 = 0.8 ;
r4 = [theta4 thetad0];

theta5 = 1.0 ;
r5 = [theta5 thetad0];

tspan = [0 N*T0];           % Integration time goes from 0 to N*T0
%opts = odeset('events',@events,'refine',6); %Here for future event finder
opts = odeset('refine',6);

% Solve diff. eq. for five different initial conditions, r1 <--> r5
[solution(1).velocity,solution(1).angle] = ode45(@proj,solution(1).time,r1,opts,g,L);

[t1,w1] = ode45(@proj,tspan,r1,opts,g,L);
[t2,w2] = ode45(@proj,tspan,r2,opts,g,L);
[t3,w3] = ode45(@proj,tspan,r3,opts,g,L);
[t4,w4] = ode45(@proj,tspan,r4,opts,g,L);
[t5,w5] = ode45(@proj,tspan,r5,opts,g,L);

ind1= find(w1(:,2).*circshift(w1(:,2), [-1 0]) <= 0);
ind1 = chop(ind1,4);
period1 = 2*mean(diff(t1(ind1)));

ind2= find(w2(:,2).*circshift(w2(:,2), [-1 0]) <= 0);
ind2 = chop(ind2,4);
period2 = 2*mean(diff(t2(ind2)));

ind3= find(w3(:,2).*circshift(w3(:,2), [-1 0]) <= 0);
ind3 = chop(ind3,4);
period3 = 2*mean(diff(t3(ind3)));

ind4= find(w4(:,2).*circshift(w4(:,2), [-1 0]) <= 0);
ind4 = chop(ind4,4);
period4 = 2*mean(diff(t4(ind4)));

ind5= find(w5(:,2).*circshift(w5(:,2), [-1 0]) <= 0);
ind5 = chop(ind5,4);
period5 = 2*mean(diff(t5(ind5)));







% Define energies
K1 = m*(L^2)*(w1(:,2).^2)/2;   % Kinetic energy
U1 = m*g*L*(1-cos(w1(:,1))) ;  % Potential energy
E1 = K1 + U1 ;                 % Total energy
Einitial1 = E1(1);             % Initial energy
deltaE1 = E1 - Einitial1;      % Change in energy over cycle
Kavg1 = linspace(mean(K1),mean(K1),length(t1));   % Average kinetic energy
Uavg1 = linspace(mean(U1),mean(U1),length(t1));   % Average potential energy

% Define energies
K2 = m*(L^2)*(w2(:,2).^2)/2;   % Kinetic energy
U2 = m*g*L*(1-cos(w2(:,1))) ;  % Potential energy
E2 = K2 + U2 ;                 % Total energy
Einitial2 = E2(1);             % Initial energy
deltaE2 = E2 - Einitial2;      % Change in energy over cycle
Kavg2 = linspace(mean(K2),mean(K2),length(t2));   % Average kinetic energy
Uavg2 = linspace(mean(U2),mean(U2),length(t2));   % Average potential energy

% Define energies
K3 = m*(L^2)*(w3(:,2).^2)/2;   % Kinetic energy
U3 = m*g*L*(1-cos(w3(:,1))) ;  % Potential energy
E3 = K3 + U3 ;                 % Total energy
Einitial3 = E3(1);             % Initial energy
deltaE3 = E3 - Einitial3;      % Change in energy over cycle
Kavg3 = linspace(mean(K3),mean(K3),length(t3));   % Average kinetic energy
Uavg3 = linspace(mean(U3),mean(U3),length(t3));   % Average potential energy

% Define energies
K4 = m*(L^2)*(w4(:,2).^2)/2;   % Kinetic energy
U4 = m*g*L*(1-cos(w4(:,1))) ;  % Potential energy
E4 = K4 + U4 ;                 % Total energy
Einitial4 = E4(1);             % Initial energy
deltaE4 = E4 - Einitial4;      % Change in energy over cycle
Kavg4 = linspace(mean(K4),mean(K4),length(t4));   % Average kinetic energy
Uavg4 = linspace(mean(U4),mean(U4),length(t4));   % Average potential energy

% Define energies
K5 = m*(L^2)*(w5(:,2).^2)/2;   % Kinetic energy
U5 = m*g*L*(1-cos(w5(:,1))) ;  % Potential energy
E5 = K5 + U5 ;                 % Total energy
Einitial5 = E5(1);             % Initial energy
deltaE5 = E5 - Einitial5;      % Change in energy over cycle
Kavg5 = linspace(mean(K5),mean(K5),length(t5));   % Average kinetic energy
Uavg5 = linspace(mean(U5),mean(U5),length(t5));   % Average potential energy






% Create plots

figure(1)
subplot(3,1,1)
plot(t1,w1(:,1),'k-',t1,w1(:,2),'b--')
legend('Angle','Angular Velocity')
title('Angle and Angular Velocity for \theta_0 = 0.1')
xlabel('t')
ylabel('\theta')
ylim([-2 2])

subplot(3,1,2)
plot(t2,w2(:,1),'k-',t2,w2(:,2),'b--')
legend('Angle','Angular Velocity')
title('Angle and Angular Velocity for \theta_0 = 0.2')
xlabel('t')
ylabel('\theta')
ylim([-2 2])

subplot(3,1,3)
plot(t3,w3(:,1),'k-',t3,w3(:,2),'b--')
legend('Angle','Angular Velocity')
title('Angle and Angular Velocity for \theta_0 = 0.4')
xlabel('t')
ylabel('\theta')
ylim([-2 2])

figure(2)
subplot(2,1,1)
plot(t4,w4(:,1),'k-',t4,w4(:,2),'b--')
legend('Angle','Angular Velocity')
title('Angle and Angular Velocity for \theta_0 = 0.8')
xlabel('t')
ylabel('\theta')
ylim([-3 3])

subplot(2,1,2)
plot(t5,w5(:,1),'k-',t5,w5(:,2),'b--')
legend('Angle','Angular Velocity')
title('Angle and Angular Velocity for \theta_0 = 1.0')
xlabel('t')
ylabel('\theta')
ylim([-3 3])

figure(3)
plot(t1,E1,'k',t2,E2,'c',t3,E3,'g',t4,E4,'y',t5,E5,'r')
legend('\theta_0=0.1','\theta_0=0.2','\theta_0=0.4','\theta_0=0.8','\theta_0=1.0')
title('Total Energy')
xlabel('t')
ylabel('Energy')




Period = [period1 period2 period3 period4 period5] ;
ThetaMax = [max(w1(:,1)) max(w2(:,1)) max(w3(:,1)) max(w4(:,1)) max(w5(:,1))];

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
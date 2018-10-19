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

g=9.81;
omega = sqrt(g/L);
T0= 2*pi/omega; % Period of simple harmonic oscillator
N = 6;          % Number of oscillations to graph
m = 1;          % Mass of pendulum bob
theta0 = 1.0 ;  % Initial angle
thetad0 = 0.0 ; % Initial angular velocity
r0 = [theta0 thetad0]; % Initial conditions

% Solve differential equation for different damping factors
gamma = [0 0.5 1 2 3 4 5 6 7 8 9];

tspan = [0 N*T0];           % Integration time goes from 0 to N*T0
%opts = odeset('events',@events,'refine',6); %Here for future event finder
opts = odeset('refine',6,'Events',@thetazero);

% Solve diff. eq. for 10 different initial conditions, gamma1 <--> gamma5
[t0,w0] = ode45(@proj,tspan,r0,opts,g,L,gamma(1));
[t1,w1] = ode45(@proj,tspan,r0,opts,g,L,gamma(2));
[t2,w2] = ode45(@proj,tspan,r0,opts,g,L,gamma(3));
[t3,w3] = ode45(@proj,tspan,r0,opts,g,L,gamma(4));
[t4,w4] = ode45(@proj,tspan,r0,opts,g,L,gamma(5));
[t5,w5] = ode45(@proj,tspan,r0,opts,g,L,gamma(6));
[t6,w6] = ode45(@proj,tspan,r0,opts,g,L,gamma(7));
[t7,w7] = ode45(@proj,tspan,r0,opts,g,L,gamma(8));
[t8,w8] = ode45(@proj,tspan,r0,opts,g,L,gamma(9));
[t9,w9] = ode45(@proj,tspan,r0,opts,g,L,gamma(10));
[t10,w10] = ode45(@proj,tspan,r0,opts,g,L,gamma(11));


ind0 = find(w0(:,2).*circshift(w0(:,2), [-1 0]) <= 0);
ind1 = find(w1(:,2).*circshift(w1(:,2), [-1 0]) <= 0);
ind2 = find(w2(:,2).*circshift(w2(:,2), [-1 0]) <= 0);
ind3 = find(w3(:,2).*circshift(w3(:,2), [-1 0]) <= 0);
ind4 = find(w4(:,2).*circshift(w4(:,2), [-1 0]) <= 0);
ind5 = find(w5(:,2).*circshift(w5(:,2), [-1 0]) <= 0);
ind6 = find(w6(:,2).*circshift(w6(:,2), [-1 0]) <= 0);
ind7 = find(w7(:,2).*circshift(w7(:,2), [-1 0]) <= 0);
ind8 = find(w8(:,2).*circshift(w8(:,2), [-1 0]) <= 0);
ind9 = find(w9(:,2).*circshift(w9(:,2), [-1 0]) <= 0);
ind10 = find(w10(:,2).*circshift(w10(:,2), [-1 0]) <= 0);


ind0 = chop(ind0,4);
ind1 = chop(ind1,4);
ind2 = chop(ind2,4);
ind3 = chop(ind3,4);
ind4 = chop(ind4,4);
ind5 = chop(ind5,4);
ind6 = chop(ind6,4);
ind7 = chop(ind7,4);
ind8 = chop(ind8,4);
ind9 = chop(ind9,4);
ind10 = chop(ind10,4);

period0 = 2*mean(diff(t1(ind0)));
period1 = 2*mean(diff(t1(ind1)));
period2 = 2*mean(diff(t2(ind2)));
period3 = 2*mean(diff(t3(ind3)));
period4 = 2*mean(diff(t4(ind4)));
period5 = 2*mean(diff(t5(ind5)));
period6 = 2*mean(diff(t6(ind6)));
period7 = 2*mean(diff(t7(ind7)));
period8 = 2*mean(diff(t8(ind8)));
period9 = 2*mean(diff(t9(ind9)));
period10 = 2*mean(diff(t10(ind10)));

% Period vector has components which are periods, depending on damping
% factor
Period = [period0 period1 period2 period3 period4 period5 period6 period7 period8 period9 period10] ;




% Define energies

% Kinetic energy
K0 = m*(L^2)*(w0(:,2).^2)/2; 
K1 = m*(L^2)*(w1(:,2).^2)/2;
K2 = m*(L^2)*(w2(:,2).^2)/2;
K3 = m*(L^2)*(w3(:,2).^2)/2;
K4 = m*(L^2)*(w4(:,2).^2)/2;
K5 = m*(L^2)*(w5(:,2).^2)/2;
K6 = m*(L^2)*(w6(:,2).^2)/2;
K7 = m*(L^2)*(w7(:,2).^2)/2;
K8 = m*(L^2)*(w8(:,2).^2)/2;
K9 = m*(L^2)*(w9(:,2).^2)/2;
K10 = m*(L^2)*(w10(:,2).^2)/2;


% Potential energy
U0 = m*g*L*(1-cos(w0(:,1))) ;
U1 = m*g*L*(1-cos(w1(:,1))) ;
U2 = m*g*L*(1-cos(w2(:,1))) ;
U3 = m*g*L*(1-cos(w3(:,1))) ;
U4 = m*g*L*(1-cos(w4(:,1))) ;
U5 = m*g*L*(1-cos(w5(:,1))) ;
U6 = m*g*L*(1-cos(w6(:,1))) ;
U7 = m*g*L*(1-cos(w7(:,1))) ;
U8 = m*g*L*(1-cos(w8(:,1))) ;
U9 = m*g*L*(1-cos(w9(:,1))) ;
U10 = m*g*L*(1-cos(w10(:,1))) ;

% Total energy
E0 = K0 + U0 ;
E1 = K1 + U1 ;
E2 = K2 + U2 ;
E3 = K3 + U3 ;
E4 = K4 + U4 ;
E5 = K5 + U5 ;
E6 = K6 + U6 ;
E7 = K7 + U7 ;
E8 = K8 + U8 ;
E9 = K9 + U9 ;
E10 = K10 + U10 ;

% Average kinetic energy
Kavg0 = linspace(mean(K0),mean(K0),length(t0));
Kavg1 = linspace(mean(K1),mean(K1),length(t1));
Kavg2 = linspace(mean(K2),mean(K2),length(t2));
Kavg3 = linspace(mean(K3),mean(K3),length(t3));
Kavg4 = linspace(mean(K4),mean(K4),length(t4));
Kavg5 = linspace(mean(K5),mean(K5),length(t5));
Kavg6 = linspace(mean(K6),mean(K6),length(t6));
Kavg7 = linspace(mean(K7),mean(K7),length(t7));
Kavg8 = linspace(mean(K8),mean(K8),length(t8));
Kavg9 = linspace(mean(K9),mean(K9),length(t9));
Kavg10 = linspace(mean(K10),mean(K10),length(t10));

% Average potential energy
Uavg0 = linspace(mean(U0),mean(U0),length(t0));
Uavg1 = linspace(mean(U1),mean(U1),length(t1));
Uavg2 = linspace(mean(U2),mean(U2),length(t2));
Uavg3 = linspace(mean(U3),mean(U3),length(t3));
Uavg4 = linspace(mean(U4),mean(U4),length(t4));
Uavg5 = linspace(mean(U5),mean(U5),length(t5));
Uavg6 = linspace(mean(U6),mean(U6),length(t6));
Uavg7 = linspace(mean(U7),mean(U7),length(t7));
Uavg8 = linspace(mean(U8),mean(U8),length(t8));
Uavg9 = linspace(mean(U9),mean(U9),length(t9));
Uavg10 = linspace(mean(U10),mean(U10),length(t10));






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









end
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
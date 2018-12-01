%{ 
This program finds the electric potential and field in between a parallel
plate capacitor. 
%}

epsilon = 8.85e-12;          % Permittivity of free space
k = 1./(4.*pi.*epsilon);     % Coulomb's constant
N = 25;                      % Number of data points

% Linear charge densities
L1 = 1;                      % Top plate
L2 = -1;                     % Bottom plate

%dimensions of rods
xa = 0;
xb = 1;
ya = 0;
yb = 0.75;

%all space dimensions
x1 = -0.5;
x2 = 2;
y1 = -1;
y2 = 1.5;

%x and y values 
x = linspace(x1,x2,N);
y = linspace(y1,y2,N);

V1 = zeros(N,N);
V2 = zeros(N,N);

%integrate over all space
for j = 1:N
    for i = 1:N
        integrand2 = @(xp) k.*L2./(sqrt((x(i)-xp).^2+(y(j)-ya).^2));
        V2(i,j) = integral(integrand2,xa,xb);
        integrand1 = @(xp) k.*L1./(sqrt((x(i)-xp).^2+(y(j)-yb).^2));
        V1(i,j) = integral(integrand1,xa,xb);
    end
end
V = V1+V2;

figure(1)
contourf(x,y,V.');        % Plot a 2D color map
pcolor(x,y,V.');          % Removes solid contours, adds grid
hold on;
shading interp;           % Removes grid
colorbar('southoutside')  % Adds horizontal color bar on bottom of contour

% Now find the electric field, E = - (dV/dx, dV/dy, dV/dz)
[Ex,Ey] = gradient(-V.',1/N,1/N) ;

E = sqrt(Ex.^2 + Ey.^2);
Exn = Ex./E;
Eyn = Ey./E;

figure(2)
quiver(x,y,Exn,Eyn,1)
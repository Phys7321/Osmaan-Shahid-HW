%{
The function "HorizontalLinePotential" finds the potential V on the xy-axes due to a
linear charge density L(x) that is parallel to the x-axis. The left end of the rod is at
the point (xa,y0) and the right end of the rod is at the point (xb,y0).

The variables x and y are arrays that form the r vector in E&M - specifically, this function
finds the potential V at the points x and y, or V(x,y). You can choose the points over which to
find the potential: the x-axis goes from x1 to x2, and the y-axis goes from y1 to y2.

Below, we define the parameters for the function. The function will plot a 2D histogram of the potential.
%}

% Linear charge density
L = @(x) 2*x;

% Number of data points
N = 100;

% Physical dimenstions of the rod
xa = 0 ;               % Left end of rod
xb = 1 ;               % Right end of rod
y0 = 0 ;               % Displacement of rod from x-axis

% Form the r vector, or the sampling space
x1 = -0.5 ;
x2 = 1.5  ;
y1 = -0.5 ;
y2 = 0.5  ;

x = linspace(x1,x2,N) ;
y = linspace(y1,y2,N) ;

% Define V as electric potential
V = zeros(N,N) ;              % Potential is 2D array with N columns, N rows
for j = 1:N                   % Sum over y values 
        for i = 1:N           % Sum over x values
            integrand = @(z) 2.*z./sqrt((x(i) - z).^2 + (y(j) - y0).^2) ;
            V(i,j) = integral(integrand,xa,xb) ;
        end
end

figure(1)
contourf(x,y,V.');        % Plot a 2D color map
pcolor(x,y,V.');          % Removes solid contours, adds grid
hold on;
shading interp;           % Removes grid
colorbar('southoutside')  % Adds horizontal color bar on bottom of contour


% Now find the electric field, E = - (dV/dx, dV/dy, dV/dz)
[Ex,Ey] = gradient(-V.',1/N,1/N) ;

figure(2)
quiver(x,y,Ex,Ey,5)

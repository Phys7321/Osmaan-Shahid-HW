%{
The function "CylindricalPotential" finds the potential V on the xy-axes due to a
surface charge density S(x) that is in the xy-plane. The center of the circle is at r0.

The variables r and t are arrays that form the r vector in E&M - specifically, this function
finds the potential V at the points r and theta, or V(r,theta). You can choose the points over which to
find the potential: the x-axis goes from x1 to x2, and the y-axis goes from y1 to y2.

Below, we define the parameters for the function. The function will plot a 2D histogram of the potential.
%}

% Linear charge density
S = @(r,t) r*cos(t) ;

% Number of data points
N = 20 ;

% Physical dimenstions of the surface
r0 = 0  ;              % Center of circle
R = 2   ;              % Radius of circle

% Form the r vector, or the sampling space
r1 = 0      ;
r2 = 2.5    ;
t1 = 0      ;
t2 = 2*pi() ;

r = linspace(r1,r2,N) ;                  % Describes r-coordinate in space
t = linspace(t1,t2,N) ;                  % Describes theta-coordinate in space

V = zeros(N,N) ;           % Potential is 2D array with N columns, N rows
count = 0 ;
for j = 1:N                % Sum over y values 
    for i = 1:N            % Sum over x values
        count = count + 1 ;
        integrand = @(rad,theta) (rad.^2).*cos(theta)./sqrt(r(i).^2 + rad.^2 - 2.*r(i).*rad.*cos(t(j) - theta) + 0.01) ;
        % Integrand is long because the denominator is the |r - r'| vector
        % in polar coordinates. Also, the +0.01 at the end allows us to
        % find the potential at a point directly above the surface, otherwise
        % the integral diverges.
        ymin = @(z) 0 ;
        ymax = @(z) 2.*pi() ;
        V(i,j) = integral2(integrand,r0,R, 0, 2.*pi()) ;
        fprintf('Calculating step %d of %d\n', count, N.*N);
    end
end

figure(1)
[r_grid,t_grid] = meshgrid(r,t) ;
contourf(r_grid.*cos(t_grid),r_grid.*sin(t_grid),V.')    % Converts to polar coordinates
pcolor(r_grid.*cos(t_grid),r_grid.*sin(t_grid),V.');     % Removes solid contours, adds grid
hold on;
shading interp;           % Removes grid
colorbar('southoutside')  % Adds horizontal color bar on bottom of contour

% Now find the electric field, E = - (dV/dx, dV/dy, dV/dz)
[Ex,Ey] = gradient(-V.') ;
Er = Ey.*cos(t_grid) - Ex.*sin(t_grid) ;
Et = Ey.*sin(t_grid) + Ex.*cos(t_grid) ;
figure(2)
quiver(r_grid.*cos(t_grid),r_grid.*sin(t_grid),Er,Et)



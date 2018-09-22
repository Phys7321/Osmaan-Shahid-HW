function [dy,xc] = Der(varargin)
%Needs the file func.m, which defines the function being used
%Use the input Der(@func,X,...)

switch nargin
    case 2
        F = varargin{1};
        x = varargin{2};
        method = 'cd' ; %default value
        n = 5 ; %default value
    case 3
        F = varargin{1};
        x = varargin{2};
        method = varargin{3};
        n = 5 ; %default value
    case 4
        F = varargin{1};
        x = varargin{2};
        method = varargin{3};
        n = varargin{4};
end

% In the form Der(func(x),x,method,n)
% F = function, x = input vector
% D calculates the derivative of the function F(x) using one of three
% methods: forward difference, central difference, and expolated difference
% D(F,x,method) returns the x and y coordinate of the derivative function.
% Specify which method in the optional third argument as 'fd', 'cd', or
% 'ed'. If F is a numeric vector, it is treated as data and a simple
% derivative is calculated

if ~isnumeric(x)
    error('Second input must be numeric vector')
end

if ~isa(F,'function_handle') % If F is NOT a fxn handle, continue
    if isnumeric(F)          % If F is a numeric vector, continue
      xc = chop(x); % method for data depends on how you assign dy to xc
      dy = diff(F)./diff(x); 
      method = 'data';
      
    else
      error('First input must be a function handle or a numeric array')
    end
end

n=length(x);
dx = diff(x); % length(dx) = length(x) - 1

switch method
    case 'fd' 
        dy = (F(x(2:n)) - F(x(1:n-1)))./dx;
        xc = x(1:n-1);
    case 'bd'
        dy = (F(x(2:n)) - F(x(1:n-1)))./dx;
        xc = x(2:n);
    case 'cd'
        dy = (F(x(1:n-1)+0.5*dx) - F(x(1:n-1)-0.5*dx))./dx;
        xc = x(1:n-1);
    case 'ed'
        half = (F(x(1:n-1)+0.25*dx) - F(x(1:n-1)-0.25*dx))./(0.5*dx); 
        full = (F(x(1:n-1)+0.5*dx) - F(x(1:n-1)-0.5*dx))./dx;
        dy = (4/3).*half - (1/3).*full;
        xc = x(1:n-1);
    case 'higherorder'
        dy = ((1/24)*F(x(1:n-1)-1.5*dx) - (27/24)*F(x(1:n-1)-0.5*dx) + (27/24)*F(x(1:n-1)+0.5*dx) - (1/24)*F(x(1:n-1)+1.5*dx) )./dx;
        xc = x(1:n-1);
    case 'data'
        return;
    otherwise
        error('method not recognized');
end

figure(1);
plot(x,F(x));
grid;

figure(2);
plot(xc,dy);
grid;

end
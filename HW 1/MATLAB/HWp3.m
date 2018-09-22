function [dy,xc] = HWp3()
load('derdata.mat')

figure(1)
plot(X,Y)
grid

if ~isnumeric(X)
    error('Second input must be numeric vector')
end
n = length(X);
if ~isa(Y,'function_handle') % If F is NOT a fxn handle, continue
    if isnumeric(Y)          % If F is a numeric vector, continue
      xc = X(1:n-1); % method for data depends on how you assign dy to xc
      dy = diff(Y)./diff(X); 
      method = 'data';
    else
      error('First input must be a function handle or a numeric array')
    end
end

figure(2);
plot(xc,dy);
grid;

dyy = diff(dy)./diff(xc); %Second derivative
xcc = X(1:n-2);

figure(3);
plot(xcc,dyy);
grid;

end
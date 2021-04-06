%% AME 565 Assignment 1
% Steepest descent method for 2D problem
close all;
clc;
clear all;


%% Exact line search using quadratic

% Function & Setup
fun = @(x,y) 2.*x.^2+3.*x.*y+7.*y.^2+12;

syms x y
Q = hessian(fun,[x,y])

% define initial conditions
x = 3; y = 2;
xmin = 1;
xmax = 5;
ymin = 1;
ymax = 5;

% gradients
dfdx = @(x,y) 4*x+3*y;
dfdy = @(x,y) 3*x+14*y;

% plot contour
figure
fcontour(fun,'LineWidth',2,'LevelList',fun(x,y))
xlim([-5 5]);
ylim([-5 5]);
xlabel('x')
ylabel('y')
axis square
grid on
hold on

err = 1;  % error
numit = 10;   % max number of iterations
normdf = sqrt(dfdx(x,y)^2+dfdy(x,y)^2);
i = 1;

while normdf > err
    if i > numit
        break;
    end

    % plot the position
    plot(x,y,'o')
    
    % line search
    x_star = (x-xmin)/(xmax-xmin);  % scaling
    y_star = (y-ymin)/(ymax-ymin);  % scaling
    
%     gradf = [dfdx(x_star,y_star); dfdy(x_star,y_star)];
    gradf = [dfdx(x,y); dfdy(x,y)];
    
    num = -gradf'*gradf;
    denom = eval(gradf'*Q*gradf);
    a_star = num/denom
    
    % calculate new point
    x1 = x+a_star*dfdx(x,y);
    y1 = y+a_star*dfdx(x,y);
    
    % plot the line & new value
    line([x x1],[y y1]);
    fcontour(fun,'LineWidth',2,'LevelList',fun(x1,y1));
    
    % store values
    x = x1; 
    y = y1;
    
    % calculate objective function
    normdf = sqrt(dfdx(x,y)^2+dfdy(x,y)^2);
    fobj(i) = fun(x1,y1);
    
    pause(1)
    i = i+1;
end

% Objective function plot
figure
plot(fobj)
xlabel('Iteration')
ylabel('Objective Fxn Value')
fprintf('Number of iterations to reach optimum %d',i-1)


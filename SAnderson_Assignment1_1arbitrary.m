%% AME 565 Assignment 1
% Steepest descent method for 2D problem
close all;
clc;
clear all;


%% Arbitrary alpha (a)

% define initial conditions
x = 3; y = 2;

% Function & Setup
fun = @(x,y) 2.*x.^2+3.*x.*y+7.*y.^2+10.*x+12;

% gradients
dfdx = @(x,y) 4*x+3*y+10;
dfdy = @(x,y) 3*x+14*y;

% plot contour
figure
fcontour(fun,'LineWidth',2,'LevelList',fun(x,y))
xlim([-5 5])
ylim([-5 5])
xlabel('x')
ylabel('y')
grid on
hold on

err = 1;  % error
numit = 10;   % max number of iterations
normdf = sqrt(dfdx(x,y)^2+dfdy(x,y)^2)
i = 1;

while normdf > err
    if i > numit
        break;
    end
    
    % plot the original position
    plot(x,y,'o')
    
    % calculate search direction
    sx = @(x,y) -dfdx(x,y)/sqrt(dfdx(x,y)^2+dfdy(x,y)^2);
    sy = @(x,y) -dfdy(x,y)/sqrt(dfdx(x,y)^2+dfdy(x,y)^2);
    
    % line search    
    a = 0.5;  %arbitrary alpha
    
    % calculate new point
    x1 = x+a*sx(x,y);
    y1 = y+a*sy(x,y);
    
    % plot the line
    line([x x1],[y y1]);

    % plot the line & new value
    line([x x1],[y y1]);
    fcontour(fun,'LineWidth',2,'LevelList',fun(x1,y1));
    
    % store values
    normdf = sqrt(dfdx(x,y)^2+dfdy(x,y)^2)
    x = x1; 
    y = y1;
    
    % calculate objective function
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


%% AME 565 - HW4
% Steven Anderson
clc
clear all
close all


% arbitrary function
fun = @(x) -2*x(1) - x(2);

g1 = @(x) x(1)^2 + x(2)^2 - 25;
g2 = @(x) x(1)^2 - x(2)^2 - 7;

% determine number of variables
for k = 1:100
    array = zeros(1,100);
    array(k) = 1;
    if fun(array) == 0
        break
    end
end
nvar = k-1  % number of design variables


%% Iterate

x0 = ones(1,nvar);   % build an array of starting points
move = 1;
lb = x0-move;
ub = x0+move;
dx = 0.000001;
err = 0.01;
x = x0; 

for j = 1:100
    xold = x;
    fprintf('~~~~Iteration %d ~~~~ \n',j)
    
    % finite differences to linearize functions
    for i = 1:nvar
        dxarray = zeros(1,nvar);
        dxarray(i) = dx;
        dfdx(i) = (fun(x+dxarray) - fun(x))/dx;
        dg1dx(i) = (g1(x+dxarray) - g1(x))/dx;
        dg2dx(i) = (g2(x+dxarray) - g2(x))/dx;
    end

    %linearize objective function
    f = dfdx
    
    % compute constraint inequality inputs (linearized)
    a1 = dg1dx;
    a2 = dg2dx;

    b1 = -g1(x) + dg1dx(1)*x(1) + dg1dx(2)*x(2);
    b2 = -g2(x) + dg2dx(1)*x(1) + dg2dx(2)*x(2);

    % linprog
    A = [a1; a2]
    b = [b1 b2]
    Aeq = [];
    beq = [];

    options = optimoptions('linprog','Display','iter');
    [x,fval,exitflag,output,lambda] = linprog(f,A,b,Aeq,beq,lb,ub,options)
    x = x'     % flip x
    farray(j,1) = j;
    farray(j,2) = fval;
    
    % move limits
    lb = x - move;
    ub = x + move;
    
    % constraint violations (positive values >> violation)
    violation(1,j) = j;
    violation(2,j) = g1(x);
    violation(3,j) = g2(x);
    
    % soft convergence
    convsoft = abs(norm(x - xold))/abs(norm(x));
    if convsoft < err
        fprintf('SOFT CONVERGENCE REACHED.\n')
        break
    end

    % hard convergence
    convhard = abs(fun(x)-fun(xold))/abs(fun(xold));
    if convsoft < err
        fprintf('HARD CONVERGENCE REACHED.\n')
        break
    end
    
end

% plot f value per iteration
figure
plot(farray(:,1),farray(:,2))
hold on
title('Fval Evolution')
xlabel('Iteration')
ylabel('F value')

% matrix of constraint violations
fprintf('Violation Matrix:\n')
violation


% for 2D problem, plot linearized constraints and objective function
if nvar == 2
    figure
    fplot(@(s) (b(1)-A(1,1)*s)/A(1,2), 'g')
    hold on
    fplot(@(s) (b(2)-A(2,1)*s)/A(2,2), 'g')
    hold on
    fplot(@(s) (fval-f(1)*s)/f(2), 'b')
    hold on
    legend('g1','g2','objective')
    title('2D Linearized Objective/Constraints') 
end


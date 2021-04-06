%% AME 565 HW3
% Steven Anderson
clc
clear all


%% Part 3 - Add cubic term to objective function

% fun = @(x) -2*x(1)-x(2)^3;
fun = @objfungrad;
dfdx1 = -2;
dfdx2 = @(x) -3*x(2)^2;
A = [];
b = [];
Aeq = [];
beq = [];
x0 = [1,1];
lb = [0,0];
nonlcon = @circlecon;
options = optimoptions('fmincon','SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true);
[x,fval,lambda] = fmincon(fun,x0,A,b,Aeq,beq,lb,[],nonlcon,options)

function [f,gradf] = objfungrad(x)
f = -2*x(1)-x(2)^3;
% Gradient of the objective function:
if nargout  > 1
    gradf = [ -2,-3*x(2)^2];
end
end

function [c,ceq, DC, DCeq] = circlecon(x)
c(1) = x(1)^2 + x(2)^2 - 25;
c(2) = x(1)^2- x(2)^2-7;
ceq = [];   % no nonlinear equality constraints
if nargout > 2
    % gradients of the nonlinear constraints
    DC= [2*x(1), 2*x(2);
        2*x(1), 2*x(2)];
    DCeq = [];
end
end


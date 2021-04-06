%% AME 565 HW3
% Steven Anderson
clc
clear all

%% Part 1 - Solve SLP problem with SQP (fmincon)
% Check active constraints and find Lagrange multipliers

fun = @(x) -2*x(1)-x(2);
A = [];
b = [];
Aeq = [];
beq = [];
x0 = [1,1];
lb = [0,0];
nonlcon = @circlecon;
options = optimoptions('fmincon','Display','iter','Algorithm','sqp','Constrainttolerance',1e-30);
[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun,x0,A,b,Aeq,beq,lb,[],nonlcon,options)

for i=1:size(lambda.ineqnonlin)
    lamineqnonlin(i,1) = lambda.ineqnonlin(i);
end
lamineqnonlin
% both inequality constraints have associated lambda values, so they are both active


function [c,ceq] = circlecon(x)
c(1) = x(1)^2 + x(2)^2 - 25;
c(2) = x(1)^2- x(2)^2-7;
ceq = [];
end


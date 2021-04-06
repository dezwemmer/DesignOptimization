%% Steven Anderson
% AME 565
% Homework 6 (Multi-Objective Optimization)
% Pareto Front Using NSGAII (gamultiobj)
clc
clear all
close all

A = [];
b = [];
Aeq = [];
beq = [];
lb = [-10,0];
ub = [10,5];
fun = @objval;
npts = 160;

% gamultiobj
options = optimoptions('gamultiobj','PlotFcn','gaplotpareto','Display','off','PopulationSize',2*npts);
[xval,fval,~,output] = gamultiobj(fun,1,A,b,Aeq,beq,lb,ub,[],options);
disp("Total Function Count " + output.funccount)

% plot Pareto front
fga = sortrows(fval,1,'ascend');
plot(fga(:,1),fga(:,2),'r')
xlim([-1000,0])
ylim([0,90])
title('Pareto Front Using gamultiobj')
xlabel('Objective 1')
ylabel('Objective 2')

% objective functions
function F = objval(x)
% both options for f1 work with this approach
% f1 = 2*x(1).^2;
f1 = x(1).^3;
f2 = (x(1)+1).^2;
F = [f1,f2];
end



% Steven Anderson
% AME 565
% Homework 8 - RBF / LHS DOE
% Leave-one-out (LOO) cross-validation
clc
clear all
close all

%% Create DOE using LHS
% number of dimensions
d = 2;
% specify boundaries
lb(1:d) = 0;
ub(1:d) = 10;
n = 10;             % number of doe

% [n x d]
xdoe = lb + lhsdesign(n,d).*(ub-lb);    % this keeps the LHS within bounds

% plot DOE
figure
plot(xdoe(:,1),xdoe(:,2),'b+');
title 'LHS for the DOE'
xlabel 'x1'
ylabel 'x2'
% figure
% plot(x(:,1),x(:,2),'rx');

%% RBF
% function
f = @(x) sin(x(:,1)).^2+(x(:,2)-2).^2+4;

% function at DOE points
fi = f(xdoe);  

% % find c
% for s = 1:d
%     fmod = horzcat(fi(1:s),fi(s:d));
% end


% create a leave-one-out partition
c = cvpartition(n,'Leaveout')

% apply LOO partition
values = crossval(@(Xtrain,Xtest)mean(Xtrain),fi,'Partition',c);
[~,repetitionIdx] = min(values);
observationIdx = test(c,repetitionIdx);
outlier = fi(observationIdx)

% correlation matrix
c = 0.5;
A = exp(-c*pdist2(xdoe,xdoe).^2);
% find coefficients (fi = A*alpha)
alpha = inv(A)*fi; 
phi = @(x)  exp(-c*pdist2(x,xdoe).^2);

[X,Y] = meshgrid(lb(1):0.5:ub(1), lb(2):0.5:ub(2));
xplot = [reshape(X,21*21,1) reshape(Y,21*21,1)];
yhat = phi(xplot)*alpha;

figure
surf(X,Y,reshape(f(xplot),21,21),'Facecolor', 'interp', 'FaceAlpha',0.3)    % plot estimated surface
hold on
surf(X,Y,reshape(yhat,21,21))     % plot function surface
hold on
plot3(xdoe(:,1),xdoe(:,2),fi,'r*','MarkerSize',10)

% calculate ftilde
phi1 = phi(xplot);
ftilde = zeros(n,1);
for j = 1:n
    for k = 1:n
        ftilde(j,1) = ftilde(j,1) + alpha(k)*phi1(j,k);
    end
end

% R^2 calculation
for p = 1:n
    square(p,1) = (fi(p)-ftilde(p)).^2;
end
sumsq = sum(square);
R2 = (1-sumsq)/sumsq

% calculate Relative Maximum Absolute Error (RMAE)
sigma = std(fi);
b = abs(fi-ftilde);
RMAE = max(b)/sigma


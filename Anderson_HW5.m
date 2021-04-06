%% Steven Anderson
% AME 565
% HW5 (Sensitivities)
clc; clear all; close all;
format long

% x = -0.5:0.1:2;
% y = exp(x)./(sqrt(sin(x).^3+cos(x).^3));
% plot(x,y)



% part 1 - exact derivative analytically
x = 1.5;
dfdx = exp(x)/sqrt(sin(x)^3+cos(x)^3) - (1/2)*exp(x)*(3*sin(x)^2*cos(x)-3*cos(x)^2*sin(x))*(sin(x)^3+cos(x)^3)^(-3/2);
digits(17)
exactderivative = vpa(dfdx)

% part 2
i = 1;
for h = 0.01:0.01:0.2
xpdx = x+h;
xmdx = x-h;
xi = x+i*h;

f = exp(x)/sqrt(sin(x)^3+cos(x)^3);
fp = exp(xpdx)/sqrt(sin(xpdx)^3+cos(xpdx)^3);
fm = exp(xmdx)/sqrt(sin(xmdx)^3+cos(xmdx)^3);
fi = exp(xi)/sqrt(sin(xi)^3+cos(xi)^3);

fwderr = (fp-f)/h - dfdx;
bckerr = (f-fm)/h - dfdx;
cnterr = (fp-fm)/(2*h) - dfdx;
imagerr = dfdx - imag(fi)/h;

array(i,1) = h;
array(i,2) = fwderr;
array(i,3) = cnterr;
array(i,4) = imagerr;
i = i+1;
end

fprintf('   h                   forward error       central error      complex step error\n')
array

figure
for j = 1:length(array)
plot(array(j,1),array(j,2),'g-*')
hold on
plot(array(j,1),array(j,3),'b-*')
hold on
end
xlabel('h (delta x)')
ylabel('error')
legend('fwd error','central error')


figure
for j = 1:length(array)
plot(array(j,1),array(j,4),'r-*')
hold on
end
xlabel('h (delta x)')
ylabel('error')
legend('complex error')
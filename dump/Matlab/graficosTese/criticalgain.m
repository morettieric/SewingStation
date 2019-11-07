clear all; close all; clc;
t=0:0.05:6*pi;
zeta=0.3;
wn=3;

f=sin(t);

figure (1);
plot(t,f,'-k','LineWidth',1.5);
grid on
title('System oscillating in the critical gain');
axis([0 6*pi -1.1 1.2])
hold on
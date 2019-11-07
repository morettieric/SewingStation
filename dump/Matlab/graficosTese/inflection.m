clear all; close all; clc;
t=0:0.05:8;
zeta=1;
wn=0.8;

k=1;
sys=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);

[y,t]=step(sys,t)



d1y=gradient(y,t);
d2y=gradient(d1y,t);

t_infl = interp1(d1y, t, max(d1y))
y_infl = interp1(t, y, t_infl)
slope  = interp1(t, d1y, t_infl);                               % Slope Defined Here As Maximum Of First Derivative
intcpt = y_infl - slope*t_infl;                                 % Calculate Intercept
tngt = slope*t + intcpt;  

figure (1);
plot(t,y,'-k','LineWidth',1.5);
grid on
title('Example of the Inflection point');
axis([-.1 8 -0.01 1.2])
hold on
plot(t, tngt, '-r', 'LineWidth',1)                              % Plot Tangent Line
plot(t_infl, y_infl, 'bp')  

L = interp1(tngt, t, 1)
clear all; close all; clc;

sys=tf([1],[1 1]);
[H,t]=step(sys)

figure (1);
plot(t,H,'-k','LineWidth',1.5);
grid on
title('Step response of a first order system');
axis([-.1 6 -0.01 1.01])

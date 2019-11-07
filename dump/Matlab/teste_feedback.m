clear all;
close all;
clc;

Kp=1;
Ki=1;
Kd=1;

s=tf('s');
A=1/(s+1)^2;
B=(Kp*(1+(Ki/s)+Kd*s))*1/(s+1000);

open_loop=A;
%closed_loop=(A*B)/(1+A*B);
%control_effort=B/(1+A*B);

closed_loop=feedback(A*B,1);
control_effort=feedback(B,A)

figure(1);
step(open_loop);
title ('Malha Aberta');

figure(2);
step(closed_loop);
title('Malha Fechada');
[y,t]=step(closed_loop);
e=1-y;
figure(4);
title('resultado lsim');
lsim(B,e,t)

plot(e);
figure(3);
step(control_effort);
title('Sinal de Controle');
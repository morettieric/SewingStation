clear all;
close all;
clc;

Kp=3;
Kd=.5;
Ki=0.3;
wn=1;
zeta=1;
K=1;
t=0:0.05:5;

s=tf('s');

M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=Kp+Kd*s+Ki/s;
malha_fechada=(P*M)/(1+P*M);

figure (1);
subplot (1,3,1);
    bode(M);
    title ('Motor');
    grid on
subplot(1,3,2);
    bode(P);
    title('Controlador');
    grid on
subplot(1,3,3);
    bode(malha_fechada);
    title('Malha Fechada');
    grid on
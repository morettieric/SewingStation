clear all; close all; clc;
t=0:0.05:8;
zeta=0.3;
wn=3;

k=1;
sys=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
[H,t]=step(sys,t)

figure (1);
plot(t,H,'-k','LineWidth',1.5);
grid on
title('Step response of a second-order system');
axis([-.1 8 -0.01 1.4])
hold on
%%
%=================================
zeta=1;
wn=3;

k=1;
sys=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
[H,t]=step(sys,t)

figure (1);
plot(t,H,'-g','LineWidth',1.5);
%=============================
zeta=2;
wn=3;

k=1;
sys=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
[H,t]=step(sys,t)

figure (1);
plot(t,H,'-b','LineWidth',1.5);

x = [3.04/8 2.35/8];
y = [1.22/1.4 1.2/1.4];
annotation('textarrow',x,y,'String','Zeta=0.3 ')
x = [3.36/8 2/8];
y = [0.655/1.4 0.843/1.4];
annotation('textarrow',x,y,'String','Zeta=1 ')
x = [4.86/8 3.4/8];
y = [0.769/1.4 0.867/1.4];
annotation('textarrow',x,y,'String','Zeta=2 ')
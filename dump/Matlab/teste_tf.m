clear all;
close all;
clc;

Kp=3;
Kd=.5;
Ki=0.3;
w=0.000001;
wn=1;
zeta=1;
K=1;
t=0:0.05:5;

s=tf('s');

M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=Kp+Kd*s/(1+s/w)+Ki/s;

malha_fechada=(P*M)/(1+P*M);

resp_deg_mf=step(malha_fechada,t);
erro=1-resp_deg_mf;
sinal_controle=lsim(P,erro,t);

linha_1=ones(length(t),1);
linha_0=zeros(length(t),1);

figure (1);
plot(t,resp_deg_mf,'-b','LineWidth',1.5);
hold on
plot(t,sinal_controle,'-r','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);
axis([-0.1 5 -0.1 max(sinal_controle)+0.1]);

plot(t,linha_1,':k',...
    t,linha_0,':k');
grid on
grid minor
legend('Resposta ao Degrau','Sinal de Controle','Erro');
title (['Resposta ao degrau - Kp ', num2str(Kp),'; Ki ', num2str(Ki),'; Kd ', num2str(Kd)]);
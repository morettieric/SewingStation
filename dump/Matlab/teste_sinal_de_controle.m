function [y,c,t] = teste_sinal_controle(coef)
clear all;
close all;
clc;

Kp=coef(1);
Ki=coef(2);
Kd=coef(3);

% Kp=3;
% Kd=.5;
% Ki=0.3;
w=0.01;
wn=1;
zeta=1;
K=1;
t=0:0.05:5;

s=tf('s');

M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=Kp+Kd*s/(1+s/0.01)+Ki/s;
P_puro=Kp+Kd*s+Ki/s;

malha_fechada=(P*M)/(1+P*M);
malha_fechada_puro=(P_puro*M)/(1+P_puro*M);

resp_deg_mf=step(malha_fechada,t);
resp_deg_mf_puro=step(malha_fechada_puro,t);
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
hold off

%%comparação do PID normal com o PID modificado
erro_pids=(resp_deg_mf_puro-resp_deg_mf).^2;
erro_med=100*sum(erro_pids)/length(t);
figure(2);
plot(t,resp_deg_mf_puro,'-b','LineWidth',1.5);
hold on

plot(t,resp_deg_mf,'-r','LineWidth',1.5);
plot(t,erro_pids,'-g','LineWidth',1.5);
hold off
legend('PID "puro"','PID com +1 polo','Erro');
grid on
grid minor
title (['Comparação PID - Erro²: ',num2str(erro_med)]);
end
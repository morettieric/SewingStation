function [y,c,t] = teste_sinal_controle(coef)
%clear all;
close all;
%clc;

%valores
Kp=coef(1);
Ki=coef(2);
Kd=coef(3);

wn=8.036118730219977;
zeta=0.900733958553509;
k=1;
t=0:0.005:5;

s=tf('s');

%sistemas
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P_ctr=Kp+Kd*s/(1+s/0.01)+Ki/s;
P=Kp+Kd*s+Ki/s;
malha_aberta=P*M;
malha_fechada=(P*M)/(1+P*M);
malha_fechada_ctr=P_ctr*M/(1+P_ctr*M);

%respostas
resp_deg_mf=step(malha_fechada,t);
resp_deg_mf_ctr=step(malha_fechada_ctr,t);
erro=1-resp_deg_mf;
[sinal_controle,t,x]=lsim(P_ctr,erro,t);

linha_1=ones(length(t),1);
linha_0=zeros(length(t),1);

%plot da resposta
figure (1);
plot(t,resp_deg_mf,'-b','LineWidth',1.5);
hold on
plot(t,sinal_controle,'-r','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);
axis([-0.1 5 -0.1 max(sinal_controle)+0.1]);

plot(   t,linha_1,':k',...
        t,linha_0,':k');
grid on
grid minor
legend('Resposta ao Degrau','Sinal de Controle','Erro');
title (['Resposta ao degrau - Kp ', num2str(Kp),'; Ki ', num2str(Ki),'; Kd ', num2str(Kd)]);
hold off

%%comparação do PID normal com o PID modificado
erro_pids=(resp_deg_mf-resp_deg_mf_ctr).^2;
erro_med_polo=sum(erro_pids)/length(t);
figure(2);
plot(t,resp_deg_mf,'-b','LineWidth',1.5);
hold on

plot(t,resp_deg_mf_ctr,'-r','LineWidth',1.5);
plot(t,erro_pids,'-g','LineWidth',1.5);
hold off
legend('PID "puro"','PID com +1 polo','Erro');
grid on
grid minor
title (['Comparação PID - Erro²: ',num2str(erro_med_polo)]);

%print dos dados importantes do sistema
%overshoot
info_step=stepinfo(malha_fechada);
oversh=info_step.Overshoot;

%bw
bw=bandwidth(malha_aberta);

%erro medio q
resposta_ideal=ones(length(t),1);
erro_quad=(resposta_ideal-resp_deg_mf).^2;
erro_med=sum(erro_quad)/length(erro_quad);

%sinal max de controle
resp_deg_mf_ctr=step(malha_fechada_ctr,t);
erro=1-resp_deg_mf_ctr;
%essa linha abaixo é diferente da função fitness em -1 pois aqui é mais
%interessante saber o valor real do sinal.
sinal_controle_max=max(abs(sinal_controle));

fprintf('Overshoot: %f\tErroMed: %f\tBw: %f\tSinContr: %f\n',oversh, erro_med, bw, sinal_controle_max);
info_step
end
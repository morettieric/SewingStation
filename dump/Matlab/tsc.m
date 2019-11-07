function [y,c,t] = teste_sinal_controle(coef)
%{
Código novo.
Será utilizado o modelo de PID como descrito no livro Computer Systems for Automation and Control.
U(s)=K(1+(1/Ti*s)+(Td*s/(1+Tfs)))
onde
Tf=Td/N;
N varia entre 5 e 10.
%}
%clear all;
%close all;
%clc;
% K=1;
% Td=1;
% Ti=1;

%valores
K=coef(1);
Ti=coef(2);
Td=coef(3);
N=5;
Tf=Td/N;
wn=8.036118730219977;
zeta=0.900733958553509;
k=1;
t=0:0.05:5;

s=tf('s');

%sistemas
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
%P_ctr=K*(1+(1/(Ti*s))+(Td*s/((1000000+1000000*s)*(1+Tf*s))));
malha_aberta=P*M;
malha_fechada=(P*M)/(1+P*M);
%malha_fechada_ctr=(P_ctr*M)/(1+P_ctr*M);

%respostas
resp_deg_mf=step(malha_fechada,t);
%resp_deg_mf_ctr=step(malha_fechada_ctr,t);
erro=1-resp_deg_mf;
[sinal_controle,t,x]=lsim(P,erro,t);

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
legend('Step Response','Controller Effort','Error');
title (['Step Response - Kp ', num2str(K),'; Ti ', num2str(Ti),'; Td ', num2str(Td)]);
hold off

%%comparação do PID normal com o PID modificado
% erro_pids=(resp_deg_mf-resp_deg_mf_ctr).^2;
% erro_med_polo=sum(erro_pids)/length(t);
% figure(2);
% plot(t,resp_deg_mf,'-b','LineWidth',1.5);
% hold on
% 
% plot(t,resp_deg_mf_ctr,'-r','LineWidth',1.5);
% plot(t,erro_pids,'-g','LineWidth',1.5);
% hold off
% legend('Pure PID','PID with a extra pole','Error');
% grid on
% grid minor
% title (['PID Comparation - Error² (%):',num2str(100*erro_med_polo)]);

%print dos dados importantes do sistema
%overshoot
info_step=stepinfo(malha_fechada);
oversh=info_step.Overshoot;

%bw
bw=bandwidth(malha_fechada);

% calculo do erro quadrático
% limite_transitorio = o tempo desejado para o tempo transitorio ideal
% em segundos.
resposta_ideal=1-(exp(-4*t));%ones(length(t),1);
limite_transitorio=1;
idx_limite_transitorio=find(t==limite_transitorio)
erro_quad=(resposta_ideal-resp_deg_mf).^2;
erro_quad=erro_quad(idx_limite_transitorio:end);
erro_med=sum(erro_quad)/length(erro_quad)

%diferença entre o RiseTime e o Settlingtime, para evitar o pico
%indesejado.
delta_T=info_step.SettlingTime-info_step.RiseTime
 


%sinal max de controle
resp_deg_mf_ctr=step(malha_fechada,t);
erro=1-resp_deg_mf_ctr;
%essa linha abaixo é diferente da função fitness em -1 pois aqui é mais
%interessante saber o valor real do sinal.
sinal_controle_max=max(abs(sinal_controle));

fprintf('Overshoot: %f\tErroMed: %f\tBw: %f\tSinContr: %f\n',oversh, erro_med, bw, sinal_controle_max);
info_step
end
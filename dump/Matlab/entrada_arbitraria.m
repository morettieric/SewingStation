close all; clc; clear all;

K=0.169022678510371;
Ti=0.072109163345392;
Td=0.091354695916176;
N=5;
Tf=Td/N;

zeta = 0.900733958553509;
wn=8.036118730219977;
k=1;
t=0:0.005:5;

s=tf('s');

sistemas
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
malha_fechada=(P*M)/(1+P*M);

tecido_corrigido = tecido_corrigido';
t=0:0.1:(length(tecido_corrigido)*0.1)-0.1;
[simulado,t,x]=lsim(malha_fechada,tecido_corrigido,t);
%
erro=carro-simulado;

figure(1)
plot(t,tecido_corrigido,'-k','LineWidth',1.5);
hold on
plot(t,simulado,'-r','LineWidth',1.5);
plot(t,carro,'-b','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);
grid on
grid minor
legend('Sewing Machine Speed (Input)','Simulated Response','Real Response','Error² (Real-Simulated)²');
title('Comparison of the simulated and the real response');
xlabel('Time (s)');
%
erro_relativo=sqrt(((carro-simulado)/carro).^2)*100;
figure(2)
plot(t,erro_relativo,'-k','LineWidth',1.5);
grid on
grid minor
title('Absolute Relative Error');
ylabel('Error (%)');
xlabel('Time (s)');

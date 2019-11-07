clear;
clc;
close;
format long;

t=0:0.1:2.7;
%tratamento dos dados
y=importdata('dados.txt');
%y(1:11) = transitório, y(12:28) = ss
y_ss=mean(y(11:28));
y_norm=y/y_ss;

y_norm_overshoot=max(y_norm(1:11));
t_pico =0.1* min(find(y_norm==y_norm_overshoot));

%plot dados
plot (t,y_norm,'--k','LineWidth',1.0);
grid on;
grid minor;
hold on;
title ('Data acquired from the system');
%plot (t_pico,y_norm_overshoot,'+')
%calculo dos parametros

%% modelo de 1a ordem
G=tf([1/0.253],[1 1/0.253])
resposta1order=step(t,G);
plot(t,resposta1order,'-.r','LineWidth',1.0);

%% modelo de 2a ordem
%plot resposta obtida
zeta=sqrt(((log(y_norm_overshoot-1)^2))/((pi^2)+((log(y_norm_overshoot-1))^2)));
wn=pi/(t_pico*sqrt(1-(zeta^2)));

H=tf([wn*wn],[1 2*wn*zeta wn*wn]);
resposta=step(t,H);

plot(t,resposta,'-b','LineWidth',1.0);
legend ('Original Response','First-Order Response','Second-Order Response');
title ('Second-Order System Response');

%linhas auxiliares
%{
x1=0:0.001:2.999;
guia090=0.90*(ones(3000,1));
guia099=0.99*(ones(3000,1));
guia063=0.63*(ones(3000,1));
guia010=0.10*(ones(3000,1));

plot(x1,guia090,'-.k');
plot(x1,guia099,'-.k');
plot(x1,guia063,'-.k');
plot(x1,guia010,'-.k');
%}

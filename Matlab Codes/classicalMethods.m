clear all; close all; clc;
t=0:0.05:1;

wn=8.036118730219977;
zeta=0.900733958553509;

s=tf('s');
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
[y,t]=step(M,t);
Nf=5;

d1y=gradient(y,t);
d2y=gradient(d1y,t);

t_infl = interp1(d1y, t, max(d1y));
y_infl = interp1(t, y, t_infl);
slope  = interp1(t, d1y, t_infl);   % Slope Defined Here As Maximum Of First Derivative
intcpt = y_infl - slope*t_infl;     % Calculate Intercept
tngt = slope*t + intcpt;  

figure (1);
plot(t,y,'-k','LineWidth',1.5);
grid on
title('Inflection point and the tangent curve of the system');
axis([0 length(t)*0.05-0.05 0 1.1]);
hold on
plot(t, tngt, '-r', 'LineWidth',1); % Plot Tangent Line
plot(t_infl, y_infl, 'bp');

%parameters from the graph
T = interp1(tngt, t, 0)
L = (interp1(tngt, t, 1))-T
DeltaCp=max(y)
N=DeltaCp/T
R=N*L/DeltaCp
P=1                                %from step function
%%
%Ziegler-Nichols
fprintf('Zigler-Nichols')
K=1.2*P/(N*L)
Ti=2*L
Td=0.5*L
Tf=Td/Nf;

G=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
malha_fechada=(G*M)/(1+G*M);
figure;
[resp_deg_mf,t]=step(malha_fechada);
erro=1-resp_deg_mf;
sinal_controle=lsim(G,erro,t);
figure;
plot(t,resp_deg_mf,'-b','LineWidth',1.5);
hold on
plot(t,sinal_controle,'-r','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);
grid on
grid minor
legend('Step Response','Controller Effort','Error');
title (['Ziegler-Nichols Step Step Response - Kp ', num2str(K),'; Ti ', num2str(Ti),'; Td ', num2str(Td)]);
hold off

%Cohen-Coon
fprintf('Cohen-Coon')
K=(P/(N*L))*(1.33+R/4)
Ti=L*((32+6*R)/(13+8*R))
Td=L*(4/(11+2*R))
Tf=Td/Nf;
G=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
malha_fechada=(G*M)/(1+G*M);
[resp_deg_mf,t]=step(malha_fechada);
erro=1-resp_deg_mf;
[sinal_controle,t,x]=lsim(G,erro,t);
figure;
plot(t,resp_deg_mf,'-b','LineWidth',1.5);
hold on
plot(t,sinal_controle,'-r','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);
grid on
grid minor
legend('Step Response','Controller Effort','Error');
title (['Cohen-Coon Step Response - Kp ', num2str(K),'; Ti ', num2str(Ti),'; Td ', num2str(Td)]);
hold off

%Chien-Hrones-Reswick
fprintf('Chien-Hrones-Reswick')
K=0.95*T/L
Ti=2.4*L
Td=0.42*L
Tf=Td/Nf;
G=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
malha_fechada=(G*M)/(1+G*M);
[resp_deg_mf,t]=step(malha_fechada);
erro=1-resp_deg_mf;
[sinal_controle,t,x]=lsim(G,erro,t);
figure;
plot(t,resp_deg_mf,'-b','LineWidth',1.5);
hold on
plot(t,sinal_controle,'-r','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);

grid on
grid minor
legend('Step Response','Controller Effort','Error');
title (['Chien-Hrones-Reswick - Kp ', num2str(K),'; Ti ', num2str(Ti),'; Td ', num2str(Td)]);
hold off
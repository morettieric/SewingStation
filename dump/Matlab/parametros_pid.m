%clear;
%clc;
%close;
format long;

zeta = 0.900733958553509;
wn=8.036118730219977;
k=0.16;
G=tf([wn*wn],[1 2*wn*zeta wn*wn]);
[y,t]=step(G);
%figure (1)
%plot (t,y);
%grid on
grid minor
%%

%Teste sinal de controle
Kp=23.0989709406818;
Ti=0.01178235168670;
Td=0.66532730425439;

s=tf('s');
D=Kp*(1+(1/(Ti*s))+Td*s);
H1=G*D/(1+G*D);
H=k*H1;
y_simulink= step (H,t);
[y,t]=step (H);
erro=k-y;
figure;
hold on
plot (t,y);
plot (t,erro);
legend ('Y','erro');

%sinal_controle=H/G;
step (sinal_controle)
%%

%Parâmetros obtidos utilizando o Simulink
Kp=23.0989709406818;
Ti=0.01178235168670;
Td=0.66532730425439;

s=tf('s');
D=Kp*(1+(1/(Ti*s))+Td*s);
H=G*D/(1+G*D);
y_simulink= step (H,t)
step (H)
hold on
%%

%Parâmetros obtidos utilizando o rng
Kp=23.554419;
Ti=35.634724;
Td=25.023581;

s=tf('s');
D=Kp*(1+(1/(Ti*s))+Td*s);
H=G*D/(1+G*D);
%y_simulink= step (H,t)
step (H)
hold on
%%
%Parametros obtidos pelo método de Ziegler-Nichols, utiliando a retantangente ao ponto de inflexão da curva, Ogata;
Kp=9.6;
Ti=0.08;
Td=0.02;

s=tf('s');
D=Kp*(1+(1/(Ti*s))+Td*s);
H=G*D/(1+G*D);
y_zn=step (H,t);
figure, step (H);
%Shahian, Hassul
%%
Kp=1;
Ti=1;
Td=1;                   

s=tf('s');
D=Kp*(1+Td*s);
H=G*D/(1+G*D);
y_zn=step (H,t);
step (H)
rlocus(H)
%%
%{
H=tf([k*Ku*wn*wn],[1 2*wn*zeta (Ku+1)*wn*wn]);
%step (G);
stepinfo(G)
[y,t]=step(G)
y_der2=diff(y,2);
%y_der2(numel(t))=0;
hold on

%plot (t,y_der2)
t_infl = fzero(@(T) interp1(t(2:end-1),y_der2,T,'linear','extrap'),0)
y_infl = interp1(t,y,t_infl,'linear')


Dados obtidos com o Simulink:
Kp=
Ki=
Kd=


%https://www.mathworks.com/matlabcentral/answers/25153-finding-the-point-of-inflection-on-a-curve

[y,t] = step(G);
plot(t,y);
hold on;
% Estimate the 2nd deriv. by finite differences
ypp = diff(y,2);  
% Find the root using FZERO
t_infl = fzero(@(T) interp1(t(2:end-1),ypp,T,'linear','extrap'),0)
y_infl = interp1(t,y,t_infl,'linear')
plot(t_infl,y_infl,'ro');
%}
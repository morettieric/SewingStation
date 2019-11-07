close all;
clear all;
clc;
U(s)=K(1+(1/Ti*s)+(Td*s/(1+Tfs)))
%obter s para z
Kp=0.919103263990108;
Ki=2.668486714901025;
Kd=0.222750604152679;

wn=8.036118730219977;
zeta=0.900733958553509;
k=1;
t=0:0.005:5;

s=tf('s');

%sistemas
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=Kp+Kd*s+Ki/s;
malha_fechada=(P*M)/(1+P*M);
malha_fechada2=minreal(malha_fechada);
P_ctr=Kp+Kd*s/(1+s/0.01)+Ki/s;
%{
%teste da função minreal;
figure;
pzmap(malha_fechada,'r');
figure;
pzmap(malha_fechada2,'b');
%}

malha_fechada_digital=c2d(malha_fechada2,0.1);

P2=minreal(P_ctr)
P2_d=c2d(P2,1/10)
[num,den] = tfdata(P2_d);
syms z;
P2_d_sym = poly2sym(cell2mat(num),z)/poly2sym(cell2mat(den),z);
%iztrans(P2_d_sym)

%{
[num,den] = tfdata(malha_fechada_digital);

%%
syms z;
mfd_sym = poly2sym(cell2mat(num),z)/poly2sym(cell2mat(den),z);
iztrans(mfd_sym)
%}

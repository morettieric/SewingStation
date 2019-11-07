function bw1 = teste_bw(coef)

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

bw1=bandwidth(malha_fechada)
end
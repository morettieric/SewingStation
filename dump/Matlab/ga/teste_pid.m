function [y,c,t] = teste_pid(coef)
Kp=coef(1);
Ki=coef(2);
Kd=coef(3);

zeta = 0.900733958553509;
wn=8.036118730219977;
k=1;
t=0:0.005:5;

%calculando a resposta
s=tf('s');
sys=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
ctr=Kp+Ki/s+Kd*s;
planta=(sys*ctr)/(1+sys*ctr);
%sig_ctr=ctr/(1-sys*ctr);
t=0:0.005:1;
resposta_ideal=ones(length(t),1);
y = step (planta,t);
plot(t,y);
%c = step (sig_ctr,t);
end
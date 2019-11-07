function fitness_final = fitness_pid(coef)
Kp=coef(1);
Ki=coef(2);
Kd=coef(3);
%valores do sistema
zeta = 0.900733958553509;
wn=8.036118730219977;
k=1;
t=0:0.005:5;

%calculando a resposta
s=tf('s');
M=tf(k*wn*wn,[1 2*wn*zeta wn*wn]);
P=Kp+Ki/s+Kd*s;
P_ctr=Kp+Kd*s/(1+s/0.01)+Ki/s;

malha_fechada=P*M/(1+P*M);
malha_fechada_ctr=P_ctr*M/(1+P_ctr*M);
ff=feedback(P*M,1)

pzmap(malha_fechada)
figure;
pzmap(ff)
%%
resposta_ideal=ones(length(t),1);
resposta_planta= step (malha_fechada,t);

%cálculo do sinal de controle
resp_deg_mf_ctr=step(malha_fechada_ctr,t);
erro=1-resp_deg_mf_ctr;
[sinal_controle,t,x]=lsim(P_ctr,erro,t);
sinal_controle_max=(max(abs(sinal_controle))-1);
if sinal_controle_max<0
    sinal_controle_max=0;
end

%calculo do erro quadrático
% talvez usar somente depois da metade do vetor para garantir o erro em ss
% =0 length(t)/2:length(t)
erro_quad=(resposta_ideal-resposta_planta).^2;
erro_med=sum(erro_quad)/length(erro_quad);

%overshoot
info_step=stepinfo(malha_fechada);
oversh=info_step.Overshoot;

%bw do controlador obtido; ideal = Hz
%{
malha_aberta=P*M;
bw=bandwidth(malha_aberta);
if isnan(bw)==1 || bw>100
    bw=100;
else
    bw=bw-2;
end
%}
bw=0;

%fitness
k_overshoot=0.25;
k_erro=0.25;
k_bw=0.25;
k_ctr=0.25;
fitness_final=k_overshoot*oversh+k_erro*erro_med+k_bw*bw+k_ctr*sinal_controle_max;
fprintf('Overshoot: %f\tErroMed: %f\tBw: %f\tSinContr: %f\n',oversh, erro_med, bw, sinal_controle_max);
end

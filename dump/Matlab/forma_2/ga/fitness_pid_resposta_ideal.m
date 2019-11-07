%function fitness_final = fitness_pid(coef)
%{
Neste código será criada uma resposta ideal para ser comparada com 

%}

K=1;%coef(1);
Ti=1;%coef(2);
Td=1;%coef(3);
N=5;
Tf=Td/N;
%valores do sistema
zeta = 0.900733958553509;
wn=8.036118730219977;
k=1;
t=0:0.05:5;

s=tf('s');

%sistemas
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
% P_ctr=K*(1+(1/(Ti*s))+(Td*s/((100000+100000*s)*(1+Tf*s))));
% malha_aberta=P*M;
malha_fechada=(P*M)/(1+P*M);
% malha_fechada_ctr=(P_ctr*M)/(1+P_ctr*M);

%respostas
resp_deg_mf=step(malha_fechada,t);
% resp_deg_mf_ctr=step(malha_fechada_ctr,t);
erro=1-resp_deg_mf;
% [sinal_controle,t,x]=lsim(P_ctr,erro,t);

% sinal_controle_max=(max(abs(sinal_controle))-1);
% if sinal_controle_max<0
%     sinal_controle_max=0;
% end

% calculo do erro quadrático
% limite_transitorio = o tempo desejado para o tempo transitorio ideal
% em segundos.
resposta_ideal=1-(exp(-4*t));
% limite_transitorio=1;
% idx_limite_transitorio=find(t==limite_transitorio);
erro_quad=(resposta_ideal-resp_deg_mf').^2;
% erro_quad=erro_quad(limite_transitorio:end);
erro_med=sum(erro_quad)/length(erro_quad);

%overshoot
% info_step=stepinfo(malha_fechada);
% oversh=info_step.Overshoot;

%diferença entre o RiseTime e o Settlingtime, para evitar o pico
%indesejado.
% delta_T=info_step.SettlingTime-info_step.RiseTime;
% if isnan(delta_T)==1
%     delta_T=0;
% end

%bw do controlador obtido; ideal = Hz
% bw=bandwidth(malha_fechada);
% if isnan(bw)==1 %|| bw>100
%     bw=10000;
% else
%     %o ideal é que bw=2, ou seja, se bw=2, o erro é zero.
%     bw=bw-2;
% end

%fitness
% k_deltaT=1;
% k_overshoot=1;
% k_erro=100;
% k_bw=1;
% k_ctr=1;
fitness_final=erro_med
%fprintf('Fit:%.2f\tOS: %.2f\tEM: %.2f\tBw: %.2f\tSC: %.2f\tDT: %.2f\tK: %.2f\tTi: %.2f\tTd: %.2f\n',fitness_final,k_overshoot*oversh, k_erro*erro_med, k_bw*bw, k_ctr*sinal_controle_max,k_deltaT*delta_T,K,Ti,Td);
%end

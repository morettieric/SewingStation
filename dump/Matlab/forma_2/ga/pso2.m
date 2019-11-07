function [x,fval] = pso2(k_deltaT,k_overshoot,k_erro,k_bw,k_ctr)

format long;
rng default;

% global k_deltaT k_overshoot k_erro k_bw k_ctr;

fun=@(coef)fitness_pid3(coef,k_deltaT,k_overshoot,k_erro,k_bw,k_ctr);
nvars=3;
lb=[0.001,0.001,0.001];
ub=[100,100,100];
options = optimoptions('particleswarm','UseParallel', true, 'UseVectorized', false);
tic;

[x,fval] = particleswarm(fun,nvars,lb,ub,options)


x
fval
toc;

agora=datestr(now,'mm_dd_HH_MM_SS');
caminho='testesPSO3\';
arq=strcat(caminho,agora);
save(arq,'x','fval','k_deltaT','k_overshoot','k_erro','k_bw','k_ctr');
tsc(x);
end
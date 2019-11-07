function [x,fval] = alg_gen2(k_deltaT,k_overshoot,k_erro,k_bw,k_ctr)

format long;
rng default;

% global k_deltaT k_overshoot k_erro k_bw k_ctr;

fun=@(coef)fitness_pid3(coef,k_deltaT,k_overshoot,k_erro,k_bw,k_ctr);
nvars=3;
lb=[0.001 0.001 0.001];
ub=[100 100 100];
%options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn',
%@gaplotbestf);And,
options = optimoptions('ga','UseParallel', true, 'UseVectorized', false);
%[x,fval]=        ga(fun,nvars)
%options = optimoptions('ga','UseParallel', true, 'UseVectorized', false, 'PlotFcn', @gaplotbestf);
tic;
%[x,fval] = ga(fun,nvars,A,b,[],[],lb,ub,nonlcon,IntCon,options)
 [x,fval] = ga(fun,nvars,[],[],[],[],lb,ub,[],[],options);
%[x,fval,exitflag,output] = particleswarm(fun,nvars,lb,ub)
x
fval
toc;

agora=datestr(now,'mm_dd_HH_MM_SS');
caminho='testesGA3\';
arq=strcat(caminho,agora);
save(arq,'x','fval','k_deltaT','k_overshoot','k_erro','k_bw','k_ctr');
tsc(x);
end
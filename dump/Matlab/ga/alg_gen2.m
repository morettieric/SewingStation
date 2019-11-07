
clear all;
clc;
close all;
format long;
rng default;

fun=@fitness_pid;
nvars=3;
lb=[0 0 0];
ub=[1000 1000 1000];
%options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);

%        ga(fun,nvars,A,b,Aeq,beq,lb,ub)

tic;
[x,fval]=ga(fun,nvars,[],[],[],[],lb,ub);
%[x,fval,exitflag,output] = particleswarm(fun,nvars,lb,ub)
x
fval
toc;

agora=datestr(now,'mm_dd_HH_MM_SS');
caminho='testes\';
arq=strcat(caminho,agora);
save(arq,'x','fval');
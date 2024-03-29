close all; clc; clear all;

K=0.169022678510371;
Ti=0.072109163345392;
Td=0.091354695916176;
N=5;
Tf=Td/N;

zeta = 0.900733958553509;
wn=8.036118730219977;
k=1;
t=0:0.005:5;

s=tf('s');

%sistemas
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
P=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)));
malha_fechada=(P*M)/(1+P*M);

tecido_corrigido = [0
3.462
45.51
162.09
318.834
456.768
551.082
600.528
616.014
612.606
602.31
589.872
577.14
568.416
565.776
568.446
573.276
576.312
579.858
587.514
594.102
592.242
585.312
579.546
573.744
568.104
564.75
566.01
572.994
578.382
578.19
579.204
583.218
585.312
583.272
580.074
579.348
579.828
582.072
584.43
584.124
583.494
583.59
583.962
583.656
582.456
577.752
567.33
555.282
543.738
528.594
507.048
481.056
447.09
400.992
348.486
292.266
233.076
176.862
124.596
76.986
39.996
17.388
7.506
3.48
0.876
0
0
0
0
0];


carro=[0
0
0
0
0
0
0
1.05
12.7
53.85
134.25
241.58
350.94
442.6
509
551.74
576.32
588.32
592.94
593.78
592.32
589.25
586.34
585.34
585.91
586.98
587.45
587.01
586.85
586.84
585.85
584.2
582.72
581.71
581.7
583.14
585.32
586.69
586.31
585.31
585.37
586.38
587.5
588.37
588.9
589.14
589.21
589.18
589.12
589.06
588.5
587.35
586.8
587.17
587.81
587.88
586.64
585.19
582.49
569
530.64
459.41
361.93
257.95
166.28
96.09
49
21.03
6.42
0.22
0]

tecido_corrigido = tecido_corrigido';
t=0:0.1:(length(tecido_corrigido)*0.1)-0.1;
[simulado,t,x]=lsim(malha_fechada,tecido_corrigido,t);
%%
erro=carro-simulado;

figure(1)
plot(t,tecido_corrigido,'-k','LineWidth',1.5);
hold on
plot(t,simulado,'-r','LineWidth',1.5);
plot(t,carro,'-b','LineWidth',1.5);
plot(t,erro,'-g','LineWidth',1.5);
grid on
grid minor
legend('Sewing Machine Speed (Input)','Simulated Response','Real Response','Error� (Real-Simulated)�');
title('Comparison of the simulated and the real response');
xlabel('Time (s)');
%%
erro_relativo=sqrt(((carro-simulado)/carro).^2)*100;
figure(2)
plot(t,erro_relativo,'-k','LineWidth',1.5);
grid on
grid minor
title('Absolute Relative Error');
ylabel('Error (%)');
xlabel('Time (s)');

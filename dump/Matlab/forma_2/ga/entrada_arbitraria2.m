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
0.69
3.564
10.02
19.674
28.74
31.65
26.382
21.24
37.62
99.33
207.42
334.566
449.796
533.844
581.628
599.454
597.324
586.14
572.856
559.518
549.762
546.192
541.992
529.656
512.448
495.792
480.402
463.458
444.21
426.438
409.92
392.148
375.888
363.942
353.55
342.444
331.272
320.322
306.876
289.8
275.832
270.384
269.928
267.498
260.754
252.666
244.818
237.81
234.42
232.746
228.084
222.054
218.478
215.49
209.406
202.986
199.548
195.498
188.136
180.006
174.45
169.374
161.022
153.576
150.582
149.556
148.224
143.664
136.932
131.112
127.242
127.302
128.274
126.594
125.652
125.964
122.556
116.454
112.272
110.01];


carro=[0
0
0
0
0
0
0
0
0
0
0
0
0
0
0.52
7.4
37.01
104.64
204.76
314.8
413.36
488.93
539.84
570.47
586.56
592.29
591.68
588.61
585.88
585.07
585.27
584.79
584.16
584.16
584.42
583.15
574.26
549.99
506.55
446.01
374.34
299.64
230.26
172.4
131.77
112.89
116.99
142.02
182.02
229.96
278.69
320.35
348.36
358.47
349.03
322.04
282.01
234.32
185.36
141.78
108.51
87.97
81.89
90.75
111.76
139.95
169.79
195.9
214.48
223.35
221.12
208.1
185.77
156.73
125.44
96.43
73.06
58.33
54.29
59.93
72.76]

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
legend('Sewing Machine Speed (Input)','Simulated Response','Real Response','Error² (Real-Simulated)²');
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

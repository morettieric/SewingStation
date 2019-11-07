clear all; close all; clc;
t=0:0.05:1;

wn=8.036118730219977;
zeta=0.900733958553509;

s=tf('s');
M=(wn^2)/(s^2+2*zeta*wn*s+wn^2);
[y,t]=step(M,t);
Nf=5;

d1y=gradient(y,t);
d2y=gradient(d1y,t);

t_infl = interp1(d1y, t, max(d1y));
y_infl = interp1(t, y, t_infl);
slope  = interp1(t, d1y, t_infl);   % Slope Defined Here As Maximum Of First Derivative
intcpt = y_infl - slope*t_infl;     % Calculate Intercept
tngt = slope*t + intcpt;  

figure (1);
plot(t,y,'-k','LineWidth',1.5);
grid on
title('Example of the Inflection point');
axis([0 length(t)*0.05-0.05 0 1.1]);
hold on
plot(t, tngt, '-r', 'LineWidth',1); % Plot Tangent Line
plot(t_infl, y_infl, 'bp');

%parameters from the graph
T = interp1(tngt, t, 0);
L = (interp1(tngt, t, 1))-T;
DeltaCp=max(y);
N=DeltaCp/T;
R=N*L/DeltaCp;
P=1;                                %from step function

%Ziegler-Nichols
fprintf('Zigler-Nichols')
K=1.2*P/(N*L)
Ti=2*L
Td=0.5*L
Tf=Td/Nf;
tsc([K Ti Td]);
title('Ziegler-Nichols Step');

%Cohen-Coon
fprintf('Cohen-Coon')
K=(P/(N*L))*(1.33+R/4)
Ti=L*((32+6*R)/(13+8*R))
Td=L*(4/(11+2*R))
tsc([K Ti Td]);
title('Cohen-Coon Step');

%Chien-Hrones-Reswick
fprintf('Chien-Hrones-Reswick')
K=0.95*T/L
Ti=2.4*L
Td=0.42*L
Tf=Td/Nf;
tsc([K Ti Td]); 
title('Chien-Hrones-Reswick Step');
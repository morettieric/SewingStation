clear all;
clc;
close all;
format long;
rng default;

global zeta
zeta = 0.900733958553509;
global wn
wn=8.036118730219977;
global k
k=1;
global t
t=0:0.005:1;
global s
s=tf('s');

G=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
%[y,t]=step(G,t);
resposta_ideal=ones(length(t),1);

Kp=1;
Ti=1;
Td=1;

fitness_atual=0;
fitness_anterior=0;

Ti_melhor=1;
Td_melhor=1;
Kp_melhor=1;

Ti_pior=1;
Td_pior=1;
Kp_pior=1;
%{
[y,overshoot]=teste_pid(Kp,Ti,Td,G);
figure;
plot (t,y);
hold on
grid on
grid minor
plot (t,overshoot);
%}

loop_size=1000;

fitness_array=zeros(1,loop_size);
%{
for i=1:loop_size
    Ti=rand;
    Td=rand;
    Kp=50*rand;
    
    if Ti==0
        Ti=50*rand;
    end
    if Td==0
        Td=50*rand;
    end
    if Kp==0
        Kp=50*rand;
    end
    D=Kp*(1+(1/(Ti*s))+Td*s);
    H=G*D/(1+G*D);
    y_ga= step (H,t);
    [erro,fitness_atual] = fitness(y_ga,resposta_ideal);
    fitness_array(i)=fitness_atual;
    
    if fitness_atual<fitness_anterior
        fitness_anterior=fitness_atual;
        Ti_melhor=Ti;
        Td_melhor=Td;
        Kp_melhor=Kp;
    end
    
    if fitness_atual>fitness_anterior
        fitness_anterior=fitness_atual;
        Ti_pior=Ti;
        Td_pior=Td;
        Kp_pior=Kp;
    end
    
    fprintf('i: %i\tKp: %f\tTi: %f\tTd: %f\tFit: %f\n', i,Kp,Ti,Td,fitness_atual);
end
 %}
x=ga(@fitness2,3)
D=Kp_melhor*(1+(1/(Ti_melhor*s))+Td_melhor*s);
H=G*D/(1+G*D);
y_melhor=step(H,t);

D=Kp_pior*(1+(1/(Ti_pior*s))+Td_pior*s);
H=G*D/(1+G*D);
y_pior=step(H,t);

figure(1);
hold on
plot (t,y_melhor);
plot (t,y_pior);
legend ('Melhor controlador','Pior controlador');
hold off

figure(2);
plot(1:length(fitness_array),fitness_array);
 
fprintf('\nMelhor\nKp: %f\tTi: %f\tTd: %f\tFit: %f\n',Kp,Ti,Td);


function erro_med = fitness2(Kp, Ti, Td)
%valores do sistema
zeta = 0.900733958553509;
wn=8.036118730219977;
k=1;
t=0:0.005:1;

%calculando a resposta
s=tf('s');
G=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
s=tf('s');
D=Kp*(1+(1/(Ti*s))+Td*s);
H=G*D/(1+G*D);
t=0:0.005:1;
resposta_ideal=ones(length(t),1);
y_ga= step (H,t);

%calculo do erro quadrático
erro_quad=(resposta_ideal-y_ga).^2;
erro_med=sum(erro_quad)/length(a);
end

function [erro_quad,erro_ss_med] = fitness(a,b)
%erro quadrático em relação ao degrau
erro_quad=(a-b).^2;
erro_med=sum(erro_quad)/length(a);

%erro quadrático em relação ao estado estacionário
erro_ss=(a(idivide(int32(length(a)),2,'round'):length(a))-b(idivide(int32(length(b)),2,'round'):length(b))).^2;
erro_ss_med=sum(erro_ss)/length(erro_ss);
end

function [y,overshoot] = teste_pid(Kp,Ti,Td,G)
s=tf('s');
D=Kp*(1+(1/(Ti*s))+Td*s);
H=G*D/(1+G*D);
t=0:0.005:1;
[y,t]=step(H,t);
informa=stepinfo(H)
overshoot=informa.Overshoot;
end

clear all;
clc;
close all;
format long;

global zeta
zeta = 0.900733958553509;
global wn
wn=8.036118730219977;
global k
k=1;
global t
t=0:0.005:1;

G=tf([k*wn*wn],[1 2*wn*zeta wn*wn]);
[y,t]=step(G,t);
resposta_ideal=ones(length(t),1);

Kp=1;
Ti=1;
Td=1;

x=teste_pid(Kp,Ti,Td,t,G);

%y_simulink= step (H,t);
fitness_atual=0;
fitness_anterior=0;

Ti_melhor=1;
Td_melhor=1;
Kp_melhor=1;

loop_size=10;
fitness_array=zeros(1,loop_size);
for i=1:loop_size
    Ti=50*rand;
    Td=50*rand;
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
    [erro,fitness_atual] = fitness(resposta_ideal,y_ga);
    fitness_array(i)=fitness_atual;
    
    if fitness_atual<fitness_anterior
        fitness_anterior=fitness_atual;
        Ti_melhor=Ti;
        Td_melhor=Td;
        Kp_melhor=Kp;
    end
    clc;
    i
end
    
D=Kp_melhor*(1+(1/(Ti_melhor*s))+Td_melhor*s);
H=G*D/(1+G*D);
y_melhor=step(H,t);

figure;
plot (t,y); 
hold on
plot (t,y_melhor);
legend ('Sistema','Melhor controlador');

figure;
plot(1:length(fitness_array),fitness_array);

Ti_melhor=Ti;
Td_melhor=Td;
Kp_melhor=Kp;

function [erro_quad,erro_med] = fitness(a,b)
    erro_quad=(a-b).^2;
    erro_med=100*sum(erro_quad)/length(a);
end

function y = teste_pid(Kp,Ti,Td,t,G)
    s=tf('s');
    D=Kp*(1+(1/(Ti*s))+Td*s);
    H=G*D/(1+G*D);
    [y,t]=step(H,t);

end

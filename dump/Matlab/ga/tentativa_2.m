clc;
clear all;
close all;
format long;

Kp=0.919103263990108;
Ki=2.668486714901025;
Kd=0.222750604152679;
T=0.1;

alfa=4*Kd+2*Kp*T+Ki*T^2;
beta=-8*Kd+(T^2)*Ki-2*T*Kp+2*Kp+T*Ki;
gama=4*Kd+T*Ki-2*Kp;

a=2*alfa/T
b=(2*beta-2*alfa)/T
c=(2*gama-2*beta)/T
d=-2*gama/T
e=-T
%{
a = 22.0302
b = -18.7119
c = -16.9254
d = 13.6071
e = -0.1000
%}
K=0.169022678510371;
Ti=0.072109163345392;
Td=0.091354695916176;
N=5;
Tf=Td/N;

s=tf('s');

P=K*(1+(1/(Ti*s))+(Td*s/(1+Tf*s)))
P=minreal(P)
P_d=c2d(P,0.1,'tustin')

num=P_d.Numerator{1}
den=P_d.Denominator{1}

%%
step(P_d)

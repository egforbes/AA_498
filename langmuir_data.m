%EP Lab Langmuir Data
%Eleanor Forbes
%Nov 5, 2017

clear all; close all; clc;

data = xlsread('iv_langmuir\n3cm_2A_edit.csv');

%%
V2 = data(:,4);
I_sat = data(:,12);
I_m = data(:,11);
I_adj = I_m-I_sat;

plot(V2,I_m)
figure(2)
plot(V2,I_adj,'.')
% set(gca,'yscale','log')

%%

crop1 = V2<-5;
i_sat = polyfit(V2(crop1),I2(crop1),1);
i_fit = polyval(i_sat,V2);

I2_adj = I2-i_fit;
figure(3)
plot(smooth(V2,50),smooth(log(I2_adj),50),'.')
figure(2)
plot(V2,smooth(log(I2_adj),20),'.')
ylim([-14 -8]);
%%
sval = -5;
kval = 25;
temprange = V2 > -5 & V2 < 25;
T_fit = polyfit(smooth(V2(temprange),50),smooth(log(I2_adj(temprange)),50),1);

T_check = polyval(T_fit,V2(temprange));
figure(4)
plot(V2(temprange),T_check)
hold on
plot(smooth(V2,50),smooth(log(I2_adj),50),'.')
%%
%compute probe parameters

%knowns
c = 3E8;
e = 1.6E-19;
A = 5e-6;
k = 1.6E-19; %J/eV
mi = 6.63E-26;

Te = real(1/T_fit(1))
indk = V2<=-24;
kneeind = nnz(indk);
n = -i_fit(kneeind)/(c*e*A*sqrt(k*Te/mi))



%%

hold on
plot(V2,log(i_fit))
% plot(V2,I2,'.')
xlabel('Voltage (V)')
ylabel('Current (I)')
title('I-V Langmuir Probe Curve, -3cm, 2A coil')
set(gca,'FontSize',16)
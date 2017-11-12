%This program will analyze the ion saturation current as a function of
%distance along the axis of the magnetic nozzle

clear all; close all; clc;

%Read in the data (only need to do once)
data = xlsread('DC_V_probe.xlsx');

%%
loc = data(1:11,1);
I_2A = data(1:11,2)./10E3;
I_4A = data(1:11,3)./10E3;
I_6A = data(1:11,4)./10E3;

%Plot the ion saturation current
figure(1)
plot(loc,I_2A,'g-.','Linewidth',2)
hold on
plot(loc,I_4A,'b-.','Linewidth',2)
plot(loc,I_6A,'r-.','Linewidth',2)
xlabel('Distance from nozzle throat (cm)')
ylabel('Ion saturation current (A)')
set(gca,'Fontsize',14)
legend('2A of Nozzle Current','4A of Nozzle Current','6A of Nozzle Current')

title('Axial Variation of Ion Saturation Current')


%%
%The ion saturation current can be used to determine properties of the
%sheath
%In this case, the ion saturation current density j = e*ne*cs, where j =
%I/A. 
%cs is the sound speed given by cs = sqrt(kb*(Z*Te+g*Ti)/mi)
%in this case we can assume Te = Ti, Z = 1, g = 1
%The floating potential is given by V = (kb*Te/e)*.5*ln(m1/(2*pi*me))

%Let's use the results from our IV data to approximate the density
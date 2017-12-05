%EP Lab 2 analysis

clear all; close all; clc;

%Fit the function
%V_BD = Bpd/(ln(Apd)-ln(ln(1+1/gamma)))
%Where A, B, and Gamma are constants
%the minimum breakdown voltage is 
%V_BD(min) = (B*ln(1+1/gamma)/A)*e

argondata = xlsread('argondata.xlsx');
heliumdata = xlsread('heliumdata1.xlsx');
nitrogendata = xlsread('nitrogendata.xlsx');

%%
%each gas was tested at five different distances

d1 = 20; %cm
d2 = 10;
d3 = 5;
d4 = 2;
d5 = 1;

%locations of data for different distances
i1_a = argondata(:,6) == 20;
i1_h = heliumdata(:,6) == 20;
i1_n = nitrogendata(:,6) == 20;

i2_a = argondata(:,6) == 10;
i2_h = heliumdata(:,6) == 10;
i2_n = nitrogendata(:,6) == 10;

% i3_a = argondata(:,6) == 5;
i3_h = heliumdata(:,6) == 5;
i3_n = nitrogendata(:,6) == 5;

i4_a = argondata(:,6) == 2;
i4_h = heliumdata(:,6) == 2;
i4_n = nitrogendata(:,6) == 2;

i5_a = argondata(:,6) == 1;
i5_h = heliumdata(:,6) == 1;
i5_n = nitrogendata(:,6) == 1;

%Get pressure-distance and breakdown voltage

%Argon
pd1_a = argondata(i1_a,1)*d1;
pd2_a = argondata(i2_a,1)*d2;
pd4_a = argondata(i4_a,1)*d4;
pd5_a = argondata(i5_a,1)*d5;

V1_a = argondata(i1_a,2);
V2_a = argondata(i2_a,2);
V4_a = argondata(i4_a,2);
V5_a = argondata(i5_a,2);

%Helium
pd1_h = heliumdata(i1_h,1)*d1;
pd2_h = heliumdata(i2_h,1)*d2;
pd3_h = heliumdata(i3_h,1)*d3;
pd4_h = heliumdata(i4_h,1)*d4;
pd5_h = heliumdata(i5_h,1)*d5;

V1_h = heliumdata(i1_h,2);
V2_h = heliumdata(i2_h,2);
V3_h = heliumdata(i3_h,2);
V4_h = heliumdata(i4_h,2);
V5_h = heliumdata(i5_h,2);

%Nitrogen
pd1_n = nitrogendata(i1_n,1)*d1;
pd2_n = nitrogendata(i2_n,1)*d2;
pd3_n = nitrogendata(i3_n,1)*d3;
pd4_n = nitrogendata(i4_n,1)*d4;
pd5_n = nitrogendata(i5_n,1)*d5;

V1_n = nitrogendata(i1_n,2);
V2_n = nitrogendata(i2_n,2);
V3_n = nitrogendata(i3_n,2);
V4_n = nitrogendata(i4_n,2);
V5_n = nitrogendata(i5_n,2);
%%

% %let the variable x = [A, B, gamma];
% start = 4;
% F = @(x,xdata)x(2).*xdata./(log(x(1).*xdata)-log(log(1+1/x(3))));
% x0 = [80 700 0.005]; %initial guess
% [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,pd4_a(start:end),V4_a(start:end)*1E3);
% x
% 
% plot(pd4_a(start:end),F(x,pd4_a(start:end)))
% hold on
% plot(pd4_n,V4_n*1E3,'ko')

%Instead use a modified version of the equation that gets rid of the SEEC
start = 1;
F = @(x,xdata)x(2).*xdata./(log(x(1).*xdata));
x0 = [.7 60];
pd = pd2_h;
V = V2_h;
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,pd(start:end),V(start:end)*1E3);
x
pdinterp = linspace(1.5,max(pd),length(pd)*4);
% plot(pdinterp,F(x,pdinterp),'linewidth',2)
semilogx(pdinterp,F(x,pdinterp),'linewidth',2)
hold on
semilogx(pd,V*1E3,'ko','linewidth',2)
% plot(pd,V*1E3,'ko','linewidth',2)
legend('Fit','Raw Data')
set(gca,'Fontsize',14)
xlabel('pd (torr-cm)')
ylabel('Breakdown Voltage (V)')
title('Paschen Fit for He, d = 10')
xlim([4E-1 3E1]) 
hold off
%%
figure()
subplot(1,2,1)
plot(pdinterp,F(x,pdinterp),'linewidth',2)
hold on
plot(pd,V*1E3,'ko','linewidth',2)
legend('Fit','Raw Data')
set(gca,'Fontsize',14)
xlabel('pd (torr-cm)')
ylabel('Breakdown Voltage (V)')
title('Paschen Fit for Ar, d = 2 cm')
% xlim([4E-2 3E1]) 
hold off
subplot(1,2,2)
semilogx(pdinterp,F(x,pdinterp),'linewidth',2)
hold on
semilogx(pd,V*1E3,'ko','linewidth',2)
legend('Fit','Raw Data')
set(gca,'Fontsize',14)
title('Log Scale on pd')
xlim([4E-2 3E1]) 




%%

%Argon
figure(2)
semilogx(pd1_a,V1_a,'ko')
hold on
semilogx(pd2_a,V2_a,'bs')
semilogx(pd4_a,V4_a,'ro')
semilogx(pd5_a,V5_a,'gs')
xlim([4E-2 1E2])
set(gca,'Fontsize',14)
xlabel('pd (torr-cm)')
ylabel('Breakdown Voltage (kV)')
title('Argon Paschen Curves')
legend('d = 20 cm','d = 10 cm','d = 2 cm','d = 1 cm')
hold off

%Helium
figure(3)
semilogx(pd1_h,V1_h,'ko')
hold on
semilogx(pd2_h,V2_h,'bs')
semilogx(pd3_h,V3_h,'mo')
semilogx(pd4_h,V4_h,'rs')
semilogx(pd5_h,V5_h,'go')
xlim([3E-2 1E2])
set(gca,'Fontsize',14)
xlabel('pd (torr-cm)')
ylabel('Breakdown Voltage (kV)')
title('Helium Paschen Curves')
legend('d = 20 cm','d = 10 cm','d = 5 cm','d = 2 cm','d = 1 cm')
hold off

%Nitrogen
figure(4)
semilogx(pd1_n,V1_n,'ko')
hold on
semilogx(pd2_n,V2_n,'bs')
semilogx(pd3_n,V3_n,'mo')
semilogx(pd4_n,V4_n,'rs')
semilogx(pd5_n,V5_n,'go')
xlim([3E-2 1E2])
set(gca,'Fontsize',14)
xlabel('pd (torr-cm)')
ylim([0.3 2.1])
ylabel('Breakdown Voltage (kV)')
title('Nitrogen Paschen Curves')
legend('d = 20 cm','d = 10 cm','d = 5 cm','d = 2 cm','d = 1 cm')


%%
%compare found coefficients to other experimentally determined ones

%He
Ap_h = [0.77 0.7 0.68 0.69 0.60];
B_h = [35 60 39 39 34];
Ap_hf = [1.08 0.69 0.668 0.81 4.77];
B_hf = [66.85 28.23 35.32 31.59 243.00];

Ap_hm = mean(Ap_h);
Ap_hs = std(Ap_h);
Ap_hmf = mean(Ap_hf);
Ap_hsf = std(Ap_hf);
B_hm = mean(B_h);
B_hs = std(B_h);
B_hmf = mean(B_hf);
B_hsf = std(B_hf);

%Ar
Ap_a = [3.15 3.1 3.02 2.64 3.57];
B_a = [154 320 152 133 180];
Ap_af = [0.74 2.64 3.067 3.18];
B_af = [125.8 187.6 231.42 291.85];

Ap_am = mean(Ap_a);
Ap_as = std(Ap_a);
Ap_amf = mean(Ap_af);
Ap_asf = std(Ap_af);
B_am = mean(B_a);
B_as = std(B_a);
B_amf = mean(B_af);
B_asf = std(B_af);

%N
Ap_n = [2.94 2.5 4.0 2.97 3.69];
B_n = [349 550 374 274 341];
Ap_nf = [5.79 6.52 2.24 1.33 5.06];
B_nf = [546.9 654.6 336.6 214 564.28];

Ap_nm = mean(Ap_n)
Ap_ns = std(Ap_n)
Ap_nmf = mean(Ap_nf)
Ap_nsf = std(Ap_nf)
B_nm = mean(B_n)
B_ns = std(B_n)
B_nmf = mean(B_nf)
B_nsf = std(B_nf)





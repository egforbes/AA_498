%Look at spectra obtained from CS200 spectrometer

clear all; close all; clc;

d1 = xlsread('spec_1_7W.csv');
d2 = xlsread('spec_25W.csv');

%%
waves = d1(:,1);
spec = d1(:,2);

spec2 = d2(:,2);

icrop = waves > 720 & waves < 878;

[peakk,locs] = findpeaks(spec(icrop),'MinPeakHeight',.04);
[peek,look] = findpeaks(spec2(icrop),'MinPeakHeight',0.2);

wrange = waves(icrop);

plot(wrange,spec2(icrop),'g','Linewidth',2)
hold on
plot(wrange,spec(icrop),'b','Linewidth',2)
plot(wrange(look),peek,'rs','Linewidth',2)
xlabel('Wavelength (nm)')
ylabel('Intensity (arb)')
title('Argon Emission Spectra')
legend('25 kW Applied Power','7 kW Applied Power')
set(gca,'Fontsize',14)
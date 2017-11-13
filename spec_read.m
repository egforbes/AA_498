%Look at spectra obtained from CS200 spectrometer

clear all; close all; clc;

d1 = xlsread('spec_1_7W.csv');
d2 = xlsread('spec_25W.csv');

%%
waves = d1(:,1);
spec = d1(:,2);
spec2 = d2(:,2);

%Small region of interest
icrop = waves > 720 & waves < 878;

%Normalize the spectra
spnorm = spec./max(spec);
spnorm2 = spec2./max(spec2);

%Find peaks with a minimum height
[peakk,locs] = findpeaks(spnorm(icrop),'MinPeakHeight',.2);
[peek,look] = findpeaks(spnorm2(icrop),'MinPeakHeight',0.2);

wrange = waves(icrop); %wavelength range

%Plot the spectra
figure(1)
plot(wrange,spec2(icrop),'g','Linewidth',2)
hold on
plot(wrange,spec(icrop),'b','Linewidth',2)
plot(wrange(look),peek,'rs','Linewidth',2)
xlabel('Wavelength (nm)')
ylabel('Intensity (arb)')
title('Argon Emission Spectra')
legend('25 kW Applied Power','7 kW Applied Power')
set(gca,'Fontsize',14)


%%

srange1 = spnorm(icrop);
srange2 = spnorm2(icrop);

%Only use identified peaks that both share
%25W
corlocs = [1:4 7:10 12];
rloc = look(corlocs);

%7W
olocs = [1:8 10];
ulocs = locs(olocs);

%Find the intensity increase of lines other than the big one at 810 nm
ints = srange2(rloc)./srange1(ulocs);

%This will plot the relative intensity and one spectra to show the peaks
figure(2)
plot(wrange(rloc),ints,'ko')
hold on
plot(wrange,spnorm2(icrop))


%%
figure(3)
plot(wrange,spnorm(icrop),'linewidth',2)
hold on
plot(wrange,spnorm2(icrop),'linewidth',2)
plot(wrange(locs([1:8 10])),peakk([1:8 10]),'co','linewidth',2)
plot(wrange(look),peek,'go','linewidth',2)
xlabel('Wavelength (nm)')
ylabel('Intensity (arb)')
title('Ar Emission Spectra')
legend('7W Input Power','25W Input Power')
set(gca,'Fontsize',14)




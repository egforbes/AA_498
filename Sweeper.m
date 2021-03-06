fileList = dir('*.csv'); % pull list of all csv files in the present folder
names = fliplr({fileList.name});% Cell array NOT VECTOR

% pre-condition figures

% the I-Prove
a = figure(1)
hold on
xlabel('Bias Voltage [V]')
ylabel('Current [A]')

% I-electron
b = figure(2)
hold on
xlabel('Bias Voltage [V]')
ylabel('Current [A]')

I_final = [];
index = 1;

for name = names
    
    [num] = xlsread(name{1});

    V = [num(:,4)];
    I = [num(:,10)]./(9.88*10^3);
    
    
    % n = 1 was too much for software *somehow* so n=30 in polyfit was used
    p = polyfit(V,I,30);
    x1 = linspace(min(V),max(V),2500);
    f1 = polyval(p,x1);
    
    % rough estimate of the initial slope of data
    slope=((polyval(p,min(V)+30)-polyval(p,min(V)))/((min(V)+30)-min(V)));
    Ii =(slope.*(x1-min(V)))+min(I); % Ion saturation current estimate
    
    I_slope(index) = slope;
    I_b(index) = min(I);
    
    % plot the IV Trace of I-Probe
    figure(1)
    plot(x1,f1,'-.','LineWidth',1);
    
    % plot the IV trace of I-e
    figure(2)
    plot(x1,f1-Ii,'-.','LineWidth',1);
    
    %save I-e
    I_final(index,:) = f1-Ii;
    index = index + 1;
end

% Post-plot adding of legend entries ADD/REMOVE elements to match the length(names)
% size in here
figure(1)
legend(names{1},names{2},names{3},names{4},names{5},names{6},'location','best');
figure(2)
legend(names{1},names{2},names{3},names{4},names{5},names{6},'location','best');

%%

% Find signals that actually contain information
ind_use = I_final(:,end) > 0; 

% Make sure those are right
% plot(x1,log(I_final(ind_use,:)),'-.', 'Linewidth',2)
% xlabel('Voltage (V)')
% ylabel('Current (A)')
% title('Good Signals')
% legend(names(ind_use),'location','best')

%Extract only current traces we want
I_use = I_final(ind_use,:);
names_use = names(ind_use);
I_slope_u = I_slope(ind_use);
I_b_u = I_b(ind_use);

figure(55)
plot(x1,log(I_use(9,:)),'-.','Linewidth',2)
% legend(names_use{2},'location','best')
xlabel('Voltage (V)')
ylabel('Current (A)')
title('Signal')

% legend(names(ind_use),'location','best')

%%

%Heuristic determination of steep linez for electron temperature
Te_ind = zeros(length(I_use(1,:)),9);
Te_ind(:,1) = x1 > 19 & x1 < 29;
Te_ind(:,2) = x1 > -53 & x1 < -27;
Te_ind(:,3) = x1 > -64 & x1 < -52;
Te_ind(:,4) = x1 > -63 & x1 < -53;
Te_ind(:,5) = x1 > -2 & x1 < 18;
Te_ind(:,6) = x1 > -29 & x1 < -9;
Te_ind(:,7) = x1 > -46 & x1 < -25;
Te_ind(:,8) = x1 > 10 & x1 < 32;
Te_ind(:,9) = x1 > -4 & x1 < 31;


%%
%Brute force your way into electron temperatures

Te = zeros(9,1);
%Use the fit function to get a line fit and the confidence intervals for
%each temp
for jcrop = 1:9
   ii = Te_ind(:,jcrop) == 1;
   x_u = x1(ii);
   I_u = log(I_use(jcrop,ii));
   Te_fit = fit(x_u.',I_u.','poly1'); %fits a 1 degree polynomial
   subplot(3,3,jcrop)               %These lines will plot the fits
   plot(Te_fit,x_u.',I_u.')
   legend off
    
    Isat_vp(jcrop) = I_slope_u(jcrop)*(x_u(end)-min(V)) + I_b_u(jcrop);

   Te(jcrop) = 1/Te_fit.p1;          %Te is the inverse slope
   ci = confint(Te_fit,0.9);         %gets the 90% confidence intervals
   errbar(jcrop,:) = ci(:,1);        %keep only error for slope
   
end

Temp_err = 1./errbar;

locs_use = [1 -3 -3 -3 -2 -2 -2 -1 0]; %These are the locations for the traces
ind_2A = [4 7];
ind_4A = [3 6];
ind_6A = [1 2 5 8 9];

%%
%Plotting
figure(8)
subplot(2,1,1)
plot1 = errorbar(locs_use(ind_2A) ,Te(ind_2A),...
    Te(ind_2A)-Temp_err(ind_2A,2),Te(ind_2A)-Temp_err(ind_2A,1),'go','Markerfacecolor','g');
xlim([-4 2])
ylim([0 40])
set(gca,'Fontsize',14)
% xlabel('Location (cm from center of nozzle)')
ylabel('Temperature (eV)')
title('T_{e} from the IV Slope')

hold on
plot2 = errorbar(locs_use(ind_4A) ,Te(ind_4A),...
    Te(ind_4A)-Temp_err(ind_4A,2),Te(ind_4A)-Temp_err(ind_4A,1),'bo','Markerfacecolor','b');

plot3 = errorbar(locs_use(ind_6A) ,Te(ind_6A),...
    Te(ind_6A)-Temp_err(ind_6A,2),Te(ind_6A)-Temp_err(ind_6A,1),'ro','Markerfacecolor','r');

% legend('2A Nozzle Current','4A Nozzle Current','6A Nozzle Current','Location','best')





%n =i_sat(Vp)/(ceAsqrt(kT/mi)) 

%define constants
e = 1.6E-19;
A = 5E-6;
k = 1.6E-19; %j/ev
m = 6.63E-26; %kg

for jdens = 1:length(Te)
n(jdens) = abs(Isat_vp(jdens)/(e*A*sqrt(k*Te(jdens)/m)));
end

%Plot densities
figure(8)
subplot(2,1,2)
plot(locs_use(ind_2A),n(ind_2A),'go','Markerfacecolor','g')
hold on
plot(locs_use(ind_4A),n(ind_4A),'bo','Markerfacecolor','b')
plot(locs_use(ind_6A),n(ind_6A),'ro','Markerfacecolor','r')
xlabel('Distance from Nozzle Throat (cm)')
ylabel('Density (m^{-3})')
title('Ion density from I_{sat}')
xlim([-4 2])
set(gca,'Fontsize',14)
legend('2A Nozzle Current','4A Nozzle Current', '6A Nozzle Current')
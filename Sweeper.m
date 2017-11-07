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
    
    % plot the IV Trace of I-Probe
    figure(1)
    plot(x1,f1,'-.','LineWidth',1);
    
    % plot the IV trace of I-e
    figure(2)
    plot(x1,f1-Ii,'-.','LineWidth',1);
    
end

% Post-plot adding of legend entries ADD/REMOVE elements to match the length(names)
% size in here
figure(1)
legend(names{1},names{2},names{3},names{4},names{5},names{6},'location','best');
figure(2)
legend(names{1},names{2},names{3},names{4},names{5},names{6},'location','best');
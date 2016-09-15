% Script to find Landsat 8 matchups for Rrs based on in situ data from
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')
%% Load sat data
clear SatData
fileID = fopen('./GOCI_TemporalAnly/GOCI_ROI_STATS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

for idx0=1:size(s{1},1)
      
      filepath = ['./GOCI_TemporalAnly/GOCI_ROI_STATS/' s{1}{idx0}];
      SatData(idx0) = loadsatcell_tempanly(filepath);
      
end

save('GOCI_TempAnly.mat','SatData')
%%
load('GOCI_TempAnly.mat','SatData')

h1 =  figure('Color','white','DefaultAxesFontSize',fs);

xrange = 0.02;

% Rrs_412
cond1 = ~isnan([SatData.Rrs_412_filtered_mean]);
cond2 = [SatData.Rrs_412_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = cond1&cond2;

data_used = [SatData(cond_used).Rrs_412_filtered_mean];

figure(h1)
subplot(6,1,1)
plot([SatData(cond_used).datetime],data_used,'.')
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(412)','FontSize',fs)

N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(412) (sr^{-1})','FontSize',fs)
xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.80*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

grid on

% Rrs_443
cond1 = ~isnan([SatData.Rrs_443_filtered_mean]);
cond2 = [SatData.Rrs_443_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = cond1&cond2;

data_used = [SatData(cond_used).Rrs_443_filtered_mean];

figure(h1)
subplot(6,1,2)
plot([SatData(cond_used).datetime],data_used,'.')
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(443)','FontSize',fs)

N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(443) (sr^{-1})','FontSize',fs)
xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.80*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

grid on

% Rrs_490
cond1 = ~isnan([SatData.Rrs_490_filtered_mean]);
cond2 = [SatData.Rrs_490_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = cond1&cond2;

data_used = [SatData(cond_used).Rrs_490_filtered_mean];

figure(h1)
subplot(6,1,3)
plot([SatData(cond_used).datetime],data_used,'.')
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(490)','FontSize',fs)

N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(490) (sr^{-1})','FontSize',fs)
xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.80*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

grid on

% Rrs_555
cond1 = ~isnan([SatData.Rrs_555_filtered_mean]);
cond2 = [SatData.Rrs_555_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = cond1&cond2;

data_used = [SatData(cond_used).Rrs_555_filtered_mean];

figure(h1)
subplot(6,1,4)
plot([SatData(cond_used).datetime],data_used,'.')
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(555)','FontSize',fs)

N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(555) (sr^{-1})','FontSize',fs)
xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.80*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

grid on

% Rrs_660
cond1 = ~isnan([SatData.Rrs_660_filtered_mean]);
cond2 = [SatData.Rrs_660_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = cond1&cond2;

data_used = [SatData(cond_used).Rrs_660_filtered_mean];

figure(h1)
subplot(6,1,5)
plot([SatData(cond_used).datetime],data_used,'.')
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(660)','FontSize',fs)


N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(660) (sr^{-1})','FontSize',fs)
xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.80*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

grid on

% Rrs_680
cond1 = ~isnan([SatData.Rrs_680_filtered_mean]);
cond2 = [SatData.Rrs_680_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = cond1&cond2;

data_used = [SatData(cond_used).Rrs_680_filtered_mean];


figure(h1)
subplot(6,1,6)
plot([SatData(cond_used).datetime],data_used,'.')
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(680)','FontSize',fs)
xlabel('Time','FontSize',fs)

N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(680) (sr^{-1})','FontSize',fs)
xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.80*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

grid on

%% Plot one day

cond_used = 1:32;

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([SatData(cond_used).datetime],[SatData(cond_used).Rrs_412_filtered_mean],'bo')
ylabel('R_{rs}(490)','FontSize',fs)

subplot(2,1,2)
plot([SatData(cond_used).datetime],90-[SatData(cond_used).center_el],'bo')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)






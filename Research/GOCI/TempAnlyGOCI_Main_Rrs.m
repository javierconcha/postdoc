% Script to find Landsat 8 matchups for Rrs based on in situ data from
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')
%% Load sat data
clear SatData
tic
fileID = fopen('./GOCI_TemporalAnly/GOCI_ROI_STATS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

for idx0=1:size(s{1},1)
      
      filepath = ['./GOCI_TemporalAnly/GOCI_ROI_STATS/' s{1}{idx0}];
      SatData(idx0) = loadsatcell_tempanly(filepath);
      
end

save('GOCI_TempAnly.mat','SatData')
toc
%%
load('GOCI_TempAnly.mat','SatData')

fs = 20;
h1 =  figure('Color','white','DefaultAxesFontSize',fs);

xrange = 0.02;

% Rrs_412
cond1 = ~isnan([SatData.Rrs_412_filtered_mean]);
cond2 = [SatData.Rrs_412_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond3 = [SatData.center_ze] <= 60;
cond_used = cond1&cond2&cond3;

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

%% Plot vs time

% cond_used = 11064-7:11064+23;
cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);
cond2 = [SatData.Rrs_660_filtered_valid_pixel_count]>= 1+size(cond1,2)/2;
cond_used = [SatData.center_ze] <= 65&cond2;

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([SatData(cond_used).datetime],[SatData(cond_used).Rrs_490_filtered_mean],'.','MarkerSize',12)
ylabel('R_{rs}(490)','FontSize',fs)
grid on

subplot(2,1,2)
plot([SatData(cond_used).datetime],[SatData(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on

%% Chlr_a

% cond_used = 11064-7:11064+23;
cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([SatData(cond_used).datetime],[SatData(cond_used).chlor_a_filtered_mean],'.','MarkerSize',20)
ylabel('Chlor\_a','FontSize',fs)
grid on

subplot(2,1,2)
plot([SatData(cond_used).datetime],[SatData(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on

%% mean rrs vs zenith

% cond_used = 11064-7:11064+23;
cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
plot([SatData(cond_used).Rrs_412_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(412)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

subplot(2,3,2)
plot([SatData(cond_used).Rrs_443_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(443)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

subplot(2,3,3)
plot([SatData(cond_used).Rrs_490_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(490)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

subplot(2,3,4)
plot([SatData(cond_used).Rrs_555_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(555)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

subplot(2,3,5)
plot([SatData(cond_used).Rrs_660_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(660)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

subplot(2,3,6)
plot([SatData(cond_used).Rrs_680_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(680)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on


%% chl vs zenith

% cond_used = 11064-7:11064+23;
cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([SatData(cond_used).chlor_a_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',12)
xlabel('Chlor_a','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on


%% Capture time analysis
D= datevec([SatData.datetime]);
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([SatData.datetime],D(:,4),'.-')
ylabel('Hour of the day (GMT)','FontSize',fs)
grid on

subplot(2,1,2)
plot([SatData(cond_used).datetime],[SatData(cond_used).center_ze],'.-')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on
%%

[Year,Month,Day] = datevec([SatData.datetime]);

first_day = datetime(SatData(1).datetime.Year,SatData(1).datetime.Month,SatData(1).datetime.Day);
last_day = datetime(SatData(end).datetime.Year,SatData(end).datetime.Month,SatData(end).datetime.Day);

date_idx = first_day:last_day;
for idx=1:size(date_idx,2)

cond_1t = date_idx(idx).Year==Year...
      & date_idx.Month(idx)==Month...
      & date_idx.Day(idx)==Day;
aux(idx) = sum(cond_1t);
end
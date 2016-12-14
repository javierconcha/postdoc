% Script to find Landsat 8 matchups for Rrs based on in situ data from
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')
addpath('/Users/jconchas/Documents/MATLAB')
%% Load GOCI data
% clear GOCI_Data
% tic
% fileID = fopen('./GOCI_TemporalAnly/GOCI_ROI_STATS/file_list.txt');
% s = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);
% 
% for idx0=1:size(s{1},1)
%       
%       filepath = ['./GOCI_TemporalAnly/GOCI_ROI_STATS/' s{1}{idx0}];
%       GOCI_Data(idx0) = loadsatcell_tempanly(filepath);
%       
% end
% 
% save('GOCI_TempAnly.mat','GOCI_Data','-append')
% toc
% %% Load Aqua data
% clear AQUA_Data
% tic
% fileID = fopen('./GOCI_TemporalAnly/AQUA_ROI_STATS/file_list.txt');
% s = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);
% 
% for idx0=1:size(s{1},1)
%       
%       filepath = ['./GOCI_TemporalAnly/AQUA_ROI_STATS/' s{1}{idx0}];
%       AQUA_Data(idx0) = loadsatcell_tempanly(filepath);
%       
% end
% 
% save('GOCI_TempAnly.mat','AQUA_Data','-append')
% toc
% %% Load VIIRS data
% clear VIIRS_Data
% tic
% fileID = fopen('./GOCI_TemporalAnly/VIIRS_ROI_STATS/file_list.txt');
% s = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);
% 
% for idx0=1:size(s{1},1)
%       
%       filepath = ['./GOCI_TemporalAnly/VIIRS_ROI_STATS/' s{1}{idx0}];
%       VIIRS_Data(idx0) = loadsatcell_tempanly(filepath);
%       
% end
% 
% save('GOCI_TempAnly.mat','VIIRS_Data','-append')
% toc
%%
load('GOCI_TempAnly.mat','GOCI_Data')

fs = 24;
h1 =  figure('Color','white','DefaultAxesFontSize',fs);

total_px_GOCI = GOCI_Data(1).pixel_count; % FOR THIS ROI!!!
ratio_from_the_total = 2; % 2 3 4 % half or third or fourth of the total of pixels
zenith_lim = 75;
xrange = 0.02;
startDate = datenum('01-01-2011');
endDate = datenum('01-01-2017');
xData = startDate:datenum(years(1)):endDate;

% Rrs_412
cond1 = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
cond2 = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data(cond_used).Rrs_412_filtered_mean];


figure(h1)
subplot(6,1,1)
plot([GOCI_Data(cond_used).datetime],data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(412)','FontSize',fs)
grid on

N = sum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(412) (sr^{-1})','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

% Rrs_443
cond1 = ~isnan([GOCI_Data.Rrs_443_filtered_mean]);
cond2 = [GOCI_Data.Rrs_443_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data(cond_used).Rrs_443_filtered_mean];

figure(h1)
subplot(6,1,2)
plot([GOCI_Data(cond_used).datetime],data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(443)','FontSize',fs)
grid on

N = sum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(443) (sr^{-1})','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

% Rrs_490
cond1 = ~isnan([GOCI_Data.Rrs_490_filtered_mean]);
cond2 = [GOCI_Data.Rrs_490_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data(cond_used).Rrs_490_filtered_mean];

figure(h1)
subplot(6,1,3)
plot([GOCI_Data(cond_used).datetime],data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(490)','FontSize',fs)
grid on

N = sum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(490) (sr^{-1})','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

% Rrs_555
cond1 = ~isnan([GOCI_Data.Rrs_555_filtered_mean]);
cond2 = [GOCI_Data.Rrs_555_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data(cond_used).Rrs_555_filtered_mean];

figure(h1)
subplot(6,1,4)
plot([GOCI_Data(cond_used).datetime],data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(555)','FontSize',fs)
grid on

N = sum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(555) (sr^{-1})','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

% Rrs_660
cond1 = ~isnan([GOCI_Data.Rrs_660_filtered_mean]);
cond2 = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data(cond_used).Rrs_660_filtered_mean];

figure(h1)
subplot(6,1,5)
plot([GOCI_Data(cond_used).datetime],data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(660)','FontSize',fs)
grid on

N = sum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(660) (sr^{-1})','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

% Rrs_680
cond1 = ~isnan([GOCI_Data.Rrs_680_filtered_mean]);
cond2 = [GOCI_Data.Rrs_680_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data(cond_used).Rrs_680_filtered_mean];


figure(h1)
subplot(6,1,6)
plot([GOCI_Data(cond_used).datetime],data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')%
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(680)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on

N = sum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(680) (sr^{-1})','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

%% Plot vs time for GOCI

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);

wl = '680'; % 412 443 490 555 660 680
eval(sprintf('cond1 = ~isnan([GOCI_Data.Rrs_%s_filtered_mean]);',wl));
eval(sprintf('cond2 = [GOCI_Data.Rrs_%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',wl));
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1 & cond2 & cond3;

eval(sprintf('data_used_y = [GOCI_Data(cond_used).Rrs_%s_filtered_mean];',wl));
data_used_x = [GOCI_Data(cond_used).datetime];

fs = 25;
h1 = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
hold on
plot(data_used_x,data_used_y,'.','MarkerSize',12)
eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl));
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')%
% set(gca,'XTickLabel',{' '})
grid on

subplot(2,1,2)
hold on
plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')%
% set(gca,'XTickLabel',{' '})
grid on
%% show high solar zenith angle and no valid data
subplot(2,1,1)
hold on
plot([GOCI_Data(~cond2).datetime],[GOCI_Data(~cond2).Rrs_412_filtered_mean],'.r','MarkerSize',12)
subplot(2,1,1)
hold on
plot([GOCI_Data(~cond3).datetime],[GOCI_Data(~cond3).Rrs_412_filtered_mean],'.g','MarkerSize',12)

subplot(2,1,2)
hold on
plot([GOCI_Data(~cond2).datetime],[GOCI_Data(~cond2).center_ze],'.r','MarkerSize',12)
subplot(2,1,2)
hold on
plot([GOCI_Data(~cond3).datetime],[GOCI_Data(~cond3).center_ze],'.g','MarkerSize',12)
%% Chlr_a

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);
cond1 = ~isnan([GOCI_Data.chlor_a_filtered_mean]);
cond2 = [GOCI_Data.chlor_a_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

fs = 25;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).chlor_a_filtered_mean],'.','MarkerSize',20)
ylabel('Chlor\_a','FontSize',fs)
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')%
% set(gca,'XTickLabel',{' '})
grid on

subplot(2,1,2)
plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')%
% set(gca,'XTickLabel',{' '})
grid on


N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist([GOCI_Data(cond_used).chlor_a_filtered_mean],50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('Chlor\_a','FontSize',fs)
grid on

%% mean rrs vs zenith
% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);

fs = 25;
ms = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);

% Rrs 412
cond1 = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
cond2 = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

subplot(2,3,1)
plot([GOCI_Data(cond_used).Rrs_412_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(412)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 443
cond1 = ~isnan([GOCI_Data.Rrs_443_filtered_mean]);
cond2 = [GOCI_Data.Rrs_443_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,2)
plot([GOCI_Data(cond_used).Rrs_443_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(443)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 490
cond1 = ~isnan([GOCI_Data.Rrs_490_filtered_mean]);
cond2 = [GOCI_Data.Rrs_490_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,3)
plot([GOCI_Data(cond_used).Rrs_490_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(490)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 555
cond1 = ~isnan([GOCI_Data.Rrs_555_filtered_mean]);
cond2 = [GOCI_Data.Rrs_555_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,4)
plot([GOCI_Data(cond_used).Rrs_555_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(555)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 660
cond1 = ~isnan([GOCI_Data.Rrs_660_filtered_mean]);
cond2 = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,5)
plot([GOCI_Data(cond_used).Rrs_660_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(660)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 680
cond1 = ~isnan([GOCI_Data.Rrs_680_filtered_mean]);
cond2 = [GOCI_Data.Rrs_680_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,6)
plot([GOCI_Data(cond_used).Rrs_680_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(680)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on


%% chl vs zenith

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);


cond1 = ~isnan([GOCI_Data.chlor_a_filtered_mean]);
cond2 = [GOCI_Data.chlor_a_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([GOCI_Data(cond_used).chlor_a_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('Chlor-\it{a}','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on


%% Capture time analysis
D= datevec([GOCI_Data.datetime]);
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_Data.datetime],datetime(2016,1,1,D(:,4),D(:,5),D(:,6)),'.')
ylabel('Hour of the day (GMT)','FontSize',fs)
datetick('y','hh:MM')%
grid on

subplot(2,1,2)
plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on
%% Daily statistics for GOCI

% cond2 = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% cond3 = [GOCI_Data.center_ze] <= 65;
% cond_used = cond3 & cond2;
clear GOCI_DailyStatMatrix
clear cond_1t

[Year,Month,Day] = datevec([GOCI_Data.datetime]);

first_day = datetime(GOCI_Data(1).datetime.Year,GOCI_Data(1).datetime.Month,GOCI_Data(1).datetime.Day);
last_day = datetime(GOCI_Data(end).datetime.Year,GOCI_Data(end).datetime.Month,GOCI_Data(end).datetime.Day);

date_idx = first_day:last_day;
count_neg_cases = 0;

for idx=1:size(date_idx,2)
      % identify all the images for a specific day
      cond_1t = date_idx(idx).Year==Year...
            & date_idx.Month(idx)==Month...
            & date_idx.Day(idx)==Day;
      
      %       %% to see how many images per day
      %       if sum(cond_1t)> 8 % or sum(cond_1t)~=8
      %             disp([num2str(sum(cond_1t)) ' ' datestr(date_idx(idx))])
      %       end
      
      GOCI_DailyStatMatrix(idx).datetime =  date_idx(idx);
      GOCI_DailyStatMatrix(idx).images_per_day = sum(cond_1t);
      
      % check if there are more than one image per hour. It does not check
      % if the values are valid or not, but there are only a bunch of cases
      time_aux = [GOCI_Data(cond_1t).datetime];
      [~,IA,~] = unique([time_aux.Hour]);
      cond_aux = zeros(size(time_aux));
      cond_aux(IA) = 1;
      cond_1t(cond_1t) = cond_aux;
      clear time_aux IA cond_aux
      %% Rrs 412
      
      data_used = [GOCI_Data(cond_1t).Rrs_412_filtered_mean];
      valid_px_count_used = [GOCI_Data(cond_1t).Rrs_412_filtered_valid_pixel_count];
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean = nanmean(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_412_stdv_mean = nanstd(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_412_N_mean = sum(cond_used);
      GOCI_DailyStatMatrix(idx).Rrs_412_max_mean = nanmax(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_412_min_mean = nanmin(data_used(cond_used));
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_412_RMSE_mean = RMSE;
      
      time_used = [GOCI_Data(cond_1t).datetime];
      
      data_used_filtered = data_used(cond_used);
      time_used_filtered = time_used(cond_used);
      
      % initialization
      GOCI_DailyStatMatrix(idx).Rrs_412_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_07 = nan;
      
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  GOCI_DailyStatMatrix(idx).Rrs_412_00 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_00 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  GOCI_DailyStatMatrix(idx).Rrs_412_01 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_01 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  GOCI_DailyStatMatrix(idx).Rrs_412_02 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_02 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  GOCI_DailyStatMatrix(idx).Rrs_412_03 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_03 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 4
                  GOCI_DailyStatMatrix(idx).Rrs_412_04 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_04 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 5
                  GOCI_DailyStatMatrix(idx).Rrs_412_05 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_05 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 6
                  GOCI_DailyStatMatrix(idx).Rrs_412_06 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_06 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  GOCI_DailyStatMatrix(idx).Rrs_412_07 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_07 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_412_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
      end
      
      GOCI_DailyStatMatrix(idx).Rrs_412_mean_first_six = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_412_00,GOCI_DailyStatMatrix(idx).Rrs_412_01,GOCI_DailyStatMatrix(idx).Rrs_412_02,...
      GOCI_DailyStatMatrix(idx).Rrs_412_03,GOCI_DailyStatMatrix(idx).Rrs_412_04,GOCI_DailyStatMatrix(idx).Rrs_412_05]);

      GOCI_DailyStatMatrix(idx).Rrs_412_mean_mid_three = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_412_02,GOCI_DailyStatMatrix(idx).Rrs_412_03,GOCI_DailyStatMatrix(idx).Rrs_412_04]);

      %% Rrs 443
      
      data_used = [GOCI_Data(cond_1t).Rrs_443_filtered_mean];
      valid_px_count_used = [GOCI_Data(cond_1t).Rrs_443_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean = nanmean(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_443_stdv_mean = nanstd(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_443_N_mean = sum(cond_used);
      GOCI_DailyStatMatrix(idx).Rrs_443_max_mean = nanmax(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_443_min_mean = nanmin(data_used(cond_used));
      
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_443_RMSE_mean = RMSE;
      
      time_used = [GOCI_Data(cond_1t).datetime];
      
      data_used_filtered = data_used(cond_used);
      time_used_filtered = time_used(cond_used);
      
      % initialization
      GOCI_DailyStatMatrix(idx).Rrs_443_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_07 = nan;
      
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  GOCI_DailyStatMatrix(idx).Rrs_443_00 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_00 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  GOCI_DailyStatMatrix(idx).Rrs_443_01 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_01 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  GOCI_DailyStatMatrix(idx).Rrs_443_02 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_02 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  GOCI_DailyStatMatrix(idx).Rrs_443_03 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_03 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 4
                  GOCI_DailyStatMatrix(idx).Rrs_443_04 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_04 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 5
                  GOCI_DailyStatMatrix(idx).Rrs_443_05 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_05 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 6
                  GOCI_DailyStatMatrix(idx).Rrs_443_06 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_06 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  GOCI_DailyStatMatrix(idx).Rrs_443_07 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_daily_mean_07 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_443_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_443_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
      end

      GOCI_DailyStatMatrix(idx).Rrs_443_mean_first_six = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_443_00,GOCI_DailyStatMatrix(idx).Rrs_443_01,GOCI_DailyStatMatrix(idx).Rrs_443_02,...
      GOCI_DailyStatMatrix(idx).Rrs_443_03,GOCI_DailyStatMatrix(idx).Rrs_443_04,GOCI_DailyStatMatrix(idx).Rrs_443_05]);

      GOCI_DailyStatMatrix(idx).Rrs_443_mean_mid_three = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_443_02,GOCI_DailyStatMatrix(idx).Rrs_443_03,GOCI_DailyStatMatrix(idx).Rrs_443_04]);

      %% Rrs 490
      
      data_used = [GOCI_Data(cond_1t).Rrs_490_filtered_mean];
      valid_px_count_used = [GOCI_Data(cond_1t).Rrs_490_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean = nanmean(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_490_stdv_mean = nanstd(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_490_N_mean = sum(cond_used);
      GOCI_DailyStatMatrix(idx).Rrs_490_max_mean = nanmax(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_490_min_mean = nanmin(data_used(cond_used));
      
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_490_RMSE_mean = RMSE;
      
      time_used = [GOCI_Data(cond_1t).datetime];
      
      data_used_filtered = data_used(cond_used);
      time_used_filtered = time_used(cond_used);
      
      % initialization
      GOCI_DailyStatMatrix(idx).Rrs_490_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_07 = nan;
      
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  GOCI_DailyStatMatrix(idx).Rrs_490_00 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_00 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  GOCI_DailyStatMatrix(idx).Rrs_490_01 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_01 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  GOCI_DailyStatMatrix(idx).Rrs_490_02 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_02 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  GOCI_DailyStatMatrix(idx).Rrs_490_03 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_03 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 4
                  GOCI_DailyStatMatrix(idx).Rrs_490_04 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_04 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 5
                  GOCI_DailyStatMatrix(idx).Rrs_490_05 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_05 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 6
                  GOCI_DailyStatMatrix(idx).Rrs_490_06 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_06 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  GOCI_DailyStatMatrix(idx).Rrs_490_07 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_daily_mean_07 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_490_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_490_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
      end

      GOCI_DailyStatMatrix(idx).Rrs_490_mean_first_six = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_490_00,GOCI_DailyStatMatrix(idx).Rrs_490_01,GOCI_DailyStatMatrix(idx).Rrs_490_02,...
      GOCI_DailyStatMatrix(idx).Rrs_490_03,GOCI_DailyStatMatrix(idx).Rrs_490_04,GOCI_DailyStatMatrix(idx).Rrs_490_05]);

      GOCI_DailyStatMatrix(idx).Rrs_490_mean_mid_three = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_490_02,GOCI_DailyStatMatrix(idx).Rrs_490_03,GOCI_DailyStatMatrix(idx).Rrs_490_04]);

      %% Rrs 555
      
      data_used = [GOCI_Data(cond_1t).Rrs_555_filtered_mean];
      valid_px_count_used = [GOCI_Data(cond_1t).Rrs_555_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean = nanmean(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_555_stdv_mean = nanstd(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_555_N_mean = sum(cond_used);
      GOCI_DailyStatMatrix(idx).Rrs_555_max_mean = nanmax(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_555_min_mean = nanmin(data_used(cond_used));
      
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_555_RMSE_mean = RMSE;
      
      time_used = [GOCI_Data(cond_1t).datetime];
      
      data_used_filtered = data_used(cond_used);
      time_used_filtered = time_used(cond_used);
      
      % initialization
      GOCI_DailyStatMatrix(idx).Rrs_555_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_07 = nan;
      
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  GOCI_DailyStatMatrix(idx).Rrs_555_00 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_00 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  GOCI_DailyStatMatrix(idx).Rrs_555_01 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_01 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  GOCI_DailyStatMatrix(idx).Rrs_555_02 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_02 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  GOCI_DailyStatMatrix(idx).Rrs_555_03 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_03 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 4
                  GOCI_DailyStatMatrix(idx).Rrs_555_04 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_04 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 5
                  GOCI_DailyStatMatrix(idx).Rrs_555_05 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_05 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 6
                  GOCI_DailyStatMatrix(idx).Rrs_555_06 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_06 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  GOCI_DailyStatMatrix(idx).Rrs_555_07 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_daily_mean_07 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_555_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_555_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
      end

      GOCI_DailyStatMatrix(idx).Rrs_555_mean_first_six = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_555_00,GOCI_DailyStatMatrix(idx).Rrs_555_01,GOCI_DailyStatMatrix(idx).Rrs_555_02,...
      GOCI_DailyStatMatrix(idx).Rrs_555_03,GOCI_DailyStatMatrix(idx).Rrs_555_04,GOCI_DailyStatMatrix(idx).Rrs_555_05]);

      GOCI_DailyStatMatrix(idx).Rrs_555_mean_mid_three = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_555_02,GOCI_DailyStatMatrix(idx).Rrs_555_03,GOCI_DailyStatMatrix(idx).Rrs_555_04]);

      
      %% Rrs 660
      
      data_used = [GOCI_Data(cond_1t).Rrs_660_filtered_mean];
      valid_px_count_used = [GOCI_Data(cond_1t).Rrs_660_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean = nanmean(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_660_stdv_mean = nanstd(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_660_N_mean = sum(cond_used);
      GOCI_DailyStatMatrix(idx).Rrs_660_max_mean = nanmax(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_660_min_mean = nanmin(data_used(cond_used));
      
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_660_RMSE_mean = RMSE;
      
      time_used = [GOCI_Data(cond_1t).datetime];
      
      data_used_filtered = data_used(cond_used);
      time_used_filtered = time_used(cond_used);
      
      % initialization
      GOCI_DailyStatMatrix(idx).Rrs_660_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_07 = nan;
      
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  GOCI_DailyStatMatrix(idx).Rrs_660_00 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_00 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  GOCI_DailyStatMatrix(idx).Rrs_660_01 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_01 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  GOCI_DailyStatMatrix(idx).Rrs_660_02 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_02 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  GOCI_DailyStatMatrix(idx).Rrs_660_03 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_03 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 4
                  GOCI_DailyStatMatrix(idx).Rrs_660_04 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_04 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 5
                  GOCI_DailyStatMatrix(idx).Rrs_660_05 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_05 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 6
                  GOCI_DailyStatMatrix(idx).Rrs_660_06 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_06 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  GOCI_DailyStatMatrix(idx).Rrs_660_07 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_daily_mean_07 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_660_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_660_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
      end

      GOCI_DailyStatMatrix(idx).Rrs_660_mean_first_six = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_660_00,GOCI_DailyStatMatrix(idx).Rrs_660_01,GOCI_DailyStatMatrix(idx).Rrs_660_02,...
      GOCI_DailyStatMatrix(idx).Rrs_660_03,GOCI_DailyStatMatrix(idx).Rrs_660_04,GOCI_DailyStatMatrix(idx).Rrs_660_05]);

      GOCI_DailyStatMatrix(idx).Rrs_660_mean_mid_three = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_660_02,GOCI_DailyStatMatrix(idx).Rrs_660_03,GOCI_DailyStatMatrix(idx).Rrs_660_04]);

      
      %% Rrs 680
      
      data_used = [GOCI_Data(cond_1t).Rrs_680_filtered_mean];
      valid_px_count_used = [GOCI_Data(cond_1t).Rrs_680_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean = nanmean(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_680_stdv_mean = nanstd(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_680_N_mean = sum(cond_used);
      GOCI_DailyStatMatrix(idx).Rrs_680_max_mean = nanmax(data_used(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_680_min_mean = nanmin(data_used(cond_used));
      
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      GOCI_DailyStatMatrix(idx).Rrs_680_RMSE_mean = RMSE;
      
      time_used = [GOCI_Data(cond_1t).datetime];
      
      data_used_filtered = data_used(cond_used);
      time_used_filtered = time_used(cond_used);
      
      % initialization
      GOCI_DailyStatMatrix(idx).Rrs_680_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_07 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_00 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_01 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_02 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_03 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_04 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_05 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_06 = nan;
      GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_07 = nan;
      
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  GOCI_DailyStatMatrix(idx).Rrs_680_00 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_00 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  GOCI_DailyStatMatrix(idx).Rrs_680_01 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_01 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  GOCI_DailyStatMatrix(idx).Rrs_680_02 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_02 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  GOCI_DailyStatMatrix(idx).Rrs_680_03 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_03 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 4
                  GOCI_DailyStatMatrix(idx).Rrs_680_04 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_04 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 5
                  GOCI_DailyStatMatrix(idx).Rrs_680_05 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_05 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 6
                  GOCI_DailyStatMatrix(idx).Rrs_680_06 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_06 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  GOCI_DailyStatMatrix(idx).Rrs_680_07 = data_used_filtered(idx2);
                  GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_daily_mean_07 = ...
                        GOCI_DailyStatMatrix(idx).Rrs_680_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                        GOCI_DailyStatMatrix(idx).Rrs_680_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                  end
            end
      end
      
      GOCI_DailyStatMatrix(idx).Rrs_680_mean_first_six = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_680_00,GOCI_DailyStatMatrix(idx).Rrs_680_01,GOCI_DailyStatMatrix(idx).Rrs_680_02,...
      GOCI_DailyStatMatrix(idx).Rrs_680_03,GOCI_DailyStatMatrix(idx).Rrs_680_04,GOCI_DailyStatMatrix(idx).Rrs_680_05]);

      GOCI_DailyStatMatrix(idx).Rrs_680_mean_mid_three = ...
      nanmean([GOCI_DailyStatMatrix(idx).Rrs_680_02,GOCI_DailyStatMatrix(idx).Rrs_680_03,GOCI_DailyStatMatrix(idx).Rrs_680_04]);

end

%% Daily statistics for AQUA

clear AQUA_DailyStatMatrix
clear cond_1t

[Year,Month,Day] = datevec([AQUA_Data.datetime]);

first_day = datetime(AQUA_Data(1).datetime.Year,AQUA_Data(1).datetime.Month,AQUA_Data(1).datetime.Day);
last_day = datetime(AQUA_Data(end).datetime.Year,AQUA_Data(end).datetime.Month,AQUA_Data(end).datetime.Day);

date_idx = first_day:last_day;
count_neg_cases = 0;

for idx=1:size(date_idx,2)
      % identify all the images for a specific day
      cond_1t = date_idx(idx).Year==Year...
            & date_idx.Month(idx)==Month...
            & date_idx.Day(idx)==Day;
      
      AQUA_DailyStatMatrix(idx).datetime =  date_idx(idx);
      AQUA_DailyStatMatrix(idx).images_per_day = sum(cond_1t);
      
      %% Rrs 412
      
      mean_temp = [AQUA_Data(cond_1t).Rrs_412_filtered_mean];
      valid_temp = [AQUA_Data(cond_1t).Rrs_412_filtered_valid_pixel_count];
      AQUA_DailyStatMatrix(idx).Rrs_412_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      AQUA_DailyStatMatrix(idx).Rrs_412_N_mean = sum(valid_temp);
      
      if sum(valid_temp) >= total_px_GOCI/4/ratio_from_the_total; % half of the equivalent GOCI are for AQUA
            AQUA_DailyStatMatrix(idx).Rrs_412_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            AQUA_DailyStatMatrix(idx).Rrs_412_filtered_mean = nan;
      end

      %% Rrs 443
      
      mean_temp = [AQUA_Data(cond_1t).Rrs_443_filtered_mean];
      valid_temp = [AQUA_Data(cond_1t).Rrs_443_filtered_valid_pixel_count];
      AQUA_DailyStatMatrix(idx).Rrs_443_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      AQUA_DailyStatMatrix(idx).Rrs_443_N_mean = sum(valid_temp);
      
      if sum(valid_temp) >= total_px_GOCI/4/ratio_from_the_total; % half of the equivalent GOCI are for AQUA
            AQUA_DailyStatMatrix(idx).Rrs_443_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            AQUA_DailyStatMatrix(idx).Rrs_443_filtered_mean = nan;
      end

      %% Rrs 488
      
      mean_temp = [AQUA_Data(cond_1t).Rrs_488_filtered_mean];
      valid_temp = [AQUA_Data(cond_1t).Rrs_488_filtered_valid_pixel_count];
      AQUA_DailyStatMatrix(idx).Rrs_488_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      AQUA_DailyStatMatrix(idx).Rrs_488_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/4/ratio_from_the_total; % half of the equivalent GOCI are for AQUA
            AQUA_DailyStatMatrix(idx).Rrs_488_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            AQUA_DailyStatMatrix(idx).Rrs_488_filtered_mean = nan;
      end

      %% Rrs 555
      
      mean_temp = [AQUA_Data(cond_1t).Rrs_555_filtered_mean];
      valid_temp = [AQUA_Data(cond_1t).Rrs_555_filtered_valid_pixel_count];
      AQUA_DailyStatMatrix(idx).Rrs_555_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      AQUA_DailyStatMatrix(idx).Rrs_555_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/4/ratio_from_the_total; % half of the equivalent GOCI are for AQUA
            AQUA_DailyStatMatrix(idx).Rrs_555_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            AQUA_DailyStatMatrix(idx).Rrs_555_filtered_mean = nan;
      end      

      %% Rrs 667
      
      mean_temp = [AQUA_Data(cond_1t).Rrs_667_filtered_mean];
      valid_temp = [AQUA_Data(cond_1t).Rrs_667_filtered_valid_pixel_count];
      AQUA_DailyStatMatrix(idx).Rrs_667_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      AQUA_DailyStatMatrix(idx).Rrs_667_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/4/ratio_from_the_total; % half of the equivalent GOCI are for AQUA
            AQUA_DailyStatMatrix(idx).Rrs_667_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            AQUA_DailyStatMatrix(idx).Rrs_667_filtered_mean = nan;
      end      

      %% Rrs 678
      
      mean_temp = [AQUA_Data(cond_1t).Rrs_678_filtered_mean];
      valid_temp = [AQUA_Data(cond_1t).Rrs_678_filtered_valid_pixel_count];
      AQUA_DailyStatMatrix(idx).Rrs_678_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      AQUA_DailyStatMatrix(idx).Rrs_678_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/4/ratio_from_the_total; % half of the equivalent GOCI are for AQUA
            AQUA_DailyStatMatrix(idx).Rrs_678_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            AQUA_DailyStatMatrix(idx).Rrs_678_filtered_mean = nan;
      end     

end

%% Daily statistics for VIIRS

clear VIIRS_DailyStatMatrix
clear cond_1t

[Year,Month,Day] = datevec([VIIRS_Data.datetime]);

first_day = datetime(VIIRS_Data(1).datetime.Year,VIIRS_Data(1).datetime.Month,VIIRS_Data(1).datetime.Day);
last_day = datetime(VIIRS_Data(end).datetime.Year,VIIRS_Data(end).datetime.Month,VIIRS_Data(end).datetime.Day);

date_idx = first_day:last_day;
count_neg_cases = 0;

for idx=1:size(date_idx,2)
      % identify all the images for a specific day
      cond_1t = date_idx(idx).Year==Year...
            & date_idx.Month(idx)==Month...
            & date_idx.Day(idx)==Day;
      
      VIIRS_DailyStatMatrix(idx).datetime =  date_idx(idx);
      VIIRS_DailyStatMatrix(idx).images_per_day = sum(cond_1t);
      
      %% Rrs 410
      
      mean_temp = [VIIRS_Data(cond_1t).Rrs_410_filtered_mean];
      valid_temp = [VIIRS_Data(cond_1t).Rrs_410_filtered_valid_pixel_count];
      VIIRS_DailyStatMatrix(idx).Rrs_410_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      VIIRS_DailyStatMatrix(idx).Rrs_410_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/2.25/ratio_from_the_total; % half of the equivalent GOCI are for VIIRS
            VIIRS_DailyStatMatrix(idx).Rrs_410_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            VIIRS_DailyStatMatrix(idx).Rrs_410_filtered_mean = nan;
      end      

      %% Rrs 443
      
      mean_temp = [VIIRS_Data(cond_1t).Rrs_443_filtered_mean];
      valid_temp = [VIIRS_Data(cond_1t).Rrs_443_filtered_valid_pixel_count];
      VIIRS_DailyStatMatrix(idx).Rrs_443_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      VIIRS_DailyStatMatrix(idx).Rrs_443_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/2.25/ratio_from_the_total; % half of the equivalent GOCI are for VIIRS
            VIIRS_DailyStatMatrix(idx).Rrs_443_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            VIIRS_DailyStatMatrix(idx).Rrs_443_filtered_mean = nan;
      end    

      %% Rrs 486
      
      mean_temp = [VIIRS_Data(cond_1t).Rrs_486_filtered_mean];
      valid_temp = [VIIRS_Data(cond_1t).Rrs_486_filtered_valid_pixel_count];
      VIIRS_DailyStatMatrix(idx).Rrs_486_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      VIIRS_DailyStatMatrix(idx).Rrs_486_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/2.25/ratio_from_the_total; % half of the equivalent GOCI are for VIIRS
            VIIRS_DailyStatMatrix(idx).Rrs_486_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            VIIRS_DailyStatMatrix(idx).Rrs_486_filtered_mean = nan;
      end    

      %% Rrs 551
      
      mean_temp = [VIIRS_Data(cond_1t).Rrs_551_filtered_mean];
      valid_temp = [VIIRS_Data(cond_1t).Rrs_551_filtered_valid_pixel_count];
      VIIRS_DailyStatMatrix(idx).Rrs_551_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      VIIRS_DailyStatMatrix(idx).Rrs_551_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/2.25/ratio_from_the_total; % half of the equivalent GOCI are for VIIRS
            VIIRS_DailyStatMatrix(idx).Rrs_551_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            VIIRS_DailyStatMatrix(idx).Rrs_551_filtered_mean = nan;
      end    

      %% Rrs 671
      
      mean_temp = [VIIRS_Data(cond_1t).Rrs_671_filtered_mean];
      valid_temp = [VIIRS_Data(cond_1t).Rrs_671_filtered_valid_pixel_count];
      VIIRS_DailyStatMatrix(idx).Rrs_671_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      VIIRS_DailyStatMatrix(idx).Rrs_671_N_mean = sum(valid_temp);

      if sum(valid_temp) >= total_px_GOCI/2.25/ratio_from_the_total; % half of the equivalent GOCI are for VIIRS
            VIIRS_DailyStatMatrix(idx).Rrs_671_filtered_mean = sum(mean_temp.*valid_temp)./sum(valid_temp);
      else
            VIIRS_DailyStatMatrix(idx).Rrs_671_filtered_mean = nan;
      end    

end

save('GOCI_TempAnly.mat','AQUA_DailyStatMatrix','VIIRS_DailyStatMatrix','-append')
%% Plot error with respect to the noon value vs time
fs = 25;
ms = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_00],'.','MarkerSize',ms)
ylabel('1st')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_01],'.','MarkerSize',ms)
ylabel('2nd')
ax = gca;
ax.XTick = xData; 
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_02],'.','MarkerSize',ms)
ylabel('3rd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_03],'.','MarkerSize',ms)
ylabel('4th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_04],'.','MarkerSize',ms)
ylabel('5th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_05],'.','MarkerSize',ms)
ylabel('6th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_06],'.','MarkerSize',ms)
ylabel('7th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_noon_07],'.','MarkerSize',ms)
ylabel('8th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

%% Plot error with respect to the daily mean value vs time
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_00],'.','MarkerSize',ms)
ylabel('1st')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_01],'.','MarkerSize',ms)
ylabel('2nd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_02],'.','MarkerSize',ms)
ylabel('3rd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_03],'.','MarkerSize',ms)
ylabel('4th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_04],'.','MarkerSize',ms)
ylabel('5th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_05],'.','MarkerSize',ms)
ylabel('6th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_06],'.','MarkerSize',ms)
ylabel('7th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_error_w_r_daily_mean_07],'.','MarkerSize',ms)
ylabel('8th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

%% Plot RMSE (error from the daily mean)

wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('sq_error_00 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_00].^2;',wl{idx}))
      RMSE_00 = sqrt(nanmean(sq_error_00));
      eval(sprintf('stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_00]);',wl{idx}))
      
      eval(sprintf('sq_error_01 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_01].^2;',wl{idx}))
      RMSE_01 = sqrt(nanmean(sq_error_01));
      eval(sprintf('stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_01]);',wl{idx}))
      
      eval(sprintf('sq_error_02 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_02].^2;',wl{idx}))
      RMSE_02 = sqrt(nanmean(sq_error_02));
      eval(sprintf('stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_02]);',wl{idx}))
      
      eval(sprintf('sq_error_03 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_03].^2;',wl{idx}))
      RMSE_03 = sqrt(nanmean(sq_error_03));
      eval(sprintf('stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_03]);',wl{idx}))
      
      eval(sprintf('sq_error_04 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_04].^2;',wl{idx}))
      RMSE_04 = sqrt(nanmean(sq_error_04));
      eval(sprintf('stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_04]);',wl{idx}))
      
      eval(sprintf('sq_error_05 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_05].^2;',wl{idx}))
      RMSE_05 = sqrt(nanmean(sq_error_05));
      eval(sprintf('stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_05]);',wl{idx}))
      
      eval(sprintf('sq_error_06 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_06].^2;',wl{idx}))
      RMSE_06 = sqrt(nanmean(sq_error_06));
      eval(sprintf('stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_06]);',wl{idx}))
      
      eval(sprintf('sq_error_07 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_07].^2;',wl{idx}))
      RMSE_07 = sqrt(nanmean(sq_error_07));
      eval(sprintf('stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_daily_mean_07]);',wl{idx}))
      
      stdv_all = [stdv_00,stdv_01,stdv_02,stdv_03,stdv_04,stdv_05,stdv_06,stdv_07];
      
      RMSE_all = [RMSE_00,RMSE_01,RMSE_02,RMSE_03,RMSE_04,RMSE_05,RMSE_06,RMSE_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,RMSE_all,stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      ylim([0 4e-3])
      
      str1 = sprintf('RMSE of the Diurnal Difference\n w/r to the daily mean\n for Rrs(%s) (1/sr)',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end      
%% Plot RMSE (error from the noon value)
for idx = 1:size(wl,2)      
      eval(sprintf('sq_error_00 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_00].^2;',wl{idx}))
      RMSE_00 = sqrt(nanmean(sq_error_00));
      eval(sprintf('stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_00]);',wl{idx}))
      
      eval(sprintf('sq_error_01 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_01].^2;',wl{idx}))
      RMSE_01 = sqrt(nanmean(sq_error_01));
      eval(sprintf('stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_01]);',wl{idx}))
      
      eval(sprintf('sq_error_02 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_02].^2;',wl{idx}))
      RMSE_02 = sqrt(nanmean(sq_error_02));
      eval(sprintf('stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_02]);',wl{idx}))
      
      eval(sprintf('sq_error_03 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_03].^2;',wl{idx}))
      RMSE_03 = sqrt(nanmean(sq_error_03));
      eval(sprintf('stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_03]);',wl{idx}))
      
      eval(sprintf('sq_error_04 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_04].^2;',wl{idx}))
      RMSE_04 = sqrt(nanmean(sq_error_04));
      eval(sprintf('stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_04]);',wl{idx}))
      
      eval(sprintf('sq_error_05 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_05].^2;',wl{idx}))
      RMSE_05 = sqrt(nanmean(sq_error_05));
      eval(sprintf('stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_05]);',wl{idx}))
      
      eval(sprintf('sq_error_06 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_06].^2;',wl{idx}))
      RMSE_06 = sqrt(nanmean(sq_error_06));
      eval(sprintf('stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_06]);',wl{idx}))
      
      eval(sprintf('sq_error_07 = [GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_07].^2;',wl{idx}))
      RMSE_07 = sqrt(nanmean(sq_error_07));
      eval(sprintf('stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_error_w_r_noon_07]);',wl{idx}))
      
      stdv_all = [stdv_00,stdv_01,stdv_02,stdv_03,stdv_04,stdv_05,stdv_06,stdv_07];
      
      RMSE_all = [RMSE_00,RMSE_01,RMSE_02,RMSE_03,RMSE_04,RMSE_05,RMSE_06,RMSE_07];
      
      % fs = 20;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,RMSE_all,stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      % ylim([-1e-3 5e-3])
      str2 = sprintf('Rrs(%s), RMSE (error from the noon)',wl{idx});
      ylabel(str2,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end
%% Plot global stats
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
hist([GOCI_DailyStatMatrix.Rrs_412_stdv_mean])
xlabel('R_{rs}(412): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,2)
hist([GOCI_DailyStatMatrix.Rrs_443_stdv_mean])
xlabel('R_{rs}(443): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,3)
hist([GOCI_DailyStatMatrix.Rrs_490_stdv_mean])
xlabel('R_{rs}(490): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,4)
hist([GOCI_DailyStatMatrix.Rrs_555_stdv_mean])
xlabel('R_{rs}(555): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,5)
hist([GOCI_DailyStatMatrix.Rrs_660_stdv_mean])
xlabel('R_{rs}(660): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,6)
hist([GOCI_DailyStatMatrix.Rrs_680_stdv_mean])
xlabel('R_{rs}(680): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
hist([GOCI_DailyStatMatrix.Rrs_412_RMSE_mean])
xlabel('R_{rs}(412): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,2)
hist([GOCI_DailyStatMatrix.Rrs_443_RMSE_mean])
xlabel('R_{rs}(443): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,3)
hist([GOCI_DailyStatMatrix.Rrs_490_RMSE_mean])
xlabel('R_{rs}(490): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,4)
hist([GOCI_DailyStatMatrix.Rrs_555_RMSE_mean])
xlabel('R_{rs}(555): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,5)
hist([GOCI_DailyStatMatrix.Rrs_660_RMSE_mean])
xlabel('R_{rs}(660): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,6)
hist([GOCI_DailyStatMatrix.Rrs_680_RMSE_mean])
xlabel('R_{rs}(680): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
hist([GOCI_DailyStatMatrix.Rrs_412_mean_mean])
xlabel('R_{rs}(412): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,2)
hist([GOCI_DailyStatMatrix.Rrs_443_mean_mean])
xlabel('R_{rs}(443): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,3)
hist([GOCI_DailyStatMatrix.Rrs_490_mean_mean])
xlabel('R_{rs}(490): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,4)
hist([GOCI_DailyStatMatrix.Rrs_555_mean_mean])
xlabel('R_{rs}(555): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,5)
hist([GOCI_DailyStatMatrix.Rrs_660_mean_mean])
xlabel('R_{rs}(660): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,6)
hist([GOCI_DailyStatMatrix.Rrs_680_mean_mean])
xlabel('R_{rs}(680): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

nanmean([GOCI_DailyStatMatrix.Rrs_412_stdv_mean])
nanmean([GOCI_DailyStatMatrix.Rrs_443_stdv_mean])
nanmean([GOCI_DailyStatMatrix.Rrs_490_stdv_mean])
nanmean([GOCI_DailyStatMatrix.Rrs_555_stdv_mean])
nanmean([GOCI_DailyStatMatrix.Rrs_660_stdv_mean])
nanmean([GOCI_DailyStatMatrix.Rrs_680_stdv_mean])


%% Time Series for Rrs for GOCI, Aqua and VIIRS
wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      eval(sprintf('cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_%s_mean_mid_three]);',wl{idx})); % ONLY FOR THE MIDDLE THREE IMAGES!!!
      cond_used = cond1;
      
      eval(sprintf('data_used_y = [GOCI_DailyStatMatrix(cond_used).Rrs_%s_mean_mid_three];',wl{idx}));
      data_used_x = [GOCI_DailyStatMatrix(cond_used).datetime];
      
      fs = 25;
      h1 = figure('Color','white','DefaultAxesFontSize',fs);
      plot(data_used_x,data_used_y,'.-','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
%       ax = gca;
%       ax.XTick = xData;
%       datetick('x','yyyy')
%       grid on
      
      %% Plot vs time for Aqua
      
      total_px_AQUA = [AQUA_Data.pixel_count];
      
      if strcmp(wl{idx},'412')
            wl_AQUA = '412';
      elseif strcmp(wl{idx},'443')
            wl_AQUA = '443';
      elseif strcmp(wl{idx},'490')
            wl_AQUA = '488';
      elseif strcmp(wl{idx},'555')
            wl_AQUA = '555';      
      elseif strcmp(wl{idx},'660')
            wl_AQUA = '667';
      elseif strcmp(wl{idx},'680')
            wl_AQUA = '678';        
      end      
      
      eval(sprintf('cond1 = ~isnan([AQUA_DailyStatMatrix.Rrs_%s_filtered_mean]);',wl_AQUA));
      % cond3 = [AQUA_Data.center_ze] <= zenith_lim;
      cond4 = [AQUA_DailyStatMatrix.datetime] >= nanmin([GOCI_Data.datetime]) &...
            [AQUA_DailyStatMatrix.datetime] <= nanmax([GOCI_Data.datetime]);
      cond_used = cond1 &cond4;
      
      eval(sprintf('data_used_y = [AQUA_DailyStatMatrix(cond_used).Rrs_%s_filtered_mean];',wl_AQUA));
      data_used_x = [AQUA_DailyStatMatrix(cond_used).datetime];
      
      fs = 25;
      figure(h1)
      hold on
      plot(data_used_x,data_used_y,'.-r','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
%       ax = gca;
%       ax.XTick = xData;
%       datetick('x','yyyy')
      grid on
      
      %% Plot vs time for VIIRS
      
      total_px_VIIRS = [VIIRS_Data.pixel_count];
      
      if strcmp(wl{idx},'412')
            wl_VIIRS = '410';
      elseif strcmp(wl{idx},'443')
            wl_VIIRS = '443';
      elseif strcmp(wl{idx},'490')
            wl_VIIRS = '486';
      elseif strcmp(wl{idx},'555')
            wl_VIIRS = '551';
      elseif strcmp(wl{idx},'660')
            wl_VIIRS = '671'; 
      elseif strcmp(wl{idx},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            wl_VIIRS = '671';        
      end
      
      eval(sprintf('cond1 = ~isnan([VIIRS_DailyStatMatrix.Rrs_%s_filtered_mean]);',wl_VIIRS));
      % cond3 = [VIIRS_Data.center_ze] <= zenith_lim;
      cond4 = [VIIRS_DailyStatMatrix.datetime] >= nanmin([GOCI_Data.datetime]) &...
            [VIIRS_DailyStatMatrix.datetime] <= nanmax([GOCI_Data.datetime]);
      cond_used = cond1 & cond4;
      
      eval(sprintf('data_used_y = [VIIRS_DailyStatMatrix(cond_used).Rrs_%s_filtered_mean];',wl_VIIRS));
      data_used_x = [VIIRS_DailyStatMatrix(cond_used).datetime];
      
      fs = 25;
      figure(h1)
      hold on
      plot(data_used_x,data_used_y,'.-k','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
%       ax = gca;
%       ax.XTick = xData;
%       datetick('x','yyyy')
      grid on
      %       end
      
      if strcmp(wl{idx},'412')
            legend('GOCI: 412 nm','MODISA: 412 nm','VIIRS: 410 nm')
      elseif strcmp(wl{idx},'443')
            legend('GOCI: 443 nm','MODISA: 443 nm','VIIRS: 443 nm')
      elseif strcmp(wl{idx},'490')
            legend('GOCI: 490 nm','MODISA: 488 nm','VIIRS: 486 nm')
      elseif strcmp(wl{idx},'555')
            legend('GOCI: 555 nm','MODISA: 555 nm','VIIRS: 551 nm')
      elseif strcmp(wl{idx},'660')
            legend('GOCI: 660 nm','MODISA: 667 nm','VIIRS: 671 nm') 
      elseif strcmp(wl{idx},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            legend('GOCI: 680 nm','MODISA: 678 nm','VIIRS: 671 nm')        
      end
      
      
end

%% Monthly statistics for GOCI
clear GOCI_MonthlyStatMatrix
[Year,Month,~] = datevec([GOCI_DailyStatMatrix.datetime]);

Year_min = min(Year);
Year_max = max(Year);

Year_idx = Year_min:Year_max;

count = 0;

for idx = 1:size(Year_idx,2)
      for idx2 = 1:12
            count = count+1;
            cond_1t = Year_idx(idx)==Year...
                  & idx2==Month;
            GOCI_MonthlyStatMatrix(count).Rrs_412_monthly_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_412_mean_first_six]);
            GOCI_MonthlyStatMatrix(count).Rrs_443_monthly_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_443_mean_first_six]);
            GOCI_MonthlyStatMatrix(count).Rrs_490_monthly_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_490_mean_first_six]);
            GOCI_MonthlyStatMatrix(count).Rrs_555_monthly_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_555_mean_first_six]);
            GOCI_MonthlyStatMatrix(count).Rrs_660_monthly_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_660_mean_first_six]);
            GOCI_MonthlyStatMatrix(count).Rrs_680_monthly_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_680_mean_first_six]);

            GOCI_MonthlyStatMatrix(count).Rrs_412_monthly_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_412_mean_mid_three]);
            GOCI_MonthlyStatMatrix(count).Rrs_443_monthly_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_443_mean_mid_three]);
            GOCI_MonthlyStatMatrix(count).Rrs_490_monthly_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_490_mean_mid_three]);
            GOCI_MonthlyStatMatrix(count).Rrs_555_monthly_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_555_mean_mid_three]);
            GOCI_MonthlyStatMatrix(count).Rrs_660_monthly_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_660_mean_mid_three]);
            GOCI_MonthlyStatMatrix(count).Rrs_680_monthly_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_680_mean_mid_three]);
            
            GOCI_MonthlyStatMatrix(count).Month = idx2;
            GOCI_MonthlyStatMatrix(count).Year  = Year_idx(idx);
            GOCI_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
      end
      
end

%% Monthly statistics for AQUA
clear AQUA_MonthlyStatMatrix
[Year,Month,~] = datevec([AQUA_DailyStatMatrix.datetime]);

Year_min = min(Year);
Year_max = max(Year);

Year_idx = Year_min:Year_max;

count = 0;

for idx = 1:size(Year_idx,2)
      for idx2 = 1:12
            count = count+1;
            cond_1t = Year_idx(idx)==Year...
                  & idx2==Month;
            AQUA_MonthlyStatMatrix(count).Rrs_412_filtered_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_412_filtered_mean]);
            AQUA_MonthlyStatMatrix(count).Rrs_443_filtered_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_443_filtered_mean]);
            AQUA_MonthlyStatMatrix(count).Rrs_488_filtered_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_488_filtered_mean]);
            AQUA_MonthlyStatMatrix(count).Rrs_555_filtered_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_555_filtered_mean]);
            AQUA_MonthlyStatMatrix(count).Rrs_667_filtered_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_667_filtered_mean]);
            AQUA_MonthlyStatMatrix(count).Rrs_678_filtered_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_678_filtered_mean]);
            
            AQUA_MonthlyStatMatrix(count).Month = idx2;
            AQUA_MonthlyStatMatrix(count).Year  = Year_idx(idx);
            AQUA_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
      end
      
end

%% Monthly statistics for VIIRS
clear VIIRS_MonthlyStatMatrix
[Year,Month,~] = datevec([VIIRS_DailyStatMatrix.datetime]);

Year_min = min(Year);
Year_max = max(Year);

Year_idx = Year_min:Year_max;

count = 0;

for idx = 1:size(Year_idx,2)
      for idx2 = 1:12
            count = count+1;
            cond_1t = Year_idx(idx)==Year...
                  & idx2==Month;
            VIIRS_MonthlyStatMatrix(count).Rrs_410_filtered_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_410_filtered_mean]);
            VIIRS_MonthlyStatMatrix(count).Rrs_443_filtered_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_443_filtered_mean]);
            VIIRS_MonthlyStatMatrix(count).Rrs_486_filtered_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_486_filtered_mean]);
            VIIRS_MonthlyStatMatrix(count).Rrs_551_filtered_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_551_filtered_mean]);
            VIIRS_MonthlyStatMatrix(count).Rrs_671_filtered_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_671_filtered_mean]);
            
            VIIRS_MonthlyStatMatrix(count).Month = idx2;
            VIIRS_MonthlyStatMatrix(count).Year  = Year_idx(idx);
            VIIRS_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
      end
      
end

%% PLot GOCI vs AQUA and VIIRS
wl = {'412','443','490','555','660','680'};
for idx0 = 1:size(wl,2)
%       h1 = figure('Color','white','DefaultAxesFontSize',fs);
%       eval(sprintf('plot([GOCI_MonthlyStatMatrix.datetime],[GOCI_MonthlyStatMatrix.Rrs_%s_monthly_mean_first_six]);',wl{idx0}))
%       eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
%       grid on

      h2 = figure('Color','white','DefaultAxesFontSize',fs);
      eval(sprintf('plot([GOCI_MonthlyStatMatrix.datetime],[GOCI_MonthlyStatMatrix.Rrs_%s_monthly_mean_mid_three]);',wl{idx0}))
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
      grid on

      %% Plot AQUA
      if strcmp(wl{idx0},'412')
            wl_AQUA = '412';
      elseif strcmp(wl{idx0},'443')
            wl_AQUA = '443';
      elseif strcmp(wl{idx0},'490')
            wl_AQUA = '488';
      elseif strcmp(wl{idx0},'555')
            wl_AQUA = '555';      
      elseif strcmp(wl{idx0},'660')
            wl_AQUA = '667';
      elseif strcmp(wl{idx0},'680')
            wl_AQUA = '678';        
      end      

      eval(sprintf('cond1 = ~isnan([AQUA_MonthlyStatMatrix.Rrs_%s_filtered_mean]);',wl_AQUA));
      cond_used = cond1;

      eval(sprintf('data_used_y = [AQUA_MonthlyStatMatrix(cond_used).Rrs_%s_filtered_mean];',wl_AQUA));
      data_used_x = [AQUA_MonthlyStatMatrix(cond_used).datetime];

      fs = 25;
%       figure(h1)
%       hold on
%       plot(data_used_x,data_used_y,'.-r','MarkerSize',12)
%       eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
%       grid on

      figure(h2)
      hold on
      plot(data_used_x,data_used_y,'.-r','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
      grid on

      %% Plot VIIRS
      if strcmp(wl{idx0},'412')
            wl_VIIRS = '410';
      elseif strcmp(wl{idx0},'443')
            wl_VIIRS = '443';
      elseif strcmp(wl{idx0},'490')
            wl_VIIRS = '486';
      elseif strcmp(wl{idx0},'555')
            wl_VIIRS = '551';
      elseif strcmp(wl{idx0},'660')
            wl_VIIRS = '671'; 
      elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            wl_VIIRS = '671';        
      end

      eval(sprintf('cond1 = ~isnan([VIIRS_MonthlyStatMatrix.Rrs_%s_filtered_mean]);',wl_VIIRS));
      cond_used = cond1;

      eval(sprintf('data_used_y = [VIIRS_MonthlyStatMatrix(cond_used).Rrs_%s_filtered_mean];',wl_VIIRS));
      data_used_x = [AQUA_MonthlyStatMatrix(cond_used).datetime];

      fs = 25;
%       figure(h1)
%       hold on
%       plot(data_used_x,data_used_y,'.-k','MarkerSize',12)
%       eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
%       grid on

      figure(h2)
      hold on
      plot(data_used_x,data_used_y,'.-k','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
      grid on
      
%       figure(h1)      
%       if strcmp(wl{idx0},'412')
%             legend('GOCI: 412 nm','MODISA: 412 nm','VIIRS: 410 nm')
%       elseif strcmp(wl{idx0},'443')
%             legend('GOCI: 443 nm','MODISA: 443 nm','VIIRS: 443 nm')
%       elseif strcmp(wl{idx0},'490')
%             legend('GOCI: 490 nm','MODISA: 488 nm','VIIRS: 486 nm')
%       elseif strcmp(wl{idx0},'555')
%             legend('GOCI: 555 nm','MODISA: 555 nm','VIIRS: 551 nm')
%       elseif strcmp(wl{idx0},'660')
%             legend('GOCI: 660 nm','MODISA: 667 nm','VIIRS: 671 nm') 
%       elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%             legend('GOCI: 680 nm','MODISA: 678 nm','VIIRS: 671 nm')        
%       end
      
      figure(h2)      
      if strcmp(wl{idx0},'412')
            legend('GOCI: 412 nm','MODISA: 412 nm','VIIRS: 410 nm')
      elseif strcmp(wl{idx0},'443')
            legend('GOCI: 443 nm','MODISA: 443 nm','VIIRS: 443 nm')
      elseif strcmp(wl{idx0},'490')
            legend('GOCI: 490 nm','MODISA: 488 nm','VIIRS: 486 nm')
      elseif strcmp(wl{idx0},'555')
            legend('GOCI: 555 nm','MODISA: 555 nm','VIIRS: 551 nm')
      elseif strcmp(wl{idx0},'660')
            legend('GOCI: 660 nm','MODISA: 667 nm','VIIRS: 671 nm') 
      elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            legend('GOCI: 680 nm','MODISA: 678 nm','VIIRS: 671 nm')        
      end
      

end

save('GOCI_TempAnly.mat','GOCI_MonthlyStatMatrix','AQUA_MonthlyStatMatrix','VIIRS_MonthlyStatMatrix','-append')
%% Scatter plots
savedirname = '/Users/jconchas/Documents/Research/GOCI/Figures/';

GOCI_date = [GOCI_DailyStatMatrix.datetime];
VIIRS_date = [VIIRS_DailyStatMatrix.datetime];
AQUA_date = [AQUA_DailyStatMatrix.datetime];

wl = {'412','443','490','555','660','680'};
for idx0 = 1:size(wl,2)
      %% For AQUA
      if strcmp(wl{idx0},'412')
            wl_AQUA = '412';
      elseif strcmp(wl{idx0},'443')
            wl_AQUA = '443';
      elseif strcmp(wl{idx0},'490')
            wl_AQUA = '488';
      elseif strcmp(wl{idx0},'555')
            wl_AQUA = '555';
      elseif strcmp(wl{idx0},'660')
            wl_AQUA = '667';
      elseif strcmp(wl{idx0},'680')
            wl_AQUA = '678';
      end
      
      %% For VIIRS
      if strcmp(wl{idx0},'412')
            wl_VIIRS = '410';
      elseif strcmp(wl{idx0},'443')
            wl_VIIRS = '443';
      elseif strcmp(wl{idx0},'490')
            wl_VIIRS = '486';
      elseif strcmp(wl{idx0},'555')
            wl_VIIRS = '551';
      elseif strcmp(wl{idx0},'660')
            wl_VIIRS = '671';
      elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            wl_VIIRS = '671';
      end
      
      
      %% GOCI Comparison with VIIRS
      % lower boundary
      a = find(VIIRS_date == GOCI_date(1)); % if VIIRS is older
      
      if ~isempty(a)
            V_low_index = a;
            G_low_index = 1;
      end
      
      b = find(VIIRS_date(1) == GOCI_date); % if GOCI is older
      
      if ~isempty(b)
            V_low_index = 1;
            G_low_index = b;
      end
      
      % upper boundary
      c = find(VIIRS_date == GOCI_date(end));
      
      if ~isempty(c)
            V_upp_index = c;
            G_upp_index = size(GOCI_date,2);
      end
      
      d = find(VIIRS_date(end) == GOCI_date);
      
      if ~isempty(d)
            V_upp_index = size(VIIRS_date,2);
            G_upp_index = d;
      end
      
      [h1,ax1,leg1] = plot_sat_vs_sat(wl{idx0},wl_VIIRS,'GOCI','VIIRS',...
            eval(sprintf('[GOCI_DailyStatMatrix(G_low_index:G_upp_index).Rrs_%s_mean_mid_three]',wl{idx0})),...
            eval(sprintf('[VIIRS_DailyStatMatrix(V_low_index:V_upp_index).Rrs_%s_filtered_mean]',wl_VIIRS)));
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_' wl{idx0}],'epsc')
      %% GOCI Comparison with AQUA
      % lower boundary
      a = find(AQUA_date == GOCI_date(1)); % if AQUA is older
      
      if ~isempty(a)
            A_low_index = a;
            G_low_index = 1;
      end
      
      b = find(AQUA_date(1) == GOCI_date); % if GOCI is older
      
      if ~isempty(b)
            A_low_index = 1;
            G_low_index = b;
      end
      
      % upper boundary
      c = find(AQUA_date == GOCI_date(end));
      
      if ~isempty(c)
            A_upp_index = c;
            G_upp_index = size(GOCI_date,2);
      end
      
      d = find(AQUA_date(end) == GOCI_date);
      
      if ~isempty(d)
            A_upp_index = size(AQUA_date,2);
            G_upp_index = d;
      end
      
      [h2,ax2,leg2] = plot_sat_vs_sat(wl{idx0},wl_AQUA,'GOCI','AQUA',...
            eval(sprintf('[GOCI_DailyStatMatrix(G_low_index:G_upp_index).Rrs_%s_mean_mid_three]',wl{idx0})),...
            eval(sprintf('[AQUA_DailyStatMatrix(A_low_index:A_upp_index).Rrs_%s_filtered_mean]',wl_AQUA)));
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_' wl{idx0}],'epsc')
      %% VIIRS Comparison with AQUA
      % lower boundary
      a = find(AQUA_date == VIIRS_date(1)); % if AQUA is older
      
      if ~isempty(a)
            A_low_index = a;
            V_low_index = 1;
      end
      
      b = find(AQUA_date(1) == VIIRS_date); % if VIIRS is older
      
      if ~isempty(b)
            A_low_index = 1;
            V_low_index = b;
      end
      
      % upper boundary
      c = find(AQUA_date == VIIRS_date(end));
      
      if ~isempty(c)
            A_upp_index = c;
            V_upp_index = size(VIIRS_date,2);
      end
      
      d = find(AQUA_date(end) == VIIRS_date);
      
      if ~isempty(d)
            A_upp_index = size(AQUA_date,2);
            V_upp_index = d;
      end
      
      [h3,ax3,leg3] = plot_sat_vs_sat(wl_VIIRS,wl_AQUA,'VIIRS','AQUA',...
            eval(sprintf('[VIIRS_DailyStatMatrix(V_low_index:V_upp_index).Rrs_%s_filtered_mean]',wl_VIIRS)),...
            eval(sprintf('[AQUA_DailyStatMatrix(A_low_index:A_upp_index).Rrs_%s_filtered_mean]',wl_AQUA))); 
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_VIIRS_AQUA_' wl{idx0}],'epsc')
end
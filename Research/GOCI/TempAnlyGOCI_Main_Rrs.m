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

total_px = SatData(1).pixel_count; % FOR THIS ROI!!!
zenith_lim = 75;
xrange = 0.02;

% Rrs_412
cond1 = ~isnan([SatData.Rrs_412_filtered_mean]);
cond2 = [SatData.Rrs_412_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
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
% xlim([-1*xrange xrange])

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
cond2 = [SatData.Rrs_443_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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
% xlim([-1*xrange xrange])

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
cond2 = [SatData.Rrs_490_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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
% xlim([-1*xrange xrange])

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
cond2 = [SatData.Rrs_555_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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
% xlim([-1*xrange xrange])

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
cond2 = [SatData.Rrs_660_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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
% xlim([-1*xrange xrange])

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
cond2 = [SatData.Rrs_680_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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
% xlim([-1*xrange xrange])

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
% cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);

wl = '680'; % 412 443 490 555 660 680
eval(sprintf('cond1 = ~isnan([SatData.Rrs_%s_filtered_mean]);',wl));
eval(sprintf('cond2 = [SatData.Rrs_%s_filtered_valid_pixel_count]>= 1+total_px/2;',wl));
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1 & cond2 & cond3;

eval(sprintf('data_used_y = [SatData(cond_used).Rrs_%s_filtered_mean];',wl));
data_used_x = [SatData(cond_used).datetime];

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
hold on
plot(data_used_x,data_used_y,'.','MarkerSize',12)
eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl));
grid on

subplot(2,1,2)
hold on
plot([SatData(cond_used).datetime],[SatData(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on

%% show high solar zenith angle and no valid data
subplot(2,1,1)
hold on
plot([SatData(~cond2).datetime],[SatData(~cond2).Rrs_412_filtered_mean],'.r','MarkerSize',12)
subplot(2,1,1)
hold on
plot([SatData(~cond3).datetime],[SatData(~cond3).Rrs_412_filtered_mean],'.g','MarkerSize',12)

subplot(2,1,2)
hold on
plot([SatData(~cond2).datetime],[SatData(~cond2).center_ze],'.r','MarkerSize',12)
subplot(2,1,2)
hold on
plot([SatData(~cond3).datetime],[SatData(~cond3).center_ze],'.g','MarkerSize',12)
%% Chlr_a

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);
cond1 = ~isnan([SatData.chlor_a_filtered_mean]);
cond2 = [SatData.chlor_a_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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


N = sum(cond_used);
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist([SatData(cond_used).chlor_a_filtered_mean],50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('Chlor\_a','FontSize',fs)
grid on
%% mean rrs vs zenith

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);

% Rrs 412
cond1 = ~isnan([SatData.Rrs_412_filtered_mean]);
cond2 = [SatData.Rrs_412_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

subplot(2,3,1)
plot([SatData(cond_used).Rrs_412_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(412)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 443
cond1 = ~isnan([SatData.Rrs_443_filtered_mean]);
cond2 = [SatData.Rrs_443_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,2)
plot([SatData(cond_used).Rrs_443_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(443)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 490
cond1 = ~isnan([SatData.Rrs_490_filtered_mean]);
cond2 = [SatData.Rrs_490_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,3)
plot([SatData(cond_used).Rrs_490_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(490)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 555
cond1 = ~isnan([SatData.Rrs_555_filtered_mean]);
cond2 = [SatData.Rrs_555_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,4)
plot([SatData(cond_used).Rrs_555_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(555)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 660
cond1 = ~isnan([SatData.Rrs_660_filtered_mean]);
cond2 = [SatData.Rrs_660_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,5)
plot([SatData(cond_used).Rrs_660_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(660)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs 680
cond1 = ~isnan([SatData.Rrs_680_filtered_mean]);
cond2 = [SatData.Rrs_680_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,6)
plot([SatData(cond_used).Rrs_680_filtered_mean],[SatData(cond_used).center_ze],'.','MarkerSize',20)
xlabel('R_{rs}(680)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on


%% chl vs zenith

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(SatData,2);
% cond_used = [SatData.datetime]>datetime(2013,1,1) & [SatData.datetime]<datetime(2014,1,1);


cond1 = ~isnan([SatData.chlor_a_filtered_mean]);
cond2 = [SatData.chlor_a_filtered_valid_pixel_count]>= 1+total_px/2;
cond3 = [SatData.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

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
plot([SatData.datetime],D(:,4),'.')
ylabel('Hour of the day (GMT)','FontSize',fs)
grid on

subplot(2,1,2)
plot([SatData(cond_used).datetime],[SatData(cond_used).center_ze],'.')
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on
%% Global statistics

% cond2 = [SatData.Rrs_660_filtered_valid_pixel_count]>= 1+total_px/2;
% cond3 = [SatData.center_ze] <= 65;
% cond_used = cond3 & cond2;
clear DailyStatMatrix
clear cond_1t

[Year,Month,Day] = datevec([SatData.datetime]);

first_day = datetime(SatData(1).datetime.Year,SatData(1).datetime.Month,SatData(1).datetime.Day);
last_day = datetime(SatData(end).datetime.Year,SatData(end).datetime.Month,SatData(end).datetime.Day);

date_idx = first_day:last_day;
count_neg_cases = 0;
%%
for idx=1:size(date_idx,2)
      % identify all the images for a specific day
      cond_1t = date_idx(idx).Year==Year...
            & date_idx.Month(idx)==Month...
            & date_idx.Day(idx)==Day;
      
      %       %% to see how many images per day
      %       if sum(cond_1t)> 8 % or sum(cond_1t)~=8
      %             disp([num2str(sum(cond_1t)) ' ' datestr(date_idx(idx))])
      %       end
      
      DailyStatMatrix(idx).datetime =  date_idx(idx);
      DailyStatMatrix(idx).images_per_day = sum(cond_1t);
      
      % check if there are more than one image per hour. It does not check
      % if the values are valid or not, but there are only a bunch of cases
      time_aux = [SatData(cond_1t).datetime];
      [~,IA,~] = unique([time_aux.Hour]);     
      cond_aux = zeros(size(time_aux));
      cond_aux(IA) = 1;     
      cond_1t(cond_1t) = cond_aux;      
      clear time_aux IA cond_aux
      %% Rrs 412
      
      data_used = [SatData(cond_1t).Rrs_412_filtered_mean];
      valid_px_count_used = [SatData(cond_1t).Rrs_412_filtered_valid_pixel_count];      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= 1 + total_px/2; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      DailyStatMatrix(idx).Rrs_412_mean_mean = nanmean(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_412_stdv_mean = nanstd(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_412_N_mean = sum(cond_used);
      DailyStatMatrix(idx).Rrs_412_max_mean = nanmax(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_412_min_mean = nanmin(data_used(cond_used));
      
      % RMSE with respect to the mean
      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      DailyStatMatrix(idx).Rrs_412_RMSE_mean = RMSE;
      
      time_used = [SatData(cond_1t).datetime];
      
      idx
      data_used_filtered = data_used(cond_used);      
      time_used_filtered = time_used(cond_used);  
      for idx2 =1:size(data_used_filtered,2)
            if time_used_filtered.Hour(idx2) == 0
                  DailyStatMatrix(idx).Rrs_412_00 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_00 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_00 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 1
                  DailyStatMatrix(idx).Rrs_412_01 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_01 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_01 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 2
                  DailyStatMatrix(idx).Rrs_412_02 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_02 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_02 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 3
                  DailyStatMatrix(idx).Rrs_412_03 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_03 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_03 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end  
            if time_used_filtered.Hour(idx2) == 4
                  DailyStatMatrix(idx).Rrs_412_04 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_04 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_04 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end 
            if time_used_filtered.Hour(idx2) == 5
                  DailyStatMatrix(idx).Rrs_412_05 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_05 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_05 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end  
            if time_used_filtered.Hour(idx2) == 6
                  DailyStatMatrix(idx).Rrs_412_06 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_06 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_06 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end
            if time_used_filtered.Hour(idx2) == 7
                  DailyStatMatrix(idx).Rrs_412_07 = data_used_filtered(idx2);
                  DailyStatMatrix(idx).Rrs_412_error_w_r_daily_mean_07 = ...
                        DailyStatMatrix(idx).Rrs_412_mean_mean - data_used_filtered(idx2);% error with respect to the daily mean
                  if sum(time_used_filtered.Hour == 4)~=0 % the noon value exist
                        DailyStatMatrix(idx).Rrs_412_error_w_r_noon_07 = ...
                              data_used_filtered(time_used_filtered.Hour == 4) - data_used_filtered(idx2);
                  end
            end              
      end

      %% Rrs 443
      
      data_used = [SatData(cond_1t).Rrs_443_filtered_mean];
      valid_px_count_used = [SatData(cond_1t).Rrs_443_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= 1 + total_px/2; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      DailyStatMatrix(idx).Rrs_443_mean_mean = nanmean(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_443_stdv_mean = nanstd(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_443_N_mean = sum(cond_used);
      DailyStatMatrix(idx).Rrs_443_max_mean = nanmax(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_443_min_mean = nanmin(data_used(cond_used));


      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      DailyStatMatrix(idx).Rrs_443_RMSE_mean = RMSE;

      %% Rrs 490
      
      data_used = [SatData(cond_1t).Rrs_490_filtered_mean];
      valid_px_count_used = [SatData(cond_1t).Rrs_490_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= 1 + total_px/2; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      DailyStatMatrix(idx).Rrs_490_mean_mean = nanmean(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_490_stdv_mean = nanstd(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_490_N_mean = sum(cond_used);
      DailyStatMatrix(idx).Rrs_490_max_mean = nanmax(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_490_min_mean = nanmin(data_used(cond_used));


      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      DailyStatMatrix(idx).Rrs_490_RMSE_mean = RMSE;  

      %% Rrs 555
      
      data_used = [SatData(cond_1t).Rrs_555_filtered_mean];
      valid_px_count_used = [SatData(cond_1t).Rrs_555_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= 1 + total_px/2; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      DailyStatMatrix(idx).Rrs_555_mean_mean = nanmean(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_555_stdv_mean = nanstd(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_555_N_mean = sum(cond_used);
      DailyStatMatrix(idx).Rrs_555_max_mean = nanmax(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_555_min_mean = nanmin(data_used(cond_used));


      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      DailyStatMatrix(idx).Rrs_555_RMSE_mean = RMSE;       

      %% Rrs 660
      
      data_used = [SatData(cond_1t).Rrs_660_filtered_mean];
      valid_px_count_used = [SatData(cond_1t).Rrs_660_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= 1 + total_px/2; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      DailyStatMatrix(idx).Rrs_660_mean_mean = nanmean(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_660_stdv_mean = nanstd(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_660_N_mean = sum(cond_used);
      DailyStatMatrix(idx).Rrs_660_max_mean = nanmax(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_660_min_mean = nanmin(data_used(cond_used));


      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      DailyStatMatrix(idx).Rrs_660_RMSE_mean = RMSE; 

      %% Rrs 680
      
      data_used = [SatData(cond_1t).Rrs_680_filtered_mean];
      valid_px_count_used = [SatData(cond_1t).Rrs_680_filtered_valid_pixel_count];
      
      cond1 = data_used >= 0; % only positive values
      cond2 = valid_px_count_used >= 1 + total_px/2; % more than half valid pixel criteria
      cond_used = cond1&cond2;
      
      DailyStatMatrix(idx).Rrs_680_mean_mean = nanmean(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_680_stdv_mean = nanstd(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_680_N_mean = sum(cond_used);
      DailyStatMatrix(idx).Rrs_680_max_mean = nanmax(data_used(cond_used));
      DailyStatMatrix(idx).Rrs_680_min_mean = nanmin(data_used(cond_used));


      sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
      RMSE = sqrt(sum(sq_err)/sum(cond_used));
      DailyStatMatrix(idx).Rrs_680_RMSE_mean = RMSE;       
end

%% Plot global stats
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
hist([DailyStatMatrix.Rrs_412_stdv_mean])
xlabel('R_{rs}(412): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,2)
hist([DailyStatMatrix.Rrs_443_stdv_mean])
xlabel('R_{rs}(443): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,3)
hist([DailyStatMatrix.Rrs_490_stdv_mean])
xlabel('R_{rs}(490): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,4)
hist([DailyStatMatrix.Rrs_555_stdv_mean])
xlabel('R_{rs}(555): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,5)
hist([DailyStatMatrix.Rrs_660_stdv_mean])
xlabel('R_{rs}(660): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,6)
hist([DailyStatMatrix.Rrs_680_stdv_mean])
xlabel('R_{rs}(680): stdv of the daily','FontSize',fs)
ylabel('Frequency','FontSize',fs)

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
hist([DailyStatMatrix.Rrs_412_RMSE_mean])
xlabel('R_{rs}(412): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,2)
hist([DailyStatMatrix.Rrs_443_RMSE_mean])
xlabel('R_{rs}(443): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,3)
hist([DailyStatMatrix.Rrs_490_RMSE_mean])
xlabel('R_{rs}(490): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,4)
hist([DailyStatMatrix.Rrs_555_RMSE_mean])
xlabel('R_{rs}(555): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,5)
hist([DailyStatMatrix.Rrs_660_RMSE_mean])
xlabel('R_{rs}(660): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,6)
hist([DailyStatMatrix.Rrs_680_RMSE_mean])
xlabel('R_{rs}(680): RMSE of the daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,3,1)
hist([DailyStatMatrix.Rrs_412_mean_mean])
xlabel('R_{rs}(412): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,2)
hist([DailyStatMatrix.Rrs_443_mean_mean])
xlabel('R_{rs}(443): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,3)
hist([DailyStatMatrix.Rrs_490_mean_mean])
xlabel('R_{rs}(490): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,4)
hist([DailyStatMatrix.Rrs_555_mean_mean])
xlabel('R_{rs}(555): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,5)
hist([DailyStatMatrix.Rrs_660_mean_mean])
xlabel('R_{rs}(660): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

subplot(2,3,6)
hist([DailyStatMatrix.Rrs_680_mean_mean])
xlabel('R_{rs}(680): daily mean','FontSize',fs)
ylabel('Frequency','FontSize',fs)

nanmean([DailyStatMatrix.Rrs_412_stdv_mean])
nanmean([DailyStatMatrix.Rrs_443_stdv_mean])
nanmean([DailyStatMatrix.Rrs_490_stdv_mean])
nanmean([DailyStatMatrix.Rrs_555_stdv_mean])
nanmean([DailyStatMatrix.Rrs_660_stdv_mean])
nanmean([DailyStatMatrix.Rrs_680_stdv_mean])



%% Script to find Landsat 8 matchups for Rrs_based on in situ data from
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')
addpath('/Users/jconchas/Documents/MATLAB')
%% Load GOCI data
clear GOCI_Data
tic
fileID = fopen('./GOCI_TemporalAnly/GOCI_ROI_STATS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'GOCI';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading GOCI Data')
      
      filepath = ['./GOCI_TemporalAnly/GOCI_ROI_STATS/' s{1}{idx0}];
      GOCI_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc

%% Load Aqua data
clear AQUA_Data
tic
fileID = fopen('./GOCI_TemporalAnly/AQUA_ROI_STATS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'AQUA';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading AQUA Data')
      
      filepath = ['./GOCI_TemporalAnly/AQUA_ROI_STATS/' s{1}{idx0}];
      AQUA_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end

close(h1)
toc

%% Load VIIRS data
clear VIIRS_Data
tic
fileID = fopen('./GOCI_TemporalAnly/VIIRS_ROI_STATS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'VIIRS';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading VIIRS Data')
      
      filepath = ['./GOCI_TemporalAnly/VIIRS_ROI_STATS/' s{1}{idx0}];
      VIIRS_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc
%%
tic
save('GOCI_TempAnly.mat','GOCI_Data','-v7.3')
save('GOCI_TempAnly.mat','AQUA_Data','-append')
save('GOCI_TempAnly.mat','VIIRS_Data','-append')
toc
%%
load('GOCI_TempAnly.mat','GOCI_Data')
%%
% fs = 24;
% h1 =  figure('Color','white','DefaultAxesFontSize',fs);

total_px_GOCI = GOCI_Data(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
ratio_from_the_total = 2; % 2 3 4 % half or third or fourth of the total of pixels
zenith_lim = 100;
xrange = 0.02;
startDate = datenum('01-01-2011');
endDate = datenum('01-01-2017');
xData = startDate:datenum(years(1)):endDate;

lw = 1.5;
fs = 25;
% % %
% % % % Rrs_412
% % % cond1 = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
% % % cond2 = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % data_used = [GOCI_Data(cond_used).Rrs_412_filtered_mean];
% % %
% % %
% % % figure(h1)
% % % subplot(6,1,1)
% % % plot([GOCI_Data(cond_used).datetime],data_used,'.')
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')
% % % set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% % % set(gca,'XTickLabel',{' '})
% % % ylabel('R_{rs}(412)','FontSize',fs)
% % % grid on
% % %
% % % N = nansum(cond_used);
% % % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist(data_used,50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('R_{rs}(412) (sr^{-1})','FontSize',fs)
% % % % xlim([-1*xrange xrange])
% % %
% % % str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
% % %       N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));
% % %
% % %
% % % xLimits = get(gca,'XLim');
% % % yLimits = get(gca,'YLim');
% % % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
% % % yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
% % % figure(h)
% % % hold on
% % % text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
% % % grid on
% % %
% % % % Rrs_443
% % % cond1 = ~isnan([GOCI_Data.Rrs_443_filtered_mean]);
% % % cond2 = [GOCI_Data.Rrs_443_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % data_used = [GOCI_Data(cond_used).Rrs_443_filtered_mean];
% % %
% % % figure(h1)
% % % subplot(6,1,2)
% % % plot([GOCI_Data(cond_used).datetime],data_used,'.')
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')
% % % set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% % % set(gca,'XTickLabel',{' '})
% % % ylabel('R_{rs}(443)','FontSize',fs)
% % % grid on
% % %
% % % N = nansum(cond_used);
% % % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist(data_used,50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('R_{rs}(443) (sr^{-1})','FontSize',fs)
% % % % xlim([-1*xrange xrange])
% % %
% % % str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
% % %       N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));
% % %
% % % xLimits = get(gca,'XLim');
% % % yLimits = get(gca,'YLim');
% % % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
% % % yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
% % % figure(h)
% % % hold on
% % % text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
% % % grid on
% % %
% % % % Rrs_490
% % % cond1 = ~isnan([GOCI_Data.Rrs_490_filtered_mean]);
% % % cond2 = [GOCI_Data.Rrs_490_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % data_used = [GOCI_Data(cond_used).Rrs_490_filtered_mean];
% % %
% % % figure(h1)
% % % subplot(6,1,3)
% % % plot([GOCI_Data(cond_used).datetime],data_used,'.')
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')
% % % set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% % % set(gca,'XTickLabel',{' '})
% % % ylabel('R_{rs}(490)','FontSize',fs)
% % % grid on
% % %
% % % N = nansum(cond_used);
% % % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist(data_used,50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('R_{rs}(490) (sr^{-1})','FontSize',fs)
% % % % xlim([-1*xrange xrange])
% % %
% % % str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
% % %       N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));
% % %
% % % xLimits = get(gca,'XLim');
% % % yLimits = get(gca,'YLim');
% % % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
% % % yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
% % % figure(h)
% % % hold on
% % % text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
% % % grid on
% % %
% % % % Rrs_555
% % % cond1 = ~isnan([GOCI_Data.Rrs_555_filtered_mean]);
% % % cond2 = [GOCI_Data.Rrs_555_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % data_used = [GOCI_Data(cond_used).Rrs_555_filtered_mean];
% % %
% % % figure(h1)
% % % subplot(6,1,4)
% % % plot([GOCI_Data(cond_used).datetime],data_used,'.')
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')
% % % set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% % % set(gca,'XTickLabel',{' '})
% % % ylabel('R_{rs}(555)','FontSize',fs)
% % % grid on
% % %
% % % N = nansum(cond_used);
% % % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist(data_used,50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('R_{rs}(555) (sr^{-1})','FontSize',fs)
% % % % xlim([-1*xrange xrange])
% % %
% % % str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
% % %       N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));
% % %
% % % xLimits = get(gca,'XLim');
% % % yLimits = get(gca,'YLim');
% % % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
% % % yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
% % % figure(h)
% % % hold on
% % % text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
% % % grid on
% % %
% % % % Rrs_660
% % % cond1 = ~isnan([GOCI_Data.Rrs_660_filtered_mean]);
% % % cond2 = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % data_used = [GOCI_Data(cond_used).Rrs_660_filtered_mean];
% % %
% % % figure(h1)
% % % subplot(6,1,5)
% % % plot([GOCI_Data(cond_used).datetime],data_used,'.')
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')
% % % set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% % % set(gca,'XTickLabel',{' '})
% % % ylabel('R_{rs}(660)','FontSize',fs)
% % % grid on
% % %
% % % N = nansum(cond_used);
% % % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist(data_used,50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('R_{rs}(660) (sr^{-1})','FontSize',fs)
% % % % xlim([-1*xrange xrange])
% % %
% % % str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
% % %       N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));
% % %
% % % xLimits = get(gca,'XLim');
% % % yLimits = get(gca,'YLim');
% % % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
% % % yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
% % % figure(h)
% % % hold on
% % % text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
% % % grid on
% % %
% % % % Rrs_680
% % % cond1 = ~isnan([GOCI_Data.Rrs_680_filtered_mean]);
% % % cond2 = [GOCI_Data.Rrs_680_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % data_used = [GOCI_Data(cond_used).Rrs_680_filtered_mean];
% % %
% % %
% % % figure(h1)
% % % subplot(6,1,6)
% % % plot([GOCI_Data(cond_used).datetime],data_used,'.')
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')%
% % % set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% % % % set(gca,'XTickLabel',{' '})
% % % ylabel('R_{rs}(680)','FontSize',fs)
% % % xlabel('Time','FontSize',fs)
% % % grid on
% % %
% % % N = nansum(cond_used);
% % % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist(data_used,50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('R_{rs}(680) (sr^{-1})','FontSize',fs)
% % % % xlim([-1*xrange xrange])
% % %
% % % str1 = sprintf('N: %i\nmean: %2.5f (sr^{-1})\nmax: %2.5f (sr^{-1})\nmin: %2.5f (sr^{-1})\nsd: %2.5f (sr^{-1})',...
% % %       N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));
% % %
% % % xLimits = get(gca,'XLim');
% % % yLimits = get(gca,'YLim');
% % % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
% % % yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
% % % figure(h)
% % % hold on
% % % text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
% % % grid on
% % %
%% GOCI Rrs vs time and solar zenith angle vs time
% % %
% % % % cond_used = 11064-7:11064+23;
% % % % cond_used = 1:size(GOCI_Data,2);
% % % % cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);
% % %
% % % wl = '680'; % 412 443 490 555 660 680
% % % eval(sprintf('cond1 = ~isnan([GOCI_Data.Rrs_%s_filtered_mean]);',wl));
% % % eval(sprintf('cond2 = [GOCI_Data.Rrs_%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',wl));
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1 & cond2 & cond3;
% % %
% % % eval(sprintf('data_used_y = [GOCI_Data(cond_used).Rrs_%s_filtered_mean];',wl));
% % % data_used_x = [GOCI_Data(cond_used).datetime];
% % %
% % % fs = 25;
% % % h1 = figure('Color','white','DefaultAxesFontSize',fs);
% % % subplot(2,1,1)
% % % hold on
% % % plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'.','MarkerSize',12)
% % % eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl));
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')%
% % % % set(gca,'XTickLabel',{' '})
% % % grid on
% % %
% % % subplot(2,1,2)
% % % hold on
% % % plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).center_ze],'.')
% % % ylabel('Solar Zenith Angle (^o)','FontSize',fs)
% % % xlabel('Time','FontSize',fs)
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')%
% % % % set(gca,'XTickLabel',{' '})
% % % grid on
%% show high solar zenith angle and no valid data
% % % subplot(2,1,1)
% % % hold on
% % % plot([GOCI_Data(~cond2).datetime],[GOCI_Data(~cond2).Rrs_412_filtered_mean],'.r','MarkerSize',12)
% % % subplot(2,1,1)
% % % hold on
% % % plot([GOCI_Data(~cond3).datetime],[GOCI_Data(~cond3).Rrs_412_filtered_mean],'.g','MarkerSize',12)
% % %
% % % subplot(2,1,2)
% % % hold on
% % % plot([GOCI_Data(~cond2).datetime],[GOCI_Data(~cond2).center_ze],'.r','MarkerSize',12)
% % % subplot(2,1,2)
% % % hold on
% % % plot([GOCI_Data(~cond3).datetime],[GOCI_Data(~cond3).center_ze],'.g','MarkerSize',12)
%% Chlr_a
% % %
% % % % cond_used = 11064-7:11064+23;
% % % % cond_used = 1:size(GOCI_Data,2);
% % % % cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);
% % % cond1 = ~isnan([GOCI_Data.chlor_a_filtered_mean]);
% % % cond2 = [GOCI_Data.chlor_a_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % fs = 25;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % subplot(2,1,1)
% % % plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).chlor_a_filtered_mean],'.','MarkerSize',20)
% % % ylabel('Chlor\_a','FontSize',fs)
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')%
% % % % set(gca,'XTickLabel',{' '})
% % % grid on
% % %
% % % subplot(2,1,2)
% % % plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).center_ze],'.')
% % % ylabel('Solar Zenith Angle (^o)','FontSize',fs)
% % % xlabel('Time','FontSize',fs)
% % % ax = gca;
% % % ax.XTick = xData;
% % % datetick('x','yyyy')%
% % % % set(gca,'XTickLabel',{' '})
% % % grid on
% % %
% % %
% % % N = nansum(cond_used);
% % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % [counts,centers] = hist([GOCI_Data(cond_used).chlor_a_filtered_mean],50);
% % % plot(centers,counts*100/N,'b-','LineWidth',1.5)
% % % ylabel('Frequency (%)','FontSize',fs)
% % % xlabel('Chlor\_a','FontSize',fs)
% % % grid on
% % %
%% mean rrs vs zenith
% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);

fs = 25;
ms = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);

% Rrs_412
cond1 = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
cond2 = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;

subplot(2,3,1)
plot([GOCI_Data(cond_used).Rrs_412_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(412)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_443
cond1 = ~isnan([GOCI_Data.Rrs_443_filtered_mean]);
cond2 = [GOCI_Data.Rrs_443_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,2)
plot([GOCI_Data(cond_used).Rrs_443_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(443)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_490
cond1 = ~isnan([GOCI_Data.Rrs_490_filtered_mean]);
cond2 = [GOCI_Data.Rrs_490_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,3)
plot([GOCI_Data(cond_used).Rrs_490_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(490)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_555
cond1 = ~isnan([GOCI_Data.Rrs_555_filtered_mean]);
cond2 = [GOCI_Data.Rrs_555_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,4)
plot([GOCI_Data(cond_used).Rrs_555_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(555)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_660
cond1 = ~isnan([GOCI_Data.Rrs_660_filtered_mean]);
cond2 = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= zenith_lim;
cond_used = cond1&cond2&cond3;
subplot(2,3,5)
plot([GOCI_Data(cond_used).Rrs_660_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
xlabel('R_{rs}(660)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_680
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
% % %
% % % % cond_used = 11064-7:11064+23;
% % % % cond_used = 1:size(GOCI_Data,2);
% % % % cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);
% % %
% % %
% % % cond1 = ~isnan([GOCI_Data.chlor_a_filtered_mean]);
% % % cond2 = [GOCI_Data.chlor_a_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% % % cond3 = [GOCI_Data.center_ze] <= zenith_lim;
% % % cond_used = cond1&cond2&cond3;
% % %
% % % fs = 20;
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % plot([GOCI_Data(cond_used).chlor_a_filtered_mean],[GOCI_Data(cond_used).center_ze],'.','MarkerSize',ms)
% % % xlabel('Chlor-\it{a}','FontSize',fs)
% % % ylabel('Solar Zenith Angle (^o)','FontSize',fs)
% % % grid on
% % %
% % %
%% Capture time analysis
% % % D= datevec([GOCI_Data.datetime]);
% % % h = figure('Color','white','DefaultAxesFontSize',fs);
% % % subplot(2,1,1)
% % % plot([GOCI_Data.datetime],datetime(2016,1,1,D(:,4),D(:,5),D(:,6)),'.')
% % % ylabel('Hour of the day (GMT)','FontSize',fs)
% % % datetick('y','hh:MM')%
% % % grid on
% % %
% % % subplot(2,1,2)
% % % plot([GOCI_Data(cond_used).datetime],[GOCI_Data(cond_used).center_ze],'.')
% % % ylabel('Solar Zenith Angle (^o)','FontSize',fs)
% % % xlabel('Time','FontSize',fs)
% % % grid on
%% Daily statistics for GOCI

% cond2 = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
% cond3 = [GOCI_Data.center_ze] <= 65;
% cond_used = cond3 & cond2;
process_data_flag = 1;

count = 0;
CV_lim = 0.3;

brdf_opt_vec = [0 3 7];

if process_data_flag
      
      clear GOCI_DailyStatMatrix
      clear cond_1t cond1 cond2 cond_used
      
      
      first_day = datetime(GOCI_Data(1).datetime.Year,GOCI_Data(1).datetime.Month,GOCI_Data(1).datetime.Day);
      last_day = datetime(GOCI_Data(end).datetime.Year,GOCI_Data(end).datetime.Month,GOCI_Data(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_senz = [GOCI_Data.senz_center_value]<=60; % criteria for the sensor zenith angle
            cond_solz = [GOCI_Data.solz_center_value]<=75;
            cond_CV = [GOCI_Data.median_CV]<=CV_lim;
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;
            
            GOCI_Data_used = GOCI_Data(cond_used);
            
            [Year,Month,Day] = datevec([GOCI_Data(cond_used).datetime]);
            
            clear cond_used
            
            for idx=1:size(date_idx,2)
                  
                  % identify all the images for a specific day
                  cond_1t = date_idx(idx).Year==Year...
                        & date_idx.Month(idx)==Month...
                        & date_idx.Day(idx)==Day;
                  
                  if ~sum(cond_1t) == 0
                        
                        count = count+1;
                        
                        GOCI_DailyStatMatrix(count).datetime =  date_idx(idx);
                        GOCI_DailyStatMatrix(count).images_per_day = nansum(cond_1t);
                        GOCI_DailyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        % check if there are more than one image per hour. It does not check
                        % if the values are valid or not, but there are only a bunch of cases
                        time_aux = [GOCI_Data_used(cond_1t).datetime];
                        [~,IA,~] = unique([time_aux.Hour]);
                        cond_aux = zeros(size(time_aux));
                        cond_aux(IA) = 1;
                        cond_1t(cond_1t) = cond_aux;
                        clear time_aux IA cond_aux
                        
                        %% Rrs_412
                        
                        data_used = [GOCI_Data_used(cond_1t).Rrs_412_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).Rrs_412_valid_pixel_count];
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).Rrs_412_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_412_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_min_mean = nanmin(data_used(cond_used));
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).Rrs_412_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_412_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_412_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_412_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_412_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_412_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_412_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_412_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_412_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_412_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_412_00,GOCI_DailyStatMatrix(count).Rrs_412_01,GOCI_DailyStatMatrix(count).Rrs_412_02,...
                              GOCI_DailyStatMatrix(count).Rrs_412_03,GOCI_DailyStatMatrix(count).Rrs_412_04,GOCI_DailyStatMatrix(count).Rrs_412_05]);
                        
                        GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_412_02,GOCI_DailyStatMatrix(count).Rrs_412_03,GOCI_DailyStatMatrix(count).Rrs_412_04]);
                        
                        %% Rrs_443
                        
                        data_used = [GOCI_Data_used(cond_1t).Rrs_443_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).Rrs_443_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).Rrs_443_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_443_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).Rrs_443_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_443_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_443_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_443_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_443_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_443_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_443_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_443_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_443_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_443_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_443_00,GOCI_DailyStatMatrix(count).Rrs_443_01,GOCI_DailyStatMatrix(count).Rrs_443_02,...
                              GOCI_DailyStatMatrix(count).Rrs_443_03,GOCI_DailyStatMatrix(count).Rrs_443_04,GOCI_DailyStatMatrix(count).Rrs_443_05]);
                        
                        GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_443_02,GOCI_DailyStatMatrix(count).Rrs_443_03,GOCI_DailyStatMatrix(count).Rrs_443_04]);
                        
                        %% Rrs_490
                        
                        data_used = [GOCI_Data_used(cond_1t).Rrs_490_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).Rrs_490_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).Rrs_490_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_490_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).Rrs_490_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_490_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_490_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_490_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_490_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_490_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_490_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_490_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_490_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_490_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_490_00,GOCI_DailyStatMatrix(count).Rrs_490_01,GOCI_DailyStatMatrix(count).Rrs_490_02,...
                              GOCI_DailyStatMatrix(count).Rrs_490_03,GOCI_DailyStatMatrix(count).Rrs_490_04,GOCI_DailyStatMatrix(count).Rrs_490_05]);
                        
                        GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_490_02,GOCI_DailyStatMatrix(count).Rrs_490_03,GOCI_DailyStatMatrix(count).Rrs_490_04]);
                        
                        %% Rrs_555
                        
                        data_used = [GOCI_Data_used(cond_1t).Rrs_555_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).Rrs_555_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).Rrs_555_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_555_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).Rrs_555_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_555_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_555_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_555_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_555_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_555_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_555_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_555_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_555_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_555_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_555_00,GOCI_DailyStatMatrix(count).Rrs_555_01,GOCI_DailyStatMatrix(count).Rrs_555_02,...
                              GOCI_DailyStatMatrix(count).Rrs_555_03,GOCI_DailyStatMatrix(count).Rrs_555_04,GOCI_DailyStatMatrix(count).Rrs_555_05]);
                        
                        GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_555_02,GOCI_DailyStatMatrix(count).Rrs_555_03,GOCI_DailyStatMatrix(count).Rrs_555_04]);
                        
                        
                        %% Rrs_660
                        
                        data_used = [GOCI_Data_used(cond_1t).Rrs_660_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).Rrs_660_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).Rrs_660_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_660_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).Rrs_660_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_660_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_660_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_660_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_660_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_660_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_660_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_660_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_660_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_660_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_660_00,GOCI_DailyStatMatrix(count).Rrs_660_01,GOCI_DailyStatMatrix(count).Rrs_660_02,...
                              GOCI_DailyStatMatrix(count).Rrs_660_03,GOCI_DailyStatMatrix(count).Rrs_660_04,GOCI_DailyStatMatrix(count).Rrs_660_05]);
                        
                        GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_660_02,GOCI_DailyStatMatrix(count).Rrs_660_03,GOCI_DailyStatMatrix(count).Rrs_660_04]);
                        
                        
                        %% Rrs_680
                        
                        data_used = [GOCI_Data_used(cond_1t).Rrs_680_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).Rrs_680_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).Rrs_680_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_680_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).Rrs_680_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_680_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_680_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_680_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_680_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_680_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_680_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_680_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_680_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_680_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_680_00,GOCI_DailyStatMatrix(count).Rrs_680_01,GOCI_DailyStatMatrix(count).Rrs_680_02,...
                              GOCI_DailyStatMatrix(count).Rrs_680_03,GOCI_DailyStatMatrix(count).Rrs_680_04,GOCI_DailyStatMatrix(count).Rrs_680_05]);
                        
                        GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).Rrs_680_02,GOCI_DailyStatMatrix(count).Rrs_680_03,GOCI_DailyStatMatrix(count).Rrs_680_04]);
                        
                        %% aot_865
                        
                        data_used = [GOCI_Data_used(cond_1t).aot_865_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).aot_865_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).aot_865_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).aot_865_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).aot_865_00 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_01 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_02 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_03 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_04 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_05 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_06 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_07 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).aot_865_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).aot_865_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).aot_865_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).aot_865_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).aot_865_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).aot_865_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).aot_865_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).aot_865_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).aot_865_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).aot_865_00,GOCI_DailyStatMatrix(count).aot_865_01,GOCI_DailyStatMatrix(count).aot_865_02,...
                              GOCI_DailyStatMatrix(count).aot_865_03,GOCI_DailyStatMatrix(count).aot_865_04,GOCI_DailyStatMatrix(count).aot_865_05]);
                        
                        GOCI_DailyStatMatrix(count).aot_865_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).aot_865_02,GOCI_DailyStatMatrix(count).aot_865_03,GOCI_DailyStatMatrix(count).aot_865_04]);
                        
                        %% angstrom
                        
                        data_used = [GOCI_Data_used(cond_1t).angstrom_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).angstrom_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).angstrom_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).angstrom_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).angstrom_00 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_01 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_02 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_03 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_04 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_05 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_06 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_07 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).angstrom_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).angstrom_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).angstrom_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).angstrom_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).angstrom_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).angstrom_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).angstrom_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).angstrom_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).angstrom_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).angstrom_00,GOCI_DailyStatMatrix(count).angstrom_01,GOCI_DailyStatMatrix(count).angstrom_02,...
                              GOCI_DailyStatMatrix(count).angstrom_03,GOCI_DailyStatMatrix(count).angstrom_04,GOCI_DailyStatMatrix(count).angstrom_05]);
                        
                        GOCI_DailyStatMatrix(count).angstrom_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).angstrom_02,GOCI_DailyStatMatrix(count).angstrom_03,GOCI_DailyStatMatrix(count).angstrom_04]);
                        
                        %% poc
                        
                        data_used = [GOCI_Data_used(cond_1t).poc_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).poc_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).poc_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).poc_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).poc_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).poc_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).poc_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).poc_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).poc_00 = nan;
                        GOCI_DailyStatMatrix(count).poc_01 = nan;
                        GOCI_DailyStatMatrix(count).poc_02 = nan;
                        GOCI_DailyStatMatrix(count).poc_03 = nan;
                        GOCI_DailyStatMatrix(count).poc_04 = nan;
                        GOCI_DailyStatMatrix(count).poc_05 = nan;
                        GOCI_DailyStatMatrix(count).poc_06 = nan;
                        GOCI_DailyStatMatrix(count).poc_07 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).poc_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).poc_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).poc_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).poc_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).poc_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).poc_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).poc_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).poc_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).poc_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).poc_00,GOCI_DailyStatMatrix(count).poc_01,GOCI_DailyStatMatrix(count).poc_02,...
                              GOCI_DailyStatMatrix(count).poc_03,GOCI_DailyStatMatrix(count).poc_04,GOCI_DailyStatMatrix(count).poc_05]);
                        
                        GOCI_DailyStatMatrix(count).poc_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).poc_02,GOCI_DailyStatMatrix(count).poc_03,GOCI_DailyStatMatrix(count).poc_04]);
                        
                        %% ag_412_mlrc
                        
                        data_used = [GOCI_Data_used(cond_1t).ag_412_mlrc_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).ag_412_mlrc_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_00 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_01 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_02 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_03 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_04 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_05 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_06 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_07 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_00,GOCI_DailyStatMatrix(count).ag_412_mlrc_01,GOCI_DailyStatMatrix(count).ag_412_mlrc_02,...
                              GOCI_DailyStatMatrix(count).ag_412_mlrc_03,GOCI_DailyStatMatrix(count).ag_412_mlrc_04,GOCI_DailyStatMatrix(count).ag_412_mlrc_05]);
                        
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_02,GOCI_DailyStatMatrix(count).ag_412_mlrc_03,GOCI_DailyStatMatrix(count).ag_412_mlrc_04]);
                        
                        %% chlor_a
                        
                        data_used = [GOCI_Data_used(cond_1t).chlor_a_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).chlor_a_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).chlor_a_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).chlor_a_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).chlor_a_00 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_01 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_02 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_03 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_04 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_05 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_06 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_07 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).chlor_a_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).chlor_a_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).chlor_a_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).chlor_a_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).chlor_a_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).chlor_a_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).chlor_a_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).chlor_a_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).chlor_a_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).chlor_a_00,GOCI_DailyStatMatrix(count).chlor_a_01,GOCI_DailyStatMatrix(count).chlor_a_02,...
                              GOCI_DailyStatMatrix(count).chlor_a_03,GOCI_DailyStatMatrix(count).chlor_a_04,GOCI_DailyStatMatrix(count).chlor_a_05]);
                        
                        GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).chlor_a_02,GOCI_DailyStatMatrix(count).chlor_a_03,GOCI_DailyStatMatrix(count).chlor_a_04]);
                        
                        %% brdf
                        
                        data_used = [GOCI_Data_used(cond_1t).brdf_filtered_mean];
                        valid_px_count_used = [GOCI_Data_used(cond_1t).brdf_valid_pixel_count];
                        
                        cond1 = data_used >= 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).brdf_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).brdf_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % RMSE with respect to the daily mean
                        sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used(cond_1t).datetime];
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).brdf_00 = nan;
                        GOCI_DailyStatMatrix(count).brdf_01 = nan;
                        GOCI_DailyStatMatrix(count).brdf_02 = nan;
                        GOCI_DailyStatMatrix(count).brdf_03 = nan;
                        GOCI_DailyStatMatrix(count).brdf_04 = nan;
                        GOCI_DailyStatMatrix(count).brdf_05 = nan;
                        GOCI_DailyStatMatrix(count).brdf_06 = nan;
                        GOCI_DailyStatMatrix(count).brdf_07 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_00 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_01 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_02 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_03 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_04 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_05 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_06 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_07 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_00 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_01 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_02 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_03 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_04 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_05 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_06 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_07 = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).brdf_00 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_00 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).brdf_01 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_01 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).brdf_02 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_02 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).brdf_03 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_03 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).brdf_04 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_04 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).brdf_05 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_05 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).brdf_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_06 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).brdf_07 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_07 = ...
                                                data_used_filtered(time_used_filtered.Hour == 3) - data_used_filtered(idx2);
                                    end
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).brdf_mean_first_six = ...
                              nanmean([GOCI_DailyStatMatrix(count).brdf_00,GOCI_DailyStatMatrix(count).brdf_01,GOCI_DailyStatMatrix(count).brdf_02,...
                              GOCI_DailyStatMatrix(count).brdf_03,GOCI_DailyStatMatrix(count).brdf_04,GOCI_DailyStatMatrix(count).brdf_05]);
                        
                        GOCI_DailyStatMatrix(count).brdf_mean_mid_three = ...
                              nanmean([GOCI_DailyStatMatrix(count).brdf_02,GOCI_DailyStatMatrix(count).brdf_03,GOCI_DailyStatMatrix(count).brdf_04]);
                        
                  end
            end
      end
end
%% Daily statistics for AQUA

count = 0;

if process_data_flag
      clear AQUA_DailyStatMatrix AQUA_Data_used
      clear cond_1t cond1 cond2 cond_used
     
      first_day = datetime(AQUA_Data(1).datetime.Year,AQUA_Data(1).datetime.Month,AQUA_Data(1).datetime.Day);
      last_day = datetime(AQUA_Data(end).datetime.Year,AQUA_Data(end).datetime.Month,AQUA_Data(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [AQUA_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_senz = [AQUA_Data.senz_center_value]<=60; % criteria for the sensor zenith angle
            cond_solz = [AQUA_Data.solz_center_value]<=75;
            cond_CV = [AQUA_Data.median_CV]<=CV_lim;
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;
            
            AQUA_Data_used = AQUA_Data(cond_used);
            
            [Year,Month,Day] = datevec([AQUA_Data(cond_used).datetime]); % only days that satisfy the criteria above
            
            clear cond_used
            
            for idx=1:size(date_idx,2)
                  % identify all the images for a specific day
                  cond_1t = date_idx(idx).Year==Year...
                        & date_idx.Month(idx)==Month...
                        & date_idx.Day(idx)==Day;
                  
                  if sum(cond_1t) ~= 0 % only days that match the criteria above
                        
                        count = count+1;
                        
                        AQUA_DailyStatMatrix(count).datetime =  date_idx(idx);
                        AQUA_DailyStatMatrix(count).images_per_day = nansum(cond_1t);
                        AQUA_DailyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        AQUA_DailyStatMatrix(count).idx_to_AQUA_Data = find(cond_1t);

                        %% Rrs_412
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).Rrs_412_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).Rrs_412_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).Rrs_412_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).Rrs_412_filtered_mean = [AQUA_Data_used(cond_1t_aux).Rrs_412_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).Rrs_412_filtered_mean = nan;
                        end
                        clear cond_1t_aux

                        %% Rrs_443
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).Rrs_443_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).Rrs_443_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).Rrs_443_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).Rrs_443_filtered_mean = [AQUA_Data_used(cond_1t_aux).Rrs_443_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).Rrs_443_filtered_mean = nan;
                        end
                        clear cond_1t_aux

                        %% Rrs_488
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).Rrs_488_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).Rrs_488_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).Rrs_488_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).Rrs_488_filtered_mean = [AQUA_Data_used(cond_1t_aux).Rrs_488_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).Rrs_488_filtered_mean = nan;
                        end
                        clear cond_1t_aux                        
                        
                        %% Rrs_547
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).Rrs_547_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).Rrs_547_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).Rrs_547_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).Rrs_547_filtered_mean = [AQUA_Data_used(cond_1t_aux).Rrs_547_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).Rrs_547_filtered_mean = nan;
                        end
                        clear cond_1t_aux                        
                        
                        %% Rrs_667
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).Rrs_667_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).Rrs_667_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).Rrs_667_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).Rrs_667_filtered_mean = [AQUA_Data_used(cond_1t_aux).Rrs_667_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).Rrs_667_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_678
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).Rrs_678_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).Rrs_678_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).Rrs_678_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).Rrs_678_filtered_mean = [AQUA_Data_used(cond_1t_aux).Rrs_678_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).Rrs_678_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                   
                        %% aot_869
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).aot_869_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).aot_869_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).aot_869_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).aot_869_filtered_mean = [AQUA_Data_used(cond_1t_aux).aot_869_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).aot_869_filtered_mean = nan;
                        end
                        clear cond_1t_aux                   
                        
                        %% angstrom
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).angstrom_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).angstrom_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).angstrom_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).angstrom_filtered_mean = [AQUA_Data_used(cond_1t_aux).angstrom_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).angstrom_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% poc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).poc_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).poc_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).poc_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).poc_filtered_mean = [AQUA_Data_used(cond_1t_aux).poc_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).poc_filtered_mean = nan;
                        end
                        clear cond_1t_aux                        
                        
                        %% ag_412_mlrc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).ag_412_mlrc_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).ag_412_mlrc_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).ag_412_mlrc_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = [AQUA_Data_used(cond_1t_aux).ag_412_mlrc_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = nan;
                        end
                        clear cond_1t_aux

                        %% chlor_a
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).chlor_a_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).chlor_a_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).chlor_a_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).chlor_a_filtered_mean = [AQUA_Data_used(cond_1t_aux).chlor_a_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).chlor_a_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% brdf
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [AQUA_Data_used(cond_1t_aux).brdf_filtered_mean]<0;
                        cond_area = [AQUA_Data_used(cond_1t_aux).brdf_valid_pixel_count]<total_px_GOCI/4/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([AQUA_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        AQUA_DailyStatMatrix(count).brdf_median_CV = [AQUA_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              AQUA_DailyStatMatrix(count).brdf_filtered_mean = [AQUA_Data_used(cond_1t_aux).brdf_filtered_mean];
                        else
                              AQUA_DailyStatMatrix(count).brdf_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                  end
            end
      end
end

%% Daily statistics for VIIRS

count = 0;

if process_data_flag
      clear VIIRS_DailyStatMatrix
      clear cond_1t cond1 cond2 cond_used
      
      
      
      first_day = datetime(VIIRS_Data(1).datetime.Year,VIIRS_Data(1).datetime.Month,VIIRS_Data(1).datetime.Day);
      last_day = datetime(VIIRS_Data(end).datetime.Year,VIIRS_Data(end).datetime.Month,VIIRS_Data(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [VIIRS_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_senz = [VIIRS_Data.senz_center_value]<=60; % criteria for the sensor zenith angle
            cond_solz = [VIIRS_Data.solz_center_value]<=75;
            cond_CV = [VIIRS_Data.median_CV]<=CV_lim;
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;
            
            VIIRS_Data_used = VIIRS_Data(cond_used);
            
            [Year,Month,Day] = datevec([VIIRS_Data(cond_used).datetime]);
            
            clear cond_used
            
            for idx=1:size(date_idx,2)
                  
                  % identify all the images for a specific day
                  cond_1t = date_idx(idx).Year==Year...
                        & date_idx.Month(idx)==Month...
                        & date_idx.Day(idx)==Day;
                  
                  if sum(cond_1t) ~= 0
                        
                        count = count+1;
                        
                        VIIRS_DailyStatMatrix(count).datetime =  date_idx(idx);
                        VIIRS_DailyStatMatrix(count).images_per_day = nansum(cond_1t);
                        VIIRS_DailyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        VIIRS_DailyStatMatrix(count).idx_to_VIIRS_Data = find(cond_1t);

                        %% Rrs_410
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).Rrs_410_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).Rrs_410_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).Rrs_410_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).Rrs_410_filtered_mean = [VIIRS_Data_used(cond_1t_aux).Rrs_410_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_410_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_443
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).Rrs_443_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).Rrs_443_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).Rrs_443_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).Rrs_443_filtered_mean = [VIIRS_Data_used(cond_1t_aux).Rrs_443_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_443_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_486
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).Rrs_486_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).Rrs_486_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).Rrs_486_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).Rrs_486_filtered_mean = [VIIRS_Data_used(cond_1t_aux).Rrs_486_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_486_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_551
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).Rrs_551_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).Rrs_551_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).Rrs_551_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).Rrs_551_filtered_mean = [VIIRS_Data_used(cond_1t_aux).Rrs_551_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_551_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_671
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).Rrs_671_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).Rrs_671_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).Rrs_671_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).Rrs_671_filtered_mean = [VIIRS_Data_used(cond_1t_aux).Rrs_671_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_671_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% aot_862
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).aot_862_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).aot_862_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).aot_862_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).aot_862_filtered_mean = [VIIRS_Data_used(cond_1t_aux).aot_862_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).aot_862_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% angstrom
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).angstrom_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).angstrom_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).angstrom_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).angstrom_filtered_mean = [VIIRS_Data_used(cond_1t_aux).angstrom_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).angstrom_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% poc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).poc_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).poc_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).poc_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).poc_filtered_mean = [VIIRS_Data_used(cond_1t_aux).poc_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).poc_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% ag_412_mlrc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).ag_412_mlrc_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).ag_412_mlrc_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).ag_412_mlrc_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = [VIIRS_Data_used(cond_1t_aux).ag_412_mlrc_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% chlor_a
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).chlor_a_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).chlor_a_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).chlor_a_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).chlor_a_filtered_mean = [VIIRS_Data_used(cond_1t_aux).chlor_a_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).chlor_a_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% brdf
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        cond_neg = [VIIRS_Data_used(cond_1t_aux).brdf_filtered_mean]<0;
                        cond_area = [VIIRS_Data_used(cond_1t_aux).brdf_valid_pixel_count]<total_px_GOCI/2.25/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux cond_area cond_neg

                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              [~,Itemp] = min([VIIRS_Data_used(cond_1t_aux).solz_center_value]);
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                      
                        VIIRS_DailyStatMatrix(count).brdf_median_CV = [VIIRS_Data_used(cond_1t_aux).median_CV];
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              VIIRS_DailyStatMatrix(count).brdf_filtered_mean = [VIIRS_Data_used(cond_1t_aux).brdf_filtered_mean];
                        else
                              VIIRS_DailyStatMatrix(count).brdf_filtered_mean = nan;
                        end
                        clear cond_1t_aux              
                  end
            end
      end
end
%
% save('GOCI_TempAnly.mat','GOCI_DailyStatMatrix','AQUA_DailyStatMatrix','VIIRS_DailyStatMatrix','-append')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Monthly statistics for GOCI
if process_data_flag
      
      clear GOCI_MonthlyStatMatrix
      clear cond_1t count
      
      [Year,Month,~] = datevec([GOCI_DailyStatMatrix.datetime]);
      
      Year_min = min(Year);
      Year_max = max(Year);
      
      Year_idx = Year_min:Year_max;
      
      count = 0;
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            for idx = 1:size(Year_idx,2)
                  for idx2 = 1:12
                        count = count+1;
                        cond_1t = Year_idx(idx)==Year...
                              & idx2==Month...
                              & [GOCI_DailyStatMatrix.brdf_opt] == brdf_opt_vec(idx_brdf);
                        
                        GOCI_MonthlyStatMatrix(count).Month = idx2;
                        GOCI_MonthlyStatMatrix(count).Year  = Year_idx(idx);
                        GOCI_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
                        GOCI_MonthlyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_412_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_412_mean_first_six]);
                        GOCI_MonthlyStatMatrix(count).Rrs_412_mean_first_six_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_412_mean_first_six]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_443_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_443_mean_first_six]);
                        GOCI_MonthlyStatMatrix(count).Rrs_443_mean_first_six_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_443_mean_first_six]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_490_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_490_mean_first_six]);
                        GOCI_MonthlyStatMatrix(count).Rrs_490_mean_first_six_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_490_mean_first_six]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_555_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_555_mean_first_six]);
                        GOCI_MonthlyStatMatrix(count).Rrs_555_mean_first_six_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_555_mean_first_six]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_660_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_660_mean_first_six]);
                        GOCI_MonthlyStatMatrix(count).Rrs_660_mean_first_six_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_660_mean_first_six]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_680_mean_first_six = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_680_mean_first_six]);
                        GOCI_MonthlyStatMatrix(count).Rrs_680_mean_first_six_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_680_mean_first_six]));
                        
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_412_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_412_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).Rrs_412_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_412_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_443_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_443_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).Rrs_443_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_443_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_490_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_490_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).Rrs_490_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_490_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_555_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_555_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).Rrs_555_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_555_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_660_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_660_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).Rrs_660_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_660_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).Rrs_680_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).Rrs_680_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).Rrs_680_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).Rrs_680_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).aot_865_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).aot_865_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).aot_865_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).aot_865_mean_mid_three]));
                        
                        
                        GOCI_MonthlyStatMatrix(count).angstrom_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).angstrom_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).angstrom_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).angstrom_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).poc_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).poc_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).poc_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).poc_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).ag_412_mlrc_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).ag_412_mlrc_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).ag_412_mlrc_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).ag_412_mlrc_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).chlor_a_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).chlor_a_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).chlor_a_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).chlor_a_mean_mid_three]));
                        
                        GOCI_MonthlyStatMatrix(count).brdf_mean_mid_three = nanmean([GOCI_DailyStatMatrix(cond_1t).brdf_mean_mid_three]);
                        GOCI_MonthlyStatMatrix(count).brdf_mean_mid_three_N = nansum(isfinite([GOCI_DailyStatMatrix(cond_1t).brdf_mean_mid_three]));
                        
                        
                        
                  end
            end
      end
end

% Monthly statistics for AQUA
if process_data_flag
      clear AQUA_MonthlyStatMatrix
      clear cond_1t count
      
      [Year,Month,~] = datevec([AQUA_DailyStatMatrix.datetime]);
      
      Year_min = min(Year);
      Year_max = max(Year);
      
      Year_idx = Year_min:Year_max;
      
      count = 0;
      for idx_brdf = 1:size(brdf_opt_vec,2)
            for idx = 1:size(Year_idx,2)
                  for idx2 = 1:12
                        count = count+1;
                        cond_1t = Year_idx(idx)==Year...
                              & idx2==Month...
                              & [AQUA_DailyStatMatrix.brdf_opt] == brdf_opt_vec(idx_brdf);
                        
                        AQUA_MonthlyStatMatrix(count).Month = idx2;
                        AQUA_MonthlyStatMatrix(count).Year  = Year_idx(idx);
                        AQUA_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
                        AQUA_MonthlyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        AQUA_MonthlyStatMatrix(count).Rrs_412_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_412_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).Rrs_412_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).Rrs_412_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).Rrs_443_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_443_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).Rrs_443_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).Rrs_443_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).Rrs_488_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_488_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).Rrs_488_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).Rrs_488_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).Rrs_547_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_547_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).Rrs_547_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).Rrs_547_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).Rrs_667_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_667_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).Rrs_667_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).Rrs_667_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).Rrs_678_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).Rrs_678_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).Rrs_678_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).Rrs_678_filtered_mean]));
                        
                        
                        AQUA_MonthlyStatMatrix(count).aot_869_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).aot_869_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).aot_869_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).aot_869_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).angstrom_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).angstrom_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).angstrom_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).angstrom_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).poc_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).poc_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).poc_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).poc_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).ag_412_mlrc_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).ag_412_mlrc_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).ag_412_mlrc_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).ag_412_mlrc_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).chlor_a_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).chlor_a_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).chlor_a_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).chlor_a_filtered_mean]));
                        
                        AQUA_MonthlyStatMatrix(count).brdf_mean = nanmean([AQUA_DailyStatMatrix(cond_1t).brdf_filtered_mean]);
                        AQUA_MonthlyStatMatrix(count).brdf_mean_N = nansum(isfinite([AQUA_DailyStatMatrix(cond_1t).brdf_filtered_mean]));
                        
                  end
            end
      end
end

% Monthly statistics for VIIRS
if process_data_flag
      clear VIIRS_MonthlyStatMatrix
      clear cond_1t count
      
      [Year,Month,~] = datevec([VIIRS_DailyStatMatrix.datetime]);
      
      Year_min = min(Year);
      Year_max = max(Year);
      
      Year_idx = Year_min:Year_max;
      
      count = 0;
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            for idx = 1:size(Year_idx,2)
                  for idx2 = 1:12
                        count = count+1;
                        cond_1t = Year_idx(idx)==Year...
                              & idx2==Month...
                              & [VIIRS_DailyStatMatrix.brdf_opt] == brdf_opt_vec(idx_brdf);
                        
                        VIIRS_MonthlyStatMatrix(count).Month = idx2;
                        VIIRS_MonthlyStatMatrix(count).Year  = Year_idx(idx);
                        VIIRS_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
                        VIIRS_MonthlyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        VIIRS_MonthlyStatMatrix(count).Rrs_410_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_410_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).Rrs_410_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).Rrs_410_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).Rrs_443_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_443_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).Rrs_443_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).Rrs_443_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).Rrs_486_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_486_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).Rrs_486_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).Rrs_486_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).Rrs_551_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_551_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).Rrs_551_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).Rrs_551_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).Rrs_671_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).Rrs_671_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).Rrs_671_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).Rrs_671_filtered_mean]));
                        
                        
                        VIIRS_MonthlyStatMatrix(count).aot_862_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).aot_862_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).aot_862_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).aot_862_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).angstrom_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).angstrom_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).angstrom_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).angstrom_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).poc_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).poc_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).poc_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).poc_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).ag_412_mlrc_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).ag_412_mlrc_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).ag_412_mlrc_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).ag_412_mlrc_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).chlor_a_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).chlor_a_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).chlor_a_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).chlor_a_filtered_mean]));
                        
                        VIIRS_MonthlyStatMatrix(count).brdf_mean = nanmean([VIIRS_DailyStatMatrix(cond_1t).brdf_filtered_mean]);
                        VIIRS_MonthlyStatMatrix(count).brdf_mean_N = nansum(isfinite([VIIRS_DailyStatMatrix(cond_1t).brdf_filtered_mean]));
                        
                        
                  end
            end
      end
end
%
% save('GOCI_TempAnly.mat','GOCI_MonthlyStatMatrix','AQUA_MonthlyStatMatrix','VIIRS_MonthlyStatMatrix','-append')
%% Plot Monthly Rrs GOCI vs AQUA and VIIRS
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

brdf_opt = 7;

wl = {'412','443','490','555','660','680'};
for idx0 = 1:size(wl,2)
      %       h1 = figure('Color','white','DefaultAxesFontSize',fs);
      %       eval(sprintf('plot([GOCI_MonthlyStatMatrix.datetime],[GOCI_MonthlyStatMatrix.Rrs_%s_mean_first_six]);',wl{idx0}))
      %       eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
      %       grid on
      cond_brdf = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt; 
      
      h2 = figure('Color','white','DefaultAxesFontSize',fs);
      data_used_x = [GOCI_MonthlyStatMatrix(cond_brdf).datetime];
      eval(sprintf('data_used_y = [GOCI_MonthlyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three];',wl{idx0}))
      plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'MarkerSize',12,'LineWidth',lw)
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
            wl_AQUA = '547';
      elseif strcmp(wl{idx0},'660')
            wl_AQUA = '667';
      elseif strcmp(wl{idx0},'680')
            wl_AQUA = '678';
      end
      
      cond_brdf = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt; 
      
      eval(sprintf('cond1 = ~isnan([AQUA_MonthlyStatMatrix.Rrs_%s_mean]);',wl_AQUA));
      cond_used = cond1&cond_brdf;
      
      eval(sprintf('data_used_y = [AQUA_MonthlyStatMatrix(cond_used).Rrs_%s_mean];',wl_AQUA));
      data_used_x = [AQUA_MonthlyStatMatrix(cond_used).datetime];
      
      fs = 25;
      %       figure(h1)
      %       hold on
      %       plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'.-r','MarkerSize',12)
      %       eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
      %       grid on
      
      figure(h2)
      hold on
      plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'r','MarkerSize',12,'LineWidth',lw)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
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
      
      cond_brdf = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt;
      
      eval(sprintf('cond1 = ~isnan([VIIRS_MonthlyStatMatrix.Rrs_%s_mean]);',wl_VIIRS));
      cond_used = cond1&cond_brdf;
      
      eval(sprintf('data_used_y = [VIIRS_MonthlyStatMatrix(cond_used).Rrs_%s_mean];',wl_VIIRS));
      data_used_x = [VIIRS_MonthlyStatMatrix(cond_used).datetime];
      
      fs = 25;
      %       figure(h1)
      %       hold on
      %       plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'.-k','MarkerSize',12)
      %       eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
      %       grid on
      
      figure(h2)
      hold on
      plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'k','MarkerSize',12,'LineWidth',lw)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
      grid on
      set(gcf, 'renderer','painters')
      
      %       figure(h1)
      %       if strcmp(wl{idx0},'412')
      %             legend('GOCI: 412 nm','MODISA: 412 nm','VIIRS: 410 nm')
      %       elseif strcmp(wl{idx0},'443')
      %             legend('GOCI: 443 nm','MODISA: 443 nm','VIIRS: 443 nm')
      %       elseif strcmp(wl{idx0},'490')
      %             legend('GOCI: 490 nm','MODISA: 488 nm','VIIRS: 486 nm')
      %       elseif strcmp(wl{idx0},'555')
      %             legend('GOCI: 555 nm','MODISA: 547 nm','VIIRS: 551 nm')
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
            legend('GOCI: 555 nm','MODISA: 547 nm','VIIRS: 551 nm')
      elseif strcmp(wl{idx0},'660')
            legend('GOCI: 660 nm','MODISA: 667 nm','VIIRS: 671 nm')
      elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            legend('GOCI: 680 nm','MODISA: 678 nm','VIIRS: 671 nm')
      end
      
      %       legend boxoff
      screen_size = get(0, 'ScreenSize');
      origSize = get(gcf, 'Position'); % grab original on screen size
      set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
      set(gcf,'PaperPositionMode','auto') %set paper pos for printing
      saveas(gcf,[savedirname 'CrossComp_Rrs' wl{idx0}],'epsc')
      
end

%% Plot Time Series Daily for Rrs_for GOCI, Aqua and VIIRS
wl = {'412','443','490','555','660','680'};

brdf_opt = 7;

for idx = 1:size(wl,2)
      cond_brdf = [GOCI_DailyStatMatrix.brdf_opt] == brdf_opt;
      
      eval(sprintf('cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_%s_mean_mid_three]);',wl{idx})); % ONLY FOR THE MIDDLE THREE IMAGES!!!
      cond_used = cond1&cond_brdf;
      
      eval(sprintf('data_used_y = [GOCI_DailyStatMatrix(cond_used).Rrs_%s_mean_mid_three];',wl{idx}));
      data_used_x = [GOCI_DailyStatMatrix(cond_used).datetime];
      
      fs = 25;
      h1 = figure('Color','white','DefaultAxesFontSize',fs);
      plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
      %       ax = gca;
      %       ax.XTick = xData;
      %       datetick('x','yyyy')
      %       grid on
      
      %% Plot vs time for Aqua
      
      cond_brdf = [AQUA_DailyStatMatrix.brdf_opt] == brdf_opt;
      
      total_px_AQUA = [AQUA_Data(cond_brdf).pixel_count];
      
      if strcmp(wl{idx},'412')
            wl_AQUA = '412';
      elseif strcmp(wl{idx},'443')
            wl_AQUA = '443';
      elseif strcmp(wl{idx},'490')
            wl_AQUA = '488';
      elseif strcmp(wl{idx},'555')
            wl_AQUA = '547';
      elseif strcmp(wl{idx},'660')
            wl_AQUA = '667';
      elseif strcmp(wl{idx},'680')
            wl_AQUA = '678';
      end
      
      eval(sprintf('cond1 = ~isnan([AQUA_DailyStatMatrix.Rrs_%s_filtered_mean]);',wl_AQUA));
      % cond3 = [AQUA_Data.center_ze] <= zenith_lim;
      cond4 = [AQUA_DailyStatMatrix.datetime] >= nanmin([GOCI_Data.datetime]) &...
            [AQUA_DailyStatMatrix.datetime] <= nanmax([GOCI_Data.datetime]);
      cond_used = cond1 &cond4 & cond_brdf;
      
      eval(sprintf('data_used_y = [AQUA_DailyStatMatrix(cond_used).Rrs_%s_filtered_mean];',wl_AQUA));
      data_used_x = [AQUA_DailyStatMatrix(cond_used).datetime];
      
      fs = 25;
      figure(h1)
      hold on
      plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'r','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
      %       ax = gca;
      %       ax.XTick = xData;
      %       datetick('x','yyyy')
      grid on
      
      %% Plot vs time for VIIRS
      
      cond_brdf = [VIIRS_DailyStatMatrix.brdf_opt] == brdf_opt;
      
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
      cond_used = cond1 & cond4 & cond_brdf;
      
      eval(sprintf('data_used_y = [VIIRS_DailyStatMatrix(cond_used).Rrs_%s_filtered_mean];',wl_VIIRS));
      data_used_x = [VIIRS_DailyStatMatrix(cond_used).datetime];
      
      fs = 25;
      figure(h1)
      hold on
      plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'k','MarkerSize',12)
      eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx}));
      %       ax = gca;
      %       ax.XTick = xData;
      %       datetick('x','yyyy')
      grid on
      set(gcf, 'renderer','painters')
      %       end
      
      if strcmp(wl{idx},'412')
            legend('GOCI: 412 nm','MODISA: 412 nm','VIIRS: 410 nm')
      elseif strcmp(wl{idx},'443')
            legend('GOCI: 443 nm','MODISA: 443 nm','VIIRS: 443 nm')
      elseif strcmp(wl{idx},'490')
            legend('GOCI: 490 nm','MODISA: 488 nm','VIIRS: 486 nm')
      elseif strcmp(wl{idx},'555')
            legend('GOCI: 555 nm','MODISA: 547 nm','VIIRS: 551 nm')
      elseif strcmp(wl{idx},'660')
            legend('GOCI: 660 nm','MODISA: 667 nm','VIIRS: 671 nm')
      elseif strcmp(wl{idx},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            legend('GOCI: 680 nm','MODISA: 678 nm','VIIRS: 671 nm')
      end
      
      
end
%% Plot difference with respect to the noon value vs time
fs = 25;
ms = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_00],'.','MarkerSize',ms)
ylabel('1st')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_01],'.','MarkerSize',ms)
ylabel('2nd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_02],'.','MarkerSize',ms)
ylabel('3rd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_03],'.','MarkerSize',ms)
ylabel('4th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_04],'.','MarkerSize',ms)
ylabel('5th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_05],'.','MarkerSize',ms)
ylabel('6th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_06],'.','MarkerSize',ms)
ylabel('7th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_noon_07],'.','MarkerSize',ms)
ylabel('8th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

%% Plot difference with respect to the daily mean value vs time
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_00],'.','MarkerSize',ms)
ylabel('1st')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_01],'.','MarkerSize',ms)
ylabel('2nd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_02],'.','MarkerSize',ms)
ylabel('3rd')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_03],'.','MarkerSize',ms)
ylabel('4th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_04],'.','MarkerSize',ms)
ylabel('5th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_05],'.','MarkerSize',ms)
ylabel('6th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_06],'.','MarkerSize',ms)
ylabel('7th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on
subplot(2,1,2)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_diff_w_r_daily_mean_07],'.','MarkerSize',ms)
ylabel('8th')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
grid on

%% Plot difference from the daily mean for Rrs
% The difference of the mean

wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('diff_mean_00= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]);',wl{idx}))
      eval(sprintf('diff_stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]);',wl{idx}))
      
      eval(sprintf('diff_mean_01= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]);',wl{idx}))
      eval(sprintf('diff_stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]);',wl{idx}))
      
      eval(sprintf('diff_mean_02= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]);',wl{idx}))
      eval(sprintf('diff_stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]);',wl{idx}))
      
      eval(sprintf('diff_mean_03= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]);',wl{idx}))
      eval(sprintf('diff_stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]);',wl{idx}))
      
      eval(sprintf('diff_mean_04= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]);',wl{idx}))
      eval(sprintf('diff_stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]);',wl{idx}))
      
      eval(sprintf('diff_mean_05= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]);',wl{idx}))
      eval(sprintf('diff_stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]);',wl{idx}))
      
      eval(sprintf('diff_mean_06= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]);',wl{idx}))
      eval(sprintf('diff_stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]);',wl{idx}))
      
      eval(sprintf('diff_mean_07= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]);',wl{idx}))
      eval(sprintf('diff_stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]);',wl{idx}))
      
      diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
      
      diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      %       ylim([-3e-3 1e-3])
      
      str1 = sprintf('Difference\n w/r to the daily mean\n  Rrs(%s) (1/sr)',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end

%% Plot absolute difference from the daily mean for Rrs
% The difference of the mean

wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('abs_diff_mean_00= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_00= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_01= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_01= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_02= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_02= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_03= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_03= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_04= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_04= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_05= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_05= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_06= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_06= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]));',wl{idx}))
      
      eval(sprintf('abs_diff_mean_07= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]));',wl{idx}))
      eval(sprintf('abs_diff_stdv_07= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]));',wl{idx}))
      
      abs_diff_stdv_all = [abs_diff_stdv_00,abs_diff_stdv_01,abs_diff_stdv_02,abs_diff_stdv_03,abs_diff_stdv_04,abs_diff_stdv_05,abs_diff_stdv_06,abs_diff_stdv_07];
      
      abs_diff_mean_all = [abs_diff_mean_00,abs_diff_mean_01,abs_diff_mean_02,abs_diff_mean_03,abs_diff_mean_04,abs_diff_mean_05,abs_diff_mean_06,abs_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,abs_diff_mean_all,abs_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      %       ylim([-3e-3 1e-3])
      
      str1 = sprintf('Absolute difference\n w/r to the daily mean\n  Rrs(%s) (1/sr)',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end

%% Plot relative difference from the daily mean for Rrs
% The difference of the mean
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('rel_diff_mean_00= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_00= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_01= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_01= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_02= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_02= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_03= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_03= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_04= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_04= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_05= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_05= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_06= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_06= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_07= nanmean(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_07= nanstd(100*[GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to the daily mean\n  Rrs(%s) [%%]',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
      %       grid minor
      
      saveas(gcf,[savedirname 'Rel_Diff_Daily_Mean_Rrs' wl{idx}],'epsc')
end

%% Plot relative absolute difference from the daily mean for Rrs
% The difference of the mean

wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('rel_diff_mean_00= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_00= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_01= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_01= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_02= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_02= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_03= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_03= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_04= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_04= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_05= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_05= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_06= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_06= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      eval(sprintf('rel_diff_mean_07= nanmean(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      eval(sprintf('rel_diff_stdv_07= nanstd(100*abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07])./abs([GOCI_DailyStatMatrix.Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      %       ylim([-3e-3 1e-3])
      
      str1 = sprintf('Relative difference\n w/r to the daily mean\n  Rrs(%s) [%%]',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end

%% Plot difference from the noon value for Rrs
% The difference of the mean

wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('diff_mean_00= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_00]);',wl{idx}))
      eval(sprintf('diff_stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_00]);',wl{idx}))
      
      eval(sprintf('diff_mean_01= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_01]);',wl{idx}))
      eval(sprintf('diff_stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_01]);',wl{idx}))
      
      eval(sprintf('diff_mean_02= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_02]);',wl{idx}))
      eval(sprintf('diff_stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_02]);',wl{idx}))
      
      eval(sprintf('diff_mean_03= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_03]);',wl{idx}))
      eval(sprintf('diff_stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_03]);',wl{idx}))
      
      eval(sprintf('diff_mean_04= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_04]);',wl{idx}))
      eval(sprintf('diff_stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_04]);',wl{idx}))
      
      eval(sprintf('diff_mean_05= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_05]);',wl{idx}))
      eval(sprintf('diff_stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_05]);',wl{idx}))
      
      eval(sprintf('diff_mean_06= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_06]);',wl{idx}))
      eval(sprintf('diff_stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_06]);',wl{idx}))
      
      eval(sprintf('diff_mean_07= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_07]);',wl{idx}))
      eval(sprintf('diff_stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_07]);',wl{idx}))
      
      diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
      
      diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      xlim([0 9])
      %       ylim([-3e-3 1e-3])
      
      str1 = sprintf('Difference\n w/r to the noon value\n  Rrs(%s) (1/sr)',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end



%% Plot RMSE (error from the daily mean) for Rrs

wl = {'412','443','490','555','660','680'};

for idx = 1:size(wl,2)
      
      eval(sprintf('sq_diff_00 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00].^2;',wl{idx}))
      RMSE_00 = sqrt(nanmean(sq_diff_00));
      eval(sprintf('stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]);',wl{idx}))
      
      eval(sprintf('sq_diff_01 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01].^2;',wl{idx}))
      RMSE_01 = sqrt(nanmean(sq_diff_01));
      eval(sprintf('stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]);',wl{idx}))
      
      eval(sprintf('sq_diff_02 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02].^2;',wl{idx}))
      RMSE_02 = sqrt(nanmean(sq_diff_02));
      eval(sprintf('stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]);',wl{idx}))
      
      eval(sprintf('sq_diff_03 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03].^2;',wl{idx}))
      RMSE_03 = sqrt(nanmean(sq_diff_03));
      eval(sprintf('stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]);',wl{idx}))
      
      eval(sprintf('sq_diff_04 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04].^2;',wl{idx}))
      RMSE_04 = sqrt(nanmean(sq_diff_04));
      eval(sprintf('stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]);',wl{idx}))
      
      eval(sprintf('sq_diff_05 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05].^2;',wl{idx}))
      RMSE_05 = sqrt(nanmean(sq_diff_05));
      eval(sprintf('stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]);',wl{idx}))
      
      eval(sprintf('sq_diff_06 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06].^2;',wl{idx}))
      RMSE_06 = sqrt(nanmean(sq_diff_06));
      eval(sprintf('stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]);',wl{idx}))
      
      eval(sprintf('sq_diff_07 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07].^2;',wl{idx}))
      RMSE_07 = sqrt(nanmean(sq_diff_07));
      eval(sprintf('stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]);',wl{idx}))
      
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

%% Plot relative diference (difference from the daily mean) for chlor_a, poc, ag_412_mlrc

par = {'chlor_a','poc','ag_412_mlrc'};

for idx = 1:size(par,2)
      
      eval(sprintf('rel_diff_mean_00 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_00 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_01 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_01 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_02 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_02 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_03 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_03 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_04 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_04 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_05 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_05 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_06 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_06 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      eval(sprintf('rel_diff_mean_07 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      eval(sprintf('rel_diff_stdv_07 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par{idx},par{idx}))
      
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      % xlim([0 9])
      % ylim([0 4e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to the daily mean\n  %s [%%]',par{idx});
      str1 = strrep(str1,'_','\_');
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
      %       grid minor
      
      saveas(gcf,[savedirname 'Rel_Diff_Daily_Mean_' par{idx}],'epsc')
end

%% Plot RMSE (error from the daily mean) for chlor_a, poc, ag_412_mlrc

par = {'chlor_a','poc','ag_412_mlrc'};

for idx = 1:size(par,2)
      
      eval(sprintf('sq_diff_00 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_00].^2;',par{idx}))
      RMSE_00 = sqrt(nanmean(sq_diff_00));
      eval(sprintf('stdv_00= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_00]);',par{idx}))
      
      eval(sprintf('sq_diff_01 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_01].^2;',par{idx}))
      RMSE_01 = sqrt(nanmean(sq_diff_01));
      eval(sprintf('stdv_01= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_01]);',par{idx}))
      
      eval(sprintf('sq_diff_02 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_02].^2;',par{idx}))
      RMSE_02 = sqrt(nanmean(sq_diff_02));
      eval(sprintf('stdv_02= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_02]);',par{idx}))
      
      eval(sprintf('sq_diff_03 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_03].^2;',par{idx}))
      RMSE_03 = sqrt(nanmean(sq_diff_03));
      eval(sprintf('stdv_03= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_03]);',par{idx}))
      
      eval(sprintf('sq_diff_04 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_04].^2;',par{idx}))
      RMSE_04 = sqrt(nanmean(sq_diff_04));
      eval(sprintf('stdv_04= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_04]);',par{idx}))
      
      eval(sprintf('sq_diff_05 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_05].^2;',par{idx}))
      RMSE_05 = sqrt(nanmean(sq_diff_05));
      eval(sprintf('stdv_05= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_05]);',par{idx}))
      
      eval(sprintf('sq_diff_06 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_06].^2;',par{idx}))
      RMSE_06 = sqrt(nanmean(sq_diff_06));
      eval(sprintf('stdv_06= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_06]);',par{idx}))
      
      eval(sprintf('sq_diff_07 = [GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_07].^2;',par{idx}))
      RMSE_07 = sqrt(nanmean(sq_diff_07));
      eval(sprintf('stdv_07= nanstd([GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_07]);',par{idx}))
      
      stdv_all = [stdv_00,stdv_01,stdv_02,stdv_03,stdv_04,stdv_05,stdv_06,stdv_07];
      
      RMSE_all = [RMSE_00,RMSE_01,RMSE_02,RMSE_03,RMSE_04,RMSE_05,RMSE_06,RMSE_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,RMSE_all,stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
      % xlim([0 9])
      % ylim([0 4e-3])
      
      str1 = sprintf('RMSE of the Diurnal Difference\n w/r to the daily mean\n for %s',par{idx});
      str1 = strrep(str1,'_','\_');
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
end

%% Plot RMSE (error from the noon value)
for idx = 1:size(wl,2)
      eval(sprintf('sq_diff_00 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_00].^2;',wl{idx}))
      RMSE_00 = sqrt(nanmean(sq_diff_00));
      eval(sprintf('stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_00]);',wl{idx}))
      
      eval(sprintf('sq_diff_01 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_01].^2;',wl{idx}))
      RMSE_01 = sqrt(nanmean(sq_diff_01));
      eval(sprintf('stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_01]);',wl{idx}))
      
      eval(sprintf('sq_diff_02 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_02].^2;',wl{idx}))
      RMSE_02 = sqrt(nanmean(sq_diff_02));
      eval(sprintf('stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_02]);',wl{idx}))
      
      eval(sprintf('sq_diff_03 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_03].^2;',wl{idx}))
      RMSE_03 = sqrt(nanmean(sq_diff_03));
      eval(sprintf('stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_03]);',wl{idx}))
      
      eval(sprintf('sq_diff_04 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_04].^2;',wl{idx}))
      RMSE_04 = sqrt(nanmean(sq_diff_04));
      eval(sprintf('stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_04]);',wl{idx}))
      
      eval(sprintf('sq_diff_05 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_05].^2;',wl{idx}))
      RMSE_05 = sqrt(nanmean(sq_diff_05));
      eval(sprintf('stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_05]);',wl{idx}))
      
      eval(sprintf('sq_diff_06 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_06].^2;',wl{idx}))
      RMSE_06 = sqrt(nanmean(sq_diff_06));
      eval(sprintf('stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_06]);',wl{idx}))
      
      eval(sprintf('sq_diff_07 = [GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_07].^2;',wl{idx}))
      RMSE_07 = sqrt(nanmean(sq_diff_07));
      eval(sprintf('stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_noon_07]);',wl{idx}))
      
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


%% Scatter plots for Rrs -- daily
savedirname = '/Users/jconchas/Documents/Research/GOCI/Figures/';

brdf_opt = 7;

GOCI_date = [GOCI_DailyStatMatrix([GOCI_DailyStatMatrix.brdf_opt]==brdf_opt).datetime];
VIIRS_date = [VIIRS_DailyStatMatrix([VIIRS_DailyStatMatrix.brdf_opt]==brdf_opt).datetime];
AQUA_date = [AQUA_DailyStatMatrix([AQUA_DailyStatMatrix.brdf_opt]==brdf_opt).datetime];

GOCI_used = GOCI_DailyStatMatrix([GOCI_DailyStatMatrix.brdf_opt]==brdf_opt);
VIIRS_used = VIIRS_DailyStatMatrix([VIIRS_DailyStatMatrix.brdf_opt]==brdf_opt);
AQUA_used = AQUA_DailyStatMatrix([AQUA_DailyStatMatrix.brdf_opt]==brdf_opt);


% all in the same temporal grid
min_date = min([GOCI_date(1) AQUA_date(1) VIIRS_date(1)]);

max_date = max([GOCI_date(end) AQUA_date(end) VIIRS_date(end)]);

date_vec = min_date:max_date;

for idx=1:size(date_vec,2)
      if ~isempty(find(GOCI_date==date_vec(idx)))
            GOCI_date_vec(idx) = find(GOCI_date==date_vec(idx)); % indexes
      else
            GOCI_date_vec(idx) = NaN;
      end
      if ~isempty(find(AQUA_date==date_vec(idx)))
            AQUA_date_vec(idx) = find(AQUA_date==date_vec(idx));
      else
            AQUA_date_vec(idx) = NaN;
      end      
      if ~isempty(find(VIIRS_date==date_vec(idx)))
            VIIRS_date_vec(idx) = find(VIIRS_date==date_vec(idx));
      else
            VIIRS_date_vec(idx) = NaN;
      end
end

cond_VG = ~isnan(VIIRS_date_vec)&~isnan(GOCI_date_vec);
cond_AG = ~isnan(AQUA_date_vec)&~isnan(GOCI_date_vec);
cond_VA = ~isnan(VIIRS_date_vec)&~isnan(AQUA_date_vec);

%
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
            wl_AQUA = '547';
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
      [h1,ax1,leg1] = plot_sat_vs_sat('Rrs',wl{idx0},wl_VIIRS,'GOCI','VIIRS',...
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_%s_mean_mid_three]',wl{idx0})),...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_%s_filtered_mean]',wl_VIIRS)));
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_' wl{idx0}],'epsc')
      %% GOCI Comparison with AQUA
      [h2,ax2,leg2] = plot_sat_vs_sat('Rrs',wl{idx0},wl_AQUA,'GOCI','AQUA',...
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_%s_mean_mid_three]',wl{idx0})),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_%s_filtered_mean]',wl_AQUA)));
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_' wl{idx0}],'epsc')
      %% VIIRS Comparison with AQUA      % lower boundary       
      [h3,ax3,leg3] = plot_sat_vs_sat('Rrs',wl_VIIRS,wl_AQUA,'VIIRS','AQUA',...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_VIIRS)),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_AQUA)));
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_VIIRS_AQUA_' wl{idx0}],'epsc')
end

%% Scatter plots for par
savedirname = '/Users/jconchas/Documents/Research/GOCI/Figures/';

par = {'chlor_a','ag_412_mlrc','poc','angstrom','aot_865','brdf'};

for idx0 = 1:size(par,2)
      
      %% GOCI Comparison with VIIRS
      if strcmp(par{idx0},'aot_865')
            par_GOCI = par{idx0};
            par_AQUA = 'aot_869';
            par_VIIRS = 'aot_862';
      else
            par_GOCI = par{idx0};
            par_AQUA = par{idx0};
            par_VIIRS = par{idx0};
      end      
      
      [h1,ax1,leg1] = plot_sat_vs_sat(par{idx0},'NA','NA','GOCI','VIIRS',...
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_VG))).%s_mean_mid_three]',par_GOCI)),...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VG))).%s_filtered_mean]',par_VIIRS)));
      legend off
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_' par{idx0}],'epsc')

      %% GOCI Comparison with AQUA   
      [h2,ax2,leg2] = plot_sat_vs_sat(par{idx0},'NA','NA','GOCI','AQUA',...
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_AG))).%s_mean_mid_three]',par_GOCI)),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_AG))).%s_filtered_mean]',par_AQUA)));
      legend off
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_' par{idx0}],'epsc')

      %% VIIRS Comparison with AQUA
      [h3,ax3,leg3] = plot_sat_vs_sat(par{idx0},'NA','NA','VIIRS','AQUA',...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VA))).%s_filtered_mean]',par_VIIRS)),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_VA))).%s_filtered_mean]',par_AQUA)));
      legend off
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_VIIRS_AQUA_' par{idx0}],'epsc')
end

%% Rrs ratios -- monthly
savedirname = '/Users/jconchas/Documents/Research/GOCI/Figures/';

clear GOCI_date VIIRS_date AQUA_date GOCI_used VIIRS_used AQUA_used GOCI_date_vec AQUA_date_vec VIIRS_date_vec

brdf_opt = 7;

GOCI_date = [GOCI_MonthlyStatMatrix([GOCI_MonthlyStatMatrix.brdf_opt]==brdf_opt).datetime];
VIIRS_date = [VIIRS_MonthlyStatMatrix([VIIRS_MonthlyStatMatrix.brdf_opt]==brdf_opt).datetime];
AQUA_date = [AQUA_MonthlyStatMatrix([AQUA_MonthlyStatMatrix.brdf_opt]==brdf_opt).datetime];

GOCI_used = GOCI_MonthlyStatMatrix([GOCI_MonthlyStatMatrix.brdf_opt]==brdf_opt);
VIIRS_used = VIIRS_MonthlyStatMatrix([VIIRS_MonthlyStatMatrix.brdf_opt]==brdf_opt);
AQUA_used = AQUA_MonthlyStatMatrix([AQUA_MonthlyStatMatrix.brdf_opt]==brdf_opt);


% all in the same temporal grid
min_date = min([GOCI_date(1) AQUA_date(1) VIIRS_date(1)]);

max_date = max([GOCI_date(end) AQUA_date(end) VIIRS_date(end)]);

date_vec = min_date:calmonths(1):max_date;

for idx=1:size(date_vec,2)
      if ~isempty(find(GOCI_date==date_vec(idx),1))
            GOCI_date_vec(idx) = find(GOCI_date==date_vec(idx)); % indexes
      else
            GOCI_date_vec(idx) = NaN;
      end
      if ~isempty(find(AQUA_date==date_vec(idx),1))
            AQUA_date_vec(idx) = find(AQUA_date==date_vec(idx));
      else
            AQUA_date_vec(idx) = NaN;
      end      
      if ~isempty(find(VIIRS_date==date_vec(idx),1))
            VIIRS_date_vec(idx) = find(VIIRS_date==date_vec(idx));
      else
            VIIRS_date_vec(idx) = NaN;
      end
end

cond_VG = ~isnan(VIIRS_date_vec)&~isnan(GOCI_date_vec);
cond_AG = ~isnan(AQUA_date_vec)&~isnan(GOCI_date_vec);
cond_VA = ~isnan(VIIRS_date_vec)&~isnan(AQUA_date_vec);

%
wl = {'412','443','490','555','660','680'};

% ratio: GOCI/MODISA Rrs(\lambda)
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','GOCI/AQUA ratio');

x = [GOCI_used(GOCI_date_vec(find(cond_AG))).datetime];
y = [GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_412_mean_mid_three]...
      ./[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_412_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0.5 0 0.5],'LineWidth',lw)
hold on
y = [GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_443_mean_mid_three]...
      ./[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_443_mean];
plot(x(~isnan(y)),y(~isnan(y)),'b','LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_490_mean_mid_three]...
      ./[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_488_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 1],'LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_555_mean_mid_three]...
      ./[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_547_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 0],'LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_660_mean_mid_three]...
      ./[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_667_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0.5 0],'LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_680_mean_mid_three]...
      ./[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_678_mean];
plot(x(~isnan(y)),y(~isnan(y)),'r','LineWidth',lw)
legend('412','443','490','555','660','680')
xlabel('Time')
ylabel('R_{rs}(\lambda) ratio (unitless)')
title('GOCI/MODISA ratio')
grid on
% ylim([-0.001 0.017])

% ratio: GOCI/VIIRS Rrs(\lambda)
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','GOCI/AQUA ratio');

x = [GOCI_used(GOCI_date_vec(find(cond_VG))).datetime];
y = [GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_412_mean_mid_three]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_410_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0.5 0 0.5],'LineWidth',lw)
hold on
y = [GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_443_mean_mid_three]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_443_mean];
plot(x(~isnan(y)),y(~isnan(y)),'b','LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_490_mean_mid_three]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_486_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 1],'LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_555_mean_mid_three]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_551_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 0],'LineWidth',lw)
y = [GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_660_mean_mid_three]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_671_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0.5 0],'LineWidth',lw)
% y = [GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_680_mean_mid_three]...
%       ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_671_mean];
% plot(x(~isnan(y)),y(~isnan(y)),'r','LineWidth',lw)
legend('412','443','490','555','660')
xlabel('Time')
ylabel('R_{rs}(\lambda) ratio (unitless)')
title('GOCI/VIIRS ratio')
grid on
% ylim([-0.001 0.017])

% ratio: AQUA/VIIRS Rrs(\lambda)
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','AQUA/VIIRS ratio');

x = [AQUA_used(AQUA_date_vec(find(cond_VA))).datetime];
y = [AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_412_mean]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_410_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0.5 0 0.5],'LineWidth',lw)
hold on
y = [AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_443_mean]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_443_mean];
plot(x(~isnan(y)),y(~isnan(y)),'b','LineWidth',lw)
y = [AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_488_mean]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_486_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 1],'LineWidth',lw)
y = [AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_547_mean]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_551_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 0],'LineWidth',lw)
y = [AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_667_mean]...
      ./[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_671_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0.5 0],'LineWidth',lw)
% y = [AQUA_used(AQUA_date_vec(find(cond_VG))).Rrs_680_mean_mid_three]...
%       ./[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_671_mean];
% plot(x(~isnan(y)),y(~isnan(y)),'r','LineWidth',lw)
legend('412','443','490','555','660')
xlabel('Time')
ylabel('R_{rs}(\lambda) ratio (unitless)')
title('MODISA/VIIRS ratio')
grid on
% ylim([-0.001 0.017])

%% Daily AOT(865) and Angstrong
lw = 1.5;
fs = 25;
h1 = figure('Color','white','DefaultAxesFontSize',fs,'Name','AOT(865)');
xdata = [GOCI_DailyStatMatrix.datetime];
ydata = [GOCI_DailyStatMatrix.aot_865_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_DailyStatMatrix.datetime];
ydata = [AQUA_DailyStatMatrix.aot_869_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_DailyStatMatrix.datetime];
ydata = [VIIRS_DailyStatMatrix.aot_862_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
ylabel('AOT(865)')
grid on
set(gcf, 'renderer','painters')
legend('GOCI','MODISA','VIIRS')



h2 = figure('Color','white','DefaultAxesFontSize',fs,'Name','Angstrom');
xdata = [GOCI_DailyStatMatrix.datetime];
ydata = [GOCI_DailyStatMatrix.angstrom_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_DailyStatMatrix.datetime];
ydata = [AQUA_DailyStatMatrix.angstrom_filtered_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_DailyStatMatrix.datetime];
ydata = [VIIRS_DailyStatMatrix.angstrom_filtered_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
xlabel('Time')
ylabel('Angstrom')
grid on
set(gcf, 'renderer','painters')
legend('GOCI','MODISA','VIIRS')

%% Plot Monthly AOT(865) and Angstrong
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

clear GOCI_date VIIRS_date AQUA_date GOCI_used VIIRS_used AQUA_used GOCI_date_vec AQUA_date_vec VIIRS_date_vec

brdf_opt = 7;

GOCI_date = [GOCI_MonthlyStatMatrix([GOCI_MonthlyStatMatrix.brdf_opt]==brdf_opt).datetime];
VIIRS_date = [VIIRS_MonthlyStatMatrix([VIIRS_MonthlyStatMatrix.brdf_opt]==brdf_opt).datetime];
AQUA_date = [AQUA_MonthlyStatMatrix([AQUA_MonthlyStatMatrix.brdf_opt]==brdf_opt).datetime];

GOCI_used = GOCI_MonthlyStatMatrix([GOCI_MonthlyStatMatrix.brdf_opt]==brdf_opt);
VIIRS_used = VIIRS_MonthlyStatMatrix([VIIRS_MonthlyStatMatrix.brdf_opt]==brdf_opt);
AQUA_used = AQUA_MonthlyStatMatrix([AQUA_MonthlyStatMatrix.brdf_opt]==brdf_opt);


% all in the same temporal grid
min_date = min([GOCI_date(1) AQUA_date(1) VIIRS_date(1)]);

max_date = max([GOCI_date(end) AQUA_date(end) VIIRS_date(end)]);

date_vec = min_date:calmonths(1):max_date;

for idx=1:size(date_vec,2)
      if ~isempty(find(GOCI_date==date_vec(idx),1))
            GOCI_date_vec(idx) = find(GOCI_date==date_vec(idx)); % indexes
      else
            GOCI_date_vec(idx) = NaN;
      end
      if ~isempty(find(AQUA_date==date_vec(idx),1))
            AQUA_date_vec(idx) = find(AQUA_date==date_vec(idx));
      else
            AQUA_date_vec(idx) = NaN;
      end      
      if ~isempty(find(VIIRS_date==date_vec(idx),1))
            VIIRS_date_vec(idx) = find(VIIRS_date==date_vec(idx));
      else
            VIIRS_date_vec(idx) = NaN;
      end
end

cond_VG = ~isnan(VIIRS_date_vec)&~isnan(GOCI_date_vec);
cond_AG = ~isnan(AQUA_date_vec)&~isnan(GOCI_date_vec);
cond_VA = ~isnan(VIIRS_date_vec)&~isnan(AQUA_date_vec);

% aot_865
fs = 25;
h1 = figure('Color','white','DefaultAxesFontSize',fs,'Name','AOT(865)');
xdata = [GOCI_used.datetime];
ydata = [GOCI_used.aot_865_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_used.datetime];
ydata = [AQUA_used.aot_869_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_used.datetime];
ydata = [VIIRS_used.aot_862_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
ylabel('AOT(865)')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerie_AOT_865'],'epsc')

% angstrom
h2 = figure('Color','white','DefaultAxesFontSize',fs,'Name','Angstrom');
xdata = [GOCI_used.datetime];
ydata = [GOCI_used.angstrom_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_used.datetime];
ydata = [AQUA_used.angstrom_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_used.datetime];
ydata = [VIIRS_used.angstrom_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
xlabel('Time')
ylabel('Angstrom')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerie_Angstrom'],'epsc')

% Plot Monthly Chl, POC and ag_412_mlrc
% chlor_a
fs = 25;
h1 = figure('Color','white','DefaultAxesFontSize',fs,'Name','Chl-a');
xdata = [GOCI_MonthlyStatMatrix.datetime];
ydata = [GOCI_MonthlyStatMatrix.chlor_a_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_MonthlyStatMatrix.datetime];
ydata = [AQUA_MonthlyStatMatrix.chlor_a_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_MonthlyStatMatrix.datetime];
ydata = [VIIRS_MonthlyStatMatrix.chlor_a_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
ylabel('Chl-{\ita}')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerie_chlor_a'],'epsc')

% poc
h2 = figure('Color','white','DefaultAxesFontSize',fs,'Name','POC');
xdata = [GOCI_MonthlyStatMatrix.datetime];
ydata = [GOCI_MonthlyStatMatrix.poc_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_MonthlyStatMatrix.datetime];
ydata = [AQUA_MonthlyStatMatrix.poc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_MonthlyStatMatrix.datetime];
ydata = [VIIRS_MonthlyStatMatrix.poc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
xlabel('Time')
ylabel('POC')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerie_poc'],'epsc')

% ag_412_mlrc
h3 = figure('Color','white','DefaultAxesFontSize',fs,'Name','ag_412_mlrc');
xdata = [GOCI_MonthlyStatMatrix.datetime];
ydata = [GOCI_MonthlyStatMatrix.ag_412_mlrc_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_MonthlyStatMatrix.datetime];
ydata = [AQUA_MonthlyStatMatrix.ag_412_mlrc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_MonthlyStatMatrix.datetime];
ydata = [VIIRS_MonthlyStatMatrix.ag_412_mlrc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
xlabel('Time')
ylabel('a_{g:mlrc}(412)')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerie_ag_412_mlrc'],'epsc')

% brdf
h4 = figure('Color','white','DefaultAxesFontSize',fs,'Name','brdf');
xdata = [GOCI_MonthlyStatMatrix.datetime];
ydata = [GOCI_MonthlyStatMatrix.brdf_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
xdata = [AQUA_MonthlyStatMatrix.datetime];
ydata = [AQUA_MonthlyStatMatrix.brdf_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
xdata = [VIIRS_MonthlyStatMatrix.datetime];
ydata = [VIIRS_MonthlyStatMatrix.brdf_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
xlabel('Time')
ylabel('BRDF')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerie_brdf'],'epsc')
%% Testing VIIRS

figure
subplot(5,1,1)
plot([VIIRS_Data.datetime],[VIIRS_Data.Rrs_671_filtered_mean],'o')
title('Rrs\_671')

subplot(5,1,2)
plot([VIIRS_Data.datetime],[VIIRS_Data.senz_center_value],'o')
title('senz')

subplot(5,1,3)
plot([VIIRS_Data.datetime],[VIIRS_Data.sena_center_value],'o')
title('sena')

subplot(5,1,4)
plot([VIIRS_Data.datetime],[VIIRS_Data.solz_center_value],'o')
title('solz')

subplot(5,1,5)
plot([VIIRS_Data.datetime],[VIIRS_Data.sola_center_value],'o')
title('sola')

%% GOCI L3
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Comparison with L3');

brdf_opt =7;
cond = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt;
x = [GOCI_MonthlyStatMatrix(cond).datetime];
y = [GOCI_MonthlyStatMatrix(cond).Rrs_412_mean_mid_three];
plot(x(~isnan(y)),y(~isnan(y)),'--','Color',[0.5 0 0.5],'LineWidth',lw)
hold on
y = [GOCI_MonthlyStatMatrix(cond).Rrs_443_mean_mid_three];
plot(x(~isnan(y)),y(~isnan(y)),'b--','LineWidth',lw)
y = [GOCI_MonthlyStatMatrix(cond).Rrs_490_mean_mid_three];
plot(x(~isnan(y)),y(~isnan(y)),'--','Color',[0 0.5 1],'LineWidth',lw)
y = [GOCI_MonthlyStatMatrix(cond).Rrs_555_mean_mid_three];
plot(x(~isnan(y)),y(~isnan(y)),'--','Color',[0 0.5 0],'LineWidth',lw)
y = [GOCI_MonthlyStatMatrix(cond).Rrs_660_mean_mid_three];
plot(x(~isnan(y)),y(~isnan(y)),'--','Color',[1 0.5 0.5],'LineWidth',lw)
ylim([-0.001 0.017])

grid on
ax = gca;
ax.YAxis.Exponent = 0;
ax.YAxis.MinorTick = 'on';
ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):.001:ax.YAxis.Limits(2);
ax.YTick = [0.000 0.005 0.010 0.015];
ax.YTickLabel = {'0.000','0.005','0.010','0.015'};
xlim(datenum(datetime([2012 2017],[1 1],[1 1])))
ax.XTickLabel = {'2013','2014','2015','2016',''};

ax.TickLabelInterpreter = 'none';

% VIIRS L3
fs = 16;
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','VIIRS Rrs');

brdf_opt =7;
cond = [VIIRS_MonthlyStatMatrix.brdf_opt] == brdf_opt;
x = [VIIRS_MonthlyStatMatrix(cond).datetime];
y = [VIIRS_MonthlyStatMatrix(cond).Rrs_410_mean];
plot(x(~isnan(y)),y(~isnan(y)),'-.','Color',[0.5 0 0.5],'LineWidth',lw)
hold on
y = [VIIRS_MonthlyStatMatrix(cond).Rrs_443_mean];
plot(x(~isnan(y)),y(~isnan(y)),'b-.','LineWidth',lw)
y = [VIIRS_MonthlyStatMatrix(cond).Rrs_486_mean];
plot(x(~isnan(y)),y(~isnan(y)),'-.','Color',[0 0.5 1],'LineWidth',lw)
y = [VIIRS_MonthlyStatMatrix(cond).Rrs_551_mean];
plot(x(~isnan(y)),y(~isnan(y)),'-.','Color',[0 0.5 0],'LineWidth',lw)
y = [VIIRS_MonthlyStatMatrix(cond).Rrs_671_mean];
plot(x(~isnan(y)),y(~isnan(y)),'-.','Color',[1 0.5 0.5],'LineWidth',lw)
ylim([-0.001 0.017])

grid on
ax = gca;
ax.YAxis.Exponent = 0;
ax.YAxis.MinorTick = 'on';
ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):.001:ax.YAxis.Limits(2);
ax.YTick = [0.000 0.005 0.010 0.015];
ax.YTickLabel = {'0.000','0.005','0.010','0.015'};
xlim(datenum(datetime([2012 2017],[1 1],[1 1])))
ax.XTickLabel = {'2013','2014','2015','2016',''};

ax.TickLabelInterpreter = 'none';

% set(gcf, 'renderer','painters')


% AQUA L3
fs = 16;
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','VIIRS Rrs');

brdf_opt =7;
cond = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt;
x = [AQUA_MonthlyStatMatrix(cond).datetime];
y = [AQUA_MonthlyStatMatrix(cond).Rrs_412_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0.5 0 0.5],'LineWidth',lw)
hold on
y = [AQUA_MonthlyStatMatrix(cond).Rrs_443_mean];
plot(x(~isnan(y)),y(~isnan(y)),'b','LineWidth',lw)
y = [AQUA_MonthlyStatMatrix(cond).Rrs_488_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 1],'LineWidth',lw)
y = [AQUA_MonthlyStatMatrix(cond).Rrs_547_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[0 0.5 0],'LineWidth',lw)
y = [AQUA_MonthlyStatMatrix(cond).Rrs_667_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0.5 0.5],'LineWidth',lw)
y = [AQUA_MonthlyStatMatrix(cond).Rrs_678_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0.5 0.5],'LineWidth',lw)

ylim([-0.001 0.017])

grid on
ax = gca;
ax.YAxis.Exponent = 0;
ax.YAxis.MinorTick = 'on';
ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):.001:ax.YAxis.Limits(2);
ax.YTick = [0.000 0.005 0.010 0.015];
ax.YTickLabel = {'0.000','0.005','0.010','0.015'};
xlim
% xlim(datenum(datetime([2002 2017],[1 1],[1 1])))
% ax.XTickLabel = {'2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016',''};

ax.TickLabelInterpreter = 'none';

% set(gcf, 'renderer','painters')
legend('GOCI 412','GOCI 443','GOCI 490','GOCI 555','GOCI 660',...
	'MODISA 412','MODISA 443','MODISA 488','MODISA 547','MODISA 667',...
	'VIIRS 410','VIIRS 443','VIIRS 486','VIIRS 551','VIIRS 671',...
	'Location','EastOutside')

%%

figure
plot([VIIRS_Data.datetime],[VIIRS_Data.senz_center_value],'.')
title('VIIRS')
sum([VIIRS_Data.senz_center_value]>=60)
size(VIIRS_Data)

figure
plot([AQUA_Data.datetime],[AQUA_Data.senz_center_value],'.')
title('AQUA')
sum([AQUA_Data.senz_center_value]>=60)
size(AQUA_Data)

figure
plot([GOCI_Data.datetime],[GOCI_Data.senz_center_value],'.')
title('GOCI')
sum([GOCI_Data.senz_center_value]>=60)
size(GOCI_Data)
%% Run A = VIIRS_DailyStatMatrix w/ an w/o senz criteria
figure
cond = ~isnan([A.Rrs_551_filtered_mean]);
plot([A.datetime],[A.Rrs_551_filtered_mean],'-*')
hold on
cond = ~isnan([B.Rrs_551_filtered_mean]);
plot([B.datetime],[B.Rrs_551_filtered_mean],'-or')
%% VIIRS
figure
cond = [VIIRS_Data.brdf_opt]==7;
plot([VIIRS_Data(cond).datetime],[VIIRS_Data(cond).Rrs_551_filtered_mean],'-*')
hold on
cond = [VIIRS_DailyStatMatrix.brdf_opt]==7;
plot([VIIRS_DailyStatMatrix(cond).datetime],[VIIRS_DailyStatMatrix(cond).Rrs_551_filtered_mean],'-o')
%% GOCI
figure
plot([GOCI_Data.datetime],[GOCI_Data.Rrs_555_filtered_mean],'-*')
hold on
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_555_mean_mid_three],'-o')


%%

VIIRS_Data(1195).Rrs_551_filtered_mean
VIIRS_Data(1196).Rrs_551_filtered_mean

VIIRS_DailyStatMatrix(562).Rrs_551_filtered_mean


VIIRS_Data(1195).center_lon
VIIRS_Data(1196).center_lon
VIIRS_DailyStatMatrix(562).datetime

%%
figure('Color','white')
hf2 = gcf;
ax = worldmap([20 50],[115 145]);
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
%%
figure(hf2)
hold on

% GOCI
UL_LAT = GOCI_Data(1).latitude_max;
UL_LON = GOCI_Data(1).longitude_min;
UR_LAT = GOCI_Data(1).latitude_max;
UR_LON = GOCI_Data(1).longitude_max;
LL_LAT = GOCI_Data(1).latitude_min;
LL_LON = GOCI_Data(1).longitude_min;
LR_LAT = GOCI_Data(1).latitude_min;
LR_LON = GOCI_Data(1).longitude_max;

geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'red','FaceAlpha','.3');
%%
% idx1=1195;
% idx2=1196;

cond = [VIIRS_Data.brdf_opt]==7;
I = find(cond);

idx1=I(1177);
idx2=I(1178);

% VIIRS idx 1
UL_LAT = VIIRS_Data(idx1).latitude_max;
UL_LON = VIIRS_Data(idx1).longitude_min;
UR_LAT = VIIRS_Data(idx1).latitude_max;
UR_LON = VIIRS_Data(idx1).longitude_max;
LL_LAT = VIIRS_Data(idx1).latitude_min;
LL_LON = VIIRS_Data(idx1).longitude_min;
LR_LAT = VIIRS_Data(idx1).latitude_min;
LR_LON = VIIRS_Data(idx1).longitude_max;

geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'blue','FaceAlpha','.3');

%% VIIRS idx 2
UL_LAT = VIIRS_Data(idx2).latitude_max;
UL_LON = VIIRS_Data(idx2).longitude_min;
UR_LAT = VIIRS_Data(idx2).latitude_max;
UR_LON = VIIRS_Data(idx2).longitude_max;
LL_LAT = VIIRS_Data(idx2).latitude_min;
LL_LON = VIIRS_Data(idx2).longitude_min;
LR_LAT = VIIRS_Data(idx2).latitude_min;
LR_LON = VIIRS_Data(idx2).longitude_max;

geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'green','FaceAlpha','.3');

title(sprintf('idx1=%i ; idx2=%i',idx1,idx2))

%% from the ticket
L2NORTH=29.4736; % lat max
L2SOUTH=24.2842; % lat min
L2WEST=131.9067; % lon min
L2EAST=142.3193; % lon max


% VIIRS idx 2
UL_LAT = L2NORTH;
UL_LON = L2WEST;
UR_LAT = L2NORTH;
UR_LON = L2EAST;
LL_LAT = L2SOUTH;
LL_LON = L2WEST;
LR_LAT = L2SOUTH;
LR_LON = L2EAST;

geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'blue','FaceAlpha','.3');

title(sprintf('idx1=%i ; idx2=%i',idx1,idx2))

%% AQUA
figure
plot([AQUA_Data.datetime],[AQUA_Data.Rrs_547_filtered_mean],'-*')
hold on
plot([AQUA_DailyStatMatrix.datetime],[AQUA_DailyStatMatrix.Rrs_547_filtered_mean],'-o')

%% GOCI
figure('Color','white')
hf2 = gcf;
ax = worldmap([20 50],[115 145]);
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')

figure(hf2)
hold on


UL_LAT = GOCI_Data(1).latitude_max;
UL_LON = GOCI_Data(1).longitude_min;
UR_LAT = GOCI_Data(1).latitude_max;
UR_LON = GOCI_Data(1).longitude_max;
LL_LAT = GOCI_Data(1).latitude_min;
LL_LON = GOCI_Data(1).longitude_min;
LR_LAT = GOCI_Data(1).latitude_min;
LR_LON = GOCI_Data(1).longitude_max;

% From MTL file
geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'red','FaceAlpha','.3');
%%

idx1=1194;
idx2=1197;

% AQUA idx 1
UL_LAT = AQUA_Data(idx1).latitude_max;
UL_LON = AQUA_Data(idx1).longitude_min;
UR_LAT = AQUA_Data(idx1).latitude_max;
UR_LON = AQUA_Data(idx1).longitude_max;
LL_LAT = AQUA_Data(idx1).latitude_min;
LL_LON = AQUA_Data(idx1).longitude_min;
LR_LAT = AQUA_Data(idx1).latitude_min;
LR_LON = AQUA_Data(idx1).longitude_max;

geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'blue','FaceAlpha','.3');

% AQUA idx 2
UL_LAT = AQUA_Data(idx2).latitude_max;
UL_LON = AQUA_Data(idx2).longitude_min;
UR_LAT = AQUA_Data(idx2).latitude_max;
UR_LON = AQUA_Data(idx2).longitude_max;
LL_LAT = AQUA_Data(idx2).latitude_min;
LL_LON = AQUA_Data(idx2).longitude_min;
LR_LAT = AQUA_Data(idx2).latitude_min;
LR_LON = AQUA_Data(idx2).longitude_max;

geoshow([UL_LAT UR_LAT LR_LAT LL_LAT UL_LAT],...
      [UL_LON UR_LON LR_LON LL_LON UL_LON],...
      'DisplayType','polygon', 'FaceColor', 'green','FaceAlpha','.3');

title(sprintf('idx1=%i ; idx2=%i',idx1,idx2))

%%

figure
plot([AQUA_Data.datetime],[AQUA_Data.unflagged_pixel_count],'*')

hold on
plot([AQUA_Data.datetime],[AQUA_Data.flagged_pixel_count],'*r')
plot([AQUA_Data.datetime],[AQUA_Data.pixel_count],'*g')

plot([AQUA_Data.datetime],[AQUA_Data.Rrs_667_valid_pixel_count],'*c')
plot([AQUA_Data.datetime],[AQUA_Data.Rrs_667_filtered_valid_pixel_count],'*m')


% plot([AQUA_DailyStatMatrix.datetime],[AQUA_DailyStatMatrix.Rrs_667_N_mean],'*c')
%% testing VIIRS
figure
subplot(2,1,1)
cond = ~isnan([VIIRS_DailyStatMatrix.Rrs_671_filtered_mean]) & ...
      [VIIRS_DailyStatMatrix.Rrs_671_median_CV]<10;
% plot([VIIRS_Data.datetime],[VIIRS_Data.Rrs_671_filtered_mean],'*-')
hold on
plot([VIIRS_DailyStatMatrix(cond).datetime],[VIIRS_DailyStatMatrix(cond).Rrs_671_filtered_mean],'r*-')
hold on
plot([VIIRS_MonthlyStatMatrix.datetime],[VIIRS_MonthlyStatMatrix.Rrs_671_mean],'g*-')
xlim([datenum(datetime(2012,1,1)) datenum(datetime(2017,1,1))])
ylim([0 .005])
grid on
title('VIIRS, Rrs(671)')


subplot(2,1,2)
plot([VIIRS_DailyStatMatrix(cond).datetime],[VIIRS_DailyStatMatrix(cond).Rrs_671_median_CV],'m*-')
xlim([datenum(datetime(2012,1,1)) datenum(datetime(2017,1,1))])
ylim([0 1])
grid on
title('VIIRS, median CV')
%%
figure
hist([VIIRS_DailyStatMatrix(cond).Rrs_671_median_CV])
% subplot(3,1,3)
% plot([VIIRS_MonthlyStatMatrix.datetime],[VIIRS_MonthlyStatMatrix.Rrs_671_mean_N],'*-')
% xlim([datenum(datetime(2012,1,1)) datenum(datetime(2017,1,1))])
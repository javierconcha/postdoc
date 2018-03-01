
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')
addpath('/Users/jconchas/Documents/MATLAB')
addpath('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal');
%% Load GOCI data
clear GOCI_Data
tic
% fileID = fopen('./GOCI_TemporalAnly/GOCI_ROI_STATS/file_list.txt');
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_TemporalAnly/GOCI_ROI_STATS_R2018_vcal_aqua/file_list_BRDF7.txt'); % new R2018.0 with vcal from AQUA

s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'GOCI';
for idx0=1:size(s{1},1)
      str1 = sprintf('%3.2f',100*idx0/size(s{1},1));                  
      waitbar(idx0/size(s{1},1),h1,['Uploading GOCI Data: ' str1 '%'])
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_TemporalAnly/GOCI_ROI_STATS_R2018_vcal_aqua/' s{1}{idx0}];
      GOCI_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc

%% Load Aqua data
clear AQUA_Data
tic
% fileID = fopen('./GOCI_TemporalAnly/AQUA_ROI_STATS/file_list.txt');
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_TemporalAnly/AQUA_ROI_STATS_R2018/file_list_BRDF7.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'AQUA';
for idx0=1:size(s{1},1)
      str1 = sprintf('%3.2f',100*idx0/size(s{1},1));                  
      waitbar(idx0/size(s{1},1),h1,['Uploading AQUA Data: ' str1 '%'])
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_TemporalAnly/AQUA_ROI_STATS_R2018/' s{1}{idx0}];
      AQUA_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end

close(h1)
toc
save('GOCI_TempAnly.mat','AQUA_Data','-append')
% Load VIIRS data
clear VIIRS_Data
tic
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_TemporalAnly/VIIRS_ROI_STATS_R2018/file_list_BRDF7.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'VIIRS';
for idx0=1:size(s{1},1)
      str1 = sprintf('%3.2f',100*idx0/size(s{1},1));                  
      waitbar(idx0/size(s{1},1),h1,['Uploading VIIRS Data: ' str1 '%'])
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_TemporalAnly/VIIRS_ROI_STATS_R2018/' s{1}{idx0}];
      VIIRS_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc
%
tic
save('GOCI_TempAnly.mat','GOCI_Data','-v7.3')
save('GOCI_TempAnly.mat','AQUA_Data','-append')
save('GOCI_TempAnly.mat','VIIRS_Data','-append')
toc
%%
load('GOCI_TempAnly.mat','GOCI_Data')

%% Time series Rrs -- All

% initialization
total_px_GOCI = GOCI_Data(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels
solz_lim = 75;
xrange = 0.02;
% startDate = datenum('01-01-2011');
startDate = datenum('05-15-2011');
endDate = datenum('12-31-2017');
xData = startDate:datenum(years(1)):endDate;
%% Plot
lw = 1.5;
fs = 25;
ms = 5;

fs = 24;
h1 =  figure('Color','white','DefaultAxesFontSize',fs);
% Rrs_412
cond1 = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
cond2 = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond3 = [GOCI_Data.center_ze] <= solz_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data.Rrs_412_filtered_mean];
data_used = data_used(cond_used);


figure(h1)
subplot(6,1,1)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(412)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(412) [sr^{-1}]','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f [sr^{-1}]\nmax: %2.5f [sr^{-1}]\nmin: %2.5f [sr^{-1}]\nsd: %2.5f [sr^{-1}]',...
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
cond3 = [GOCI_Data.center_ze] <= solz_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data.Rrs_443_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,2)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(443)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(443) [sr^{-1}]','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f [sr^{-1}]\nmax: %2.5f [sr^{-1}]\nmin: %2.5f [sr^{-1}]\nsd: %2.5f [sr^{-1}]',...
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
cond3 = [GOCI_Data.center_ze] <= solz_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data.Rrs_490_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,3)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(490)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(490) [sr^{-1}]','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f [sr^{-1}]\nmax: %2.5f [sr^{-1}]\nmin: %2.5f [sr^{-1}]\nsd: %2.5f [sr^{-1}]',...
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
cond3 = [GOCI_Data.center_ze] <= solz_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data.Rrs_555_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,4)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(555)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(555) [sr^{-1}]','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f [sr^{-1}]\nmax: %2.5f [sr^{-1}]\nmin: %2.5f [sr^{-1}]\nsd: %2.5f [sr^{-1}]',...
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
cond3 = [GOCI_Data.center_ze] <= solz_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data.Rrs_660_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,5)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(660)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(660) [sr^{-1}]','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f [sr^{-1}]\nmax: %2.5f [sr^{-1}]\nmin: %2.5f [sr^{-1}]\nsd: %2.5f [sr^{-1}]',...
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
cond3 = [GOCI_Data.center_ze] <= solz_lim;
cond_used = cond1&cond2&cond3;

data_used = [GOCI_Data.Rrs_680_filtered_mean];
data_used = data_used(cond_used);


figure(h1)
subplot(6,1,6)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'.')
ax = gca;
ax.XTick = xData;
datetick('x','yyyy')%
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(680)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('R_{rs}(680) [sr^{-1}]','FontSize',fs)
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.5f [sr^{-1}]\nmax: %2.5f [sr^{-1}]\nmin: %2.5f [sr^{-1}]\nsd: %2.5f [sr^{-1}]',...
      N,nanmean(data_used),nanmax(data_used),nanmin(data_used),std(data_used));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

%% Time Serie: GOCI Rrs vs time, and solar zenith angle vs time -- filtered except negative

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

solz_lim = 75;
senz_lim = 60;
CV_lim = 0.25;
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels

% CV_lim = 0.3;
% CV_lim = nanmean([GOCI_Data.median_CV])+nanstd([GOCI_Data.median_CV]);
brdf_opt = 7;


ms = 5;

wl_vec = {'412','443','490','555','660','680'};

for idx = 1:size(wl_vec,2)
     %% 
      eval(sprintf('cond_nan = ~isnan([GOCI_Data.Rrs_%s_filtered_mean]);',wl_vec{idx}));
      eval(sprintf('cond_area = [GOCI_Data.Rrs_%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',wl_vec{idx}));
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_CV = [GOCI_Data.median_CV]<=CV_lim;
      cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
      cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
      
      % plot time serie
      fs = 25;
      h1 = figure('Color','white','DefaultAxesFontSize',fs,'units','normalized','outerposition',[0 0 1 1]);
      
      for idx_tod = 0:7
            cond_tod = (hour([GOCI_Data.datetime])==idx_tod); % cond for time of the day
            cond_plot = cond_used&cond_tod;
            eval(sprintf('data_used_y = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx}));
            data_used_y = data_used_y(cond_plot);
            
            data_used_x = [GOCI_Data.datetime];
            data_used_x = data_used_x(cond_plot);
            
            figure(h1)
            subplot(2,1,1)
            hold on
            if idx_tod==0
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'or','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==1
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'og','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==2
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'ob','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==3
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'ok','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==4
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'oc','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==5
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'om','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==6
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==7
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            end
            
            
            subplot(2,1,2)
            hold on
            
            if idx_tod==0
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'or','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==1
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'og','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==2
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'ob','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==3
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'ok','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==4
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'oc','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==5
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'om','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==6
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==7
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            end
      end
      
      subplot(2,1,1)
      hold on
      eval(sprintf('ylabel(''R_{rs}(%s) [sr^{-1}]'',''FontSize'',fs)',wl_vec{idx}));
      ax = gca;
      ax.XTick = xData;
      datetick('x','yyyy')%
      %       ax.YAxis.TickLabelFormat = '%,.0f';
      %       ylim([-0.01 0.03])
      grid on
      
      % to create dummy data and create a custon legend
      if idx==1
            p = zeros(8,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','southeast')
      end
      
      subplot(2,1,2)
      ylabel('Solar Zenith Angle [^o]','FontSize',fs)
      xlabel('Time','FontSize',fs)
      ylim([0 80])
      ax = gca;
      ax.XTick = xData;
      datetick('x','yyyy')%
      grid on
      
      % save fullscreen figure
      %       set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 30 20])
      set(gcf,'PaperPositionMode', 'auto')
      print('-depsc2', [savedirname 'TimeSerie_Rrs' wl_vec{idx}])
      saveas(gcf,[savedirname 'TimeSerie_Rrs' wl_vec{idx}],'epsc')
      
      % histogram
      N = nansum(cond_used);
      eval(sprintf('data_used_y = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx}));
      data_used_y = data_used_y((cond_used));
      % fs = 20;
      figure('Color','white','DefaultAxesFontSize',fs);
      [counts,centers] = hist(data_used_y,50);
      plot(centers,counts*100/N,'b-','LineWidth',1.5)
      ylabel('Frequency (%)','FontSize',fs)
      eval(sprintf('xlabel(''R_{rs}(%s) [sr^{-1}]'',''FontSize'',fs)',wl_vec{idx}));
      % xlim([-1*xrange xrange])
      
      str1 = sprintf('N: %i\nmean: %2.5f \nmax: %2.5f \nmin: %2.5f \nSD: %2.5f',...
            N,nanmean(data_used_y),nanmax(data_used_y),nanmin(data_used_y),std(data_used_y));
      
      xLimits = get(gca,'XLim');
      yLimits = get(gca,'YLim');
%       xLoc = xLimits(1)+0.02*(xLimits(2)-xLimits(1));
      xLoc = xLimits(1)+0.65*(xLimits(2)-xLimits(1));
      yLoc = yLimits(1)+0.8*(yLimits(2)-yLimits(1));
      figure(gcf)
      hold on
      text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
      grid on
      
      saveas(gcf,[savedirname 'Hist_Rrs' wl_vec{idx}],'epsc')
      
end

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

%% Time serie: GOCI chlor_a, ag_412_mlrc, poc -- filtered except negative

% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

% solz_lim = 90;
% senz_lim = 60;
% CV_lim = 0.3;
%
% brdf_opt = 7;

par_vec = {'chlor_a','ag_412_mlrc', 'poc','solz','senz'};
% par_vec = {'solz'};

for idx = 1:size(par_vec,2)
      
      if strcmp(par_vec{idx},'chlor_a')
            par_char = 'Chlor-{\ita} [mg m^{-3}]';
      elseif strcmp(par_vec{idx},'ag_412_mlrc')
            par_char = 'a_{g}(412) [m^{-1}]';
      elseif strcmp(par_vec{idx},'poc')
            par_char = 'POC [mg m^{-3}]';
      elseif strcmp(par_vec{idx},'solz')
            par_char = 'Solar Zenith Angle [^o]';
      elseif strcmp(par_vec{idx},'senz')
            par_char = 'Sensor Zenith Angle [^o]';
      end
      
      
      eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx}));
      eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx}));
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_CV = [GOCI_Data.median_CV]<=CV_lim;
      cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
      cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
      
      % plot time serie
      fs = 25;
      h1 = figure('Color','white','DefaultAxesFontSize',fs,'units','normalized','outerposition',[0 0 1 1]);
      
      for idx_tod = 0:7
            cond_tod = (hour([GOCI_Data.datetime])==idx_tod); % cond for time of the day
            cond_plot = cond_used&cond_tod;
            eval(sprintf('data_used_y = [GOCI_Data.%s_filtered_mean];',par_vec{idx}));
            data_used_y = data_used_y(cond_plot);
            data_used_x = [GOCI_Data.datetime];
            data_used_x = data_used_x(cond_plot);
            
            figure(h1)
            subplot(2,1,1)
            hold on
            if idx_tod==0
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'or','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==1
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'og','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==2
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'ob','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==3
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'ok','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==4
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'oc','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==5
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'om','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==6
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==7
                  plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            end
            
            subplot(2,1,2)
            hold on
            if idx_tod==0
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'or','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==1
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'og','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==2
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'ob','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==3
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'ok','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==4
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'oc','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==5
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'om','MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==6
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            elseif idx_tod==7
                  plot([GOCI_Data(cond_plot).datetime],[GOCI_Data(cond_plot).solz_center_value],'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            end
      end
      
      subplot(2,1,1)
      hold on
      eval(sprintf('ylabel(''%s'',''FontSize'',fs)',par_char));
      ax = gca;
      ax.XTick = xData;
      datetick('x','yyyy')%
      %       ax.YAxis.TickLabelFormat = '%,.0f';
      %       ylim([-0.01 0.03])
      grid on
      
      if idx==1
            p = zeros(4,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','southeast')
      end
      
      subplot(2,1,2)
      hold on
      ylabel('Solar Zenith Angle [^o]','FontSize',fs)
      xlabel('Time','FontSize',fs)
      ylim([0 100])
      ax = gca;
      ax.XTick = xData;
      datetick('x','yyyy')%
      grid on
      
      
      %% label seasons
      hold on
      
      % winter
      x_wi = [datenum(2010:2017,11,30);datenum(2011:2018,02,28);...
            datenum(2011:2018,02,28);datenum(2010:2017,11,30)];
      y=get(gca,'YLim');
      y_wi = repmat([0;0;y(2);y(2)],1,size(x_wi,2));
      patch('XData',x_wi,'YData',y_wi,'FaceColor','none','linestyle','--')
      
      xloc = x_wi(1,2:end-1)+365*0.6/4/2;
      yloc = repmat(y(2),1,size(xloc,2));
      text(xloc,yloc*1.03,'wi','FontSize',20)
      
      % spring
      x_sp = [datenum(2011:2018,02,28);datenum(2011:2018,05,31);...
            datenum(2011:2018,05,31);datenum(2011:2018,02,28)];
      y=get(gca,'YLim');
      y_sp = repmat([0;0;y(2);y(2)],1,size(x_sp,2));
      patch('XData',x_sp,'YData',y_sp,'FaceColor','none','linestyle','--')
      
      xloc = x_sp(1,1:end-2)+365*0.6/4/2;
      yloc = repmat(y(2),1,size(xloc,2));
      text(xloc,yloc*1.03,'sp','FontSize',20)
      
      % summer
      x_su = [datenum(2011:2018,05,31);datenum(2011:2018,08,31);...
            datenum(2011:2018,08,31);datenum(2011:2018,05,31)];
      y=get(gca,'YLim');
      y_su = repmat([0;0;y(2);y(2)],1,size(x_su,2));
      patch('XData',x_su,'YData',y_su,'FaceColor','none','linestyle','--')
      
      xloc = x_su(1,1:end-2)+365*0.6/4/2;
      yloc = repmat(y(2),1,size(xloc,2));
      text(xloc,yloc*1.03,'su','FontSize',20)
      
      % fall
      x_fa = [datenum(2011:2018,08,31);datenum(2011:2018,11,30);...
            datenum(2011:2018,11,30);datenum(2011:2018,08,31)];
      y=get(gca,'YLim');
      y_fa = repmat([0;0;y(2);y(2)],1,size(x_fa,2));
      patch('XData',x_fa,'YData',y_fa,'FaceColor','none','linestyle','--')
      
      xloc = x_fa(1,1:end-2)+365*0.6/4/2;
      yloc = repmat(y(2),1,size(xloc,2));
      text(xloc,yloc*1.03,'fa','FontSize',20)
      
      %% save fullscreen figure
      %       set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 30 20])
      set(gcf,'PaperPositionMode', 'auto')
      %       print('-depsc2', [savedirname 'TimeSerie_Rrs' par_vec{idx}])
      saveas(gcf,[savedirname 'TimeSerie_' par_vec{idx}],'epsc')
      
      %% histogram
      N = nansum(cond_used);
      eval(sprintf('data_used_y = [GOCI_Data.%s_filtered_mean];',par_vec{idx}));
      data_used_y = data_used_y(cond_used);
      % fs = 20;
      figure('Color','white','DefaultAxesFontSize',fs);
      [counts,centers] = hist(data_used_y,50);
      plot(centers,counts*100/N,'b-','LineWidth',1.5)
      ylabel('Frequency (%)','FontSize',fs)
      eval(sprintf('xlabel(''%s'',''FontSize'',fs)',par_char));
      % xlim([-1*xrange xrange])
      
      str1 = sprintf('N: %i\nmean: %2.5f \nmax: %2.5f \nmin: %2.5f \nSD: %2.5f',...
            N,nanmean(data_used_y),nanmax(data_used_y),nanmin(data_used_y),std(data_used_y));
      
      ax = gca;
      ax.XLim(1)
      
      xLimits = get(gca,'XLim');
      yLimits = get(gca,'YLim');
      
      if strcmp(par_vec{idx},'solz')
            xLoc = xLimits(1)+0.03*(xLimits(2)-xLimits(1));
            yLoc = yLimits(1)+0.8*(yLimits(2)-yLimits(1));
      else
            xLoc = xLimits(1)+0.6*(xLimits(2)-xLimits(1));
            yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
      end
      figure(gcf)
      hold on
      text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
      grid on
      
      saveas(gcf,[savedirname 'Hist_' par_vec{idx}],'epsc')
end
%% Histogram for filtered solz
% histogram
N = nansum(cond_used);
data_used_y = [GOCI_Data.solz_center_value];
data_used_y = data_used_y(cond_used);
% fs = 20;
figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used_y,50);
plot(centers,counts*100/N,'b-','LineWidth',1.5)
ylabel('Frequency (%)','FontSize',fs)
xlabel('Solar Zenith Angle [^o]');
% xlim([-1*xrange xrange])

str1 = sprintf('N: %i\nmean: %2.2f \nmax: %2.2f \nmin: %2.2f \nSD: %2.2f',...
      N,nanmean(data_used_y),nanmax(data_used_y),nanmin(data_used_y),std(data_used_y));

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.7*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));
figure(gcf)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');
grid on

saveas(gcf,[savedirname 'Hist_solz'],'epsc')
%% mean Rrs vs zenith -- filtered, color coded by time of the day
% cond_used = 11064-7:11064+23;
% cond_used = 1:size(GOCI_Data,2);
% cond_used = [GOCI_Data.datetime]>datetime(2013,1,1) & [GOCI_Data.datetime]<datetime(2014,1,1);
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

fs = 40;
ms = 5;
lw = 2;
solz_lim = 90;
senz_lim = 60;
% CV_lim = 0.3;
brdf_opt = 7;

% Rrs_412
cond_nan = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
cond_area = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;

h0 = figure('Color','white','DefaultAxesFontSize',fs);
% subplot(2,3,1)

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.Rrs_412_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('R_{rs}(412) [sr^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','southwest')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Rrs_412_vs_Zenith'],'epsc')

% Rrs_443
cond_nan = ~isnan([GOCI_Data.Rrs_443_filtered_mean]);
cond_area = [GOCI_Data.Rrs_443_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;

h1 = figure('Color','white','DefaultAxesFontSize',fs);
% subplot(2,3,2)

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.Rrs_443_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('R_{rs}(443) [sr^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Rrs_443_vs_Zenith'],'epsc')

% Rrs_490
cond_nan = ~isnan([GOCI_Data.Rrs_490_filtered_mean]);
cond_area = [GOCI_Data.Rrs_490_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;

h2 = figure('Color','white','DefaultAxesFontSize',fs);
% subplot(2,3,3)

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.Rrs_490_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('R_{rs}(490) [sr^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Rrs_490_vs_Zenith'],'epsc')

% Rrs_555
cond_nan = ~isnan([GOCI_Data.Rrs_555_filtered_mean]);
cond_area = [GOCI_Data.Rrs_555_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;

h3 = figure('Color','white','DefaultAxesFontSize',fs);
% subplot(2,3,4)

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.Rrs_555_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('R_{rs}(555) [sr^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Rrs_555_vs_Zenith'],'epsc')

% Rrs_660
cond_nan = ~isnan([GOCI_Data.Rrs_660_filtered_mean]);
cond_area = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;

h4 = figure('Color','white','DefaultAxesFontSize',fs);
% subplot(2,3,5)

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.Rrs_660_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('R_{rs}(660) [sr^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Rrs_660_vs_Zenith'],'epsc')

% Rrs_680
cond_nan = ~isnan([GOCI_Data.Rrs_680_filtered_mean]);
cond_area = [GOCI_Data.Rrs_680_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;

h5 = figure('Color','white','DefaultAxesFontSize',fs);
% subplot(2,3,6)

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.Rrs_680_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('R_{rs}(680) [sr^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Rrs_680_vs_Zenith'],'epsc')

%% mean Rrs vs zenith -- filtered, color coded by season
% Spring - from March 1 to May 31; 3, 4, 5
% Summer - from June 1 to August 31; 6, 7, 8
% Fall (autumn) - from September 1 to November 30; and, 9, 10, 11
% Winter - from December 1 to February 28 (February 29 in a leap year). 12, 1, 2

fs = 40;
ms = 5;
lw = 2;
solz_lim = 90;
senz_lim = 60;
% CV_lim = 0.3;
brdf_opt = 7;

par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

for idx_par = 1:size(par_vec,2)
      eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx_par}))
      eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx_par}))
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_CV = [GOCI_Data.median_CV]<=CV_lim;
      cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
      cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
      
      h = figure('Color','white','DefaultAxesFontSize',fs);
      
      % Spring
      cond_tod = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
      eval(sprintf('data_x = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}))
      data_x = data_x(cond_used&cond_tod);
      data_y = [GOCI_Data.solz_center_value];
      data_y = data_y(cond_used&cond_tod);
      plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)
      
      hold on
      % Summer
      cond_tod = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
      eval(sprintf('data_x = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}))
      data_x = data_x(cond_used&cond_tod);
      data_y = [GOCI_Data.solz_center_value];
      data_y = data_y(cond_used&cond_tod);
      plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)
      
      hold on
      % Fall
      cond_tod = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
      eval(sprintf('data_x = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}))
      data_x = data_x(cond_used&cond_tod);
      data_y = [GOCI_Data.solz_center_value];
      data_y = data_y(cond_used&cond_tod);
      plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)
      
      hold on
      % Winter
      cond_tod = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
      eval(sprintf('data_x = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}))
      data_x = data_x(cond_used&cond_tod);
      data_y = [GOCI_Data.solz_center_value];
      data_y = data_y(cond_used&cond_tod);
      plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)
      
      switch par_vec{idx_par}
            case 'Rrs_412'
                  x_str = 'R_{rs}(412) [sr^{-1}]';
            case 'Rrs_443'
                  x_str = 'R_{rs}(443) [sr^{-1}]';
            case 'Rrs_490'
                  x_str = 'R_{rs}(490) [sr^{-1}]';
            case 'Rrs_555'
                  x_str = 'R_{rs}(555) [sr^{-1}]';
            case 'Rrs_660'
                  x_str = 'R_{rs}(660) [sr^{-1}]';
            case 'Rrs_680'
                  x_str = 'R_{rs}(680) [sr^{-1}]';
            case 'chlor_a'
                  x_str = 'Chlor-{\ita} [mg m^{-3}]';
            case 'ag_412_mlrc'
                  x_str = 'a_{g}(412) [m^{-1}]';
            case 'poc'
                  x_str = 'POC [mg m^{-3}]';
      end
      
      xlabel(x_str,'FontSize',fs)
      ylabel('Solar Zenith Angle (^o)','FontSize',fs)
      ylim([0 90])
      grid on
      
      str1 = sprintf('N = %i',sum(cond_used));
      title(str1,'FontSize',fs-2,'FontWeight','Normal')
      
      legend('Spring','Summer','Fall','Winter','Location','southwest')
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      eval(sprintf('saveas(gcf,[savedirname ''%s_vs_Zenith_season''],''epsc'')',par_vec{idx_par}))
end

%% par vs zenith -- color coded by time of the day

fs = 40;
solz_lim = 90;

% chlor_a
cond_nan = ~isnan([GOCI_Data.chlor_a_filtered_mean]);
cond_area = [GOCI_Data.chlor_a_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;


h = figure('Color','white','DefaultAxesFontSize',fs);

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('Chlor-{\ita} [mg m^{-3}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Par_vs_Zenith_chlor_a'],'epsc')

% ag_412_mlrc
cond_nan = ~isnan([GOCI_Data.ag_412_mlrc_filtered_mean]);
cond_area = [GOCI_Data.ag_412_mlrc_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;


h = figure('Color','white','DefaultAxesFontSize',fs);

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('a_{g}(412) [m^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','east')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Par_vs_Zenith_ag_412_mlrc'],'epsc')

% poc
cond_nan = ~isnan([GOCI_Data.poc_filtered_mean]);
cond_area = [GOCI_Data.poc_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;


h = figure('Color','white','DefaultAxesFontSize',fs);

% 0h
cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% 1h
cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% 2h
cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% 3h
cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

% 4h
cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'oc','MarkerSize',ms,'LineWidth',lw)

hold on
% 5h
cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'om','MarkerSize',ms,'LineWidth',lw)

hold on
% 6h
cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)

hold on
% 7h
cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

xlabel('POC [mg m^{-3}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Par_vs_Zenith_poc'],'epsc')

%% par vs zenith -- color coded by season

fs = 40;
solz_lim = 90;
% chlor_a
cond_nan = ~isnan([GOCI_Data.chlor_a_filtered_mean]);
cond_area = [GOCI_Data.chlor_a_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;


h = figure('Color','white','DefaultAxesFontSize',fs);

% Spring
cond_tod = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% Summer
cond_tod = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% Fall
cond_tod = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% Winter
cond_tod = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
data_x = [GOCI_Data.chlor_a_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

xlabel('Chlor-{\ita} [mg m^{-3}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Par_vs_Zenith_chlor_a_season'],'epsc')

% ag_412_mlrc
cond_nan = ~isnan([GOCI_Data.ag_412_mlrc_filtered_mean]);
cond_area = [GOCI_Data.ag_412_mlrc_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;


h = figure('Color','white','DefaultAxesFontSize',fs);

% Spring
cond_tod = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% Summer
cond_tod = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% Fall
cond_tod = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% Winter
cond_tod = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
data_x = [GOCI_Data.ag_412_mlrc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)

xlabel('a_{g}(412) [m^{-1}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

legend('Spring','Summer','Fall','Winter','Location','southeast')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Par_vs_Zenith_ag_412_mlrc_season'],'epsc')

% poc
cond_nan = ~isnan([GOCI_Data.poc_filtered_mean]);
cond_area = [GOCI_Data.poc_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;
cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;


h = figure('Color','white','DefaultAxesFontSize',fs);

% Spring
cond_tod = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
data_x = [GOCI_Data.poc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'or','MarkerSize',ms,'LineWidth',lw)

hold on
% Summer
cond_tod = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
data_x = [GOCI_Data.poc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'og','MarkerSize',ms,'LineWidth',lw)

hold on
% Fall
cond_tod = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
data_x = [GOCI_Data.poc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ob','MarkerSize',ms,'LineWidth',lw)

hold on
% Winter
cond_tod = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
data_x = [GOCI_Data.poc_filtered_mean];
data_x = data_x(cond_used&cond_tod);
data_y = [GOCI_Data.solz_center_value];
data_y = data_y(cond_used&cond_tod);
plot(data_x,data_y,'ok','MarkerSize',ms,'LineWidth',lw)


xlabel('POC [mg m^{-3}]','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
ylim([0 90])
grid on

str1 = sprintf('N = %i',sum(cond_used));
title(str1,'FontSize',fs-2,'FontWeight','Normal')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
saveas(gcf,[savedirname 'Par_vs_Zenith_poc_season'],'epsc')


%% mean Rrs vs zenith -- filtered, by season but color coded by time of the day
% Spring - from March 1 to May 31; 3, 4, 5
% Summer - from June 1 to August 31; 6, 7, 8
% Fall (autumn) - from September 1 to November 30; and, 9, 10, 11
% Winter - from December 1 to February 28 (February 29 in a leap year). 12, 1, 2
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

fs = 80;
ms = 20;
lw = 2;
solz_lim = 90;
senz_lim = 60;
% CV_lim = 0.3;
% CV_lim = nanmean([GOCI_Data.median_CV])+nanstd([GOCI_Data.median_CV]);
brdf_opt = 7;

par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};
par_season = {'Spring','Summer','Fall','Winter'};

for idx_par = 1:size(par_vec,2)
      eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx_par}))
      eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx_par}))
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_CV = [GOCI_Data.median_CV]<=CV_lim;
      cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
      cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
      
      eval(sprintf('data_x = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}))
      data_y = [GOCI_Data.solz_center_value];
      
      for idx_season = 1:size(par_season,2)
            
            h = figure('Color','white','DefaultAxesFontSize',fs,'Name',par_season{idx_season});
%             title(par_season{idx_season})
            N = 0;
            switch par_season{idx_season}
                  case 'Spring'
                        cond_season = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
                  case 'Summer'
                        cond_season = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
                  case 'Fall'
                        cond_season = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
                  case 'Winter'
                        cond_season = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
            end
            
            for idx_tod = 1:8;
                  if idx_tod == 1
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'or','MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 2
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'og','MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 3
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'ob','MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 4
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'ok','MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 5
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'oc','MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 6
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'om','MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 7
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
                  elseif idx_tod == 8
                        hold on
                        cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
                        data_x_used = data_x(cond_used&cond_season&cond_tod);
                        data_y_used = data_y(cond_used&cond_season&cond_tod);
                        plot(data_x_used,data_y_used,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
                  end
                  N= N + sum(cond_used&cond_season&cond_tod);
            end
            
            switch par_vec{idx_par}
                  case 'Rrs_412'
                        x_str = 'R_{rs}(\lambda)';
                        xlim([0 0.02])
                  case 'Rrs_443'
                        x_str = 'R_{rs}(\lambda)';
                        xlim([0 0.015])
                  case 'Rrs_490'
                        x_str = 'R_{rs}(\lambda)';
                        xlim([0 0.01])
                  case 'Rrs_555'
                        x_str = 'R_{rs}(\lambda)';
                        xlim([0 4e-3])
                  case 'Rrs_660'
                        x_str = 'R_{rs}(\lambda)';
                        xlim([-5e-4 15e-4])
                  case 'Rrs_680'
                        x_str = 'R_{rs}(\lambda)';
                        xlim([-5e-4 1.5e-3])
                  case 'chlor_a'
                        x_str = 'Chl-{\ita}';
                        xlim([0.0 0.6])
                  case 'ag_412_mlrc'
                        x_str = 'a_{g}(412)';
                        xlim([0.0 0.08])
                  case 'poc'
                        x_str = 'POC';
                        xlim([0 120])
            end
            
            str1 = sprintf('N = %i',N);
            xlabel([x_str '; ' str1],'FontSize',fs)
            ylabel('SZA [^{\circ}]','FontSize',fs)
            ylim([0 90])
            grid on
            
            
%             title([par_season{idx_season} '; ' str1],'FontSize',fs-2,'FontWeight','Normal')
            
            %             % to create dummy data and create a custon legend
            %             p = zeros(8,1);
            %             p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            %             p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            %             p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            %             p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            %             p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            %             p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            %             p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            %             p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            %             legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
            %             clear p
            
            set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
            eval(sprintf('saveas(gcf,[savedirname ''%s_vs_Zenith_%s_tod''],''epsc'')',par_vec{idx_par},par_season{idx_season}))
            
            
      end
end
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

% total_px_GOCI = GOCI_Data(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
% GCWS width 968
% GCWS height 433
total_px_GOCI = 968*433; % new GCWS
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels
xrange = 0.02;
% startDate = datenum('01-01-2011');
startDate = datenum('05-15-2011');
endDate = datenum('01-01-2017');
xData = startDate:datenum(years(1)):endDate;

tic
process_data_flag = 1;

% CV_lim = nanmean([GOCI_Data.median_CV])+nanstd([GOCI_Data.median_CV]);

CV_lim = 0.25;
solz_lim = 75;
senz_lim = 60;

% brdf_opt_vec = [0 3 7];
brdf_opt_vec = 7;



clear cond_1t cond1 cond2 cond_used


%% first_day = datetime(GOCI_Data(1).datetime.Year,GOCI_Data(1).datetime.Month,GOCI_Data(1).datetime.Day);
first_day = datetime(2011,5,20);
last_day = datetime(GOCI_Data(end).datetime.Year,GOCI_Data(end).datetime.Month,GOCI_Data(end).datetime.Day);

date_idx = first_day:last_day;

total_num = size(brdf_opt_vec,2)*size(date_idx,2);

cond_senz = [GOCI_Data.senz_center_value]<=senz_lim; % criteria for the sensor zenith angle
cond_solz = [GOCI_Data.solz_center_value]<=solz_lim;
cond_CV = [GOCI_Data.median_CV]<=CV_lim;

% climatology data
% tic
% par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','aot_865','angstrom','poc','ag_412_mlrc','chlor_a','brdf','solz','senz'};
% clear GOCI_DailyStatMatrix
% h1 = waitbar(0,'Initializing ...');
% count_per_proc = 0;
% for idx_par = 1:size(par_vec,2)
%       for idx_brdf=1:size(brdf_opt_vec,2)
%             for idx_month = 1:12
%                   for idx_hour = 0:7
%                         count_per_proc = count_per_proc+1;
%                         per_proc = count_per_proc/(size(par_vec,2)*size(brdf_opt_vec,2)*12*8);
%                         str1 = sprintf('%3.2f',100*per_proc);
%                         waitbar(per_proc,h1,['Processing Climatology Data: ' str1 '%'])
%                         %% detrend
%                         cond_time_aux = month([GOCI_Data.datetime])==idx_month & ...
%                               hour([GOCI_Data.datetime])==idx_hour;
%                         cond_brdf_aux = [GOCI_Data.brdf_opt]==brdf_opt_vec(idx_brdf);
%
%                         eval(sprintf('cond_area_aux = [GOCI_Data.%s_filtered_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total;',par_vec{idx_par}));
%                         eval(sprintf('cond_nan_aux = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx_par}));
%
%                         cond_used_aux = cond_time_aux&cond_nan_aux&cond_area_aux&cond_brdf_aux&cond_solz&cond_senz&cond_CV;
%
%                         eval(sprintf('data_aux = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}));
%                         data_aux = data_aux(cond_used_aux);
%                         mean_month_hour = nanmean(data_aux);
%
%                         eval(sprintf('ClimatologyMatrix.BRDF(idx_brdf).Month(idx_month).Hour(idx_hour+1).%s.mean_month_hour = mean_month_hour;',par_vec{idx_par}));
%                   end
%             end
%       end
% end
% clear idx_par idx_brdf idx_month idx_hour per_proc str1 count_per_proc
% clear cond_used_aux cond_time_aux cond_brdf_aux cond_area_aux cond_nan_aux data_aux mean_month_hour
% close(h1)
% toc
% %% fast checking climatology
% figure
% for idx_brdf=1:size(brdf_opt_vec,2)
%       for idx_month = 1:12
%             for idx_hour = 0:7
%                   hold on
%                   plot((idx_month-1)*10+idx_hour,ClimatologyMatrix.BRDF(3).Month(idx_month).Hour(idx_hour+1).Rrs_680.mean_month_hour,'*');
%             end
%       end
% end
% %%
tic
if process_data_flag
      %%       %% memory preallocation
      %       GOCI_DailyStatMatrix(total_num).datetime =  [];
      %       GOCI_DailyStatMatrix(total_num).images_per_day = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_opt = [];
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_min_mean = nan;
      %       % Rrs_412
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_412_diff_w_r_mid_three_07_detrend = nan;
      %       % Rrs_443
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_443_diff_w_r_mid_three_07_detrend = nan;
      %       % Rrs_490
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_490_diff_w_r_mid_three_07_detrend = nan;
      %       % Rrs_555
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_555_diff_w_r_mid_three_07_detrend = nan;
      %       % Rrs_660
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_660_diff_w_r_mid_three_07_detrend = nan;
      %       % Rrs_680
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_680_diff_w_r_mid_three_07_detrend = nan;
      %       % aot_865
      %       GOCI_DailyStatMatrix(total_num).Rrs_865_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_865_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_865_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_865_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).Rrs_865_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).aot_865_diff_w_r_mid_three_07_detrend = nan;
      %       % angstrom
      %       GOCI_DailyStatMatrix(total_num).angstrom_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).angstrom_diff_w_r_mid_three_07_detrend = nan;
      %       % poc
      %       GOCI_DailyStatMatrix(total_num).poc_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).poc_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).poc_diff_w_r_mid_three_07_detrend = nan;
      %       % ag_412_mlrc
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).ag_412_mlrc_diff_w_r_mid_three_07_detrend = nan;
      %       % chlor_a
      %       GOCI_DailyStatMatrix(total_num).chlor_a_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).chlor_a_diff_w_r_mid_three_07_detrend = nan;
      %       % brdf
      %       GOCI_DailyStatMatrix(total_num).brdf_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).brdf_diff_w_r_mid_three_07_detrend = nan;
      %       % solz
      %       GOCI_DailyStatMatrix(total_num).solz_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).solz_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).solz_diff_w_r_mid_three_07_detrend = nan;
      %       % senz
      %       GOCI_DailyStatMatrix(total_num).senz_mean_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_stdv_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_N_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_max_mean = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_min_mean = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_mean_first_six = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_mean_mid_three = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_mean_mid_three_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_07_detrend = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_daily_mean_07 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_00 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_01 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_02 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_03 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_04 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_05 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_06 = nan;
      %       % GOCI_DailyStatMatrix(total_num).senz_diff_w_r_noon_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_00 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_01 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_02 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_03 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_04 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_05 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_06 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_07 = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_00_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_01_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_02_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_03_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_04_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_05_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_06_detrend = nan;
      %       GOCI_DailyStatMatrix(total_num).senz_diff_w_r_mid_three_07_detrend = nan;
      %%       Creation of Daily Matrix
      clear GOCI_DailyStatMatrix
      count = 0;
      
      h1 = waitbar(0,'Initializing ...');
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;
            
            GOCI_Data_used = GOCI_Data(cond_used);
            
            datetime_used = [GOCI_Data.datetime];
            
            [Year,Month,Day] = datevec(datetime_used(cond_used));
            
            clear cond_used
            
            for idx=1:size(date_idx,2)
                  %%
                  per_proc = ((idx_brdf-1)*size(date_idx,2)+idx)/(size(brdf_opt_vec,2)*size(date_idx,2));
                  str1 = sprintf('%3.2f',100*per_proc);
                  
                  waitbar(per_proc,h1,['Processing GOCI Daily Data: ' str1 '%'])
                  
                  % identify all the images for a specific day
                  cond_1t = date_idx(idx).Year==Year...
                        & date_idx.Month(idx)==Month...
                        & date_idx.Day(idx)==Day;
                  
                  
                  if ~sum(cond_1t) == 0
                        filtered_product_count = 0;
                        count = count+1;
                        
                        % check if there are more than one image per hour. It does not check
                        % if the values are valid or not, but there are only a bunch of cases
                        time_aux = [GOCI_Data_used.datetime];
                        time_aux = time_aux(cond_1t);
                        [~,IA,~] = unique([time_aux.Hour]);
                        cond_aux = zeros(size(time_aux));
                        cond_aux(IA) = 1; % only the fqirst repeated value will used. NO better criteria applied!!!!
                        cond_1t(cond_1t) = cond_aux;
                        clear time_aux IA cond_aux
                        
                        GOCI_DailyStatMatrix(count).datetime =  date_idx(idx);
                        GOCI_DailyStatMatrix(count).images_per_day = nansum(cond_1t);
                        GOCI_DailyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        GOCI_DailyStatMatrix(count).senz_lim = senz_lim;
                        GOCI_DailyStatMatrix(count).solz_lim = solz_lim;
                        GOCI_DailyStatMatrix(count).CV_lim = CV_lim;
                        GOCI_DailyStatMatrix(count).ratio_from_the_total = ratio_from_the_total;
                        
                        % datetime per hour of day
                        I = find(cond_1t); % indeces to images per day

                        GOCI_DailyStatMatrix(count).datetime_0h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_1h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_2h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_3h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_4h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_5h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_6h = date_idx(idx);
                        GOCI_DailyStatMatrix(count).datetime_7h = date_idx(idx);
                        
                        for idx_aux=1:size(I,2)
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 0
                                    GOCI_DailyStatMatrix(count).datetime_0h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_0h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 1
                                    GOCI_DailyStatMatrix(count).datetime_1h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_1h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 2
                                    GOCI_DailyStatMatrix(count).datetime_2h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_2h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 3
                                    GOCI_DailyStatMatrix(count).datetime_3h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_3h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 4
                                    GOCI_DailyStatMatrix(count).datetime_4h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_4h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 5
                                    GOCI_DailyStatMatrix(count).datetime_5h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_5h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 6
                                    GOCI_DailyStatMatrix(count).datetime_6h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_6h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                              if GOCI_Data_used(I(idx_aux)).datetime.Hour == 7
                                    GOCI_DailyStatMatrix(count).datetime_7h = GOCI_Data_used(I(idx_aux)).datetime;
                                    GOCI_DailyStatMatrix(count).ifile_7h = GOCI_Data_used(I(idx_aux)).ifile;
                              end
                        end
                        
                        clear idx_aux
                        
                        %% Rrs_412
                        data_used = [GOCI_Data_used.Rrs_412_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.Rrs_412_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1; % number of products that at least one image per day pas the criteria
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_412_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_412_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_412_min_mean = nanmin(data_used(cond_used));
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).Rrs_412_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).Rrs_412_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_412_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %                                    mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_412_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_412_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_412_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_412_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_412_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_412_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_412_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_412.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_412_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).Rrs_412_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).Rrs_412_00,GOCI_DailyStatMatrix(count).Rrs_412_01,GOCI_DailyStatMatrix(count).Rrs_412_02,...
                        % GOCI_DailyStatMatrix(count).Rrs_412_03,GOCI_DailyStatMatrix(count).Rrs_412_04,GOCI_DailyStatMatrix(count).Rrs_412_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).Rrs_412_02,GOCI_DailyStatMatrix(count).Rrs_412_03,GOCI_DailyStatMatrix(count).Rrs_412_04])==0
                              GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).Rrs_412_02,GOCI_DailyStatMatrix(count).Rrs_412_03,GOCI_DailyStatMatrix(count).Rrs_412_04]);
                        end
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).Rrs_412_02_detrend,GOCI_DailyStatMatrix(count).Rrs_412_03_detrend,GOCI_DailyStatMatrix(count).Rrs_412_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).Rrs_412_02_detrend,GOCI_DailyStatMatrix(count).Rrs_412_03_detrend,GOCI_DailyStatMatrix(count).Rrs_412_04_detrend]);
                        % end
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_00_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_01_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_02_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_03_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_04_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_05_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_06_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_412_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_412_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_412_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_412_07_detrend - GOCI_DailyStatMatrix(count).Rrs_412_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% Rrs_443
                        data_used = [GOCI_Data_used.Rrs_443_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.Rrs_443_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_443_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_443_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_443_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).Rrs_443_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).Rrs_443_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_443_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_443_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_443_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_443_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_443_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_443_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_443_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_06 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_06 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_443_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_443.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_443_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).Rrs_443_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).Rrs_443_00,GOCI_DailyStatMatrix(count).Rrs_443_01,GOCI_DailyStatMatrix(count).Rrs_443_02,...
                        % GOCI_DailyStatMatrix(count).Rrs_443_03,GOCI_DailyStatMatrix(count).Rrs_443_04,GOCI_DailyStatMatrix(count).Rrs_443_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).Rrs_443_02,GOCI_DailyStatMatrix(count).Rrs_443_03,GOCI_DailyStatMatrix(count).Rrs_443_04])==0
                              GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).Rrs_443_02,GOCI_DailyStatMatrix(count).Rrs_443_03,GOCI_DailyStatMatrix(count).Rrs_443_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).Rrs_443_02_detrend,GOCI_DailyStatMatrix(count).Rrs_443_03_detrend,GOCI_DailyStatMatrix(count).Rrs_443_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).Rrs_443_02_detrend,GOCI_DailyStatMatrix(count).Rrs_443_03_detrend,GOCI_DailyStatMatrix(count).Rrs_443_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_00_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_01_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_02_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_03_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_04_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_05_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_06_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_443_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_443_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_443_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_443_07_detrend - GOCI_DailyStatMatrix(count).Rrs_443_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% Rrs_490
                        data_used = [GOCI_Data_used.Rrs_490_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.Rrs_490_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_490_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_490_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_490_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).Rrs_490_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).Rrs_490_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_07_detrend = nan;
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_490_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_490_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_490_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_490_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_490_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_490_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_490_06 = data_used_filtered(idx2);
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_06 = ...
                                                data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_490_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_490.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_490_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).Rrs_490_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).Rrs_490_00,GOCI_DailyStatMatrix(count).Rrs_490_01,GOCI_DailyStatMatrix(count).Rrs_490_02,...
                        % GOCI_DailyStatMatrix(count).Rrs_490_03,GOCI_DailyStatMatrix(count).Rrs_490_04,GOCI_DailyStatMatrix(count).Rrs_490_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).Rrs_490_02,GOCI_DailyStatMatrix(count).Rrs_490_03,GOCI_DailyStatMatrix(count).Rrs_490_04])==0
                              GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).Rrs_490_02,GOCI_DailyStatMatrix(count).Rrs_490_03,GOCI_DailyStatMatrix(count).Rrs_490_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).Rrs_490_02_detrend,GOCI_DailyStatMatrix(count).Rrs_490_03_detrend,GOCI_DailyStatMatrix(count).Rrs_490_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).Rrs_490_02_detrend,GOCI_DailyStatMatrix(count).Rrs_490_03_detrend,GOCI_DailyStatMatrix(count).Rrs_490_04_detrend]);
                        % end
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_00_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_01_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_02_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_03_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_04_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_05_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_06_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_490_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_490_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_490_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_490_07_detrend - GOCI_DailyStatMatrix(count).Rrs_490_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% Rrs_555
                        data_used = [GOCI_Data_used.Rrs_555_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.Rrs_555_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_555_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_555_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_555_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).Rrs_555_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).Rrs_555_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_555_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_555_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_555_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_555_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_555_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_555_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_555_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_06 = ...
                                    %                                           data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_06 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_555_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_555.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_555_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).Rrs_555_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).Rrs_555_00,GOCI_DailyStatMatrix(count).Rrs_555_01,GOCI_DailyStatMatrix(count).Rrs_555_02,...
                        % GOCI_DailyStatMatrix(count).Rrs_555_03,GOCI_DailyStatMatrix(count).Rrs_555_04,GOCI_DailyStatMatrix(count).Rrs_555_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).Rrs_555_02,GOCI_DailyStatMatrix(count).Rrs_555_03,GOCI_DailyStatMatrix(count).Rrs_555_04])==0
                              GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).Rrs_555_02,GOCI_DailyStatMatrix(count).Rrs_555_03,GOCI_DailyStatMatrix(count).Rrs_555_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).Rrs_555_02_detrend,GOCI_DailyStatMatrix(count).Rrs_555_03_detrend,GOCI_DailyStatMatrix(count).Rrs_555_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).Rrs_555_02_detrend,GOCI_DailyStatMatrix(count).Rrs_555_03_detrend,GOCI_DailyStatMatrix(count).Rrs_555_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_00_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_01_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_02_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_03_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_04_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_05_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_06_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_555_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_555_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_555_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_555_07_detrend - GOCI_DailyStatMatrix(count).Rrs_555_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% Rrs_660
                        data_used = [GOCI_Data_used.Rrs_660_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.Rrs_660_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_660_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_660_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_660_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).Rrs_660_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).Rrs_660_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_660_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_660_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_660_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_660_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_660_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_660_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_660_06 = data_used_filtered(idx2);
                                    %                                     GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_06 = ...
                                    %                                           data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    %                                     if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %                                           GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_06 = ...
                                    %                                                 data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    %                                     end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_660_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_660.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_660_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).Rrs_660_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).Rrs_660_00,GOCI_DailyStatMatrix(count).Rrs_660_01,GOCI_DailyStatMatrix(count).Rrs_660_02,...
                        % GOCI_DailyStatMatrix(count).Rrs_660_03,GOCI_DailyStatMatrix(count).Rrs_660_04,GOCI_DailyStatMatrix(count).Rrs_660_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).Rrs_660_02,GOCI_DailyStatMatrix(count).Rrs_660_03,GOCI_DailyStatMatrix(count).Rrs_660_04])==0
                              GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).Rrs_660_02,GOCI_DailyStatMatrix(count).Rrs_660_03,GOCI_DailyStatMatrix(count).Rrs_660_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).Rrs_660_02_detrend,GOCI_DailyStatMatrix(count).Rrs_660_03_detrend,GOCI_DailyStatMatrix(count).Rrs_660_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).Rrs_660_02_detrend,GOCI_DailyStatMatrix(count).Rrs_660_03_detrend,GOCI_DailyStatMatrix(count).Rrs_660_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_00_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_01_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_02_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_03_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_04_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_05_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_06_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_660_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_660_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_660_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_660_07_detrend - GOCI_DailyStatMatrix(count).Rrs_660_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% Rrs_680
                        data_used = [GOCI_Data_used.Rrs_680_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.Rrs_680_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).Rrs_680_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).Rrs_680_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).Rrs_680_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).Rrs_680_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).Rrs_680_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_680_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_680_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_680_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_680_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_680_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_680_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_680_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_06 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_06 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_680_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).Rrs_680.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).Rrs_680_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).Rrs_680_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).Rrs_680_00,GOCI_DailyStatMatrix(count).Rrs_680_01,GOCI_DailyStatMatrix(count).Rrs_680_02,...
                        % GOCI_DailyStatMatrix(count).Rrs_680_03,GOCI_DailyStatMatrix(count).Rrs_680_04,GOCI_DailyStatMatrix(count).Rrs_680_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).Rrs_680_02,GOCI_DailyStatMatrix(count).Rrs_680_03,GOCI_DailyStatMatrix(count).Rrs_680_04])==0
                              GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).Rrs_680_02,GOCI_DailyStatMatrix(count).Rrs_680_03,GOCI_DailyStatMatrix(count).Rrs_680_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).Rrs_680_02_detrend,GOCI_DailyStatMatrix(count).Rrs_680_03_detrend,GOCI_DailyStatMatrix(count).Rrs_680_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).Rrs_680_02_detrend,GOCI_DailyStatMatrix(count).Rrs_680_03_detrend,GOCI_DailyStatMatrix(count).Rrs_680_04_detrend]);
                        % end
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_00_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_01_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_02_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_03_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_04_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_05_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_06_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).Rrs_680_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).Rrs_680_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).Rrs_680_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).Rrs_680_07_detrend - GOCI_DailyStatMatrix(count).Rrs_680_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% aot_865
                        data_used = [GOCI_Data_used.aot_865_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.aot_865_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        GOCI_DailyStatMatrix(count).aot_865_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).aot_865_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).aot_865_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).aot_865_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).aot_865_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).aot_865_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).aot_865_00 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_01 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_02 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_03 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_04 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_05 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_06 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_07 = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).aot_865_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).aot_865_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).aot_865_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).aot_865_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).aot_865_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).aot_865_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).aot_865_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).aot_865_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).aot_865_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).aot_865.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).aot_865_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).aot_865_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).aot_865_00,GOCI_DailyStatMatrix(count).aot_865_01,GOCI_DailyStatMatrix(count).aot_865_02,...
                        % GOCI_DailyStatMatrix(count).aot_865_03,GOCI_DailyStatMatrix(count).aot_865_04,GOCI_DailyStatMatrix(count).aot_865_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).aot_865_02,GOCI_DailyStatMatrix(count).aot_865_03,GOCI_DailyStatMatrix(count).aot_865_04])==0
                              GOCI_DailyStatMatrix(count).aot_865_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).aot_865_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).aot_865_02,GOCI_DailyStatMatrix(count).aot_865_03,GOCI_DailyStatMatrix(count).aot_865_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).aot_865_02_detrend,GOCI_DailyStatMatrix(count).aot_865_03_detrend,GOCI_DailyStatMatrix(count).aot_865_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).aot_865_02_detrend,GOCI_DailyStatMatrix(count).aot_865_03_detrend,GOCI_DailyStatMatrix(count).aot_865_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_00_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_01_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_02_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_03_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_04_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_05_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_06_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).aot_865_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).aot_865_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).aot_865_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).aot_865_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).aot_865_07_detrend - GOCI_DailyStatMatrix(count).aot_865_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        %% angstrom
                        data_used = [GOCI_Data_used.angstrom_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.angstrom_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        
                        GOCI_DailyStatMatrix(count).angstrom_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).angstrom_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).angstrom_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).angstrom_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).angstrom_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).angstrom_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).angstrom_00 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_01 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_02 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_03 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_04 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_05 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_06 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_07 = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).angstrom_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_0g_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).angstrom_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).angstrom_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).angstrom_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_03 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).angstrom_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_04 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).angstrom_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_05 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).angstrom_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).angstrom_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).angstrom_diff_w_r_daily_mean_07 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).angstrom_diff_w_r_noon_07 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).angstrom.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).angstrom_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).angstrom_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).angstrom_00,GOCI_DailyStatMatrix(count).angstrom_01,GOCI_DailyStatMatrix(count).angstrom_02,...
                        % GOCI_DailyStatMatrix(count).angstrom_03,GOCI_DailyStatMatrix(count).angstrom_04,GOCI_DailyStatMatrix(count).angstrom_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).angstrom_02,GOCI_DailyStatMatrix(count).angstrom_03,GOCI_DailyStatMatrix(count).angstrom_04])==0
                              GOCI_DailyStatMatrix(count).angstrom_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).angstrom_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).angstrom_02,GOCI_DailyStatMatrix(count).angstrom_03,GOCI_DailyStatMatrix(count).angstrom_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).angstrom_02_detrend,GOCI_DailyStatMatrix(count).angstrom_03_detrend,GOCI_DailyStatMatrix(count).angstrom_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).angstrom_02_detrend,GOCI_DailyStatMatrix(count).angstrom_03_detrend,GOCI_DailyStatMatrix(count).angstrom_04_detrend]);
                        % end
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_00_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_01_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_02_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_03_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_04_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_05_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_06_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).angstrom_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).angstrom_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).angstrom_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).angstrom_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).angstrom_07_detrend - GOCI_DailyStatMatrix(count).angstrom_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        %% poc
                        data_used = [GOCI_Data_used.poc_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.poc_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).poc_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).poc_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).poc_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).poc_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).poc_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).poc_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).poc_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).poc_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).poc_00 = nan;
                        GOCI_DailyStatMatrix(count).poc_01 = nan;
                        GOCI_DailyStatMatrix(count).poc_02 = nan;
                        GOCI_DailyStatMatrix(count).poc_03 = nan;
                        GOCI_DailyStatMatrix(count).poc_04 = nan;
                        GOCI_DailyStatMatrix(count).poc_05 = nan;
                        GOCI_DailyStatMatrix(count).poc_06 = nan;
                        GOCI_DailyStatMatrix(count).poc_07 = nan;
                        %GOCI_DailyStatMatrix(count).poc_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).poc_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).poc_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).poc_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).poc_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).poc_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).poc_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).poc_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).poc_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).poc_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).poc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).poc_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).poc_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).poc_00,GOCI_DailyStatMatrix(count).poc_01,GOCI_DailyStatMatrix(count).poc_02,...
                        % GOCI_DailyStatMatrix(count).poc_03,GOCI_DailyStatMatrix(count).poc_04,GOCI_DailyStatMatrix(count).poc_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).poc_02,GOCI_DailyStatMatrix(count).poc_03,GOCI_DailyStatMatrix(count).poc_04])==0
                              GOCI_DailyStatMatrix(count).poc_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).poc_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).poc_02,GOCI_DailyStatMatrix(count).poc_03,GOCI_DailyStatMatrix(count).poc_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).poc_02_detrend,GOCI_DailyStatMatrix(count).poc_03_detrend,GOCI_DailyStatMatrix(count).poc_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).poc_02_detrend,GOCI_DailyStatMatrix(count).poc_03_detrend,GOCI_DailyStatMatrix(count).poc_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_00_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_01_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_02_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_03_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_04_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_05_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_06_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).poc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).poc_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).poc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).poc_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).poc_07_detrend - GOCI_DailyStatMatrix(count).poc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% ag_412_mlrc
                        data_used = [GOCI_Data_used.ag_412_mlrc_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.ag_412_mlrc_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_00 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_01 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_02 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_03 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_04 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_05 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_06 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_07 = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).ag_412_mlrc.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_00,GOCI_DailyStatMatrix(count).ag_412_mlrc_01,GOCI_DailyStatMatrix(count).ag_412_mlrc_02,...
                        % GOCI_DailyStatMatrix(count).ag_412_mlrc_03,GOCI_DailyStatMatrix(count).ag_412_mlrc_04,GOCI_DailyStatMatrix(count).ag_412_mlrc_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_02,GOCI_DailyStatMatrix(count).ag_412_mlrc_03,GOCI_DailyStatMatrix(count).ag_412_mlrc_04])==0
                              GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_02,GOCI_DailyStatMatrix(count).ag_412_mlrc_03,GOCI_DailyStatMatrix(count).ag_412_mlrc_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_02_detrend,GOCI_DailyStatMatrix(count).ag_412_mlrc_03_detrend,GOCI_DailyStatMatrix(count).ag_412_mlrc_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).ag_412_mlrc_02_detrend,GOCI_DailyStatMatrix(count).ag_412_mlrc_03_detrend,GOCI_DailyStatMatrix(count).ag_412_mlrc_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_00_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_01_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_02_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_03_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_04_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_05_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_06_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).ag_412_mlrc_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).ag_412_mlrc_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).ag_412_mlrc_07_detrend - GOCI_DailyStatMatrix(count).ag_412_mlrc_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% chlor_a
                        data_used = [GOCI_Data_used.chlor_a_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.chlor_a_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).chlor_a_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).chlor_a_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).chlor_a_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).chlor_a_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).chlor_a_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_00 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_01 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_02 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_03 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_04 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_05 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_06 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_07 = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).chlor_a_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).chlor_a_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).chlor_a_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).chlor_a_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).chlor_a_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).chlor_a_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).chlor_a_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).chlor_a_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).chlor_a.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).chlor_a_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).chlor_a_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).chlor_a_00,GOCI_DailyStatMatrix(count).chlor_a_01,GOCI_DailyStatMatrix(count).chlor_a_02,...
                        % GOCI_DailyStatMatrix(count).chlor_a_03,GOCI_DailyStatMatrix(count).chlor_a_04,GOCI_DailyStatMatrix(count).chlor_a_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).chlor_a_02,GOCI_DailyStatMatrix(count).chlor_a_03,GOCI_DailyStatMatrix(count).chlor_a_04])==0
                              GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).chlor_a_02,GOCI_DailyStatMatrix(count).chlor_a_03,GOCI_DailyStatMatrix(count).chlor_a_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).chlor_a_02_detrend,GOCI_DailyStatMatrix(count).chlor_a_03_detrend,GOCI_DailyStatMatrix(count).chlor_a_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).chlor_a_02_detrend,GOCI_DailyStatMatrix(count).chlor_a_03_detrend,GOCI_DailyStatMatrix(count).chlor_a_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_00_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_01_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_02_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_03_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_04_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_05_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_06_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).chlor_a_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).chlor_a_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).chlor_a_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).chlor_a_07_detrend - GOCI_DailyStatMatrix(count).chlor_a_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% brdf
                        data_used = [GOCI_Data_used.brdf_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.brdf_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        if sum(cond_used) > 0
                              filtered_product_count = filtered_product_count+1;
                        end
                        
                        GOCI_DailyStatMatrix(count).brdf_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).brdf_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).brdf_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).brdf_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).brdf_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).brdf_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).brdf_00 = nan;
                        GOCI_DailyStatMatrix(count).brdf_01 = nan;
                        GOCI_DailyStatMatrix(count).brdf_02 = nan;
                        GOCI_DailyStatMatrix(count).brdf_03 = nan;
                        GOCI_DailyStatMatrix(count).brdf_04 = nan;
                        GOCI_DailyStatMatrix(count).brdf_05 = nan;
                        GOCI_DailyStatMatrix(count).brdf_06 = nan;
                        GOCI_DailyStatMatrix(count).brdf_07 = nan;
                        %GOCI_DailyStatMatrix(count).brdf_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_07_detrend = nan;
                        
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).brdf_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).brdf_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).brdf_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).brdf_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).brdf_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).brdf_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).brdf_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).brdf_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).brdf_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).brdf.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).brdf_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).brdf_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).brdf_00,GOCI_DailyStatMatrix(count).brdf_01,GOCI_DailyStatMatrix(count).brdf_02,...
                        % GOCI_DailyStatMatrix(count).brdf_03,GOCI_DailyStatMatrix(count).brdf_04,GOCI_DailyStatMatrix(count).brdf_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).brdf_02,GOCI_DailyStatMatrix(count).brdf_03,GOCI_DailyStatMatrix(count).brdf_04])==0
                              GOCI_DailyStatMatrix(count).brdf_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).brdf_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).brdf_02,GOCI_DailyStatMatrix(count).brdf_03,GOCI_DailyStatMatrix(count).brdf_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).brdf_02_detrend,GOCI_DailyStatMatrix(count).brdf_03_detrend,GOCI_DailyStatMatrix(count).brdf_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).brdf_02_detrend,GOCI_DailyStatMatrix(count).brdf_03_detrend,GOCI_DailyStatMatrix(count).brdf_04_detrend]);
                        % end
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_00_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_01_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_02_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_03_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_04_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_05_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_06_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).brdf_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).brdf_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).brdf_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).brdf_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).brdf_07_detrend - GOCI_DailyStatMatrix(count).brdf_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        
                        %% solz
                        data_used = [GOCI_Data_used.solz_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.solz_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        
                        GOCI_DailyStatMatrix(count).solz_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).solz_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).solz_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).solz_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).solz_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).solz_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).solz_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).solz_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).solz_00 = nan;
                        GOCI_DailyStatMatrix(count).solz_01 = nan;
                        GOCI_DailyStatMatrix(count).solz_02 = nan;
                        GOCI_DailyStatMatrix(count).solz_03 = nan;
                        GOCI_DailyStatMatrix(count).solz_04 = nan;
                        GOCI_DailyStatMatrix(count).solz_05 = nan;
                        GOCI_DailyStatMatrix(count).solz_06 = nan;
                        GOCI_DailyStatMatrix(count).solz_07 = nan;
                        %GOCI_DailyStatMatrix(count).solz_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_07_detrend = nan;
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).solz_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).solz_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).solz_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).solz_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).solz_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).solz_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).solz_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).solz_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).solz_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).solz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).solz_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).solz_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).solz_00,GOCI_DailyStatMatrix(count).solz_01,GOCI_DailyStatMatrix(count).solz_02,...
                        % GOCI_DailyStatMatrix(count).solz_03,GOCI_DailyStatMatrix(count).solz_04,GOCI_DailyStatMatrix(count).solz_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).solz_02,GOCI_DailyStatMatrix(count).solz_03,GOCI_DailyStatMatrix(count).solz_04])==0
                              GOCI_DailyStatMatrix(count).solz_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).solz_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).solz_02,GOCI_DailyStatMatrix(count).solz_03,GOCI_DailyStatMatrix(count).solz_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).solz_02_detrend,GOCI_DailyStatMatrix(count).solz_03_detrend,GOCI_DailyStatMatrix(count).solz_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).solz_02_detrend,GOCI_DailyStatMatrix(count).solz_03_detrend,GOCI_DailyStatMatrix(count).solz_04_detrend]);
                        % end
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_00_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_01_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_02_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_03_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_04_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_05_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_06_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).solz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).solz_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).solz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).solz_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).solz_07_detrend - GOCI_DailyStatMatrix(count).solz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        %% senz
                        data_used = [GOCI_Data_used.senz_filtered_mean];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.senz_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        
                        GOCI_DailyStatMatrix(count).senz_mean_mean = nanmean(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).senz_stdv_mean = nanstd(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).senz_N_mean = nansum(cond_used);
                        GOCI_DailyStatMatrix(count).senz_max_mean = nanmax(data_used(cond_used));
                        GOCI_DailyStatMatrix(count).senz_min_mean = nanmin(data_used(cond_used));
                        
                        
                        % % RMSE with respect to the daily mean
                        % sq_err = (nanmean(data_used(cond_used))- data_used(cond_used)).^2;
                        % RMSE = sqrt(nansum(sq_err)/nansum(cond_used));
                        % GOCI_DailyStatMatrix(count).senz_RMSE_mean = RMSE;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        % GOCI_DailyStatMatrix(count).senz_mean_first_six = nan;
                        GOCI_DailyStatMatrix(count).senz_mean_mid_three = nan;
                        %GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend = nan;
                        GOCI_DailyStatMatrix(count).senz_00 = nan;
                        GOCI_DailyStatMatrix(count).senz_01 = nan;
                        GOCI_DailyStatMatrix(count).senz_02 = nan;
                        GOCI_DailyStatMatrix(count).senz_03 = nan;
                        GOCI_DailyStatMatrix(count).senz_04 = nan;
                        GOCI_DailyStatMatrix(count).senz_05 = nan;
                        GOCI_DailyStatMatrix(count).senz_06 = nan;
                        GOCI_DailyStatMatrix(count).senz_07 = nan;
                        %GOCI_DailyStatMatrix(count).senz_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_07_detrend = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_00 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_01 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_02 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_03 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_04 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_05 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_06 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_07 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_00 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_01 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_02 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_03 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_04 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_05 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_06 = nan;
                        % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_07 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_00 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_01 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_02 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_03 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_04 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_05 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_06 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_07 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_00 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_01 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_02 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_03 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_04 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_05 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_06 = nan;
                        GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_07 = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_00_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_01_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_02_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_03_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_04_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_05_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_06_detrend = nan;
                        %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_07_detrend = nan;
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).senz_00 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_00 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_00 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_00_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).senz_01 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_01 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_01 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_01_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).senz_02 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_02 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_02 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_02_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).senz_03 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_03 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_03 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_03_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).senz_04 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_04 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_04 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_04_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).senz_05 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_05 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_05 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_05_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).senz_06 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_06 = ...
                                    %       data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    %       GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_06 = ...
                                    %             data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_06_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).senz_07 = data_used_filtered(idx2);
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_daily_mean_07 = ...
                                    % data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mean;% error with respect to the daily mean
                                    % if nansum(time_used_filtered.Hour == 3)~=0 % the noon value exist
                                    % GOCI_DailyStatMatrix(count).senz_diff_w_r_noon_07 = ...
                                    % data_used_filtered(idx2) - data_used_filtered(time_used_filtered.Hour == 3);
                                    % end
                                    %% detrend
                                    %mean_month_hour = ClimatologyMatrix.BRDF(idx_brdf).Month(time_used_filtered.Month(idx2)).Hour(time_used_filtered.Hour(idx2)+1).senz.mean_month_hour;
                                    %GOCI_DailyStatMatrix(count).senz_07_detrend = data_used_filtered(idx2)-mean_month_hour;
                                    % clear cond_used_aux cond_time_aux cond_nan_aux cond_area_aux cond_solz cond_senz cond_CV cond_brdf mean_month_hour;
                              end
                        end
                        
                        % GOCI_DailyStatMatrix(count).senz_mean_first_six = ...
                        % nanmean([GOCI_DailyStatMatrix(count).senz_00,GOCI_DailyStatMatrix(count).senz_01,GOCI_DailyStatMatrix(count).senz_02,...
                        % GOCI_DailyStatMatrix(count).senz_03,GOCI_DailyStatMatrix(count).senz_04,GOCI_DailyStatMatrix(count).senz_05]);
                        
                        if nanmean([GOCI_DailyStatMatrix(count).senz_02,GOCI_DailyStatMatrix(count).senz_03,GOCI_DailyStatMatrix(count).senz_04])==0
                              GOCI_DailyStatMatrix(count).senz_mean_mid_three = nan; % to avoid dividing by 0 and Inf result
                        else
                              GOCI_DailyStatMatrix(count).senz_mean_mid_three = ...
                                    nanmean([GOCI_DailyStatMatrix(count).senz_02,GOCI_DailyStatMatrix(count).senz_03,GOCI_DailyStatMatrix(count).senz_04]);
                        end
                        
                        
                        %if nanmean([GOCI_DailyStatMatrix(count).senz_02_detrend,GOCI_DailyStatMatrix(count).senz_03_detrend,GOCI_DailyStatMatrix(count).senz_04_detrend])==0
                        %GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend = nan; % to avoid dividing by 0 and Inf result
                        % else
                        %GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend = ...
                        %nanmean([GOCI_DailyStatMatrix(count).senz_02_detrend,GOCI_DailyStatMatrix(count).senz_03_detrend,GOCI_DailyStatMatrix(count).senz_04_detrend]);
                        % end
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_00 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_00 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_00_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_00_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_01 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_01 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_01_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_01_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_02 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_02 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_02_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_02_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_03 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_03 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_03_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_03_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_04 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_04 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_04_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_04_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_05 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_05 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_05_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_05_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_06 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_06 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_06_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_06_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_07 = ...
                                          data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_mean_mid_three;% error with respect to the middle three
                                    if GOCI_DailyStatMatrix(count).senz_04~=0;% error with respect to the 4th
                                          GOCI_DailyStatMatrix(count).senz_diff_w_r_4th_07 = data_used_filtered(idx2) - GOCI_DailyStatMatrix(count).senz_04;
                                    end
                                    %GOCI_DailyStatMatrix(count).senz_diff_w_r_mid_three_07_detrend = ...
                                    %GOCI_DailyStatMatrix(count).senz_07_detrend - GOCI_DailyStatMatrix(count).senz_mean_mid_three_detrend;% error with respect to the middle three
                              end
                        end
                        
                        %% solz_center_value
                        data_used = [GOCI_Data_used.solz_center_value];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.solz_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).solz_center_value_00 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_01 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_02 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_03 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_04 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_05 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_06 = nan;
                        GOCI_DailyStatMatrix(count).solz_center_value_07 = nan;
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).solz_center_value_00 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).solz_center_value_01 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).solz_center_value_02 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).solz_center_value_03 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).solz_center_value_04 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).solz_center_value_05 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).solz_center_value_06 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).solz_center_value_07 = data_used_filtered(idx2);
                              end
                        end
                        
                        %% senz_center_value
                        data_used = [GOCI_Data_used.senz_center_value];
                        data_used = data_used(cond_1t);
                        valid_px_count_used = [GOCI_Data_used.senz_valid_pixel_count];
                        valid_px_count_used = valid_px_count_used(cond_1t);
                        cond1 = data_used > 0; % only positive values
                        cond2 = valid_px_count_used >= total_px_GOCI/ratio_from_the_total; % more than half valid pixel criteria
                        cond_used = cond1&cond2;
                        
                        time_used = [GOCI_Data_used.datetime];
                        time_used = time_used(cond_1t);
                        
                        data_used_filtered = data_used(cond_used);
                        time_used_filtered = time_used(cond_used);
                        
                        % initialization
                        GOCI_DailyStatMatrix(count).senz_center_value_00 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_01 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_02 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_03 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_04 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_05 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_06 = nan;
                        GOCI_DailyStatMatrix(count).senz_center_value_07 = nan;
                        
                        for idx2 =1:size(data_used_filtered,2)
                              if time_used_filtered.Hour(idx2) == 0
                                    GOCI_DailyStatMatrix(count).senz_center_value_00 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 1
                                    GOCI_DailyStatMatrix(count).senz_center_value_01 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 2
                                    GOCI_DailyStatMatrix(count).senz_center_value_02 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 3
                                    GOCI_DailyStatMatrix(count).senz_center_value_03 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 4
                                    GOCI_DailyStatMatrix(count).senz_center_value_04 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 5
                                    GOCI_DailyStatMatrix(count).senz_center_value_05 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 6
                                    GOCI_DailyStatMatrix(count).senz_center_value_06 = data_used_filtered(idx2);
                              end
                              if time_used_filtered.Hour(idx2) == 7
                                    GOCI_DailyStatMatrix(count).senz_center_value_07 = data_used_filtered(idx2);
                              end
                        end
                        
                        GOCI_DailyStatMatrix(count).filtered_product_count = filtered_product_count;
                  end
            end
      end
end
close(h1) % closes status message window
save('GOCI_TempAnly.mat','GOCI_Data','-v7.3','-append')
save('GOCI_TempAnly.mat','GOCI_DailyStatMatrix','AQUA_DailyStatMatrix','VIIRS_DailyStatMatrix','-append')
toc
%% Daily statistics for AQUA

count = 0;
brdf_opt_vec = 7;
% ratio_from_the_total = 3;
pixel_lim = (total_px_GOCI/4)/ratio_from_the_total;
% pixel_lim = 15*15;

% CV_lim = nanmean([AQUA_Data.median_CV])+3*nanstd([AQUA_Data.median_CV]);
% CV_lim = 0.49;

if process_data_flag
      clear AQUA_DailyStatMatrix AQUA_Data_used
      clear cond_1t cond1 cond2 cond_used
      
      first_day = datetime(AQUA_Data(1).datetime.Year,AQUA_Data(1).datetime.Month,AQUA_Data(1).datetime.Day);
      last_day = datetime(AQUA_Data(end).datetime.Year,AQUA_Data(end).datetime.Month,AQUA_Data(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      count_per_proc = 0;
      h1 = waitbar(0,'Initializing ...');
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [AQUA_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_senz = [AQUA_Data.senz_center_value]<=senz_lim; % criteria for the sensor zenith angle
            cond_solz = [AQUA_Data.solz_center_value]<=solz_lim;
            cond_CV = [AQUA_Data.median_CV]<=CV_lim;
            cond_area = [AQUA_Data.pixel_count]>=pixel_lim;
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV&cond_area;
            
            AQUA_Data_used = AQUA_Data(cond_used);
            
            datetime_aux = [AQUA_Data.datetime];
            datetime_aux = datetime_aux(cond_used);
            
            [Year,Month,Day] = datevec(datetime_aux); % only days that satisfy the criteria above
            
            clear cond_used datetime_aux
            
            for idx=1:size(date_idx,2)
                  count_per_proc = count_per_proc +1;
                  per_proc = count_per_proc/(size(brdf_opt_vec,2)*size(date_idx,2));
                  str1 = sprintf('%3.2f',100*per_proc);
                  waitbar(per_proc,h1,['Processing AQUA Daily Data: ' str1 '%'])
                  
                  % identify all the images for a specific day
                  cond_1t = date_idx(idx).Year==Year...
                        & date_idx.Month(idx)==Month...
                        & date_idx.Day(idx)==Day;
                  
                  cond_1t_aux = cond_1t;
                  
                  % best geometry if there is more than one image
                  if sum(cond_1t_aux)>1
                        I = find(cond_1t_aux);
                        data_aux = [AQUA_Data_used.solz_center_value];
                        [~,Itemp] = min(data_aux(cond_1t_aux));
                        Imin = I(Itemp);
                        cond_1t_aux = 0.*cond_1t_aux;
                        cond_1t_aux(Imin) = 1;
                        cond_1t_aux = logical(cond_1t_aux);
                        cond_1t = cond_1t_aux;
                        clear Imin Itemp cond_1t_aux
                  end
                  
                  if sum(cond_1t) ~= 0 % only days that match the criteria above
                        
                        count = count+1;
                        
                        AQUA_DailyStatMatrix(count).date =  date_idx(idx);
                        AQUA_DailyStatMatrix(count).datetime =  AQUA_Data_used(cond_1t).datetime;
                        AQUA_DailyStatMatrix(count).DOY = day(date_idx(idx),'dayofyear');
                        AQUA_DailyStatMatrix(count).images_per_day = nansum(cond_1t);
                        AQUA_DailyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        AQUA_DailyStatMatrix(count).idx_to_AQUA_Data = find(cond_1t);
                        AQUA_DailyStatMatrix(count).ifile = AQUA_Data_used(cond_1t).ifile;
                        
                        %% Rrs_412
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.Rrs_412_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0; % negative values should NOT be used
                        data_aux = [AQUA_Data_used.Rrs_412_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim; % less than half of the scene is valid, it should NOT be used
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values or scene with less than half of the area is invalid
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).Rrs_412_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.Rrs_412_filtered_mean];
                              AQUA_DailyStatMatrix(count).Rrs_412_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).Rrs_412_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_443
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.Rrs_443_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.Rrs_443_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).Rrs_443_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.Rrs_443_filtered_mean];
                              AQUA_DailyStatMatrix(count).Rrs_443_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).Rrs_443_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_488
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.Rrs_488_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.Rrs_488_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).Rrs_488_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.Rrs_488_filtered_mean];
                              AQUA_DailyStatMatrix(count).Rrs_488_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).Rrs_488_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_547
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.Rrs_547_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.Rrs_547_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).Rrs_547_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.Rrs_547_filtered_mean];
                              AQUA_DailyStatMatrix(count).Rrs_547_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).Rrs_547_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_667
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.Rrs_667_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.Rrs_667_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).Rrs_667_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.Rrs_667_filtered_mean];
                              AQUA_DailyStatMatrix(count).Rrs_667_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).Rrs_667_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_678
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.Rrs_678_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.Rrs_678_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).Rrs_678_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.Rrs_678_filtered_mean];
                              AQUA_DailyStatMatrix(count).Rrs_678_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).Rrs_678_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% aot_869
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.aot_869_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.aot_869_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).aot_869_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.aot_869_filtered_mean];
                              AQUA_DailyStatMatrix(count).aot_869_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).aot_869_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% angstrom
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.angstrom_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.angstrom_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).angstrom_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.angstrom_filtered_mean];
                              AQUA_DailyStatMatrix(count).angstrom_filtered_mean = data_aux(cond_1t_aux);
                              data_aux = [AQUA_Data_used.angstrom_filtered_valid_pixel_count];
                              AQUA_DailyStatMatrix(count).angstrom_filtered_valid_pixel_count = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).angstrom_filtered_mean = nan;
                              AQUA_DailyStatMatrix(count).angstrom_filtered_valid_pixel_count = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% poc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.poc_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.poc_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).poc_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.poc_filtered_mean];
                              AQUA_DailyStatMatrix(count).poc_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).poc_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% ag_412_mlrc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.ag_412_mlrc_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.ag_412_mlrc_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).ag_412_mlrc_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.ag_412_mlrc_filtered_mean];
                              AQUA_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% chlor_a
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.chlor_a_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.chlor_a_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).chlor_a_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.chlor_a_filtered_mean];
                              AQUA_DailyStatMatrix(count).chlor_a_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).chlor_a_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% brdf
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [AQUA_Data_used.brdf_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [AQUA_Data_used.brdf_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<=pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        %                         % best geometry if there is more than one image
                        %                         if sum(cond_1t_aux)>1
                        %                               I = find(cond_1t_aux);
                        %                               data_aux = [AQUA_Data_used.solz_center_value];
                        %                               [~,Itemp] = min(data_aux(cond_1t_aux));
                        %                               Imin = I(Itemp);
                        %                               cond_1t_aux = 0.*cond_1t_aux;
                        %                               cond_1t_aux(Imin) = 1;
                        %                               cond_1t_aux = logical(cond_1t_aux);
                        %                               clear Imin Itemp
                        %                         end
                        
                        data_aux = [AQUA_Data_used.median_CV];
                        AQUA_DailyStatMatrix(count).brdf_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [AQUA_Data_used.brdf_filtered_mean];
                              AQUA_DailyStatMatrix(count).brdf_filtered_mean = data_aux(cond_1t_aux);
                        else
                              AQUA_DailyStatMatrix(count).brdf_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                  end
            end
      end
end
close(h1)
%% Daily statistics for VIIRS

count = 0;

% CV_lim = nanmean([VIIRS_Data.median_CV])+3*nanstd([VIIRS_Data.median_CV]);

if process_data_flag
      clear VIIRS_DailyStatMatrix
      clear cond_1t cond1 cond2 cond_used
      
      first_day = datetime(VIIRS_Data(1).datetime.Year,VIIRS_Data(1).datetime.Month,VIIRS_Data(1).datetime.Day);
      last_day = datetime(VIIRS_Data(end).datetime.Year,VIIRS_Data(end).datetime.Month,VIIRS_Data(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      count_per_proc = 0;
      h1 = waitbar(0,'Initializing ...');
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [VIIRS_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_senz = [VIIRS_Data.senz_center_value]<=senz_lim; % criteria for the sensor zenith angle
            cond_solz = [VIIRS_Data.solz_center_value]<=solz_lim;
            cond_CV = [VIIRS_Data.median_CV]<=CV_lim;
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;
            
            VIIRS_Data_used = VIIRS_Data(cond_used);
            
            datetime_aux = [VIIRS_Data.datetime];
            datetime_aux = datetime_aux(cond_used);
            
            [Year,Month,Day] = datevec(datetime_aux);
            
            clear cond_used
            
            for idx=1:size(date_idx,2)
                  count_per_proc = count_per_proc +1;
                  per_proc = count_per_proc/(size(brdf_opt_vec,2)*size(date_idx,2));
                  str1 = sprintf('%3.2f',100*per_proc);
                  waitbar(per_proc,h1,['Processing VIIRS Daily Data: ' str1 '%'])
                  
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
                        data_aux = [VIIRS_Data_used.Rrs_410_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.Rrs_410_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).Rrs_410_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.Rrs_410_filtered_mean];
                              VIIRS_DailyStatMatrix(count).Rrs_410_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_410_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_443
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.Rrs_443_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.Rrs_443_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).Rrs_443_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.Rrs_443_filtered_mean];
                              VIIRS_DailyStatMatrix(count).Rrs_443_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_443_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_486
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.Rrs_486_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.Rrs_486_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).Rrs_486_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.Rrs_486_filtered_mean];
                              VIIRS_DailyStatMatrix(count).Rrs_486_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_486_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_551
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.Rrs_551_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.Rrs_551_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).Rrs_551_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.Rrs_551_filtered_mean];
                              VIIRS_DailyStatMatrix(count).Rrs_551_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_551_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% Rrs_671
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.Rrs_671_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.Rrs_671_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).Rrs_671_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.Rrs_671_filtered_mean];
                              VIIRS_DailyStatMatrix(count).Rrs_671_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).Rrs_671_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% aot_862
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.aot_862_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.aot_862_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).aot_862_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.aot_862_filtered_mean];
                              VIIRS_DailyStatMatrix(count).aot_862_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).aot_862_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% angstrom
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.angstrom_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.angstrom_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.angstrom_filtered_mean];
                              VIIRS_DailyStatMatrix(count).angstrom_filtered_mean = data_aux(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.angstrom_filtered_valid_pixel_count];
                              VIIRS_DailyStatMatrix(count).angstrom_filtered_valid_pixel_count = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).angstrom_filtered_mean = nan;
                              VIIRS_DailyStatMatrix(count).angstrom_filtered_valid_pixel_count = nan;
                        end
                        clear cond_1t_aux
                        
                        %% poc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.poc_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.poc_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).poc_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.poc_filtered_mean];
                              VIIRS_DailyStatMatrix(count).poc_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).poc_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% ag_412_mlrc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.ag_412_mlrc_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.ag_412_mlrc_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).ag_412_mlrc_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.ag_412_mlrc_filtered_mean];
                              VIIRS_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% chlor_a
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.chlor_a_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.chlor_a_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).chlor_a_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.chlor_a_filtered_mean];
                              VIIRS_DailyStatMatrix(count).chlor_a_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).chlor_a_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                        
                        %% brdf
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [VIIRS_Data_used.brdf_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [VIIRS_Data_used.brdf_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<(total_px_GOCI/2.25)/ratio_from_the_total;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [VIIRS_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [VIIRS_Data_used.median_CV];
                        VIIRS_DailyStatMatrix(count).brdf_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [VIIRS_Data_used.brdf_filtered_mean];
                              VIIRS_DailyStatMatrix(count).brdf_filtered_mean = data_aux(cond_1t_aux);
                        else
                              VIIRS_DailyStatMatrix(count).brdf_filtered_mean = nan;
                        end
                        clear cond_1t_aux
                  end
            end
      end
end
close(h1)
%
save('GOCI_TempAnly.mat','AQUA_DailyStatMatrix','VIIRS_DailyStatMatrix','-append')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Monthly statistics for GOCI
if process_data_flag
      
      clear GOCI_MonthlyStatMatrix
      clear cond_1t count
      
      [Year,Month,~] = datevec([GOCI_DailyStatMatrix.datetime]);
      
      Year_min = min(Year);
      Year_max = max(Year);
      
      Year_idx = Year_min:Year_max;
      
      count = 0;
      
      count_per_proc = 0;
      h1 = waitbar(0,'Initializing ...');
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            for idx = 1:size(Year_idx,2)
                  for idx2 = 1:12
                        
                        count_per_proc = count_per_proc +1;
                        per_proc = count_per_proc/(size(brdf_opt_vec,2)*size(Year_idx,2)*12);
                        str1 = sprintf('%3.2f',100*per_proc);
                        waitbar(per_proc,h1,['Processing GOCI Monthly Data: ' str1 '%'])
                        
                        count = count+1;
                        cond_1t = Year_idx(idx)==Year...
                              & idx2==Month...
                              & [GOCI_DailyStatMatrix.brdf_opt] == brdf_opt_vec(idx_brdf);
                        
                        GOCI_MonthlyStatMatrix(count).Month = idx2;
                        GOCI_MonthlyStatMatrix(count).Year  = Year_idx(idx);
                        GOCI_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
                        GOCI_MonthlyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        % data_aux = [GOCI_DailyStatMatrix.Rrs_412_mean_first_six];
                        % GOCI_MonthlyStatMatrix(count).Rrs_412_mean_first_six = nanmean(data_aux((cond_1t)));
                        % GOCI_MonthlyStatMatrix(count).Rrs_412_mean_first_six_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        % data_aux = [GOCI_DailyStatMatrix.Rrs_443_mean_first_six];
                        % GOCI_MonthlyStatMatrix(count).Rrs_443_mean_first_six = nanmean(data_aux((cond_1t)));
                        % GOCI_MonthlyStatMatrix(count).Rrs_443_mean_first_six_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        % data_aux = [GOCI_DailyStatMatrix.Rrs_490_mean_first_six];
                        % GOCI_MonthlyStatMatrix(count).Rrs_490_mean_first_six = nanmean(data_aux((cond_1t)));
                        % GOCI_MonthlyStatMatrix(count).Rrs_490_mean_first_six_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        % data_aux = [GOCI_DailyStatMatrix.Rrs_555_mean_first_six];
                        % GOCI_MonthlyStatMatrix(count).Rrs_555_mean_first_six = nanmean(data_aux((cond_1t)));
                        % GOCI_MonthlyStatMatrix(count).Rrs_555_mean_first_six_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        % data_aux = [GOCI_DailyStatMatrix.Rrs_660_mean_first_six];
                        % GOCI_MonthlyStatMatrix(count).Rrs_660_mean_first_six = nanmean(data_aux((cond_1t)));
                        % GOCI_MonthlyStatMatrix(count).Rrs_660_mean_first_six_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        % data_aux = [GOCI_DailyStatMatrix.Rrs_680_mean_first_six];
                        % GOCI_MonthlyStatMatrix(count).Rrs_680_mean_first_six = nanmean(data_aux((cond_1t)));
                        % GOCI_MonthlyStatMatrix(count).Rrs_680_mean_first_six_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        
                        data_aux = [GOCI_DailyStatMatrix.Rrs_412_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).Rrs_412_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).Rrs_412_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.Rrs_443_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).Rrs_443_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).Rrs_443_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.Rrs_490_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).Rrs_490_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).Rrs_490_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.Rrs_555_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).Rrs_555_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).Rrs_555_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.Rrs_660_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).Rrs_660_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).Rrs_660_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.Rrs_680_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).Rrs_680_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).Rrs_680_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.aot_865_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).aot_865_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).aot_865_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        
                        data_aux = [GOCI_DailyStatMatrix.angstrom_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).angstrom_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).angstrom_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.poc_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).poc_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).poc_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.ag_412_mlrc_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).ag_412_mlrc_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).ag_412_mlrc_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.chlor_a_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).chlor_a_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).chlor_a_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [GOCI_DailyStatMatrix.brdf_mean_mid_three];
                        GOCI_MonthlyStatMatrix(count).brdf_mean_mid_three = nanmean(data_aux((cond_1t)));
                        GOCI_MonthlyStatMatrix(count).brdf_mean_mid_three_N = nansum(isfinite(data_aux((cond_1t))));
                  end
            end
      end
end
close(h1)
%% Monthly statistics for AQUA
if process_data_flag
      clear AQUA_MonthlyStatMatrix
      clear cond_1t count
      
      [Year,Month,~] = datevec([AQUA_DailyStatMatrix.datetime]);
      
      Year_min = min(Year);
      Year_max = max(Year);
      
      Year_idx = Year_min:Year_max;
      
      count_per_proc = 0;
      h1 = waitbar(0,'Initializing ...');
      
      count = 0;
      for idx_brdf = 1:size(brdf_opt_vec,2)
            for idx = 1:size(Year_idx,2)
                  for idx2 = 1:12
                        
                        count_per_proc = count_per_proc +1;
                        per_proc = count_per_proc/(size(brdf_opt_vec,2)*size(Year_idx,2)*12);
                        str1 = sprintf('%3.2f',100*per_proc);
                        waitbar(per_proc,h1,['Processing AQUA Monthly Data: ' str1 '%'])
                        
                        count = count+1;
                        cond_1t = Year_idx(idx)==Year...
                              & idx2==Month...
                              & [AQUA_DailyStatMatrix.brdf_opt] == brdf_opt_vec(idx_brdf);
                        
                        AQUA_MonthlyStatMatrix(count).Month = idx2;
                        AQUA_MonthlyStatMatrix(count).Year  = Year_idx(idx);
                        AQUA_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
                        AQUA_MonthlyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        data_aux = [AQUA_DailyStatMatrix.Rrs_412_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).Rrs_412_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).Rrs_412_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.Rrs_443_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).Rrs_443_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).Rrs_443_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.Rrs_488_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).Rrs_488_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).Rrs_488_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.Rrs_547_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).Rrs_547_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).Rrs_547_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.Rrs_667_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).Rrs_667_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).Rrs_667_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.Rrs_678_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).Rrs_678_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).Rrs_678_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        
                        data_aux = [AQUA_DailyStatMatrix.aot_869_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).aot_869_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).aot_869_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.angstrom_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).angstrom_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).angstrom_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.poc_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).poc_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).poc_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.ag_412_mlrc_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).ag_412_mlrc_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).ag_412_mlrc_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.chlor_a_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).chlor_a_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).chlor_a_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [AQUA_DailyStatMatrix.brdf_filtered_mean];
                        AQUA_MonthlyStatMatrix(count).brdf_mean = nanmean(data_aux((cond_1t)));
                        AQUA_MonthlyStatMatrix(count).brdf_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                  end
            end
      end
end
close(h1)
% Monthly statistics for VIIRS
if process_data_flag
      clear VIIRS_MonthlyStatMatrix
      clear cond_1t count
      
      [Year,Month,~] = datevec([VIIRS_DailyStatMatrix.datetime]);
      
      Year_idx =  min(Year):max(Year);
      
      count_per_proc = 0;
      h1 = waitbar(0,'Initializing ...');
      
      count = 0;
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            for idx = 1:size(Year_idx,2)
                  for idx2 = 1:12
                        
                        count_per_proc = count_per_proc +1;
                        per_proc = count_per_proc/(size(brdf_opt_vec,2)*size(Year_idx,2)*12);
                        str1 = sprintf('%3.2f',100*per_proc);
                        waitbar(per_proc,h1,['Processing VIIRS Monthly Data: ' str1 '%'])
                        
                        count = count+1;
                        cond_1t = Year_idx(idx)==Year...
                              & idx2==Month...
                              & [VIIRS_DailyStatMatrix.brdf_opt] == brdf_opt_vec(idx_brdf);
                        
                        VIIRS_MonthlyStatMatrix(count).Month = idx2;
                        VIIRS_MonthlyStatMatrix(count).Year  = Year_idx(idx);
                        VIIRS_MonthlyStatMatrix(count).datetime = datetime(Year_idx(idx),idx2,1);
                        VIIRS_MonthlyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        
                        data_aux = [VIIRS_DailyStatMatrix.Rrs_410_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).Rrs_410_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).Rrs_410_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.Rrs_443_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).Rrs_443_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).Rrs_443_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.Rrs_486_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).Rrs_486_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).Rrs_486_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.Rrs_551_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).Rrs_551_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).Rrs_551_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.Rrs_671_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).Rrs_671_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).Rrs_671_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        
                        data_aux = [VIIRS_DailyStatMatrix.aot_862_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).aot_862_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).aot_862_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.angstrom_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).angstrom_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).angstrom_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.poc_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).poc_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).poc_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.ag_412_mlrc_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).ag_412_mlrc_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).ag_412_mlrc_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.chlor_a_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).chlor_a_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).chlor_a_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        data_aux = [VIIRS_DailyStatMatrix.brdf_filtered_mean];
                        VIIRS_MonthlyStatMatrix(count).brdf_mean = nanmean(data_aux((cond_1t)));
                        VIIRS_MonthlyStatMatrix(count).brdf_mean_N = nansum(isfinite(data_aux((cond_1t))));
                        
                        
                  end
            end
      end
end
%
% save('GOCI_TempAnly.mat','ClimatologyMatrix','GOCI_DailyStatMatrix','AQUA_DailyStatMatrix','VIIRS_DailyStatMatrix','-append')
close(h1)
save('GOCI_TempAnly.mat','GOCI_MonthlyStatMatrix','AQUA_MonthlyStatMatrix','VIIRS_MonthlyStatMatrix','-append')
%% Basics stats for GOCI_DailyStatMatrix

nvalid = 3;

cond_Rrs_412 =[GOCI_DailyStatMatrix.Rrs_412_N_mean]>=nvalid;
cond_Rrs_443 =[GOCI_DailyStatMatrix.Rrs_443_N_mean]>=nvalid;
cond_Rrs_490 =[GOCI_DailyStatMatrix.Rrs_490_N_mean]>=nvalid;
cond_Rrs_555 =[GOCI_DailyStatMatrix.Rrs_555_N_mean]>=nvalid;
cond_Rrs_660 =[GOCI_DailyStatMatrix.Rrs_660_N_mean]>=nvalid;
cond_Rrs_680 =[GOCI_DailyStatMatrix.Rrs_680_N_mean]>=nvalid;
cond_chlor_a = [GOCI_DailyStatMatrix.chlor_a_N_mean]>=nvalid;
cond_ag_412_mlrc = [GOCI_DailyStatMatrix.ag_412_mlrc_N_mean]>=nvalid;
cond_poc = [GOCI_DailyStatMatrix.poc_N_mean]>=nvalid;

cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==7;

% N
clc
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_mean_mean]))
%% mean SD
clc
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean])

% %% SD SD
% clc
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean])
%%
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_412_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_412_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_443_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_443_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_490_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_490_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_555_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_555_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_660_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_660_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_680_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_680_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.chlor_a_stdv_mean])/nanmean([GOCI_DailyStatMatrix.chlor_a_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.ag_412_mlrc_stdv_mean])/nanmean([GOCI_DailyStatMatrix.ag_412_mlrc_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.poc_stdv_mean])/nanmean([GOCI_DailyStatMatrix.poc_mean_mean])
%% min CV[%]
clc
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_mean_mean])

%% max CV[%]
clc
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_mean_mean])

%% mean CV[%]
clc
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_mean_mean])

%% median CV[%]
clc
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_mean_mean])

%% SD CV[%]
clc
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_brdf).Rrs_412_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_brdf).Rrs_443_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_brdf).Rrs_490_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_brdf).Rrs_555_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_brdf).Rrs_660_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_brdf).Rrs_680_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_brdf).chlor_a_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_brdf).ag_412_mlrc_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_brdf).poc_mean_mean])

%% Basics stats for GOCI_DailyStatMatrix -- ONLY SUMMER
nvalid = 3;

cond_Rrs_412 =[GOCI_DailyStatMatrix.Rrs_412_N_mean]>=nvalid;
cond_Rrs_443 =[GOCI_DailyStatMatrix.Rrs_443_N_mean]>=nvalid;
cond_Rrs_490 =[GOCI_DailyStatMatrix.Rrs_490_N_mean]>=nvalid;
cond_Rrs_555 =[GOCI_DailyStatMatrix.Rrs_555_N_mean]>=nvalid;
cond_Rrs_660 =[GOCI_DailyStatMatrix.Rrs_660_N_mean]>=nvalid;
cond_Rrs_680 =[GOCI_DailyStatMatrix.Rrs_680_N_mean]>=nvalid;
cond_chlor_a = [GOCI_DailyStatMatrix.chlor_a_N_mean]>=nvalid;
cond_ag_412_mlrc = [GOCI_DailyStatMatrix.ag_412_mlrc_N_mean]>=nvalid;
cond_poc = [GOCI_DailyStatMatrix.poc_N_mean]>=nvalid;

% Summer
cond_tod = month([GOCI_DailyStatMatrix.datetime])==6|month([GOCI_DailyStatMatrix.datetime])==7|month([GOCI_DailyStatMatrix.datetime])==8; % cond for season

% N
clc
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_mean_mean]))
sum(~isnan(100*[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_mean_mean]))
%% mean SD
clc
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean])
2*nanmean([GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean])

% SD SD
% clc
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean])
% 2*nanstd([GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean])
%%
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_412_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_412_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_443_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_443_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_490_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_490_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_555_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_555_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_660_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_660_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.Rrs_680_stdv_mean])/nanmean([GOCI_DailyStatMatrix.Rrs_680_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.chlor_a_stdv_mean])/nanmean([GOCI_DailyStatMatrix.chlor_a_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.ag_412_mlrc_stdv_mean])/nanmean([GOCI_DailyStatMatrix.ag_412_mlrc_mean_mean])
% 100*nanmean([GOCI_DailyStatMatrix.poc_stdv_mean])/nanmean([GOCI_DailyStatMatrix.poc_mean_mean])
%% min CV[%]
clc
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_mean_mean])
nanmin(100*[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_mean_mean])

%% max CV[%]
clc
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_mean_mean])
nanmax(100*[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_mean_mean])

%% mean CV[%]
clc
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_mean_mean])
nanmean(100*[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_mean_mean])

%% median CV[%]
clc
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_mean_mean])
nanmedian(100*[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_mean_mean])

%% SD CV[%]
clc
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_412&cond_tod&cond_brdf).Rrs_412_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_443&cond_tod&cond_brdf).Rrs_443_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_490&cond_tod&cond_brdf).Rrs_490_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_555&cond_tod&cond_brdf).Rrs_555_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_660&cond_tod&cond_brdf).Rrs_660_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_stdv_mean]./[GOCI_DailyStatMatrix(cond_Rrs_680&cond_tod&cond_brdf).Rrs_680_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_stdv_mean]./[GOCI_DailyStatMatrix(cond_chlor_a&cond_tod&cond_brdf).chlor_a_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_stdv_mean]./[GOCI_DailyStatMatrix(cond_ag_412_mlrc&cond_tod&cond_brdf).ag_412_mlrc_mean_mean])
nanstd(100*[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_stdv_mean]./[GOCI_DailyStatMatrix(cond_poc&cond_tod&cond_brdf).poc_mean_mean])

%% mean rrs vs zenith -- filtered

fs = 25;
ms = 14;
lw = 2;
h = figure('Color','white','DefaultAxesFontSize',fs);

% Rrs_412
cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_412_mean_mid_three]);
cond_used = cond1;

subplot(2,3,1)
data_x = [GOCI_DailyStatMatrix.Rrs_412_mean_mid_three];
data_y = [GOCI_DailyStatMatrix.solz_center_value_03];
plot(data_x(cond_used),data_y(cond_used),'.b','MarkerSize',ms)
xlabel('R_{rs}(412)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_443
cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_443_mean_mid_three]);
cond_used = cond1;

subplot(2,3,2)
data_x = [GOCI_DailyStatMatrix.Rrs_443_mean_mid_three];
data_y = [GOCI_DailyStatMatrix.solz_center_value_03];
plot(data_x(cond_used),data_y(cond_used),'.b','MarkerSize',ms)
xlabel('R_{rs}(443)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_490
cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_490_mean_mid_three]);
cond_used = cond1;

subplot(2,3,3)
data_x = [GOCI_DailyStatMatrix.Rrs_490_mean_mid_three];
data_y = [GOCI_DailyStatMatrix.solz_center_value_03];
plot(data_x(cond_used),data_y(cond_used),'.b','MarkerSize',ms)
xlabel('R_{rs}(490)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_555
cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_555_mean_mid_three]);
cond_used = cond1;

subplot(2,3,4)
data_x = [GOCI_DailyStatMatrix.Rrs_555_mean_mid_three];
data_y = [GOCI_DailyStatMatrix.solz_center_value_03];
plot(data_x(cond_used),data_y(cond_used),'.b','MarkerSize',ms)
xlabel('R_{rs}(555)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_660
cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_660_mean_mid_three]);
cond_used = cond1;

subplot(2,3,5)
data_x = [GOCI_DailyStatMatrix.Rrs_660_mean_mid_three];
data_y = [GOCI_DailyStatMatrix.solz_center_value_03];
plot(data_x(cond_used),data_y(cond_used),'.b','MarkerSize',ms)
xlabel('R_{rs}(660)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

% Rrs_680
cond1 = ~isnan([GOCI_DailyStatMatrix.Rrs_680_mean_mid_three]);
cond_used = cond1;

subplot(2,3,6)
data_x = [GOCI_DailyStatMatrix.Rrs_680_mean_mid_three];
data_y = [GOCI_DailyStatMatrix.solz_center_value_03];
plot(data_x(cond_used),data_y(cond_used),'.b','MarkerSize',ms)
xlabel('R_{rs}(680)','FontSize',fs)
ylabel('Solar Zenith Angle (^o)','FontSize',fs)
grid on

%% Plot Monthly Rrs GOCI vs AQUA and VIIRS
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

save_opt = 0;

brdf_opt = 7;

wl = {'412','443','490','555','660','680'};
for idx0 = 1:size(wl,2)
      cond_brdf = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt;
      
      h2 = figure('Color','white','DefaultAxesFontSize',fs);
      
      data_used_x = [GOCI_MonthlyStatMatrix.datetime];
      data_used_x = data_used_x(cond_brdf);
      
      eval(sprintf('data_used_y = [GOCI_MonthlyStatMatrix.Rrs_%s_mean_mid_three];',wl{idx0}))
      data_used_y = data_used_y(cond_brdf);
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
      
      eval(sprintf('data_used_y = [AQUA_MonthlyStatMatrix.Rrs_%s_mean];',wl_AQUA));
      data_used_y = data_used_y(cond_used);
      data_used_x = [AQUA_MonthlyStatMatrix.datetime];
      data_used_x = data_used_x(cond_used);
      
      fs = 25;
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
            %       elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            %             wl_VIIRS = '671';
      end
      
      cond_brdf = [VIIRS_MonthlyStatMatrix.brdf_opt] == brdf_opt;
      
      eval(sprintf('cond1 = ~isnan([VIIRS_MonthlyStatMatrix.Rrs_%s_mean]);',wl_VIIRS));
      cond_used = cond1&cond_brdf;
      
      eval(sprintf('data_used_y = [VIIRS_MonthlyStatMatrix.Rrs_%s_mean];',wl_VIIRS));
      data_used_y = data_used_y(cond_used);
      data_used_x = [VIIRS_MonthlyStatMatrix.datetime];
      data_used_x = data_used_x(cond_used);
      
      fs = 25;
      if ~strcmp(wl{idx0},'680')
            figure(h2)
            hold on
            plot(data_used_x(~isnan(data_used_y)),data_used_y(~isnan(data_used_y)),'k','MarkerSize',12,'LineWidth',lw)
            eval(sprintf('ylabel(''R_{rs}(%s)'',''FontSize'',fs)',wl{idx0}));
            grid on
            set(gcf, 'renderer','painters')
      end
      
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
            legend('GOCI: 680 nm','MODISA: 678 nm')
      end
      
      %       legend boxoff
      
      if save_opt
            screen_size = get(0, 'ScreenSize');
            origSize = get(gcf, 'Position'); % grab original on screen size
            set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
            set(gcf,'PaperPositionMode','auto') %set paper pos for printing
            saveas(gcf,[savedirname 'CrossComp_Rrs' wl{idx0}],'epsc')
      end
      
end

%% Create DESEASONED data based on GOCI_Data.m
clear Climatology_GOCI_data
solz_lim = 90;
senz_lim = 60;
% CV_lim = 0.3;
% CV_lim = nanmean([GOCI_Data.median_CV])+nanstd([GOCI_Data.median_CV]);
brdf_opt = 7;

par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

for idx_par = 1:size(par_vec,2)
      for idx_month = 1:12
            cond_time = month([GOCI_Data.datetime])==idx_month;
            eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx_par}));
            eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx_par}));
            cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
            cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
            cond_CV = [GOCI_Data.median_CV]<=CV_lim;
            cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
            cond_used = cond_time&cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
            
            
            for idx_hour = 1:8
                  cond_tod = (hour([GOCI_Data.datetime])==idx_hour-1); % cond for time of the day
                  eval(sprintf('data_aux = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}));
                  eval(sprintf('Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_hour) = nanmean(data_aux(cond_used&cond_tod));',par_vec{idx_par}));
            end
            
      end
end

%% mean Rrs vs zenith -- DESEASONED filtered, by season but color coded by time of the day
% Spring - from March 1 to May 31; 3, 4, 5
% Summer - from June 1 to August 31; 6, 7, 8
% Fall (autumn) - from September 1 to November 30; and, 9, 10, 11
% Winter - from December 1 to February 28 (February 29 in a leap year). 12, 1, 2
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

fs = 60;
ms = 8;
lw = 2;
solz_lim = 90;
senz_lim = 60;
% CV_lim = 0.3;
% CV_lim = nanmean([GOCI_Data.median_CV])+nanstd([GOCI_Data.median_CV]);
brdf_opt = 7;

par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};
par_season = {'Spring','Summer','Fall','Winter'};

for idx_par = 1:size(par_vec,2)
      eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx_par}))
      eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx_par}))
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_CV = [GOCI_Data.median_CV]<=CV_lim;
      cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
      cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
      
      eval(sprintf('data_x = [GOCI_Data.%s_filtered_mean];',par_vec{idx_par}))
      data_y = [GOCI_Data.solz_center_value];
      
      for idx_season = 1:size(par_season,2)
            
            h = figure('Color','white','DefaultAxesFontSize',fs);
            title(par_season{idx_season})
            N = 0;
            switch par_season{idx_season}
                  case 'Spring'
                        cond_season = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
                  case 'Summer'
                        cond_season = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
                  case 'Fall'
                        cond_season = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
                  case 'Winter'
                        cond_season = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
            end
            
            for idx_month = 1:12
                  for idx_tod = 1:8;
                        if idx_tod == 1
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==0 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'or','MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 2
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==1 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'og','MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 3
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==2 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'ob','MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 4
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==3 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'ok','MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 5
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==4 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'oc','MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 6
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==5 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'om','MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 7
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==6 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
                        elseif idx_tod == 8
                              hold on
                              cond_tod = (hour([GOCI_Data.datetime])==7 & month([GOCI_Data.datetime])==idx_month); % cond for time of the day
                              eval(sprintf('data_x_used = data_x(cond_used&cond_season&cond_tod)-Climatology_GOCI_data.%s.Month(idx_month).Hour(idx_tod);',par_vec{idx_par}))
                              data_y_used = data_y(cond_used&cond_season&cond_tod);
                              plot(data_x_used,data_y_used,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
                        end
                        
                        N= N + sum(cond_used&cond_season&cond_tod);
                  end
            end
            
            switch par_vec{idx_par}
                  case 'Rrs_412'
                        x_str = 'R_{rs}(412) [sr^{-1}]';
                        xlim([-6E-3 6E-3])
                  case 'Rrs_443'
                        x_str = 'R_{rs}(443) [sr^{-1}]';
                        xlim([-3E-3 3E-3])
                  case 'Rrs_490'
                        x_str = 'R_{rs}(490) [sr^{-1}]';
                        xlim([-2E-3 2E-3])
                  case 'Rrs_555'
                        x_str = 'R_{rs}(555) [sr^{-1}]';
                        xlim([-1E-3 1E-3])
                  case 'Rrs_660'
                        x_str = 'R_{rs}(660) [sr^{-1}]';
                        xlim([-3E-4 3E-4])
                  case 'Rrs_680'
                        x_str = 'R_{rs}(680) [sr^{-1}]';
                        xlim([-8E-4 8E-4])
                  case 'chlor_a'
                        x_str = 'Chl-{\ita} [mg m^{-3}]';
                        xlim([-0.08 0.08])
                  case 'ag_412_mlrc'
                        x_str = 'a_{g}(412) [m^{-1}]';
                        xlim([-0.015 0.015])
                  case 'poc'
                        x_str = 'POC [mg m^{-3}]';
                        xlim([-20 20])
            end
            
            xlabel(x_str,'FontSize',fs)
            ylabel('Solar Zenith Angle (^o)','FontSize',fs)
            ylim([0 90])
            grid on
            
            str1 = sprintf('N = %i',N);
            title([par_season{idx_season} '; ' str1],'FontSize',fs-2,'FontWeight','Normal')
            
            % to create dummy data and create a custon legend
            p = zeros(8,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
            clear p
            
            set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
            eval(sprintf('saveas(gcf,[savedirname ''%s_vs_Zenith_%s_tod_detrend''],''epsc'')',par_vec{idx_par},par_season{idx_season}))
            
            
      end
end
% % %
%% Detrending Data Rrs - subtract monthly hourly means, color coded by time of the day

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

fs = 40;
ms = 5;
lw = 2;

solz_lim = 90;
senz_lim = 60;
% CV_lim = 0.3;
% CV_lim = nanmean([GOCI_Data.median_CV])+nanstd([GOCI_Data.median_CV]);
brdf_opt = 7;

wl_vec = {'412','443','490','555','660','680'};
for idx0 = 1:size(wl_vec,2)
      N = 0; % total number of points per band
      
      h = figure('Color','white','DefaultAxesFontSize',fs);
      for idx_month = 1:12
            cond_time = month([GOCI_Data.datetime])==idx_month;
            eval(sprintf('cond_nan = ~isnan([GOCI_Data.Rrs_%s_filtered_mean]);',wl_vec{idx0}));
            eval(sprintf('cond_area = [GOCI_Data.Rrs_%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',wl_vec{idx0}));
            cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
            cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
            cond_CV = [GOCI_Data.median_CV]<=CV_lim;
            cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
            cond_used = cond_time&cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
            
            figure(gcf)
            hold on
            
            % 0h
            cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'or','MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            hold on
            % 1h
            cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'og','MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            hold on
            % 2h
            cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}))
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'ob','MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            hold on
            % 3h
            cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}))
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'ok','MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            % 4h
            cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}))
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'oc','MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            hold on
            % 5h
            cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}))
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'om','MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            hold on
            % 6h
            cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}))
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'o','Color',[1 .5 0],'MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
            hold on
            % 7h
            cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
            eval(sprintf('data_aux = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}));
            mean_month_hour = nanmean(data_aux(cond_used&cond_tod));
            eval(sprintf('data_aux_x = [GOCI_Data.Rrs_%s_filtered_mean];',wl_vec{idx0}))
            data_aux_x = data_aux_x((cond_used&cond_tod));
            data_aux_y = [GOCI_Data.solz_center_value];
            data_aux_y = data_aux_y(cond_used&cond_tod);
            plot(data_aux_x-mean_month_hour,data_aux_y,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            N = N + sum(cond_used&cond_tod);
            
      end
      
      figure(gcf)
      eval(sprintf('xlabel(''R_{rs}(%s) [sr^{-1}]'',''FontSize'',fs)',wl_vec{idx0}));
      ylabel('Solar Zenith Angle (^o)','FontSize',fs)
      ylim([0 90])
      grid on
      
      str1 = sprintf('N = %i',N);
      title(str1,'FontSize',fs-2,'FontWeight','Normal')
      N = 0;
      
      % to create dummy data and create a custon legend
      if idx0==6
            p = zeros(8,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      end
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      saveas(gcf,[savedirname 'Rrs_vs_Zenith_detrend_' wl_vec{idx0} '_2'],'epsc')
      
end

%% Detrending Data Rrs - subtract monthly hourly means, color coded by time of the day
% -- from data created in GOCI_DailtyStatMatrix

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

fs = 40;
ms = 5;
lw = 2;
% solz_lim = 75;
% senz_lim = 60;
% CV_lim = 0.3;
brdf_opt = 7;

wl_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680'};
for idx0 = 1:size(wl_vec,2)
      N = 0; % total number of points per band
      
      h = figure('Color','white','DefaultAxesFontSize',fs);
      
      cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
      
      hold on
      % 0h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_00_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_00];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'or','MarkerSize',ms,'LineWidth',lw);
      hold on
      
      % 1h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_01_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_01];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'og','MarkerSize',ms,'LineWidth',lw);
      
      hold on
      % 2h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_02_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_02];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'ob','MarkerSize',ms,'LineWidth',lw);
      
      hold on
      % 3h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_03_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_03];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'ok','MarkerSize',ms,'LineWidth',lw);
      
      % 4h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_04_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_04];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'oc','MarkerSize',ms,'LineWidth',lw);
      
      hold on
      % 5h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_05_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_05];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'om','MarkerSize',ms,'LineWidth',lw);
      
      hold on
      % 6h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_06_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_06];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
      
      hold on
      % 7h
      eval(sprintf('cond_nan = ~isnan([GOCI_DailyStatMatrix.%s_07_detrend]);',wl_vec{idx0}));
      cond_used = cond_brdf&cond_nan;
      
      eval(sprintf('x_used = [GOCI_DailyStatMatrix.%s_00_detrend];',wl_vec{idx0}));
      y_used = [GOCI_DailyStatMatrix.solz_center_value_07];
      N = N + sum(cond_used);
      plot(x_used(cond_used),y_used(cond_used),'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
      
      figure(gcf)
      eval(sprintf('xlabel(''R_{rs}(%s) [sr^{-1}]'',''FontSize'',fs)',wl_vec{idx0}));
      ylabel('Solar Zenith Angle (^o)','FontSize',fs)
      ylim([0 90])
      grid on
      
      str1 = sprintf('N = %i',N);
      title(str1,'FontSize',fs-2,'FontWeight','Normal')
      
      % to create dummy data and create a custon legend
      if idx0==6
            p = zeros(8,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      end
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      % saveas(gcf,[savedirname 'Rrs_vs_Zenith_detrend_' wl_vec{idx0} '_2'],'epsc')
      
end

%% Detrending Data par - subtract monthly hourly means, color coded by time of the day

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

N = 0;

par_vec = {'chlor_a','ag_412_mlrc','poc'};

for idx0 = 1:size(par_vec,2)
      h = figure('Color','white','DefaultAxesFontSize',fs);
      
      if strcmp(par_vec{idx0},'chlor_a')
            par_char = 'Chlor-{\ita} [mg m^{-3}]';
      elseif strcmp(par_vec{idx0},'ag_412_mlrc')
            par_char = 'a_{g}(412) [m^{-1}]';
      elseif strcmp(par_vec{idx0},'poc')
            par_char = 'POC [mg m^{-3}]';
      end
      
      for idx_month = 1:12
            for idx_hour = 0:7
                  cond_time = month([GOCI_Data.datetime])==idx_month & ...
                        hour([GOCI_Data.datetime])==idx_hour;
                  eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx0}));
                  eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx0}));
                  cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
                  cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
                  cond_CV = [GOCI_Data.median_CV]<=CV_lim;
                  cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
                  cond_used = cond_time&cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
                  
                  N = N + sum(cond_used);
                  
                  eval(sprintf('mean_month_hour = nanmean([GOCI_Data(cond_used).%s_filtered_mean]);',par_vec{idx0}));
                  
                  figure(gcf)
                  hold on
                  % 0h
                  cond_tod = (hour([GOCI_Data.datetime])==0); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''or'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % 1h
                  cond_tod = (hour([GOCI_Data.datetime])==1); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''og'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % 2h
                  cond_tod = (hour([GOCI_Data.datetime])==2); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''ob'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % 3h
                  cond_tod = (hour([GOCI_Data.datetime])==3); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''ok'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  % 4h
                  cond_tod = (hour([GOCI_Data.datetime])==4); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''oc'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % 5h
                  cond_tod = (hour([GOCI_Data.datetime])==5); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''om'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % 6h
                  cond_tod = (hour([GOCI_Data.datetime])==6); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''o'',''Color'',[1 0.5 0],''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % 7h
                  cond_tod = (hour([GOCI_Data.datetime])==7); % cond for time of the day
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''o'',''Color'',[0.5 0 0.5],''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  
            end
      end
      
      figure(gcf)
      eval(sprintf('xlabel(''%s'',''FontSize'',fs)',par_char));
      ylabel('Solar Zenith Angle (^o)','FontSize',fs)
      ylim([0 90])
      grid on
      
      str1 = sprintf('N = %i',N);
      title(str1,'FontSize',fs-2,'FontWeight','Normal')
      N = 0;
      
      % to create dummy data and create a custon legend
      if idx0==2
            p = zeros(8,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            p(5) = plot(NaN,NaN,'oc','MarkerSize',ms,'LineWidth',lw);
            p(6) = plot(NaN,NaN,'om','MarkerSize',ms,'LineWidth',lw);
            p(7) = plot(NaN,NaN,'o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw);
            p(8) = plot(NaN,NaN,'o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw);
            legend(p,'0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      end
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      saveas(gcf,[savedirname 'Par_vs_Zenith_detrend_' par_vec{idx0} '_2'],'epsc')
      
end

%% Detrending Data Rrs - subtract monthly hourly means, color coded by season

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

N = 0; % total number of points per band

wl_vec = {'412','443','490','555','660','680'};
for idx0 = 1:size(wl_vec,2)
      h = figure('Color','white','DefaultAxesFontSize',fs);
      for idx_month = 1:12
            for idx_hour = 0:7
                  cond_time = month([GOCI_Data.datetime])==idx_month & ...
                        hour([GOCI_Data.datetime])==idx_hour;
                  eval(sprintf('cond_nan = ~isnan([GOCI_Data.Rrs_%s_filtered_mean]);',wl_vec{idx0}));
                  eval(sprintf('cond_area = [GOCI_Data.Rrs_%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',wl_vec{idx0}));
                  cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
                  cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
                  cond_CV = [GOCI_Data.median_CV]<=CV_lim;
                  cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
                  cond_used = cond_time&cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
                  
                  N = N + sum(cond_used);
                  
                  eval(sprintf('mean_month_hour = nanmean([GOCI_Data(cond_used).Rrs_%s_filtered_mean]);',wl_vec{idx0}));
                  
                  figure(gcf)
                  hold on
                  
                  % Spring
                  cond_tod = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).Rrs_%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''or'',''MarkerSize'',ms,''LineWidth'',lw);',wl_vec{idx0}));
                  
                  hold on
                  % Summer
                  cond_tod = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).Rrs_%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''og'',''MarkerSize'',ms,''LineWidth'',lw);',wl_vec{idx0}));
                  
                  hold on
                  % Fall
                  cond_tod = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).Rrs_%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''ob'',''MarkerSize'',ms,''LineWidth'',lw);',wl_vec{idx0}));
                  
                  hold on
                  % Winter
                  cond_tod = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).Rrs_%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''ok'',''MarkerSize'',ms,''LineWidth'',lw);',wl_vec{idx0}));
                  
                  
            end
      end
      
      figure(gcf)
      eval(sprintf('xlabel(''R_{rs}(%s) [sr^{-1}]'',''FontSize'',fs)',wl_vec{idx0}));
      ylabel('Solar Zenith Angle (^o)','FontSize',fs)
      ylim([0 90])
      grid on
      
      str1 = sprintf('N = %i',N);
      title(str1,'FontSize',fs-2,'FontWeight','Normal')
      N = 0;
      
      % to create dummy data and create a custon legend
      if idx0==6&&idx_month==12&&idx_hour==7
            p = zeros(4,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            legend(p,'Spring','Summer','Fall','Winter','Location','northeast')
      end
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      saveas(gcf,[savedirname 'Rrs_vs_Zenith_detrend_' wl_vec{idx0} '_season'],'epsc')
      
end

%% Detrending Data par - subtract monthly hourly means, color coded by season

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

N = 0;

par_vec = {'chlor_a','ag_412_mlrc','poc'};

for idx0 = 1:size(par_vec,2)
      h = figure('Color','white','DefaultAxesFontSize',fs);
      
      if strcmp(par_vec{idx0},'chlor_a')
            par_char = 'Chlor-{\ita} [mg m^{-3}]';
      elseif strcmp(par_vec{idx0},'ag_412_mlrc')
            par_char = 'a_{g}(412) [m^{-1}]';
      elseif strcmp(par_vec{idx0},'poc')
            par_char = 'POC [mg m^{-3}]';
      end
      
      for idx_month = 1:12
            for idx_hour = 0:7
                  cond_time = month([GOCI_Data.datetime])==idx_month & ...
                        hour([GOCI_Data.datetime])==idx_hour;
                  eval(sprintf('cond_nan = ~isnan([GOCI_Data.%s_filtered_mean]);',par_vec{idx0}));
                  eval(sprintf('cond_area = [GOCI_Data.%s_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;',par_vec{idx0}));
                  cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
                  cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
                  cond_CV = [GOCI_Data.median_CV]<=CV_lim;
                  cond_brdf = [GOCI_Data.brdf_opt] == brdf_opt;
                  cond_used = cond_time&cond_nan&cond_area&cond_solz&cond_senz&cond_CV&cond_brdf;
                  
                  N = N + sum(cond_used);
                  
                  eval(sprintf('mean_month_hour = nanmean([GOCI_Data(cond_used).%s_filtered_mean]);',par_vec{idx0}));
                  
                  figure(gcf)
                  hold on
                  % Spring
                  cond_tod = month([GOCI_Data.datetime])==3|month([GOCI_Data.datetime])==4|month([GOCI_Data.datetime])==5; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''or'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % Summer
                  cond_tod = month([GOCI_Data.datetime])==6|month([GOCI_Data.datetime])==7|month([GOCI_Data.datetime])==8; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''og'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % Fall
                  cond_tod = month([GOCI_Data.datetime])==9|month([GOCI_Data.datetime])==10|month([GOCI_Data.datetime])==11; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''ob'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
                  hold on
                  % Winter
                  cond_tod = month([GOCI_Data.datetime])==12|month([GOCI_Data.datetime])==1|month([GOCI_Data.datetime])==2; % cond for season
                  eval(sprintf('plot([GOCI_Data(cond_used&cond_tod).%s_filtered_mean]-mean_month_hour,[GOCI_Data(cond_used&cond_tod).solz_center_value],''ok'',''MarkerSize'',ms,''LineWidth'',lw);',par_vec{idx0}));
                  
            end
      end
      
      figure(gcf)
      eval(sprintf('xlabel(''%s'',''FontSize'',fs)',par_char));
      ylabel('Solar Zenith Angle (^o)','FontSize',fs)
      ylim([0 90])
      grid on
      
      str1 = sprintf('N = %i',N);
      title(str1,'FontSize',fs-2,'FontWeight','Normal')
      N = 0;
      
      % to create dummy data and create a custon legend
      if idx0==3&&idx_month==12&&idx_hour==7
            p = zeros(4,1);
            p(1) = plot(NaN,NaN,'or','MarkerSize',ms,'LineWidth',lw);
            p(2) = plot(NaN,NaN,'og','MarkerSize',ms,'LineWidth',lw);
            p(3) = plot(NaN,NaN,'ob','MarkerSize',ms,'LineWidth',lw);
            p(4) = plot(NaN,NaN,'ok','MarkerSize',ms,'LineWidth',lw);
            legend(p,'Spring','Summer','Fall','Winter','Location','northeast')
      end
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      saveas(gcf,[savedirname 'Par_vs_Zenith_detrend_' par_vec{idx0} '_season'],'epsc')
      
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
      % cond3 = [AQUA_Data.center_ze] <= solz_lim;
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
      % cond3 = [VIIRS_Data.center_ze] <= solz_lim;
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

% %% Plot difference from the daily mean for Rrs
% % The difference of the mean
%
% wl = {'412','443','490','555','660','680'};
%
% for idx = 1:size(wl,2)
%
%       eval(sprintf('diff_mean_00= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]);',wl{idx}))
%       eval(sprintf('diff_stdv_00= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]);',wl{idx}))
%
%       eval(sprintf('diff_mean_01= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]);',wl{idx}))
%       eval(sprintf('diff_stdv_01= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]);',wl{idx}))
%
%       eval(sprintf('diff_mean_02= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]);',wl{idx}))
%       eval(sprintf('diff_stdv_02= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]);',wl{idx}))
%
%       eval(sprintf('diff_mean_03= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]);',wl{idx}))
%       eval(sprintf('diff_stdv_03= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]);',wl{idx}))
%
%       eval(sprintf('diff_mean_04= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]);',wl{idx}))
%       eval(sprintf('diff_stdv_04= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]);',wl{idx}))
%
%       eval(sprintf('diff_mean_05= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]);',wl{idx}))
%       eval(sprintf('diff_stdv_05= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]);',wl{idx}))
%
%       eval(sprintf('diff_mean_06= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]);',wl{idx}))
%       eval(sprintf('diff_stdv_06= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]);',wl{idx}))
%
%       eval(sprintf('diff_mean_07= nanmean([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]);',wl{idx}))
%       eval(sprintf('diff_stdv_07= nanstd([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]);',wl{idx}))
%
%       diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
%
%       diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
%
%       fs = 25;
%       h = figure('Color','white','DefaultAxesFontSize',fs);
%       % plot(1:8,stdv_all,'or','MarkerSize',12)
%       errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
%       ax = gca;
%       ax.XTick = 1:8;
%       ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
%       xlim([0 9])
%       %       ylim([-3e-3 1e-3])
%
%       str1 = sprintf('Difference\n w/r to the daily mean\n  Rrs(%s) (1/sr)',wl{idx});
%
%       ylabel(str1,'FontSize',fs)
%       xlabel('Local Time','FontSize',fs)
%
%       grid on
% end

% %% Plot absolute difference from the daily mean for Rrs
% % The difference of the mean
%
% wl = {'412','443','490','555','660','680'};
%
% for idx = 1:size(wl,2)
%
%       eval(sprintf('abs_diff_mean_00= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_00= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_00]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_01= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_01= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_01]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_02= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_02= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_02]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_03= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_03= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_03]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_04= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_04= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_04]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_05= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_05= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_05]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_06= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_06= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_06]));',wl{idx}))
%
%       eval(sprintf('abs_diff_mean_07= nanmean(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]));',wl{idx}))
%       eval(sprintf('abs_diff_stdv_07= nanstd(abs([GOCI_DailyStatMatrix.Rrs_%s_diff_w_r_daily_mean_07]));',wl{idx}))
%
%       abs_diff_stdv_all = [abs_diff_stdv_00,abs_diff_stdv_01,abs_diff_stdv_02,abs_diff_stdv_03,abs_diff_stdv_04,abs_diff_stdv_05,abs_diff_stdv_06,abs_diff_stdv_07];
%
%       abs_diff_mean_all = [abs_diff_mean_00,abs_diff_mean_01,abs_diff_mean_02,abs_diff_mean_03,abs_diff_mean_04,abs_diff_mean_05,abs_diff_mean_06,abs_diff_mean_07];
%
%       fs = 25;
%       h = figure('Color','white','DefaultAxesFontSize',fs);
%       % plot(1:8,stdv_all,'or','MarkerSize',12)
%       errorbar(1:8,abs_diff_mean_all,abs_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
%       ax = gca;
%       ax.XTick = 1:8;
%       ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
%       xlim([0 9])
%       %       ylim([-3e-3 1e-3])
%
%       str1 = sprintf('Absolute difference\n w/r to the daily mean\n  Rrs(%s) (1/sr)',wl{idx});
%
%       ylabel(str1,'FontSize',fs)
%       xlabel('Local Time','FontSize',fs)
%
%       grid on
% end

% %% Plot relative difference from the daily mean for Rrs
% % The difference of the mean
% savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';
%
%
% wl = {'412','443','490','555','660','680'};
%
% brdf_opt = 7;
%
% cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
%
% for idx = 1:size(wl,2)
%
%       eval(sprintf('rel_diff_mean_00= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_00= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_01= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_01= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_02= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_02= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_03= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_03= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_04= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_04= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_05= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_05= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_06= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_06= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       eval(sprintf('rel_diff_mean_07= nanmean(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%       eval(sprintf('rel_diff_stdv_07= nanstd(100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mean]));',wl{idx},wl{idx}))
%
%       rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
%       rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
%
%       fs = 25;
%       h = figure('Color','white','DefaultAxesFontSize',fs);
%       % plot(1:8,stdv_all,'or','MarkerSize',12)
%       errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
%       ax = gca;
%       ax.XTick = 1:8;
%       ax.XTickLabel = {'09h','10h','11h','12h','13h','14h','15h','16h'};
%       xlim([0 9])
%
%       disp('======================')
%       disp(wl{idx})
%       rel_diff_mean_all
%       rel_diff_stdv_all
%       %       ylim([-3e-3 1e-3])
%
%       ax.YAxis.MinorTick = 'on';
%       ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
%       ax.YGrid = 'on';
%       ax.YMinorGrid = 'on';
%       %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
%       str1 = sprintf('Relative difference\n w/r to the daily mean\n  Rrs(%s) [%%]',wl{idx});
%
%       ylabel(str1,'FontSize',fs)
%       xlabel('Local Time','FontSize',fs)
%
%       grid on
%       %       grid minor
%
%       saveas(gcf,[savedirname 'Rel_Diff_Daily_Mean_Rrs' wl{idx}],'epsc')
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from the three midday for par
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};


brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412)';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443)';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490)';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555)';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660)';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680)';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita}';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412)';
            case 'poc'
                  y_str = 'POC';
      end
      eval(sprintf('mean_mid_three= nanmean(abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]));',par_vec{idx}));
      
      %%
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_00]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      rel_diff_N_00 = sum(cond_filter);
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_01]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      rel_diff_N_01 = sum(cond_filter);
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_02]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      rel_diff_N_02 = sum(cond_filter);
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_03]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      rel_diff_N_03 = sum(cond_filter);
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_04]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      rel_diff_N_04 = sum(cond_filter);
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_05]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      rel_diff_N_05 = sum(cond_filter);
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_06]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      rel_diff_N_06 = sum(cond_filter);
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_07]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      rel_diff_N_07 = sum(cond_filter);
      
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,rel_diff_mean_00+1.3*rel_diff_stdv_00,['N=' num2str(rel_diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,rel_diff_mean_01+1.3*rel_diff_stdv_01,['N=' num2str(rel_diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,rel_diff_mean_02+1.3*rel_diff_stdv_02,['N=' num2str(rel_diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,rel_diff_mean_03+1.3*rel_diff_stdv_03,['N=' num2str(rel_diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,rel_diff_mean_04+1.3*rel_diff_stdv_04,['N=' num2str(rel_diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,rel_diff_mean_05+1.3*rel_diff_stdv_05,['N=' num2str(rel_diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,rel_diff_mean_06+1.3*rel_diff_stdv_06,['N=' num2str(rel_diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,rel_diff_mean_07+1.3*rel_diff_stdv_07,['N=' num2str(rel_diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      mean_mid_three
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to mean middle three\n  %s [%%]',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Rel_Diff_mid_three_' par_vec{idx}],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from the three midday for Rrs -- ONLY SUMMER
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
% Summer
cond_tod = month([GOCI_DailyStatMatrix.datetime])==6|month([GOCI_DailyStatMatrix.datetime])==7|month([GOCI_DailyStatMatrix.datetime])==8; % cond for season
cond_used = cond_brdf&cond_tod;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412)';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443)';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490)';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555)';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660)';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680)';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita}';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412)';
            case 'poc'
                  y_str = 'POC';
      end
      eval(sprintf('mean_mid_three= nanmean(abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]));',par_vec{idx}));
      
      %%
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_00]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      rel_diff_N_00 = sum(cond_filter);
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_01]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      rel_diff_N_01 = sum(cond_filter);
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_02]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      rel_diff_N_02 = sum(cond_filter);
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_03]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      rel_diff_N_03 = sum(cond_filter);
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_04]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      rel_diff_N_04 = sum(cond_filter);
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_05]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      rel_diff_N_05 = sum(cond_filter);
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_06]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      rel_diff_N_06 = sum(cond_filter);
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_07]./abs([GOCI_DailyStatMatrix(cond_used).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      rel_diff_N_07 = sum(cond_filter);
      
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,rel_diff_mean_00+1.3*rel_diff_stdv_00,['N=' num2str(rel_diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,rel_diff_mean_01+1.3*rel_diff_stdv_01,['N=' num2str(rel_diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,rel_diff_mean_02+1.3*rel_diff_stdv_02,['N=' num2str(rel_diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,rel_diff_mean_03+1.3*rel_diff_stdv_03,['N=' num2str(rel_diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,rel_diff_mean_04+1.3*rel_diff_stdv_04,['N=' num2str(rel_diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,rel_diff_mean_05+1.3*rel_diff_stdv_05,['N=' num2str(rel_diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,rel_diff_mean_06+1.3*rel_diff_stdv_06,['N=' num2str(rel_diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,rel_diff_mean_07+1.3*rel_diff_stdv_07,['N=' num2str(rel_diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      mean_mid_three
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to mean middle three\n  %s [%%]',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Rel_Diff_mid_three_' par_vec{idx} '_summer'],'epsc')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Difference from the three midday for Rrs
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412) [sr^{-1}]';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443) [sr^{-1}]';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490) [sr^{-1}]';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555) [sr^{-1}]';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660) [sr^{-1}]';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680) [sr^{-1}]';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita} [mg m^{-3}]';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412) [m^{-1}]';
            case 'poc'
                  y_str = 'POC [mg m^{-3}]';
      end
      %%
      eval(sprintf('diff_00= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_00];',par_vec{idx}));
      cond_filter = abs(diff_00) <= nanmean(diff_00)+3*nanstd(diff_00);
      diff_mean_00 = nanmean(diff_00(cond_filter));
      diff_stdv_00 = nanstd(diff_00(cond_filter));
      diff_N_00 = sum(cond_filter);
      
      eval(sprintf('diff_01= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_01];',par_vec{idx}));
      cond_filter = abs(diff_01) <= nanmean(diff_01)+3*nanstd(diff_01);
      diff_mean_01 = nanmean(diff_01(cond_filter));
      diff_stdv_01 = nanstd(diff_01(cond_filter));
      diff_N_01 = sum(cond_filter);
      
      eval(sprintf('diff_02= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_02];',par_vec{idx}));
      cond_filter = abs(diff_02) <= nanmean(diff_02)+3*nanstd(diff_02);
      diff_mean_02 = nanmean(diff_02(cond_filter));
      diff_stdv_02 = nanstd(diff_02(cond_filter));
      diff_N_02 = sum(cond_filter);
      
      eval(sprintf('diff_03= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_03];',par_vec{idx}));
      cond_filter = abs(diff_03) <= nanmean(diff_03)+3*nanstd(diff_03);
      diff_mean_03 = nanmean(diff_03(cond_filter));
      diff_stdv_03 = nanstd(diff_03(cond_filter));
      diff_N_03 = sum(cond_filter);
      
      eval(sprintf('diff_04= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_04];',par_vec{idx}));
      cond_filter = abs(diff_04) <= nanmean(diff_04)+3*nanstd(diff_04);
      diff_mean_04 = nanmean(diff_04(cond_filter));
      diff_stdv_04 = nanstd(diff_04(cond_filter));
      diff_N_04 = sum(cond_filter);
      
      eval(sprintf('diff_05= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_05];',par_vec{idx}));
      cond_filter = abs(diff_05) <= nanmean(diff_05)+3*nanstd(diff_05);
      diff_mean_05 = nanmean(diff_05(cond_filter));
      diff_stdv_05 = nanstd(diff_05(cond_filter));
      diff_N_05 = sum(cond_filter);
      
      eval(sprintf('diff_06= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_06];',par_vec{idx}));
      cond_filter = abs(diff_06) <= nanmean(diff_06)+3*nanstd(diff_06);
      diff_mean_06 = nanmean(diff_06(cond_filter));
      diff_stdv_06 = nanstd(diff_06(cond_filter));
      diff_N_06 = sum(cond_filter);
      
      eval(sprintf('diff_07= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_07];',par_vec{idx}));
      cond_filter = abs(diff_07) <= nanmean(diff_07)+3*nanstd(diff_07);
      diff_mean_07 = nanmean(diff_07(cond_filter));
      diff_stdv_07 = nanstd(diff_07(cond_filter));
      diff_N_07 = sum(cond_filter);
      
      
      diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
      diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,diff_mean_00+1.3*diff_stdv_00,['N=' num2str(diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,diff_mean_01+1.3*diff_stdv_01,['N=' num2str(diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,diff_mean_02+1.3*diff_stdv_02,['N=' num2str(diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,diff_mean_03+1.3*diff_stdv_03,['N=' num2str(diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,diff_mean_04+1.3*diff_stdv_04,['N=' num2str(diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,diff_mean_05+1.3*diff_stdv_05,['N=' num2str(diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,diff_mean_06+1.3*diff_stdv_06,['N=' num2str(diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,diff_mean_07+1.3*diff_stdv_07,['N=' num2str(diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      diff_mean_all
      diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Difference\n w/r to mean middle three\n  %s',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Diff_mid_three_' par_vec{idx}],'epsc')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Difference from the three midday for Rrs -- ONLY SUMMERS
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
% Summer
cond_tod = month([GOCI_DailyStatMatrix.datetime])==6|month([GOCI_DailyStatMatrix.datetime])==7|month([GOCI_DailyStatMatrix.datetime])==8; % cond for season
cond_used = cond_brdf&cond_tod;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412) [sr^{-1}]';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443) [sr^{-1}]';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490) [sr^{-1}]';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555) [sr^{-1}]';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660) [sr^{-1}]';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680) [sr^{-1}]';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita} [mg m^{-3}]';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412) [m^{-1}]';
            case 'poc'
                  y_str = 'POC [mg m^{-3}]';
      end
      %%
      eval(sprintf('diff_00= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_00];',par_vec{idx}));
      cond_filter = abs(diff_00) <= nanmean(diff_00)+3*nanstd(diff_00);
      diff_mean_00 = nanmean(diff_00(cond_filter));
      diff_stdv_00 = nanstd(diff_00(cond_filter));
      diff_N_00 = sum(cond_filter);
      
      eval(sprintf('diff_01= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_01];',par_vec{idx}));
      cond_filter = abs(diff_01) <= nanmean(diff_01)+3*nanstd(diff_01);
      diff_mean_01 = nanmean(diff_01(cond_filter));
      diff_stdv_01 = nanstd(diff_01(cond_filter));
      diff_N_01 = sum(cond_filter);
      
      eval(sprintf('diff_02= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_02];',par_vec{idx}));
      cond_filter = abs(diff_02) <= nanmean(diff_02)+3*nanstd(diff_02);
      diff_mean_02 = nanmean(diff_02(cond_filter));
      diff_stdv_02 = nanstd(diff_02(cond_filter));
      diff_N_02 = sum(cond_filter);
      
      eval(sprintf('diff_03= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_03];',par_vec{idx}));
      cond_filter = abs(diff_03) <= nanmean(diff_03)+3*nanstd(diff_03);
      diff_mean_03 = nanmean(diff_03(cond_filter));
      diff_stdv_03 = nanstd(diff_03(cond_filter));
      diff_N_03 = sum(cond_filter);
      
      eval(sprintf('diff_04= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_04];',par_vec{idx}));
      cond_filter = abs(diff_04) <= nanmean(diff_04)+3*nanstd(diff_04);
      diff_mean_04 = nanmean(diff_04(cond_filter));
      diff_stdv_04 = nanstd(diff_04(cond_filter));
      diff_N_04 = sum(cond_filter);
      
      eval(sprintf('diff_05= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_05];',par_vec{idx}));
      cond_filter = abs(diff_05) <= nanmean(diff_05)+3*nanstd(diff_05);
      diff_mean_05 = nanmean(diff_05(cond_filter));
      diff_stdv_05 = nanstd(diff_05(cond_filter));
      diff_N_05 = sum(cond_filter);
      
      eval(sprintf('diff_06= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_06];',par_vec{idx}));
      cond_filter = abs(diff_06) <= nanmean(diff_06)+3*nanstd(diff_06);
      diff_mean_06 = nanmean(diff_06(cond_filter));
      diff_stdv_06 = nanstd(diff_06(cond_filter));
      diff_N_06 = sum(cond_filter);
      
      eval(sprintf('diff_07= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_mid_three_07];',par_vec{idx}));
      cond_filter = abs(diff_07) <= nanmean(diff_07)+3*nanstd(diff_07);
      diff_mean_07 = nanmean(diff_07(cond_filter));
      diff_stdv_07 = nanstd(diff_07(cond_filter));
      diff_N_07 = sum(cond_filter);
      
      
      diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
      diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,diff_mean_00+1.3*diff_stdv_00,['N=' num2str(diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,diff_mean_01+1.3*diff_stdv_01,['N=' num2str(diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,diff_mean_02+1.3*diff_stdv_02,['N=' num2str(diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,diff_mean_03+1.3*diff_stdv_03,['N=' num2str(diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,diff_mean_04+1.3*diff_stdv_04,['N=' num2str(diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,diff_mean_05+1.3*diff_stdv_05,['N=' num2str(diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,diff_mean_06+1.3*diff_stdv_06,['N=' num2str(diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,diff_mean_07+1.3*diff_stdv_07,['N=' num2str(diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      diff_mean_all
      diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Difference\n w/r to mean middle three\n  %s',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Diff_mid_three_' par_vec{idx} '_summer'],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from the 4th time of day for par
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};


brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(par_vec,2)
      eval(sprintf('mean_4h= nanmean(abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]));',par_vec{idx}));
      
      %%
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_00]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      rel_diff_N_00 = sum(cond_filter);
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_01]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      rel_diff_N_01 = sum(cond_filter);
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_02]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      rel_diff_N_02 = sum(cond_filter);
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_03]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      rel_diff_N_03 = sum(cond_filter);
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_04]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      rel_diff_N_04 = sum(cond_filter);
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_05]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      rel_diff_N_05 = sum(cond_filter);
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_06]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      rel_diff_N_06 = sum(cond_filter);
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_07]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      rel_diff_N_07 = sum(cond_filter);
      
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};ax.YAxis.FontSize
%       ax.XAxis.FontSize = 18;
      ax.XTickLabelRotation = -40;
      xlim([0 9])
      
            switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412)';
                  ylim([-15 15])
            case 'Rrs_443'
                  y_str = 'R_{rs}(443)';
                  ylim([-15 15])
            case 'Rrs_490'
                  y_str = 'R_{rs}(490)';
                  ylim([-15 15])
            case 'Rrs_555'
                  y_str = 'R_{rs}(555)';
                  ylim([-20 20])
            case 'Rrs_660'
                  y_str = 'R_{rs}(660)';
                  ylim([-60 60])
            case 'Rrs_680'
                  y_str = 'R_{rs}(680)';
                  ylim([-150 150])
            case 'chlor_a'
                  y_str = 'Chlor-{\ita}';
                  ylim([-30 30])
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412)';
                  ylim([-15 15])
            case 'poc'
                  y_str = 'POC';
                  ylim([-20 20])
      end
      
      text(1,rel_diff_mean_00+1.3*rel_diff_stdv_00,['N=' num2str(rel_diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,rel_diff_mean_01+1.3*rel_diff_stdv_01,['N=' num2str(rel_diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,rel_diff_mean_02+1.3*rel_diff_stdv_02,['N=' num2str(rel_diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,rel_diff_mean_03+1.3*rel_diff_stdv_03,['N=' num2str(rel_diff_N_03)],'HorizontalAlignment','center','FontSize',14)
%       text(5,rel_diff_mean_04+1.3*rel_diff_stdv_04,['N=' num2str(rel_diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,rel_diff_mean_05+1.3*rel_diff_stdv_05,['N=' num2str(rel_diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,rel_diff_mean_06+1.3*rel_diff_stdv_06,['N=' num2str(rel_diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,rel_diff_mean_07+1.3*rel_diff_stdv_07,['N=' num2str(rel_diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      mean_4h
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('R\\Delta_t[%%]');
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Rel_Diff_4th_' par_vec{idx}],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Difference from the 4h for par
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412) [sr^{-1}]';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443) [sr^{-1}]';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490) [sr^{-1}]';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555) [sr^{-1}]';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660) [sr^{-1}]';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680) [sr^{-1}]';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita} [mg m^{-3}]';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412) [m^{-1}]';
            case 'poc'
                  y_str = 'POC [mg m^{-3}]';
      end
      %%
      eval(sprintf('diff_00= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_00];',par_vec{idx}));
      cond_filter = abs(diff_00) <= nanmean(diff_00)+3*nanstd(diff_00);
      diff_mean_00 = nanmean(diff_00(cond_filter));
      diff_stdv_00 = nanstd(diff_00(cond_filter));
      diff_N_00 = sum(cond_filter);
      
      eval(sprintf('diff_01= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_01];',par_vec{idx}));
      cond_filter = abs(diff_01) <= nanmean(diff_01)+3*nanstd(diff_01);
      diff_mean_01 = nanmean(diff_01(cond_filter));
      diff_stdv_01 = nanstd(diff_01(cond_filter));
      diff_N_01 = sum(cond_filter);
      
      eval(sprintf('diff_02= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_02];',par_vec{idx}));
      cond_filter = abs(diff_02) <= nanmean(diff_02)+3*nanstd(diff_02);
      diff_mean_02 = nanmean(diff_02(cond_filter));
      diff_stdv_02 = nanstd(diff_02(cond_filter));
      diff_N_02 = sum(cond_filter);
      
      eval(sprintf('diff_03= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_03];',par_vec{idx}));
      cond_filter = abs(diff_03) <= nanmean(diff_03)+3*nanstd(diff_03);
      diff_mean_03 = nanmean(diff_03(cond_filter));
      diff_stdv_03 = nanstd(diff_03(cond_filter));
      diff_N_03 = sum(cond_filter);
      
      eval(sprintf('diff_04= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_04];',par_vec{idx}));
      cond_filter = abs(diff_04) <= nanmean(diff_04)+3*nanstd(diff_04);
      diff_mean_04 = nanmean(diff_04(cond_filter));
      diff_stdv_04 = nanstd(diff_04(cond_filter));
      diff_N_04 = sum(cond_filter);
      
      eval(sprintf('diff_05= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_05];',par_vec{idx}));
      cond_filter = abs(diff_05) <= nanmean(diff_05)+3*nanstd(diff_05);
      diff_mean_05 = nanmean(diff_05(cond_filter));
      diff_stdv_05 = nanstd(diff_05(cond_filter));
      diff_N_05 = sum(cond_filter);
      
      eval(sprintf('diff_06= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_06];',par_vec{idx}));
      cond_filter = abs(diff_06) <= nanmean(diff_06)+3*nanstd(diff_06);
      diff_mean_06 = nanmean(diff_06(cond_filter));
      diff_stdv_06 = nanstd(diff_06(cond_filter));
      diff_N_06 = sum(cond_filter);
      
      eval(sprintf('diff_07= [GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_4th_07];',par_vec{idx}));
      cond_filter = abs(diff_07) <= nanmean(diff_07)+3*nanstd(diff_07);
      diff_mean_07 = nanmean(diff_07(cond_filter));
      diff_stdv_07 = nanstd(diff_07(cond_filter));
      diff_N_07 = sum(cond_filter);
      
      
      diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
      diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,diff_mean_00+1.3*diff_stdv_00,['N=' num2str(diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,diff_mean_01+1.3*diff_stdv_01,['N=' num2str(diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,diff_mean_02+1.3*diff_stdv_02,['N=' num2str(diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,diff_mean_03+1.3*diff_stdv_03,['N=' num2str(diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,diff_mean_04+1.3*diff_stdv_04,['N=' num2str(diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,diff_mean_05+1.3*diff_stdv_05,['N=' num2str(diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,diff_mean_06+1.3*diff_stdv_06,['N=' num2str(diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,diff_mean_07+1.3*diff_stdv_07,['N=' num2str(diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      diff_mean_all
      diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Difference\n w/r to 4h\n  %s',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Diff_4th_' par_vec{idx}],'epsc')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from 4th time of day for par -- ONLY SUMMER
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
% Summer
cond_tod = month([GOCI_DailyStatMatrix.datetime])==6|month([GOCI_DailyStatMatrix.datetime])==7|month([GOCI_DailyStatMatrix.datetime])==8; % cond for season
cond_used = cond_brdf&cond_tod;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412)';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443)';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490)';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555)';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660)';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680)';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita}';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412)';
            case 'poc'
                  y_str = 'POC';
      end
      eval(sprintf('mean_4th= nanmean(abs([GOCI_DailyStatMatrix(cond_used).%s_04]));',par_vec{idx}));
      
      %%
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_00]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      rel_diff_N_00 = sum(cond_filter);
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_01]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      rel_diff_N_01 = sum(cond_filter);
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_02]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      rel_diff_N_02 = sum(cond_filter);
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_03]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      rel_diff_N_03 = sum(cond_filter);
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_04]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      rel_diff_N_04 = sum(cond_filter);
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_05]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      rel_diff_N_05 = sum(cond_filter);
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_06]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      rel_diff_N_06 = sum(cond_filter);
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_07]./abs([GOCI_DailyStatMatrix(cond_used).%s_04]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      rel_diff_N_07 = sum(cond_filter);
      
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,rel_diff_mean_00+1.3*rel_diff_stdv_00,['N=' num2str(rel_diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,rel_diff_mean_01+1.3*rel_diff_stdv_01,['N=' num2str(rel_diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,rel_diff_mean_02+1.3*rel_diff_stdv_02,['N=' num2str(rel_diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,rel_diff_mean_03+1.3*rel_diff_stdv_03,['N=' num2str(rel_diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,rel_diff_mean_04+1.3*rel_diff_stdv_04,['N=' num2str(rel_diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,rel_diff_mean_05+1.3*rel_diff_stdv_05,['N=' num2str(rel_diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,rel_diff_mean_06+1.3*rel_diff_stdv_06,['N=' num2str(rel_diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,rel_diff_mean_07+1.3*rel_diff_stdv_07,['N=' num2str(rel_diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      mean_4th
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('R\\Delta_t[%%] for %s',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Rel_Diff_4th_' par_vec{idx} '_summer'],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Difference from the 4th for par -- ONLY SUMMERS
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'Rrs_412','Rrs_443','Rrs_490','Rrs_555','Rrs_660','Rrs_680','chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;
clear cond_brdf
cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
% Summer
cond_tod = month([GOCI_DailyStatMatrix.datetime])==6|month([GOCI_DailyStatMatrix.datetime])==7|month([GOCI_DailyStatMatrix.datetime])==8; % cond for season
cond_used = cond_brdf&cond_tod;

for idx = 1:size(par_vec,2)
      switch par_vec{idx}
            case 'Rrs_412'
                  y_str = 'R_{rs}(412) [sr^{-1}]';
            case 'Rrs_443'
                  y_str = 'R_{rs}(443) [sr^{-1}]';
            case 'Rrs_490'
                  y_str = 'R_{rs}(490) [sr^{-1}]';
            case 'Rrs_555'
                  y_str = 'R_{rs}(555) [sr^{-1}]';
            case 'Rrs_660'
                  y_str = 'R_{rs}(660) [sr^{-1}]';
            case 'Rrs_680'
                  y_str = 'R_{rs}(680) [sr^{-1}]';
            case 'chlor_a'
                  y_str = 'Chlor-{\ita} [mg m^{-3}]';
            case 'ag_412_mlrc'
                  y_str = 'a_{g}(412) [m^{-1}]';
            case 'poc'
                  y_str = 'POC [mg m^{-3}]';
      end
      %%
      eval(sprintf('diff_00= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_00];',par_vec{idx}));
      cond_filter = abs(diff_00) <= nanmean(diff_00)+3*nanstd(diff_00);
      diff_mean_00 = nanmean(diff_00(cond_filter));
      diff_stdv_00 = nanstd(diff_00(cond_filter));
      diff_N_00 = sum(cond_filter);
      
      eval(sprintf('diff_01= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_01];',par_vec{idx}));
      cond_filter = abs(diff_01) <= nanmean(diff_01)+3*nanstd(diff_01);
      diff_mean_01 = nanmean(diff_01(cond_filter));
      diff_stdv_01 = nanstd(diff_01(cond_filter));
      diff_N_01 = sum(cond_filter);
      
      eval(sprintf('diff_02= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_02];',par_vec{idx}));
      cond_filter = abs(diff_02) <= nanmean(diff_02)+3*nanstd(diff_02);
      diff_mean_02 = nanmean(diff_02(cond_filter));
      diff_stdv_02 = nanstd(diff_02(cond_filter));
      diff_N_02 = sum(cond_filter);
      
      eval(sprintf('diff_03= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_03];',par_vec{idx}));
      cond_filter = abs(diff_03) <= nanmean(diff_03)+3*nanstd(diff_03);
      diff_mean_03 = nanmean(diff_03(cond_filter));
      diff_stdv_03 = nanstd(diff_03(cond_filter));
      diff_N_03 = sum(cond_filter);
      
      eval(sprintf('diff_04= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_04];',par_vec{idx}));
      cond_filter = abs(diff_04) <= nanmean(diff_04)+3*nanstd(diff_04);
      diff_mean_04 = nanmean(diff_04(cond_filter));
      diff_stdv_04 = nanstd(diff_04(cond_filter));
      diff_N_04 = sum(cond_filter);
      
      eval(sprintf('diff_05= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_05];',par_vec{idx}));
      cond_filter = abs(diff_05) <= nanmean(diff_05)+3*nanstd(diff_05);
      diff_mean_05 = nanmean(diff_05(cond_filter));
      diff_stdv_05 = nanstd(diff_05(cond_filter));
      diff_N_05 = sum(cond_filter);
      
      eval(sprintf('diff_06= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_06];',par_vec{idx}));
      cond_filter = abs(diff_06) <= nanmean(diff_06)+3*nanstd(diff_06);
      diff_mean_06 = nanmean(diff_06(cond_filter));
      diff_stdv_06 = nanstd(diff_06(cond_filter));
      diff_N_06 = sum(cond_filter);
      
      eval(sprintf('diff_07= [GOCI_DailyStatMatrix(cond_used).%s_diff_w_r_4th_07];',par_vec{idx}));
      cond_filter = abs(diff_07) <= nanmean(diff_07)+3*nanstd(diff_07);
      diff_mean_07 = nanmean(diff_07(cond_filter));
      diff_stdv_07 = nanstd(diff_07(cond_filter));
      diff_N_07 = sum(cond_filter);
      
      
      diff_stdv_all = [diff_stdv_00,diff_stdv_01,diff_stdv_02,diff_stdv_03,diff_stdv_04,diff_stdv_05,diff_stdv_06,diff_stdv_07];
      diff_mean_all = [diff_mean_00,diff_mean_01,diff_mean_02,diff_mean_03,diff_mean_04,diff_mean_05,diff_mean_06,diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,diff_mean_all,diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,diff_mean_00+1.3*diff_stdv_00,['N=' num2str(diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,diff_mean_01+1.3*diff_stdv_01,['N=' num2str(diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,diff_mean_02+1.3*diff_stdv_02,['N=' num2str(diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,diff_mean_03+1.3*diff_stdv_03,['N=' num2str(diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,diff_mean_04+1.3*diff_stdv_04,['N=' num2str(diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,diff_mean_05+1.3*diff_stdv_05,['N=' num2str(diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,diff_mean_06+1.3*diff_stdv_06,['N=' num2str(diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,diff_mean_07+1.3*diff_stdv_07,['N=' num2str(diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      diff_mean_all
      diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Difference\n w/r to 4th  %s',y_str);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      %%
      saveas(gcf,[savedirname 'Diff_4th_' par_vec{idx} '_summer'],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from the three midday for Rrs -- DETRENDED
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

wl = {'412','443','490','555','660','680'};

brdf_opt = 7;

cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(wl,2)
      
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_00_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_01_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_02_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_03_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_04_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_05_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_06_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_diff_w_r_mid_three_07_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).Rrs_%s_mean_mid_three_detrend]);',wl{idx},wl{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      disp('======================')
      disp(wl{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to mean middle three for anomalies\n  Rrs(%s) [%%]',wl{idx});
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time fo the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      
      saveas(gcf,[savedirname 'Rel_Diff_mid_three_Rrs_' wl{idx} '_detrend'],'epsc')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from the three midday for par
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;

cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(par_vec,2)
      
      if strcmp(par_vec{idx},'chlor_a')
            par_char = 'Chlor-{\ita}';
      elseif strcmp(par_vec{idx},'ag_412_mlrc')
            par_char = 'a_{g}(412)';
      elseif strcmp(par_vec{idx},'poc')
            par_char = 'POC';
      end
      
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_00]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      rel_diff_N_00 = sum(cond_filter);
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_01]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      rel_diff_N_01 = sum(cond_filter);
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_02]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      rel_diff_N_02 = sum(cond_filter);
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_03]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      rel_diff_N_03 = sum(cond_filter);
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_04]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      rel_diff_N_04 = sum(cond_filter);
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_05]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      rel_diff_N_05 = sum(cond_filter);
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_06]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      rel_diff_N_06 = sum(cond_filter);
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_07]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      rel_diff_N_07 = sum(cond_filter);
      
      
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      text(1,rel_diff_mean_00+1.3*rel_diff_stdv_00,['N=' num2str(rel_diff_N_00)],'HorizontalAlignment','center','FontSize',14)
      text(2,rel_diff_mean_01+1.3*rel_diff_stdv_01,['N=' num2str(rel_diff_N_01)],'HorizontalAlignment','center','FontSize',14)
      text(3,rel_diff_mean_02+1.3*rel_diff_stdv_02,['N=' num2str(rel_diff_N_02)],'HorizontalAlignment','center','FontSize',14)
      text(4,rel_diff_mean_03+1.3*rel_diff_stdv_03,['N=' num2str(rel_diff_N_03)],'HorizontalAlignment','center','FontSize',14)
      text(5,rel_diff_mean_04+1.3*rel_diff_stdv_04,['N=' num2str(rel_diff_N_04)],'HorizontalAlignment','center','FontSize',14)
      text(6,rel_diff_mean_05+1.3*rel_diff_stdv_05,['N=' num2str(rel_diff_N_05)],'HorizontalAlignment','center','FontSize',14)
      text(7,rel_diff_mean_06+1.3*rel_diff_stdv_06,['N=' num2str(rel_diff_N_06)],'HorizontalAlignment','center','FontSize',14)
      text(8,rel_diff_mean_07+1.3*rel_diff_stdv_07,['N=' num2str(rel_diff_N_07)],'HorizontalAlignment','center','FontSize',14)
      
      disp('======================')
      disp(par_vec{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to mean middle three\n  %s [%%]',par_char);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      
      saveas(gcf,[savedirname 'Rel_Diff_mid_three_' par_vec{idx}],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot relative difference from the three midday for par -- DETRENDED
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';


par_vec = {'chlor_a','ag_412_mlrc','poc'};

brdf_opt = 7;

cond_brdf = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;

for idx = 1:size(par_vec,2)
      
      if strcmp(par_vec{idx},'chlor_a')
            par_char = 'Chlor-{\ita}';
      elseif strcmp(par_vec{idx},'ag_412_mlrc')
            par_char = 'a_{g}(412)';
      elseif strcmp(par_vec{idx},'poc')
            par_char = 'POC';
      end
      
      eval(sprintf('rel_diff_00= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_00_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
      rel_diff_mean_00 = nanmean(rel_diff_00(cond_filter));
      rel_diff_stdv_00 = nanstd(rel_diff_00(cond_filter));
      
      eval(sprintf('rel_diff_01= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_01_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_01) <= nanmean(rel_diff_01)+3*nanstd(rel_diff_01);
      rel_diff_mean_01 = nanmean(rel_diff_01(cond_filter));
      rel_diff_stdv_01 = nanstd(rel_diff_01(cond_filter));
      
      eval(sprintf('rel_diff_02= 102*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_02_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_02) <= nanmean(rel_diff_02)+3*nanstd(rel_diff_02);
      rel_diff_mean_02 = nanmean(rel_diff_02(cond_filter));
      rel_diff_stdv_02 = nanstd(rel_diff_02(cond_filter));
      
      eval(sprintf('rel_diff_03= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_03_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_03) <= nanmean(rel_diff_03)+3*nanstd(rel_diff_03);
      rel_diff_mean_03 = nanmean(rel_diff_03(cond_filter));
      rel_diff_stdv_03 = nanstd(rel_diff_03(cond_filter));
      
      eval(sprintf('rel_diff_04= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_04_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_04) <= nanmean(rel_diff_04)+3*nanstd(rel_diff_04);
      rel_diff_mean_04 = nanmean(rel_diff_04(cond_filter));
      rel_diff_stdv_04 = nanstd(rel_diff_04(cond_filter));
      
      eval(sprintf('rel_diff_05= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_05_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_05) <= nanmean(rel_diff_05)+3*nanstd(rel_diff_05);
      rel_diff_mean_05 = nanmean(rel_diff_05(cond_filter));
      rel_diff_stdv_05 = nanstd(rel_diff_05(cond_filter));
      
      eval(sprintf('rel_diff_06= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_06_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_06) <= nanmean(rel_diff_06)+3*nanstd(rel_diff_06);
      rel_diff_mean_06 = nanmean(rel_diff_06(cond_filter));
      rel_diff_stdv_06 = nanstd(rel_diff_06(cond_filter));
      
      eval(sprintf('rel_diff_07= 100*[GOCI_DailyStatMatrix(cond_brdf).%s_diff_w_r_mid_three_07_detrend]./abs([GOCI_DailyStatMatrix(cond_brdf).%s_mean_mid_three_detrend]);',par_vec{idx},par_vec{idx}));
      cond_filter = abs(rel_diff_07) <= nanmean(rel_diff_07)+3*nanstd(rel_diff_07);
      rel_diff_mean_07 = nanmean(rel_diff_07(cond_filter));
      rel_diff_stdv_07 = nanstd(rel_diff_07(cond_filter));
      rel_diff_stdv_all = [rel_diff_stdv_00,rel_diff_stdv_01,rel_diff_stdv_02,rel_diff_stdv_03,rel_diff_stdv_04,rel_diff_stdv_05,rel_diff_stdv_06,rel_diff_stdv_07];
      rel_diff_mean_all = [rel_diff_mean_00,rel_diff_mean_01,rel_diff_mean_02,rel_diff_mean_03,rel_diff_mean_04,rel_diff_mean_05,rel_diff_mean_06,rel_diff_mean_07];
      
      fs = 25;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      % plot(1:8,stdv_all,'or','MarkerSize',12)
      errorbar(1:8,rel_diff_mean_all,rel_diff_stdv_all,'ob','MarkerSize',12,'LineWidth',1.5)
      ax = gca;
      ax.XTick = 1:8;
      ax.XTickLabel = {'0h','1h','2h','3h','4h','5h','6h','7h'};
      xlim([0 9])
      
      disp('======================')
      disp(par_vec{idx})
      rel_diff_mean_all
      rel_diff_stdv_all
      %       ylim([-3e-3 1e-3])
      
      ax.YAxis.MinorTick = 'on';
      ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      ax.YGrid = 'on';
      ax.YMinorGrid = 'on';
      %       ax.YAxis.TickValues = ax.YAxis.Limits(1):10:ax.YAxis.Limits(2);
      str1 = sprintf('Relative difference\n w/r to mean middle three for anomalies\n  %s [%%]',par_char);
      
      ylabel(str1,'FontSize',fs)
      xlabel('Time of the day (GMT)','FontSize',fs)
      
      grid on
      %       grid minor
      
      saveas(gcf,[savedirname 'Rel_Diff_mid_three_' par_vec{idx} '_detrend'],'epsc')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

par_vec = {'chlor_a','ag_412_mlrc', 'poc'};

for idx = 1:size(par_vec,2)
      
      if strcmp(par_vec{idx},'chlor_a')
            par_char = 'Chlor-{\ita} [mg m^{-3}]';
      elseif strcmp(par_vec{idx},'ag_412_mlrc')
            par_char = 'a_{g}(412) [m^{-1}]';
      elseif strcmp(par_vec{idx},'poc')
            par_char = 'POC [mg m^{-3}]';
      end
      
      eval(sprintf('rel_diff_mean_00 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_00 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_00]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_01 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_01 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_01]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_02 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_02 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_02]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_03 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_03 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_03]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_04 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_04 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_04]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_05 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_05 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_05]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_06 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_06 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_06]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
      eval(sprintf('rel_diff_mean_07 = nanmean(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      eval(sprintf('rel_diff_stdv_07 =  nanstd(100*[GOCI_DailyStatMatrix.%s_diff_w_r_daily_mean_07]./abs([GOCI_DailyStatMatrix.%s_mean_mean]));',par_vec{idx},par_vec{idx}))
      
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
      str1 = sprintf('Relative difference\n w/r to the daily mean\n  %s [%%]',par_char);
      str1 = strrep(str1,'_','\_');
      
      ylabel(str1,'FontSize',fs)
      xlabel('Local Time','FontSize',fs)
      
      grid on
      %       grid minor
      
      saveas(gcf,[savedirname 'Rel_Diff_Daily_Mean_' par_vec{idx}],'epsc')
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


%% Scatter plots for Rrs -- daily -- from GOCI_DailyStatMatrix
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';
clear GOCI_date VIIRS_date AQUA_date
clear GOCI_date_vec AQUA_date_vec VIIRS_date_vec
clear GOCI_used VIIRS_used AQUA_used

brdf_opt = 7;

cond_brdf_GOCI = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
GOCI_date = [GOCI_DailyStatMatrix(cond_brdf_GOCI).datetime];
cond_brdf_VIIRS = [VIIRS_DailyStatMatrix.brdf_opt]==brdf_opt;
VIIRS_date = [VIIRS_DailyStatMatrix(cond_brdf_VIIRS).datetime];
cond_brdf_AQUA = [AQUA_DailyStatMatrix.brdf_opt]==brdf_opt;
AQUA_date = [AQUA_DailyStatMatrix(cond_brdf_AQUA).datetime];

GOCI_used = GOCI_DailyStatMatrix(cond_brdf_GOCI);
VIIRS_used = VIIRS_DailyStatMatrix(cond_brdf_VIIRS);
AQUA_used = AQUA_DailyStatMatrix(cond_brdf_AQUA);

% clear cond_brdf_GOCI cond_brdf_VIIRS cond_brdf_AQUA

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
      legend off
      set(gcf, 'renderer','painters')
      
      
      saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_' wl{idx0}],'epsc')
      %% GOCI Comparison with AQUA
      [h2,ax2,leg2] = plot_sat_vs_sat('Rrs',wl{idx0},wl_AQUA,'GOCI','AQUA',...
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_%s_mean_mid_three]',wl{idx0})),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_%s_filtered_mean]',wl_AQUA)));
      legend off
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_' wl{idx0}],'epsc')
      %% VIIRS Comparison with AQUA      % lower boundary
      [h3,ax3,leg3] = plot_sat_vs_sat('Rrs',wl_VIIRS,wl_AQUA,'VIIRS','AQUA',...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_VIIRS)),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_AQUA)));
      legend off
      set(gcf, 'renderer','painters')
      
      saveas(gcf,[savedirname 'Scatter_VIIRS_AQUA_' wl{idx0}],'epsc')
end
%% Scatter plots for Rrs -- from GOCI_Data
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';
clear GOCI_date VIIRS_date AQUA_date
clear GOCI_date_vec AQUA_date_vec VIIRS_date_vec
clear GOCI_used VIIRS_used AQUA_used


brdf_opt = 7;

GOCI_date = [GOCI_Data([GOCI_Data.brdf_opt]==brdf_opt).datetime];
VIIRS_date = [VIIRS_Data([VIIRS_Data.brdf_opt]==brdf_opt).datetime];
AQUA_date = [AQUA_Data([AQUA_Data.brdf_opt]==brdf_opt).datetime];

GOCI_used = GOCI_Data([GOCI_Data.brdf_opt]==brdf_opt);
VIIRS_used = VIIRS_Data([VIIRS_Data.brdf_opt]==brdf_opt);
AQUA_used = AQUA_Data([AQUA_Data.brdf_opt]==brdf_opt);


% all in the same temporal grid
min_date = min([GOCI_date(1) AQUA_date(1) VIIRS_date(1)]);

max_date = max([GOCI_date(end) AQUA_date(end) VIIRS_date(end)]);

date_vec = min_date:max_date;

for idx=1:size(date_vec,2)
      [~,b] = min(abs(GOCI_date-date_vec(idx)));
      if GOCI_date(b).Year==date_vec(idx).Year&&...
                  GOCI_date(b).Month==date_vec(idx).Month&&...
                  GOCI_date(b).Day==date_vec(idx).Day
            GOCI_date_vec(idx) = b; % indexes
      else
            GOCI_date_vec(idx) = NaN;
      end
      [~,b] = min(abs(AQUA_date-date_vec(idx)));
      if AQUA_date(b).Year==date_vec(idx).Year&&...
                  AQUA_date(b).Month==date_vec(idx).Month&&...
                  AQUA_date(b).Day==date_vec(idx).Day
            AQUA_date_vec(idx) = b; % indexes
      else
            AQUA_date_vec(idx) = NaN;
      end
      [~,b] = min(abs(VIIRS_date-date_vec(idx)));
      if VIIRS_date(b).Year==date_vec(idx).Year&&...
                  VIIRS_date(b).Month==date_vec(idx).Month&&...
                  VIIRS_date(b).Day==date_vec(idx).Day
            VIIRS_date_vec(idx) = b; % indexes
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
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_%s_filtered_mean]',wl{idx0})),...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_%s_filtered_mean]',wl_VIIRS)));
      legend off
      set(gcf, 'renderer','painters')
      
      
      % saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_' wl{idx0}],'epsc')
      %% GOCI Comparison with AQUA
      [h2,ax2,leg2] = plot_sat_vs_sat('Rrs',wl{idx0},wl_AQUA,'GOCI','AQUA',...
            eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_%s_filtered_mean]',wl{idx0})),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_%s_filtered_mean]',wl_AQUA)));
      legend off
      set(gcf, 'renderer','painters')
      
      % saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_' wl{idx0}],'epsc')
      %% VIIRS Comparison with AQUA      % lower boundary
      [h3,ax3,leg3] = plot_sat_vs_sat('Rrs',wl_VIIRS,wl_AQUA,'VIIRS','AQUA',...
            eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_VIIRS)),...
            eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_AQUA)));
      legend off
      set(gcf, 'renderer','painters')
      
      % saveas(gcf,[savedirname 'Scatter_VIIRS_AQUA_' wl{idx0}],'epsc')
end

%% Scatter plots for par
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

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
saveas(gcf,[savedirname 'Ratio_GOCI_MODISA'],'epsc')

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
saveas(gcf,[savedirname 'Ratio_GOCI_VIIRS'],'epsc')

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
saveas(gcf,[savedirname 'Ratio_MODISA_VIIRS'],'epsc')

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

%% Plot Monthly Chl, POC and ag_412_mlrc

brdf_opt = 7;

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

% chlor_a
fs = 25;
h1 = figure('Color','white','DefaultAxesFontSize',fs,'Name','Chl-a');
cond_brdf = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [GOCI_MonthlyStatMatrix(cond_used).datetime];
ydata = [GOCI_MonthlyStatMatrix(cond_used).chlor_a_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)


hold on
cond_brdf = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [AQUA_MonthlyStatMatrix(cond_used).datetime];
ydata = [AQUA_MonthlyStatMatrix(cond_used).chlor_a_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
cond_brdf = [VIIRS_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [VIIRS_MonthlyStatMatrix(cond_used).datetime];
ydata = [VIIRS_MonthlyStatMatrix(cond_used).chlor_a_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
ylabel('Chl-{\ita}')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerieComp_chlor_a'],'epsc')

% poc
h2 = figure('Color','white','DefaultAxesFontSize',fs,'Name','POC');
cond_brdf = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [GOCI_MonthlyStatMatrix(cond_used).datetime];
ydata = [GOCI_MonthlyStatMatrix(cond_used).poc_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
cond_brdf = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [AQUA_MonthlyStatMatrix(cond_used).datetime];
ydata = [AQUA_MonthlyStatMatrix(cond_used).poc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
cond_brdf = [VIIRS_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [VIIRS_MonthlyStatMatrix(cond_used).datetime];
ydata = [VIIRS_MonthlyStatMatrix(cond_used).poc_mean];
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
saveas(gcf,[savedirname 'TimeSerieComp_poc'],'epsc')

% ag_412_mlrc
h3 = figure('Color','white','DefaultAxesFontSize',fs,'Name','ag_412_mlrc');
cond_brdf = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [GOCI_MonthlyStatMatrix(cond_used).datetime];
ydata = [GOCI_MonthlyStatMatrix(cond_used).ag_412_mlrc_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
cond_brdf = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [AQUA_MonthlyStatMatrix(cond_used).datetime];
ydata = [AQUA_MonthlyStatMatrix(cond_used).ag_412_mlrc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
cond_brdf = [VIIRS_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [VIIRS_MonthlyStatMatrix(cond_used).datetime];
ydata = [VIIRS_MonthlyStatMatrix(cond_used).ag_412_mlrc_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'k','LineWidth',lw)
xlabel('Time')
ylabel('a_{g}(412)')
grid on
legend('GOCI','MODISA','VIIRS')
screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) 0.5*screen_size(4) ] ); %set to screen size
set(gcf, 'renderer','painters')
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[savedirname 'TimeSerieComp_ag_412_mlrc'],'epsc')

%% brdf
h4 = figure('Color','white','DefaultAxesFontSize',fs,'Name','brdf');
cond_brdf = [GOCI_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [GOCI_MonthlyStatMatrix(cond_used).datetime];
ydata = [GOCI_MonthlyStatMatrix(cond_used).brdf_mean_mid_three];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'LineWidth',lw)

hold on
cond_brdf = [AQUA_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [AQUA_MonthlyStatMatrix(cond_used).datetime];
ydata = [AQUA_MonthlyStatMatrix(cond_used).brdf_mean];
plot(xdata(~isnan(ydata)),ydata(~isnan(ydata)),'r','LineWidth',lw)

hold on
cond_brdf = [VIIRS_MonthlyStatMatrix.brdf_opt] == brdf_opt;
cond_used = cond_brdf;
xdata = [VIIRS_MonthlyStatMatrix(cond_used).datetime];
ydata = [VIIRS_MonthlyStatMatrix(cond_used).brdf_mean];
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
saveas(gcf,[savedirname 'TimeSerieComp_brdf'],'epsc')
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

%% Time series for all Rrs
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

brdf_opt =7;
fs = 28;
lw = 2.0;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Comparison with L3','units','normalized','outerposition',[0 0 1 1]);
% GOCI
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
plot(x(~isnan(y)),y(~isnan(y)),'--','Color',[1 0 0],'LineWidth',lw)
y = [GOCI_MonthlyStatMatrix(cond).Rrs_680_mean_mid_three];
plot(x(~isnan(y)),y(~isnan(y)),'--','Color',[1 0.5 0],'LineWidth',lw)

% AQUA
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
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0 0],'LineWidth',lw)
y = [AQUA_MonthlyStatMatrix(cond).Rrs_678_mean];
plot(x(~isnan(y)),y(~isnan(y)),'Color',[1 0.5 0],'LineWidth',lw)

% VIIRS
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
plot(x(~isnan(y)),y(~isnan(y)),'-.','Color',[1 0 0],'LineWidth',lw)
ylim([-0.001 0.017])

grid on
ax = gca;
ax.YAxis.Exponent = 0;
ax.YAxis.MinorTick = 'on';
ax.YAxis.MinorTickValues = ax.YAxis.Limits(1):.001:ax.YAxis.Limits(2);
ax.YTick = [0.000 0.005 0.010 0.015];
ax.YTickLabel = {'0.000','0.005','0.010','0.015'};
xlim(datenum(datetime([2011 2018],[1 1],[1 1])))
% ax.XTickLabel = {'2011','2013','2014','2015','2016',''};
ax.XTick = (datenum([datetime(2011,1,1) datetime(2012,1,1) datetime(2013,1,1) ...
      datetime(2014,1,1) datetime(2015,1,1) datetime(2016,1,1) datetime(2017,1,1) datetime(2018,1,1)]));

ax.TickLabelInterpreter = 'none';

xlabel('Time','FontSize',fs+4)
ylabel('R_{rs}(\lambda) [sr^{-1}]','FontSize',fs+4)

% set(gcf, 'renderer','painters')

% set(gcf, 'renderer','painters')
legend('GOCI 412','GOCI 443','GOCI 490','GOCI 555','GOCI 660','GOCI 680',...
      'MODISA 412','MODISA 443','MODISA 488','MODISA 547','MODISA 667','MODISA 678',...
      'VIIRS 410','VIIRS 443','VIIRS 486','VIIRS 551','VIIRS 671',...
      'Location','EastOutside')

set(gcf,'PaperPositionMode', 'auto')
% saveas(gcf,[savedirname 'CrossComp_All_Rrs'],'epsc')

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

%% 3-day set comparison
clear three_day_idx cond1 cond2 cond3 cond4 cond5 cond6
clear cond_brdf1 cond_brdf2 cond_brdf3
brdf_opt = 7;

for idx = 1:size(GOCI_DailyStatMatrix,2)-2
      cond_brdf1 = [GOCI_DailyStatMatrix(idx+0).brdf_opt]==brdf_opt;
      cond_brdf2 = [GOCI_DailyStatMatrix(idx+1).brdf_opt]==brdf_opt;
      cond_brdf3 = [GOCI_DailyStatMatrix(idx+2).brdf_opt]==brdf_opt;
      
      
      cond1 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_07]);
      
      
      cond2 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_07]);
      
      cond3 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_07]);
      
      cond4 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_07]);
      
      %       cond5 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_01]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_02]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_03]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_04]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_05]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_06]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_07]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_00]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_01]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_02]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_03]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_04]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_05]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_06]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_07]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_00]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_01]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_02]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_03]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_04]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_05]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_06]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_07]);
      
      %       cond6 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_01]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_02]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_03]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_04]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_05]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_06]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_07]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_00]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_01]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_02]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_03]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_04]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_05]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_06]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_07]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_00]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_01]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_02]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_03]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_04]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_05]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_06]) && ...
      %             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_07]);
      
      if ~isempty(cond1)&&~isempty(cond1)&&~isempty(cond1)&&~isempty(cond1)...
                  &&~isempty(cond_brdf1)&&~isempty(cond_brdf2)&&~isempty(cond_brdf3)
            if cond1&&cond2&&cond3&&cond4... % for bands 412, 443, 490, and 555
                        &&cond_brdf1&&cond_brdf2&&cond_brdf3
                  three_day_idx(idx)=true;
                  
            else
                  three_day_idx(idx)=false;
            end
      else
            three_day_idx(idx)=false;
      end
end

A= find(three_day_idx); % indeces to 3-day sequences.
%% 3-day sequences plot -- Rrs

% for idx = 1:1*sum(three_day_idx)/4
for idx =      [18 57]
      
      % Rrs
      tod_Rrs_412_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_00]];
      tod_Rrs_412_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_01]];
      tod_Rrs_412_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_02]];
      tod_Rrs_412_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_03]];
      tod_Rrs_412_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_04]];
      tod_Rrs_412_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_05]];
      tod_Rrs_412_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_06]];
      tod_Rrs_412_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_07]];
      
      tod_Rrs_443_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_00]];
      tod_Rrs_443_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_01]];
      tod_Rrs_443_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_02]];
      tod_Rrs_443_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_03]];
      tod_Rrs_443_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_04]];
      tod_Rrs_443_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_05]];
      tod_Rrs_443_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_06]];
      tod_Rrs_443_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_07]];
      
      tod_Rrs_490_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_00]];
      tod_Rrs_490_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_01]];
      tod_Rrs_490_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_02]];
      tod_Rrs_490_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_03]];
      tod_Rrs_490_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_04]];
      tod_Rrs_490_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_05]];
      tod_Rrs_490_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_06]];
      tod_Rrs_490_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_07]];
      
      tod_Rrs_555_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_00]];
      tod_Rrs_555_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_01]];
      tod_Rrs_555_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_02]];
      tod_Rrs_555_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_03]];
      tod_Rrs_555_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_04]];
      tod_Rrs_555_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_05]];
      tod_Rrs_555_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_06]];
      tod_Rrs_555_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_07]];
      
      % datetime
      tod_Rrs_412_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_412_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      
      tod_Rrs_443_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_443_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      
      tod_Rrs_490_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_490_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      
      tod_Rrs_555_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_Rrs_555_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      
      
      
      fs = 30;
      lw = 1.5;
      ms = 16;
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A(idx))]);
      
      %% Rrs
      % Rrs_412
      % subplot(2,2,1)
      plot(tod_Rrs_412_00_datetime+hours(0),tod_Rrs_412_00,'-or','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_412_01_datetime+hours(1),tod_Rrs_412_01,'-og','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_02_datetime+hours(2),tod_Rrs_412_02,'-ob','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_03_datetime+hours(3),tod_Rrs_412_03,'-ok','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_04_datetime+hours(4),tod_Rrs_412_04,'-oc','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_05_datetime+hours(5),tod_Rrs_412_05,'-om','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_06_datetime+hours(6),tod_Rrs_412_06,'-o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_07_datetime+hours(7),tod_Rrs_412_07,'-o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      % ylabel('R_{rs}(412) [sr^{-1}]','FontSize',fs)
      % xlabel('Time','FontSize',fs)
      % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      
      % Rrs_443
      % subplot(2,2,1)
      plot(tod_Rrs_443_00_datetime+hours(0),tod_Rrs_443_00,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_443_01_datetime+hours(1),tod_Rrs_443_01,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_02_datetime+hours(2),tod_Rrs_443_02,'-^b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_03_datetime+hours(3),tod_Rrs_443_03,'-^k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_04_datetime+hours(4),tod_Rrs_443_04,'-^c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_05_datetime+hours(5),tod_Rrs_443_05,'-^m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_06_datetime+hours(6),tod_Rrs_443_06,'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_07_datetime+hours(7),tod_Rrs_443_07,'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      % ylabel('R_{rs}(443) [sr^{-1}]','FontSize',fs)
      % xlabel('Time','FontSize',fs)
      % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      
      % Rrs_490
      % subplot(2,2,1)
      plot(tod_Rrs_490_00_datetime+hours(0),tod_Rrs_490_00,'-*r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_490_01_datetime+hours(1),tod_Rrs_490_01,'-*g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_02_datetime+hours(2),tod_Rrs_490_02,'-*b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_03_datetime+hours(3),tod_Rrs_490_03,'-*k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_04_datetime+hours(4),tod_Rrs_490_04,'-*c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_05_datetime+hours(5),tod_Rrs_490_05,'-*m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_06_datetime+hours(6),tod_Rrs_490_06,'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_07_datetime+hours(7),tod_Rrs_490_07,'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      % ylabel('R_{rs}(490) [sr^{-1}]','FontSize',fs)
      % xlabel('Time','FontSize',fs)
      % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      
      % Rrs_555
      % subplot(2,2,1)
      plot(tod_Rrs_555_00_datetime+hours(0),tod_Rrs_555_00,'-xr','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_555_01_datetime+hours(1),tod_Rrs_555_01,'-xg','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_02_datetime+hours(2),tod_Rrs_555_02,'-xb','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_03_datetime+hours(3),tod_Rrs_555_03,'-xk','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_04_datetime+hours(4),tod_Rrs_555_04,'-xc','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_05_datetime+hours(5),tod_Rrs_555_05,'-xm','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_06_datetime+hours(6),tod_Rrs_555_06,'-x','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_07_datetime+hours(7),tod_Rrs_555_07,'-x','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      grid on
      ylabel('R_{rs}(\lambda) [sr^{-1}]','FontSize',fs)
      xlabel('Time','FontSize',fs)
      
      datetick('x','mm/dd/yy')
      ax = gca;
      % ax.YLim(1) = 0 ;
      ylim([0 0.016])
      ax.XLim(1) = ax.XTick(1)-0.2;
      ax.XLim(2) = ax.XTick(3)+0.5;
      
      hleg = legend('412: 0h','412: 1h','412: 2h','412: 3h','412: 4h','412: 5h','412: 6h','412: 7h',...
            '443: 0h','443: 1h','443: 2h','443: 3h','443: 4h','443: 5h','443: 6h','443: 7h',...
            '490: 0h','490: 1h','490: 2h','490: 3h','490: 4h','490: 5h','490: 6h','490: 7h',...
            '555: 0h','555: 1h','555: 2h','555: 3h','555: 4h','555: 5h','555: 6h','555: 7h');
      set(hleg,'fontsize',22)
      set(hleg,'Location','bestoutside')
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      
      
end

%% 3-day sequences plot -- par
savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

% for idx = 1:1*sum(three_day_idx)/10
for idx = [18 57]
      
      % par
      
      tod_chlor_a_00 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_00] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_00] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_00]];
      tod_chlor_a_01 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_01] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_01] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_01]];
      tod_chlor_a_02 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_02] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_02] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_02]];
      tod_chlor_a_03 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_03] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_03] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_03]];
      tod_chlor_a_04 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_04] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_04] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_04]];
      tod_chlor_a_05 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_05] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_05] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_05]];
      tod_chlor_a_06 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_06] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_06] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_06]];
      tod_chlor_a_07 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_07] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_07] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_07]];
      
      tod_ag_412_mlrc_00 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_00]];
      tod_ag_412_mlrc_01 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_01]];
      tod_ag_412_mlrc_02 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_02]];
      tod_ag_412_mlrc_03 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_03]];
      tod_ag_412_mlrc_04 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_04]];
      tod_ag_412_mlrc_05 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_05]];
      tod_ag_412_mlrc_06 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_06]];
      tod_ag_412_mlrc_07 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_07]];
      
      tod_poc_00 = [[GOCI_DailyStatMatrix(A(idx)).poc_00] [GOCI_DailyStatMatrix(A(idx)+1).poc_00] [GOCI_DailyStatMatrix(A(idx)+2).poc_00]];
      tod_poc_01 = [[GOCI_DailyStatMatrix(A(idx)).poc_01] [GOCI_DailyStatMatrix(A(idx)+1).poc_01] [GOCI_DailyStatMatrix(A(idx)+2).poc_01]];
      tod_poc_02 = [[GOCI_DailyStatMatrix(A(idx)).poc_02] [GOCI_DailyStatMatrix(A(idx)+1).poc_02] [GOCI_DailyStatMatrix(A(idx)+2).poc_02]];
      tod_poc_03 = [[GOCI_DailyStatMatrix(A(idx)).poc_03] [GOCI_DailyStatMatrix(A(idx)+1).poc_03] [GOCI_DailyStatMatrix(A(idx)+2).poc_03]];
      tod_poc_04 = [[GOCI_DailyStatMatrix(A(idx)).poc_04] [GOCI_DailyStatMatrix(A(idx)+1).poc_04] [GOCI_DailyStatMatrix(A(idx)+2).poc_04]];
      tod_poc_05 = [[GOCI_DailyStatMatrix(A(idx)).poc_05] [GOCI_DailyStatMatrix(A(idx)+1).poc_05] [GOCI_DailyStatMatrix(A(idx)+2).poc_05]];
      tod_poc_06 = [[GOCI_DailyStatMatrix(A(idx)).poc_06] [GOCI_DailyStatMatrix(A(idx)+1).poc_06] [GOCI_DailyStatMatrix(A(idx)+2).poc_06]];
      tod_poc_07 = [[GOCI_DailyStatMatrix(A(idx)).poc_07] [GOCI_DailyStatMatrix(A(idx)+1).poc_07] [GOCI_DailyStatMatrix(A(idx)+2).poc_07]];
      
      
      % par
      
      tod_chlor_a_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_chlor_a_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      
      tod_ag_412_mlrc_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_ag_412_mlrc_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      
      tod_poc_00_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_01_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_02_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_03_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_04_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_05_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_06_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      tod_poc_07_datetime = [[GOCI_DailyStatMatrix(A(idx)).datetime] [GOCI_DailyStatMatrix(A(idx)+1).datetime] [GOCI_DailyStatMatrix(A(idx)+2).datetime]];
      % saveas(gcf,[savedirname '3_day_sequence'],'epsc')
      
      %% par plot
      fs = 30;
      lw = 1.5;
      ms = 16;
      
      % chlor_a
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A(idx))]);
      
      plot(tod_chlor_a_00_datetime+hours(0),tod_chlor_a_00,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_chlor_a_01_datetime+hours(1),tod_chlor_a_01,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_chlor_a_02_datetime+hours(2),tod_chlor_a_02,'-^b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_chlor_a_03_datetime+hours(3),tod_chlor_a_03,'-^k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_chlor_a_04_datetime+hours(4),tod_chlor_a_04,'-^c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_chlor_a_05_datetime+hours(5),tod_chlor_a_05,'-^m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_chlor_a_06_datetime+hours(6),tod_chlor_a_06,'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_chlor_a_07_datetime+hours(7),tod_chlor_a_07,'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      grid on
      
      ylabel('Chlor-{\ita} [mg m^{-3}]','FontSize',fs)
      xlabel('Time','FontSize',fs)
      
      datetick('x','mm/dd/yy')
      ax = gca;
      ax.YLim(1) = 0;
      ylim([0 0.09])
      ax.XLim(1) = ax.XTick(1)-0.2;
      ax.XLim(2) = ax.XTick(3)+0.5;
      
      hleg = legend('0h','1h','2h','3h','4h','5h','6h','7h');
      set(hleg,'Location','southeast');
      set(hleg,'fontsize',22)
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      saveas(gcf,[savedirname '3day_chlor_a_' num2str(idx)],'epsc')
      
      % ag_412_mlrc
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A(idx))]);
      
      plot(tod_ag_412_mlrc_00_datetime+hours(0),tod_ag_412_mlrc_00,'-*r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_ag_412_mlrc_01_datetime+hours(1),tod_ag_412_mlrc_01,'-*g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_ag_412_mlrc_02_datetime+hours(2),tod_ag_412_mlrc_02,'-*b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_ag_412_mlrc_03_datetime+hours(3),tod_ag_412_mlrc_03,'-*k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_ag_412_mlrc_04_datetime+hours(4),tod_ag_412_mlrc_04,'-*c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_ag_412_mlrc_05_datetime+hours(5),tod_ag_412_mlrc_05,'-*m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_ag_412_mlrc_06_datetime+hours(6),tod_ag_412_mlrc_06,'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_ag_412_mlrc_07_datetime+hours(7),tod_ag_412_mlrc_07,'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      grid on
      
      ylabel('a_{g}(412) [m^{-1}]','FontSize',fs)
      xlabel('Time','FontSize',fs)
      
      datetick('x','mm/dd/yy')
      ax = gca;
      ax.YLim(1) = 0 ;
      ax.XLim(1) = ax.XTick(1)-0.2;
      ax.XLim(2) = ax.XTick(3)+0.5;
      
      hleg = legend('0h','1h','2h','3h','4h','5h','6h','7h');
      set(hleg,'Location','southeast');
      set(hleg,'fontsize',22)
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      saveas(gcf,[savedirname '3day_ag_412_mlrc_' num2str(idx)],'epsc')
      
      % poc
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A(idx))]);
      
      plot(tod_poc_00_datetime+hours(0),tod_poc_00,'-xr','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_poc_01_datetime+hours(1),tod_poc_01,'-xg','MarkerSize',ms,'LineWidth',lw)
      plot(tod_poc_02_datetime+hours(2),tod_poc_02,'-xb','MarkerSize',ms,'LineWidth',lw)
      plot(tod_poc_03_datetime+hours(3),tod_poc_03,'-xk','MarkerSize',ms,'LineWidth',lw)
      plot(tod_poc_04_datetime+hours(4),tod_poc_04,'-xc','MarkerSize',ms,'LineWidth',lw)
      plot(tod_poc_05_datetime+hours(5),tod_poc_05,'-xm','MarkerSize',ms,'LineWidth',lw)
      plot(tod_poc_06_datetime+hours(6),tod_poc_06,'-x','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_poc_07_datetime+hours(7),tod_poc_07,'-x','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      grid on
      
      ylabel('POC [mg m^{-3}]','FontSize',fs)
      xlabel('Time','FontSize',fs)
      
      datetick('x','mm/dd/yy')
      ax = gca;
      ax.YLim(1) = 0 ;
      ax.XLim(1) = ax.XTick(1)-0.2;
      ax.XLim(2) = ax.XTick(3)+0.5;
      
      hleg = legend('0h','1h','2h','3h','4h','5h','6h','7h');
      set(hleg,'Location','southeast');
      set(hleg,'fontsize',22)
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      saveas(gcf,[savedirname '3day_poc_' num2str(idx)],'epsc')
end
%% 3-day sequences stats -- Rrs

for idx = 1:sum(three_day_idx)
      
      % Rrs
      three_day_seq(idx).tod_Rrs_412_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_00]];
      three_day_seq(idx).tod_Rrs_412_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_01]];
      three_day_seq(idx).tod_Rrs_412_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_02]];
      three_day_seq(idx).tod_Rrs_412_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_03]];
      three_day_seq(idx).tod_Rrs_412_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_04]];
      three_day_seq(idx).tod_Rrs_412_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_05]];
      three_day_seq(idx).tod_Rrs_412_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_06]];
      three_day_seq(idx).tod_Rrs_412_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_412_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_412_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_412_07]];
      
      three_day_seq(idx).tod_Rrs_443_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_00]];
      three_day_seq(idx).tod_Rrs_443_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_01]];
      three_day_seq(idx).tod_Rrs_443_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_02]];
      three_day_seq(idx).tod_Rrs_443_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_03]];
      three_day_seq(idx).tod_Rrs_443_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_04]];
      three_day_seq(idx).tod_Rrs_443_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_05]];
      three_day_seq(idx).tod_Rrs_443_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_06]];
      three_day_seq(idx).tod_Rrs_443_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_443_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_443_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_443_07]];
      
      three_day_seq(idx).tod_Rrs_490_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_00]];
      three_day_seq(idx).tod_Rrs_490_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_01]];
      three_day_seq(idx).tod_Rrs_490_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_02]];
      three_day_seq(idx).tod_Rrs_490_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_03]];
      three_day_seq(idx).tod_Rrs_490_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_04]];
      three_day_seq(idx).tod_Rrs_490_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_05]];
      three_day_seq(idx).tod_Rrs_490_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_06]];
      three_day_seq(idx).tod_Rrs_490_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_490_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_490_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_490_07]];
      
      three_day_seq(idx).tod_Rrs_555_00 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_00] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_00] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_00]];
      three_day_seq(idx).tod_Rrs_555_01 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_01] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_01] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_01]];
      three_day_seq(idx).tod_Rrs_555_02 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_02] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_02] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_02]];
      three_day_seq(idx).tod_Rrs_555_03 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_03] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_03] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_03]];
      three_day_seq(idx).tod_Rrs_555_04 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_04] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_04] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_04]];
      three_day_seq(idx).tod_Rrs_555_05 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_05] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_05] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_05]];
      three_day_seq(idx).tod_Rrs_555_06 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_06] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_06] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_06]];
      three_day_seq(idx).tod_Rrs_555_07 = [[GOCI_DailyStatMatrix(A(idx)).Rrs_555_07] [GOCI_DailyStatMatrix(A(idx)+1).Rrs_555_07] [GOCI_DailyStatMatrix(A(idx)+2).Rrs_555_07]];
      
      % mean
      three_day_seq(idx).tod_Rrs_412_00_mean = nanmean(three_day_seq(idx).tod_Rrs_412_00);
      three_day_seq(idx).tod_Rrs_412_01_mean = nanmean(three_day_seq(idx).tod_Rrs_412_01);
      three_day_seq(idx).tod_Rrs_412_02_mean = nanmean(three_day_seq(idx).tod_Rrs_412_02);
      three_day_seq(idx).tod_Rrs_412_03_mean = nanmean(three_day_seq(idx).tod_Rrs_412_03);
      three_day_seq(idx).tod_Rrs_412_04_mean = nanmean(three_day_seq(idx).tod_Rrs_412_04);
      three_day_seq(idx).tod_Rrs_412_05_mean = nanmean(three_day_seq(idx).tod_Rrs_412_05);
      three_day_seq(idx).tod_Rrs_412_06_mean = nanmean(three_day_seq(idx).tod_Rrs_412_06);
      three_day_seq(idx).tod_Rrs_412_07_mean = nanmean(three_day_seq(idx).tod_Rrs_412_07);
      three_day_seq(idx).tod_Rrs_443_00_mean = nanmean(three_day_seq(idx).tod_Rrs_443_00);
      three_day_seq(idx).tod_Rrs_443_01_mean = nanmean(three_day_seq(idx).tod_Rrs_443_01);
      three_day_seq(idx).tod_Rrs_443_02_mean = nanmean(three_day_seq(idx).tod_Rrs_443_02);
      three_day_seq(idx).tod_Rrs_443_03_mean = nanmean(three_day_seq(idx).tod_Rrs_443_03);
      three_day_seq(idx).tod_Rrs_443_04_mean = nanmean(three_day_seq(idx).tod_Rrs_443_04);
      three_day_seq(idx).tod_Rrs_443_05_mean = nanmean(three_day_seq(idx).tod_Rrs_443_05);
      three_day_seq(idx).tod_Rrs_443_06_mean = nanmean(three_day_seq(idx).tod_Rrs_443_06);
      three_day_seq(idx).tod_Rrs_443_07_mean = nanmean(three_day_seq(idx).tod_Rrs_443_07);
      three_day_seq(idx).tod_Rrs_490_00_mean = nanmean(three_day_seq(idx).tod_Rrs_490_00);
      three_day_seq(idx).tod_Rrs_490_01_mean = nanmean(three_day_seq(idx).tod_Rrs_490_01);
      three_day_seq(idx).tod_Rrs_490_02_mean = nanmean(three_day_seq(idx).tod_Rrs_490_02);
      three_day_seq(idx).tod_Rrs_490_03_mean = nanmean(three_day_seq(idx).tod_Rrs_490_03);
      three_day_seq(idx).tod_Rrs_490_04_mean = nanmean(three_day_seq(idx).tod_Rrs_490_04);
      three_day_seq(idx).tod_Rrs_490_05_mean = nanmean(three_day_seq(idx).tod_Rrs_490_05);
      three_day_seq(idx).tod_Rrs_490_06_mean = nanmean(three_day_seq(idx).tod_Rrs_490_06);
      three_day_seq(idx).tod_Rrs_490_07_mean = nanmean(three_day_seq(idx).tod_Rrs_490_07);
      three_day_seq(idx).tod_Rrs_555_00_mean = nanmean(three_day_seq(idx).tod_Rrs_555_00);
      three_day_seq(idx).tod_Rrs_555_01_mean = nanmean(three_day_seq(idx).tod_Rrs_555_01);
      three_day_seq(idx).tod_Rrs_555_02_mean = nanmean(three_day_seq(idx).tod_Rrs_555_02);
      three_day_seq(idx).tod_Rrs_555_03_mean = nanmean(three_day_seq(idx).tod_Rrs_555_03);
      three_day_seq(idx).tod_Rrs_555_04_mean = nanmean(three_day_seq(idx).tod_Rrs_555_04);
      three_day_seq(idx).tod_Rrs_555_05_mean = nanmean(three_day_seq(idx).tod_Rrs_555_05);
      three_day_seq(idx).tod_Rrs_555_06_mean = nanmean(three_day_seq(idx).tod_Rrs_555_06);
      three_day_seq(idx).tod_Rrs_555_07_mean = nanmean(three_day_seq(idx).tod_Rrs_555_07);
      
      % SD
      three_day_seq(idx).tod_Rrs_412_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_00);
      three_day_seq(idx).tod_Rrs_412_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_01);
      three_day_seq(idx).tod_Rrs_412_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_02);
      three_day_seq(idx).tod_Rrs_412_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_03);
      three_day_seq(idx).tod_Rrs_412_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_04);
      three_day_seq(idx).tod_Rrs_412_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_05);
      three_day_seq(idx).tod_Rrs_412_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_06);
      three_day_seq(idx).tod_Rrs_412_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_07);
      three_day_seq(idx).tod_Rrs_443_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_00);
      three_day_seq(idx).tod_Rrs_443_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_01);
      three_day_seq(idx).tod_Rrs_443_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_02);
      three_day_seq(idx).tod_Rrs_443_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_03);
      three_day_seq(idx).tod_Rrs_443_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_04);
      three_day_seq(idx).tod_Rrs_443_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_05);
      three_day_seq(idx).tod_Rrs_443_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_06);
      three_day_seq(idx).tod_Rrs_443_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_07);
      three_day_seq(idx).tod_Rrs_490_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_00);
      three_day_seq(idx).tod_Rrs_490_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_01);
      three_day_seq(idx).tod_Rrs_490_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_02);
      three_day_seq(idx).tod_Rrs_490_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_03);
      three_day_seq(idx).tod_Rrs_490_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_04);
      three_day_seq(idx).tod_Rrs_490_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_05);
      three_day_seq(idx).tod_Rrs_490_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_06);
      three_day_seq(idx).tod_Rrs_490_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_07);
      three_day_seq(idx).tod_Rrs_555_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_00);
      three_day_seq(idx).tod_Rrs_555_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_01);
      three_day_seq(idx).tod_Rrs_555_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_02);
      three_day_seq(idx).tod_Rrs_555_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_03);
      three_day_seq(idx).tod_Rrs_555_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_04);
      three_day_seq(idx).tod_Rrs_555_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_05);
      three_day_seq(idx).tod_Rrs_555_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_06);
      three_day_seq(idx).tod_Rrs_555_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_07);
      
      % CV
      three_day_seq(idx).tod_Rrs_412_00_CV = three_day_seq(idx).tod_Rrs_412_00_stdv/three_day_seq(idx).tod_Rrs_412_00_mean;
      three_day_seq(idx).tod_Rrs_412_01_CV = three_day_seq(idx).tod_Rrs_412_01_stdv/three_day_seq(idx).tod_Rrs_412_01_mean;
      three_day_seq(idx).tod_Rrs_412_02_CV = three_day_seq(idx).tod_Rrs_412_02_stdv/three_day_seq(idx).tod_Rrs_412_02_mean;
      three_day_seq(idx).tod_Rrs_412_03_CV = three_day_seq(idx).tod_Rrs_412_03_stdv/three_day_seq(idx).tod_Rrs_412_03_mean;
      three_day_seq(idx).tod_Rrs_412_04_CV = three_day_seq(idx).tod_Rrs_412_04_stdv/three_day_seq(idx).tod_Rrs_412_04_mean;
      three_day_seq(idx).tod_Rrs_412_05_CV = three_day_seq(idx).tod_Rrs_412_05_stdv/three_day_seq(idx).tod_Rrs_412_05_mean;
      three_day_seq(idx).tod_Rrs_412_06_CV = three_day_seq(idx).tod_Rrs_412_06_stdv/three_day_seq(idx).tod_Rrs_412_06_mean;
      three_day_seq(idx).tod_Rrs_412_07_CV = three_day_seq(idx).tod_Rrs_412_07_stdv/three_day_seq(idx).tod_Rrs_412_07_mean;
      three_day_seq(idx).tod_Rrs_443_00_CV = three_day_seq(idx).tod_Rrs_443_00_stdv/three_day_seq(idx).tod_Rrs_443_00_mean;
      three_day_seq(idx).tod_Rrs_443_01_CV = three_day_seq(idx).tod_Rrs_443_01_stdv/three_day_seq(idx).tod_Rrs_443_01_mean;
      three_day_seq(idx).tod_Rrs_443_02_CV = three_day_seq(idx).tod_Rrs_443_02_stdv/three_day_seq(idx).tod_Rrs_443_02_mean;
      three_day_seq(idx).tod_Rrs_443_03_CV = three_day_seq(idx).tod_Rrs_443_03_stdv/three_day_seq(idx).tod_Rrs_443_03_mean;
      three_day_seq(idx).tod_Rrs_443_04_CV = three_day_seq(idx).tod_Rrs_443_04_stdv/three_day_seq(idx).tod_Rrs_443_04_mean;
      three_day_seq(idx).tod_Rrs_443_05_CV = three_day_seq(idx).tod_Rrs_443_05_stdv/three_day_seq(idx).tod_Rrs_443_05_mean;
      three_day_seq(idx).tod_Rrs_443_06_CV = three_day_seq(idx).tod_Rrs_443_06_stdv/three_day_seq(idx).tod_Rrs_443_06_mean;
      three_day_seq(idx).tod_Rrs_443_07_CV = three_day_seq(idx).tod_Rrs_443_07_stdv/three_day_seq(idx).tod_Rrs_443_07_mean;
      three_day_seq(idx).tod_Rrs_490_00_CV = three_day_seq(idx).tod_Rrs_490_00_stdv/three_day_seq(idx).tod_Rrs_490_00_mean;
      three_day_seq(idx).tod_Rrs_490_01_CV = three_day_seq(idx).tod_Rrs_490_01_stdv/three_day_seq(idx).tod_Rrs_490_01_mean;
      three_day_seq(idx).tod_Rrs_490_02_CV = three_day_seq(idx).tod_Rrs_490_02_stdv/three_day_seq(idx).tod_Rrs_490_02_mean;
      three_day_seq(idx).tod_Rrs_490_03_CV = three_day_seq(idx).tod_Rrs_490_03_stdv/three_day_seq(idx).tod_Rrs_490_03_mean;
      three_day_seq(idx).tod_Rrs_490_04_CV = three_day_seq(idx).tod_Rrs_490_04_stdv/three_day_seq(idx).tod_Rrs_490_04_mean;
      three_day_seq(idx).tod_Rrs_490_05_CV = three_day_seq(idx).tod_Rrs_490_05_stdv/three_day_seq(idx).tod_Rrs_490_05_mean;
      three_day_seq(idx).tod_Rrs_490_06_CV = three_day_seq(idx).tod_Rrs_490_06_stdv/three_day_seq(idx).tod_Rrs_490_06_mean;
      three_day_seq(idx).tod_Rrs_490_07_CV = three_day_seq(idx).tod_Rrs_490_07_stdv/three_day_seq(idx).tod_Rrs_490_07_mean;
      three_day_seq(idx).tod_Rrs_555_00_CV = three_day_seq(idx).tod_Rrs_555_00_stdv/three_day_seq(idx).tod_Rrs_555_00_mean;
      three_day_seq(idx).tod_Rrs_555_01_CV = three_day_seq(idx).tod_Rrs_555_01_stdv/three_day_seq(idx).tod_Rrs_555_01_mean;
      three_day_seq(idx).tod_Rrs_555_02_CV = three_day_seq(idx).tod_Rrs_555_02_stdv/three_day_seq(idx).tod_Rrs_555_02_mean;
      three_day_seq(idx).tod_Rrs_555_03_CV = three_day_seq(idx).tod_Rrs_555_03_stdv/three_day_seq(idx).tod_Rrs_555_03_mean;
      three_day_seq(idx).tod_Rrs_555_04_CV = three_day_seq(idx).tod_Rrs_555_04_stdv/three_day_seq(idx).tod_Rrs_555_04_mean;
      three_day_seq(idx).tod_Rrs_555_05_CV = three_day_seq(idx).tod_Rrs_555_05_stdv/three_day_seq(idx).tod_Rrs_555_05_mean;
      three_day_seq(idx).tod_Rrs_555_06_CV = three_day_seq(idx).tod_Rrs_555_06_stdv/three_day_seq(idx).tod_Rrs_555_06_mean;
      three_day_seq(idx).tod_Rrs_555_07_CV = three_day_seq(idx).tod_Rrs_555_07_stdv/three_day_seq(idx).tod_Rrs_555_07_mean;
      
end

fs = 30;
lw = 1.5;
ms = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);

% Rrs_412
% subplot(2,2,1)
plot(0,100*nanmean([three_day_seq.tod_Rrs_412_00_CV]),'-or','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_Rrs_412_01_CV]),'-og','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_Rrs_412_02_CV]),'-ob','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_Rrs_412_03_CV]),'-ok','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_Rrs_412_04_CV]),'-oc','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_Rrs_412_05_CV]),'-om','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_Rrs_412_06_CV]),'-o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_Rrs_412_07_CV]),'-o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ylabel('R_{rs}(412) [sr^{-1}]','FontSize',fs)
% xlabel('Time','FontSize',fs)
% legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% Rrs_443
% subplot(2,2,1)
plot(0,100*nanmean([three_day_seq.tod_Rrs_443_00_CV]),'-^r','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_Rrs_443_01_CV]),'-^g','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_Rrs_443_02_CV]),'-^b','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_Rrs_443_03_CV]),'-^k','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_Rrs_443_04_CV]),'-^c','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_Rrs_443_05_CV]),'-^m','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_Rrs_443_06_CV]),'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_Rrs_443_07_CV]),'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ylabel('R_{rs}(443) [sr^{-1}]','FontSize',fs)
% xlabel('Time','FontSize',fs)
% legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% Rrs_490
% subplot(2,2,1)
plot(0,100*nanmean([three_day_seq.tod_Rrs_490_00_CV]),'-*r','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_Rrs_490_01_CV]),'-*g','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_Rrs_490_02_CV]),'-*b','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_Rrs_490_03_CV]),'-*k','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_Rrs_490_04_CV]),'-*c','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_Rrs_490_05_CV]),'-*m','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_Rrs_490_06_CV]),'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_Rrs_490_07_CV]),'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ylabel('R_{rs}(490) [sr^{-1}]','FontSize',fs)
% xlabel('Time','FontSize',fs)
% legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% Rrs_555
% subplot(2,2,1)
plot(0,100*nanmean([three_day_seq.tod_Rrs_555_00_CV]),'-xr','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_Rrs_555_01_CV]),'-xg','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_Rrs_555_02_CV]),'-xb','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_Rrs_555_03_CV]),'-xk','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_Rrs_555_04_CV]),'-xc','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_Rrs_555_05_CV]),'-xm','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_Rrs_555_06_CV]),'-x','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_Rrs_555_07_CV]),'-x','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

grid on
ylabel('Mean of CV for R_{rs}(\lambda) [%]','FontSize',fs)
xlabel('Time of the day','FontSize',fs)

hleg = legend('412: 0h','412: 1h','412: 2h','412: 3h','412: 4h','412: 5h','412: 6h','412: 7h',...
      '443: 0h','443: 1h','443: 2h','443: 3h','443: 4h','443: 5h','443: 6h','443: 7h',...
      '490: 0h','490: 1h','490: 2h','490: 3h','490: 4h','490: 5h','490: 6h','490: 7h',...
      '555: 0h','555: 1h','555: 2h','555: 3h','555: 4h','555: 5h','555: 6h','555: 7h',...
      'Location','northeastoutside');
set(hleg,'fontsize',22)

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

xlim([-1 8])
ax = gca;
ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};
%% mean and st dev
h = figure('Color','white','DefaultAxesFontSize',fs);

% Rrs_412
% subplot(2,2,1)
errorbar(0,mean([three_day_seq.tod_Rrs_412_00_mean]),mean([three_day_seq.tod_Rrs_412_00_stdv]),'-or','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,mean([three_day_seq.tod_Rrs_412_01_mean]),mean([three_day_seq.tod_Rrs_412_01_stdv]),'-og','MarkerSize',ms,'LineWidth',lw)
errorbar(2,mean([three_day_seq.tod_Rrs_412_02_mean]),mean([three_day_seq.tod_Rrs_412_02_stdv]),'-ob','MarkerSize',ms,'LineWidth',lw)
errorbar(3,mean([three_day_seq.tod_Rrs_412_03_mean]),mean([three_day_seq.tod_Rrs_412_03_stdv]),'-ok','MarkerSize',ms,'LineWidth',lw)
errorbar(4,mean([three_day_seq.tod_Rrs_412_04_mean]),mean([three_day_seq.tod_Rrs_412_04_stdv]),'-oc','MarkerSize',ms,'LineWidth',lw)
errorbar(5,mean([three_day_seq.tod_Rrs_412_05_mean]),mean([three_day_seq.tod_Rrs_412_05_stdv]),'-om','MarkerSize',ms,'LineWidth',lw)
errorbar(6,mean([three_day_seq.tod_Rrs_412_06_mean]),mean([three_day_seq.tod_Rrs_412_06_stdv]),'-o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,mean([three_day_seq.tod_Rrs_412_07_mean]),mean([three_day_seq.tod_Rrs_412_07_stdv]),'-o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ylabel('R_{rs}(412) [sr^{-1}]','FontSize',fs)
% xlabel('Time','FontSize',fs)
% legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% Rrs_443
% subplot(2,2,1)
errorbar(0,mean([three_day_seq.tod_Rrs_443_00_mean]),mean([three_day_seq.tod_Rrs_443_00_stdv]),'-^r','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,mean([three_day_seq.tod_Rrs_443_01_mean]),mean([three_day_seq.tod_Rrs_443_01_stdv]),'-^g','MarkerSize',ms,'LineWidth',lw)
errorbar(2,mean([three_day_seq.tod_Rrs_443_02_mean]),mean([three_day_seq.tod_Rrs_443_02_stdv]),'-^b','MarkerSize',ms,'LineWidth',lw)
errorbar(3,mean([three_day_seq.tod_Rrs_443_03_mean]),mean([three_day_seq.tod_Rrs_443_03_stdv]),'-^k','MarkerSize',ms,'LineWidth',lw)
errorbar(4,mean([three_day_seq.tod_Rrs_443_04_mean]),mean([three_day_seq.tod_Rrs_443_04_stdv]),'-^c','MarkerSize',ms,'LineWidth',lw)
errorbar(5,mean([three_day_seq.tod_Rrs_443_05_mean]),mean([three_day_seq.tod_Rrs_443_05_stdv]),'-^m','MarkerSize',ms,'LineWidth',lw)
errorbar(6,mean([three_day_seq.tod_Rrs_443_06_mean]),mean([three_day_seq.tod_Rrs_443_06_stdv]),'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,mean([three_day_seq.tod_Rrs_443_07_mean]),mean([three_day_seq.tod_Rrs_443_07_stdv]),'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ylabel('R_{rs}(443) [sr^{-1}]','FontSize',fs)
% xlabel('Time','FontSize',fs)
% legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% Rrs_490
% subplot(2,2,1)
errorbar(0,mean([three_day_seq.tod_Rrs_490_00_mean]),mean([three_day_seq.tod_Rrs_490_00_stdv]),'-*r','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,mean([three_day_seq.tod_Rrs_490_01_mean]),mean([three_day_seq.tod_Rrs_490_01_stdv]),'-*g','MarkerSize',ms,'LineWidth',lw)
errorbar(2,mean([three_day_seq.tod_Rrs_490_02_mean]),mean([three_day_seq.tod_Rrs_490_02_stdv]),'-*b','MarkerSize',ms,'LineWidth',lw)
errorbar(3,mean([three_day_seq.tod_Rrs_490_03_mean]),mean([three_day_seq.tod_Rrs_490_03_stdv]),'-*k','MarkerSize',ms,'LineWidth',lw)
errorbar(4,mean([three_day_seq.tod_Rrs_490_04_mean]),mean([three_day_seq.tod_Rrs_490_04_stdv]),'-*c','MarkerSize',ms,'LineWidth',lw)
errorbar(5,mean([three_day_seq.tod_Rrs_490_05_mean]),mean([three_day_seq.tod_Rrs_490_05_stdv]),'-*m','MarkerSize',ms,'LineWidth',lw)
errorbar(6,mean([three_day_seq.tod_Rrs_490_06_mean]),mean([three_day_seq.tod_Rrs_490_06_stdv]),'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,mean([three_day_seq.tod_Rrs_490_07_mean]),mean([three_day_seq.tod_Rrs_490_07_stdv]),'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ylabel('R_{rs}(490) [sr^{-1}]','FontSize',fs)
% xlabel('Time','FontSize',fs)
% legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% Rrs_555
% subplot(2,2,1)
errorbar(0,mean([three_day_seq.tod_Rrs_555_00_mean]),mean([three_day_seq.tod_Rrs_555_00_stdv]),'-xr','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,mean([three_day_seq.tod_Rrs_555_01_mean]),mean([three_day_seq.tod_Rrs_555_01_stdv]),'-xg','MarkerSize',ms,'LineWidth',lw)
errorbar(2,mean([three_day_seq.tod_Rrs_555_02_mean]),mean([three_day_seq.tod_Rrs_555_02_stdv]),'-xb','MarkerSize',ms,'LineWidth',lw)
errorbar(3,mean([three_day_seq.tod_Rrs_555_03_mean]),mean([three_day_seq.tod_Rrs_555_03_stdv]),'-xk','MarkerSize',ms,'LineWidth',lw)
errorbar(4,mean([three_day_seq.tod_Rrs_555_04_mean]),mean([three_day_seq.tod_Rrs_555_04_stdv]),'-xc','MarkerSize',ms,'LineWidth',lw)
errorbar(5,mean([three_day_seq.tod_Rrs_555_05_mean]),mean([three_day_seq.tod_Rrs_555_05_stdv]),'-xm','MarkerSize',ms,'LineWidth',lw)
errorbar(6,mean([three_day_seq.tod_Rrs_555_06_mean]),mean([three_day_seq.tod_Rrs_555_06_stdv]),'-x','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,mean([three_day_seq.tod_Rrs_555_07_mean]),mean([three_day_seq.tod_Rrs_555_07_stdv]),'-x','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

grid on
ylabel('Mean of the mean R_{rs}(\lambda) [sr^{-1}]','FontSize',fs)
xlabel('Time of the day','FontSize',fs)

hleg = legend('412: 0h','412: 1h','412: 2h','412: 3h','412: 4h','412: 5h','412: 6h','412: 7h',...
      '443: 0h','443: 1h','443: 2h','443: 3h','443: 4h','443: 5h','443: 6h','443: 7h',...
      '490: 0h','490: 1h','490: 2h','490: 3h','490: 4h','490: 5h','490: 6h','490: 7h',...
      '555: 0h','555: 1h','555: 2h','555: 3h','555: 4h','555: 5h','555: 6h','555: 7h',...
      'Location','northeastoutside');
set(hleg,'fontsize',22)

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

xlim([-1 8])
ax = gca;
ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

%% 3-day sequences stats -- par

for idx = 1:sum(three_day_idx)
      
      % par
      three_day_seq(idx).tod_chlor_a_00 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_00] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_00] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_00]];
      three_day_seq(idx).tod_chlor_a_01 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_01] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_01] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_01]];
      three_day_seq(idx).tod_chlor_a_02 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_02] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_02] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_02]];
      three_day_seq(idx).tod_chlor_a_03 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_03] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_03] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_03]];
      three_day_seq(idx).tod_chlor_a_04 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_04] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_04] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_04]];
      three_day_seq(idx).tod_chlor_a_05 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_05] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_05] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_05]];
      three_day_seq(idx).tod_chlor_a_06 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_06] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_06] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_06]];
      three_day_seq(idx).tod_chlor_a_07 = [[GOCI_DailyStatMatrix(A(idx)).chlor_a_07] [GOCI_DailyStatMatrix(A(idx)+1).chlor_a_07] [GOCI_DailyStatMatrix(A(idx)+2).chlor_a_07]];
      
      three_day_seq(idx).tod_ag_412_mlrc_00 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_00]];
      three_day_seq(idx).tod_ag_412_mlrc_01 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_01]];
      three_day_seq(idx).tod_ag_412_mlrc_02 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_02]];
      three_day_seq(idx).tod_ag_412_mlrc_03 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_03]];
      three_day_seq(idx).tod_ag_412_mlrc_04 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_04]];
      three_day_seq(idx).tod_ag_412_mlrc_05 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_05]];
      three_day_seq(idx).tod_ag_412_mlrc_06 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_06]];
      three_day_seq(idx).tod_ag_412_mlrc_07 = [[GOCI_DailyStatMatrix(A(idx)).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A(idx)+1).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A(idx)+2).ag_412_mlrc_07]];
      
      three_day_seq(idx).tod_poc_00 = [[GOCI_DailyStatMatrix(A(idx)).poc_00] [GOCI_DailyStatMatrix(A(idx)+1).poc_00] [GOCI_DailyStatMatrix(A(idx)+2).poc_00]];
      three_day_seq(idx).tod_poc_01 = [[GOCI_DailyStatMatrix(A(idx)).poc_01] [GOCI_DailyStatMatrix(A(idx)+1).poc_01] [GOCI_DailyStatMatrix(A(idx)+2).poc_01]];
      three_day_seq(idx).tod_poc_02 = [[GOCI_DailyStatMatrix(A(idx)).poc_02] [GOCI_DailyStatMatrix(A(idx)+1).poc_02] [GOCI_DailyStatMatrix(A(idx)+2).poc_02]];
      three_day_seq(idx).tod_poc_03 = [[GOCI_DailyStatMatrix(A(idx)).poc_03] [GOCI_DailyStatMatrix(A(idx)+1).poc_03] [GOCI_DailyStatMatrix(A(idx)+2).poc_03]];
      three_day_seq(idx).tod_poc_04 = [[GOCI_DailyStatMatrix(A(idx)).poc_04] [GOCI_DailyStatMatrix(A(idx)+1).poc_04] [GOCI_DailyStatMatrix(A(idx)+2).poc_04]];
      three_day_seq(idx).tod_poc_05 = [[GOCI_DailyStatMatrix(A(idx)).poc_05] [GOCI_DailyStatMatrix(A(idx)+1).poc_05] [GOCI_DailyStatMatrix(A(idx)+2).poc_05]];
      three_day_seq(idx).tod_poc_06 = [[GOCI_DailyStatMatrix(A(idx)).poc_06] [GOCI_DailyStatMatrix(A(idx)+1).poc_06] [GOCI_DailyStatMatrix(A(idx)+2).poc_06]];
      three_day_seq(idx).tod_poc_07 = [[GOCI_DailyStatMatrix(A(idx)).poc_07] [GOCI_DailyStatMatrix(A(idx)+1).poc_07] [GOCI_DailyStatMatrix(A(idx)+2).poc_07]];
      
      % mean
      three_day_seq(idx).tod_chlor_a_00_mean = nanmean(three_day_seq(idx).tod_chlor_a_00);
      three_day_seq(idx).tod_chlor_a_01_mean = nanmean(three_day_seq(idx).tod_chlor_a_01);
      three_day_seq(idx).tod_chlor_a_02_mean = nanmean(three_day_seq(idx).tod_chlor_a_02);
      three_day_seq(idx).tod_chlor_a_03_mean = nanmean(three_day_seq(idx).tod_chlor_a_03);
      three_day_seq(idx).tod_chlor_a_04_mean = nanmean(three_day_seq(idx).tod_chlor_a_04);
      three_day_seq(idx).tod_chlor_a_05_mean = nanmean(three_day_seq(idx).tod_chlor_a_05);
      three_day_seq(idx).tod_chlor_a_06_mean = nanmean(three_day_seq(idx).tod_chlor_a_06);
      three_day_seq(idx).tod_chlor_a_07_mean = nanmean(three_day_seq(idx).tod_chlor_a_07);
      
      three_day_seq(idx).tod_ag_412_mlrc_00_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_00);
      three_day_seq(idx).tod_ag_412_mlrc_01_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_01);
      three_day_seq(idx).tod_ag_412_mlrc_02_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_02);
      three_day_seq(idx).tod_ag_412_mlrc_03_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_03);
      three_day_seq(idx).tod_ag_412_mlrc_04_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_04);
      three_day_seq(idx).tod_ag_412_mlrc_05_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_05);
      three_day_seq(idx).tod_ag_412_mlrc_06_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_06);
      three_day_seq(idx).tod_ag_412_mlrc_07_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_07);
      
      three_day_seq(idx).tod_poc_00_mean = nanmean(three_day_seq(idx).tod_poc_00);
      three_day_seq(idx).tod_poc_01_mean = nanmean(three_day_seq(idx).tod_poc_01);
      three_day_seq(idx).tod_poc_02_mean = nanmean(three_day_seq(idx).tod_poc_02);
      three_day_seq(idx).tod_poc_03_mean = nanmean(three_day_seq(idx).tod_poc_03);
      three_day_seq(idx).tod_poc_04_mean = nanmean(three_day_seq(idx).tod_poc_04);
      three_day_seq(idx).tod_poc_05_mean = nanmean(three_day_seq(idx).tod_poc_05);
      three_day_seq(idx).tod_poc_06_mean = nanmean(three_day_seq(idx).tod_poc_06);
      three_day_seq(idx).tod_poc_07_mean = nanmean(three_day_seq(idx).tod_poc_07);
      
      % SD
      three_day_seq(idx).tod_chlor_a_00_stdv = nanstd(three_day_seq(idx).tod_chlor_a_00);
      three_day_seq(idx).tod_chlor_a_01_stdv = nanstd(three_day_seq(idx).tod_chlor_a_01);
      three_day_seq(idx).tod_chlor_a_02_stdv = nanstd(three_day_seq(idx).tod_chlor_a_02);
      three_day_seq(idx).tod_chlor_a_03_stdv = nanstd(three_day_seq(idx).tod_chlor_a_03);
      three_day_seq(idx).tod_chlor_a_04_stdv = nanstd(three_day_seq(idx).tod_chlor_a_04);
      three_day_seq(idx).tod_chlor_a_05_stdv = nanstd(three_day_seq(idx).tod_chlor_a_05);
      three_day_seq(idx).tod_chlor_a_06_stdv = nanstd(three_day_seq(idx).tod_chlor_a_06);
      three_day_seq(idx).tod_chlor_a_07_stdv = nanstd(three_day_seq(idx).tod_chlor_a_07);
      
      three_day_seq(idx).tod_ag_412_mlrc_00_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_00);
      three_day_seq(idx).tod_ag_412_mlrc_01_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_01);
      three_day_seq(idx).tod_ag_412_mlrc_02_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_02);
      three_day_seq(idx).tod_ag_412_mlrc_03_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_03);
      three_day_seq(idx).tod_ag_412_mlrc_04_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_04);
      three_day_seq(idx).tod_ag_412_mlrc_05_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_05);
      three_day_seq(idx).tod_ag_412_mlrc_06_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_06);
      three_day_seq(idx).tod_ag_412_mlrc_07_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_07);
      
      three_day_seq(idx).tod_poc_00_stdv = nanstd(three_day_seq(idx).tod_poc_00);
      three_day_seq(idx).tod_poc_01_stdv = nanstd(three_day_seq(idx).tod_poc_01);
      three_day_seq(idx).tod_poc_02_stdv = nanstd(three_day_seq(idx).tod_poc_02);
      three_day_seq(idx).tod_poc_03_stdv = nanstd(three_day_seq(idx).tod_poc_03);
      three_day_seq(idx).tod_poc_04_stdv = nanstd(three_day_seq(idx).tod_poc_04);
      three_day_seq(idx).tod_poc_05_stdv = nanstd(three_day_seq(idx).tod_poc_05);
      three_day_seq(idx).tod_poc_06_stdv = nanstd(three_day_seq(idx).tod_poc_06);
      three_day_seq(idx).tod_poc_07_stdv = nanstd(three_day_seq(idx).tod_poc_07);
      
      % CV
      three_day_seq(idx).tod_chlor_a_00_CV = three_day_seq(idx).tod_chlor_a_00_stdv/three_day_seq(idx).tod_chlor_a_00_mean;
      three_day_seq(idx).tod_chlor_a_01_CV = three_day_seq(idx).tod_chlor_a_01_stdv/three_day_seq(idx).tod_chlor_a_01_mean;
      three_day_seq(idx).tod_chlor_a_02_CV = three_day_seq(idx).tod_chlor_a_02_stdv/three_day_seq(idx).tod_chlor_a_02_mean;
      three_day_seq(idx).tod_chlor_a_03_CV = three_day_seq(idx).tod_chlor_a_03_stdv/three_day_seq(idx).tod_chlor_a_03_mean;
      three_day_seq(idx).tod_chlor_a_04_CV = three_day_seq(idx).tod_chlor_a_04_stdv/three_day_seq(idx).tod_chlor_a_04_mean;
      three_day_seq(idx).tod_chlor_a_05_CV = three_day_seq(idx).tod_chlor_a_05_stdv/three_day_seq(idx).tod_chlor_a_05_mean;
      three_day_seq(idx).tod_chlor_a_06_CV = three_day_seq(idx).tod_chlor_a_06_stdv/three_day_seq(idx).tod_chlor_a_06_mean;
      three_day_seq(idx).tod_chlor_a_07_CV = three_day_seq(idx).tod_chlor_a_07_stdv/three_day_seq(idx).tod_chlor_a_07_mean;
      
      three_day_seq(idx).tod_ag_412_mlrc_00_CV = three_day_seq(idx).tod_ag_412_mlrc_00_stdv/three_day_seq(idx).tod_ag_412_mlrc_00_mean;
      three_day_seq(idx).tod_ag_412_mlrc_01_CV = three_day_seq(idx).tod_ag_412_mlrc_01_stdv/three_day_seq(idx).tod_ag_412_mlrc_01_mean;
      three_day_seq(idx).tod_ag_412_mlrc_02_CV = three_day_seq(idx).tod_ag_412_mlrc_02_stdv/three_day_seq(idx).tod_ag_412_mlrc_02_mean;
      three_day_seq(idx).tod_ag_412_mlrc_03_CV = three_day_seq(idx).tod_ag_412_mlrc_03_stdv/three_day_seq(idx).tod_ag_412_mlrc_03_mean;
      three_day_seq(idx).tod_ag_412_mlrc_04_CV = three_day_seq(idx).tod_ag_412_mlrc_04_stdv/three_day_seq(idx).tod_ag_412_mlrc_04_mean;
      three_day_seq(idx).tod_ag_412_mlrc_05_CV = three_day_seq(idx).tod_ag_412_mlrc_05_stdv/three_day_seq(idx).tod_ag_412_mlrc_05_mean;
      three_day_seq(idx).tod_ag_412_mlrc_06_CV = three_day_seq(idx).tod_ag_412_mlrc_06_stdv/three_day_seq(idx).tod_ag_412_mlrc_06_mean;
      three_day_seq(idx).tod_ag_412_mlrc_07_CV = three_day_seq(idx).tod_ag_412_mlrc_07_stdv/three_day_seq(idx).tod_ag_412_mlrc_07_mean;
      
      three_day_seq(idx).tod_poc_00_CV = three_day_seq(idx).tod_poc_00_stdv/three_day_seq(idx).tod_poc_00_mean;
      three_day_seq(idx).tod_poc_01_CV = three_day_seq(idx).tod_poc_01_stdv/three_day_seq(idx).tod_poc_01_mean;
      three_day_seq(idx).tod_poc_02_CV = three_day_seq(idx).tod_poc_02_stdv/three_day_seq(idx).tod_poc_02_mean;
      three_day_seq(idx).tod_poc_03_CV = three_day_seq(idx).tod_poc_03_stdv/three_day_seq(idx).tod_poc_03_mean;
      three_day_seq(idx).tod_poc_04_CV = three_day_seq(idx).tod_poc_04_stdv/three_day_seq(idx).tod_poc_04_mean;
      three_day_seq(idx).tod_poc_05_CV = three_day_seq(idx).tod_poc_05_stdv/three_day_seq(idx).tod_poc_05_mean;
      three_day_seq(idx).tod_poc_06_CV = three_day_seq(idx).tod_poc_06_stdv/three_day_seq(idx).tod_poc_06_mean;
      three_day_seq(idx).tod_poc_07_CV = three_day_seq(idx).tod_poc_07_stdv/three_day_seq(idx).tod_poc_07_mean;
      
      
end

fs = 30;
lw = 1.5;
ms = 16;

% chlor_a
h = figure('Color','white','DefaultAxesFontSize',fs);
plot(0,100*nanmean([three_day_seq.tod_chlor_a_00_CV]),'-or','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_chlor_a_01_CV]),'-og','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_chlor_a_02_CV]),'-ob','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_chlor_a_03_CV]),'-ok','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_chlor_a_04_CV]),'-oc','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_chlor_a_05_CV]),'-om','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_chlor_a_06_CV]),'-o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_chlor_a_07_CV]),'-o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% ax = gca;
% ax.YLim(1) = 0 ;
%
% grid on

% ylabel('Mean of CV for Chlor-{\ita} [%]','FontSize',fs)
% xlabel('Time of the day','FontSize',fs)

% xlim([-1 8])
% ax = gca;
% ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

% ag_410_mlrc
plot(0,100*nanmean([three_day_seq.tod_ag_412_mlrc_00_CV]),'-^r','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_ag_412_mlrc_01_CV]),'-^g','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_ag_412_mlrc_02_CV]),'-^b','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_ag_412_mlrc_03_CV]),'-^k','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_ag_412_mlrc_04_CV]),'-^c','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_ag_412_mlrc_05_CV]),'-^m','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_ag_412_mlrc_06_CV]),'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_ag_412_mlrc_07_CV]),'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

% grid on

% ylabel('Mean of CV for a_{g}(412) [%]','FontSize',fs)
% xlabel('Time of the day','FontSize',fs)

% ax = gca;
% ax.YLim(1) = 0 ;
% grid on
% xlim([-1 8])
% ax = gca;
% ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

% poc
plot(0,100*nanmean([three_day_seq.tod_poc_00_CV]),'-*r','MarkerSize',ms,'LineWidth',lw)
hold on
plot(1,100*nanmean([three_day_seq.tod_poc_01_CV]),'-*g','MarkerSize',ms,'LineWidth',lw)
plot(2,100*nanmean([three_day_seq.tod_poc_02_CV]),'-*b','MarkerSize',ms,'LineWidth',lw)
plot(3,100*nanmean([three_day_seq.tod_poc_03_CV]),'-*k','MarkerSize',ms,'LineWidth',lw)
plot(4,100*nanmean([three_day_seq.tod_poc_04_CV]),'-*c','MarkerSize',ms,'LineWidth',lw)
plot(5,100*nanmean([three_day_seq.tod_poc_05_CV]),'-*m','MarkerSize',ms,'LineWidth',lw)
plot(6,100*nanmean([three_day_seq.tod_poc_06_CV]),'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
plot(7,100*nanmean([three_day_seq.tod_poc_07_CV]),'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

grid on
ylabel('Mean of CV [%]','FontSize',fs)
xlabel('Time of the day','FontSize',fs)

ax = gca;
ax.YLim(1) = 0 ;
grid on
xlim([-1 8])
ax = gca;
ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

hleg = legend('Chlor-{\ita}: 0h','Chlor-{\ita}: 1h','Chlor-{\ita}: 2h','Chlor-{\ita}: 3h','Chlor-{\ita}: 4h','Chlor-{\ita}: 5h','Chlor-{\ita}: 6h','Chlor-{\ita}: 7h',...
      'a_{g}(412): 0h','a_{g}(412): 1h','a_{g}(412): 2h','a_{g}(412): 3h','a_{g}(412): 4h','a_{g}(412): 5h','a_{g}(412): 6h','a_{g}(412): 7h',...
      'POC: 0h','POC: 1h','POC: 2h','POC: 3h','POC: 4h','POC: 5h','POC: 6h','POC: 7h',...
      'Location','northeastoutside');
set(hleg,'fontsize',22)

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

%% mean and st dev
% chlor_a
h = figure('Color','white','DefaultAxesFontSize',fs);
errorbar(0,nanmean([three_day_seq.tod_chlor_a_00_mean]),nanmean([three_day_seq.tod_chlor_a_00_stdv]),'-or','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,nanmean([three_day_seq.tod_chlor_a_01_mean]),nanmean([three_day_seq.tod_chlor_a_01_stdv]),'-og','MarkerSize',ms,'LineWidth',lw)
errorbar(2,nanmean([three_day_seq.tod_chlor_a_02_mean]),nanmean([three_day_seq.tod_chlor_a_02_stdv]),'-ob','MarkerSize',ms,'LineWidth',lw)
errorbar(3,nanmean([three_day_seq.tod_chlor_a_03_mean]),nanmean([three_day_seq.tod_chlor_a_03_stdv]),'-ok','MarkerSize',ms,'LineWidth',lw)
errorbar(4,nanmean([three_day_seq.tod_chlor_a_04_mean]),nanmean([three_day_seq.tod_chlor_a_04_stdv]),'-oc','MarkerSize',ms,'LineWidth',lw)
errorbar(5,nanmean([three_day_seq.tod_chlor_a_05_mean]),nanmean([three_day_seq.tod_chlor_a_05_stdv]),'-om','MarkerSize',ms,'LineWidth',lw)
errorbar(6,nanmean([three_day_seq.tod_chlor_a_06_mean]),nanmean([three_day_seq.tod_chlor_a_06_stdv]),'-o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,nanmean([three_day_seq.tod_chlor_a_07_mean]),nanmean([three_day_seq.tod_chlor_a_07_stdv]),'-o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)



ylabel('Mean Chlor-{\ita} [mg m^{-3}]','FontSize',fs)
xlabel('Time of the day','FontSize',fs)

ax = gca;
ax.YLim(1) = 0 ;
grid on
xlim([-1 8])
ax = gca;
ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

hleg = legend('Chlor-{\ita}: 0h','Chlor-{\ita}: 1h','Chlor-{\ita}: 2h','Chlor-{\ita}: 3h','Chlor-{\ita}: 4h','Chlor-{\ita}: 5h','Chlor-{\ita}: 6h','Chlor-{\ita}: 7h',...
      'Location','southeast');
set(hleg,'fontsize',22)

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% ag_412_mlrc
h = figure('Color','white','DefaultAxesFontSize',fs);
errorbar(0,nanmean([three_day_seq.tod_ag_412_mlrc_00_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_00_stdv]),'-^r','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,nanmean([three_day_seq.tod_ag_412_mlrc_01_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_01_stdv]),'-^g','MarkerSize',ms,'LineWidth',lw)
errorbar(2,nanmean([three_day_seq.tod_ag_412_mlrc_02_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_02_stdv]),'-^b','MarkerSize',ms,'LineWidth',lw)
errorbar(3,nanmean([three_day_seq.tod_ag_412_mlrc_03_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_03_stdv]),'-^k','MarkerSize',ms,'LineWidth',lw)
errorbar(4,nanmean([three_day_seq.tod_ag_412_mlrc_04_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_04_stdv]),'-^c','MarkerSize',ms,'LineWidth',lw)
errorbar(5,nanmean([three_day_seq.tod_ag_412_mlrc_05_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_05_stdv]),'-^m','MarkerSize',ms,'LineWidth',lw)
errorbar(6,nanmean([three_day_seq.tod_ag_412_mlrc_06_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_06_stdv]),'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,nanmean([three_day_seq.tod_ag_412_mlrc_07_mean]),nanmean([three_day_seq.tod_ag_412_mlrc_07_stdv]),'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

ylabel('Mean a_{g}(412) [m^{-1}]','FontSize',fs)
xlabel('Time of the day','FontSize',fs)

ax = gca;
ax.YLim(1) = 0 ;
grid on
xlim([-1 8])
ax = gca;
ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

hleg = legend('a_{g}(412): 0h','a_{g}(412): 1h','a_{g}(412): 2h','a_{g}(412): 3h','a_{g}(412): 4h','a_{g}(412): 5h','a_{g}(412): 6h','a_{g}(412): 7h',...
      'Location','southeast');
set(hleg,'fontsize',22)

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% poc
h = figure('Color','white','DefaultAxesFontSize',fs);
errorbar(0,nanmean([three_day_seq.tod_poc_00_mean]),nanmean([three_day_seq.tod_poc_00_stdv]),'-*r','MarkerSize',ms,'LineWidth',lw)
hold on
errorbar(1,nanmean([three_day_seq.tod_poc_01_mean]),nanmean([three_day_seq.tod_poc_01_stdv]),'-*g','MarkerSize',ms,'LineWidth',lw)
errorbar(2,nanmean([three_day_seq.tod_poc_02_mean]),nanmean([three_day_seq.tod_poc_02_stdv]),'-*b','MarkerSize',ms,'LineWidth',lw)
errorbar(3,nanmean([three_day_seq.tod_poc_03_mean]),nanmean([three_day_seq.tod_poc_03_stdv]),'-*k','MarkerSize',ms,'LineWidth',lw)
errorbar(4,nanmean([three_day_seq.tod_poc_04_mean]),nanmean([three_day_seq.tod_poc_04_stdv]),'-*c','MarkerSize',ms,'LineWidth',lw)
errorbar(5,nanmean([three_day_seq.tod_poc_05_mean]),nanmean([three_day_seq.tod_poc_05_stdv]),'-*m','MarkerSize',ms,'LineWidth',lw)
errorbar(6,nanmean([three_day_seq.tod_poc_06_mean]),nanmean([three_day_seq.tod_poc_06_stdv]),'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
errorbar(7,nanmean([three_day_seq.tod_poc_07_mean]),nanmean([three_day_seq.tod_poc_07_stdv]),'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

grid on
ylabel('Mean POC [mg m^{-3}]','FontSize',fs)
xlabel('Time of the day','FontSize',fs)

hleg = legend('POC: 0h','POC: 1h','POC: 2h','POC: 3h','POC: 4h','POC: 5h','POC: 6h','POC: 7h',...
      'Location','southeast');
set(hleg,'fontsize',22)

ax = gca;
ax.YLim(1) = 0 ;
grid on
xlim([-1 8])
ax = gca;
ax.XTickLabel = {'','0h','1h','2h','3h','4h','5h','6h','7h',''};

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
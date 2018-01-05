%% In Situ data from the KORUS-OC 2016
cd '/Users/jconchas/Documents/Research/GOCI/GOCI_KORUS';

%%

L2sdata = load('1614106_L2s.mat'); % file from Ivona

ES = L2sdata.L2sdata.ES_hyperspectral_data';
LT = L2sdata.L2sdata.LT_hyperspectral_data';
LI = L2sdata.L2sdata.LI_hyperspectral_data';
a = L2sdata.L2sdata.ES_hyperspectral_fields;
WL = cellfun(@(x)str2double(x), a);

LAT = L2sdata.L2sdata.LATPOS_data;
LON = L2sdata.L2sdata.LONPOS_data;

Rrs = (LT-0.028*LI)./(ES);
cond1 = WL>400&WL<700;
% cond1 = cond1';

fs = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,2,1)
plot(WL(cond1),ES(cond1,:))
title('ES')
grid on

subplot(2,2,2)
plot(WL(cond1),LT(cond1,:))
title('LT')
grid on

subplot(2,2,3)
plot(WL(cond1),LI(cond1,:))
title('LI')
xlabel('Wavelength (nm)')
grid on

subplot(2,2,4)
plot(WL(cond1),Rrs(cond1,:))
title('Rrs')
xlabel('Wavelength (nm)')
grid on
%%
% Plot GOCI footprint
figure('Color','white')
hf2 = gcf;
ax = worldmap('World');
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')

figure(hf2)
hold on
plotm(LAT./100,LON./100,'r*')

%% plot time


ALL_time = datetime(L2sdata.L2sdata.ALL_time,'ConvertFrom','datenum');
AZIMUTH_data = L2sdata.L2sdata.AZIMUTH_data;
ELEVATION_data = L2sdata.L2sdata.ELEVATION_data;
HEADING_data = L2sdata.L2sdata.HEADING_data;
PITCH_data = L2sdata.L2sdata.PITCH_data;
ROLL_data = L2sdata.L2sdata.ROLL_data;
COURSE_data = L2sdata.L2sdata.COURSE_data;
MAGVAR_data = L2sdata.L2sdata.MAGVAR_data;
SPEED_data = L2sdata.L2sdata.SPEED_data;

fs = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,4,1)
plot(ALL_time,AZIMUTH_data)
title('AZIMUTH')

subplot(2,4,2)
plot(ALL_time,ELEVATION_data)
title('ELEVATION')

subplot(2,4,3)
plot(ALL_time,HEADING_data)
title('HEADING')

subplot(2,4,4)
plot(ALL_time,PITCH_data)
title('PITCH')

subplot(2,4,5)
plot(ALL_time,ROLL_data)
title('ROLL')

subplot(2,4,6)
plot(ALL_time,COURSE_data)
title('COURSE')

subplot(2,4,7)
plot(ALL_time,MAGVAR_data)
title('MAGVAR')

subplot(2,4,8)
plot(ALL_time,SPEED_data)
title('SPEED')

%% load GOCI RSRs
filename = '/Users/jconchas/Documents/Research/GOCI/GOCI_KORUS/goci_RSR/GOCI_RSRs.txt';
RSR_Mat = load(filename);

RSR_wave = RSR_Mat(:,1);
RSR_412 = RSR_Mat(:,2);
RSR_443 = RSR_Mat(:,3);
RSR_490 = RSR_Mat(:,4);
RSR_555 = RSR_Mat(:,5);
RSR_660 = RSR_Mat(:,6);
RSR_680 = RSR_Mat(:,7);
RSR_745 = RSR_Mat(:,8);
RSR_865 = RSR_Mat(:,9);

clear RSR_Mat

fs = 14;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot(RSR_wave,RSR_412,'c'), hold on
plot(RSR_wave,RSR_443,'b')
plot(RSR_wave,RSR_490,'b')
plot(RSR_wave,RSR_555,'g')
plot(RSR_wave,RSR_660,'r')
plot(RSR_wave,RSR_680,'m')
plot(RSR_wave,RSR_745,'k')
plot(RSR_wave,RSR_865,'k')
ylabel('RSR')
xlabel('wavelength [nm]')

%% Read CSV data
% ASD from Wonkook
clear  KORUS_InSitu Rrs

KORUS_ASD_rrs_ON = csvread('/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_ASD_rrs_ON.csv',...
      1,1);
% reading station names
filename = '/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_ASD_station_ON.csv';
fileID = fopen(filename);
C = textscan(fileID,'%s');
fclose(fileID);

Rrs = KORUS_ASD_rrs_ON(:,10:end);
wl = 350:900;

count = 0;

% figure
% plot(wl,Rrs)

for idx = 1:size(Rrs,1)
      count = count + 1;
      KORUS_InSitu(count).instrument = 'ASD';
      KORUS_InSitu(count).station = char(C{1}(idx));
      KORUS_InSitu(count).datetime = datetime(...
            KORUS_ASD_rrs_ON(idx,1),...
            KORUS_ASD_rrs_ON(idx,2),...
            KORUS_ASD_rrs_ON(idx,3),...
            KORUS_ASD_rrs_ON(idx,4),...
            KORUS_ASD_rrs_ON(idx,5),...
            KORUS_ASD_rrs_ON(idx,6));
      KORUS_InSitu(count).date = datetime(...
            KORUS_ASD_rrs_ON(idx,1),...
            KORUS_ASD_rrs_ON(idx,2),...
            KORUS_ASD_rrs_ON(idx,3),...
            KORUS_ASD_rrs_ON(idx,4),...
            KORUS_ASD_rrs_ON(idx,5),...
            KORUS_ASD_rrs_ON(idx,6),...
            'Format','yyyyMMdd'); 
      KORUS_InSitu(count).lat = KORUS_ASD_rrs_ON(idx,7);
      KORUS_InSitu(count).lon = KORUS_ASD_rrs_ON(idx,8);
      KORUS_InSitu(count).Rrs = Rrs(idx,:);
      KORUS_InSitu(count).wavelength = wl;
      reflec_resp = spect_sampGOCI(KORUS_InSitu(count).wavelength,KORUS_InSitu(count).Rrs);
      KORUS_InSitu(count).Rrs_412 = reflec_resp(1);
      KORUS_InSitu(count).Rrs_443 = reflec_resp(2);
      KORUS_InSitu(count).Rrs_490 = reflec_resp(3);
      KORUS_InSitu(count).Rrs_555 = reflec_resp(4);
      KORUS_InSitu(count).Rrs_660 = reflec_resp(5);
      KORUS_InSitu(count).Rrs_680 = reflec_resp(6);
      KORUS_InSitu(count).Rrs_745 = reflec_resp(7);
      KORUS_InSitu(count).Rrs_865 = reflec_resp(8);
end

clear KORUS_ASD_rrs_ON fileID filename C wl Rrs idx

% TriOS from Wonkook
clear  Rrs
KORUS_TriOS_rrs_ON = csvread('/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_TriOS_rrs_ON.csv',...
      1,1);
% reading station names
filename = '/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_TriOS_station_ON.csv';
fileID = fopen(filename);
C = textscan(fileID,'%s');
fclose(fileID);
Rrs = KORUS_TriOS_rrs_ON(:,10:end);
wl = 350:900;

% figure
% plot(wl,Rrs)

for idx = 1:size(Rrs,1)
      count = count + 1;
      KORUS_InSitu(count).instrument = 'TriOS';
      KORUS_InSitu(count).station = char(C{1}(idx));
      KORUS_InSitu(count).datetime = datetime(...
            KORUS_TriOS_rrs_ON(idx,1),...
            KORUS_TriOS_rrs_ON(idx,2),...
            KORUS_TriOS_rrs_ON(idx,3),...
            KORUS_TriOS_rrs_ON(idx,4),...
            KORUS_TriOS_rrs_ON(idx,5),...
            KORUS_TriOS_rrs_ON(idx,6));
      KORUS_InSitu(count).date = datetime(...
            KORUS_TriOS_rrs_ON(idx,1),...
            KORUS_TriOS_rrs_ON(idx,2),...
            KORUS_TriOS_rrs_ON(idx,3),...
            KORUS_TriOS_rrs_ON(idx,4),...
            KORUS_TriOS_rrs_ON(idx,5),...
            KORUS_TriOS_rrs_ON(idx,6),...
            'Format','yyyyMMdd'); 
      KORUS_InSitu(count).lat = KORUS_TriOS_rrs_ON(idx,7);
      KORUS_InSitu(count).lon = KORUS_TriOS_rrs_ON(idx,8);
      KORUS_InSitu(count).Rrs = Rrs(idx,:);
      KORUS_InSitu(count).wavelength = wl;
      reflec_resp = spect_sampGOCI(KORUS_InSitu(count).wavelength,KORUS_InSitu(count).Rrs);
      KORUS_InSitu(count).Rrs_412 = reflec_resp(1);
      KORUS_InSitu(count).Rrs_443 = reflec_resp(2);
      KORUS_InSitu(count).Rrs_490 = reflec_resp(3);
      KORUS_InSitu(count).Rrs_555 = reflec_resp(4);
      KORUS_InSitu(count).Rrs_660 = reflec_resp(5);
      KORUS_InSitu(count).Rrs_680 = reflec_resp(6);
      KORUS_InSitu(count).Rrs_745 = reflec_resp(7);
      KORUS_InSitu(count).Rrs_865 = reflec_resp(8);      
end

clear KORUS_TriOS_rrs_ON fileID filename C wl Rrs idx count reflec_resp

reflec_resp = spect_sampGOCI(KORUS_InSitu(end).wavelength,KORUS_InSitu(end).Rrs);
 
figure
plot(KORUS_InSitu(end).wavelength,KORUS_InSitu(end).Rrs), hold on
plot([412 443 490 555 660 680 745 865],reflec_resp,'*')

%% Plot Location
figure('Color','white')
ax = worldmap([30 45],[116 136]);
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
plotm(cell2mat({KORUS_InSitu.lat}'),cell2mat({KORUS_InSitu.lon}'),'*r')
%% dates for both instruments
[[KORUS_InSitu.datetime]';[KORUS_InSitu.datetime]']

%% Load GOCI data
clear GOCI_Data
tic
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_KORUS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'GOCI';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading GOCI Data')
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_KORUS/' s{1}{idx0}];
      GOCI_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc
%% Time series Rrs
h1 =  figure('Color','white','DefaultAxesFontSize',fs);

total_px_GOCI = GOCI_Data(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
ratio_from_the_total = 2; % 2 3 4 % half or third or fourth of the total of pixels
solz_lim = 75;
senz_lim = 60;
CV_lim = 0.15;

xrange = 0.02;
% startDate = datenum('01-01-2011');
startDate = datenum('05-15-2011');
endDate = datenum('01-01-2017');
xData = startDate:datenum(years(1)):endDate;

lw = 2;
fs = 25;
ms = 5;

% Rrs_412
cond_nan = ~isnan([GOCI_Data.Rrs_412_filtered_mean]);
cond_area = [GOCI_Data.Rrs_412_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV] <= CV_lim;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV;

data_used = [GOCI_Data.Rrs_412_filtered_mean];
data_used = data_used(cond_used);


figure(h1)
subplot(6,1,1)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'*','MarkerSize',ms,'LineWidth',lw)
% ax = gca;  
% ax.XTick = xData;
% datetick('x','yyyy')
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(412)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used);
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
cond_nan = ~isnan([GOCI_Data.Rrs_443_filtered_mean]);
cond_area = [GOCI_Data.Rrs_443_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV] <= CV_lim;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV;

data_used = [GOCI_Data.Rrs_443_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,2)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'*','MarkerSize',ms,'LineWidth',lw)
% ax = gca;  
% ax.XTick = xData;
% datetick('x','yyyy')
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(443)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used);
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
cond_nan = ~isnan([GOCI_Data.Rrs_490_filtered_mean]);
cond_area = [GOCI_Data.Rrs_490_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV] <= CV_lim;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV;

data_used = [GOCI_Data.Rrs_490_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,3)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'*','MarkerSize',ms,'LineWidth',lw)
% ax = gca;  
% ax.XTick = xData;
% datetick('x','yyyy')
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(490)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used);
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
cond_nan = ~isnan([GOCI_Data.Rrs_555_filtered_mean]);
cond_area = [GOCI_Data.Rrs_555_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV] <= CV_lim;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV;

data_used = [GOCI_Data.Rrs_555_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,4)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'*','MarkerSize',ms,'LineWidth',lw)
% ax = gca;  
% ax.XTick = xData;
% datetick('x','yyyy')
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(555)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used);
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
cond_nan = ~isnan([GOCI_Data.Rrs_660_filtered_mean]);
cond_area = [GOCI_Data.Rrs_660_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV] <= CV_lim;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV;

data_used = [GOCI_Data.Rrs_660_filtered_mean];
data_used = data_used(cond_used);

figure(h1)
subplot(6,1,5)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'*','MarkerSize',ms,'LineWidth',lw)
% ax = gca;  
% ax.XTick = xData;
% datetick('x','yyyy')
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(660)','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used);
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
cond_nan = ~isnan([GOCI_Data.Rrs_680_filtered_mean]);
cond_area = [GOCI_Data.Rrs_680_filtered_valid_pixel_count]>= total_px_GOCI/ratio_from_the_total;
cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
cond_CV = [GOCI_Data.median_CV] <= CV_lim;
cond_used = cond_nan&cond_area&cond_solz&cond_senz&cond_CV;

data_used = [GOCI_Data.Rrs_680_filtered_mean];
data_used = data_used(cond_used);


figure(h1)
subplot(6,1,6)
x_data = [GOCI_Data.datetime];
x_data = x_data(cond_used);
plot(x_data,data_used,'*','MarkerSize',ms,'LineWidth',lw)
% ax = gca;  
% ax.XTick = xData;
% datetick('x','yyyy')%
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'))
% set(gca,'XTickLabel',{' '})
ylabel('R_{rs}(680)','FontSize',fs)
xlabel('Time','FontSize',fs)
grid on

N = nansum(cond_used);
% fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
[counts,centers] = hist(data_used);
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

%% InSitu vs Sat
% InSituBands =[412,443,490,555,665,681]; or 678
% GOCIbands =  [412,443,490,555,660,680,745,865];
%               2   4   7   11  12  17  N/A N/A
%               1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17 
% wavelength = [410,412,413,443,486,488,490,531,547,551,555,665,667,670,671,678,681];
          
clear Matchup

for idx1=1:size(KORUS_InSitu,2)
      
      Matchup(idx1).datetime_ins = KORUS_InSitu(idx1).datetime;
      Matchup(idx1).instrument_ins = KORUS_InSitu(idx1).instrument;
      
      % Rrs_412
      
      Matchup(idx1).Rrs_412_ins = KORUS_InSitu(idx1).Rrs_412;
      cond_enough = [GOCI_Data.Rrs_412_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      cond_pos = [GOCI_Data.Rrs_412_filtered_mean] >0;
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;
      [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond_used); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_412_sat = GOCI_Data(IdxOrig(idx_aux)).Rrs_412_filtered_mean;
      else
            Matchup(idx1).Rrs_412_sat = NaN;
      end   
      Matchup(idx1).Rrs_412_sat_datetime = GOCI_Data(IdxOrig(idx_aux)).datetime;        
      Matchup(idx1).Rrs_412_t_diff = t_diff;

      % Rrs_443
      
      Matchup(idx1).Rrs_443_ins = KORUS_InSitu(idx1).Rrs_443;
      cond_enough = [GOCI_Data.Rrs_443_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      cond_pos = [GOCI_Data.Rrs_443_filtered_mean] >0;
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;      
      [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond_used); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_443_sat = GOCI_Data(IdxOrig(idx_aux)).Rrs_443_filtered_mean;
      else
            Matchup(idx1).Rrs_443_sat = NaN;
      end   
      Matchup(idx1).Rrs_443_sat_datetime = GOCI_Data(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_443_t_diff = t_diff;

       % Rrs_490

      Matchup(idx1).Rrs_490_ins = KORUS_InSitu(idx1).Rrs_490;
      cond_enough = [GOCI_Data.Rrs_490_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      cond_pos = [GOCI_Data.Rrs_490_filtered_mean] >0;
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;      
      [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond_used); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_490_sat = GOCI_Data(IdxOrig(idx_aux)).Rrs_490_filtered_mean;
      else
            Matchup(idx1).Rrs_490_sat = NaN;
      end   
      Matchup(idx1).Rrs_490_sat_datetime = GOCI_Data(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_490_t_diff = t_diff;

      % Rrs_555
      
      Matchup(idx1).Rrs_555_ins = KORUS_InSitu(idx1).Rrs_555;
      cond_enough = [GOCI_Data.Rrs_555_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      cond_pos = [GOCI_Data.Rrs_555_filtered_mean] >0;
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;      
      [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond_used); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_555_sat = GOCI_Data(IdxOrig(idx_aux)).Rrs_555_filtered_mean;
      else
            Matchup(idx1).Rrs_555_sat = NaN;
      end   
      Matchup(idx1).Rrs_555_sat_datetime = GOCI_Data(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_555_t_diff = t_diff;

      % Rrs_660
      
      Matchup(idx1).Rrs_665_ins = KORUS_InSitu(idx1).Rrs_660;
      cond_enough = [GOCI_Data.Rrs_660_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      cond_pos = [GOCI_Data.Rrs_660_filtered_mean] >0;
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;      
      [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond_used); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_660_sat = GOCI_Data(IdxOrig(idx_aux)).Rrs_660_filtered_mean;
      else
            Matchup(idx1).Rrs_660_sat = NaN;
      end   
      Matchup(idx1).Rrs_660_sat_datetime = GOCI_Data(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_660_t_diff = t_diff;

      % Rrs_680
      % For in situ @ 678 nm
      Matchup(idx1).Rrs_678_ins = KORUS_InSitu(idx1).Rrs_680;
      cond_enough = [GOCI_Data.Rrs_680_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      cond_pos = [GOCI_Data.Rrs_680_filtered_mean] >0;
      cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;      
      [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond_used); % to convert to the original matrix

      % % For in situ @ 681 nm
      % Matchup(idx1).Rrs_681_ins = KORUS_InSitu(idx1).Rrs(17);
      % cond_enough = [GOCI_Data.Rrs_680_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 7x7 window?     
      % cond_pos = [GOCI_Data.Rrs_412_filtered_mean] >0;% 
      % cond_solz = [GOCI_Data.solz_center_value] <= solz_lim;
      % cond_senz = [GOCI_Data.senz_center_value] <= senz_lim;
      % cond_median_CV = [GOCI_Data.median_CV] <= CV_lim;
      % cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV;    % % 
      % % [t_diff,idx_aux] = min(abs([GOCI_Data(cond_used).datetime]-[KORUS_InSitu(idx1).datetime])); % index to cond1 but not to the original matrix
      % IdxOrig = find(cond_used); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_680_sat = GOCI_Data(IdxOrig(idx_aux)).Rrs_680_filtered_mean;
      else
            Matchup(idx1).Rrs_680_sat = NaN;
      end         
      Matchup(idx1).Rrs_680_sat_datetime = GOCI_Data(IdxOrig(idx_aux)).datetime;        
      Matchup(idx1).Rrs_680_t_diff = t_diff;

end
%%

% latex table
!rm ./MyTable.tex
FID = fopen('./MyTable.tex','w');

fprintf(FID,'\\begin{tabular}{ccccccccccccc} \n \\hline \n');

fprintf(FID, 'Sat (nm) ');
fprintf(FID, '& InSitu (nm) ');
fprintf(FID, '& $R^2$ ');
fprintf(FID, '& Regression ');
fprintf(FID, '& RMSE ');
fprintf(FID, '& N ');
fprintf(FID, '& Mean APD ($\\%%$) ');
fprintf(FID, '& St.Dev. APD ($\\%%$) ');
fprintf(FID, '& Median APD ($\\%%$) ');
fprintf(FID, '& Bias ($\\%%$) ');
fprintf(FID, '& Median ratio ');
fprintf(FID, '& SIQR ');
fprintf(FID, '& rsqcorr ');
fprintf(FID,'\\\\ \\hline \n');

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],1,FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_412'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],1,FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_443'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],1,FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_490'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],1,FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_555'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],1,FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_660'],'epsc')

% latex table
fprintf(FID,'\\hline \n');
fprintf(FID,'\\end{tabular}\n');
% no data for in situ 678 or 681
% [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('678','680',[Matchup.Rrs_678_ins],[Matchup.Rrs_680_sat]);
% [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('681','680',[Matchup.Rrs_681_ins],[Matchup.Rrs_680_sat]);

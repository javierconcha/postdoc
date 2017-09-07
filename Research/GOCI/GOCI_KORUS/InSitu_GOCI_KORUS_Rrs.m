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
% ASD 
clear  KORUS_ASD Rrs

KORUS_ASD_rrs_ON = csvread('/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_ASD_rrs_ON.csv',...
      1,1);
% reading station names
filename = '/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_ASD_station_ON.csv';
fileID = fopen(filename);
C = textscan(fileID,'%s');
fclose(fileID);

Rrs = KORUS_ASD_rrs_ON(:,10:end);
wl = 350:900;

% figure
% plot(wl,Rrs)

for idx = 1:size(Rrs,1)
      KORUS_ASD(idx).station = char(C{1}(idx));
      KORUS_ASD(idx).datetime = datetime(...
            KORUS_ASD_rrs_ON(idx,1),...
            KORUS_ASD_rrs_ON(idx,2),...
            KORUS_ASD_rrs_ON(idx,3),...
            KORUS_ASD_rrs_ON(idx,4),...
            KORUS_ASD_rrs_ON(idx,5),...
            KORUS_ASD_rrs_ON(idx,6));
      KORUS_ASD(idx).date = datetime(...
            KORUS_ASD_rrs_ON(idx,1),...
            KORUS_ASD_rrs_ON(idx,2),...
            KORUS_ASD_rrs_ON(idx,3),...
            KORUS_ASD_rrs_ON(idx,4),...
            KORUS_ASD_rrs_ON(idx,5),...
            KORUS_ASD_rrs_ON(idx,6),...
            'Format','yyyyMMdd'); 
      KORUS_ASD(idx).lat = KORUS_ASD_rrs_ON(idx,7);
      KORUS_ASD(idx).lon = KORUS_ASD_rrs_ON(idx,8);
      KORUS_ASD(idx).Rrs = Rrs(idx,:);
      KORUS_ASD(idx).wavelength = wl;
end

clear KORUS_ASD_rrs_ON fileID filename C wl Rrs idx

figure
plot(KORUS_ASD(1).wavelength,KORUS_ASD(1).Rrs)
%% TriOS
clear  KORUS_TRiOS Rrs
KORUS_TRiOS_rrs_ON = csvread('/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_TRiOS_rrs_ON.csv',...
      1,1);
% reading station names
filename = '/Users/jconchas/Documents/Research/InSituData/2017_KORUSOC/KORUS_TRiOS_station_ON.csv';
fileID = fopen(filename);
C = textscan(fileID,'%s');
fclose(fileID);
Rrs = KORUS_TRiOS_rrs_ON(:,10:end);
wl = 350:900;

% figure
% plot(wl,Rrs)

for idx = 1:size(Rrs,1)
      KORUS_TRiOS(idx).station = char(C{1}(idx));
      KORUS_TRiOS(idx).datetime = datetime(...
            KORUS_TRiOS_rrs_ON(idx,1),...
            KORUS_TRiOS_rrs_ON(idx,2),...
            KORUS_TRiOS_rrs_ON(idx,3),...
            KORUS_TRiOS_rrs_ON(idx,4),...
            KORUS_TRiOS_rrs_ON(idx,5),...
            KORUS_TRiOS_rrs_ON(idx,6));
      KORUS_TRiOS(idx).date = datetime(...
            KORUS_TRiOS_rrs_ON(idx,1),...
            KORUS_TRiOS_rrs_ON(idx,2),...
            KORUS_TRiOS_rrs_ON(idx,3),...
            KORUS_TRiOS_rrs_ON(idx,4),...
            KORUS_TRiOS_rrs_ON(idx,5),...
            KORUS_TRiOS_rrs_ON(idx,6),...
            'Format','yyyyMMdd'); 
      KORUS_TRiOS(idx).lat = KORUS_TRiOS_rrs_ON(idx,7);
      KORUS_TRiOS(idx).lon = KORUS_TRiOS_rrs_ON(idx,8);
      KORUS_TRiOS(idx).Rrs = Rrs(idx,:);
      KORUS_TRiOS(idx).wavelength = wl;
end

clear KORUS_TRiOS_rrs_ON fileID filename C wl Rrs idx

figure
plot(KORUS_TRiOS(1).wavelength,KORUS_TRiOS(1).Rrs)
%% dates for both instruments
[[KORUS_ASD.datetime]';[KORUS_TRiOS.datetime]']



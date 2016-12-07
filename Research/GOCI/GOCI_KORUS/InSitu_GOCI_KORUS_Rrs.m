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



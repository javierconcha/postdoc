addpath('/Users/jconchas/Documents/Research/')

%% Open file 
dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Dec2010/archive/ag/';
filename = 'KR_20101130_stleodo_0m.txt';
filepath = [dirname filename];
      
[data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);

figure
hf1 = gcf;


%% Plot GOCI footprint
figure('Color','white')
hf2 = gcf;
ax = worldmap([30 45],[116 136]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
%%
figure(hf1)
plot(data.wavelength,data.ag);
grid on

figure(hf2)
hold on
plotm(sbHeader.north_latitude,sbHeader.east_longitude,'*r')


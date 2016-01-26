
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/LC80720212014209LGN00';
filename = 'LC80720212014209LGN00_L2test.nc';
filepath = [dirname '/' filename];

ncdisp(filepath)
ncinfo(filepath)
%%
% Load Landsat images

%     infiles = dir('/disk04/Landsat/Processing/Australia/LC8115075*_Australia.L2');  % file has reflectances and Lw,Lt,La for noise model

%     for imag = 1:length(infiles)
%         filename = infiles(imag).name;
longitude   = ncread(filepath,'/navigation_data/longitude');
latitude    = ncread(filepath,'/navigation_data/latitude');
ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
Rrs443      = ncread(filepath,'/geophysical_data/Rrs_443');
Rrs561      = ncread(filepath,'/geophysical_data/Rrs_561');
Lt443       = ncread(filepath,'/geophysical_data/Lt_443');
Lt561       = ncread(filepath,'/geophysical_data/Lt_561');
Lt2201      = ncread(filepath,'/geophysical_data/Lt_2201');
Lw443       = ncread(filepath,'/geophysical_data/Lw_443');
Lw561       = ncread(filepath,'/geophysical_data/Lw_561');
La443       = ncread(filepath,'/geophysical_data/La_443');
La561       = ncread(filepath,'/geophysical_data/La_561');
La2201      = ncread(filepath,'/geophysical_data/La_2201');
%%
chl_oc3     = ncread(filepath,'/geophysical_data/chl_oc3');
year        = str2double(filename(10:13));
julday      = str2double(filename(14:16));
%     end

% figure,imagesc(ag412)
%% Plot chl_oc3 from nc from SeaDAS
plusdegress = 0.5;
latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];

figure('Color','white')
% ax = worldmap([52 75],[170 -120]);
ax = worldmap(latlimplot,lonlimplot);

load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])

geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% Display product

geoshow(ax,latitude,longitude,log10(chl_oc3),'DisplayType','surface','ZData',zeros(size(chl_oc3)),'CData',log10(chl_oc3))
colormap jet
caxis([log10(0.01),log10(20)]) % from colorbar in SeaDAS
hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','Chl-a [mg m\^-3]')
fs = 11;
set(hcb,'fontsize',fs,'Location','southoutside')
set(hcb,'Position',[.2 .15 .6 .05])
title(hcb,'chl-a [mg m\^-3]','FontSize',fs)
set(gca, 'Units', 'normalized', 'Position', [0 0.1 1 1])
% y = get(hcb,'XTick');
[xmin,xmax] = caxis;
x = [10^xmin 0.07 0.45 2.99 10^xmax];
set(hcb,'XTick',log10(x));
set(hcb,'XTickLabel',x)

%% Plot ag_412_mlrc from nc from SeaDAS

plusdegress = 0.5;
latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];

figure('Color','white')
% ax = worldmap([52 75],[170 -120]);
ax = worldmap(latlimplot,lonlimplot);

load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])

geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% Display product

geoshow(ax,latitude,longitude,log10(ag_412_mlrc),'DisplayType','surface','ZData',zeros(size(ag_412_mlrc)),'CData',log10(ag_412_mlrc))
colormap jet
caxis([log10(0.00030006314),log10(2.968400001526)]) % from colorbar in SeaDAS
hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','Chl-a [mg m\^-3]')
fs = 11;
set(hcb,'fontsize',fs,'Location','southoutside')
set(hcb,'Position',[.2 .15 .6 .05])
title(hcb,'ag\_412\_mlrc [m\^-1]','FontSize',fs)
set(gca, 'Units', 'normalized', 'Position', [0 0.1 1 1])
y = get(hcb,'XTick');
[xmin,xmax] = caxis;
x = [10^xmin  10^xmax];
set(hcb,'XTick',log10(x));
set(hcb,'XTickLabel',x)

%% From Sergio's script
[DOC,ag412] = doc_algorithm_ag412_daily( Rrs443, Rrs561, julday );
%% Quick display
figure('Color','white')
imagesc(log10(ag412))
colormap jet
caxis([log10(min(ag412(:))),log10(max(ag412(:)))])  
hcb = colorbar('southoutside');
y = get(hcb,'XTick');
% [xmin,xmax] = caxis;
x = 10.^y;
set(hcb,'XTick',log10(x));
set(hcb,'XTickLabel',x)
%%
plusdegress = 0.5;
latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];

figure('Color','white')
% ax = worldmap([52 75],[170 -120]);
ax = worldmap(latlimplot,lonlimplot);

load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])

geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% Display product

geoshow(ax,latitude,longitude,log10(ag412),'DisplayType','surface',...
      'ZData',zeros(size(ag412)),'CData',log10(ag412))
colormap jet
% caxis([log10(min(ag412(:))),log10(max(ag412(:)))]) 
caxis([log10(0.00030006314),log10(2.968400001526)]) % from colorbar in SeaDAS
hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','Chl-a [mg m\^-3]')
fs = 11;
set(hcb,'fontsize',fs,'Location','southoutside')
set(hcb,'Position',[.2 .15 .6 .05])
title(hcb,'ag\_412 [m\^-1]','FontSize',fs)
% set(gca, 'Units', 'normalized', 'Position', [0 0.1 1 1])
y = get(hcb,'XTick');
% [xmin,xmax] = caxis;
x = 10.^y;
set(hcb,'XTick',log10(x));
set(hcb,'XTickLabel',x)
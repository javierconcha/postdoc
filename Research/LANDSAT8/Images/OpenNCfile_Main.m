%% Load Landsat images
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/artic_L2wag412/';
% filename = 'LC80720212014209LGN00';
filename = 'LC80770102014196LGN00';
extension = '_L2.nc';
filepath = [dirname filename extension];

% ncdisp(filepath)
% ncinfo(filepath)

%     infiles = dir('/disk04/Landsat/Processing/Australia/LC8115075*_Australia.L2');  % file has reflectances and Lw,Lt,La for noise model

%     for imag = 1:length(infiles)
%         filename = infiles(imag).name;
longitude   = ncread(filepath,'/navigation_data/longitude');
latitude    = ncread(filepath,'/navigation_data/latitude');
ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
Rrs443      = ncread(filepath,'/geophysical_data/Rrs_443');
Rrs561      = ncread(filepath,'/geophysical_data/Rrs_561');
% Lt443       = ncread(filepath,'/geophysical_data/Lt_443');
% Lt561       = ncread(filepath,'/geophysical_data/Lt_561');
% Lt2201      = ncread(filepath,'/geophysical_data/Lt_2201');
% Lw443       = ncread(filepath,'/geophysical_data/Lw_443');
% Lw561       = ncread(filepath,'/geophysical_data/Lw_561');
% La443       = ncread(filepath,'/geophysical_data/La_443');
% La561       = ncread(filepath,'/geophysical_data/La_561');
% La2201      = ncread(filepath,'/geophysical_data/La_2201');
% chl_oc3     = ncread(filepath,'/geophysical_data/chl_oc3');
year        = str2double(filename(10:13));
julday      = str2double(filename(14:16));

% figure,imagesc(ag412)

clear dirname extension filepath
%% Checking number of NaN and Negatives
disp('----------------------------------------------')
fprintf('Pixels in the Image: %2.8G\n',size(Rrs443(:),1))
fprintf('NaN values ag_412_mlrc: %2.8G\n',sum(isnan(ag_412_mlrc(:))))
fprintf('NaN values Rr443: %2.8G\n',sum(isnan(Rrs443(:))))
fprintf('NaN values Rr561: %2.8G\n',sum(isnan(Rrs561(:))))

fprintf('Neg. values ag_412_mlrc: %2.8G\n',sum(ag_412_mlrc(:)<0))
fprintf('Neg. values Rr443: %2.8G\n',sum(Rrs443(:)<0))
fprintf('Neg. values Rr561: %2.8G\n',sum(Rrs561(:)<0))

figure('Color','white','Name',filename),histogram(Rrs443(:)),title('Rrs443')
figure('Color','white','Name',filename),histogram(Rrs561(:)),title('Rrs561')

figure('Color','white','Name',filename),imagesc(Rrs443<0),colormap('gray'),title('Rrs443<0')
figure('Color','white','Name',filename),imagesc(Rrs561<0),colormap('gray'),title('Rrs561<0')
disp('----------------------------------------------')
% 
% %% Plot chl_oc3 from nc from SeaDAS
% plusdegress = 0.5;
% latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
% lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];
% 
% figure('Color','white','Name',filename)
% % ax = worldmap([52 75],[170 -120]);
% ax = worldmap(latlimplot,lonlimplot);
% 
% load coastlines
% geoshow(ax, coastlat, coastlon,...
% 'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
% 
% geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
% geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% % Display product
% 
% geoshow(ax,latitude,longitude,log10(chl_oc3),'DisplayType','surface','ZData',zeros(size(chl_oc3)),'CData',log10(chl_oc3))
% colormap jet
% caxis([log10(0.01),log10(20)]) % from colorbar in SeaDAS
% hcb = colorbar('southoutside');
% % set(get(hcb,'Xlabel'),'String','Chl-a [mg m\^-3]')
% fs = 11;
% set(hcb,'fontsize',fs,'Location','southoutside')
% set(hcb,'Position',[.2 .15 .6 .05])
% title('Chl-a (SeaDAS)','FontSize',fs)
% title(hcb,'Chl-a (mg m\^-3)','FontSize',fs)
% % set(gca, 'Units', 'normalized', 'Position', [0 0.1 1 1])
% y = get(hcb,'XTick');
% % [xmin,xmax] = caxis;
% x = 10.^y;
% set(hcb,'XTick',log10(x));
% set(hcb,'XTickLabel',x)

%% Plot ag_412_mlrc from nc from SeaDAS

plusdegress = 0.5;
latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];

figure('Color','white','Name',filename)
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
cmin = nanmin(ag_412_mlrc(:));
cmax = nanmax(ag_412_mlrc(:));
caxis([log10(cmin),log10(cmax)]) % from colorbar in SeaDAS
hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','Chl-a [mg m\^-3]')
fs = 11;
set(hcb,'fontsize',fs,'Location','southoutside')
set(hcb,'Position',[.2 .15 .6 .05])
title('ag\_412\_mlrc (SeaDAS)','FontSize',fs)
title(hcb,'a_{CDOM} (m\^-1)','FontSize',fs)
% set(gca, 'Units', 'normalized', 'Position', [0 0.1 1 1])
y = get(hcb,'XTick');
% [xmin,xmax] = caxis;
x = 10.^y;
set(hcb,'XTick',log10(x));
set(hcb,'XTickLabel',x)

%% From Sergio's script
[DOC,ag412] = doc_algorithm_ag412_daily( Rrs443, Rrs561, julday );
% %% Quick display
% figure('Color','white','Name',filename)
% imagesc(log10(ag412))
% colormap jet
% caxis([log10(min(ag412(:))),log10(max(ag412(:)))])  
% hcb = colorbar('southoutside');
% y = get(hcb,'XTick');
% % [xmin,xmax] = caxis;
% x = 10.^y;
% set(hcb,'XTick',log10(x));
% set(hcb,'XTickLabel',x)
%%
plusdegress = 0.5;
latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];

figure('Color','white','Name',filename)
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
caxis([log10(cmin),log10(cmax)])
hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','Chl-a [mg m\^-3]')
fs = 11;
set(hcb,'fontsize',fs,'Location','southoutside')
set(hcb,'Position',[.2 .15 .6 .05])
title('ag\_412 (Matlab)','FontSize',fs)
title(hcb,'a_{CDOM} (m\^-1)','FontSize',fs)
% set(gca, 'Units', 'normalized', 'Position', [0 0.1 1 1])
y = get(hcb,'XTick');
% [xmin,xmax] = caxis;
x = 10.^y;
set(hcb,'XTick',log10(x));
set(hcb,'XTickLabel',x)

%% Comparison
disp('Percentage of error:')
disp(nanmean(ag412(:)-ag_412_mlrc(:))/(nanmin(ag412(:)-nanmax(ag412(:)))))
figure('Color','white','Name',filename),histogram(ag412(:)),title('ag\_412 (Matlab)','FontSize',fs)
figure('Color','white','Name',filename),histogram(ag_412_mlrc(:)),title('ag\_412\_mlrc (SeaDAS)','FontSize',fs)
xlim([0 1])
%%
% Checking if they are real
if isreal(ag_412_mlrc)
      disp('It is real')
else
      disp('It is NOT real')
end
if isreal(ag412)  
      disp('It is real')
else
      disp('It is NOT real')
end
%%
error = ag_412_mlrc(:)- ag412(:);
RMSE = sqrt(nanmean(error.^2));


disp(   '----------------------------------------------')
disp(   'Product        min       max     mean    std')
fprintf('ag_412_mlrc    %2.2G   %2.3f   %2.3f   %2.3f\n',nanmin(ag_412_mlrc(:)),nanmax(ag_412_mlrc(:)),nanmean(ag_412_mlrc(:)),nanstd(ag_412_mlrc(:)))
fprintf('ag412 (Matlab) %2.2G   %2.3f   %2.3f   %2.3f\n',nanmin(ag412(:)),nanmax(ag412(:)),nanmean(ag412(:)),nanstd(ag412(:)))
fprintf('error         %2.5f    %2.2G   %2.2G   %2.2G\n',nanmin(error(:)),nanmax(error(:)),nanmean(error(:)),nanstd(error(:)))

fprintf('\nRMSE = %2.4f\n',RMSE)



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
ag412       = ncread(filepath,'/geophysical_data/ag_412_mlrc');
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
%%
figure('Color','white')
ax = worldmap([54 60],[-170 -150]);
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,latitude,longitude,chl_oc3)
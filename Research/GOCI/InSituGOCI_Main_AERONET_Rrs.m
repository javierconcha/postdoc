% Script to find Landsat 8 matchups for Rrs based on in situ data from
% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/GOCI';
%% Load in situ data: Extract AERONET Rrs data from SeaBASS file
clear InSitu
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/L8_Rrs_Matchups_AERONET/';

count = 0;

filename = 'aeronet_oc_env_data.txt';

filepath = [dirname filename];

[data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,...
      'NewTextFields',{'cruise_name','data_id','date','time',});

h1 = waitbar(0,'Initializing ...');
for idx=1:size(data.date,1)
      station_name = char(data.cruise_name(idx));
      if strcmp(station_name(1:12),'aoc_gageocho')||...
                  strcmp(station_name(1:9),'aoc_ieodo') % ex: aoc_gageocho_l20_201205 or aoc_ieodo_l20_201312
            waitbar(idx/size(data.date,1),h1,'Creating In Situ cells...')
            %% Rrs
            
            Rrs = [data.rrs410(idx),data.rrs412(idx),data.rrs413(idx),data.rrs443(idx),data.rrs486(idx),data.rrs488(idx),data.rrs490(idx),data.rrs531(idx),data.rrs547(idx),data.rrs551(idx),data.rrs555(idx),data.rrs665(idx),data.rrs667(idx),data.rrs670(idx),data.rrs671(idx),data.rrs678(idx),data.rrs681(idx)];
            wavelength = [410,412,413,443,486,488,490,531,547,551,555,665,667,670,671,678,681];
            
            count = count+1;
            
            time_acquired = datestr(data.time(idx),'HH:MM:ss');
            t_date = datetime(data.date(idx),'Format','yyyy-MM-dd');
            t = char(t_date);
            t = [t(:,1:10) ' ' time_acquired];
            t = datetime(t,'ConvertFrom','yyyymmdd');
            
            InSitu(count).scene_date = datetime(data.date(idx),'Format','yyyyMMdd');
            InSitu(count).station = data.cruise_name(idx);
            InSitu(count).data_id = data.data_id(idx);
            InSitu(count).wavelength = wavelength;
            InSitu(count).Rrs = Rrs;
            InSitu(count).lat = data.latitude(idx);
            InSitu(count).lon = data.longitude(idx);
            InSitu(count).t = t;
%             InSitu(count).scene_date = datetime(data.date(idx),'Format','yyyyMMdd');
            
            %       fprintf('%i %s\n',idx,char(data.date_time(idx)))
            
      end
end
close(h1)
%%
unique([InSitu(:).scene_date]','rows') % to have only one date per day
% this list is used to search for the GOCI scene in the in house server
% from the list goci_l1.txt provided by John Wildings
%%
[InSitu(:).scene_date]' 
[InSitu(:).lat]'
[InSitu(:).lon]'
%% figure for plottig the data
Rrs = cell2mat({InSitu.Rrs});
wavelength = cell2mat({InSitu.wavelength});

figure('Color','white')
ylabel('Rrs (1/sr)')
xlabel('wavelength (nm)')
hold on
plot(wavelength,Rrs);
grid on
title('Rrs')
%% Plot Location
figure('Color','white')
ax = worldmap([30 45],[116 136]);
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
plotm(cell2mat({InSitu.lat}'),cell2mat({InSitu.lon}'),'*r')

%% Load sat data
clear SatData
fileID = fopen('./GOCI_AERONET/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

% InSitu(size(data.date,1)).station = '';
% SatData(size(s{1},1)).time = '';

for idx0=1:size(s{1},1)
      
      filepath = ['./GOCI_AERONET/' s{1}{idx0}];
      SatData(idx0) = loadsatcell(filepath);
      
end

%%

cond1 = [SatData.Rrs_412_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?

%% Histograms
figure,hist([SatData(cond1).Rrs_490_filtered_mean],20)

figure,hist([SatData(cond1).angstrom_filtered_mean],20)

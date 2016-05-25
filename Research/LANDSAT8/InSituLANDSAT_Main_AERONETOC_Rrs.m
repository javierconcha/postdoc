% Script to find Landsat 8 matchups for Rrs based on in situ data from
% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';

%% Load in situ data


% figure for plottig the data
figure('Color','white')
hf1 = gcf;
ylabel('Rrs (1/sr)')
xlabel('wavelength (nm)')

% Plot GOCI footprint
figure('Color','white')
hf2 = gcf;
ax = worldmap([45 90],[-180 180]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')

%%
% Extract Tara data from SeaBASS file
dirname = '/Volumes/Data/OLI/L8_Rrs_Matchups/';

% % Open file with the list of images names
% fileID = fopen([dirname 'file_list.txt']);
% s = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);

count = 0;

% for idx=1:size(s{:},1)
%       filename = s{1}{idx}; % search on the list of filenames
      
      filename = 'val1464210174176624_Rrs.csv';
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);
%%      
      %% ag
      
      Rrs = [data.rrs340,data.rrs412,data.rrs443,data.rrs465,data.rrs490,data.rrs510,data.rrs532,data.rrs555,data.rrs560,data.rrs589,data.rrs625,data.rrs665,data.rrs670,data.rrs683,data.rrs694,data.rrs710,data.rrs765,data.rrs780,data.rrs875];
      wavelength = [340,412,443,465,490,510,532,555,560,589,625,665,670,683,694,710,765,780,875];
      
      figure(hf1)
      hold on
      plot(wavelength,Rrs);
      grid on
      title('Rrs')
      
      %% Location
      figure(hf2)
      hold on
      plotm(sbHeader.north_latitude,sbHeader.east_longitude,'*r')
      
      date_acquired = data.date;
      time_acquired = datestr(data.time,'HH:MM:SS');
      t = datetime(date_acquired,'ConvertFrom','yyyymmdd');
      t = char(t);
      t = [t(:,1:12) time_acquired];
      t = datetime(t,'ConvertFrom','yyyymmdd');
      
      count = count+1;
      InSitu(count).station = sbHeader.station;
      InSitu(count).start_date = sbHeader.start_date;
      InSitu(count).start_time = sbHeader.start_time;
      InSitu(count).filepath = filepath;
      InSitu(count).wavelength = wavelength;
      InSitu(count).Rrs = Rrs;
      InSitu(count).lat = sbHeader.north_latitude;
      InSitu(count).lon = sbHeader.east_longitude;
      InSitu(count).t = t;
      
      fprintf('%s %i %s\n',sbHeader.station,sbHeader.start_date,sbHeader.start_time)
end
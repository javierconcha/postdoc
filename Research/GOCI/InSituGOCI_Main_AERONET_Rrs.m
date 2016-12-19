% Script to find GOCI matchups for Rrs based on in situ data from
% AERONET-OC
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')

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

save('GOCI_AERONET_Rrs.mat','InSitu')
%%
unique([InSitu(:).scene_date]','rows') % to have only one date per day
% this list is used to search for the GOCI scene in the in house server
% from the list goci_l1.txt provided by John Wildings
%% to process images in anly104
% [InSitu(:).scene_date]' 
% [InSitu(:).lat]'
% [InSitu(:).lon]'
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

%% InSitu vs Sat
% InSituBands =[412,443,490,555,665,681]; or 678
% GOCIbands =  [412,443,490,555,660,680,745,865];
%               2   4   7   11  12  17  N/A N/A
%               1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17 
% wavelength = [410,412,413,443,486,488,490,531,547,551,555,665,667,670,671,678,681];
          
clear Matchup

for idx1=1:size(InSitu,2)
      
      Matchup(idx1).datetime_ins = InSitu(idx1).t;
      Matchup(idx1).station_ins = InSitu(idx1).station;
      
      % Rrs_412
      
      Matchup(idx1).Rrs_412_ins = InSitu(idx1).Rrs(2 );
      cond1 = [SatData.Rrs_412_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond1); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_412_sat = SatData(IdxOrig(idx_aux)).Rrs_412_filtered_mean;
      else
            Matchup(idx1).Rrs_412_sat = NaN;
      end   
      Matchup(idx1).Rrs_412_sat_datetime = SatData(IdxOrig(idx_aux)).datetime;        
      Matchup(idx1).Rrs_412_t_diff = t_diff;

      % Rrs_443
      
      Matchup(idx1).Rrs_443_ins = InSitu(idx1).Rrs(4 );
      cond1 = [SatData.Rrs_443_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond1); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_443_sat = SatData(IdxOrig(idx_aux)).Rrs_443_filtered_mean;
      else
            Matchup(idx1).Rrs_443_sat = NaN;
      end   
      Matchup(idx1).Rrs_443_sat_datetime = SatData(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_443_t_diff = t_diff;

       % Rrs_490

      Matchup(idx1).Rrs_490_ins = InSitu(idx1).Rrs(7 );
      cond1 = [SatData.Rrs_490_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond1); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_490_sat = SatData(IdxOrig(idx_aux)).Rrs_490_filtered_mean;
      else
            Matchup(idx1).Rrs_490_sat = NaN;
      end   
      Matchup(idx1).Rrs_490_sat_datetime = SatData(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_490_t_diff = t_diff;

      % Rrs_555
      
      Matchup(idx1).Rrs_555_ins = InSitu(idx1).Rrs(11);
      cond1 = [SatData.Rrs_555_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond1); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_555_sat = SatData(IdxOrig(idx_aux)).Rrs_555_filtered_mean;
      else
            Matchup(idx1).Rrs_555_sat = NaN;
      end   
      Matchup(idx1).Rrs_555_sat_datetime = SatData(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_555_t_diff = t_diff;

      % Rrs_660
      
      Matchup(idx1).Rrs_665_ins = InSitu(idx1).Rrs(12);
      cond1 = [SatData.Rrs_660_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond1); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_660_sat = SatData(IdxOrig(idx_aux)).Rrs_660_filtered_mean;
      else
            Matchup(idx1).Rrs_660_sat = NaN;
      end   
      Matchup(idx1).Rrs_660_sat_datetime = SatData(IdxOrig(idx_aux)).datetime; 
      Matchup(idx1).Rrs_660_t_diff = t_diff;

      % Rrs_680
      % For in situ @ 678 nm
      Matchup(idx1).Rrs_678_ins = InSitu(idx1).Rrs(16);
      cond1 = [SatData.Rrs_680_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      IdxOrig = find(cond1); % to convert to the original matrix

      % % For in situ @ 681 nm
      % Matchup(idx1).Rrs_681_ins = InSitu(idx1).Rrs(17);
      % cond1 = [SatData.Rrs_680_valid_pixel_count]>=9/2+1; % enough valid pixels for a 3x3 window?     
      % [t_diff,idx_aux] = min(abs([SatData(cond1).datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix
      % IdxOrig = find(cond1); % to convert to the original matrix
      
      if t_diff<=hours(3)
            Matchup(idx1).Rrs_680_sat = SatData(IdxOrig(idx_aux)).Rrs_680_filtered_mean;
      else
            Matchup(idx1).Rrs_680_sat = NaN;
      end         
      Matchup(idx1).Rrs_680_sat_datetime = SatData(IdxOrig(idx_aux)).datetime;        
      Matchup(idx1).Rrs_680_t_diff = t_diff;

end
%%

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat]);
legend off
set(gcf, 'renderer','painters')
[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat]);
legend off
set(gcf, 'renderer','painters')
[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat]);
legend off
set(gcf, 'renderer','painters')
[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat]);
legend off
set(gcf, 'renderer','painters')
[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat]);
legend off
set(gcf, 'renderer','painters')

% no data for in situ 678 or 681
% [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('678','680',[Matchup.Rrs_678_ins],[Matchup.Rrs_680_sat]);
% [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('681','680',[Matchup.Rrs_681_ins],[Matchup.Rrs_680_sat]);
%%

%% Histograms
figure,hist([SatData(cond1).Rrs_490_filtered_mean],20)

figure,hist([SatData(cond1).angstrom_filtered_mean],20)

figure,hist([SatData(cond1).center_az],20)
figure,hist([SatData(cond1).center_el],20)

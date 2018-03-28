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
A = unique([InSitu(:).scene_date]','rows') % to have only one date per day
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

source = 'AERONET_GOCI_R2018_SW';
% source = 'AERONET_GOCI_R2018_MA';
% source = 'AERONET_GOCI_R2018_NO';
% source = 'AERONET_GOCI_R2018_NR';
% source = 'AERONET_GOCI_R2018_MA_CV1p5';
% source = 'AERONET_GOCI_R2018_NIRvcal';

fileID = fopen(['/Users/jconchas/Documents/Research/GOCI/GOCI_AERONET/' source '/file_list.txt']);

s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

% InSitu(size(data.date,1)).station = '';
% SatData(size(s{1},1)).time = '';

for idx0=1:size(s{1},1)
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_AERONET/' source '/' s{1}{idx0}];
      SatData(idx0) = loadsatcell_tempanly(filepath,'GOCI');
      
end

count = 0;

solz_lim = 75;
senz_lim = 60;
CV_lim = 0.15;

total_px_GOCI = 5*5;
ratio_from_the_total = 2;

clear Matchup

cond_solz = [SatData.solz_center_value] < solz_lim;
cond_senz = [SatData.senz_center_value] < senz_lim;
cond_median_CV = [SatData.median_CV] < CV_lim;
cond_used = cond_solz&cond_senz&cond_median_CV;
SatData_used = SatData(cond_used);
clear cond_used cond_solz cond_senz cond_median_CV

for idx1=1:size(SatData_used,2)
      %%
      cond_time = hours(abs([SatData_used(idx1).datetime]-[InSitu.t]))<0.5;
      if sum(cond_time)~=0 % only if there are matchups within 30 min window
            count = count+1;
            % Rrs_412
            cond_enough = [SatData_used(idx1).Rrs_412_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
            cond_pos = [SatData_used(idx1).Rrs_412_filtered_mean] >0;
            cond_used = cond_enough&cond_pos;
            clear cond_enough cond_pos
            if cond_used
                  
                  [t_diff,idx_aux] = min(abs([InSitu.t]-[SatData_used(idx1).datetime])); % index to cond1 but not to the original matrix
                  if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5
                        
                        Matchup(count).Rrs_412_ins = InSitu(idx_aux).Rrs(2);
                        Matchup(count).datetime_ins = InSitu(idx_aux).t;
                        Matchup(count).station_ins = InSitu(idx_aux).station;
                        
                        station_char = char(InSitu(idx_aux).station);
                        
                        if strcmp(station_char(1:9),'aoc_gageo')
                              Matchup(count).station_ins_ID = 1;
                        elseif strcmp(station_char(1:9),'aoc_ieodo')
                              Matchup(count).station_ins_ID = 2;
                        end
                        
                        Matchup(count).Rrs_412_sat = SatData_used(idx1).Rrs_412_filtered_mean;
                        Matchup(count).Rrs_412_sat_datetime = SatData_used(idx1).datetime;
                        Matchup(count).Rrs_412_t_diff = t_diff;
                  end   
            else
                  Matchup(count).Rrs_412_ins = NaN;
                  Matchup(count).datetime_ins = datetime(0,0,0);
                  Matchup(count).station_ins = 'NaN';
                  Matchup(count).station_ins_ID = NaN;
                  
                  Matchup(count).Rrs_412_sat = NaN;
                  Matchup(count).Rrs_412_sat_datetime = datetime(0,0,0);
                  Matchup(count).Rrs_412_t_diff = hours(0);  
            end

            % Rrs_443
            cond_enough = [SatData_used(idx1).Rrs_443_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
            cond_pos = [SatData_used(idx1).Rrs_443_filtered_mean] >0;
            cond_used = cond_enough&cond_pos;
            clear cond_enough cond_pos
            if cond_used
                  
                  [t_diff,idx_aux] = min(abs([InSitu.t]-[SatData_used(idx1).datetime])); % index to cond1 but not to the original matrix
                  if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5
                        
                        Matchup(count).Rrs_443_ins = InSitu(idx_aux).Rrs(4);
                        Matchup(count).datetime_ins = InSitu(idx_aux).t;
                        Matchup(count).station_ins = InSitu(idx_aux).station;
                        
                        station_char = char(InSitu(idx_aux).station);
                        
                        if strcmp(station_char(1:9),'aoc_gageo')
                              Matchup(count).station_ins_ID = 1;
                        elseif strcmp(station_char(1:9),'aoc_ieodo')
                              Matchup(count).station_ins_ID = 2;
                        end
                        
                        Matchup(count).Rrs_443_sat = SatData_used(idx1).Rrs_443_filtered_mean;
                        Matchup(count).Rrs_443_sat_datetime = SatData_used(idx1).datetime;
                        Matchup(count).Rrs_443_t_diff = t_diff;
                  end   
            else
                  Matchup(count).Rrs_443_ins = NaN;
                  Matchup(count).datetime_ins = datetime(0,0,0);
                  Matchup(count).station_ins = 'NaN';
                  Matchup(count).station_ins_ID = NaN;
                  
                  Matchup(count).Rrs_443_sat = NaN;
                  Matchup(count).Rrs_443_sat_datetime = datetime(0,0,0);
                  Matchup(count).Rrs_443_t_diff = hours(0);  
            end

            % Rrs_490
            cond_enough = [SatData_used(idx1).Rrs_490_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
            cond_pos = [SatData_used(idx1).Rrs_490_filtered_mean] >0;
            cond_used = cond_enough&cond_pos;
            clear cond_enough cond_pos
            if cond_used
                  
                  [t_diff,idx_aux] = min(abs([InSitu.t]-[SatData_used(idx1).datetime])); % index to cond1 but not to the original matrix
                  if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5
                        
                        Matchup(count).Rrs_490_ins = InSitu(idx_aux).Rrs(7);
                        Matchup(count).datetime_ins = InSitu(idx_aux).t;
                        Matchup(count).station_ins = InSitu(idx_aux).station;
                        
                        station_char = char(InSitu(idx_aux).station);
                        
                        if strcmp(station_char(1:9),'aoc_gageo')
                              Matchup(count).station_ins_ID = 1;
                        elseif strcmp(station_char(1:9),'aoc_ieodo')
                              Matchup(count).station_ins_ID = 2;
                        end
                        
                        Matchup(count).Rrs_490_sat = SatData_used(idx1).Rrs_490_filtered_mean;
                        Matchup(count).Rrs_490_sat_datetime = SatData_used(idx1).datetime;
                        Matchup(count).Rrs_490_t_diff = t_diff;
                  end   
            else
                  Matchup(count).Rrs_490_ins = NaN;
                  Matchup(count).datetime_ins = datetime(0,0,0);
                  Matchup(count).station_ins = 'NaN';
                  Matchup(count).station_ins_ID = NaN;
                  
                  Matchup(count).Rrs_490_sat = NaN;
                  Matchup(count).Rrs_490_sat_datetime = datetime(0,0,0);
                  Matchup(count).Rrs_490_t_diff = hours(0);  
            end

            % Rrs_555
            cond_enough = [SatData_used(idx1).Rrs_555_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
            cond_pos = [SatData_used(idx1).Rrs_555_filtered_mean] >0;
            cond_used = cond_enough&cond_pos;
            clear cond_enough cond_pos
            if cond_used
                  
                  [t_diff,idx_aux] = min(abs([InSitu.t]-[SatData_used(idx1).datetime])); % index to cond1 but not to the original matrix
                  if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5
                        
                        Matchup(count).Rrs_555_ins = InSitu(idx_aux).Rrs(11);
                        Matchup(count).datetime_ins = InSitu(idx_aux).t;
                        Matchup(count).station_ins = InSitu(idx_aux).station;
                        
                        station_char = char(InSitu(idx_aux).station);
                        
                        if strcmp(station_char(1:9),'aoc_gageo')
                              Matchup(count).station_ins_ID = 1;
                        elseif strcmp(station_char(1:9),'aoc_ieodo')
                              Matchup(count).station_ins_ID = 2;
                        end
                        
                        Matchup(count).Rrs_555_sat = SatData_used(idx1).Rrs_555_filtered_mean;
                        Matchup(count).Rrs_555_sat_datetime = SatData_used(idx1).datetime;
                        Matchup(count).Rrs_555_t_diff = t_diff;
                  end   
            else
                  Matchup(count).Rrs_555_ins = NaN;
                  Matchup(count).datetime_ins = datetime(0,0,0);
                  Matchup(count).station_ins = 'NaN';
                  Matchup(count).station_ins_ID = NaN;
                  
                  Matchup(count).Rrs_555_sat = NaN;
                  Matchup(count).Rrs_555_sat_datetime = datetime(0,0,0);
                  Matchup(count).Rrs_555_t_diff = hours(0);  
            end

            % Rrs_660
            cond_enough = [SatData_used(idx1).Rrs_660_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
            cond_pos = [SatData_used(idx1).Rrs_660_filtered_mean] >0;
            cond_used = cond_enough&cond_pos;
            clear cond_enough cond_pos
            if cond_used
                  
                  [t_diff,idx_aux] = min(abs([InSitu.t]-[SatData_used(idx1).datetime])); % index to cond1 but not to the original matrix
                  if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5
                        
                        Matchup(count).Rrs_665_ins = InSitu(idx_aux).Rrs(12);
                        Matchup(count).datetime_ins = InSitu(idx_aux).t;
                        Matchup(count).station_ins = InSitu(idx_aux).station;
                        
                        station_char = char(InSitu(idx_aux).station);
                        
                        if strcmp(station_char(1:9),'aoc_gageo')
                              Matchup(count).station_ins_ID = 1;
                        elseif strcmp(station_char(1:9),'aoc_ieodo')
                              Matchup(count).station_ins_ID = 2;
                        end
                        
                        Matchup(count).Rrs_660_sat = SatData_used(idx1).Rrs_660_filtered_mean;
                        Matchup(count).Rrs_660_sat_datetime = SatData_used(idx1).datetime;
                        Matchup(count).Rrs_660_t_diff = t_diff;
                  end   
            else
                  Matchup(count).Rrs_665_ins = NaN;
                  Matchup(count).datetime_ins = datetime(0,0,0);
                  Matchup(count).station_ins = 'NaN';
                  Matchup(count).station_ins_ID = NaN;
                  
                  Matchup(count).Rrs_660_sat = NaN;
                  Matchup(count).Rrs_660_sat_datetime = datetime(0,0,0);
                  Matchup(count).Rrs_660_t_diff = hours(0);  
            end

            % Rrs_680
            cond_enough = [SatData_used(idx1).Rrs_680_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
            cond_pos = [SatData_used(idx1).Rrs_680_filtered_mean] >0;
            cond_used = cond_enough&cond_pos;
            clear cond_enough cond_pos
            if cond_used
                  
                  [t_diff,idx_aux] = min(abs([InSitu.t]-[SatData_used(idx1).datetime])); % index to cond1 but not to the original matrix
                  if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5
                        
                        Matchup(count).Rrs_680_ins = InSitu(idx_aux).Rrs(16);
                        Matchup(count).datetime_ins = InSitu(idx_aux).t;
                        Matchup(count).station_ins = InSitu(idx_aux).station;
                        
                        station_char = char(InSitu(idx_aux).station);
                        
                        if strcmp(station_char(1:9),'aoc_gageo')
                              Matchup(count).station_ins_ID = 1;
                        elseif strcmp(station_char(1:9),'aoc_ieodo')
                              Matchup(count).station_ins_ID = 2;
                        end
                        
                        Matchup(count).Rrs_680_sat = SatData_used(idx1).Rrs_680_filtered_mean;
                        Matchup(count).Rrs_680_sat_datetime = SatData_used(idx1).datetime;
                        Matchup(count).Rrs_680_t_diff = t_diff;
                  end   
            else
                  Matchup(count).Rrs_680_ins = NaN;
                  Matchup(count).datetime_ins = datetime(0,0,0);
                  Matchup(count).station_ins = 'NaN';
                  Matchup(count).station_ins_ID = NaN;
                  
                  Matchup(count).Rrs_680_sat = NaN;
                  Matchup(count).Rrs_680_sat_datetime = datetime(0,0,0);
                  Matchup(count).Rrs_680_t_diff = hours(0);  
            end


      end
end
%

% InSitu vs Sat
% InSituBands =[412,443,490,555,665,681]; or 678
% GOCIbands =  [412,443,490,555,660,680,745,865];
%               2   4   7   11  12  17  N/A N/A
%               1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17
% wavelength = [410,412,413,443,486,488,490,531,547,551,555,665,667,670,671,678,681];

% count = 0;

% solz_lim = 75;
% senz_lim = 60;
% CV_lim = 0.15;

% total_px_GOCI = 5*5;
% ratio_from_the_total = 2;

% clear Matchup

% for idx1=1:size(InSitu,2)

%       cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;

%       if sum(cond_time)~=0
%             count = count+1;

%             Matchup(count).datetime_ins = InSitu(idx1).t;
%             Matchup(count).station_ins = InSitu(idx1).station;

%             station_char = char(InSitu(idx1).station);

%             if strcmp(station_char(1:9),'aoc_gageo')
%                   Matchup(count).station_ins_ID = 1;
%             elseif strcmp(station_char(1:9),'aoc_ieodo')
%                   Matchup(count).station_ins_ID = 2;
%             end

%             % Rrs_412

%             Matchup(count).Rrs_412_ins = InSitu(idx1).Rrs(2);
%             cond_enough = [SatData.Rrs_412_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%             cond_pos = [SatData.Rrs_412_filtered_mean] >0;
%             cond_solz = [SatData.solz_center_value] < solz_lim;
%             cond_senz = [SatData.senz_center_value] < senz_lim;
%             cond_median_CV = [SatData.median_CV] < CV_lim;
%             cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;
%             cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;
%             SatData_used = SatData(cond_used);

%             sum(cond_used)

%             if ~isempty(SatData_used)

%                   [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   if hours(t_diff)<=3
%                         Matchup(count).Rrs_412_sat = SatData_used(idx_aux).Rrs_412_filtered_mean;
%                   else
%                         Matchup(count).Rrs_412_sat = NaN;
%                   end
%                   Matchup(count).Rrs_412_sat_datetime = SatData_used(idx_aux).datetime;
%                   Matchup(count).Rrs_412_t_diff = t_diff;
%             else
%                   Matchup(count).Rrs_412_sat = NaN;
%                   Matchup(count).Rrs_412_sat_datetime = datetime(0,0,1);
%                   Matchup(count).Rrs_412_t_diff = hours(0);
%             end

%             % Rrs_443

%             Matchup(count).Rrs_443_ins = InSitu(idx1).Rrs(4);
%             cond_enough = [SatData.Rrs_443_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%             cond_pos = [SatData.Rrs_443_filtered_mean] >0;
%             cond_solz = [SatData.solz_center_value] < solz_lim;
%             cond_senz = [SatData.senz_center_value] < senz_lim;
%             cond_median_CV = [SatData.median_CV] < CV_lim;
%             cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;
%             cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;
%             SatData_used = SatData(cond_used);
%             if ~isempty(SatData_used)

%                   [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   if hours(t_diff)<=3
%                         Matchup(count).Rrs_443_sat = SatData_used(idx_aux).Rrs_443_filtered_mean;
%                   else
%                         Matchup(count).Rrs_443_sat = NaN;
%                   end
%                   Matchup(count).Rrs_443_sat_datetime = SatData_used(idx_aux).datetime;
%                   Matchup(count).Rrs_443_t_diff = t_diff;
%             else
%                   Matchup(count).Rrs_443_sat = NaN;
%                   Matchup(count).Rrs_443_sat_datetime = datetime(0,0,1);
%                   Matchup(count).Rrs_443_t_diff = hours(0);
%             end

%             % Rrs_490

%             Matchup(count).Rrs_490_ins = InSitu(idx1).Rrs(7);
%             cond_enough = [SatData.Rrs_490_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%             cond_pos = [SatData.Rrs_490_filtered_mean] >0;
%             cond_solz = [SatData.solz_center_value] < solz_lim;
%             cond_senz = [SatData.senz_center_value] < senz_lim;
%             cond_median_CV = [SatData.median_CV] < CV_lim;
%             cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;
%             cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;
%             SatData_used = SatData(cond_used);
%             if ~isempty(SatData_used)

%                   [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   if hours(t_diff)<=3
%                         Matchup(count).Rrs_490_sat = SatData_used(idx_aux).Rrs_490_filtered_mean;
%                   else
%                         Matchup(count).Rrs_490_sat = NaN;
%                   end
%                   Matchup(count).Rrs_490_sat_datetime = SatData_used(idx_aux).datetime;
%                   Matchup(count).Rrs_490_t_diff = t_diff;
%             else
%                   Matchup(count).Rrs_490_sat = NaN;
%                   Matchup(count).Rrs_490_sat_datetime = datetime(0,0,1);
%                   Matchup(count).Rrs_490_t_diff = hours(0);
%             end

%             % Rrs_555

%             Matchup(count).Rrs_555_ins = InSitu(idx1).Rrs(11);
%             cond_enough = [SatData.Rrs_555_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%             cond_pos = [SatData.Rrs_555_filtered_mean] >0;
%             cond_solz = [SatData.solz_center_value] < solz_lim;
%             cond_senz = [SatData.senz_center_value] < senz_lim;
%             cond_median_CV = [SatData.median_CV] < CV_lim;
%             cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;
%             cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;
%             SatData_used = SatData(cond_used);
%             if ~isempty(SatData_used)

%                   [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   if hours(t_diff)<=3
%                         Matchup(count).Rrs_555_sat = SatData_used(idx_aux).Rrs_555_filtered_mean;
%                   else
%                         Matchup(count).Rrs_555_sat = NaN;
%                   end
%                   Matchup(count).Rrs_555_sat_datetime = SatData_used(idx_aux).datetime;
%                   Matchup(count).Rrs_555_t_diff = t_diff;
%             else
%                   Matchup(count).Rrs_555_sat = NaN;
%                   Matchup(count).Rrs_555_sat_datetime = datetime(0,0,1);
%                   Matchup(count).Rrs_555_t_diff = hours(0);
%             end

%             % Rrs_660

%             Matchup(count).Rrs_665_ins = InSitu(idx1).Rrs(12);
%             cond_enough = [SatData.Rrs_660_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%             cond_pos = [SatData.Rrs_660_filtered_mean] >0;
%             cond_solz = [SatData.solz_center_value] < solz_lim;
%             cond_senz = [SatData.senz_center_value] < senz_lim;
%             cond_median_CV = [SatData.median_CV] < CV_lim;
%             cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;
%             cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;
%             SatData_used = SatData(cond_used);
%             if ~isempty(SatData_used)

%                   [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   if hours(t_diff)<=3
%                         Matchup(count).Rrs_660_sat = SatData_used(idx_aux).Rrs_660_filtered_mean;
%                   else
%                         Matchup(count).Rrs_660_sat = NaN;
%                   end
%                   Matchup(count).Rrs_660_sat_datetime = SatData_used(idx_aux).datetime;
%                   Matchup(count).Rrs_660_t_diff = t_diff;
%             else
%                   Matchup(count).Rrs_660_sat = NaN;
%                   Matchup(count).Rrs_660_sat_datetime = datetime(0,0,1);
%                   Matchup(count).Rrs_660_t_diff = hours(0);
%             end

%             % Rrs_680
%             % For in situ @ 678 nm
%             Matchup(count).Rrs_678_ins = InSitu(idx1).Rrs(16);
%             cond_enough = [SatData.Rrs_680_valid_pixel_count]>1+total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%             cond_pos = [SatData.Rrs_680_filtered_mean] >0;
%             cond_solz = [SatData.solz_center_value] < solz_lim;
%             cond_senz = [SatData.senz_center_value] < senz_lim;
%             cond_median_CV = [SatData.median_CV] < CV_lim;
%             cond_time = hours(abs([SatData.datetime]-[InSitu(idx1).t]))<0.5;
%             cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;
%             SatData_used = SatData(cond_used);
%             if ~isempty(SatData_used)

%                   [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   % % For in situ @ 681 nm
%                   % Matchup(count).Rrs_681_ins = InSitu(idx1).Rrs(17);
%                   % cond_enough = [SatData.Rrs_680_valid_pixel_count]>=total_px_GOCI/ratio_from_the_total; % enough valid pixels for a 5x5 window?
%                   % cond_pos = [SatData.Rrs_412_filtered_mean] >0;%
%                   % cond_solz = [SatData.solz_center_value] <= solz_lim;
%                   % cond_senz = [SatData.senz_center_value] <= senz_lim;
%                   % cond_median_CV = [SatData.median_CV] <= CV_lim;
%                   % cond_used = cond_enough&cond_pos&cond_solz&cond_senz&cond_median_CV&cond_time;    % %
%                   % SatData_used = SatData(cond_used);
%                   % % [t_diff,idx_aux] = min(abs([SatData_used.datetime]-[InSitu(idx1).t])); % index to cond1 but not to the original matrix

%                   if hours(t_diff)<=3
%                         Matchup(count).Rrs_680_sat = SatData_used(idx_aux).Rrs_680_filtered_mean;
%                   else
%                         Matchup(count).Rrs_680_sat = NaN;
%                   end
%                   Matchup(count).Rrs_680_sat_datetime = SatData_used(idx_aux).datetime;
%                   Matchup(count).Rrs_680_t_diff = t_diff;
%             else
%                   Matchup(count).Rrs_680_sat = NaN;
%                   Matchup(count).Rrs_680_sat_datetime = datetime(0,0,1);
%                   Matchup(count).Rrs_680_t_diff = hours(0);
%             end
%       end
% end
%

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
%%
savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_412'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_443'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_490'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_555'],'epsc')

[h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],FID);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_660'],'epsc')

% latex table
fprintf(FID,'\\hline \n');
fprintf(FID,'\\end{tabular}\n');
% no data for in situ 678 or 681
% [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('678','680',[Matchup.Rrs_678_ins],[Matchup.Rrs_680_sat]);
% [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('681','680',[Matchup.Rrs_681_ins],[Matchup.Rrs_680_sat]);
%%
savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';

fs = 20;
h_412 = figure('Color','white','DefaultAxesFontSize',fs);
h_443 = figure('Color','white','DefaultAxesFontSize',fs);
h_490 = figure('Color','white','DefaultAxesFontSize',fs);
h_555 = figure('Color','white','DefaultAxesFontSize',fs);
h_660 = figure('Color','white','DefaultAxesFontSize',fs);

%% Uncalibrated
color_line = 'b';
% Rrs_412
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_412,fs,[0 0.02]);
legend off
% Rrs_443
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_443,fs,[0 0.02]);
legend off
% Rrs_490
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_490,fs,[0 0.03]);
legend off
% Rrs_555
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_555,fs,[0 0.04]);
legend off
% Rrs_660
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_660,fs,[0 0.02]);
legend off

%% MA
color_line = 'r';
% Rrs_412
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_412,fs,[0 0.02]);
legend off
% Rrs_443
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_443,fs,[0 0.02]);
legend off
% Rrs_490
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_490,fs,[0 0.03]);
legend off
% Rrs_555
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_555,fs,[0 0.04]);
legend off
% Rrs_660
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_660,fs,[0 0.02]);
legend off

%% SW
color_line = 'k';
% Rrs_412
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_412,fs,[0 0.02]);
legend off
% Rrs_443
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_443,fs,[0 0.02]);
legend off
% Rrs_490
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_490,fs,[0 0.03]);
legend off
% Rrs_555
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_555,fs,[0 0.04]);
legend off
% Rrs_660
[ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
      color_line,h_660,fs,[0 0.02]);
legend off

%%
figure(h_412)
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_412_All'],'epsc')
figure(h_443)
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_443_All'],'epsc')
figure(h_490)
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_490_All'],'epsc')
figure(h_555)
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_555_All'],'epsc')
figure(h_660)
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_660_All'],'epsc')


%% Histograms
figure,hist([SatData_used.Rrs_490_filtered_mean],20)

figure,hist([SatData_used.angstrom_filtered_mean],20)

figure,hist([SatData_used.center_az],20)
figure,hist([SatData_used.center_el],20)

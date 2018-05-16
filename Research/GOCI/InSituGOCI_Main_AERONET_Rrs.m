% Script to find GOCI matchups for Rrs based on in situ data from
% AERONET-OC
cd '/Users/jconchas/Documents/Research/GOCI/';

% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')

%% Load in situ data: Extract AERONET Rrs data from SeaBASS file
clear InSitu
% dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/L8_Rrs_Matchups_AERONET/';
dirname = '/Users/jconchas/Documents/Research/GOCI/GOCI_AERONET/';

count = 0;

% filename = 'aeronet_oc_env_data.txt';
filename = 'all_aeronet_insitu_seabass_20180503.txt';

filepath = [dirname filename];

% [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,...
% % before  /fields=cruise_name,data_id,date,time,latitude,longitude,Rrs410,Rrs412,Rrs413,Rrs443,Rrs486,Rrs488,Rrs490,Rrs531,Rrs547,Rrs551,Rrs555,Rrs665,Rrs667,Rrs670,Rrs671,Rrs678,Rrs681,aot862,aot865,aot869,OPTICS,aot1017.3,aot1018.4,aot1018.7,aot1018.8,aot1019.3,aot1019.4,aot1019.5,aot1019.6,aot1019.7,aot1019.8,aot1019.9,aot1020,aot1020.1,aot1020.3,aot1020.5,aot1020.7,aot1021,aot1021.1,aot1021.4,aot1022.1,aot411.2,aot411.3,aot411.7,aot411.8,aot412,aot412.4,aot412.5,aot412.6,aot412.7,aot412.9,aot413,aot413.1,aot413.2,aot439.5,aot439.6,aot440,aot440.6,aot440.7,aot440.8,aot441.6,aot441.7,aot441.8,aot441.9,aot442,aot442.1,aot488.5,aot488.9,aot489,aot489.2,aot489.3,aot489.6,aot489.9,aot490.5,aot490.8,aot490.9,aot491.1,aot491.2,aot491.3,aot491.4,aot491.5,aot491.6,aot500,aot500.1,aot500.3,aot500.5,aot501.4,aot530,aot530.3,aot530.4,aot530.5,aot530.6,aot530.7,aot530.8,aot531,aot531.1,aot531.2,aot531.4,aot550.6,aot550.7,aot551,aot551.1,aot551.3,aot551.4,aot551.5,aot551.6,aot551.7,aot551.8,aot551.9,aot554.9,aot555,aot555.1,aot555.4,aot666.8,aot667.6,aot667.7,aot667.8,aot667.9,aot668.1,aot668.2,aot668.3,aot668.4,aot668.5,aot670,aot674.2,aot674.9,aot675,aot675.4,aot868.6,aot868.7,aot869,aot869.4,aot869.6,aot869.8,aot869.9,aot870,aot870.1,aot870.2,aot870.5,aot870.8,aot871.9,es1017.3,es1018.4,es1018.7,es1018.8,es1019.3,es1019.4,es1019.5,es1019.6,es1019.7,es1019.8,es1019.9,es1020,es1020.1,es1020.3,es1020.5,es1020.7,es1021,es1021.1,es1021.4,es1022.1,es411,es411.2,es411.3,es411.7,es411.8,es412,es412.4,es412.5,es412.6,es412.7,es412.9,es413,es413.1,es413.2,es439,es439.5,es439.6,es440,es440.6,es440.7,es440.8,es441,es441.6,es441.7,es441.8,es441.9,es442,es442.1,es488.5,es488.9,es489,es489.2,es489.3,es489.6,es489.9,es490,es490.5,es490.8,es490.9,es491,es491.1,es491.2,es491.3,es491.4,es491.5,es491.6,es500,es500.1,es500.3,es500.5,es501,es501.4,es530,es530.3,es530.4,es530.5,es530.6,es530.7,es530.8,es531,es531.1,es531.2,es531.4,es550,es550.6,es550.7,es551,es551.1,es551.3,es551.4,es551.5,es551.6,es551.7,es551.8,es551.9,es554,es554.9,es555,es555.1,es555.4,es666.8,es667,es667.6,es667.7,es667.8,es667.9,es668,es668.1,es668.2,es668.3,es668.4,es668.5,es670,es674,es674.2,es674.9,es675,es675.4,es868.6,es868.7,es869,es869.4,es869.6,es869.8,es869.9,es870,es870.1,es870.2,es870.5,es870.8,es871.9,lw1017.3,lw1018.4,lw1018.7,lw1018.8,lw1019.3,lw1019.5,lw1019.6,lw1019.7,lw1019.8,lw1019.9,lw1020,lw1020.1,lw1020.3,lw1020.5,lw1020.7,lw1021,lw1021.1,lw1021.4,lw1022.1,lw411,lw411.3,lw411.7,lw411.8,lw412,lw412.4,lw412.5,lw412.6,lw412.7,lw412.9,lw413,lw413.1,lw413.2,lw439,lw439.5,lw439.6,lw440,lw440.6,lw440.7,lw440.8,lw441,lw441.6,lw441.7,lw441.8,lw441.9,lw442,lw442.1,lw488.5,lw488.9,lw489,lw489.2,lw489.3,lw489.6,lw489.9,lw490,lw490.5,lw490.9,lw491,lw491.1,lw491.2,lw491.3,lw491.4,lw491.5,lw491.6,lw500,lw500.1,lw500.3,lw500.5,lw501,lw501.4,lw530,lw530.3,lw530.4,lw530.5,lw530.6,lw530.7,lw530.8,lw531,lw531.1,lw531.2,lw531.4,lw550,lw550.6,lw550.7,lw551,lw551.1,lw551.3,lw551.4,lw551.5,lw551.6,lw551.7,lw551.8,lw551.9,lw554,lw554.9,lw555,lw555.1,lw555.4,lw666.8,lw667,lw667.6,lw667.7,lw667.8,lw667.9,lw668,lw668.1,lw668.2,lw668.3,lw668.4,lw668.5,lw670,lw674,lw674.2,lw674.9,lw675,lw675.4,lw868.6,lw868.7,lw869,lw869.4,lw869.6,lw869.8,lw869.9,lw870,lw870.1,lw870.2,lw870.5,lw870.8,lw871.9
%       'NewTextFields',{'cruise_name','data_id','date','time',});

% from new aeronet-oc file
%           /fields=cruise_name,date,time,env_file,data_id,latitude,longitude,angstrom,aot862,aot865,aot869,rrs410,rrs412,rrs413,rrs443,rrs486,rrs488,rrs490,rrs531,rrs547,rrs551,rrs555,rrs665,rrs667,rrs670,rrs671,rrs678,rrs681,RAW,raw_angstrom,raw_aot411.2,raw_aot411.3,raw_aot411.7,raw_aot411.8,raw_aot412,raw_aot412.4,raw_aot412.5,raw_aot412.6,raw_aot412.7,raw_aot412.9,raw_aot413,raw_aot413.1,raw_aot413.2,raw_aot439.5,raw_aot439.6,raw_aot440,raw_aot440.6,raw_aot440.7,raw_aot440.8,raw_aot441.6,raw_aot441.7,raw_aot441.8,raw_aot441.9,raw_aot442,raw_aot442.1,raw_aot442.2,raw_aot488.4,raw_aot488.5,raw_aot488.9,raw_aot489,raw_aot489.2,raw_aot489.3,raw_aot489.6,raw_aot489.9,raw_aot490.5,raw_aot490.9,raw_aot491.1,raw_aot491.2,raw_aot491.3,raw_aot491.4,raw_aot491.5,raw_aot491.6,raw_aot500,raw_aot500.1,raw_aot500.3,raw_aot500.5,raw_aot501.4,raw_aot530,raw_aot530.3,raw_aot530.4,raw_aot530.5,raw_aot530.6,raw_aot530.7,raw_aot530.8,raw_aot530.9,raw_aot531,raw_aot531.1,raw_aot531.2,raw_aot531.4,raw_aot550,raw_aot550.6,raw_aot550.7,raw_aot551,raw_aot551.1,raw_aot551.2,raw_aot551.3,raw_aot551.4,raw_aot551.5,raw_aot551.6,raw_aot551.7,raw_aot551.8,raw_aot551.9,raw_aot554.9,raw_aot555,raw_aot555.1,raw_aot555.4,raw_aot666.8,raw_aot667.6,raw_aot667.7,raw_aot667.8,raw_aot667.9,raw_aot668,raw_aot668.1,raw_aot668.2,raw_aot668.3,raw_aot668.4,raw_aot668.5,raw_aot670,raw_aot674.2,raw_aot674.9,raw_aot675,raw_aot675.4,raw_aot868.6,raw_aot868.7,raw_aot869,raw_aot869.4,raw_aot869.6,raw_aot869.8,raw_aot869.9,raw_aot870,raw_aot870.1,raw_aot870.2,raw_aot870.5,raw_aot870.8,raw_aot871.9,raw_aot1017.3,raw_aot1018.4,raw_aot1018.7,raw_aot1018.8,raw_aot1019.3,raw_aot1019.5,raw_aot1019.6,raw_aot1019.7,raw_aot1019.8,raw_aot1019.9,raw_aot1020,raw_aot1020.1,raw_aot1020.3,raw_aot1020.5,raw_aot1020.7,raw_aot1021,raw_aot1021.1,raw_aot1021.4,raw_aot1022.1,raw_es411.2,raw_es411.3,raw_es411.7,raw_es411.8,raw_es412,raw_es412.4,raw_es412.5,raw_es412.6,raw_es412.7,raw_es412.9,raw_es413,raw_es413.1,raw_es413.2,raw_es439.5,raw_es439.6,raw_es440,raw_es440.6,raw_es440.7,raw_es440.8,raw_es441.6,raw_es441.7,raw_es441.8,raw_es441.9,raw_es442,raw_es442.1,raw_es442.2,raw_es488.4,raw_es488.5,raw_es488.9,raw_es489,raw_es489.2,raw_es489.3,raw_es489.6,raw_es489.9,raw_es490.5,raw_es490.9,raw_es491.1,raw_es491.2,raw_es491.3,raw_es491.4,raw_es491.5,raw_es491.6,raw_es500,raw_es500.1,raw_es500.3,raw_es500.5,raw_es501.4,raw_es530,raw_es530.3,raw_es530.4,raw_es530.5,raw_es530.6,raw_es530.7,raw_es530.8,raw_es530.9,raw_es531,raw_es531.1,raw_es531.2,raw_es531.4,raw_es550,raw_es550.6,raw_es550.7,raw_es551,raw_es551.1,raw_es551.2,raw_es551.3,raw_es551.4,raw_es551.5,raw_es551.6,raw_es551.7,raw_es551.8,raw_es551.9,raw_es554.9,raw_es555,raw_es555.1,raw_es555.4,raw_es666.8,raw_es667.6,raw_es667.7,raw_es667.8,raw_es667.9,raw_es668,raw_es668.1,raw_es668.2,raw_es668.3,raw_es668.4,raw_es668.5,raw_es670,raw_es674.2,raw_es674.9,raw_es675,raw_es675.4,raw_es868.6,raw_es868.7,raw_es869,raw_es869.4,raw_es869.6,raw_es869.8,raw_es869.9,raw_es870,raw_es870.1,raw_es870.2,raw_es870.5,raw_es870.8,raw_es871.9,raw_es1017.3,raw_es1018.4,raw_es1018.7,raw_es1018.8,raw_es1019.3,raw_es1019.5,raw_es1019.6,raw_es1019.7,raw_es1019.8,raw_es1019.9,raw_es1020,raw_es1020.1,raw_es1020.3,raw_es1020.5,raw_es1020.7,raw_es1021,raw_es1021.1,raw_es1021.4,raw_es1022.1,raw_lw411.2,raw_lw411.3,raw_lw411.7,raw_lw411.8,raw_lw412,raw_lw412.4,raw_lw412.5,raw_lw412.6,raw_lw412.7,raw_lw412.9,raw_lw413,raw_lw413.1,raw_lw413.2,raw_lw439.5,raw_lw439.6,raw_lw440,raw_lw440.6,raw_lw440.7,raw_lw440.8,raw_lw441.6,raw_lw441.7,raw_lw441.8,raw_lw441.9,raw_lw442,raw_lw442.1,raw_lw442.2,raw_lw488.4,raw_lw488.5,raw_lw488.9,raw_lw489,raw_lw489.2,raw_lw489.3,raw_lw489.6,raw_lw489.9,raw_lw490.5,raw_lw490.9,raw_lw491.1,raw_lw491.2,raw_lw491.3,raw_lw491.4,raw_lw491.5,raw_lw491.6,raw_lw500,raw_lw500.1,raw_lw500.3,raw_lw500.5,raw_lw501.4,raw_lw530,raw_lw530.3,raw_lw530.4,raw_lw530.5,raw_lw530.6,raw_lw530.7,raw_lw530.8,raw_lw530.9,raw_lw531,raw_lw531.1,raw_lw531.2,raw_lw531.4,raw_lw550,raw_lw550.6,raw_lw550.7,raw_lw551,raw_lw551.1,raw_lw551.2,raw_lw551.3,raw_lw551.4,raw_lw551.5,raw_lw551.6,raw_lw551.7,raw_lw551.8,raw_lw551.9,raw_lw554.9,raw_lw555,raw_lw555.1,raw_lw555.4,raw_lw666.8,raw_lw667.6,raw_lw667.7,raw_lw667.8,raw_lw667.9,raw_lw668,raw_lw668.1,raw_lw668.2,raw_lw668.3,raw_lw668.4,raw_lw668.5,raw_lw670,raw_lw674.2,raw_lw674.9,raw_lw675,raw_lw675.4,raw_lw868.6,raw_lw868.7,raw_lw869,raw_lw869.4,raw_lw869.6,raw_lw869.8,raw_lw869.9,raw_lw870,raw_lw870.1,raw_lw870.2,raw_lw870.5,raw_lw870.8,raw_lw871.9,raw_lw1017.3,raw_lw1018.4,raw_lw1018.7,raw_lw1018.8,raw_lw1019.3,raw_lw1019.5,raw_lw1019.6,raw_lw1019.7,raw_lw1019.8,raw_lw1019.9,raw_lw1020,raw_lw1020.1,raw_lw1020.3,raw_lw1020.5,raw_lw1020.7,raw_lw1021,raw_lw1021.1,raw_lw1021.4,raw_lw1022.1
[data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,...
      'NewTextFields',{'cruise_name','date','time','env_file','data_id','latitude','longitude','angstrom','aot862','aot865','aot869'});

h1 = waitbar(0,'Initializing ...');
for idx=1:size(data.date,1)
      station_name = char(data.cruise_name(idx));
      if strcmp(station_name(1:12),'aoc_gageocho')||...
                  strcmp(station_name(1:9),'aoc_ieodo')||...
                  strcmp(station_name(1:14),'aoc_socheongch') % ex: aoc_gageocho_l20_201205 or aoc_ieodo_l20_201312 or aoc_socheongch_l20_201608
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

savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';

fs = 20;
h_412 = figure('Color','white','DefaultAxesFontSize',fs);
h_443 = figure('Color','white','DefaultAxesFontSize',fs);
h_490 = figure('Color','white','DefaultAxesFontSize',fs);
h_555 = figure('Color','white','DefaultAxesFontSize',fs);
h_660 = figure('Color','white','DefaultAxesFontSize',fs);

clear SatData source

source(1).char = 'AERONET_GOCI_R2018_NRL';
source(2).char = 'AERONET_GOCI_R2018_Wang';
source(3).char = 'AERONET_GOCI_R2018_Ahn';
source(4).char = 'AERONET_GOCI_R2018_Uncalibr';
source(5).char = 'AERONET_GOCI_R2018_MA_CV1p5';
source(6).char = 'AERONET_GOCI_R2018_SW_CV1p5';

for idx = 1:size(source,2)
      
      fileID = fopen(['/Users/jconchas/Documents/Research/GOCI/GOCI_AERONET/' source(idx).char '/file_list.txt']);
      
      s = textscan(fileID,'%s','Delimiter','\n');
      fclose(fileID);
      
      for idx0=1:size(s{1},1)
            
            filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_AERONET/' source(idx).char '/' s{1}{idx0}];
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
                        if hours(abs([InSitu(idx_aux).t]-[SatData_used(idx1).datetime]))<0.5 ...
                                    && abs(str2double(InSitu(idx_aux).lat)-SatData_used(idx1).latitude_center_value)<0.05 ...
                                    && abs(str2double(InSitu(idx_aux).lon)-SatData_used(idx1).longitude_center_value)<0.05
                              %                         Ieodo_Station (32N,125E), Gageocho_Station (33N,124E), Socheongcho (37N,125E)
                              
                              Matchup(count).Rrs_412_ins = InSitu(idx_aux).Rrs(2);
                              Matchup(count).datetime_ins = InSitu(idx_aux).t;
                              Matchup(count).station_ins = InSitu(idx_aux).station;
                              
                              station_char = char(InSitu(idx_aux).station);
                              
                              if strcmp(station_char(1:9),'aoc_gageo')
                                    Matchup(count).station_ins_ID = 1;
                              elseif strcmp(station_char(1:9),'aoc_ieodo')
                                    Matchup(count).station_ins_ID = 2;
                              elseif strcmp(station_char(1:9),'aoc_soche')
                                    Matchup(count).station_ins_ID = 3;
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
                              elseif strcmp(station_char(1:9),'aoc_soche')
                                    Matchup(count).station_ins_ID = 3;
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
                              elseif strcmp(station_char(1:9),'aoc_soche')
                                    Matchup(count).station_ins_ID = 3;
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
                              elseif strcmp(station_char(1:9),'aoc_soche')
                                    Matchup(count).station_ins_ID = 3;
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
                              elseif strcmp(station_char(1:9),'aoc_soche')
                                    Matchup(count).station_ins_ID = 3;
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
                              elseif strcmp(station_char(1:9),'aoc_soche')
                                    Matchup(count).station_ins_ID = 3;
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
      
      %% InSitu vs Sat
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
      
      %% latex table
      % !rm ./MyTable.tex
      % FID = fopen('./MyTable.tex','w');
      
      % fprintf(FID,'\\begin{tabular}{ccccccccccccc} \n \\hline \n');
      
      % fprintf(FID, 'Sat (nm) ');
      % fprintf(FID, '& InSitu (nm) ');
      % fprintf(FID, '& $R^2$ ');
      % fprintf(FID, '& Regression ');
      % fprintf(FID, '& RMSE ');
      % fprintf(FID, '& N ');
      % fprintf(FID, '& Mean APD ($\\%%$) ');
      % fprintf(FID, '& St.Dev. APD ($\\%%$) ');
      % fprintf(FID, '& Median APD ($\\%%$) ');
      % fprintf(FID, '& Bias ($\\%%$) ');
      % fprintf(FID, '& Median ratio ');
      % fprintf(FID, '& SIQR ');
      % fprintf(FID, '& rsqcorr ');
      % fprintf(FID,'\\\\ \\hline \n');
      %%
      % savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';
      
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],FID);
      % legend off
      % set(gcf, 'renderer','painters')
      % saveas(gcf,[savedirname 'GOCI_AERO_412'],'epsc')
      
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],FID);
      % legend off
      % set(gcf, 'renderer','painters')
      % saveas(gcf,[savedirname 'GOCI_AERO_443'],'epsc')
      
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],FID);
      % legend off
      % set(gcf, 'renderer','painters')
      % saveas(gcf,[savedirname 'GOCI_AERO_490'],'epsc')
      
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],FID);
      % legend off
      % set(gcf, 'renderer','painters')
      % saveas(gcf,[savedirname 'GOCI_AERO_555'],'epsc')
      
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],FID);
      % legend off
      % set(gcf, 'renderer','painters')
      % saveas(gcf,[savedirname 'GOCI_AERO_660'],'epsc')
      
      % % latex table
      % fprintf(FID,'\\hline \n');
      % fprintf(FID,'\\end{tabular}\n');
      % no data for in situ 678 or 681
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('678','680',[Matchup.Rrs_678_ins],[Matchup.Rrs_680_sat]);
      % [h1,ax1,leg1] = plot_insitu_vs_sat_GOCI('681','680',[Matchup.Rrs_681_ins],[Matchup.Rrs_680_sat]);
      
      
      
      
      %% NRL
      if strcmp(source(idx).char,'AERONET_GOCI_R2018_NRL')
            color_line = [0.0 0.8 1.0]; % almost cyan
            % Rrs_412
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_412,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_443
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_443,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_490
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_490,fs,[0 0.03],source(idx).char);
            legend off
            % Rrs_555
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_555,fs,[0 0.04],source(idx).char);
            legend off
            % Rrs_660
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_660,fs,[0 0.02],source(idx).char);
            legend off
      end
      
      %% Wang
      if strcmp(source(idx).char,'AERONET_GOCI_R2018_Wang')
            color_line = [1.0 0.6 0.0]; % orange
            % Rrs_412
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_412,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_443
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_443,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_490
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_490,fs,[0 0.03],source(idx).char);
            legend off
            % Rrs_555
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_555,fs,[0 0.04],source(idx).char);
            legend off
            % Rrs_660
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_660,fs,[0 0.02],source(idx).char);
            legend off
      end
      %% Ahn
      if strcmp(source(idx).char,'AERONET_GOCI_R2018_Ahn')
            color_line = [0.0 0.8 0.0]; % green
            % Rrs_412
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_412,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_443
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_443,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_490
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_490,fs,[0 0.03],source(idx).char);
            legend off
            % Rrs_555
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_555,fs,[0 0.04],source(idx).char);
            legend off
            % Rrs_660
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_660,fs,[0 0.02],source(idx).char);
            legend off
      end
      %% Uncalibrated
      if strcmp(source(idx).char,'AERONET_GOCI_R2018_Uncalibr')
            color_line = 'b';
            % Rrs_412
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_412,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_443
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_443,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_490
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_490,fs,[0 0.03],source(idx).char);
            legend off
            % Rrs_555
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_555,fs,[0 0.04],source(idx).char);
            legend off
            % Rrs_660
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_660,fs,[0 0.02],source(idx).char);
            legend off
      end
      %% MA
      if strcmp(source(idx).char,'AERONET_GOCI_R2018_MA_CV1p5')
            color_line = 'r';
            % Rrs_412
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_412,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_443
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_443,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_490
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_490,fs,[0 0.03],source(idx).char);
            legend off
            % Rrs_555
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_555,fs,[0 0.04],source(idx).char);
            legend off
            % Rrs_660
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_660,fs,[0 0.02],source(idx).char);
            legend off
      end
      %% SW
      if strcmp(source(idx).char,'AERONET_GOCI_R2018_SW_CV1p5')
            color_line = 'k';
            % Rrs_412
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('412','412',[Matchup.Rrs_412_ins],[Matchup.Rrs_412_sat],[Matchup.Rrs_412_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_412,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_443
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('443','443',[Matchup.Rrs_443_ins],[Matchup.Rrs_443_sat],[Matchup.Rrs_443_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_443,fs,[0 0.02],source(idx).char);
            legend off
            % Rrs_490
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('490','490',[Matchup.Rrs_490_ins],[Matchup.Rrs_490_sat],[Matchup.Rrs_490_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_490,fs,[0 0.03],source(idx).char);
            legend off
            % Rrs_555
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('555','555',[Matchup.Rrs_555_ins],[Matchup.Rrs_555_sat],[Matchup.Rrs_555_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_555,fs,[0 0.04],source(idx).char);
            legend off
            % Rrs_660
            [ax1,leg1] = plot_insitu_vs_sat_GOCI_onlystations('665','660',[Matchup.Rrs_665_ins],[Matchup.Rrs_660_sat],[Matchup.Rrs_660_sat_datetime],[Matchup.station_ins_ID],...
                  color_line,h_660,fs,[0 0.02],source(idx).char);
            legend off
      end
end
%
figure(h_412)
axis([0 15E-3 0 15E-3])
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_412_All'],'epsc')

figure(h_443)
axis([0 16E-3 0 16E-3])
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_443_All'],'epsc')

figure(h_490)
axis([0 22E-3 0 22E-3])
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_490_All'],'epsc')

figure(h_555)
axis([0 25E-3 0 25E-3])
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_555_All'],'epsc')

figure(h_660)
axis([0 10E-3 0 10E-3])
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'GOCI_AERO_660_All'],'epsc')
%%
figure('Color','white');

subplot(5,2,1)
hist([Matchup.Rrs_412_ins])
xlabel('In situ R_{rs}(412)')

subplot(5,2,2)
hist([Matchup.Rrs_412_sat])
xlabel('Satellite R_{rs}(412)')

subplot(5,2,3)
hist([Matchup.Rrs_443_ins])
xlabel('In situ R_{rs}(443)')

subplot(5,2,4)
hist([Matchup.Rrs_443_sat])
xlabel('Satellite R_{rs}(443)')

subplot(5,2,5)
hist([Matchup.Rrs_490_ins])
xlabel('In situ R_{rs}(490)')

subplot(5,2,6)
hist([Matchup.Rrs_490_sat])
xlabel('Satellite R_{rs}(490)')

subplot(5,2,7)
hist([Matchup.Rrs_555_ins])
xlabel('In situ R_{rs}(555)')

subplot(5,2,8)
hist([Matchup.Rrs_555_sat])
xlabel('Satellite R_{rs}(555)')

subplot(5,2,9)
hist([Matchup.Rrs_665_ins])
xlabel('In situ R_{rs}(665)')

subplot(5,2,10)
hist([Matchup.Rrs_660_sat])
xlabel('Satellite R_{rs}(660)')


%% Histograms
figure,hist([SatData_used.Rrs_490_filtered_mean],20)

figure,hist([SatData_used.angstrom_filtered_mean],20)

figure,hist([SatData_used.center_az],20)
figure,hist([SatData_used.center_el],20)

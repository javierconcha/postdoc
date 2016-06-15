% Script to find Landsat 8 matchups for Rrs based on in situ data from
% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';
%% Load in situ data: Extract AERONET Rrs data from SeaBASS file
clear InSitu
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/L8_Rrs_Matchups_AERONET/';

count = 0;

h1 = waitbar(0,'Initializing ...');

filename = 'val1464210174176624_Rrs_original.csv';

filepath = [dirname filename];

[data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,'NewTextFields',{'date_time','cruise_name','file_name'});

for idx=1:size(data.date_time,1)
      waitbar(idx/size(data.date_time,1),h1,'Creating In Situ cells...')
      %% Rrs
      
      Rrs = [data.insitu_rrs412(idx),data.insitu_rrs443(idx),data.insitu_rrs488(idx),...
            data.insitu_rrs531(idx),data.insitu_rrs547(idx),data.insitu_rrs667(idx),data.insitu_rrs678(idx)];
      wavelength = [412,443,488,531,547,667,678];
      
      count = count+1;
      %       InSitu(count).station = data.station;
      InSitu(count).start_date = datetime(data.date_time(idx),'Format','yyyyMMdd');
      InSitu(count).start_time = datetime(data.date_time(idx),'Format','HH:mm:ss');
      %       InSitu(count).filepath = filepath;
      InSitu(count).wavelength = wavelength;
      InSitu(count).Rrs = Rrs;
      InSitu(count).lat = data.latitude(idx);
      InSitu(count).lon = data.longitude(idx);
      InSitu(count).t = datetime(data.date_time(idx));
      
      %       fprintf('%i %s\n',idx,char(data.date_time(idx)))
end
close(h1)

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
ax = worldmap('World');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
plotm(cell2mat({InSitu.lat}'),cell2mat({InSitu.lon}'),'*r')


%% Find path and row for in situ data and select the image
% Create structure DB (database) with the potential scene path and row based on the lat and lon of the
% in situ data obtained from OpenSeaBASSfile_Main.m. Note: some paths and
% rows could be not valid because they are only over water and Landsat does
% not acquired images over only water.
% For each image, there could be several indexes associated to the in situ data
clear DB
clc
load('WRS2_pathrow_struct.mat');
h1 = waitbar(0,'Initializing ...');

tic
firsttime = true;
days_offset = 3;
db_idx = 0;
cond_in = zeros(1,size(WRS_struct,2));
for d = 1:size(InSitu,2)
      waitbar(d/size(InSitu,2),h1,'Determining paths and rows...')
      %% Check if it is inside the polygon
      for u = 1:size(WRS_struct,2)
            xv = [WRS_struct(u).LON_LL WRS_struct(u).LON_LR ...
                  WRS_struct(u).LON_UR WRS_struct(u).LON_UL WRS_struct(u).LON_LL];
            yv = [WRS_struct(u).LAT_LL WRS_struct(u).LAT_LR ...
                  WRS_struct(u).LAT_UR WRS_struct(u).LAT_UL WRS_struct(u).LAT_LL];
            x =InSitu(d).lon; y = InSitu(d).lat;
            cond_in(u) = inpolygon(x,y,xv,yv);
            
      end
      cond_in = logical(cond_in);
      aux_pr = [WRS_struct(cond_in).PATH;WRS_struct(cond_in).ROW];
      
      %% Only save when it is not in the database (DB)
      
      for i=1:sum(cond_in) % index for aux_pr: potential combinations of pairs of paths and rows
            % Initialize DB (database)
            %             i
            if firsttime
                  %                   disp('First time...')
                  for j=1:sum(cond_in)
                        db_idx = db_idx+1;
                        DB(db_idx).PATH = aux_pr(1,j);
                        DB(db_idx).ROW  = aux_pr(2,j);
                        DB(db_idx).YEAR = InSitu(d).t.Year;
                        DB(db_idx).MONTH= InSitu(d).t.Month;
                        DB(db_idx).DAY  = InSitu(d).t.Day;
                        DB(db_idx).insituidx  = d;
                  end
            else
                  for j=1:size(DB,2) % Check DB for duplicates
                        %                         j
                        if DB(j).PATH==aux_pr(1,i) && ...
                                    DB(j).ROW== aux_pr(2,i) &&...
                                    DB(j).YEAR == InSitu(d).t.Year &&...
                                    DB(j).MONTH== InSitu(d).t.Month &&...
                                    DB(j).DAY  == InSitu(d).t.Day &&...
                                    datenum(datetime([DB(db_idx).YEAR DB(db_idx).MONTH DB(db_idx).DAY]))+datenum(days_offset)...
                                    >datenum(datetime([InSitu(d).t.Year InSitu(d).t.Month InSitu(d).t.Day]))
                              
                              %                               disp('Duplicate found...')
                              DB(j).insituidx(size(DB(j).insituidx,2)+1) = d;
                              break
                        elseif j== size(DB,2)
                              db_idx = db_idx+1;
                              DB(db_idx).PATH = aux_pr(1,i);
                              DB(db_idx).ROW  = aux_pr(2,i);
                              DB(db_idx).YEAR = InSitu(d).t.Year;
                              DB(db_idx).MONTH= InSitu(d).t.Month;
                              DB(db_idx).DAY  = InSitu(d).t.Day;
                              DB(db_idx).insituidx  = d;
                        end
                        
                  end
            end
            if firsttime
                  firsttime = false;
                  break
            end
      end
end
close(h1)
T=toc;
disp(['Seconds: ' num2str(T/60) ' minutes.'])
clear T

% [C,IA,IC] = unique([DB(:).PATH;DB(:).ROW]','rows');
% unique([DB(:).PATH;DB(:).ROW;DB(:).YEAR;DB(:).MONTH;DB(:).DAY]','rows')
%%
% To search for the available Landsat 8 scene and make sure the path and
% row is acquired by the sensor. Note: this process takes a long time
clear Matchup
tic
h2 = waitbar(0,'Initializing ...');
idx_match = 0;
for n=1:size(DB,2) %  how many path and row combinations
      waitbar(n/size(DB,2),h2,'Looking for Matchups')
      if datenum(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY]))-datenum(days_offset) >= datenum(2013,2,11) % date must be larger than Landsat 8 first scene
            %% landsat.m is a script written by Chad A. Greene of the University of Texas at Austin's and available online.
            % it checks if there is a jpg image associated with the scene
            % on the USGS server.
            [~,ImageDate,~,~] = landsat(DB(n).PATH,DB(n).ROW,datestr(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY])+days_offset),'nomap');
            if ~isempty(ImageDate)
                  if ImageDate >= datenum(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY]))-datenum(days_offset)
                        
                        for idx1 = 1:length(DB(n).insituidx(:))
                              disp('--------------------------------------------')
                              disp(['In situ taken: ',datestr(InSitu(DB(n).insituidx(idx1)).t)])
                              
                              disp(['Image taken:   ',datestr(ImageDate)])
                              
                              fprintf('path:%i , row:%i, d:%i\n',DB(n).PATH,DB(n).ROW,DB(n).insituidx(idx1))
                              da = datevec(ImageDate);
                              v = datenum(da);
                              DOY = v - datenum(da(:,1), 1,0);
                              L8id = ['LC8',sprintf('%03.f',DB(n).PATH),sprintf('%03.f',DB(n).ROW),sprintf('%03.f',da(:,1)),...
                                    sprintf('%03.f',DOY),'LGN00'] ;
                              fprintf('ID: %s\n',L8id)
                              % Save it in a structure
                              idx_match = idx_match + 1;
                              Matchup(idx_match).number_d = DB(n).insituidx(idx1);
                              Matchup(idx_match).id_scene = L8id;
                        end
                  end
            end
      end
end
close(h2)
% clear aux_idx aux_pr cond_in d db_idx firsttime h1 h2 i idx_match ImageDate j n u x xv y yv
T=toc;
disp(['Seconds: ' num2str(T/60) ' minutes.'])
clear T
save('L8Matchups_AERONET_Rrs.mat','InSitu','Matchup','DB')

%% Create idlatlon_list.txt to process images only around the ROI
A = {Matchup.id_scene}';
B = {InSitu(cell2mat({Matchup.number_d})).lat}';
C = {InSitu(cell2mat({Matchup.number_d})).lon}';
D = [A B C];

fileID = fopen('idlatlon_list.txt','w');

formatSpec = '%s %4.6f %4.6f\n';

[nrows,ncols] = size(D);
for row = 1:nrows
      fprintf(fileID,formatSpec,D{row,:});
end

fclose(fileID);

type idlatlon_list.txt

clear A B C D

%% Look in the Matchup structure the best images previously selected by visual inspection
% using landsat.m and plot the jpg image and the in situ data location

% dirname = '/Volumes/Data/OLI/L8_Rrs_Matchups_AERONET/';
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/L8_Rrs_Matchups_AERONET/L8_Rrs_Matchups_AERONET_L2/';

fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n'); % list with all the Landsat 8 scenes
fclose(fileID);

for n = 1:size(s{:},1)
      %%
      disp('----------------------------------')
      disp(s{1}{n})
      for i=1:size(Matchup,2)
            if s{1}{n} == Matchup(i).id_scene
                  filepath = [dirname  Matchup(i).id_scene '_MTL.txt'];
                  if exist(filepath, 'file');
                        parval_DATE = GetParMTL(filepath,'DATE_ACQUIRED');
                        parval_TIME = GetParMTL(filepath,'SCENE_CENTER_TIME');
                        if parval_TIME(1) == '"'
                              tc = textscan(parval_TIME,'%s','Delimiter','"'); % I can or cannot have "" delimiters
                              tc = tc{:}{2};
                              tc = tc(1:8);
                        else
                              tc = textscan(parval_TIME,'%s');
                              tc = tc{:}{1};
                              tc = tc(1:8);
                        end
                        
                        taux = datetime(parval_DATE,'ConvertFrom','yyyy-mm-dd');
                        taux = datetime([char(taux) ' ' tc],'ConvertFrom','yyyymmdd');
                        %% Assign scene time from MTL
                        Matchup(i).scenetime = taux;
                        clear taux tc parval_DATE parval_TIME
                        disp('Found it!')
                        disp(Matchup(i))
                        break
                  else
                        % File does not exist.
                        warningMessage = sprintf('Warning: file does not exist:\n%s\n', fullFileName);
                        uiwait(msgbox(warningMessage));
                  end
            end
      end
      path = str2double(s{1}{n}(4:6));
      row  = str2double(s{1}{n}(7:9));
      year = str2double(s{1}{n}(10:13));
      doy  = str2double(s{1}{n}(14:16));
      [yy mm dd] = datevec(datenum(year,1,doy));
      str= datestr(datenum([yy mm dd]),'yyyy-mm-dd');
      t_acq = datetime(str,'InputFormat','yyyy-MM-dd');
      %       str2 = datestr(t_acq);
      
      %       h1 = figure(1000);
      % lansat.m to check the USGS server for jpg images as proxy to scenes available
      %       [~,~,~,h] = landsat(path,row,str);
      
      %       figure(gcf)
      %       set(gcf,'Color','white','Name',s{1}{n})
      %       plotm([InSitu(Matchup(i).number_d).lat],[InSitu(Matchup(i).number_d).lon],'*-r')
      
      t_diff = [InSitu(Matchup(i).number_d).t] - t_acq;
      
      [Y,I] = min(abs(t_diff));
      
      str2 = datestr(Matchup(i).scenetime);
      str3 = sprintf('Taken: %s, Closest in Situ: %s, Diff: %s',str2,datestr(InSitu(Matchup(i).number_d(I)).t),char(t_diff(I)));
      
      %       title(str3)
      
      disp(['Acquired Date:' str2])
      disp('In situ:')
      InSitu(Matchup(i).number_d).t
      [InSitu(Matchup(i).number_d).lat,InSitu(Matchup(i).number_d).lon]
      
      %       close(h1)
      
end

%% Find valid matchups

L2ext = {'_L2n1.nc','_L2n2.nc','_L2n1SWIR5x5.nc','_L2n2SWIR5x5.nc'};

debug = 0;

for idx0 = 1:size(L2ext,2)
      count = 0;
      clear MatchupReal
      h2 = waitbar(0,'Initializing ...');
      for idx = 1:size(Matchup,2)
            waitbar(idx/size(Matchup,2),h2,'Looking for Real Matchups')
            if ~isempty(Matchup(idx).scenetime) % only the paths and rows that are valid have a scene id
                  %% Open ag_412 product and plot
                  filepath = [dirname Matchup(idx).id_scene char(L2ext(idx0))]; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
                  longitude   = ncread(filepath,'/navigation_data/longitude');
                  latitude    = ncread(filepath,'/navigation_data/latitude');
                  Rrs_443 = ncread(filepath,'/geophysical_data/Rrs_443');
                  Rrs_482 = ncread(filepath,'/geophysical_data/Rrs_482');
                  Rrs_561 = ncread(filepath,'/geophysical_data/Rrs_561');
                  Rrs_655 = ncread(filepath,'/geophysical_data/Rrs_655');
                  
                  %% Plot in situ and obtain value from the product
                  for idx2 = 1:size(Matchup(idx).number_d,1) % each scene could have several field points
                        %% closest distance
                        % latitude and longitude are arrays of MxN
                        % lat0 and lon0 is the coordinates of one point
                        lat0 = InSitu(Matchup(idx).number_d(idx2)).lat;
                        lon0 = InSitu(Matchup(idx).number_d(idx2)).lon;
                        dist_squared = (latitude-lat0).^2 + (longitude-lon0).^2;
                        [m,I] = min(dist_squared(:));
                        [r,c]=ind2sub(size(latitude),I); % index to the closest in the latitude and longitude arrays
                        clear lat0 lon0 m I dist_squared
                        
                        if ~isnan(Rrs_443(r,c))
                              count = count+1;
                              
                              if debug
                                    fprintf('idx=%i,idx2=%i,count=%i\n',idx,idx2,count)
                              end
                              MatchupReal(count).Rrs_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs;
                              MatchupReal(count).Rrs_412_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(1);
                              MatchupReal(count).Rrs_443_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(2);
                              MatchupReal(count).Rrs_488_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(3);
                              MatchupReal(count).Rrs_531_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(4);
                              MatchupReal(count).Rrs_547_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(5);
                              MatchupReal(count).Rrs_667_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(6);
                              MatchupReal(count).Rrs_678_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(7);
                              MatchupReal(count).wavelength_insitu = InSitu(Matchup(idx).number_d(idx2)).wavelength;
                              MatchupReal(count).insitu_idx = Matchup(idx).number_d(idx2);
                              MatchupReal(count).id_scene = Matchup(idx).id_scene;
                              MatchupReal(count).scenetime = Matchup(idx).scenetime;
                              MatchupReal(count).insitutime = InSitu(Matchup(idx).number_d(idx2)).t;
                              
                              
                              ws = 3; % window size:3, 5, or 7
                              
                              %% Rrs_443
                              % Filtered Mean = [sum_i(1.5*std-mean)<xi<(1.5*std+mean)]/N from Maninno et al. 2014
                              if r-1 == 0 || c-1 ==0 || r == size(Rrs_443,1) || c == size(Rrs_443,2)
                                    warning('Window indices out of range...')
                              end
                              
                              window = Rrs_443(r-(ws-1)/2:r+(ws-1)/2,c-(ws-1)/2:c+(ws-1)/2);
                              window_mean = nanmean(window(:)); % only non NaN values
                              window_std = nanstd(window(:));
                              
                              % indices to the cells that pass the filter
                              xi_idx = (window > (window_mean-1.5*window_std)) &...
                                    (window < (window_mean+1.5*window_std)) &...
                                    ~isnan(window); % to exclude NaN
                              
                              window_filt = window(xi_idx(:));
                              
                              CV = std(window_filt)/mean(window_filt);
                              
                              MatchupReal(count).Rrs_443_mean = window_mean;
                              MatchupReal(count).Rrs_443_meadian = nanmedian(window(:));
                              MatchupReal(count).Rrs_443_std = window_std;
                              MatchupReal(count).Rrs_443_center = Rrs_443(r,c);
                              
                              if CV < 0.15 && size(window_filt,1)>=5 % filter outliers and at least 5 pixels form the 3x3 pixel arrays (from Mannino at al. 2014)
                                    MatchupReal(count).Rrs_443_filt_mean = mean(window_filt);
                                    MatchupReal(count).Rrs_443_filt_std = std(window_filt);
                                    
                              else
                                    if debug
                                          warning('CV < 0.15. Rrs_443 not valid.')
                                    end
                                    MatchupReal(count).Rrs_443_filt_mean = NaN;
                                    MatchupReal(count).Rrs_443_filt_std = NaN;
                              end
                              
                              MatchupReal(count).Rrs_443_filt_min = min(window_filt);
                              MatchupReal(count).Rrs_443_filt_max = max(window_filt);
                              MatchupReal(count).Rrs_443_valid_px = sum(~isnan(window(:)));
                              MatchupReal(count).Rrs_443_filt_px_count = sum(~isnan(window_filt(:)));
                              MatchupReal(count).Rrs_443_window = window;
                              MatchupReal(count).Rrs_443_CV = CV;
                              
                              %% Rrs_482
                              % Filtered Mean = [sum_i(1.5*std-mean)<xi<(1.5*std+mean)]/N from Maninno et al. 2014
                              if r-1 == 0 || c-1 ==0 || r == size(Rrs_482,1) || c == size(Rrs_482,2)
                                    warning('Window indices out of range...')
                              end
                              
                              window = Rrs_482(r-(ws-1)/2:r+(ws-1)/2,c-(ws-1)/2:c+(ws-1)/2);
                              window_mean = nanmean(window(:)); % only non NaN values
                              window_std = nanstd(window(:));
                              
                              % indices to the cells that pass the filter
                              xi_idx = (window > (window_mean-1.5*window_std)) &...
                                    (window < (window_mean+1.5*window_std)) &...
                                    ~isnan(window); % to exclude NaN
                              
                              window_filt = window(xi_idx(:));
                              
                              CV = std(window_filt)/mean(window_filt);
                              
                              MatchupReal(count).Rrs_482_mean = window_mean;
                              MatchupReal(count).Rrs_482_meadian = nanmedian(window(:));
                              MatchupReal(count).Rrs_482_std = window_std;
                              MatchupReal(count).Rrs_482_center = Rrs_482(r,c);
                              
                              if CV < 0.15 && size(window_filt,1)>=5 % filter outliers and at least 5 pixels form the 3x3 pixel arrays (from Mannino at al. 2014)
                                    MatchupReal(count).Rrs_482_filt_mean = mean(window_filt);
                                    MatchupReal(count).Rrs_482_filt_std = std(window_filt);
                                    
                              else
                                    if debug
                                          warning('CV < 0.15. Rrs_482 not valid.')
                                    end
                                    MatchupReal(count).Rrs_482_filt_mean = NaN;
                                    MatchupReal(count).Rrs_482_filt_std = NaN;
                              end
                              
                              MatchupReal(count).Rrs_482_filt_min = min(window_filt);
                              MatchupReal(count).Rrs_482_filt_max = max(window_filt);
                              MatchupReal(count).Rrs_482_valid_px = sum(~isnan(window(:)));
                              MatchupReal(count).Rrs_482_filt_px_count = sum(~isnan(window_filt(:)));
                              MatchupReal(count).Rrs_482_window = window;
                              MatchupReal(count).Rrs_482_CV = CV;
                              %% Rrs_561
                              % Filtered Mean = [sum_i(1.5*std-mean)<xi<(1.5*std+mean)]/N from Maninno et al. 2014
                              if r-1 == 0 || c-1 ==0 || r == size(Rrs_561,1) || c == size(Rrs_561,2)
                                    warning('Window indices out of range...')
                              end
                              
                              window = Rrs_561(r-(ws-1)/2:r+(ws-1)/2,c-(ws-1)/2:c+(ws-1)/2);
                              window_mean = nanmean(window(:)); % only non NaN values
                              window_std = nanstd(window(:));
                              
                              % indices to the cells that pass the filter
                              xi_idx = (window > (window_mean-1.5*window_std)) &...
                                    (window < (window_mean+1.5*window_std)) &...
                                    ~isnan(window); % to exclude NaN
                              
                              window_filt = window(xi_idx(:));
                              
                              CV = std(window_filt)/mean(window_filt);
                              
                              MatchupReal(count).Rrs_561_mean = window_mean;
                              MatchupReal(count).Rrs_561_meadian = nanmedian(window(:));
                              MatchupReal(count).Rrs_561_std = window_std;
                              MatchupReal(count).Rrs_561_center = Rrs_561(r,c);
                              
                              if CV < 0.15 && size(window_filt,1)>=5 % filter outliers and at least 5 pixels form the 3x3 pixel arrays (from Mannino at al. 2014)
                                    MatchupReal(count).Rrs_561_filt_mean = mean(window_filt);
                                    MatchupReal(count).Rrs_561_filt_std = std(window_filt);
                                    
                              else
                                    if debug
                                          warning('CV < 0.15. Rrs_561 not valid.')
                                    end
                                    MatchupReal(count).Rrs_561_filt_mean = NaN;
                                    MatchupReal(count).Rrs_561_filt_std = NaN;
                              end
                              
                              MatchupReal(count).Rrs_561_filt_min = min(window_filt);
                              MatchupReal(count).Rrs_561_filt_max = max(window_filt);
                              MatchupReal(count).Rrs_561_valid_px = sum(~isnan(window(:)));
                              MatchupReal(count).Rrs_561_filt_px_count = sum(~isnan(window_filt(:)));
                              MatchupReal(count).Rrs_561_window = window;
                              MatchupReal(count).Rrs_561_CV = CV;
                              %% Rrs_655
                              % Filtered Mean = [sum_i(1.5*std-mean)<xi<(1.5*std+mean)]/N from Maninno et al. 2014
                              if r-1 == 0 || c-1 ==0 || r == size(Rrs_655,1) || c == size(Rrs_655,2)
                                    warning('Window indices out of range...')
                              end
                              
                              window = Rrs_655(r-(ws-1)/2:r+(ws-1)/2,c-(ws-1)/2:c+(ws-1)/2);
                              window_mean = nanmean(window(:)); % only non NaN values
                              window_std = nanstd(window(:));
                              
                              % indices to the cells that pass the filter
                              xi_idx = (window > (window_mean-1.5*window_std)) &...
                                    (window < (window_mean+1.5*window_std)) &...
                                    ~isnan(window); % to exclude NaN
                              
                              window_filt = window(xi_idx(:));
                              
                              CV = std(window_filt)/mean(window_filt);
                              
                              MatchupReal(count).Rrs_655_mean = window_mean;
                              MatchupReal(count).Rrs_655_meadian = nanmedian(window(:));
                              MatchupReal(count).Rrs_655_std = window_std;
                              MatchupReal(count).Rrs_655_center = Rrs_655(r,c);
                              
                              if CV < 0.15 && size(window_filt,1)>=5 % filter outliers and at least 5 pixels form the 3x3 pixel arrays (from Mannino at al. 2014)
                                    MatchupReal(count).Rrs_655_filt_mean = mean(window_filt);
                                    MatchupReal(count).Rrs_655_filt_std = std(window_filt);
                                    
                              else
                                    if debug
                                          warning('CV < 0.15. Rrs_655 not valid.')
                                    end
                                    MatchupReal(count).Rrs_655_filt_mean = NaN;
                                    MatchupReal(count).Rrs_655_filt_std = NaN;
                              end
                              
                              MatchupReal(count).Rrs_655_filt_min = min(window_filt);
                              MatchupReal(count).Rrs_655_filt_max = max(window_filt);
                              MatchupReal(count).Rrs_655_valid_px = sum(~isnan(window(:)));
                              MatchupReal(count).Rrs_655_filt_px_count = sum(~isnan(window_filt(:)));
                              MatchupReal(count).Rrs_655_window = window;
                              MatchupReal(count).Rrs_655_CV = CV;
                              %%
                        else
                              Matchup(idx).Rrs_443(idx2) = NaN;
                              Matchup(idx).Rrs_482(idx2) = NaN;
                              Matchup(idx).Rrs_561(idx2) = NaN;
                              Matchup(idx).Rrs_655(idx2) = NaN;
                              
                        end
                  end
                  clear latitude longitude Rrs_443 Rrs_482 Rrs_561 Rrs_655 CV window window_filt xi_idx window_mean window_std r c
            end
      end
      
      close(h2)
      
      save('L8Matchups_AERONET_Rrs.mat','InSitu','Matchup','DB','MatchupReal')
%       %% Plot retrieved vs in situ for all and less than 3 hours or 1 day
%       % load('L8Matchups_Arctics.mat','Matchup','MatchupReal')
%       t_diff = [MatchupReal(:).scenetime]-[MatchupReal(:).insitutime];
%       cond1 = abs(t_diff) <= days(1); % days(1) or hours(3)
%       cond2 = abs(t_diff) <= hours(3); % days(1) or hours(3)
%       
%       fprintf('Matchups less than 3 days: %i\n',size(t_diff,2))
%       fprintf('Matchups less than 1 day: %i\n',sum(cond1))
%       fprintf('Matchups less than 3 hours: %i\n',sum(cond2))
%       
%       fs = 16;
%       figure('Color','white','DefaultAxesFontSize',fs)
%       plot(t_diff,'*-k')
%       hold on
%       plot(find(cond1),t_diff(cond1),'*r')
%       plot(find(cond2),t_diff(cond2),'*b')
%       grid on
%       legend('3 days','1 day','3 hours')
      
      %% filtered
      which_time_range = {'3 days','1 day','3 hours'};
      
      for idx = 1:size(which_time_range,2)
            
            disp('-----------------------------------------')
            disp(['ACO scheme: ' char(L2ext(idx0))])
            
            fs = 16;
            f1 = figure('Color','white','DefaultAxesFontSize',fs,'Name',[char(which_time_range(idx)) char(L2ext(idx0))]);
            
            [h1,ax1,leg1] = plot_insitu_vs_sat('443','443',MatchupReal,char(which_time_range(idx))); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            [h2,ax2,leg2] = plot_insitu_vs_sat('482','488',MatchupReal,char(which_time_range(idx))); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            [h3,ax3,leg3] = plot_insitu_vs_sat('561','547',MatchupReal,char(which_time_range(idx))); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            [h4,ax4,leg4] = plot_insitu_vs_sat('655','667',MatchupReal,char(which_time_range(idx))); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            
            
            figure(f1)
            copies = copyobj([ax1,leg1],f1);
            ax1_copy = copies(1);
            subplot(2,2,1,ax1_copy)
            
            copies = copyobj([ax2,leg2],f1);
            ax2_copy = copies(1);
            subplot(2,2,2,ax2_copy)
            
            copies = copyobj([ax3,leg3],f1);
            ax3_copy = copies(1);
            subplot(2,2,3,ax3_copy)
            
            copies = copyobj([ax4,leg4],f1);
            ax4_copy = copies(1);
            subplot(2,2,4,ax4_copy)
            
            figure(h1)
            close
            figure(h2)
            close
            figure(h3)
            close
            figure(h4)
            close
            
      end
end
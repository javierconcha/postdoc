% Script to find Landsat 8 matchups for Rrs based on in situ data from
% AERONET-OC from SeaDAS Matchups
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';
% %% Load in situ data: Extract AERONET Rrs data from SeaBASS file
% clear InSitu
% dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/L8_Rrs_Matchups_AERONET/';
% % dirname = '/Volumes/Data/OLI/L8_Rrs_Matchups_AERONET/';
%
% count = 0;
%
% % filename = 'val1464210174176624_Rrs_original.csv';
% filename = 'aeronet_oc_env_data.txt';
%
% filepath = [dirname filename];
%
% [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,...
%       'NewTextFields',{'cruise_name','data_id','date','time',});
% % [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,'NewTextFields',{'date_time','cruise_name','file_name'});
%
% % Preallocation
% InSitu(size(data.date,1)).station = '';
%
% h1 = waitbar(0,'Initializing ...');
% for idx=1:size(data.date,1)
%       waitbar(idx/size(data.date,1),h1,'Creating In Situ cells...')
%       %% Rrs
%
%       %       Rrs = [data.insitu_rrs412(idx),data.insitu_rrs443(idx),data.insitu_rrs488(idx),...
%       %             data.insitu_rrs531(idx),data.insitu_rrs547(idx),data.insitu_rrs667(idx),data.insitu_rrs678(idx)];
%       %       wavelength = [412,443,488,531,547,667,678];
%
%       Rrs = [data.rrs410(idx),data.rrs412(idx),data.rrs413(idx),data.rrs443(idx),data.rrs486(idx),data.rrs488(idx),data.rrs490(idx),data.rrs531(idx),data.rrs547(idx),data.rrs551(idx),data.rrs555(idx),data.rrs665(idx),data.rrs667(idx),data.rrs670(idx),data.rrs671(idx),data.rrs678(idx),data.rrs681(idx)];
%       wavelength = [410,412,413,443,486,488,490,531,547,551,555,665,667,670,671,678,681];
%
%       count = count+1;
%
%       time_acquired = datestr(data.time(idx),'HH:MM:ss');
%       t_date = datetime(data.date(idx),'Format','yyyy-MM-dd');
%       t = char(t_date);
%       t = [t(:,1:10) ' ' time_acquired];
%       t = datetime(t,'ConvertFrom','yyyymmdd');
%
%       InSitu(count).station = data.cruise_name(idx);
%       InSitu(count).data_id = data.data_id(idx);
%       %       InSitu(count).start_date = t_date;
%       % %       InSitu(count).start_time =
%       % datetime(data.time(idx),'Format','HH:mm:ss');
%       %       InSitu(count).start_time = time_acquired;
%       %       InSitu(count).filepath = filepath;
%       InSitu(count).wavelength = wavelength;
%       InSitu(count).Rrs = Rrs;
%       InSitu(count).lat = data.latitude(idx);
%       InSitu(count).lon = data.longitude(idx);
%       InSitu(count).t = t;
%
%       %       fprintf('%i %s\n',idx,char(data.date_time(idx)))
% end
% close(h1)
%
% %% figure for plottig the data
% Rrs = cell2mat({InSitu.Rrs});
% wavelength = cell2mat({InSitu.wavelength});
%
% figure('Color','white')
% ylabel('Rrs (1/sr)')
% xlabel('wavelength (nm)')
% hold on
% plot(wavelength,Rrs);
% grid on
% title('Rrs')
% %% Plot Location
% figure('Color','white')
% ax = worldmap('World');
% load coastlines
% geoshow(ax, coastlat, coastlon,...
%       'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
% geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
% geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% plotm(cell2mat({InSitu.lat}'),cell2mat({InSitu.lon}'),'*r')
%
%
% %% Find path and row for in situ data and select the image
% % Create structure DB (database) with the potential scene path and row based on the lat and lon of the
% % in situ data obtained from OpenSeaBASSfile_Main.m. Note: some paths and
% % rows could be not valid because they are only over water and Landsat does
% % not acquired images over only water.
% % For each image, there could be several indexes associated to the in situ data
% clear DB
% clc
% load('WRS2_pathrow_struct.mat');
% h1 = waitbar(0,'Initializing ...');
%
% tic
% firsttime = true;
% days_offset = 3;
% db_idx = 0;
% cond_in = zeros(1,size(WRS_struct,2));
% for d = 1:size(InSitu,2)
%       waitbar(d/size(InSitu,2),h1,'Determining paths and rows...')
%       %% Check if it is inside the polygon
%       for u = 1:size(WRS_struct,2)
%             xv = [WRS_struct(u).LON_LL WRS_struct(u).LON_LR ...
%                   WRS_struct(u).LON_UR WRS_struct(u).LON_UL WRS_struct(u).LON_LL];
%             yv = [WRS_struct(u).LAT_LL WRS_struct(u).LAT_LR ...
%                   WRS_struct(u).LAT_UR WRS_struct(u).LAT_UL WRS_struct(u).LAT_LL];
%             x =InSitu(d).lon; y = InSitu(d).lat;
%             cond_in(u) = inpolygon(x,y,xv,yv);
%
%       end
%       cond_in = logical(cond_in);
%       aux_pr = [WRS_struct(cond_in).PATH;WRS_struct(cond_in).ROW];
%
%       %% Only save when it is not in the database (DB)
%
%       for i=1:sum(cond_in) % index for aux_pr: potential combinations of pairs of paths and rows
%             % Initialize DB (database)
%             %             i
%             if firsttime
%                   %                   disp('First time...')
%                   for j=1:sum(cond_in)
%                         db_idx = db_idx+1;
%                         DB(db_idx).PATH = aux_pr(1,j);
%                         DB(db_idx).ROW  = aux_pr(2,j);
%                         DB(db_idx).YEAR = InSitu(d).t.Year;
%                         DB(db_idx).MONTH= InSitu(d).t.Month;
%                         DB(db_idx).DAY  = InSitu(d).t.Day;
%                         DB(db_idx).insituidx  = d;
%                   end
%             else
%                   for j=1:size(DB,2) % Check DB for duplicates
%                         %                         j
%                         if DB(j).PATH==aux_pr(1,i) && ...
%                                     DB(j).ROW== aux_pr(2,i) &&...
%                                     DB(j).YEAR == InSitu(d).t.Year &&...
%                                     DB(j).MONTH== InSitu(d).t.Month &&...
%                                     DB(j).DAY  == InSitu(d).t.Day &&...
%                                     datenum(datetime([DB(db_idx).YEAR DB(db_idx).MONTH DB(db_idx).DAY]))+datenum(days_offset)...
%                                     >datenum(datetime([InSitu(d).t.Year InSitu(d).t.Month InSitu(d).t.Day]))
%
%                               %                               disp('Duplicate found...')
%                               DB(j).insituidx(size(DB(j).insituidx,2)+1) = d;
%                               break
%                         elseif j== size(DB,2)
%                               db_idx = db_idx+1;
%                               DB(db_idx).PATH = aux_pr(1,i);
%                               DB(db_idx).ROW  = aux_pr(2,i);
%                               DB(db_idx).YEAR = InSitu(d).t.Year;
%                               DB(db_idx).MONTH= InSitu(d).t.Month;
%                               DB(db_idx).DAY  = InSitu(d).t.Day;
%                               DB(db_idx).insituidx  = d;
%                         end
%
%                   end
%             end
%             if firsttime
%                   firsttime = false;
%                   break
%             end
%       end
% end
% close(h1)
% T=toc;
% disp(['Seconds: ' num2str(T/60) ' minutes.'])
% clear T
%
% % [C,IA,IC] = unique([DB(:).PATH;DB(:).ROW]','rows');
% % unique([DB(:).PATH;DB(:).ROW;DB(:).YEAR;DB(:).MONTH;DB(:).DAY]','rows')
% %
% %% To search for the available Landsat 8 scene and make sure the path and
% % row is acquired by the sensor. For each in situ point, there is one element in Matchup.
% % Therefore, there could be multiple elements for one single scene. Note: this process takes a long time
% clear Matchup
% tic
% h2 = waitbar(0,'Initializing ...');
% idx_match = 0;
% for n=1:size(DB,2) %  how many path and row combinations
%       waitbar(n/size(DB,2),h2,'Looking for Matchups')
%       if datenum(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY]))-datenum(days_offset) >= datenum(2013,2,11) % date must be larger than Landsat 8 first scene
%             %% landsat.m is a script written by Chad A. Greene of the University of Texas at Austin's and available online.
%             % it checks if there is a jpg image associated with the scene
%             % on the USGS server.
%             [~,ImageDate,~,~,scene_id] = landsat(DB(n).PATH,DB(n).ROW,...
%                   datestr(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY])),...
%                   'nomap',days_offset);
%             if ~isempty(ImageDate)
%                   if ImageDate >= datenum(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY]))-datenum(days_offset)
%
%                         for idx1 = 1:length(DB(n).insituidx(:))
%                               disp('--------------------------------------------')
%                               disp(['In situ taken: ',datestr(InSitu(DB(n).insituidx(idx1)).t)])
%
%                               disp(['Image taken:   ',datestr(ImageDate)])
%
%                               fprintf('path:%i , row:%i, d:%i\n',DB(n).PATH,DB(n).ROW,DB(n).insituidx(idx1))
%                               fprintf('ID: %s\n',scene_id)
%                               % Save it in a structure
%                               idx_match = idx_match + 1;
%                               Matchup(idx_match).number_d = DB(n).insituidx(idx1);
%                               Matchup(idx_match).id_scene = scene_id;
%                         end
%                   end
%             end
%       end
% end
% close(h2)
% % clear aux_idx aux_pr cond_in d db_idx firsttime h1 h2 i idx_match ImageDate j n u x xv y yv
% T=toc;
% disp(['Seconds: ' num2str(T/60) ' minutes.'])
% clear T
% save('L8Matchups_AERONET_Rrs.mat','InSitu','Matchup','DB')
%
% %% Create idlatlon_list.txt to process images only around the ROI
% A = {Matchup.id_scene}';
% B = {InSitu(cell2mat({Matchup.number_d})).lat}';
% C = {InSitu(cell2mat({Matchup.number_d})).lon}';
% D = [A B C];
%
% fileID = fopen('idlatlon_list.txt','w');
%
% formatSpec = '%s %4.6f %4.6f\n';
%
% [nrows,ncols] = size(D);
% for row = 1:nrows
%       fprintf(fileID,formatSpec,D{row,:});
% end
%
% fclose(fileID);
%
% type idlatlon_list.txt
%
% clear A B C D
%
% %% Look in the Matchup structure the best images previously selected by visual inspection
% % using landsat.m and plot the jpg image and the in situ data location.
% % It extracts info from MTL files and fills Matchup.
%
% % dirname = '/Volumes/Data/OLI/L8_Rrs_Matchups_AERONET/';
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images/L8_Rrs_Matchups_AERONET/L8_Rrs_Matchups_AERONET_L2/';

fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n'); % list with all the Landsat 8 scenes
fclose(fileID);
%
% h2 = waitbar(0,'Initializing ...');
%
% for n = 1:size(s{:},1)
%       %%
%       waitbar(n/size(s{:},1),h2,'Extracting MTL info...')
%
%       disp('----------------------------------')
%       disp(s{1}{n})
%       for i=1:size(Matchup,2)
%             if s{1}{n} == Matchup(i).id_scene
%                   filepath = [dirname  Matchup(i).id_scene '_MTL.txt'];
%                   % for the different possible id scene endings
%                   id = Matchup(i).id_scene;
%                   filepath00 = [dirname id(1:16) 'LGN00_MTL.txt']; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
%                   filepath01 = [dirname id(1:16) 'LGN01_MTL.txt']; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
%                   filepath02 = [dirname id(1:16) 'LGN02_MTL.txt']; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
%
%                   if exist(filepath00, 'file');
%                         filepath = filepath00;
%
%                   elseif exist(filepath01, 'file');
%                         filepath = filepath01;
%
%                   elseif exist(filepath02, 'file');
%                         filepath = filepath02;
%
%                   else % File does not exist.
%                         warning('Warning: file does not exist:\n%s\n', filepath);
%                         fid = fopen('file_not_found.txt','a');
%                         fprintf(fid,[char(Matchup(i).id_scene) '\n']);
%                         fclose(fid);
%                         continue
%                   end
%
%                   parval_DATE = GetParMTL(filepath,'DATE_ACQUIRED');
%                   parval_TIME = GetParMTL(filepath,'SCENE_CENTER_TIME');
%                   if parval_TIME(1) == '"'
%                         tc = textscan(parval_TIME,'%s','Delimiter','"'); % I can or cannot have "" delimiters
%                         tc = tc{:}{2};
%                         tc = tc(1:8);
%                   else
%                         tc = textscan(parval_TIME,'%s');
%                         tc = tc{:}{1};
%                         tc = tc(1:8);
%                   end
%
%                   taux = datetime(parval_DATE,'ConvertFrom','yyyy-mm-dd');
%                   taux = datetime([char(taux) ' ' tc],'ConvertFrom','yyyymmdd');
%                   %% Assign scene time from MTL
%                   Matchup(i).scenetime = taux;
%                   clear taux tc parval_DATE parval_TIME
%                   disp('Found it!')
%                   disp(Matchup(i))
%                   %                   break
%
%                   path = str2double(s{1}{n}(4:6));
%                   row  = str2double(s{1}{n}(7:9));
%                   year = str2double(s{1}{n}(10:13));
%                   doy  = str2double(s{1}{n}(14:16));
%                   [yy,mm,dd] = datevec(datenum(year,1,doy));
%                   str= datestr(datenum([yy mm dd]),'yyyy-mm-dd');
%                   t_acq = datetime(str,'InputFormat','yyyy-MM-dd');
%                   %       str2 = datestr(t_acq);
%
%                   %       h1 = figure(1000);
%                   % lansat.m to check the USGS server for jpg images as proxy to scenes available
%                   %       [~,~,~,h] = landsat(path,row,str);
%
%                   %       figure(gcf)
%                   %       set(gcf,'Color','white','Name',s{1}{n})
%                   %       plotm([InSitu(Matchup(i).number_d).lat],[InSitu(Matchup(i).number_d).lon],'*-r')
%
%                   t_diff = [InSitu(Matchup(i).number_d).t] - t_acq;
%
%                   [Y,I] = min(abs(t_diff));
%
%                   str2 = datestr(Matchup(i).scenetime);
%                   str3 = sprintf('Taken: %s, Closest in Situ: %s, Diff: %s',str2,datestr(InSitu(Matchup(i).number_d(I)).t),char(t_diff(I)));
%
%                   %       title(str3)
%
%                   disp(['Acquired Date:' str2])
%                   disp('In situ:')
%                   InSitu(Matchup(i).number_d).t
%                   [InSitu(Matchup(i).number_d).lat,InSitu(Matchup(i).number_d).lon]
%
%                   %       close(h1)
%             end
%       end
% end
%
% close(h2)
% save('L8Matchups_AERONET_Rrs.mat','InSitu','Matchup','DB')

%% Find valid matchups. 
% It creates MatchupReal extracting the values from the L2 products.
% For each in situ point, there is one element associated. % Therefore, 
% for one image, there could be multiple elements in MatchupReal.
% Some of the elements in Matchup could be invalid, so MatchupReal will
% have less elements. However, it includes the different AC schemes, and
% therefor, for each in situ point could/should be the number of AC schemes
% elements in MatchupReal


clear MatchupReal
% L2ext = {'_L2n1.nc','_L2n2.nc','_L2n1SWIR5x5.nc','_L2n2SWIR5x5.nc'};
L2ext = {'_L2n1.nc','_L2n2.nc','_L2n2SWIR5x5.nc'};

ws = 9; % window size:3, 5, or 7

debug = 0;

% Pre-allocation
% global MatchupReal
MatchupReal(size(Matchup,2)).Rrs_insitu = '';
count = 0; % for MatchupReal

for idx0 = 1:size(L2ext,2)
      
      h2 = waitbar(0,'Initializing ...');
      for idx = 1:size(Matchup,2)
            waitbar(idx/size(Matchup,2),h2,['Looking for Real Matchups for' char(L2ext(idx0))])
            if ~isempty(Matchup(idx).scenetime) % only the paths and rows that are valid have a scene id
                  %% Open ag_412 product and plot
                  id = Matchup(idx).id_scene;
                  filepath00 = [dirname id(1:16) 'LGN00'  char(L2ext(idx0))]; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
                  filepath01 = [dirname id(1:16) 'LGN01'  char(L2ext(idx0))]; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
                  filepath02 = [dirname id(1:16) 'LGN02'  char(L2ext(idx0))]; % '_L2n1.nc' or '_L2n2.nc' or '_L2n2SWIR5x5.nc']
                  
                  if exist(filepath00, 'file');
                        filepath = filepath00;
                        
                  elseif exist(filepath01, 'file');
                        filepath = filepath01;
                        
                  elseif exist(filepath02, 'file');
                        filepath = filepath02;
                        
                  else % File does not exist.
                        warning('Warning: file does not exist:\n%s\n', filepath);
                        fid = fopen('file_not_found.txt','a');
                        fprintf(fid,[char(Matchup(idx).id_scene) '\n']);
                        fclose(fid);
                        continue
                  end
                  
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
                              MatchupReal(count).Rrs_410_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(1);
                              MatchupReal(count).Rrs_412_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(2);
                              MatchupReal(count).Rrs_413_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(3);
                              MatchupReal(count).Rrs_443_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(4);
                              MatchupReal(count).Rrs_486_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(5);
                              MatchupReal(count).Rrs_488_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(6);
                              MatchupReal(count).Rrs_490_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(7);
                              MatchupReal(count).Rrs_531_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(8);
                              MatchupReal(count).Rrs_547_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(9);
                              MatchupReal(count).Rrs_551_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(10);
                              MatchupReal(count).Rrs_555_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(11);
                              MatchupReal(count).Rrs_665_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(12);
                              MatchupReal(count).Rrs_667_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(13);
                              MatchupReal(count).Rrs_670_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(14);
                              MatchupReal(count).Rrs_671_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(15);
                              MatchupReal(count).Rrs_678_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(16);
                              MatchupReal(count).Rrs_681_insitu = InSitu(Matchup(idx).number_d(idx2)).Rrs(17);
                              MatchupReal(count).wavelength_insitu = InSitu(Matchup(idx).number_d(idx2)).wavelength;
                              MatchupReal(count).insitu_idx = Matchup(idx).number_d(idx2);
                              MatchupReal(count).id_scene = Matchup(idx).id_scene;
                              MatchupReal(count).scenetime = Matchup(idx).scenetime;
                              MatchupReal(count).insitutime = InSitu(Matchup(idx).number_d(idx2)).t;
                              MatchupReal(count).scene_ACpar = char(L2ext(idx0));
                              
                              
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
                        else % to indicate invalid product
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
      
end

%       save('L8Matchups_AERONET_Rrs.mat','InSitu','Matchup','DB','MatchupReal')
%% Plot retrieved vs in situ for all and less than 3 hours or 1 day
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
clear MatchupRealFilt
count2 = 0; % for creating the MatchupRealFilt

%       which_time_range = {'3 days','1 day','3 hours'};
for idx0 = 1:size(L2ext,2)
      
      cond6 = strcmp({MatchupReal.scene_ACpar}',char(L2ext(idx0)));
      
      Matchup_used = MatchupReal(cond6);
      
      which_time_range = {'3 hours'};
      for idx3 = 1:size(which_time_range,2)
            %% filtering to the closest
            h3 = waitbar(0,'Initializing ...');
            
            clear tempMatchupReal tempMatchupReal2
            
            if strcmp(which_time_range(idx3),'3 hours')
                  t_lim = hours(3);
            end
            
            for n = 1:size(s{:},1)
                  %%
                  waitbar(n/size(s{:},1),h3,'Filtering MatchupReal...')
                  
                  ind0 = strcmp({Matchup_used.id_scene}',s{1}{n}); % all the in situ associated a particular scene
                  if sum(ind0)~=0
                        
                        clear t_temp;
                        clear tempMatchupReal tempMatchupReal2
                        
                        tempMatchupReal = Matchup_used(ind0);
                        for idx1 = 1:sum(ind0)
                              t_temp(idx1)=abs(tempMatchupReal(idx1).scenetime-tempMatchupReal(idx1).insitutime);
                        end
                        
                        if (sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_443_filt_mean}'))) &&... % if there is valid value for at least one band
                                    sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_443_filt_mean}')))) ||...
                                    (sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_482_filt_mean}'))) &&...
                                    sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_482_filt_mean}')))) ||...
                                    (sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_561_filt_mean}'))) &&...
                                    sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_561_filt_mean}')))) ||...
                                    (sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_655_filt_mean}'))) &&...
                                    sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_655_filt_mean}'))))
                              
                              count2 = count2+1;
                              
                              MatchupRealFilt(count2).scene_id = tempMatchupReal(1).id_scene;
                              MatchupRealFilt(count2).scene_time = tempMatchupReal(1).scenetime;
                              MatchupRealFilt(count2).scene_ACpar = char(L2ext(idx0));
                              %% Rrs 443
                              if sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_443_filt_mean}'))) &&...
                                          sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_443_filt_mean}')))% &&...
                                    %sum(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_443_filt_mean}')>0)
                                    
                                    tempMatchupReal2 = tempMatchupReal(t_temp <= t_lim);
                                    [~,I] =sort(t_temp(t_temp <= t_lim));
                                    MatchupRealFilt(count2).Rrs_443_filt_mean = tempMatchupReal2(I(1)).Rrs_443_filt_mean;
                                    MatchupRealFilt(count2).Rrs_443_insitu = tempMatchupReal2(I(1)).Rrs_443_insitu;
                                    MatchupRealFilt(count2).Rrs_443_insitu_time = tempMatchupReal2(I(1)).insitutime;
                                    MatchupRealFilt(count2).Rrs_443_insitu_index = tempMatchupReal2(I(1)).insitu_idx;
                              end
                              %% Rrs 482
                              if sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_482_filt_mean}'))) &&...
                                          sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_482_filt_mean}'))) %&&...
                                    %sum(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_482_filt_mean}')>0)
                                    
                                    tempMatchupReal2 = tempMatchupReal(t_temp <= t_lim);
                                    [~,I] =sort(t_temp(t_temp <= t_lim));
                                    MatchupRealFilt(count2).Rrs_482_filt_mean = tempMatchupReal2(I(1)).Rrs_482_filt_mean;
                                    MatchupRealFilt(count2).Rrs_486_insitu = tempMatchupReal2(I(1)).Rrs_486_insitu;
                                    MatchupRealFilt(count2).Rrs_486_insitu_time = tempMatchupReal2(I(1)).insitutime;
                                    MatchupRealFilt(count2).Rrs_486_insitu_index = tempMatchupReal2(I(1)).insitu_idx;
                                    
                              end
                              %% Rrs 561
                              if sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_561_filt_mean}'))) &&...
                                          sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_561_filt_mean}'))) %&&...
                                    %sum(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_561_filt_mean}')>0)
                                    
                                    tempMatchupReal2 = tempMatchupReal(t_temp <= t_lim);
                                    [~,I] =sort(t_temp(t_temp <= t_lim));
                                    MatchupRealFilt(count2).Rrs_561_filt_mean = tempMatchupReal2(I(1)).Rrs_561_filt_mean;
                                    MatchupRealFilt(count2).Rrs_555_insitu = tempMatchupReal2(I(1)).Rrs_555_insitu;
                                    MatchupRealFilt(count2).Rrs_555_insitu_time = tempMatchupReal2(I(1)).insitutime;
                                    MatchupRealFilt(count2).Rrs_555_insitu_index = tempMatchupReal2(I(1)).insitu_idx;
                                    
                              end
                              %% Rrs 655
                              if sum(~isnan(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_655_filt_mean}'))) &&...
                                          sum(~isempty(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_655_filt_mean}'))) %&&...
                                    %sum(cell2mat({tempMatchupReal(t_temp <= t_lim).Rrs_655_filt_mean}')>0)
                                    
                                    tempMatchupReal2 = tempMatchupReal(t_temp <= t_lim);
                                    [~,I] =sort(t_temp(t_temp <= t_lim));
                                    MatchupRealFilt(count2).Rrs_655_filt_mean = tempMatchupReal2(I(1)).Rrs_655_filt_mean;
                                    MatchupRealFilt(count2).Rrs_665_insitu = tempMatchupReal2(I(1)).Rrs_665_insitu;
                                    MatchupRealFilt(count2).Rrs_665_insitu_time = tempMatchupReal2(I(1)).insitutime;
                                    MatchupRealFilt(count2).Rrs_665_insitu_index = tempMatchupReal2(I(1)).insitu_idx;
                                    
                              end
                        end
                        
                  end
            end
            close(h3)
            
            %% latex table
            
            if idx3 == 1 && idx0 == 1
                  % latex table
                  !rm ./MyTable.tex
                  FID = fopen('./MyTable.tex','w');
                  
                  fprintf(FID,'\\begin{tabular}{ccccccccccccccc} \n \\hline \n');
                  
                  fprintf(FID, 'Data');
                  fprintf(FID, '& ACO scheme ');
                  fprintf(FID, '& Sat (nm) ');
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
                  
            end
            %% Plot
            fs = 16;
            f1 = figure('Color','white','DefaultAxesFontSize',fs,'Name',[char(which_time_range(idx3)) char(L2ext(idx0))]);
            
            cond7 =  strcmp({MatchupRealFilt.scene_ACpar}',char(L2ext(idx0)));
            
            [h1,ax1,leg1] = plot_insitu_vs_sat('443','443',MatchupRealFilt(cond7),char(which_time_range(idx3)),char(L2ext(idx0)),FID); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            [h2,ax2,leg2] = plot_insitu_vs_sat('482','486',MatchupRealFilt(cond7),char(which_time_range(idx3)),char(L2ext(idx0)),FID); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            [h3,ax3,leg3] = plot_insitu_vs_sat('561','555',MatchupRealFilt(cond7),char(which_time_range(idx3)),char(L2ext(idx0)),FID); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            [h4,ax4,leg4] = plot_insitu_vs_sat('655','665',MatchupRealFilt(cond7),char(which_time_range(idx3)),char(L2ext(idx0)),FID); % plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)
            
            % latex table
            fprintf(FID,'\\hline \n');
            
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

% latex table
fprintf(FID,'\n \\end{tabular} \n');
fclose(FID);
save('L8Matchups_AERONET_Rrs.mat','InSitu','Matchup','DB','MatchupReal','MatchupRealFilt')
%%

cond6 = strcmp({MatchupRealFilt.scene_ACpar}','_L2n2.nc');
Rrs_443_sat = [MatchupRealFilt(cond6).Rrs_443_filt_mean];
Rrs_443_ins = [MatchupRealFilt(cond6).Rrs_443_insitu];

cond0 =  ~isnan(Rrs_443_sat)&~isnan(Rrs_443_ins)&...
      isfinite(Rrs_443_sat)&isfinite(Rrs_443_ins); % valid values

wl_sat = '443';
wl_ins = '443';

fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot(Rrs_443_ins,Rrs_443_sat,'o')
ylabel(['Satellite Rrs\_' wl_sat '(sr^{-1})'],'FontSize',fs)
xlabel(['in situ Rrs\_' wl_ins '(sr^{-1})'],'FontSize',fs)
axis equal

Rrs_sat_min = min(Rrs_443_sat)*0.95;
Rrs_sat_max = max(Rrs_443_sat)*1.05;
Rrs_ins_min = min(Rrs_443_ins)*0.95;
Rrs_ins_max = max(Rrs_443_ins)*1.05;

Rrs_min = min([Rrs_sat_min Rrs_ins_min]);
Rrs_max = max([Rrs_sat_max Rrs_ins_max]);

xlim([Rrs_min Rrs_max])
ylim([Rrs_min Rrs_max])

hold on
plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k')
% plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
% plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
grid on
leg = legend(['1 d; N: ' num2str(sum(cond0)) ]);
ax = gca;
ax.XTick =ax.YTick;

% Script to find Landsat 8 matchups based on in situ data
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';
% Load in situ data from VIIRS 2014
clear
DIRMAT(1).dirname = '/Users/jconchas/Documents/Research/InSituData/VIIRS2014CaryCDOMa_g/';
DIRMAT(2).dirname = '/Users/jconchas/Documents/Research/InSituData/NASA_GSFC/CLIVAR/p16s_2014/archive/';
DIRMAT(3).dirname = '/Users/jconchas/Documents/Research/InSituData/NASA_GSFC/ECOMON/archive/ag/';
DIRMAT(4).dirname = '/Users/jconchas/Documents/Research/InSituData/NASA_GSFC/ASIRI/archive/';
DIRMAT(5).dirname = '/Users/jconchas/Documents/Research/InSituData/NASA_GSFC/GEOCAPE/gomex_2013/archive/ag/';

count = 0;
for idx0=1:size(DIRMAT,2)
      % Open file with the list of images names
      fileID = fopen([DIRMAT(idx0).dirname 'file_list.txt']);
      s = textscan(fileID,'%s','Delimiter','\n');
      fclose(fileID);
      
      disp('-------------------------')
      disp('Starting Matchups search...')
      disp(DIRMAT(idx0).dirname)
      
      % figure for plottig the data
      figure('Color','white')
      hf1 = gcf;
      ylabel('a\_g (m\^-1)')
      xlabel('wavelength (nm)')
      
      
      % Plot GOCI footprint
      figure('Color','white')
      hf2 = gcf;
      % ax = worldmap([30 45],[116 136]);
      ax = worldmap('world');
      load coastlines
      geoshow(ax, coastlat, coastlon,...
            'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
      geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
      geoshow(ax,'worldrivers.shp', 'Color', 'blue')
      %
      for idx=1:size(s{:},1)
            %%
            filename = s{1}{idx}; % search on the list of filenames
            
            filepath = [DIRMAT(idx0).dirname filename];
            
            [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);
            % ag
            figure(hf1)
            hold on
            plot(data.wavelength,data.ag);
            grid on
            % location
            figure(hf2)
            hold on
            plotm(sbHeader.north_latitude,sbHeader.east_longitude,'*r')
            
            count = count+1;
            InSitu(count).station = sbHeader.station;
            InSitu(count).start_date = sbHeader.start_date;
            InSitu(count).start_time = sbHeader.start_time;
            InSitu(count).file_name = sbHeader.data_file_name;
            InSitu(count).wavelength = data.wavelength;
            InSitu(count).ag = data.ag;
            InSitu(count).ag_412_insitu = data.ag(data.wavelength==412);
            InSitu(count).lat = sbHeader.north_latitude;
            InSitu(count).lon = sbHeader.east_longitude;
            
            t = datetime(sbHeader.start_date,'ConvertFrom','yyyymmdd');
            t = char(t);
            t = [t(:,1:12) sbHeader.start_time];
            t = datetime(t,'ConvertFrom','yyyymmdd');
            
            InSitu(count).t = t;
            
            fprintf('%i %i %s\n',sbHeader.station,sbHeader.start_date,sbHeader.start_time)
      end
end
%% Find path and row for in situ data and select the image
% Create structure DB (database) with the potential scene path and row based on the lat and lon of the
% in situ data obtained from OpenSeaBASSfile_Main.m. Note: some paths and
% rows could be not valid because they are only over water and Landsat does
% not acquired images over only water.
% For each image, there are several indexes associated to the in situ data
% RUN OpenSeaBASSfile_Main.m first!!!
clear DB
% clc
load('WRS2_pathrow_struct.mat');
h1 = waitbar(0,'Initializing ...');

lat = [InSitu.lat];
lon = [InSitu.lon];
t = [InSitu.t];

% tic
firsttime = true;
days_offset = 3;
db_idx = 0;
cond_in = zeros(1,size(WRS_struct,2));
for d = 1:size(lon,2)
      waitbar(d/size(lon,2),h1,'Determining paths and rows...')
      %% Check if it is inside the polygon
      for u = 1:size(WRS_struct,2)
            xv = [WRS_struct(u).LON_LL WRS_struct(u).LON_LR ...
                  WRS_struct(u).LON_UR WRS_struct(u).LON_UL WRS_struct(u).LON_LL];
            yv = [WRS_struct(u).LAT_LL WRS_struct(u).LAT_LR ...
                  WRS_struct(u).LAT_UR WRS_struct(u).LAT_UL WRS_struct(u).LAT_LL];
            x =lon(d); y = lat(d);
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
                        DB(db_idx).YEAR = t(d).Year;
                        DB(db_idx).MONTH= t(d).Month;
                        DB(db_idx).DAY  = t(d).Day;
                        DB(db_idx).insituidx  = d;
                  end
            else
                  for j=1:size(DB,2) % Check DB for duplicates
                        %                         j
                        if DB(j).PATH==aux_pr(1,i) && ...
                                    DB(j).ROW== aux_pr(2,i) &&...
                                    datenum(datetime([DB(db_idx).YEAR DB(db_idx).MONTH DB(db_idx).DAY]))+datenum(days_offset)...
                                    >datenum(datetime([t(d).Year t(d).Month t(d).Day]))
                              %                            DB(j).YEAR == t(d).Year &&...
                              %                            DB(j).MONTH== t(d).Month &&...
                              %                            DB(j).DAY  == t(d).Day
                              %
                              %                               disp('Duplicate found...')
                              DB(j).insituidx(size(DB(j).insituidx,2)+1) = d;
                              break
                        elseif j== size(DB,2)
                              db_idx = db_idx+1;
                              DB(db_idx).PATH = aux_pr(1,i);
                              DB(db_idx).ROW  = aux_pr(2,i);
                              DB(db_idx).YEAR = t(d).Year;
                              DB(db_idx).MONTH= t(d).Month;
                              DB(db_idx).DAY  = t(d).Day;
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
% toc
% [C,IA,IC] = unique([DB(:).PATH;DB(:).ROW]','rows');
% unique([DB(:).PATH;DB(:).ROW;DB(:).YEAR;DB(:).MONTH;DB(:).DAY]','rows')

% To search for the available Landsat 8 scene and make sure the path and
% row is acquired by the sensor. Note: this process takes a long time
clear Matchup
% tic
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
                        disp('--------------------------------------------')
                        disp(['In situ taken: ',datestr(t(DB(n).insituidx(1)))])
                        
                        disp(['Image taken:   ',datestr(ImageDate)])
                        
                        
                        fprintf('path:%i , row:%i, d:%i\n',DB(n).PATH,DB(n).ROW,DB(n).insituidx(1))
                        da = datevec(ImageDate);
                        v = datenum(da);
                        DOY = v - datenum(da(:,1), 1,0);
                        L8id = ['LC8',sprintf('%03.f',DB(n).PATH),sprintf('%03.f',DB(n).ROW),sprintf('%03.f',da(:,1)),...
                              sprintf('%03.f',DOY),'LGN00'] ;
                        fprintf('ID: %s\n',L8id)
                        
                        % Save it in a structure
                        idx_match = idx_match + 1;
                        Matchup(idx_match).number_d = DB(n).insituidx(:);
                        Matchup(idx_match).id_scene = L8id;
                        Matchup(idx_match).dirname = DIRMAT(idx0).dirname;
                        
                  end
            end
      end
end

disp('Matchups search finished!')
disp('-------------------------')

close(h2)




clear aux_idx aux_pr cond_in d db_idx firsttime h1 h2 i idx_match ImageDate j n u x xv y yv
% toc
% save('L8Matchups_VIIRSS2014.mat','Matchup','DB')

%% Look in the Matchup structure the best images previously selected by visual inspection
% using landsat.m and plot the jpg image and the in situ data location
% load('L8Matchups_VIIRSS2014.mat')

dirname = '/Volumes/Data/OLI/L8MatchPot/';

fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n'); % list with all the Landsat 8 scenes
fclose(fileID);

for n = 1:size(s{:},1)
      %%
      disp('----------------------------------')
      disp(s{1}{n})
      for i=1:size(Matchup,2)
            if s{1}{n} == Matchup(i).id_scene
                  filepath = [dirname Matchup(i).id_scene '/' Matchup(i).id_scene '_MTL.txt'];
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
                        Matchup(i).scenetime = taux;
                        clear taux tc parval_DATE parval_TIME
                        disp('Found it!')
                        disp(Matchup(i))
                        break
                  else
                        % File does not exist.
                        warningMessage = sprintf('Warning: file does not exist:\n%s', fullFileName);
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
      
      h1 = figure(1000);
      % lansat.m to check the USGS server for jpg images as proxy to scenes available
      [~,~,~,h] = landsat(path,row,str);
      
      figure(gcf)
      set(gcf,'Color','white','Name',s{1}{n})
      plotm(lat(Matchup(i).number_d),lon(Matchup(i).number_d),'*-r')
      
      t_diff = t(Matchup(i).number_d) - t_acq;
      
      [Y,I] = min(abs(t_diff));
      
      str2 = datestr(Matchup(i).scenetime);
      str3 = sprintf('Taken: %s, Closest in Situ: %s, Diff: %s',str2,datestr(t(Matchup(i).number_d(I))),char(t_diff(I)));
      
      title(str3)
      
      disp(['Acquired Date:' str2])
      disp('In situ:')
      t(Matchup(i).number_d)
      [lat(Matchup(i).number_d),lon(Matchup(i).number_d)]
      
      close(h1)
      
end
% save('L8Matchups_Arctics.mat','Matchup')
%% Find valid matchups
% load('L8Matchups_Arctics.mat','Matchup')
% dirname = '/Users/jconchas/Documents/Research/Arctic_Data/L8images/Bulk Order 618966/L8 OLI_TIRS/';% where the L2 products are
count = 0;
for idx = 1:size(Matchup,2)
      if ~isempty(Matchup(idx).scenetime) % only the paths and rows that are valid have a scene id
            %% Open ag_412 product and plot
            filepath = [dirname Matchup(idx).id_scene '/' Matchup(idx).id_scene '_L2.nc']; % '_L2n1.nc' or '_L2n2.nc']
            longitude   = ncread(filepath,'/navigation_data/longitude');
            latitude    = ncread(filepath,'/navigation_data/latitude');
            ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
            
            % plot
%             plusdegress = 0;
%             latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
%             lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];
%             h = figure('Color','white','Name',[Matchup(idx).id_scene '_L2.nc']);
%             ax = worldmap(latlimplot,lonlimplot);
%             
%             load coastlines
%             geoshow(ax, coastlat, coastlon,...
%                   'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
%             
%             geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
%             geoshow(ax,'worldrivers.shp', 'Color', 'blue')
%             
%             % Display product
%             pcolorm(latitude,longitude,log10(ag_412_mlrc)) % faster than geoshow
%             colormap jet
            %
            %% Plot in situ and obtain value from the product
            for idx2 = 1:size(Matchup(idx).number_d,1) % each scene could have several field points
%                   figure(h)
%                   hold on
%                   plotm(lat(Matchup(idx).number_d(idx2)),lon(Matchup(idx).number_d(idx2)),'*c')
                  %% closest distance
                  % latitude and longitude are arrays of MxN
                  % lat0 and lon0 is the coordinates of one point
                  lat0 = lat(Matchup(idx).number_d(idx2));
                  lon0 = lon(Matchup(idx).number_d(idx2));
                  dist_squared = (latitude-lat0).^2 + (longitude-lon0).^2;
                  [m,I] = min(dist_squared(:));
                  [r,c]=ind2sub(size(latitude),I); % index to the closest in the latitude and longitude arrays
                  clear lat0 lon0 m I dist_squared
                  
                  if ~isnan(ag_412_mlrc(r,c))
                        %                         Matchup(idx).ag_412_insitu(idx2) = ag(Matchup(idx).number_d(idx2),wavelength==412);
                        
                        count = count+1;
                        fprintf('idx=%i,idx2=%i,count=%i\n',idx,idx2,count)
                        MatchupReal(count).ag_412_insitu = InSitu(Matchup(idx).number_d(idx2)).ag(InSitu(Matchup(idx).number_d(idx2)).wavelength==412);
                        MatchupReal(count).insitu_idx = Matchup(idx).number_d(idx2);
                        MatchupReal(count).id_scene = Matchup(idx).id_scene;
                        MatchupReal(count).scenetime = Matchup(idx).scenetime;
                        MatchupReal(count).insitutime = t(Matchup(idx).number_d(idx2));
                        
                        %% Filtered Mean = [sum_i(1.5*std-mean)<xi<(1.5*std+mean)]/N from Maninno et al. 2014
                        if r-1 == 0 || c-1 ==0 || r == size(ag_412_mlrc,1) || c == size(ag_412_mlrc,2)
                              warning('Window indices out of range...')
                        end
                        
                        ws = 3; % window size:3, 5, or 7
                        
                        window = ag_412_mlrc(r-(ws-1)/2:r+(ws-1)/2,c-(ws-1)/2:c+(ws-1)/2);
                        window_mean = nanmean(window(:)); % only non NaN values
                        window_std = nanstd(window(:));
                        
                        % indices to the cells that pass the filter
                        xi_idx = (window > (window_mean-1.5*window_std)) &...
                              (window < (window_mean+1.5*window_std)) &...
                              ~isnan(window); % to exclude NaN
                        
                        window_filt = window(xi_idx(:));
                        
                        CV = std(window_filt)/mean(window_filt);
                        
                        MatchupReal(count).ag_412_mlrc_mean = window_mean;
                        MatchupReal(count).ag_412_mlrc_meadian = nanmedian(window(:));
                        MatchupReal(count).ag_412_mlrc_std = window_std;
                        MatchupReal(count).ag_412_mlrc_center = ag_412_mlrc(r,c);
                        
                        if CV < 0.15 && size(window_filt,1)>=5 % filter outliers and at least 5 pixels form the 3x3 pixel arrays (from Mannino at al. 2014)
                              MatchupReal(count).ag_412_mlrc_filt_mean = mean(window_filt);
                              MatchupReal(count).ag_412_mlrc_filt_std = std(window_filt);
                              
                        else
                              warning('CV < 0.15. ag_412_mlrc not valid.')
                              MatchupReal(count).ag_412_mlrc_filt_mean = NaN;
                              MatchupReal(count).ag_412_mlrc_filt_std = NaN;
                        end
                        
                        MatchupReal(count).ag_412_mlrc_filt_min = min(window_filt);
                        MatchupReal(count).ag_412_mlrc_filt_max = max(window_filt);
                        MatchupReal(count).valid_px = sum(~isnan(window(:)));
                        MatchupReal(count).ag_412_mlrc_filt_px_count = sum(~isnan(window_filt(:)));
                        MatchupReal(count).window = window;
                        MatchupReal(count).CV = CV;
                        
                  else
                        Matchup(idx).ag_412_mlrc(idx2) = NaN;
                        Matchup(idx).ag_412_insitu(idx2) = InSitu(Matchup(idx).number_d(idx2)).ag(InSitu(Matchup(idx).number_d(idx2)).wavelength==412);
                  end
            end
            clear latitude longitude ag_412_mlrc
      end
end

save('L8Matchups_Arctics.mat','Matchup','MatchupReal')
%% Plot retrieved vs in situ for all and less than 3 hours or 1 day
% load('L8Matchups_Arctics.mat','Matchup','MatchupReal')
t_diff = [MatchupReal(:).scenetime]-[MatchupReal(:).insitutime];
cond1 = abs(t_diff) <= days(1); % days(1) or hours(3)
cond2 = abs(t_diff) <= hours(3); % days(1) or hours(3)

fprintf('Number of matchups: %i\n',sum(cond1))

fs = 16;
figure('Color','white','DefaultAxesFontSize',fs)
plot(t_diff,'*-k')
hold on
plot(find(cond1),t_diff(cond1),'*r')
plot(find(cond2),t_diff(cond2),'*b')
grid on
legend('3 days','1 day','3 hours')

%% NO filtered
fs = 16;
figure('Color','white','DefaultAxesFontSize',fs)
plot([MatchupReal.ag_412_insitu],[MatchupReal.ag_412_mlrc_center],'ok')
hold on
plot([MatchupReal(cond1).ag_412_insitu],[MatchupReal(cond1).ag_412_mlrc_center],'sr')
plot([MatchupReal(cond2).ag_412_insitu],[MatchupReal(cond2).ag_412_mlrc_center],'*b')
ylabel('Satellite a_{CDOM}(412) (m^{-1})','FontSize',fs)
xlabel('in situ a_{CDOM}(412) (m^{-1})','FontSize',fs)
axis equal
a_g_max = 0.9;
xlim([0 a_g_max])
ylim([0 a_g_max])
hold on
plot([0 a_g_max],[0 a_g_max],'--k')
plot([0 a_g_max],[0.1*a_g_max 1.1*a_g_max],':k')
plot([0 a_g_max],[-0.1*a_g_max 0.9*a_g_max],':k')
grid on
legend(['3 d; N: ' num2str(sum(~isnan([MatchupReal.ag_412_mlrc_center]))) ],['1 d; N: ' num2str(sum(cond1)) ],['3 h; N: ' num2str(sum(cond2)) ])
ax = gca;
ax.XTick =ax.YTick;
%% filtered
cond0 =  ~isnan([MatchupReal.ag_412_mlrc_filt_mean]);
cond3 = cond1 & cond0;
cond4 = cond2 & cond0;

fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([MatchupReal(cond0).ag_412_insitu],[MatchupReal(cond0).ag_412_mlrc_center],'ok')
hold on
plot([MatchupReal(cond3).ag_412_insitu],[MatchupReal(cond3).ag_412_mlrc_filt_mean],'sr')
plot([MatchupReal(cond4).ag_412_insitu],[MatchupReal(cond4).ag_412_mlrc_filt_mean],'*b')
ylabel('Satellite a_{CDOM}(412) (m^{-1})','FontSize',fs)
xlabel('in situ a_{CDOM}(412) (m^{-1})','FontSize',fs)
axis equal
a_g_max = 0.9;
xlim([0 a_g_max])
ylim([0 a_g_max])
hold on
plot([0 a_g_max],[0 a_g_max],'--k')
plot([0 a_g_max],[0.1*a_g_max 1.1*a_g_max],':k')
plot([0 a_g_max],[-0.1*a_g_max 0.9*a_g_max],':k')
grid on
legend(['3 d; N: ' num2str(sum(cond0)) ],['1 d; N: ' num2str(sum(cond3)) ],['3 h; N: ' num2str(sum(cond4)) ])
ax = gca;
ax.XTick =ax.YTick;
%% filtered only < 3 hours
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([MatchupReal(cond4).ag_412_insitu],[MatchupReal(cond4).ag_412_mlrc_filt_mean],'*b')
ylabel('Satellite a_{CDOM}(412) (m^{-1})','FontSize',fs)
xlabel('in situ a_{CDOM}(412) (m^{-1})','FontSize',fs)
axis equal
a_g_max = 0.16;
xlim([0 a_g_max])
ylim([0 a_g_max])
hold on
plot([0 a_g_max],[0 a_g_max],'--k')
plot([0 a_g_max],[0.1*a_g_max 1.1*a_g_max],':k')
plot([0 a_g_max],[-0.1*a_g_max 0.9*a_g_max],':k')
grid on
legend(['3 h; N: ' num2str(sum(cond4)) ])
ax = gca;
ax.XTick =ax.YTick;
%% Statistics
cond_used = cond0;
C_alg = [MatchupReal(cond_used).ag_412_mlrc_filt_mean];
C_insitu = [MatchupReal(cond_used).ag_412_insitu];
N = size(C_insitu,2);

PD = abs(C_alg-C_insitu)./C_insitu; % percent difference

Mean_APD = (100/N)*sum(PD);% mean of the absolute percent difference (APD)

Stdv_APD = 100*std(PD);% standard deviation of the absolute difference

Median_APD = 100*median(PD); % a.k.a. MPD

RMSE = sqrt((1/N)*sum((C_alg-C_insitu).^2));

Percentage_Bias = 100*((1/N)*sum(C_alg-C_insitu))/(mean(C_insitu));

ratio_alg_insitu = C_alg./C_insitu;

Median_ratio = median(ratio_alg_insitu);

Q3 = prctile(ratio_alg_insitu,75);
Q1 = prctile(ratio_alg_insitu,25);
SIQR = (Q3-Q1)/2; % Semi-interquartile range


disp(['Mean APD (%) = ' num2str(Mean_APD)])
disp(['St.Dev. APD (%) = ' num2str(Stdv_APD)])
disp(['Median APD (%) = ' num2str(Median_APD)])
disp(['RMSE = ' num2str(RMSE)])
disp(['Bias (%) = ' num2str(Percentage_Bias)])
disp(['Median ratio = ' num2str(Median_ratio)])
disp(['SIQR = ' num2str(SIQR)])

% clear C_alg C_insitu N

%% RMA regression and r-squared (or coefficient of determination)
regressiontype = 'RMA';

if strcmp(regressiontype,'OLS')
      [a,~] = polyfit(C_insitu,C_alg,1);
elseif strcmp(regressiontype,'RMA')
      % %%%%%%%% RMA Regression %%%%%%%%%%%%%
      % [[b1 b0],bintr,bintjm] = gmregress(C_insitu,C_alg);
      a(1) = std(C_alg)/std(C_insitu); % slope
      
      if corr(C_insitu,C_alg)<0
            a(1) = -abs(a(1));
      elseif corr(C_insitu,C_alg)>=0
            a(1) = abs(a(1));
      end
      
      a(2) = mean(C_alg)-mean(C_insitu)*a(1); % y intercept
      
end

maxref = a_g_max;

x1=[0 maxref];
y1=a(1).*x1+a(2);

figure(h)
plot(x1,y1,'r-','LineWidth',1.2)


SStot = sum((C_alg-mean(C_alg)).^2);
SSres = sum((C_alg-polyval(a,C_insitu)).^2);
rsq_SS = 1-(SSres/SStot)
rsq_corr = corr(C_insitu',C_alg')^2 % when OLS rsq_SS and rsq_corr are equal

if a(2)>=0
      str1 = sprintf('y: %2.4f x + %2.4f \n R^2: %2.4f; N: %i \n RMSE: %2.4f',...
            a(1),abs(a(2)),rsq_SS,size(C_insitu,2),RMSE);
else
      str1 = sprintf('y: %2.4f x - %2.4f \n R^2: %2.4f; N: %i \n RMSE: %2.4f',...
            a(1),abs(a(2)),rsq_SS,size(C_insitu,2),RMSE);
end

axis([0 maxref 0 maxref])

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.85*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs,'FontWeight','normal');
disp(str1)

%% List scene time and in situ time together
[[MatchupReal(cond1).scenetime]' [MatchupReal(cond1).insitutime]']

%% Plot only Matchup Real
cond_used = cond0;
scene_list = unique({MatchupReal(cond_used).id_scene}'); % cond4 for less than 3 hours and filtered mean
MatchupReal_aux = MatchupReal(cond_used);
% dirname = '/Users/jconchas/Documents/Research/Arctic_Data/L8images/Bulk Order 618966/L8 OLI_TIRS/';% where the products are

for idx = 1:size(scene_list,1)
      %% Open ag_412 product and plot
      scene_id_char =  char(scene_list(idx,:));
      filepath = [dirname scene_id_char '/' scene_id_char '_L2.nc']; % '_L2n1.nc' or '_L2n2.nc']
      longitude   = ncread(filepath,'/navigation_data/longitude');
      latitude    = ncread(filepath,'/navigation_data/latitude');
      ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
      
      % plot
      plusdegress = 0;
      latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
      lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];
      h = figure('Color','white','Name',scene_id_char);
      ax = worldmap(latlimplot,lonlimplot);
      mlabel('MLabelParallel','north')
      
      %             load coastlines
      %             geoshow(ax, coastlat, coastlon,...
      %                   'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
      %
      %             geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
      %             geoshow(ax,'worldrivers.shp', 'Color', 'blue')
      
      % Plot jpg image
      path = str2double(scene_id_char(4:6));
      row  = str2double(scene_id_char(7:9));
      year = str2double(scene_id_char(10:13));
      DOY  = str2double(scene_id_char(14:16));
      date_aux = datevec(DOY+datenum(year,1,1)-1);
      date_char = sprintf('%i-%i-%i',date_aux(1),date_aux(2),date_aux(3));
      hold on
      
      [~,~,~,h0] = landsat(path,row,date_char);
      
      % Display product
      
      
      figure(gcf)
      pcolorm(latitude,longitude,log10(ag_412_mlrc)) % faster than geoshow
      colormap jet
      
      for idx2 = 1:size(MatchupReal_aux,2)
            if char(scene_list(idx,:)) == MatchupReal_aux(idx2).id_scene
                  figure(gcf)
                  hold on
                  plotm(lat(MatchupReal_aux(idx2).insitu_idx),lon(MatchupReal_aux(idx2).insitu_idx),'om','markerfacecolor','m')
            end
      end
      
      mask = isnan(ag_412_mlrc);
      ag_412_mlrc_log10 =log10(ag_412_mlrc);
      ag_412_mlrc_mean = nanmean(ag_412_mlrc_log10(:));
      ag_412_mlrc_std= nanstd(ag_412_mlrc_log10(:));
      cte = 3;
      set(gca, 'CLim', [ag_412_mlrc_mean-cte*ag_412_mlrc_std, ag_412_mlrc_mean+cte*ag_412_mlrc_std]);
      set(h0, 'AlphaData', mask)
      
      hbar = colorbar('SouthOutside');
      pos = get(gca,'position');
      set(gca,'position',[pos(1) pos(2) pos(3) pos(4)])
      set(hbar,'location','manual','position',[.2 0.07 .64 .05]); % [left, bottom, width, height]
      title(hbar,'Satellite a_{CDOM}(412) (m^{-1})','FontSize',fs)
      y = get(hbar,'XTick');
      x = 10.^y;
      set(hbar,'XTick',log10(x));
      for i=1:size(x,2)
            x_clean{i} = sprintf('%0.3f',x(i));
      end
      set(hbar,'XTickLabel',x_clean,'FontSize',fs-1)
end

clear MatchupReal_aux ixc latlimplot lonlimplot h ax path row year DOY date_aux idx2

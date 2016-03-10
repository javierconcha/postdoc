% Script to find Landsat 8 matchups based on in situ data
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';
%% Create WRS Structure
% Create an estucture WRS_struct with the path and row's coordinate limits
% clear
fileID = fopen('WRS-2_bound_world.kml');
% Downloaded from: https://landsat.usgs.gov/tools_wrs-2_shapefile.php
C = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

count =0;
for idx=1:size(C{:},1)
      %       if strcmp(C{1}{idx},'<name>')
      %             count = count+1;
      %       end
      if regexp(C{1}{idx},'<strong>PATH</strong>:')
            count = count+1;
            WRS_struct(count).linenumber = idx;
            aux = textscan(C{1}{idx},'%s','Delimiter','<>_:');
            WRS_struct(count).PATH = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+1},'%s','Delimiter','<>_:');
            WRS_struct(count).ROW  = str2double(aux{1}{6});
            
            aux = textscan(C{1}{idx+2},'%s','Delimiter','<>_:');
            WRS_struct(count).CTR_LAT = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+3},'%s','Delimiter','<>_:');
            WRS_struct(count).CTR_LON = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+4},'%s','Delimiter','<>:');
            WRS_struct(count).Name    = aux{1}{6};
            aux = textscan(C{1}{idx+5},'%s','Delimiter','<>_:');
            WRS_struct(count).LAT_UL  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+6},'%s','Delimiter','<>_:');
            WRS_struct(count).LON_UL  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+7},'%s','Delimiter','<>_:');
            WRS_struct(count).LAT_UR  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+8},'%s','Delimiter','<>_:');
            WRS_struct(count).LON_UR  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+9},'%s','Delimiter','<>_:');
            WRS_struct(count).LAT_LL  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+10},'%s','Delimiter','<>_:');
            WRS_struct(count).LON_LL  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+11},'%s','Delimiter','<>_:');
            WRS_struct(count).LAT_LR  = str2double(aux{1}{6});
            aux = textscan(C{1}{idx+12},'%s','Delimiter','<>_:');
            WRS_struct(count).LON_LR  = str2double(aux{1}{6});
            
      end
end
clear aux C count idx fileID
save('WRS2_pathrow_struct.mat','WRS_struct')
%% Load in situ data
% Extract Tara data from SeaBASS file
% dirname = '/Users/jconchas/Documents/Research/Arctic_Data/SeaBASS_ArcticL8/MAINE/boss/Tara_Oceans_Polar_Circle/Pevek_Tuktoyaktuk/archive/';
dirname = '/Users/jconchas/Documents/Research/Arctic_Data/';

% Open file with the list of images names
% fileID = fopen([dirname 'file_list.txt']);
% s = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);

% for idx=1:size(s{:},1) % when it is many file
%       filename = s{1}{idx}; % search on the list of filenames
filename = 'TaraArctic_ag_cal_UpdatedGPS.txt'; % from Thomas Leeuw

filepath = [dirname filename];

[data, sbHeader, headerArray] = readsb(filepath);

date_acquired = data{:,1};

time_acquired = datestr(data{:,2},'HH:MM:SS');
lat = [data{3}];
lon = [data{4}];
ag = [data{7:81}];
%       ag_sd = [data{88:168}];

%       wavelength = [400.1,404.3,408.5,412.8,417.3,422.1,426.9,431.7,...
%           436.3,440.7,445.6,450.9,456,460.6,465.5,470.6,476.1,481.1,...
%           486.4,490.9,495.8,500.7,505.7,511.1,516.3,521.5,526.8,531.5,...
%           536.1,541.1,546.1,551,556,561.1,566.1,570.7,575.2,579.7,583.7,...
%           588.3,592.3,596.7,601.1,606,610.7,615.3,620,624.5,629,633.4,...
%           638,642.5,647.3,651.7,656.5,661.3,665.9,670.3,674.7,679.1,683.2,...
%           687.2,691.1,695.2,698.9,702.8,706.3,710.2,713.6,717.2,720.8,...
%           724.1,727.8,730.8,734,737.2,740.3,742.7,745.7,748.4,750];
wavelength = [400,402,406,408,410,412,414,416,418,420,422,424,...
      426,428,430,432,434,436,438,440,442,444,446,448,450,452,...
      454,456,458,460,462,464,466,468,470,472,474,476,478,480,...
      482,484,486,488,490,492,494,496,498,500,502,504,506,508,...
      510,512,514,516,518,520,522,524,526,528,530,532,534,536,...
      538,540,542,544,546,548,550];

n = size(ag,1);

% figure('Color','white','Name',filename)
% %       subplot(2,1,1)
% plot(wavelength,ag')
% ylabel('a or c (m\^-1)')
% str = sprintf('N=%i',n);
% title(str)
% grid on

%       subplot(2,1,2)
%       plot(wavelength,ag_sd','r')
%       ylabel('std. dev. a or c (m\^-1)')
%       xlabel('wavelength (nm)')
%       grid on
% end
% %% Plot Tara data on map
% figure('Color','white')
% ax = worldmap([45 90],[-180 180]);
% % ax = worldmap('North Pole');
% load coastlines
% geoshow(ax, coastlat, coastlon,...
%       'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
% geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
% geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% hold on
% plotm(lat,lon,'r*-')
% %% Plot time

t = datetime(date_acquired,'ConvertFrom','yyyymmdd');
t = char(t);
t = [t(:,1:12) time_acquired];
t = datetime(t,'ConvertFrom','yyyymmdd');
%
% figure
% plot(t,ag(:,wavelength==440))
clear dirname filename filepath headerArray n sbHeader
%% Find path and row for in situ data and select the image
% Create structure DB (database) with the potential scene path and row based on the lat and lon of the
% in situ data obtained from OpenSeaBASSfile_Main.m. Note: some paths and
% rows could be not valid because they are only over water and Landsat does
% not acquired images over only water.
% For each image, there are several indexes associated to the in situ data
% RUN OpenSeaBASSfile_Main.m first!!!
clear DB
clc
load('WRS2_pathrow_struct.mat');
h1 = waitbar(0,'Initializing ...');

tic
firsttime = true;
days_offset = 3;
db_idx = 0;
cond_in = zeros(1,size(WRS_struct,2));
for d = 1:size(lon,1)
      waitbar(d/size(lon,1),h1,'Determining paths and rows...')
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
toc
% [C,IA,IC] = unique([DB(:).PATH;DB(:).ROW]','rows');
% unique([DB(:).PATH;DB(:).ROW;DB(:).YEAR;DB(:).MONTH;DB(:).DAY]','rows')

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
                  end
            end
      end
end
close(h2)
clear aux_idx aux_pr cond_in d db_idx firsttime h1 h2 i idx_match ImageDate j n u x xv y yv
toc
save('L8Matchups_Arctics.mat','Matchup','DB')

%% Look in the Matchup structure the best images previously selected by visual inspection
% using landsat.m and plot the jpg image and the in situ data location
load('L8Matchups_Arctics.mat')

dirname = '/Users/jconchas/Documents/Research/Arctic_Data/L8images/Bulk Order 618966/L8 OLI_TIRS/';

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
save('L8Matchups_Arctics.mat','Matchup')
%% Plot Matchups with product
load('L8Matchups_Arctics.mat','Matchup')
dirname = '/Users/jconchas/Documents/Research/Arctic_Data/L8images/Bulk Order 618966/L8 OLI_TIRS/';% where the products are
count = 0;
for idx = 1:size(Matchup,2)
      idx
      if ~isempty(Matchup(idx).scenetime)
            %% Open ag_412 product and plot
            filepath = [dirname Matchup(idx).id_scene '/' Matchup(idx).id_scene '_L2n2.nc']; % '_L2n1.nc' or '_L2n2.nc']
            longitude   = ncread(filepath,'/navigation_data/longitude');
            latitude    = ncread(filepath,'/navigation_data/latitude');
            ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
            
            % plot
%             plusdegress = 0.5;
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
            for idx2 = 1:size(Matchup(idx).number_d,1)
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
                  
                  if ~isnan(ag_412_mlrc (r,c))
%                         plotm(latitude(r,c),longitude(r,c),'*m')
                        Matchup(idx).ag_412_mlrc(idx2) = ag_412_mlrc (r,c);
                        Matchup(idx).ag_412_insitu(idx2) = ag(Matchup(idx).number_d(idx2),wavelength==412);
                        
                        count = count+1;
                        MatchupReal(count).ag_412_mlrc = ag_412_mlrc (r,c);
                        MatchupReal(count).ag_412_insitu = ag(Matchup(idx).number_d(idx2),wavelength==412);
                        MatchupReal(count).insitu_idx = Matchup(idx).number_d(idx2);
                        MatchupReal(count).id_scene = Matchup(idx).id_scene;
                        MatchupReal(count).scenetime = Matchup(idx).scenetime;    
                        MatchupReal(count).insitutime = t(Matchup(idx).number_d(idx2));
                  else
                        Matchup(idx).ag_412_mlrc(idx2) = NaN;
                        Matchup(idx).ag_412_insitu(idx2) = ag(Matchup(idx).number_d(idx2),wavelength==412);
                  end
            end
            clear latitude longitude ag_412_mlrc
      end
end

save('L8Matchups_Arctics.mat','Matchup','MatchupReal')
%% Plot retrieved vs in situ for all and less than 3 hours or 1 day
load('L8Matchups_Arctics.mat','Matchup','MatchupReal')
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

%
fs = 16;
figure('Color','white','DefaultAxesFontSize',fs)
plot([MatchupReal.ag_412_mlrc],[MatchupReal.ag_412_insitu],'*k')
hold on
plot([MatchupReal(cond1).ag_412_mlrc],[MatchupReal(cond1).ag_412_insitu],'*r')
plot([MatchupReal(cond2).ag_412_mlrc],[MatchupReal(cond2).ag_412_insitu],'*b')
xlabel('ag\_412\_mlrc (m\^-1)','FontSize',fs)
ylabel('ag\_412\_insitu (m\^-1)','FontSize',fs)
axis equal 
a_g_max = 0.16;
xlim([0 a_g_max])
ylim([0 a_g_max])
hold on
plot([0 a_g_max],[0 a_g_max],'--k')
grid on
legend('3 days','1 day','3 hours')
%% List scene time and in situ time together
[[MatchupReal(cond1).scenetime]' [MatchupReal(cond1).insitutime]']

%% Plot only Matchup Real
scene_list = unique({MatchupReal(cond1).id_scene}');
MatchupReal_aux = MatchupReal(cond1);
dirname = '/Users/jconchas/Documents/Research/Arctic_Data/L8images/Bulk Order 618966/L8 OLI_TIRS/';% where the products are

for idx = 1:size(scene_list,1)
            %% Open ag_412 product and plot
            scene_id_char =  char(scene_list(idx,:));
            filepath = [dirname scene_id_char '/' scene_id_char '_L2n1.nc']; % '_L2n1.nc' or '_L2n2.nc']
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
            title(hbar,'ag\_412\_mlrc (m\^-1)','FontSize',fs)
            y = get(hbar,'XTick');
            format short
            x = 10.^y;
            set(hbar,'XTick',log10(x));
            for i=1:size(x,2)
                  x_clean{i} = sprintf('%0.3f',x(i));
            end
            set(hbar,'XTickLabel',x_clean,'FontSize',fs-1)
end

clear MatchupReal_aux ixc latlimplot lonlimplot h ax path row year DOY date_aux idx2

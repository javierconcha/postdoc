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

% Plot 
figure('Color','white')
hf2 = gcf;
ax = worldmap('World');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')

%%
% Extract Tara data from SeaBASS file
clear InSitu
dirname = '/Volumes/Data/OLI/L8_Rrs_Matchups/';

count = 0;


      
      filename = 'val1464210174176624_Rrs_original.csv';
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true,'NewTextFields',{'date_time','cruise_name','file_name'});
      
for idx=1:size(data.date_time,1)
      %% Rrs

      Rrs = [data.insitu_rrs412(idx),data.insitu_rrs443(idx),data.insitu_rrs488(idx),...
            data.insitu_rrs531(idx),data.insitu_rrs547(idx),data.insitu_rrs667(idx),data.insitu_rrs678(idx)];
      wavelength = [412,443,488,531,547,667,678];
      
      figure(hf1)
      hold on
      plot(wavelength,Rrs);
      grid on
      title('Rrs')
      
      %% Location
      figure(hf2)
      hold on
      plotm(data.latitude(idx),data.longitude(idx),'*r')

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
      
      fprintf('%i %s\n',idx,char(data.date_time(idx)))
end

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
                        disp('--------------------------------------------')
                        disp(['In situ taken: ',datestr(InSitu(DB(n).insituidx(1)).t)])
                        
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
% clear aux_idx aux_pr cond_in d db_idx firsttime h1 h2 i idx_match ImageDate j n u x xv y yv
T=toc;
disp(['Seconds: ' num2str(T/60) ' minutes.'])
clear T
% save('L8Matchups_AERONET_Rrs.mat','Matchup','DB')
%% Look in the Matchup structure the best images previously selected by visual inspection
% using landsat.m and plot the jpg image and the in situ data location

dirname = '/Volumes/Data/OLI/L8_Rrs_Matchups_AERONET/';

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
      
      h1 = figure(1000);
      % lansat.m to check the USGS server for jpg images as proxy to scenes available
      [~,~,~,h] = landsat(path,row,str);
      
      figure(gcf)
      set(gcf,'Color','white','Name',s{1}{n})
      plotm([InSitu(Matchup(i).number_d).lat],[InSitu(Matchup(i).number_d).lon],'*-r')
      
      t_diff = [InSitu(Matchup(i).number_d).t] - t_acq;
      
      [Y,I] = min(abs(t_diff));
      
      str2 = datestr(Matchup(i).scenetime);
      str3 = sprintf('Taken: %s, Closest in Situ: %s, Diff: %s',str2,datestr(InSitu(Matchup(i).number_d(I)).t),char(t_diff(I)));
      
      title(str3)
      
      disp(['Acquired Date:' str2])
      disp('In situ:')
      InSitu(Matchup(i).number_d).t
      [InSitu(Matchup(i).number_d).lat,InSitu(Matchup(i).number_d).lon]
      
      close(h1)
      
end
save('L8Matchups_Arctics.mat','Matchup')
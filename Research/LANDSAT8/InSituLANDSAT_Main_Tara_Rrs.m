
% Script to find Landsat 8 matchups for Rrs based on in situ data from Tara
% Polar expedition
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';

%% Load in situ data
% Extract Tara data from SeaBASS file
dirname = '/Users/jconchas/Documents/Research/InSituData/MAINE/boss/Tara_Oceans_Polar_Circle/';

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

% Open file with the list of images names
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

count = 0;

for idx=1:size(s{:},1)
      filename = s{1}{idx}; % search on the list of filenames
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);
      
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

%% Find path and row for in situ data and select the image
% Create structure DB (database) with the potential scene path and row based on the lat and lon of the
% in situ data obtained from OpenSeaBASSfile_Main.m. Note: some paths and
% rows could be not valid because they are only over water and Landsat does
% not acquired images over only water.
% For each image, there are several indexes associated to the in situ data
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
                                    datenum(datetime([DB(db_idx).YEAR DB(db_idx).MONTH DB(db_idx).DAY]))+datenum(days_offset)...
                                    >datenum(datetime([InSitu(d).t.Year InSitu(d).t.Month InSitu(d).t.Day]))
                              %                            DB(j).YEAR == InSitu(d).t.Year &&...
                              %                            DB(j).MONTH== InSitu(d).t.Month &&...
                              %                            DB(j).DAY  == InSitu(d).t.Day
                              %
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
toc
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
clear aux_idx aux_pr cond_in d db_idx firsttime h1 h2 i idx_match ImageDate j n u x xv y yv
toc
save('L8Matchups_Arctic_Rrs.mat','Matchup','DB')
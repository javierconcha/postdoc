addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/Images/MTLDIR')
addpath('/Users/jconchas/Documents/Research/GOCI')
cd '/Users/jconchas/Documents/Research/GOCI/InSitu';
count = 0; % to create the InSitu structure
clear InSitu
%% Open file for cruise GEOCAPE_GOCI
% dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Dec2010/archive/ag/';
% dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Apr2011/archive/ag/';
dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Aug2011/archive/ag/';


% Open file with the list of images names
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

%% figure for plottig the data
figure('Color','white')
hf1 = gcf;
ylabel('a\_g (m\^-1)')
xlabel('wavelength (nm)')


%% Plot GOCI footprint
figure('Color','white')
hf2 = gcf;
ax = worldmap([30 45],[116 136]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
%%

for idx=1:size(s{:},1)
      filename = s{1}{idx}; % search on the list of filenames
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);
      %% ag
      figure(hf1)
      hold on
      plot(data.wavelength,data.ag);
      grid on
      %% location
      figure(hf2)
      hold on
      plotm(sbHeader.north_latitude,sbHeader.east_longitude,'*r')
      
      count = count+1;
      InSitu(count).station = sbHeader.station;
      InSitu(count).start_date = sbHeader.start_date;
      InSitu(count).start_time = sbHeader.start_time;
      InSitu(count).filepath = filepath;
      InSitu(count).wavelength = data.wavelength;
      InSitu(count).ag = data.ag;
      InSitu(count).lat = sbHeader.north_latitude;
      InSitu(count).lon = sbHeader.east_longitude;
      
      fprintf('%s %i %s\n',sbHeader.station,sbHeader.start_date,sbHeader.start_time)
end


%% Open file for cruise GOCI_2013
dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GOCI_2013/archive/iop/';


% Open file with the list of images names
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

%% figure for plottig the data
figure('Color','white')
hf1 = gcf;
ylabel('a\_g (m\^-1)')
xlabel('wavelength (nm)')


%% Plot GOCI footprint
figure('Color','white')
hf2 = gcf;
ax = worldmap([30 45],[116 136]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
%%

for idx=1:size(s{:},1)
      filename = s{1}{idx}; % search on the list of filenames
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);
      
      %% ag
      
      ag = [data.ag400_9,data.ag405,data.ag408_9,data.ag412_6,data.ag416_9,data.ag421_7,data.ag426_3,data.ag431_1,data.ag435_2,data.ag439_6,data.ag444_2,data.ag449_2,data.ag454_1,data.ag458_9,data.ag463_4,data.ag468_4,data.ag473_4,data.ag478_5,data.ag483_6,data.ag488_5,data.ag493,data.ag497_5,data.ag502_4,data.ag507_4,data.ag512_6,data.ag517_8,data.ag523,data.ag528,data.ag532_7,data.ag537_7,data.ag542_3,data.ag547_5,data.ag552_4,data.ag557_4,data.ag562_3,data.ag567_3,data.ag571_9,data.ag575_8,data.ag580_3,data.ag584_9,data.ag589_3,data.ag593_5,data.ag597_9,data.ag602_3,data.ag605_6,data.ag610_8,data.ag615_9,data.ag620_5,data.ag625_4,data.ag629_9,data.ag634_5,data.ag639_5,data.ag644,data.ag648_9,data.ag653_5,data.ag658_3,data.ag662_9,data.ag667_5,data.ag671_8,data.ag676_3,data.ag680_1,data.ag684_5,data.ag688_4,data.ag692_6,data.ag696_3,data.ag699_9,data.ag703_6,data.ag707_3,data.ag711,data.ag714_5];
      wavelength = [400.9,405,408.9,412.6,416.9,421.7,426.3,431.1,435.2,439.6,444.2,449.2,454.1,458.9,463.4,468.4,473.4,478.5,483.6,488.5,493,497.5,502.4,507.4,512.6,517.8,523,528,532.7,537.7,542.3,547.5,552.4,557.4,562.3,567.3,571.9,575.8,580.3,584.9,589.3,593.5,597.9,602.3,605.6,610.8,615.9,620.5,625.4,629.9,634.5,639.5,644,648.9,653.5,658.3,662.9,667.5,671.8,676.3,680.1,684.5,688.4,692.6,696.3,699.9,703.6,707.3,711,714.5];
      
      figure(hf1)
      hold on
      plot(wavelength,ag);
      grid on
      title('a\_g profiles')
      
      %% Location
      figure(hf2)
      hold on
      plotm(sbHeader.north_latitude,sbHeader.east_longitude,'*r')
      
      count = count+1;
      InSitu(count).station = sbHeader.station;
      InSitu(count).start_date = sbHeader.start_date;
      InSitu(count).start_time = sbHeader.start_time;
      InSitu(count).filepath = filepath;
      InSitu(count).wavelength = wavelength;
      InSitu(count).ag = ag;
      InSitu(count).lat = sbHeader.north_latitude;
      InSitu(count).lon = sbHeader.east_longitude;
      
      fprintf('%s %i %s\n',sbHeader.station,sbHeader.start_date,sbHeader.start_time)
end
%%
save('GOCI_InSitu.mat','InSitu')

%%
load('GOCI_InSitu.mat')
load('/Users/jconchas/Documents/Research/GOCI/Images/MTLDIR/MTLGOCI_struct.mat')
whos InSitu MTLGOCI
unique([InSitu(:).start_date]','rows') % to have only one date per day

%%  Matchups
count = 0;
count2 = 0;
clear MatchupsGOCI MatchupsGOCI2
for idx = 1:size(InSitu,2)
      t = datetime(InSitu(idx).start_date,'ConvertFrom','yyyymmdd');
      t = char(t);
      t = [t(:,1:12) InSitu(idx).start_time];
      t = datetime(t,'ConvertFrom','yyyymmdd');
      
      A = abs([MTLGOCI(:).Scene_end_time]-t);
      [t_dif,I] = min(A);
      t_dif2 = min(setdiff(A(:),min(A(:))));
      [~,I2] = min(abs(A - t_dif2));
      
      if t_dif <= hours(3)
            count = count+1;
            MatchupsGOCI(count) = InSitu(idx); % closest image
            MatchupsGOCI(count).Matchup_index = I; % index to the MTLGOCI structure
            MatchupsGOCI(count).Matchup_scene_id = MTLGOCI(I).Product_name;
      end
      
      if t_dif2 <= hours(3)
            count2 = count2+1;
            MatchupsGOCI2(count2) = InSitu(idx); % second closest image
            MatchupsGOCI2(count2).Matchup_index = I2; % index to the MTLGOCI structure
            MatchupsGOCI2(count2).Matchup_scene_id = MTLGOCI(I2).Product_name;
      end
      
end
%% Number of matchups
fprintf('Number of Matchups: %i\n',sum(~isnan([MatchupsGOCI(:).Matchup_index])))

%% Plot images
pathname = '/Users/jconchas/Documents/Research/GOCI/Images/L2Product/';

for idx = 1:size(MatchupsGOCI,2)
      %%
      if ~isnan(MatchupsGOCI(idx).Matchup_index(1)) && ...
                  ~isnan(MatchupsGOCI(idx).Matchup_scene_id(1))
            disp([pathname MatchupsGOCI(idx).Matchup_scene_id '_L2.nc'])
            
            if exist([pathname MatchupsGOCI(idx).Matchup_scene_id '_L2.nc'], 'file')
                  disp([pathname MatchupsGOCI(idx).Matchup_scene_id '_L2.nc' ' exist...'])
                  %% plot scene
                  filepath = [pathname MatchupsGOCI(idx).Matchup_scene_id '_L2.nc'];
                  longitude   = ncread(filepath,'/navigation_data/longitude');
                  latitude    = ncread(filepath,'/navigation_data/latitude');
                  ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
                  
                  plusdegress = 0.5;
                  latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
                  lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];
                  
                  figure('Color','white','Name',[MatchupsGOCI(idx).Matchup_scene_id '_L2.nc'])
                  % ax = worldmap([52 75],[170 -120]);
                  ax = worldmap(latlimplot,lonlimplot);
                   
                  load coastlines
                  geoshow(ax, coastlat, coastlon,...
                        'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
                  
                  geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
                  geoshow(ax,'worldrivers.shp', 'Color', 'blue')
                  % Display product
                  
                  geoshow(ax,latitude,longitude,log10(ag_412_mlrc),'DisplayType','surface','ZData',zeros(size(ag_412_mlrc)),'CData',log10(ag_412_mlrc))
                  % Plot in situ data
                  hold on
                  plotm(MatchupsGOCI(idx).lat,MatchupsGOCI(idx).lon,'*c')
                  textm(MatchupsGOCI(idx).lat,MatchupsGOCI(idx).lon,MatchupsGOCI(idx).station)
                 
                  
                  colormap jet
                  waitforbuttonpress;
                  
            else
                  % File does not exist.
                  warningMessage = sprintf('Warning: file does not exist:\n%s', fullFileName);
                  uiwait(msgbox(warningMessage));
            end
            
      end
      
end
addpath('/Users/jconchas/Documents/Research/LANDSAT8/')
%%
clear
fileID = fopen('WRS-2_bound_world.kml');
% Downloaded from: https://landsat.usgs.gov/tools_wrs-2_shapefile.php
C = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
%%
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
count
save('WRS2_pathrow_struct.mat','WRS_struct')
%%
load('WRS2_pathrow_struct.mat');
%%
v = 1:28556;

figure('Color','white')
ax = worldmap('World');
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
% geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
% geoshow(ax,'worldrivers.shp', 'Color', 'blue')
hold on
plotm([WRS_struct(v).CTR_LAT],[WRS_struct(v).CTR_LON],'.k')
% plotm([WRS_struct(v).LAT_UL],[WRS_struct(v).LON_UL],'*r')
% plotm([WRS_struct(v).LAT_UR],[WRS_struct(v).LON_UR],'*g')
% plotm([WRS_struct(v).LAT_LL],[WRS_struct(v).LON_LL],'*b')
% plotm([WRS_struct(v).LAT_LR],[WRS_struct(v).LON_LR],'*c')
%%
d = 1000; % index to the in situ data (Tara)
cond_lon = ...
      (lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_UL]>=0&...
      lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_UR]<=0)|...
      (lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_LL]>=0&...
      lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_LR]<=0);

cond_lat = ...
      (lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_LL]>=0&...
      lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_UL]<=0)|...
      (lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_LR]>=0&...
      lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_UR]<=0);

cond_in = cond_lon & cond_lat;

p = [WRS_struct(cond_in).PATH];
r = [WRS_struct(cond_in).ROW];
%% Plot Tara data on map
n = 4;

figure('Color','white')
ax = worldmap([45 90],[-180 180]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
hold on

disp('--------------------------------------------')
disp(['In situ taken ',datestr(t(d))])
fprintf('path:%i , row:%i\n',p(n),r(n))

[I,ImageDate,R,h] = landsat(p(n),r(n),datestr(t(d)));
plotm(lat,lon,'r*-')
%%
days_offset = 3;
clear Matchup
clc
idx_match = 0;
h1 = waitbar(0,'Initializing ...');
tic
for d = 1:size(lon,1)
      waitbar(d/size(lon,1),h1,'Processing')
      cond_lon = ...
            (lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_UL]>=0&...
            lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_UR]<=0)|...
            (lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_LL]>=0&...
            lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_LR]<=0);
      
      cond_lat = ...
            (lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_LL]>=0&...
            lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_UL]<=0)|...
            (lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_LR]>=0&...
            lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_UR]<=0);
      
      cond_in = cond_lon & cond_lat;
      
      p = [WRS_struct(cond_in).PATH];
      r = [WRS_struct(cond_in).ROW];
      for n=1:size(p,2) %  how many path and row combinations
            if datenum(t(d))-datenum(days_offset) >= datenum(2013,2,11) % date must be larger than Landsat 8 first scene
                  [~,ImageDate,~,~] = landsat(p(n),r(n),datestr(datetime([t(d).Year t(d).Month t(d).Day])+days_offset),'nomap');
                  if ~isempty(ImageDate)
                        if ImageDate >= datenum(t(d))-datenum(days_offset)
                              disp('--------------------------------------------')
                              disp(['In situ taken: ',datestr(t(d))])
                              
                              disp(['Image taken:   ',datestr(ImageDate)])
                              
                              
                              fprintf('path:%i , row:%i, d:%i\n',p(n),r(n),d)
                              da = datevec(ImageDate);
                              v = datenum(da);
                              DOY = v - datenum(da(:,1), 1,0);
                              L8id = ['LC8',sprintf('%03.f',p(n)),sprintf('%03.f',r(n)),sprintf('%03.f',da(:,1)),...
                                    sprintf('%03.f',DOY),'LGN00'] ;
                              fprintf('ID: %s\n',L8id)
                              
                              % Save it in a structure
                              idx_match = idx_match + 1;
                              Matchup(idx_match).number_d = d;
                              Matchup(idx_match).id_scene = L8id;
                        end
                  end
            end
      end
end
close(h1)
save('L8Matchups_Arctics.mat','Matchup')
toc
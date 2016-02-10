addpath('/Users/jconchas/Documents/Research/LANDSAT8/')
%%
clear
fileID = fopen('WRS-2_bound_world.kml');
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
d = 1000;
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

WRS_struct(cond_in).Name


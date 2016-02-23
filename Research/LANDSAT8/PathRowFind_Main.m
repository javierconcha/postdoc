addpath('/Users/jconchas/Documents/Research/LANDSAT8/')
%%
% clear
% fileID = fopen('WRS-2_bound_world.kml');
% % Downloaded from: https://landsat.usgs.gov/tools_wrs-2_shapefile.php
% C = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);
% %%
% count =0;
% for idx=1:size(C{:},1)
%       %       if strcmp(C{1}{idx},'<name>')
%       %             count = count+1;
%       %       end
%       if regexp(C{1}{idx},'<strong>PATH</strong>:')
%             count = count+1;
%             WRS_struct(count).linenumber = idx;
%             aux = textscan(C{1}{idx},'%s','Delimiter','<>_:');
%             WRS_struct(count).PATH = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+1},'%s','Delimiter','<>_:');
%             WRS_struct(count).ROW  = str2double(aux{1}{6});
%
%             aux = textscan(C{1}{idx+2},'%s','Delimiter','<>_:');
%             WRS_struct(count).CTR_LAT = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+3},'%s','Delimiter','<>_:');
%             WRS_struct(count).CTR_LON = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+4},'%s','Delimiter','<>:');
%             WRS_struct(count).Name    = aux{1}{6};
%             aux = textscan(C{1}{idx+5},'%s','Delimiter','<>_:');
%             WRS_struct(count).LAT_UL  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+6},'%s','Delimiter','<>_:');
%             WRS_struct(count).LON_UL  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+7},'%s','Delimiter','<>_:');
%             WRS_struct(count).LAT_UR  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+8},'%s','Delimiter','<>_:');
%             WRS_struct(count).LON_UR  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+9},'%s','Delimiter','<>_:');
%             WRS_struct(count).LAT_LL  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+10},'%s','Delimiter','<>_:');
%             WRS_struct(count).LON_LL  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+11},'%s','Delimiter','<>_:');
%             WRS_struct(count).LAT_LR  = str2double(aux{1}{6});
%             aux = textscan(C{1}{idx+12},'%s','Delimiter','<>_:');
%             WRS_struct(count).LON_LR  = str2double(aux{1}{6});
%
%       end
% end
% count
% save('WRS2_pathrow_struct.mat','WRS_struct')
% %%
% load('WRS2_pathrow_struct.mat');
% %%
% v = 1:28556;
%
% figure('Color','white')
% ax = worldmap('World');
% % ax = worldmap('North Pole');
% load coastlines
% geoshow(ax, coastlat, coastlon,...
%       'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
% % geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
% % geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% hold on
% plotm([WRS_struct(v).CTR_LAT],[WRS_struct(v).CTR_LON],'.k')
% % plotm([WRS_struct(v).LAT_UL],[WRS_struct(v).LON_UL],'*r')
% % plotm([WRS_struct(v).LAT_UR],[WRS_struct(v).LON_UR],'*g')
% % plotm([WRS_struct(v).LAT_LL],[WRS_struct(v).LON_LL],'*b')
% % plotm([WRS_struct(v).LAT_LR],[WRS_struct(v).LON_LR],'*c')
% %%
% d = 1000; % index to the in situ data (Tara)
% cond_lon = ...
%       (lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_UL]>=0&...
%       lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_UR]<=0)|...
%       (lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_LL]>=0&...
%       lon(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LON_LR]<=0);
%
% cond_lat = ...
%       (lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_LL]>=0&...
%       lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_UL]<=0)|...
%       (lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_LR]>=0&...
%       lat(d)*ones(1,size(WRS_struct,1))-[WRS_struct(:).LAT_UR]<=0);
%
% cond_in = cond_lon & cond_lat;
%
% p = [WRS_struct(cond_in).PATH];
% r = [WRS_struct(cond_in).ROW];
% %% Plot Tara data on map
% n = 4;
%
% figure('Color','white')
% ax = worldmap([45 90],[-180 180]);
% % ax = worldmap('North Pole');
% load coastlines
% geoshow(ax, coastlat, coastlon,...
%       'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
% geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
% geoshow(ax,'worldrivers.shp', 'Color', 'blue')
% hold on
%
% disp('--------------------------------------------')
% disp(['In situ taken ',datestr(t(d))])
% fprintf('path:%i , row:%i\n',p(n),r(n))
%
% [I,ImageDate,R,h] = landsat(p(n),r(n),datestr(t(d)));
% plotm(lat,lon,'r*-')
%%
clear DB
clc
h1 = waitbar(0,'Initializing ...');
tic
aux_idx = 0;
firsttime = true;
days_offset = 3;
db_idx = 0;
cond_in = zeros(1,size(WRS_struct,2));
for d = 1:size(lon,1)
      waitbar(d/size(lon,1),h1,'Determining paths and rows...')

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

%%
clear Matchup
tic
h2 = waitbar(0,'Initializing ...');
idx_match = 0;
for n=1:size(DB,2) %  how many path and row combinations
      waitbar(n/size(DB,2),h2,'Looking for Matchups')
      if datenum(datetime([DB(n).YEAR DB(n).MONTH DB(n).DAY]))-datenum(days_offset) >= datenum(2013,2,11) % date must be larger than Landsat 8 first scene
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
toc
save('L8Matchups_Arctics.mat','Matchup','DB')

%%
load('L8Matchups_Arctics.mat')
% %% Testing algorithm
% pr = WRS_struct([WRS_struct.PATH]==210 & [WRS_struct.ROW]==17);
% 
% figure,worldmap('world')
% landsat(210,17)
% plotm(pr.LAT_UL,pr.LON_UL,'*r') % from path row
% hold on
% plotm(62.51995,-10.22183,'b*') % from MTL
% plotm(pr.LAT_UR,pr.LON_UR,'*r')
% plotm(62.48299,-5.56307,'b*')
% plotm(pr.LAT_LL,pr.LON_LL,'*r')
% plotm(60.42240,-10.14323,'b*')
% plotm(pr.LAT_LR,pr.LON_LR,'*r')
% plotm(60.38851,-5.78629,'b*')
% 
% %%
% pr = WRS_struct([WRS_struct.PATH]==210 & [WRS_struct.ROW]==17);
% 
% figure
% worldmap('world')
% % landsat(210,18)
% plotm(pr.LAT_UL,pr.LON_UL,'*r') % from path row
% hold on
% plotm(pr.LAT_UR,pr.LON_UR,'*r')
% plotm(pr.LAT_LL,pr.LON_LL,'*r')
% plotm(pr.LAT_LR,pr.LON_LR,'*r')
% hold on
% plotm(lat(d),lon(d),'*c')
% 
% %%
% figure
% xv = [pr.LON_LL pr.LON_LR pr.LON_UR pr.LON_UL pr.LON_LL];
% yv = [pr.LAT_LL pr.LAT_LR pr.LAT_UR pr.LAT_UL pr.LAT_LL];
% x =lon(d); y = lat(d);
% in = inpolygon(x,y,xv,yv);
% plot(xv,yv,x(in),y(in),'*r',x(~in),y(~in),'*b')
% 

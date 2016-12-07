% Matchups for aCDOM(412) for:
% GEOCAPE_GOCI_Dec2010
% GEOCAPE_GOCI_Apr2011
% GEOCAPE_GOCI_Aug2011
% GOCI_2013

addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/Images/MTLDIR')
addpath('/Users/jconchas/Documents/Research/GOCI')
cd '/Users/jconchas/Documents/Research/GOCI/InSitu';

%% Open file for cruise GEOCAPE_GOCI
clear
clc
close all
count = 0; % to create the InSitu structure

% run multiple time, one for each in situ cruise
DIRMAT(1).dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Dec2010/archive/ag/';
DIRMAT(2).dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Apr2011/archive/ag/';
DIRMAT(3).dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GEOCAPE_GOCI/GEOCAPE_GOCI_Aug2011/archive/ag/';

for idx0=1:size(DIRMAT,2)
      % Open file with the list of images names
      fileID = fopen([DIRMAT(idx0).dirname 'file_list.txt']);
      s = textscan(fileID,'%s','Delimiter','\n');
      fclose(fileID);
      
      % figure for plottig the data
      figure('Color','white')
      hf1 = gcf;
      ylabel('a\_g (m\^-1)')
      xlabel('wavelength (nm)')
      
      
      % Plot GOCI footprint
      figure('Color','white')
      hf2 = gcf;
      ax = worldmap([30 45],[116 136]);
      % ax = worldmap('North Pole');
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
            InSitu(count).filepath = filepath;
            InSitu(count).wavelength = data.wavelength;
            InSitu(count).ag = data.ag;
            InSitu(count).ag_412_insitu = data.ag(data.wavelength==412);
            InSitu(count).lat = sbHeader.north_latitude;
            InSitu(count).lon = sbHeader.east_longitude;
            
            fprintf('%s %i %s\n',sbHeader.station,sbHeader.start_date,sbHeader.start_time)
      end
      clear coastlat coastlon ax idx filepath dirname filename
end
% Open file for cruise GOCI_2013
dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/NASA_GSFC/GOCI_2013/archive/iop/';


% Open file with the list of images names
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

% figure for plottig the data
figure('Color','white')
hf1 = gcf;
ylabel('a\_g (m\^-1)')
xlabel('wavelength (nm)')

% Plot GOCI footprint
figure('Color','white')
hf2 = gcf;
ax = worldmap([30 45],[116 136]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
      'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
%

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
      InSitu(count).ag_412_insitu = ag(wavelength==412.6);
      InSitu(count).lat = sbHeader.north_latitude;
      InSitu(count).lon = sbHeader.east_longitude;
      
      fprintf('%s %i %s\n',sbHeader.station,sbHeader.start_date,sbHeader.start_time)
end
%
% save('GOCI_InSitu.mat','InSitu')

%%
% load('GOCI_InSitu.mat')
load('/Users/jconchas/Documents/Research/GOCI/Images/MTLDIR/MTLGOCI_struct.mat') % from ~/Documents/Research/GOCI/Images/MTLDIR/CreateMTL.m
whos InSitu MTLGOCI
unique([InSitu(:).start_date]','rows') % to have only one date per day
% this list is used to search for the GOCI scene in the in house server
% from the list goci_l1.txt provided by John Wildings

%%  Matchups
count = 0;
count2 = 0;
clear MatchupsGOCI MatchupsGOCI2
for idx = 1:size(InSitu,2)
      t = datetime(InSitu(idx).start_date,'ConvertFrom','yyyymmdd');
      t = char(t);
      t = [t(:,1:12) InSitu(idx).start_time];
      t = datetime(t,'ConvertFrom','yyyymmdd');
      
      A = abs([MTLGOCI(:).Scene_center_time]-t);
      [t_dif,I] = min(A);
      t_dif2 = min(setdiff(A(:),min(A(:))));
      [~,I2] = min(abs(A - t_dif2));
      
      if t_dif <= hours(3)
            count = count+1;
            MatchupsGOCI(count).station = InSitu(idx).station; % closest image
            MatchupsGOCI(count).start_date = InSitu(idx).start_date;
            MatchupsGOCI(count).start_time = InSitu(idx).start_time;
            MatchupsGOCI(count).filepath = InSitu(idx).filepath;
            MatchupsGOCI(count).wavelength = InSitu(idx).wavelength;
            MatchupsGOCI(count).ag = InSitu(idx).ag;
            MatchupsGOCI(count).ag_412_insitu = InSitu(idx).ag_412_insitu;
            MatchupsGOCI(count).lat = InSitu(idx).lat;
            MatchupsGOCI(count).lon = InSitu(idx).lon;
            MatchupsGOCI(count).MTL_index = I; % index to the MTLGOCI structure
            MatchupsGOCI(count).Matchup_scene_id = MTLGOCI(I).Product_name;
            MatchupsGOCI(count).close_status = 1; % 1 if closest, 2 if second closest
            MatchupsGOCI(count).t_dif = t_dif;
      end
      
      if t_dif2 <= hours(3)
            count2 = count2+1;
            MatchupsGOCI2(count2).station = InSitu(idx).station; % second closest image
            MatchupsGOCI2(count2).start_date = InSitu(idx).start_date;
            MatchupsGOCI2(count2).start_time = InSitu(idx).start_time;
            MatchupsGOCI2(count2).filepath = InSitu(idx).filepath;
            MatchupsGOCI2(count2).wavelength = InSitu(idx).wavelength;
            MatchupsGOCI2(count2).ag = InSitu(idx).ag;
            MatchupsGOCI2(count2).ag_412_insitu = InSitu(idx).ag_412_insitu;
            MatchupsGOCI2(count2).lat = InSitu(idx).lat;
            MatchupsGOCI2(count2).lon = InSitu(idx).lon;
            MatchupsGOCI2(count2).MTL_index = I2; % index to the MTLGOCI structure
            MatchupsGOCI2(count2).Matchup_scene_id = MTLGOCI(I2).Product_name;
            MatchupsGOCI2(count2).close_status = 2; % 1 if closest, 2 if second closest
            MatchupsGOCI2(count2).t_dif = t_dif2;
      end
      
end
% clear idx t A t_dif t_dif2 I2 I count count2

%% See if there is valid value in the product and plot the images
pathname = '/Volumes/Data/GOCI/L2Product/'; % for the default aer_opt=-2
% pathname = '/Volumes/Data/GOCI/L2n1Product/';% for aer_opt=-1
clear MatchupMat
% MatchupMat = MatchupsGOCI;
MatchupMat = [MatchupsGOCI MatchupsGOCI2];

image_list = unique({MatchupMat(:).Matchup_scene_id}'); % not repeated images
h1 = waitbar(0,'Initializing ...');

for idx = 1:size(image_list,1)
      waitbar(idx/size(image_list,1),h1,'Searching for matchups...')
      %%
      firsttime = true;
      filepath = [pathname image_list{idx} '_L2.nc']; % '_L2n1.nc' or '_L2.nc']
      if exist(filepath, 'file');
            %% Extract info
            longitude   = ncread(filepath,'/navigation_data/longitude');
            latitude    = ncread(filepath,'/navigation_data/latitude');
            ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
            
            for idx2 = 1:size(MatchupMat,2)
                  if image_list{idx} == MatchupMat(idx2).Matchup_scene_id
                        %% closest distance
                        % latitude and longitude are arrays of MxN
                        % lat0 and lon0 is the coordinates of one point
                        lat0 = MatchupMat(idx2).lat;
                        lon0 = MatchupMat(idx2).lon;
                        dist_squared = (latitude-lat0).^2 + (longitude-lon0).^2;
                        [m,I] = min(dist_squared(:));
                        [r,c]=ind2sub(size(latitude),I); % index to the closest in the latitude and longitude arrays
                        clear lat0 lon0 m I dist_squared
                        if ~isnan(ag_412_mlrc(r,c))
                              disp('------------------------------------------')
                              disp(['Image: ' image_list{idx}])
                              disp(['START: ' datestr(MTLGOCI(MatchupMat(idx2).MTL_index).Scene_Start_time)])
                              disp(['END: ' datestr(MTLGOCI(MatchupMat(idx2).MTL_index).Scene_end_time)])
                              
                              ag_412_insitu = MatchupMat(idx2).ag_412_insitu;
                              
                              t = datetime(MatchupMat(idx2).start_date,'ConvertFrom','yyyymmdd');
                              t = char(t);
                              t = [t(:,1:12) MatchupMat(idx2).start_time];
                              t = datetime(t,'ConvertFrom','yyyymmdd');
                              
                              disp(['In Situ taken on ' datestr(t)])
                              
                              fprintf('Station: %s; In Situ: %2.4f; Product: %2.4f\n',MatchupMat(idx2).station,ag_412_insitu,ag_412_mlrc (r,c))
                              
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
                              
                              MatchupMat(idx2).ag_412_mlrc_mean = window_mean;
                              MatchupMat(idx2).ag_412_mlrc_meadian = nanmedian(window(:));
                              MatchupMat(idx2).ag_412_mlrc_std = window_std;
                              MatchupMat(idx2).ag_412_mlrc_center = ag_412_mlrc(r,c);
                              
                              if CV < 0.15 && size(window_filt,1)>=5 % filter outliers and at least 5 pixels form the 3x3 pixel arrays (from Mannino at al. 2014)
                                    MatchupMat(idx2).ag_412_mlrc_filt_mean = mean(window_filt);
                                    MatchupMat(idx2).ag_412_mlrc_filt_std = std(window_filt);
                                    
                              else
                                    warning('CV < 0.15. ag_412_mlrc not valid.')
                                    MatchupMat(idx2).ag_412_mlrc_filt_mean = NaN;
                                    MatchupMat(idx2).ag_412_mlrc_filt_std = NaN;
                              end
                              
                              MatchupMat(idx2).ag_412_mlrc_filt_min = min(window_filt);
                              MatchupMat(idx2).ag_412_mlrc_filt_max = max(window_filt);
                              MatchupMat(idx2).valid_px = sum(~isnan(window(:)));
                              MatchupMat(idx2).ag_412_mlrc_filt_px_count = sum(~isnan(window_filt(:)));
                              MatchupMat(idx2).ag_412_insitu = ag_412_insitu;
                              MatchupMat(idx2).window = window;
                              MatchupMat(idx2).CV = CV;
                              
                              %% Plot
                              plusdegress = 0;
                              latlimplot = [min(latitude(:))-.5*plusdegress max(latitude(:))+.5*plusdegress];
                              lonlimplot = [min(longitude(:))-plusdegress max(longitude(:))+plusdegress];
                              
                              if firsttime
                                    
                                    h = figure('Color','white','Name',[image_list{idx} '_L2.nc']);
                                    % ax = worldmap([52 75],[170 -120]);
                                    ax = worldmap(latlimplot,lonlimplot);
                                    mlabel('MLabelParallel','north')
                                    
                                    load coastlines
                                    geoshow(ax, coastlat, coastlon,...
                                          'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
                                    
                                    geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
                                    geoshow(ax,'worldrivers.shp', 'Color', 'blue')
                                    % Display product
                                    
                                    %             geoshow(ax,latitude,longitude,log10(ag_412_mlrc),'DisplayType','surface',...
                                    %                   'ZData',zeros(size(ag_412_mlrc)),'CData',log10(ag_412_mlrc))
                                    
                                    pcolorm(latitude,longitude,log10(ag_412_mlrc)) % faster than geoshow
                                    colormap jet
                                    firsttime = false;
                              end
                              % Plot in situ data
                              figure(h)
                              hold on
                              
                              plotm(MatchupMat(idx2).lat,MatchupMat(idx2).lon,'om','markerfacecolor','m')
                              textm(MatchupMat(idx2).lat,MatchupMat(idx2).lon,MatchupMat(idx2).station)
                              plotm(latitude(r,c),longitude(r,c),'*m')
                              
                        else
                              MatchupMat(idx2).ag_412_mlrc_center = NaN;
                        end
                        
                  end
                  %% Plot when all the stations are processed for one scene
                  if idx2 == size(MatchupMat,2) && ~isnan(ag_412_mlrc(r,c))
                        figure(gcf)
                        fs = 16;
                        ag_412_mlrc_log10 =log10(ag_412_mlrc);
                        ag_412_mlrc_mean = nanmean(ag_412_mlrc_log10(:));
                        ag_412_mlrc_std= nanstd(ag_412_mlrc_log10(:));
                        cte = 3;
                        set(gca, 'CLim', [ag_412_mlrc_mean-cte*ag_412_mlrc_std, ag_412_mlrc_mean+cte*ag_412_mlrc_std]);
                        
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
                        set(hbar,'XTickLabel',x_clean,'FontSize',fs-4)
                        %                         title(image_list{idx},'interpreter', 'none')
                        saveas(gcf,['/Users/jconchas/Documents/Research/GOCI/InSitu/MatlabFigs/' image_list{idx} '.png'],'png')
                  end
            end
            
            %             waitforbuttonpress;
            
      else
            % File does not exist.
            warningMessage = sprintf('Warning: file does not exist:\n%s', fullFileName);
            uiwait(msgbox(warningMessage));
      end
end

close(h1)

% clear pathname h1 idx idx2 ax r c count count2 coastlat coastlon ...
%       firsttime h plusdegress latlimplot lonlimplot ag_412_mlrc ...
%       ag_412_insitu image_list latitude longitude t

% save('GOCI_Matchups.mat','MatchupMat','MatchupsGOCI','MatchupsGOCI2')
%% Plotting in situ vs retrieved filtered and NO filtered
% load('GOCI_Matchups.mat','MatchupMat','MatchupsGOCI','MatchupsGOCI2')
cond1 = ~isnan([MatchupMat.ag_412_mlrc_center]) & [MatchupMat.close_status] == 1; % closest
cond2 = ~isnan([MatchupMat.ag_412_mlrc_center]) & [MatchupMat.close_status] == 2; % second closest
%
fs = 16;
figure('Color','white','DefaultAxesFontSize',fs)
%
hold on
plot([MatchupMat(cond1).ag_412_insitu],[MatchupMat(cond1).ag_412_mlrc_center],'*r')
plot([MatchupMat(cond1).ag_412_insitu],[MatchupMat(cond1).ag_412_mlrc_filt_mean],'or')
plot([MatchupMat(cond2).ag_412_insitu],[MatchupMat(cond2).ag_412_mlrc_center],'*b')
plot([MatchupMat(cond2).ag_412_insitu],[MatchupMat(cond2).ag_412_mlrc_filt_mean],'ob')
legend('Closest center','Closest filt. mean','2nd Closest center','2nd Closest filt. mean')
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
ax = gca;
ax.XTick =ax.YTick;
grid on
%% Plotting in situ vs retrieved Filtered
% load('GOCI_Matchups.mat','MatchupMat','MatchupsGOCI','MatchupsGOCI2')
cond1 = ~isnan([MatchupMat.ag_412_mlrc_center]) & [MatchupMat.close_status] == 1; % closest
cond2 = ~isnan([MatchupMat.ag_412_mlrc_center]) & [MatchupMat.close_status] == 2; % second closest
%
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);
%
hold on
plot([MatchupMat(cond1).ag_412_insitu],[MatchupMat(cond1).ag_412_mlrc_filt_mean],'or')
plot([MatchupMat(cond2).ag_412_insitu],[MatchupMat(cond2).ag_412_mlrc_filt_mean],'sqb')
legend('Closest filt. mean','2nd Closest filt. mean')
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
ax = gca;
ax.XTick =ax.YTick;
grid on

%% Statistics
C_insitu = [[MatchupMat(cond1).ag_412_insitu] [MatchupMat(cond2).ag_412_insitu]];
C_alg = [[MatchupMat(cond1).ag_412_mlrc_filt_mean] [MatchupMat(cond2).ag_412_mlrc_filt_mean]];
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

%% Clean version of the matchups
clear MatchupMatTemp MatchupMatClean
count = 0;

MatchupMatTemp = MatchupMat(~isnan([MatchupMat.ag_412_mlrc_center]));
MatchupMatTemp(1).used = [];

for idx=1:size(MatchupMatTemp,2)
      cond3 = [MatchupMatTemp.lat]==MatchupMatTemp(idx).lat ...
            & [MatchupMatTemp.lon]==MatchupMatTemp(idx).lon;
      
      if sum(cond3) > 1 && isempty(MatchupMatTemp(idx).used) % if there are more than one product values for the same station location
            ind = find(cond3==1);
            for idx3=1:size(ind,2)
                  MatchupMatTemp(ind(idx3)).used = true;
            end
            [~,I] = max([MatchupMatTemp(ind).t_dif]);
            count = count+1;
            MatchupMatClean(count) = MatchupMatTemp(ind(I));
      elseif sum(cond3)==1
            count = count+1;
            MatchupMatClean(count) = MatchupMatTemp(idx);
      end
end

clear MatchupMatTemp
save('GOCI_Matchups.mat','MatchupMatClean','-append')
%% Plotting in situ vs retrieved Filtered
load('GOCI_Matchups.mat','MatchupMat','MatchupsGOCI','MatchupsGOCI2','MatchupMatClean')
fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);
%
hold on
plot([MatchupMatClean.ag_412_insitu],[MatchupMatClean.ag_412_mlrc_filt_mean],'ob');
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
ax = gca;
ax.XTick =ax.YTick;
grid on
%% Statistics
C_insitu = [MatchupMatClean.ag_412_insitu];
C_alg = [MatchupMatClean.ag_412_mlrc_filt_mean];
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
%% Distribution of all in situ data
fs = 16;
figure('Color','white','DefaultAxesFontSize',fs)
fs = 16;
hist([InSitu(:).ag_412_insitu],20)
xlabel('in situ a_{CDOM}(412) (m^{-1})','FontSize',fs)
ylabel('Frequency','FontSize',fs)
title('Histogram','FontSize',fs)

ag412_mean = mean([InSitu(:).ag_412_insitu]);
ag412_stdv = std([InSitu(:).ag_412_insitu]);
ag412_min = min([InSitu(:).ag_412_insitu]);
ag412_max = max([InSitu(:).ag_412_insitu]);
N = size([InSitu(:).ag_412_insitu],2);

str2 = sprintf('Mean: %2.4f\nSd: %2.4f\nmax: %2.4f\nmin: %2.4f\nN: %i\n',...
      ag412_mean,ag412_stdv,ag412_min,ag412_max,N);
xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.6*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.75*(yLimits(2)-yLimits(1));

hold on
text(xLoc,yLoc,str2,'FontSize',fs,'FontWeight','normal');
disp(str2)
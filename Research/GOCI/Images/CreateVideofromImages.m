%% Script to create video from png images
cd /Users/jconchas/Documents/Research/GOCI/Images/Videos/
clear
close all
clc
%% Open product, create a Raster with all eight images. Determine min and max for the colorbar
pathname = '/Volumes/Data/GOCI/L2n1Product_diurnal_var/';% for aer_opt=-1
videopath = '/Users/jconchas/Documents/Research/GOCI/Images/Videos/';
% filename = 'COMS_GOCI_L1B_GA_20120527001639.he5_L2n1.nc';
% filepath = [pathname filename];

% Open file with the list of images names
fileID = fopen([pathname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

idx3 = 0;
for idx=1:size(s{:},1)
      for idx2 = 1:8
            filenametemp = s{1}{idx}; % search on the list of filenames
            
            filepathtemp = [pathname filenametemp(1:25) '0' num2str(idx2-1)];
            
            filepath = ls([filepathtemp '*']);
            
            filepath = filepath(1:end-1);
            
            clear filenametemp filepathtemp
            
            idx3 = idx3+1;
            %       filepath = [pathname image_list{idx} '_L2n1.nc']; % '_L2n1.nc' or '_L2.nc']
            if exist(filepath, 'file');
                  %% Extract info
                  Raster(idx3).filename = filepath(end-42:end);
                  Raster(idx3).longitude   = ncread(filepath,'/navigation_data/longitude');
                  Raster(idx3).latitude    = ncread(filepath,'/navigation_data/latitude');
                  Raster(idx3).ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc');
            else
                  % File does not exist.
                  warningMessage = sprintf('Warning: file does not exist:\n%s', filepath);
                  uiwait(msgbox(warningMessage));
            end
      end
      
      
      %%
      temp = log10([Raster(idx3-7:idx3).ag_412_mlrc]);
      minval = nanmin(temp(:));
      maxval = nanmax(temp(:));
      ag_412_mlrc_mean = nanmean(temp(:));
      ag_412_mlrc_std= nanstd(temp(:));
      
      clear temp
      %%
      for idx2=1:8
            % Plot
            plusdegress = 0;
            latlimplot = [min(Raster(idx3-8+idx2).latitude(:))-.5*plusdegress max(Raster(idx3-8+idx2).latitude(:))+.5*plusdegress];
            lonlimplot = [min(Raster(idx3-8+idx2).longitude(:))-plusdegress max(Raster(idx3-8+idx2).longitude(:))+plusdegress];
            
            h = figure('Color','white','Name',Raster(idx3-8+idx2).filename);
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
            
            ag_412_mlrc_log10 =log10(Raster(idx3-8+idx2).ag_412_mlrc);
            
            pcolorm(Raster(idx3-8+idx2).latitude,Raster(idx3-8+idx2).longitude,ag_412_mlrc_log10) % faster than geoshow
            colormap jet
            
            figure(gcf)
            fs = 16;
            htitle = title([num2str(idx2) ':00h'],'FontSize',fs);
            v = axis;
            set(htitle,'Position',[v(1)*0.95 v(4)*0.95])
            
            %       ag_412_mlrc_mean = nanmean(ag_412_mlrc_log10(:));
            %       ag_412_mlrc_std= nanstd(ag_412_mlrc_log10(:));
            cte = 3;
            set(gca, 'CLim', [ag_412_mlrc_mean-cte*ag_412_mlrc_std, ...
                  ag_412_mlrc_mean+cte*ag_412_mlrc_std]);
            
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
            %                         title(image_list{idx3},'interpreter', 'none')
            saveas(gcf,[videopath Raster(idx3-8+idx2).filename '.png'],'png')
            % load the images
            idx2
            images{idx2} = imread([videopath Raster(idx3-8+idx2).filename '.png']);
            
      end
      
      %% Create the video
      % create the video writer with 4 fps
      writerObj = VideoWriter([filepath(end-42:end) '.avi']);
      fps = 6; % frames per second
      writerObj.FrameRate = fps;
      % set the seconds per image
      startDelay = 1; % starting delay in seconds
      secsPerImage = startDelay:1/fps:((length(images)-1)/fps)+startDelay;
      % open the video writer
      open(writerObj);
      % write the frames to the video
      for u=1:length(images)
            % convert the image to a frame
            frame = im2frame(images{u});
            for v=1:secsPerImage(u)
                  writeVideo(writerObj, frame);
            end
      end
      % close the writer object
      close(writerObj);
      clear images
      close all
end



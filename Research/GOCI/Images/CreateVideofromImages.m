%% Script to create video from png images
cd /Users/jconchas/Documents/Research/GOCI/Images/Videos/
% clear
close all
clc
%% Open product, create a Raster with all eight images. Determine min and max for the colorbar
pathname = '/Volumes/Data/GOCI/L2n1Product_diurnal_var/';% for aer_opt=-1
% pathname = '/Users/jconchas/Documents/Research/GOCI/Images/COMS_GOCI_L1B_GA_201512240x1640/';

videopath = '/Users/jconchas/Documents/Research/GOCI/Images/Videos/';
% filename = 'COMS_GOCI_L1B_GA_20120527001639.he5_L2n1.nc';
% filepath = [pathname filename];

% Open file with the list of images names
fileID = fopen([pathname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

% ROI = 'Whole';
ROI_name = 'South_Korea';

% Preallocation
Raster(8*size(s{:},1)).filename = '';
x_clean = cell(1,8);
images = cell(1,8);

h1 = waitbar(0,'Initializing ...');

idx3 = 0;
for idx=1:size(s{:},1)
      for idx2 = 1:8
            
            waitbar(((idx-1)*8+idx2)/(8*size(s{:},1)),h1,'Creating Videos...')
            
            filenametemp = s{1}{idx}; % search on the list of filenames
            
            filepathtemp = [pathname filenametemp(1:25) '0' num2str(idx2-1)];
            
            filepath = ls([filepathtemp '*.he5*']);
            
            filepath = filepath(1:end-1);
            
            clear filenametemp filepathtemp
            
            idx3 = idx3+1;
            %       filepath = [pathname image_list{idx} '_L2n1.nc']; % '_L2n1.nc' or '_L2.nc']
            if exist(filepath, 'file');
                  
                  switch ROI_name
                        case 'Whole'
                              %% Extract info
                              Raster(idx3).filename = filepath(end-42:end);
                              Raster(idx3).longitude   = ncread(filepath,'/navigation_data/longitude',[1 1],[Inf Inf]);
                              Raster(idx3).latitude    = ncread(filepath,'/navigation_data/latitude',[1 1],[Inf Inf]);
                              Raster(idx3).ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc',[1 1],[Inf Inf]);
                              Raster(idx3).l2_flags = ncread(filepath,'/geophysical_data/l2_flags',[1 1],[Inf Inf]);
                              
                              Raster(idx3).LANDmask = bitget(Raster(idx3).l2_flags,2,'int32');
                              Raster(idx3).PRODFAILmask = bitget(Raster(idx3).l2_flags,31,'int32');
                              
                              % from ncdump -h
                              %                   int l2_flags(number_of_lines, pixels_per_line) ;
                              %                 l2_flags:long_name = "Level-2 Processing Flags" ;
                              %                 l2_flags:valid_min = -2147483648 ;
                              %                 l2_flags:valid_max = 2147483647 ;
                              %                 l2_flags:flag_masks = 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144
                              % , 524288, 1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, -2147483648 ;
                              %                 l2_flags:flag_meanings = "ATMFAIL LAND PRODWARN HIGLINT HILT HISATZEN COASTZ SPARE STRAYLIGHT CLDICE COCCOLITH TURBIDW HISOLZEN SPARE LOWLW CHLFAIL NAVWARN ABSAER SPARE MAXAERITER MODGLINT CHLWARN ATMWARN SPARE SEAICE NAVFAIL FILTER SPARE BOWTIEDEL HIPOL PRODFAIL SPARE" ;
                              %   } // group geophysical_data
                              
                        case 'South_Korea'
                              
                              %% Cropping to ROI
                              SWlat = 33;
                              SWlon = 123;
                              NElat = 40;
                              NElon = 131;
                              
                              % lat. The lat and lon are inverted in direction in the matrix from matlab
                              LAT_MAT = ncread(filepath,'/navigation_data/latitude');
                              [~,I] = min(abs(LAT_MAT-SWlat),[],2);
                              [SWlat_min_i,~] = max(I);
                              [~,I] = min(abs(LAT_MAT-NElat),[],2);
                              [NElat_max_i,~] = min(I);
                              
                              % lon
                              LON_MAT = ncread(filepath,'/navigation_data/longitude');
                              [~,I] = min(abs(LON_MAT-SWlon),[],1);
                              [SWlon_min_i,~] = min(I);
                              [~,I] = min(abs(LON_MAT-NElon),[],1);
                              [NElon_max_i,~] = max(I);
                              
                              Raster(idx3).filename = filepath(end-42:end);
                              
                              Raster(idx3).latitude    = LAT_MAT(SWlon_min_i:NElon_max_i,NElat_max_i:SWlat_min_i);

                              Raster(idx3).latitude    = LON_MAT(SWlon_min_i:NElon_max_i,NElat_max_i:SWlat_min_i);
                              
                              Raster(idx3).ag_412_mlrc = ncread(filepath,'/geophysical_data/ag_412_mlrc',...
                                    [SWlon_min_i NElat_max_i],[NElon_max_i-SWlon_min_i+1 SWlat_min_i-NElat_max_i+1]);
                              
                              A = ncread(filepath,'/geophysical_data/l2_flags',...
                                    [SWlon_min_i NElat_max_i],[NElon_max_i-SWlon_min_i+1 SWlat_min_i-NElat_max_i+1]);
                              
                              Raster(idx3).l2_flags = A;
                              
                              Raster(idx3).LANDmask = bitget(A,2,'int32');

                              Raster(idx3).PRODFAILmask = bitget(A,31,'int32');
                              
                              clear A B SWlat_min_i NElat_max_i SWlon_min_i NElon_max_i
                  end
                  
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
            %% Plot it
            fs = 16;
            h = figure('Color','white','Name',Raster(idx3-8+idx2).filename,'visible','off');
            
            ag_412_mlrc_log10 =log10(Raster(idx3-8+idx2).ag_412_mlrc);
            
            landmask = logical(Raster(idx3-8+idx2).LANDmask);
            prodfailmask = logical(Raster(idx3-8+idx2).PRODFAILmask);
            mask = landmask|prodfailmask;
            
            maskcolor =cat(3,   (0.7*landmask)+~prodfailmask, ...
                  (0.7*landmask)+~prodfailmask,...
                  (0.7*landmask)+~prodfailmask);
            
            % land mask
            imagesc(maskcolor)
            hold on
            
            h0 = imagesc(ag_412_mlrc_log10); % display Map image second. From PaperPlots.m
            set(h0, 'AlphaData', ~mask) % Apply transparency to the mask
            set(gca,'fontsize',fs)
            axis equal
            axis image
            axis off
            
            set(gca,'XDir','rev')
            
            view([-90 90]);
            
%             figure(gcf)
            
            %             htitle = title([num2str(idx2) ':00h'],'FontSize',fs);
            v = axis;
            
            switch ROI_name
                  case 'Whole_Image'
                        text(350,200,[num2str(idx2+8) ':00h'],'FontSize',25)
                  case 'South_Korea'
                        text(80,150,[num2str(idx2+8) ':00h'],'FontSize',25)
            end
            %%
            cte = 3;
            set(gca, 'CLim', [ag_412_mlrc_mean-cte*ag_412_mlrc_std, ...
                  ag_412_mlrc_mean+cte*ag_412_mlrc_std]);
            
            colormap jet
            
            %
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
            %% Save it
            saveas(gcf,[videopath Raster(idx3-8+idx2).filename '.png'],'png')
            % load the images
            images{idx2} = imread([videopath Raster(idx3-8+idx2).filename '.png']);
            
      end
      
      %% Create the video
      % create the video writer with 4 fps
      writerObj = VideoWriter([filepath(end-42:end) '.avi']);
      fps = 3; % frames per second
      writerObj.FrameRate = fps;
      % set the seconds per image
      startDelay = 2; % starting delay in seconds
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

close(h1)


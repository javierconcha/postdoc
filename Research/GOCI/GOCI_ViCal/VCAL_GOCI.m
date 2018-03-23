cd '/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/';

addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
addpath('/Users/jconchas/Documents/Research/GOCI/')
addpath('/Users/jconchas/Documents/Research/GOCI/SolarAzEl/')
addpath('/Users/jconchas/Documents/MATLAB')
%% with all brdf!!!
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.Rrs_412_04],'o')

hold on
plot([AQUA_DailyStatMatrix.datetime],[AQUA_DailyStatMatrix.Rrs_412_filtered_mean],'or')

legend(['GOCI 4h; N=' num2str(sum(~isnan([GOCI_DailyStatMatrix.Rrs_412_04])))],...
      ['AQUA; N=' num2str(sum(~isnan([AQUA_DailyStatMatrix.Rrs_412_filtered_mean])))])
xlabel('Time')
ylabel('R_{rs}(412)')


%% GOCI vcal gains from AQUA and VIIRS -- daily -- from GOCI_DailyStatMatrix
% savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/';
clear GOCI_date VIIRS_date AQUA_date
clear GOCI_date_vec AQUA_date_vec VIIRS_date_vec
clear GOCI_used VIIRS_used AQUA_used

brdf_opt = 7;

cond_brdf_GOCI = [GOCI_DailyStatMatrix.brdf_opt]==brdf_opt;
GOCI_date = [GOCI_DailyStatMatrix(cond_brdf_GOCI).datetime];
GOCI_used = GOCI_DailyStatMatrix(cond_brdf_GOCI);

cond_brdf_VIIRS = [VIIRS_DailyStatMatrix.brdf_opt]==brdf_opt;
VIIRS_date = [VIIRS_DailyStatMatrix(cond_brdf_VIIRS).datetime];
VIIRS_used = VIIRS_DailyStatMatrix(cond_brdf_VIIRS);

cond_brdf_AQUA = [AQUA_DailyStatMatrix.brdf_opt]==brdf_opt;
AQUA_date = [AQUA_DailyStatMatrix(cond_brdf_AQUA).datetime];
AQUA_used = AQUA_DailyStatMatrix(cond_brdf_AQUA);

% clear cond_brdf_GOCI cond_brdf_VIIRS cond_brdf_AQUA

% all in the same temporal grid
min_date = min([GOCI_date(1) AQUA_date(1)]);

max_date = max([GOCI_date(end) AQUA_date(end)]);

date_vec = min_date:max_date;

for idx=1:size(date_vec,2)
      if ~isempty(find(GOCI_date==date_vec(idx)))
            GOCI_date_vec(idx) = find(GOCI_date==date_vec(idx)); % indexes
      else
            GOCI_date_vec(idx) = NaN;
      end
      if ~isempty(find(AQUA_date==date_vec(idx)))
            AQUA_date_vec(idx) = find(AQUA_date==date_vec(idx));
      else
            AQUA_date_vec(idx) = NaN;
      end
      %       if ~isempty(find(VIIRS_date==date_vec(idx)))
      %             VIIRS_date_vec(idx) = find(VIIRS_date==date_vec(idx));
      %       else
      %             VIIRS_date_vec(idx) = NaN;
      %       end
end

% cond_VG = ~isnan(VIIRS_date_vec)&~isnan(GOCI_date_vec);
cond_AG = ~isnan(AQUA_date_vec)&~isnan(GOCI_date_vec);
% cond_VA = ~isnan(VIIRS_date_vec)&~isnan(AQUA_date_vec);

%%
% wl = {'412'};
wl = {'412','443','490','555','660','680'};

for idx0 = 1:size(wl,2)
      %% For AQUA
      if strcmp(wl{idx0},'412')
            wl_AQUA = '412';
      elseif strcmp(wl{idx0},'443')
            wl_AQUA = '443';
      elseif strcmp(wl{idx0},'490')
            wl_AQUA = '488';
      elseif strcmp(wl{idx0},'555')
            wl_AQUA = '547';
      elseif strcmp(wl{idx0},'660')
            wl_AQUA = '667';
      elseif strcmp(wl{idx0},'680')
            wl_AQUA = '678';
      end
      
      %% For VIIRS
      if strcmp(wl{idx0},'412')
            wl_VIIRS = '410';
      elseif strcmp(wl{idx0},'443')
            wl_VIIRS = '443';
      elseif strcmp(wl{idx0},'490')
            wl_VIIRS = '486';
      elseif strcmp(wl{idx0},'555')
            wl_VIIRS = '551';
      elseif strcmp(wl{idx0},'660')
            wl_VIIRS = '671';
      elseif strcmp(wl{idx0},'680') % REPEATING VIIRS-671 band for GOCI-660 and GOCI-680 nm!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            wl_VIIRS = '671';
      end
      
      %       %% GOCI Comparison with VIIRS
      %       [h1,ax1,leg1] = plot_sat_vs_sat('Rrs',wl{idx0},wl_VIIRS,'GOCI','VIIRS',...
      %             eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_VG))).Rrs_%s_04]',wl{idx0})),...
      %             eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VG))).Rrs_%s_filtered_mean]',wl_VIIRS)));
      %       legend off
      %       set(gcf, 'renderer','painters')
      %
      
      %       saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_' wl{idx0}],'epsc')
      %% GOCI Comparison with AQUA
      DEN = eval(sprintf('[GOCI_used(GOCI_date_vec(find(cond_AG))).Rrs_%s_04]',wl{idx0}));
      NUM = eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_AG))).Rrs_%s_filtered_mean]',wl_AQUA));
      
      g = DEN./NUM;
      %%
      fs = 20;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      subplot(2,1,1)
      eval(sprintf('plot(GOCI_date,[GOCI_used.Rrs_%s_04],''o'')',wl{idx0}));
      
      hold on
      eval(sprintf('plot(AQUA_date,[AQUA_used.Rrs_%s_filtered_mean],''ro'')',wl_AQUA));
      
      title(wl{idx0})
      legend(['GOCI, N=' num2str(sum(~isnan([GOCI_used.Rrs_412_04])))],...
            ['AQUA, N=' num2str(sum(~isnan([AQUA_used.Rrs_412_filtered_mean])))])
      %%
      datetime_vec = [AQUA_used(AQUA_date_vec(find(cond_AG))).datetime];
      
      subplot(2,1,2)
      
      % all data
      plot(datetime_vec', g,'ob')
      xlabel('Time','FontSize',fs)
      ylabel('Gain Coefficient','FontSize',fs)
      title(wl{idx0},'FontSize',fs)
      
      % mean all data
      ax = gca;
      hold on
      plot(ax.XLim,[nanmean(g) nanmean(g)],'r--')
      
      % semi-interquartile range
      Q1 = quantile(g(~isnan(g)),0.25);
      Q3 = quantile(g(~isnan(g)),0.75);
      cond_siqr = g >= Q1&g <= Q3;
      g_siqr = g(cond_siqr);
      
      % siqr mean
      q_siqr_mean = nanmean(g_siqr);
      
      plot(ax.XLim,[q_siqr_mean q_siqr_mean],'r')
      plot(ax.XLim,[Q1 Q1],'b')
      plot(ax.XLim,[Q3 Q3],'b')
      
      
      % plot semi-interquartile range data
      datetime_siqr = datetime_vec(cond_siqr);
      plot(datetime_siqr,g_siqr,'ob','MarkerFaceColor', 'b')
      
      
      legend(['all data; N=' num2str(sum(~isnan(g)))],...
            ['mean=' num2str(nanmean(g))],...
            ['mean siqr=' num2str(q_siqr_mean)],...
            ['Q1=' num2str(Q1)],...
            ['Q3=' num2str(Q3)],['siqr data;N=' num2str(sum(~isnan(g_siqr)))])
      
      screen_size = get(0, 'ScreenSize');
      origSize = get(gcf, 'Position'); % grab original on screen size
      set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
      %%
      %       figure
      %       hist(g(~isnan(g)))
      
      %
      %       legend off
      %       set(gcf, 'renderer','painters')
      
      %       saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_' wl{idx0}],'epsc')
      %       %% VIIRS Comparison with AQUA      % lower boundary
      %       [h3,ax3,leg3] = plot_sat_vs_sat('Rrs',wl_VIIRS,wl_AQUA,'VIIRS','AQUA',...
      %             eval(sprintf('[VIIRS_used(VIIRS_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_VIIRS)),...
      %             eval(sprintf('[AQUA_used(AQUA_date_vec(find(cond_VA))).Rrs_%s_filtered_mean]',wl_AQUA)));
      %       legend off
      %       set(gcf, 'renderer','painters')
      
      %       saveas(gcf,[savedirname 'Scatter_VIIRS_AQUA_' wl{idx0}],'epsc')
end


%% Checking low number of AQUA values
total_px_GOCI = GOCI_Data(1).pixel_count;
ratio_from_the_total = 3;

solz_lim = 75;
senz_lim = 60;
CV_lim = 0.25;

cond_solz = [AQUA_Data.solz_center_value] <= solz_lim;
cond_senz = [AQUA_Data.senz_center_value] <= senz_lim;
cond_CV = [AQUA_Data.median_CV]<=CV_lim;
cond_brdf = [AQUA_Data.brdf_opt] == brdf_opt;
cond_area = [AQUA_Data.Rrs_412_valid_pixel_count]>=(total_px_GOCI/4)/ratio_from_the_total;

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([AQUA_Data(cond_brdf).datetime],[AQUA_Data(cond_brdf).Rrs_412_filtered_mean],'o')
hold on
cond_used1 = cond_solz&cond_senz&cond_CV&cond_brdf;
plot([AQUA_Data(cond_used1).datetime],[AQUA_Data(cond_used1).Rrs_412_filtered_mean],'go')

cond_used2 = cond_area&cond_brdf;
plot([AQUA_Data(cond_used2).datetime],[AQUA_Data(cond_used2).Rrs_412_filtered_mean],'mo')

legend(['All data; N=' num2str(sum(cond_brdf))],...
      ['Geometry and Mean CV criteria; N=' num2str(sum(cond_used1))],...
      ['Region criteria; N=' num2str(sum(cond_used2))])

title(['AQUA; ' num2str(100/ratio_from_the_total) '% of the GCW'],...
      'FontSize',fs)
xlabel('Time')
ylabel('R_{rs}(412)')
%% pixels counts w/r to GOCI area for AQUA
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(3,2,1)
hist([AQUA_Data.Rrs_412_valid_pixel_count]./(total_px_GOCI/4),50)
title('AQUA Rrs 412 valid pixel count')
xlabel('% of GCW area')

subplot(3,2,2)
hist([AQUA_Data.pixel_count]./(total_px_GOCI/4),50)
title('AQUA pixel count')
xlabel('% of GCW area')

subplot(3,2,3)
hist([AQUA_Data.unflagged_pixel_count]./(total_px_GOCI/4),50)
title('AQUA unflagged pixel count')
xlabel('% of GCW area')

subplot(3,2,4)
hist([AQUA_Data.flagged_pixel_count]./(total_px_GOCI/4),50)
title('AQUA flagged pixel count')
xlabel('% of GCW area')

subplot(3,2,5)
hist([AQUA_Data.Rrs_412_filtered_valid_pixel_count]./(total_px_GOCI/4),50)
title('AQUA Rrs 412 filtered valid pixel count')
xlabel('% of GCW area')

subplot(3,2,6)
hist([AQUA_Data.Rrs_412_iqr_valid_pixel_count]./(total_px_GOCI/4),50)
title('AQUA Rrs 412 iqr valid pixel count')
xlabel('% of GCW area')

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%% pixels counts w/r to GOCI area for GOCI
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(3,2,1)
hist([GOCI_Data.Rrs_412_valid_pixel_count]./(total_px_GOCI),50)
title('GOCI Rrs 412 valid pixel count')
xlabel('% of GCW area')

subplot(3,2,2)
hist([GOCI_Data.pixel_count]./(total_px_GOCI),50)
title('GOCI pixel count')
xlabel('% of GCW area')

subplot(3,2,3)
hist([GOCI_Data.unflagged_pixel_count]./(total_px_GOCI),50)
title('GOCI unflagged pixel count')
xlabel('% of GCW area')

subplot(3,2,4)
hist([GOCI_Data.flagged_pixel_count]./(total_px_GOCI),50)
title('GOCI flagged pixel count')
xlabel('% of GCW area')

subplot(3,2,5)
hist([GOCI_Data.Rrs_412_filtered_valid_pixel_count]./(total_px_GOCI),50)
title('GOCI Rrs 412 filtered valid pixel count')
xlabel('% of GCW area')

subplot(3,2,6)
hist([GOCI_Data.Rrs_412_iqr_valid_pixel_count]./(total_px_GOCI),50)
title('GOCI Rrs 412 iqr valid pixel count')
xlabel('% of GCW area')

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%% pixels counts w/r to GOCI area for VIIRS
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(3,2,1)
hist([VIIRS_Data.Rrs_410_valid_pixel_count]./(total_px_GOCI/2.25),50)
title('VIIRS Rrs 412 valid pixel count')
xlabel('% of GCW area')

subplot(3,2,2)
hist([VIIRS_Data.pixel_count]./(total_px_GOCI/2.25),50)
title('VIIRS pixel count')
xlabel('% of GCW area')

subplot(3,2,3)
hist([VIIRS_Data.unflagged_pixel_count]./(total_px_GOCI/2.25),50)
title('VIIRS unflagged pixel count')
xlabel('% of GCW area')

subplot(3,2,4)
hist([VIIRS_Data.flagged_pixel_count]./(total_px_GOCI/2.25),50)
title('VIIRS flagged pixel count')
xlabel('% of GCW area')

subplot(3,2,5)
hist([VIIRS_Data.Rrs_410_filtered_valid_pixel_count]./(total_px_GOCI/2.25),50)
title('VIIRS Rrs 412 filtered valid pixel count')
xlabel('% of GCW area')

subplot(3,2,6)
hist([VIIRS_Data.Rrs_410_iqr_valid_pixel_count]./(total_px_GOCI/2.25),50)
title('VIIRS Rrs 412 iqr valid pixel count')
xlabel('% of GCW area')

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%%
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(2,2,1)
hist([GOCI_Data.median_CV],100)
title('GOCI')
xlabel('Median CV')
ylabel('Frequency')

subplot(2,2,2)
hist([AQUA_Data.median_CV],100)
title('AQUA')
xlabel('Median CV')
ylabel('Frequency')

subplot(2,2,3)
hist([VIIRS_Data.median_CV],100)
title('VIIRS')
xlabel('Median CV')
ylabel('Frequency')

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%% Load SeaWiFS data
clear SEAW_Data
tic
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/SEAWIFS_ROI_STAT_R2018/file_list_BRDF7.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'SEAW';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading SeaWiFS Data')
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/SEAWIFS_ROI_STAT_R2018/' s{1}{idx0}];
      SEAW_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc

save('ValCalGOCI.mat','SEAW_Data')
%% Daily statistics for SeaWiFS

count = 0;
process_data_flag = 1;
ratio_from_the_total = 3;

brdf_opt_vec = 7;
senz_lim = 60;
solz_lim = 75;
% CV_lim = nanmean([SEAW_Data.median_CV])+3*nanstd([SEAW_Data.median_CV]);
CV_lim = 0.25;

pixel_lim = (total_px_GOCI/4.84)/ratio_from_the_total;
% pixel_lim = 15*15;

if process_data_flag
      clear SEAW_DailyStatMatrix SEAW_Data_used
      clear cond_1t cond1 cond2 cond_used
      
      first_day = datetime(SEAW_Data(1).datetime.Year,SEAW_Data(1).datetime.Month,SEAW_Data(1).datetime.Day);
      last_day = datetime(SEAW_Data(end).datetime.Year,SEAW_Data(end).datetime.Month,SEAW_Data(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      count_per_proc = 0;
      h1 = waitbar(0,'Initializing ...');
      
      for idx_brdf = 1:size(brdf_opt_vec,2)
            
            cond_brdf = [SEAW_Data.brdf_opt] == brdf_opt_vec(idx_brdf);
            cond_senz = [SEAW_Data.senz_center_value]<=senz_lim; % criteria for the sensor zenith angle
            cond_solz = [SEAW_Data.solz_center_value]<=solz_lim;
            cond_CV = [SEAW_Data.median_CV]<=CV_lim;
            cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;
            
            SEAW_Data_used = SEAW_Data(cond_used);
            
            datetime_aux = [SEAW_Data.datetime];
            datetime_aux = datetime_aux(cond_used);
            
            [Year,Month,Day] = datevec(datetime_aux); % only days that satisfy the criteria above
            
            clear cond_used datetime_aux
            
            for idx=1:size(date_idx,2)
                  count_per_proc = count_per_proc +1;
                  per_proc = count_per_proc/(size(brdf_opt_vec,2)*size(date_idx,2));
                  str1 = sprintf('%3.2f',100*per_proc);
                  waitbar(per_proc,h1,['Processing SEAW Daily Data: ' str1 '%'])
                  
                  % identify all the images for a specific day
                  cond_1t = date_idx(idx).Year==Year...
                        & date_idx.Month(idx)==Month...
                        & date_idx.Day(idx)==Day;
                  
                  if sum(cond_1t) ~= 0 % only days that match the criteria above
                        
                        count = count+1;
                        
                        SEAW_DailyStatMatrix(count).datetime =  date_idx(idx);
                        SEAW_DailyStatMatrix(count).DOY = day(date_idx(idx),'dayofyear');
                        SEAW_DailyStatMatrix(count).images_per_day = nansum(cond_1t);
                        SEAW_DailyStatMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                        SEAW_DailyStatMatrix(count).idx_to_SEAW_Data = find(cond_1t);
                        
                        %% Rrs_412
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.Rrs_412_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0; % negative values should NOT be used
                        data_aux = [SEAW_Data_used.Rrs_412_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim; % less than half of the scene is valid, it should NOT be used
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values or scene with less than half of the area is invalid
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).Rrs_412_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.Rrs_412_filtered_mean];
                              SEAW_DailyStatMatrix(count).Rrs_412_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).Rrs_412_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_443
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.Rrs_443_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.Rrs_443_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).Rrs_443_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.Rrs_443_filtered_mean];
                              SEAW_DailyStatMatrix(count).Rrs_443_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).Rrs_443_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_490
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.Rrs_490_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.Rrs_490_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).Rrs_490_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.Rrs_490_filtered_mean];
                              SEAW_DailyStatMatrix(count).Rrs_490_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).Rrs_490_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_555
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.Rrs_555_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.Rrs_555_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).Rrs_555_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.Rrs_555_filtered_mean];
                              SEAW_DailyStatMatrix(count).Rrs_555_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).Rrs_555_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% Rrs_670
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.Rrs_670_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.Rrs_670_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).Rrs_670_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.Rrs_670_filtered_mean];
                              SEAW_DailyStatMatrix(count).Rrs_670_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).Rrs_670_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                       %% nLw_412
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.nLw_412_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0; % negative values should NOT be used
                        data_aux = [SEAW_Data_used.nLw_412_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim; % less than half of the scene is valid, it should NOT be used
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values or scene with less than half of the area is invalid
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).nLw_412_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.nLw_412_filtered_mean];
                              SEAW_DailyStatMatrix(count).nLw_412_filtered_mean = 0.1*data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).nLw_412_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% nLw_443
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.nLw_443_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.nLw_443_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).nLw_443_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.nLw_443_filtered_mean];
                              SEAW_DailyStatMatrix(count).nLw_443_filtered_mean = 0.1*data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).nLw_443_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% nLw_490
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.nLw_490_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.nLw_490_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).nLw_490_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.nLw_490_filtered_mean];
                              SEAW_DailyStatMatrix(count).nLw_490_filtered_mean = 0.1*data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).nLw_490_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% nLw_555
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.nLw_555_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.nLw_555_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).nLw_555_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.nLw_555_filtered_mean];
                              SEAW_DailyStatMatrix(count).nLw_555_filtered_mean = 0.1*data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).nLw_555_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% nLw_670
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.nLw_670_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.nLw_670_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).nLw_670_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.nLw_670_filtered_mean];
                              SEAW_DailyStatMatrix(count).nLw_670_filtered_mean = 0.1*data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).nLw_670_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        

                        %% aot_865
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.aot_865_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.aot_865_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).aot_865_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.aot_865_filtered_mean];
                              SEAW_DailyStatMatrix(count).aot_865_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).aot_865_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% angstrom
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.angstrom_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.angstrom_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).angstrom_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.angstrom_filtered_mean];
                              SEAW_DailyStatMatrix(count).angstrom_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).angstrom_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% poc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.poc_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.poc_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).poc_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.poc_filtered_mean];
                              SEAW_DailyStatMatrix(count).poc_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).poc_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% ag_412_mlrc
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.ag_412_mlrc_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.ag_412_mlrc_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).ag_412_mlrc_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.ag_412_mlrc_filtered_mean];
                              SEAW_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).ag_412_mlrc_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% chlor_a
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.chlor_a_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.chlor_a_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).chlor_a_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.chlor_a_filtered_mean];
                              SEAW_DailyStatMatrix(count).chlor_a_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).chlor_a_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                        %% brdf
                        % only positive values and if more of half of the area is valid
                        cond_1t_aux = cond_1t;
                        I = find(cond_1t_aux); % indexes to the images per day
                        data_aux = [SEAW_Data_used.brdf_filtered_mean];
                        cond_neg = data_aux(cond_1t_aux)<=0;
                        data_aux = [SEAW_Data_used.brdf_valid_pixel_count];
                        cond_area = data_aux(cond_1t_aux)<pixel_lim;
                        idx_aux = I(cond_area|cond_neg); % neg values
                        cond_1t_aux(idx_aux) = 0; % not to use neg values
                        cond_1t_aux = logical(cond_1t_aux);
                        clear idx_aux data_aux cond_area cond_neg
                        
                        % best geometry if there is more than one image
                        if sum(cond_1t_aux)>1
                              I = find(cond_1t_aux);
                              data_aux = [SEAW_Data_used.solz_center_value];
                              [~,Itemp] = min(data_aux(cond_1t_aux));
                              Imin = I(Itemp);
                              cond_1t_aux = 0.*cond_1t_aux;
                              cond_1t_aux(Imin) = 1;
                              cond_1t_aux = logical(cond_1t_aux);
                              clear Imin Itemp
                        end
                        
                        data_aux = [SEAW_Data_used.median_CV];
                        SEAW_DailyStatMatrix(count).brdf_median_CV = data_aux(cond_1t_aux);
                        
                        if sum(cond_1t_aux)~=0 % there is at least one image
                              data_aux = [SEAW_Data_used.brdf_filtered_mean];
                              SEAW_DailyStatMatrix(count).brdf_filtered_mean = data_aux(cond_1t_aux);
                        else
                              SEAW_DailyStatMatrix(count).brdf_filtered_mean = nan;
                        end
                        clear cond_1t_aux data_aux
                        
                  end
            end
      end
end
close(h1)

save('ValCalGOCI.mat','SEAW_Data','SEAW_DailyStatMatrix','-append')
%%
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([SEAW_Data.datetime],0.1*[SEAW_Data.nLw_412_filtered_mean],'o')
hold on
plot([SEAW_DailyStatMatrix.datetime],[SEAW_DailyStatMatrix.nLw_412_filtered_mean],'og')
title('SeaWiFS')
xlabel('Time')
ylabel('L_{wn}(412)')

legend(['All Data; N=' num2str(sum(~isnan([SEAW_Data.nLw_412_filtered_mean])))],...
      ['Daily filtered; N=' num2str(sum(~isnan([SEAW_DailyStatMatrix.nLw_412_filtered_mean])))])

%% pixels counts w/r to GOCI area for SeaWiFS
fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
subplot(3,2,1)
hist([SEAW_Data.Rrs_412_valid_pixel_count]./(total_px_GOCI/4.84),50) %(1.1*1.1)/(0.5*0.5)
title('SeaWiFS Rrs 412 valid pixel count')
xlabel('% of GCW area')
ylabel('Frequency')

subplot(3,2,2)
hist([SEAW_Data.pixel_count]./(total_px_GOCI/4.84),50)
title('SeaWiFS pixel count')
xlabel('% of GCW area')
ylabel('Frequency')

subplot(3,2,3)
hist([SEAW_Data.unflagged_pixel_count]./(total_px_GOCI/4.84),50)
title('SeaWiFS unflagged pixel count')
xlabel('% of GCW area')
ylabel('Frequency')

subplot(3,2,4)
hist([SEAW_Data.flagged_pixel_count]./(total_px_GOCI/4.84),50)
title('SeaWiFS flagged pixel count')
xlabel('% of GCW area')
ylabel('Frequency')

subplot(3,2,5)
hist([SEAW_Data.Rrs_412_filtered_valid_pixel_count]./(total_px_GOCI/4.84),50)
title('SeaWiFS Rrs 412 filtered valid pixel count')
xlabel('% of GCW area')
ylabel('Frequency')

subplot(3,2,6)
hist([SEAW_Data.Rrs_412_iqr_valid_pixel_count]./(total_px_GOCI/4.84),50)
title('SeaWiFS Rrs 412 iqr valid pixel count')
xlabel('% of GCW area')
ylabel('Frequency')
%% SEAW_climatology data
tic

clear SEAW_Climatology SEAW_ClimatologyBinned

par_vec = {'nLw_412','nLw_443','nLw_490','nLw_555','nLw_670'};

h1 = waitbar(0,'Initializing ...');

count = 0;

count_per_proc = 0;

brdf_opt_vec = 7;

for idx_brdf=1:size(brdf_opt_vec,2)
      for idx_DOY = 1:366
            
            count = count + 1;
            
            for idx_par = 1:size(par_vec,2)
                  count_per_proc = count_per_proc+1;
                  per_proc = count_per_proc/(size(par_vec,2)*size(brdf_opt_vec,2)*366);
                  str1 = sprintf('%3.2f',100*per_proc);
                  waitbar(per_proc,h1,['Processing Climatology Data for SeaWiFS: ' str1 '%'])
                  
                  cond_time_aux = [SEAW_DailyStatMatrix.DOY]==idx_DOY;
                  cond_brdf_aux = [SEAW_DailyStatMatrix.brdf_opt]==brdf_opt_vec(idx_brdf);
                  
                  SEAW_ClimatologyMatrix(count).brdf_opt = brdf_opt_vec(idx_brdf);
                  
                  eval(sprintf('cond_nan_aux = ~isnan([SEAW_DailyStatMatrix.%s_filtered_mean]);',par_vec{idx_par}));
                  
                  cond_used_aux = cond_time_aux&cond_nan_aux&cond_brdf_aux;
                  
                  eval(sprintf('data_aux = [SEAW_DailyStatMatrix.%s_filtered_mean];',par_vec{idx_par}));
                  data_aux = data_aux(cond_used_aux);
                  mean_DOY = nanmean(data_aux);
                  
                  eval(sprintf('SEAW_ClimatologyMatrix(count).%s_mean_DOY = mean_DOY;',par_vec{idx_par}));
                  eval(sprintf('SEAW_ClimatologyMatrix(count).%s_data = data_aux;',par_vec{idx_par}));
                  eval(sprintf('SEAW_ClimatologyMatrix(count).%s_DOY = idx_DOY;',par_vec{idx_par}));
            end
      end
end
clear idx_par idx_brdf idx_month idx_day per_proc str1 count_per_proc
clear cond_used_aux cond_time_aux cond_brdf_aux cond_area_aux cond_nan_aux data_aux mean_month_day
close(h1)




for idx = 1:size(SEAW_ClimatologyMatrix,2)
      for idx_bin = 1:26; % ~26 weeks per year
            for idx_par = 1:size(par_vec,2)
                  eval(sprintf('cond_bin = [SEAW_ClimatologyMatrix.%s_DOY] > (idx_bin-1)*14+1 & [SEAW_ClimatologyMatrix.%s_DOY] < idx_bin*14;',par_vec{idx_par},par_vec{idx_par}));
                  eval(sprintf('data_aux = [SEAW_ClimatologyMatrix(cond_bin).%s_data];',par_vec{idx_par}));
                  eval(sprintf('SEAW_ClimatologyBinned(idx_bin).%s_data = data_aux;',par_vec{idx_par}));
                  
                  % semi-interquartile range
                  Q1 = quantile(data_aux,0.25);
                  Q3 = quantile(data_aux,0.75);
                  cond_siqr = data_aux >= Q1& data_aux <= Q3;
                  data_aux_siqr = data_aux(cond_siqr);
                  
                  % siqr mean
                  data_aux_siqr_mean = nanmean(data_aux_siqr);
                  eval(sprintf('SEAW_ClimatologyBinned(idx_bin).%s_siqr_mean = data_aux_siqr_mean;',par_vec{idx_par}));
                  eval(sprintf('SEAW_ClimatologyBinned(idx_bin).%s_bin_begin = (idx_bin-1)*14+1;',par_vec{idx_par}));
                  eval(sprintf('SEAW_ClimatologyBinned(idx_bin).%s_bin_end = idx_bin*14;',par_vec{idx_par}));
            end
      end
end

dlg = msgbox('Save operation in progress...');

save('ValCalGOCI.mat','SEAW_ClimatologyMatrix','SEAW_ClimatologyBinned','-append')

if ishghandle(dlg)
      delete(dlg);
end

toc
%% display for nLw

for idx_par = 1:size(par_vec,2)
      clear cond_brdf cond_nan cond_used
      switch par_vec{idx_par}
            case 'nLw_412'
                  y_str = 'L_{wn}(412)';
            case 'nLw_443'
                  y_str = 'L_{wn}(443)';
            case 'nLw_490'
                  y_str = 'L_{wn}(490)';
            case 'nLw_555'
                  y_str = 'L_{wn}(555)';
            case 'nLw_670'
                  y_str = 'L_{wn}(670)';
      end
      
      lw = 1.5;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      
      cond_brdf = [SEAW_DailyStatMatrix.brdf_opt] == 7;
      eval(sprintf('plot([SEAW_DailyStatMatrix(cond_brdf ).DOY],[SEAW_DailyStatMatrix(cond_brdf).%s_filtered_mean],''o'')',par_vec{idx_par}));
      hold on
      
      cond_brdf = [SEAW_ClimatologyMatrix.brdf_opt] == 7;
      eval(sprintf('cond_nan = ~isnan([SEAW_ClimatologyMatrix.%s_mean_DOY]);',par_vec{idx_par}));
      cond_used = cond_brdf&cond_nan;
      eval(sprintf('plot([SEAW_ClimatologyMatrix(cond_used).%s_DOY],[SEAW_ClimatologyMatrix(cond_used).%s_mean_DOY])',par_vec{idx_par},par_vec{idx_par}));
      
      hold on
      eval(sprintf('plot([SEAW_ClimatologyBinned.%s_bin_begin]+7,[SEAW_ClimatologyBinned.%s_siqr_mean],''g-o'',''LineWidth'',lw)',par_vec{idx_par},par_vec{idx_par}));
      
      
      eval(sprintf('ClimaBinned = [SEAW_ClimatologyBinned.%s_siqr_mean];',par_vec{idx_par}));
      
      % three-element central moving-average
      movingAverage = conv(ClimaBinned, ones(3,1)/3, 'same');
      hold on
      eval(sprintf('plot([SEAW_ClimatologyBinned.%s_bin_begin]+7,movingAverage,''m-o'',''LineWidth'',lw)',par_vec{idx_par}));
      
      legend('All Data','Mean DOY','Mean siqr 14-day bins','3-element central amoving-average')
      
      xlabel('DOY','FontSize',fs)
      
      ylabel(y_str,'FontSize',fs)
      
      screen_size = get(0, 'ScreenSize');
      origSize = get(gcf, 'Position'); % grab original on screen size
      set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
      
end
%% smoothed fit
clear SEAW_Clima_Final

year_total = 14;
fourteen_day_periods = 26;

lw = 1.5;
h2 = figure('Color','white','DefaultAxesFontSize',fs);

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size

for idx_par = 1:size(par_vec,2)
      clear cond_brdf cond_nan cond_used
      switch par_vec{idx_par}
            case 'nLw_412'
                  y_str = 'L_{wn}(412)';
            case 'nLw_443'
                  y_str = 'L_{wn}(443)';
            case 'nLw_490'
                  y_str = 'L_{wn}(490)';
            case 'nLw_555'
                  y_str = 'L_{wn}(555)';
            case 'nLw_670'
                  y_str = 'L_{wn}(670)';
      end
      eval(sprintf('ClimaBinned = [SEAW_ClimatologyBinned.%s_siqr_mean];',par_vec{idx_par}));
      fit_smooth_clima = conv(repmat(ClimaBinned,1,year_total),ones(3,1)/3, 'same'); % 12 years
      
      startDate = datenum('01-07-1997');
      
      lw = 1.5;
      h = figure('Color','white','DefaultAxesFontSize',fs);
      eval(sprintf('plot([SEAW_DailyStatMatrix.datetime],[SEAW_DailyStatMatrix.%s_filtered_mean],''o'')',par_vec{idx_par}));
      hold on
      
      % 14-day bins
      date_vec = startDate:14:startDate+14*(fourteen_day_periods*year_total)-1;
      
      plot(date_vec,fit_smooth_clima,'go','LineWidth',lw)
      datetick('x','yyyy','keeplimits')
      
      legend('Filtered Data','3-element central amoving-average')
      
      xlabel('Time','FontSize',fs)
      ylabel(y_str,'FontSize',fs)
      
      hold on
      
      date_vec_spline = date_vec(1):1:date_vec(end);
      cubic_spline_clima = spline(date_vec,fit_smooth_clima,date_vec_spline);
      plot(date_vec_spline,cubic_spline_clima,'m.','MarkerSize',12)
      
      legend('Filtered Data','3-element central amoving-average','Cubic Spline interp.')
      
      title('SeaWiFS Climatology')
      
      screen_size = get(0, 'ScreenSize');
      origSize = get(gcf, 'Position'); % grab original on screen size
      set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
      
      
      %%
      
      clima_date_vec = datenum('01-01-2000'):datenum('12-31-2000'); % leap year day
      
      for idx = 1:size(clima_date_vec,2)
            SEAW_Clima_Final(idx).datetime = datetime(clima_date_vec(idx),'ConvertFrom','datenum')+hours(3)+minutes(30);
            SEAW_Clima_Final(idx).DOY = day(datetime(clima_date_vec(idx),'ConvertFrom','datenum'),'dayofyear');
            
            cond = date_vec_spline == clima_date_vec(idx);
            eval(sprintf('SEAW_Clima_Final(idx).%s = cubic_spline_clima(cond);',par_vec{idx_par}));
      end
      
      figure(h2)
      hold on
      eval(sprintf('plot([SEAW_Clima_Final.datetime],[SEAW_Clima_Final.%s],''LineWidth'',1.5);',par_vec{idx_par}));
      datetick('x','mmm-yyyy')
end

figure(h2)
legend('L_{wn}(412)','L_{wn}(443)','L_{wn}(490)','L_{wn}(555)','L_{wn}(670)')
ylabel('L_{wn}(\lambda)')
xlabel('Time')

save('ValCalGOCI.mat','SEAW_Clima_Final','-append')


%% Load GOCI vcal using SeaWiFS data
clear Gvcal_SW_Data
tic
% fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/MA_SW_ROI_STAT/file_list_SW.txt');
% fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/MA_SW_ROI_STAT/file_list_SW.txt');
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_ROI_STATS_R2018_vcal_vis_seaw/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'GOCI_vcal';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading GOCI Vcal Data using SeaWiFS...')
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_ROI_STATS_R2018_vcal_vis_seaw/' s{1}{idx0}];
      Gvcal_SW_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc

save('ValCalGOCI.mat','Gvcal_SW_Data','-append')

%% Vcal using SeaWiFS climatology

savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';

% latex table
!rm ./Gvcal_SW_Table.tex
FID = fopen('./Gvcal_SW_Table.tex','w');

% fprintf(FID,'\\begin{tabular}{ccccccccccccc} \n \\hline \n');

% fprintf(FID, 'Sat (nm) ');
% fprintf(FID, '& InSitu (nm) ');
% fprintf(FID, '& $R^2$ ');
% fprintf(FID, '& Regression ');
% fprintf(FID, '& RMSE ');
% fprintf(FID, '& N ');
% fprintf(FID, '& Mean APD ($\\%%$) ');
% fprintf(FID, '& St.Dev. APD ($\\%%$) ');
% fprintf(FID, '& Median APD ($\\%%$) ');
% fprintf(FID, '& Bias ($\\%%$) ');
% fprintf(FID, '& Median ratio ');
% fprintf(FID, '& SIQR ');
% fprintf(FID, '& rsqcorr ');
% fprintf(FID,'\\\\ \\hline \n');

%

total_px_GOCI = Gvcal_SW_Data(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels
pixel_lim = total_px_GOCI/ratio_from_the_total;
% pixel_lim = 15*15;

CV_lim = 0.25;
solz_lim = 75;
senz_lim = 60;

wl = {'412','443','490','555','660','680'};

for idx0 = 1:size(wl,2)
      %%
      eval(sprintf('cond_area = [Gvcal_SW_Data.vgain_%s_filtered_valid_pixel_count] >= pixel_lim;',wl{idx0}));
      cond_senz = [Gvcal_SW_Data.senz_center_value] <= senz_lim;
      cond_solz = [Gvcal_SW_Data.solz_center_value] <= solz_lim;
      cond_used = cond_area&cond_senz&cond_solz;
      
      
      Gvcal_SW_Data_used = Gvcal_SW_Data(cond_used);
      
      first_day = datetime(2011,5,20);
      last_day = datetime(Gvcal_SW_Data_used(end).datetime.Year,Gvcal_SW_Data_used(end).datetime.Month,Gvcal_SW_Data_used(end).datetime.Day);
      
      date_idx = first_day:last_day;
      
      datetime_used = [Gvcal_SW_Data_used.datetime];
      
      [Year,Month,Day] = datevec(datetime_used);
      
      
      count = 0;
      for idx = 1:size(date_idx,2)
            cond_aux = date_idx(idx).Year==Year...
                  & date_idx.Month(idx)==Month...
                  & date_idx.Day(idx)==Day;
            if sum(cond_aux)~=0
                  Gvcal_SW_Data_aux = Gvcal_SW_Data_used(cond_aux);
                  datetim_aux = datetime_used(cond_aux);
                  [~,I] = min(abs(timeofday(datetim_aux)-(hours(3)+minutes(30))));
                  count = count+1;
                  Gvcal_SW_Data_filtered(count) = Gvcal_SW_Data_aux(I);
            end
      end
      clear count idx cond_aux Gvcal_SW_Data_aux datetim_aux I
      
      eval(sprintf('g = [Gvcal_SW_Data_filtered.vgain_%s_filtered_mean];',wl{idx0}));
      datetime_vec = [Gvcal_SW_Data_filtered.datetime];
      
      % plot
      fs = 30;
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',wl{idx0});
      
      [g_siqr_mean,g_siqr_std,N_siqr] = plot_gains(datetime_vec,g,wl{idx0},FID)
%       type Gvcal_SW_Table.tex
      
      set(gcf,'PaperPositionMode','auto') %set paper pos for printing
      saveas(gcf,[savedirname 'Gvcal_SW_' wl{idx0}],'epsc')
      
      clear Gvcal_SW_Data_filtered screen_size origSize cond_used cond_area cond_senz cond_solz Gvcal_SW_Data_used
      clear Year Month Day Q1 Q2 cond_siqr g_siqr datetime_siqr
      clear first_day last_day date_idx datetime_used
end

%% Load GOCI vcal using MODISA data
clear Gvcal_MA_Data
tic
% fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/MA_SW_ROI_STAT/file_list_MA.txt'); % before R2018.0
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_ROI_STATS_R2018_vcal_vis_aqua/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'GOCI_vcal';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading GOCI Vcal Data using MODISA...')
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_ROI_STATS_R2018_vcal_vis_aqua/' s{1}{idx0}];
      Gvcal_MA_Data(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc

save('ValCalGOCI.mat','Gvcal_MA_Data','-append')
%% Vcal using MODIS
total_px_GOCI = Gvcal_MA_Data(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels

pixel_lim = total_px_GOCI/ratio_from_the_total;
% pixel_lim = 15*15;

load('ValCalGOCI.mat','GOCI_MODIS_GCW_matchups'); % from vcal_find.m

CV_lim = 0.25;
solz_lim = 75;
senz_lim = 60;

wl = {'412','443','490','555','660','680'};

for idx0 = 1:size(wl,2)
      %%
      eval(sprintf('cond_area = [Gvcal_MA_Data.vgain_%s_filtered_valid_pixel_count] >= pixel_lim;',wl{idx0}));
      cond_senz = [Gvcal_MA_Data.senz_center_value] <= senz_lim;
      cond_solz = [Gvcal_MA_Data.solz_center_value] <= solz_lim;
      cond_used = cond_area&cond_senz&cond_solz;
      
      % GOCI vcal file filtered
      Gvcal_MA_Data_used = Gvcal_MA_Data(cond_used);
      first_day = datetime(2011,5,20);
      last_day = datetime(Gvcal_MA_Data_used(end).datetime.Year,Gvcal_MA_Data_used(end).datetime.Month,Gvcal_MA_Data_used(end).datetime.Day);
      date_idx = first_day:last_day;
      datetime_used = [Gvcal_MA_Data_used.datetime];
      [Year,Month,Day] = datevec(datetime_used);
      
      % MODIS matchups
      [YearMA,MonthMA,DayMA] = datevec([GOCI_MODIS_GCW_matchups.AQUA_datetime]);
      
      count = 0;
      for idx = 1:size(date_idx,2)
            cond_aux = date_idx(idx).Year==Year...
                  & date_idx.Month(idx)==Month...
                  & date_idx.Day(idx)==Day;
            
            if sum(cond_aux)~=0
                  % MODISA matchups
                  cond_auxMA = date_idx(idx).Year==YearMA...
                        & date_idx.Month(idx)==MonthMA...
                        & date_idx.Day(idx)==DayMA;
                  if sum(cond_auxMA)~=0
                        datetime_aux = [GOCI_MODIS_GCW_matchups(cond_auxMA).AQUA_datetime];
                        
                        Gvcal_MA_Data_aux = Gvcal_MA_Data_used(cond_aux);
                        datetim_aux = datetime_used(cond_aux);
                        [~,I] = min(abs(timeofday(datetim_aux)-timeofday(datetime_aux(1))));
                        count = count+1;
                        Gvcal_MA_Data_filtered(count) = Gvcal_MA_Data_aux(I);
                        
                        clear datetime_aux cond_auxMA I cond_aux Gvcal_MA_Data_aux
                  end
            end
      end
      clear count idx
      
      eval(sprintf('g = [Gvcal_MA_Data_filtered.vgain_%s_filtered_mean];',wl{idx0}));
      datetime_vec = [Gvcal_MA_Data_filtered.datetime];
      
      % plot
      fs = 30;
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',wl{idx0});
      
      [g_siqr_mean,g_siqr_std,N_siqr] = plot_gains(datetime_vec,g,wl{idx0})
      
      set(gcf,'PaperPositionMode','auto') %set paper pos for printing
      saveas(gcf,[savedirname 'Gvcal_MA_' wl{idx0}],'epsc')
      
      clear Gvcal_MA_Data_filtered screen_size origSize cond_used cond_area cond_senz cond_solz Gvcal_MA_Data_used
      clear Year Month Day YearMA MonthMA DayMA Q1 Q2 cond_siqr g_siqr datetime_siqr cond_auxMA
      clear first_day last_day date_idx datetime_used
end
%% Re-derivation gain GOCI 745 nm band
% angstrom AQUA
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','MODISA Angstrom');

subplot(2,1,1)
% plot([AQUA_Data.datetime],[AQUA_Data.angstrom_filtered_mean],'o')
% hold on
plot([AQUA_DailyStatMatrix.datetime],[AQUA_DailyStatMatrix.angstrom_filtered_mean],'ok')
title('MODIS-Aqua')
xlabel('Time')
ylabel('Angstrom')

subplot(2,1,2)
hist([AQUA_DailyStatMatrix.angstrom_filtered_mean])
xlabel('Angstrom')
ylabel('Frequency')

data_used = [AQUA_DailyStatMatrix.angstrom_filtered_mean];
str1 = sprintf('N: %i\nmean: %2.2f \nmax: %2.2f \nmin: %2.2f \nSD: %2.2f ',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.75*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.6*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%% Angstrom filtered valid pixel count
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','MODISA Angstrom');

subplot(2,1,1)
% plot([AQUA_Data.datetime],[AQUA_Data.angstrom_filtered_mean],'o')
% hold on
plot([AQUA_DailyStatMatrix.datetime],[AQUA_DailyStatMatrix.angstrom_filtered_valid_pixel_count],'o')
title('MODIS-Aqua')
xlabel('Time')
ylabel('Angstrom px count')

subplot(2,1,2)
hist([AQUA_DailyStatMatrix.angstrom_filtered_valid_pixel_count],100)
xlabel('Angstrom px count')
ylabel('Frequency')

data_used = [AQUA_DailyStatMatrix.angstrom_filtered_valid_pixel_count];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.75*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.6*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size

%% angstrom VIIRS
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','VIIRS Angstrom');

subplot(2,1,1)
% plot([VIIRS_Data.datetime],[VIIRS_Data.angstrom_filtered_mean],'o')
% hold on
plot([VIIRS_DailyStatMatrix.datetime],[VIIRS_DailyStatMatrix.angstrom_filtered_mean],'o')
title('VIIRS')
xlabel('Time')
ylabel('Angstrom')

subplot(2,1,2)
hist([VIIRS_DailyStatMatrix.angstrom_filtered_mean])
xlabel('Angstrom')
ylabel('Frequency')

data_used = [VIIRS_DailyStatMatrix.angstrom_filtered_mean];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.75*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.6*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%% Angstrom filtered valid pixel count
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','MODISA Angstrom');

subplot(2,1,1)
% plot([VIIRS_Data.datetime],[VIIRS_Data.angstrom_filtered_mean],'o')
% hold on
plot([VIIRS_DailyStatMatrix.datetime],[VIIRS_DailyStatMatrix.angstrom_filtered_valid_pixel_count],'o')
title('VIIRS')
xlabel('Time')
ylabel('Angstrom px count')

subplot(2,1,2)
hist([VIIRS_DailyStatMatrix.angstrom_filtered_valid_pixel_count],100)
xlabel('Angstrom px count')
ylabel('Frequency')

data_used = [VIIRS_DailyStatMatrix.angstrom_filtered_valid_pixel_count];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.75*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.6*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%% angstrom SEAW
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','SeaWiFS Angstrom');
subplot(2,1,1)
% plot([SEAW_Data.datetime],[SEAW_Data.angstrom_filtered_mean],'o')
% hold on
plot([SEAW_DailyStatMatrix.datetime],[SEAW_DailyStatMatrix.angstrom_filtered_mean],'o')
title('SeaWiFS')
xlabel('Time')
ylabel('Angstrom')

subplot(2,1,2)
hist([SEAW_DailyStatMatrix.angstrom_filtered_mean])
xlabel('Angstrom')
ylabel('Frequency')

data_used = [SEAW_DailyStatMatrix.angstrom_filtered_mean];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.73*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.65*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size

%%
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','GOCI 3h Angstrom');
subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.angstrom_03],'o')
title('GOCI 3h')
xlabel('Time')
ylabel('Angstrom')

subplot(2,1,2)
hist([GOCI_DailyStatMatrix.angstrom_03])
xlabel('Angstrom')
ylabel('Frequency')

data_used = [GOCI_DailyStatMatrix.angstrom_03];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.73*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.65*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size
%%
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','MODISA AOT(869)');

subplot(2,1,1)
% plot([AQUA_Data.datetime],[AQUA_Data.angstrom_filtered_mean],'o')
% hold on
plot([AQUA_DailyStatMatrix.datetime],[AQUA_DailyStatMatrix.aot_869_filtered_mean],'o')
title('MODIS-Aqua')
xlabel('Time')
ylabel('AOT(869)')

subplot(2,1,2)
hist([AQUA_DailyStatMatrix.aot_869_filtered_mean])
xlabel('AOT(869)')
ylabel('Frequency')

data_used = [AQUA_DailyStatMatrix.aot_869_filtered_mean];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.85*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.61*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size

%%
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','SeaWiFS AOT(865)');

subplot(2,1,1)
plot([SEAW_DailyStatMatrix.datetime],[SEAW_DailyStatMatrix.aot_865_filtered_mean],'o')
title('SeaWiFS')
xlabel('Time')
ylabel('AOT(865)')

subplot(2,1,2)
hist([SEAW_DailyStatMatrix.aot_865_filtered_mean])
xlabel('AOT(865)')
ylabel('Frequency')

data_used = [SEAW_DailyStatMatrix.aot_865_filtered_mean];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.75*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.5*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size

%%
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','GOCI AOT(865)');

subplot(2,1,1)
plot([GOCI_DailyStatMatrix.datetime],[GOCI_DailyStatMatrix.aot_865_03],'o')
title('GOCI 3h')
xlabel('Time')
ylabel('AOT(865)')

subplot(2,1,2)
hist([GOCI_DailyStatMatrix.aot_865_03])
xlabel('AOT(865)')
ylabel('Frequency')

data_used = [GOCI_DailyStatMatrix.aot_865_03];
str1 = sprintf('N: %i\nmean: %2.2f [sr^{-1}]\nmax: %2.2f [sr^{-1}]\nmin: %2.2f [sr^{-1}]\nsd: %2.2f [sr^{-1}]',...
      sum(~isnan(data_used)),nanmean(data_used),nanmax(data_used),nanmin(data_used),nanstd(data_used));


xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
xLoc = xLimits(1)+0.55*(xLimits(2)-xLimits(1));
yLoc = yLimits(1)+0.5*(yLimits(2)-yLimits(1));
figure(h)
hold on
text(xLoc,yLoc,str1,'FontSize',fs-3,'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)] ); %set to screen size

%% 745 band gain: loading data
clear Gvcal_745
tic
fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_VCAL_745_aqua/file_list_r95f10v01.txt'); % r50f20v01 r95f10v01
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

h1 = waitbar(0,'Initializing ...');

sensor_id = 'GOCI_vcal';
for idx0=1:size(s{1},1)
      waitbar(idx0/size(s{1},1),h1,'Uploading GOCI Vcal Data for 745 gain calculation...')
      
      filepath = ['/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_VCAL_745_aqua/' s{1}{idx0}];
      Gvcal_745(idx0) = loadsatcell_tempanly(filepath,sensor_id);
      
end
close(h1)
toc

save('ValCalGOCI.mat','Gvcal_745','-append')

%% 745 band gain: loading data

savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/';

% latex table
!rm ./Gvcal_745_Table.tex
FID = fopen('./Gvcal_745_Table.tex','w');

% fprintf(FID,'\\begin{tabular}{ccccccccccccc} \n \\hline \n');

% fprintf(FID, 'Sat (nm) ');
% fprintf(FID, '& InSitu (nm) ');
% fprintf(FID, '& $R^2$ ');
% fprintf(FID, '& Regression ');
% fprintf(FID, '& RMSE ');
% fprintf(FID, '& N ');
% fprintf(FID, '& Mean APD ($\\%%$) ');
% fprintf(FID, '& St.Dev. APD ($\\%%$) ');
% fprintf(FID, '& Median APD ($\\%%$) ');
% fprintf(FID, '& Bias ($\\%%$) ');
% fprintf(FID, '& Median ratio ');
% fprintf(FID, '& SIQR ');
% fprintf(FID, '& rsqcorr ');
% fprintf(FID,'\\\\ \\hline \n');

%

total_px_GOCI = Gvcal_745(1).pixel_count; % FOR THIS ROI!!! ((499*2+1)*(999*2+1))
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels

pixel_lim=total_px_GOCI/ratio_from_the_total;
% pixel_lim=15*15;

solz_lim = 75;
senz_lim = 60;
CV_lim = 0.15;

wl = {'745'};

for idx0 = 1:size(wl,2)
      %%
      eval(sprintf('cond_area = [Gvcal_745.vgain_%s_filtered_valid_pixel_count] >= pixel_lim;',wl{idx0}));
      cond_senz = [Gvcal_745.senz_center_value] <= senz_lim;
      cond_solz = [Gvcal_745.solz_center_value] <= solz_lim;
      cond_CV = [Gvcal_745.vgain_745_filtered_stddev]./[Gvcal_745.vgain_745_filtered_mean]<=CV_lim;
      cond_used = cond_area&cond_senz&cond_solz&cond_CV;
      
      
      Gvcal_745_used = Gvcal_745(cond_used);
      
      first_day = datetime(2011,5,20);
      last_day = datetime(Gvcal_745_used(end).datetime.Year,Gvcal_745_used(end).datetime.Month,Gvcal_745_used(end).datetime.Day);
     
      date_idx = first_day:last_day;
      
      datetime_used = [Gvcal_745_used.datetime];
      
      [Year,Month,Day] = datevec(datetime_used);
      
      
      count = 0;
      for idx = 1:size(date_idx,2)
            cond_aux = date_idx(idx).Year==Year...
                  & date_idx.Month(idx)==Month...
                  & date_idx.Day(idx)==Day;
            if sum(cond_aux)~=0
                  Gvcal_745_aux = Gvcal_745_used(cond_aux);
                  datetim_aux = datetime_used(cond_aux);
                  [~,I] = min(abs(timeofday(datetim_aux)-(hours(3)+minutes(30)))); % 
                  count = count+1;
                  Gvcal_745_filtered(count) = Gvcal_745_aux(I);
            end
      end
      clear count idx cond_aux Gvcal_745_aux datetim_aux I
      
      eval(sprintf('g = [Gvcal_745_filtered.vgain_%s_filtered_mean];',wl{idx0}));
      datetime_vec = [Gvcal_745_filtered.datetime];
      
      % plot
      fs = 30;
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',wl{idx0});
      
      [g_siqr_mean,g_siqr_std,N_siqr] = plot_gains(datetime_vec,g,wl{idx0},FID);
      type Gvcal_SW_Table.tex
      
      set(gcf,'PaperPositionMode','auto') %set paper pos for printing
      saveas(gcf,[savedirname 'Gvcal_745_' wl{idx0}],'epsc')
      
      clear Gvcal_745_filtered screen_size origSize cond_used cond_area cond_senz cond_solz Gvcal_745_used
      clear Year Month Day Q1 Q2 cond_siqr g_siqr datetime_siqr
      clear first_day last_day date_idx datetime_used
end
%%
% Javier,
%
%
%
% Enclosed is the paper by Werdell et al. on accomplishing a vicarious
% calibration for OCTS and CZCS using SeaWiFS.  Bryan suggested you can
% follow this approach for the GOCI Clear Water region.
%
%
%
% There two possible approaches that you should consider and evaluate:
%
% 1.        Generate an annual daily climatology of the GOCI clear water
% region from SeaWiFS observations from 1998 to 2009 (11 complete years)
% and apply this to compute GOCI vicarious gains as Jeremy did for OCTS and
% CZCS.  You would match the GOCI time point closest in time with SeaWiFS
% (noonish).  You can then use MODIS, VIIRS and AERONET-OC as independent
% comparisons (validation) of the GOCI Rrs from 2011 to 2017.
%
% 2.       Apply MODIS-Aqua to accomplish vicarious calibration of GOCI
% from 2011 through 2015 (or until you have sufficient data points for
% stable vicarious gains; Bryan does this sound reasonable?) to avoid the
% recent couple of years where MODIS-A data is more suspect.  This approach
% would be more similar to using MOBY as described in Franz et al. 2007.
% Here you would apply daily mean MODIS Rrs for the GCW that pass through
% your exclusion criteria rather than MOBY to accomplish the vicarious
% calibration of GOCI. You can then use VIIRS and AERONET-OC as independent
% comparisons (validation) of the GOCI Rrs.  You can still show the GOCI
% comparisons with MODIS-A and VIIRS, just have to indicate that the
% comparison with MODIS-A is not independent.  Since you already have MODIS
% data processed, this will be quicker, but I think it?s worth looking at
% using SeaWiFS too.
%
%
% Antonio



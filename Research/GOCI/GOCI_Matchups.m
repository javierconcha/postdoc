total_px_GOCI = 968*433; % new GCWS
ratio_from_the_total = 3; % 2 3 4 % half or third or fourth of the total of pixels

CV_lim = 0.25;
solz_lim = 75;
senz_lim = 60;

cond_brdf = [GOCI_Data.brdf_opt]==7;
cond_senz = [GOCI_Data.senz_center_value]<=senz_lim; % criteria for the sensor zenith angle
cond_solz = [GOCI_Data.solz_center_value]<=solz_lim;
cond_CV   = [GOCI_Data.median_CV]<=CV_lim;
cond_used = cond_brdf&cond_senz&cond_solz&cond_CV;

GOCI_Data_used = GOCI_Data(cond_used);

%% GOCI-MODISA matchups
clear GOCI_MODIS_matchups I

count = 0;

for idx0=1:size(AQUA_DailyStatMatrix,2);
      [t_diff,I]=min(abs(AQUA_DailyStatMatrix(idx0).datetime-[GOCI_Data_used.datetime]));
      if hours(t_diff)<0.5
            count = count+1;
            GOCI_MODIS_matchups(count).GOCI_ifile = char(GOCI_Data_used(I).ifile);
            GOCI_MODIS_matchups(count).GOCI_datetime = char(GOCI_Data_used(I).datetime);
            GOCI_MODIS_matchups(count).AQUA_ifile = AQUA_DailyStatMatrix(idx0).ifile;
            GOCI_MODIS_matchups(count).AQUA_datetime = AQUA_DailyStatMatrix(idx0).datetime;
            
            if GOCI_Data_used(I).Rrs_412_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_MODIS_matchups(count).Rrs_412_GOCI = GOCI_Data_used(I).Rrs_412_filtered_mean;
            else 
                  GOCI_MODIS_matchups(count).Rrs_412_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_443_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_MODIS_matchups(count).Rrs_443_GOCI = GOCI_Data_used(I).Rrs_443_filtered_mean;
            else
                  GOCI_MODIS_matchups(count).Rrs_443_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_490_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_MODIS_matchups(count).Rrs_490_GOCI = GOCI_Data_used(I).Rrs_490_filtered_mean;
            else
                  GOCI_MODIS_matchups(count).Rrs_490_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_555_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_MODIS_matchups(count).Rrs_555_GOCI = GOCI_Data_used(I).Rrs_555_filtered_mean;
            else
                  GOCI_MODIS_matchups(count).Rrs_555_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_660_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_MODIS_matchups(count).Rrs_660_GOCI = GOCI_Data_used(I).Rrs_660_filtered_mean;
            else
                  GOCI_MODIS_matchups(count).Rrs_660_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_680_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_MODIS_matchups(count).Rrs_680_GOCI = GOCI_Data_used(I).Rrs_680_filtered_mean;
            else
                  GOCI_MODIS_matchups(count).Rrs_680_GOCI = NaN;
            end


            
            GOCI_MODIS_matchups(count).Rrs_412_AQUA = AQUA_DailyStatMatrix(idx0).Rrs_412_filtered_mean;
            GOCI_MODIS_matchups(count).Rrs_443_AQUA = AQUA_DailyStatMatrix(idx0).Rrs_443_filtered_mean;
            GOCI_MODIS_matchups(count).Rrs_488_AQUA = AQUA_DailyStatMatrix(idx0).Rrs_488_filtered_mean;
            GOCI_MODIS_matchups(count).Rrs_547_AQUA = AQUA_DailyStatMatrix(idx0).Rrs_547_filtered_mean;
            GOCI_MODIS_matchups(count).Rrs_555_AQUA = conv_rrs_to_555(AQUA_DailyStatMatrix(idx0).Rrs_547_filtered_mean,547);
            GOCI_MODIS_matchups(count).Rrs_667_AQUA = AQUA_DailyStatMatrix(idx0).Rrs_667_filtered_mean;
            GOCI_MODIS_matchups(count).Rrs_678_AQUA = AQUA_DailyStatMatrix(idx0).Rrs_678_filtered_mean;
      end
      
end
%%
savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','412','412','GOCI','AQUA',...
            [GOCI_MODIS_matchups.Rrs_412_GOCI],...
            [GOCI_MODIS_matchups.Rrs_412_AQUA]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_412'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','443','443','GOCI','AQUA',...
            [GOCI_MODIS_matchups.Rrs_443_GOCI],...
            [GOCI_MODIS_matchups.Rrs_443_AQUA]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_443'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','490','488','GOCI','AQUA',...
            [GOCI_MODIS_matchups.Rrs_490_GOCI],...
            [GOCI_MODIS_matchups.Rrs_488_AQUA]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_490'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','555','555','GOCI','AQUA',...
            [GOCI_MODIS_matchups.Rrs_555_GOCI],...
            [GOCI_MODIS_matchups.Rrs_555_AQUA]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_555'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','660','667','GOCI','AQUA',...
            [GOCI_MODIS_matchups.Rrs_660_GOCI],...
            [GOCI_MODIS_matchups.Rrs_667_AQUA]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_660'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','680','678','GOCI','AQUA',...
            [GOCI_MODIS_matchups.Rrs_680_GOCI],...
            [GOCI_MODIS_matchups.Rrs_678_AQUA]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_AQUA_680'],'epsc')

%% GOCI-VIIRS matchups
clear GOCI_VIIRS_matchups I t_diff

count = 0;
h1 = waitbar(0,'Initializing ...');

for idx0=1:size(VIIRS_DailyStatMatrix,2);
      str1 = sprintf('%3.2f',100*idx0/size(VIIRS_DailyStatMatrix,2));                  
      waitbar(idx0/size(VIIRS_DailyStatMatrix,2),h1,['Looking for GOCI-VIIRS Matchups: ' str1 '%'])
      
      [t_diff,I]=min(abs(VIIRS_DailyStatMatrix(idx0).datetime-[GOCI_Data_used.datetime]));
      if hours(t_diff)<0.5
            count = count+1;
            GOCI_VIIRS_matchups(count).GOCI_ifile = char(GOCI_Data_used(I).ifile);
            GOCI_VIIRS_matchups(count).GOCI_datetime = char(GOCI_Data_used(I).datetime);
            GOCI_VIIRS_matchups(count).VIIRS_ifile = VIIRS_DailyStatMatrix(idx0).ifile;
            GOCI_VIIRS_matchups(count).VIIRS_datetime = VIIRS_DailyStatMatrix(idx0).datetime;
            
            if GOCI_Data_used(I).Rrs_412_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_VIIRS_matchups(count).Rrs_412_GOCI = GOCI_Data_used(I).Rrs_412_filtered_mean;
            else 
                  GOCI_VIIRS_matchups(count).Rrs_412_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_443_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_VIIRS_matchups(count).Rrs_443_GOCI = GOCI_Data_used(I).Rrs_443_filtered_mean;
            else
                  GOCI_VIIRS_matchups(count).Rrs_443_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_490_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_VIIRS_matchups(count).Rrs_490_GOCI = GOCI_Data_used(I).Rrs_490_filtered_mean;
            else
                  GOCI_VIIRS_matchups(count).Rrs_490_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_555_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_VIIRS_matchups(count).Rrs_555_GOCI = GOCI_Data_used(I).Rrs_555_filtered_mean;
            else
                  GOCI_VIIRS_matchups(count).Rrs_555_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_660_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_VIIRS_matchups(count).Rrs_660_GOCI = GOCI_Data_used(I).Rrs_660_filtered_mean;
            else
                  GOCI_VIIRS_matchups(count).Rrs_660_GOCI = NaN;
            end

            if GOCI_Data_used(I).Rrs_680_filtered_valid_pixel_count >= total_px_GOCI/ratio_from_the_total;
                  GOCI_VIIRS_matchups(count).Rrs_680_GOCI = GOCI_Data_used(I).Rrs_680_filtered_mean;
            else
                  GOCI_VIIRS_matchups(count).Rrs_680_GOCI = NaN;
            end


            
            GOCI_VIIRS_matchups(count).Rrs_410_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_410_filtered_mean;
            GOCI_VIIRS_matchups(count).Rrs_443_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_443_filtered_mean;
            GOCI_VIIRS_matchups(count).Rrs_486_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_486_filtered_mean;
            GOCI_VIIRS_matchups(count).Rrs_551_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_551_filtered_mean;
            GOCI_VIIRS_matchups(count).Rrs_671_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_671_filtered_mean;
      end
      
end
close(h1)
%%
savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','412','410','GOCI','VIIRS',...
            [GOCI_VIIRS_matchups.Rrs_412_GOCI],...
            [GOCI_VIIRS_matchups.Rrs_410_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_412'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','443','443','GOCI','VIIRS',...
            [GOCI_VIIRS_matchups.Rrs_443_GOCI],...
            [GOCI_VIIRS_matchups.Rrs_443_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_443'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','490','486','GOCI','VIIRS',...
            [GOCI_VIIRS_matchups.Rrs_490_GOCI],...
            [GOCI_VIIRS_matchups.Rrs_486_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_490'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','555','551','GOCI','VIIRS',...
            [GOCI_VIIRS_matchups.Rrs_555_GOCI],...
            [GOCI_VIIRS_matchups.Rrs_551_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_555'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','660','671','GOCI','VIIRS',...
            [GOCI_VIIRS_matchups.Rrs_660_GOCI],...
            [GOCI_VIIRS_matchups.Rrs_671_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_660'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','680','671','GOCI','VIIRS',...
            [GOCI_VIIRS_matchups.Rrs_680_GOCI],...
            [GOCI_VIIRS_matchups.Rrs_671_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_GOCI_VIIRS_680'],'epsc')
      

%% AQUA-VIIRS matchups
clear AQUA_VIIRS_matchups

count = 0;

for idx0=1:size(VIIRS_DailyStatMatrix,2);
      [t_diff,I]=min(abs(VIIRS_DailyStatMatrix(idx0).datetime-[AQUA_DailyStatMatrix.datetime]));
      if hours(t_diff)<3
            count = count+1;
            AQUA_VIIRS_matchups(count).AQUA_ifile = char(AQUA_DailyStatMatrix(I).ifile);
            AQUA_VIIRS_matchups(count).AQUA_datetime = char(AQUA_DailyStatMatrix(I).datetime);
            AQUA_VIIRS_matchups(count).VIIRS_ifile = VIIRS_DailyStatMatrix(idx0).ifile;
            AQUA_VIIRS_matchups(count).VIIRS_datetime = VIIRS_DailyStatMatrix(idx0).datetime;
            
            AQUA_VIIRS_matchups(count).Rrs_412_AQUA = AQUA_DailyStatMatrix(I).Rrs_412_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_443_AQUA = AQUA_DailyStatMatrix(I).Rrs_443_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_490_AQUA = AQUA_DailyStatMatrix(I).Rrs_488_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_547_AQUA = AQUA_DailyStatMatrix(I).Rrs_547_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_555_AQUA = conv_rrs_to_555(AQUA_DailyStatMatrix(I).Rrs_547_filtered_mean,547);
            AQUA_VIIRS_matchups(count).Rrs_667_AQUA = AQUA_DailyStatMatrix(I).Rrs_667_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_678_AQUA = AQUA_DailyStatMatrix(I).Rrs_678_filtered_mean;

            
            AQUA_VIIRS_matchups(count).Rrs_410_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_410_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_443_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_443_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_486_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_486_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_551_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_551_filtered_mean;
            AQUA_VIIRS_matchups(count).Rrs_671_VIIRS = VIIRS_DailyStatMatrix(idx0).Rrs_671_filtered_mean;
      end
      
end
%%
savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/source/';


[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','412','410','AQUA','VIIRS',...
            [AQUA_VIIRS_matchups.Rrs_412_AQUA],...
            [AQUA_VIIRS_matchups.Rrs_410_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_AQUA_VIIRS_412'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','443','443','AQUA','VIIRS',...
            [AQUA_VIIRS_matchups.Rrs_443_AQUA],...
            [AQUA_VIIRS_matchups.Rrs_443_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_AQUA_VIIRS_443'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','490','486','AQUA','VIIRS',...
            [AQUA_VIIRS_matchups.Rrs_490_AQUA],...
            [AQUA_VIIRS_matchups.Rrs_486_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_AQUA_VIIRS_490'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','547','551','AQUA','VIIRS',...
            [AQUA_VIIRS_matchups.Rrs_547_AQUA],...
            [AQUA_VIIRS_matchups.Rrs_551_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_AQUA_VIIRS_555'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','667','671','AQUA','VIIRS',...
            [AQUA_VIIRS_matchups.Rrs_667_AQUA],...
            [AQUA_VIIRS_matchups.Rrs_671_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_AQUA_VIIRS_660'],'epsc')

[h1,ax1,leg1] = plot_sat_vs_sat('Rrs','678','671','AQUA','VIIRS',...
            [AQUA_VIIRS_matchups.Rrs_678_AQUA],...
            [AQUA_VIIRS_matchups.Rrs_671_VIIRS]);
legend off
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname 'Scatter_AQUA_VIIRS_680'],'epsc')      
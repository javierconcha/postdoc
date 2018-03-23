% script to find matchups for GOCI vcal
%% preprocessing
brdf_opt_vec = 7;
cond_brdf = [AQUA_DailyStatMatrix.brdf_opt]==brdf_opt_vec;
AQUA_DailyStatMatrix_used = AQUA_DailyStatMatrix(cond_brdf);clear cond_used;


cond_aux = [GOCI_Data.brdf_opt]==7;
GOCI_Data_used = GOCI_Data(cond_aux);clear cond_aux;

% cond_aux = [SEAW_Data.brdf_opt]==7;
% SEAW_Data_used = SEAW_Data(cond_aux);clear cond_aux;
%% vcal with MODISA
% F0 for MODISA
% # Wavelengths (um) # Extraterrestrial Solar Irradiance (mW/cm^2/um/sr)
% #
% Lambda(1) = 412; F0(1) = 172.912
% Lambda(2) = 443; F0(2) = 187.622
% Lambda(3) = 488; F0(3) = 194.933
% Lambda(5) = 547; F0(5) = 186.539
% Lambda(6) = 667; F0(6) = 152.255
% Lambda(7) = 678; F0(7) = 148.052
% Lambda(8) = 748; F0(8) = 128.065
% Lambda(9) = 869; F0(9) = 95.824

% F0_412 = 172.912;
% F0_443 = 187.622;
% F0_488 = 194.933;
F0_547 = 186.539;
% from l2.fmt
% "Rrs_555" "solar_irradiance" "solar_irradiance" DFNT_FLOAT32 1 READ_ONE_VAL 183.75676
%     Rrs_555:solar_irradiance = 1837.567f ; The units are W/m^2/um/sr
F0_555 = 183.75676; %
% F0_667 = 152.255;
% F0_678 = 148.052;
% F0_748 = 128.065;
% F0_869 = 95.824;

clear GOCI_MODIS_GCW_matchups

fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_MODIS_GCW_matchups.txt','w');

count = 0;

h1 = waitbar(0,'Initializing ...');

for idx0 = 1:size(AQUA_DailyStatMatrix_used,2)
      
      waitbar(idx0/size(AQUA_DailyStatMatrix_used,2),h1,'Creating matchups file...')
      
      nLw_412 = 0.1*AQUA_DailyStatMatrix_used(idx0).nLw_412_filtered_mean; % nLw_412 = AQUA_DailyStatMatrix_used(idx0).Rrs_412_filtered_mean*F0_412 ;
      nLw_443 = 0.1*AQUA_DailyStatMatrix_used(idx0).nLw_443_filtered_mean;
      nLw_488 = 0.1*AQUA_DailyStatMatrix_used(idx0).nLw_488_filtered_mean;
      nLw_547 = 0.1*AQUA_DailyStatMatrix_used(idx0).nLw_547_filtered_mean;
      
      Rrs_547 = nLw_547/F0_547;
      Rrs_555 = conv_rrs_to_555(Rrs_547, 547);
      nLw_555 = Rrs_555*F0_555;
      
      nLw_667 = 0.1*AQUA_DailyStatMatrix_used(idx0).nLw_667_filtered_mean;
      nLw_678 = 0.1*AQUA_DailyStatMatrix_used(idx0).nLw_678_filtered_mean;
      
      
      
      vcal_nLw = [nLw_412, nLw_443, nLw_488, nLw_555, nLw_667, nLw_678, 0, 0];
      %%
      if ~isnan(vcal_nLw(1))&&~isnan(vcal_nLw(2))&&~isnan(vcal_nLw(3))&&~isnan(vcal_nLw(4))&&...
                  ~isnan(vcal_nLw(5))&&~isnan(vcal_nLw(6))
            if vcal_nLw(1)~=0&&vcal_nLw(2)~=0&&vcal_nLw(3)~=0&&vcal_nLw(4)~=0&&...
                        vcal_nLw(5)~=0&&vcal_nLw(6)
                  
                  
                  cond_tw = hours(abs(AQUA_DailyStatMatrix_used(idx0).datetime-[GOCI_Data_used.datetime]))<0.5;
                  
                  ind = find(cond_tw);
                  
                  vcal_nLw_str = sprintf('%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f,%2.7f',...
                        vcal_nLw(1),vcal_nLw(2),vcal_nLw(3),vcal_nLw(4),...
                        vcal_nLw(5),vcal_nLw(6),vcal_nLw(7),vcal_nLw(8));
                  
                  for idx = 1:size(ind,2)
                        
                        count = count+1;
                        GOCI_MODIS_GCW_matchups(count).GOCI_ifile = char(GOCI_Data_used(ind(idx)).ifile);
                        GOCI_MODIS_GCW_matchups(count).GOCI_datetime = char(GOCI_Data_used(ind(idx)).datetime);
                        GOCI_MODIS_GCW_matchups(count).AQUA_ifile = AQUA_DailyStatMatrix_used(idx0).ifile;
                        GOCI_MODIS_GCW_matchups(count).AQUA_datetime = AQUA_DailyStatMatrix_used(idx0).datetime;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_412 = nLw_412;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_443 = nLw_443;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_488 = nLw_488;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_547 = nLw_547;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_555 = nLw_555;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_667 = nLw_667;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw_678 = nLw_678;
                        
                        fprintf(fileID,[char(GOCI_Data_used(ind(idx)).ifile) '=' vcal_nLw_str '\n']);
                  end
            end
      end
      
end

close(h1)
fclose(fileID);

save('ValCalGOCI.mat','GOCI_MODIS_GCW_matchups','-append')
%%
figure('Color','white','DefaultAxesFontSize',12);
subplot(2,3,1)
hist([GOCI_MODIS_GCW_matchups.vcal_nLw_412])
title('nLw(412)')

subplot(2,3,2)
hist([GOCI_MODIS_GCW_matchups.vcal_nLw_443])
title('nLw(443)')

subplot(2,3,3)
hist([GOCI_MODIS_GCW_matchups.vcal_nLw_488])
title('nLw(488)')

subplot(2,3,4)
hist([GOCI_MODIS_GCW_matchups.vcal_nLw_555])
title('nLw(555)')

subplot(2,3,5)
hist([GOCI_MODIS_GCW_matchups.vcal_nLw_667])
title('nLw(667)')

subplot(2,3,6)
hist([GOCI_MODIS_GCW_matchups.vcal_nLw_678])
title('nLw(678)')


% type GOCI_MODIS_GCW_matchups.txt
%% GOCI vcal w/ SeaWiFS Climatology

% seawifs
% # Wavelengths (nm) % # Extraterrestrial Solar Irradiance (mW/cm^2/um/sr)
% Lambda(1) = 412    % F0(1) = 172.998
% Lambda(2) = 443    % F0(2) = 190.154
% Lambda(3) = 490    % F0(3) = 196.438
% Lambda(5) = 555    % F0(5) = 182.997
% Lambda(6) = 670    % F0(6) = 151.139
% Lambda(7) = 765    % F0(7) = 122.330
% Lambda(8) = 865    % F0(8) = 96.264

clear GOCI_SEAW_GCW_matchups

fileID = fopen('/Users/jconchas/Documents/Research/GOCI/GOCI_ViCal/GOCI_SEAW_GCW_matchups.txt','w');

count = 0;

h1 = waitbar(0,'Initializing ...');

for idx0 = 1:size(GOCI_Data_used,2)
      
      waitbar(idx0/size(GOCI_Data_used,2),h1,'Creating matchups file...')
      
      DOY = day(GOCI_Data_used(idx0).datetime,'dayofyear');
      
      if hours(abs(timeofday(SEAW_Clima_Final(DOY).datetime)-timeofday(GOCI_Data_used(idx0).datetime)))<.5 % SEAW_Clima_Final obtained from VCAL_GOCI.m
            
            nLw_412 = SEAW_Clima_Final(DOY).nLw_412;
            nLw_443 = SEAW_Clima_Final(DOY).nLw_443;
            nLw_490 = SEAW_Clima_Final(DOY).nLw_490;
            nLw_555 = SEAW_Clima_Final(DOY).nLw_555;
            nLw_670 = SEAW_Clima_Final(DOY).nLw_670;
            
            vcal_nLw = [nLw_412, nLw_443, nLw_490, nLw_555, nLw_670, nLw_670, 0, 0]; % GOCI band 660 and 680 repeated with SeaWiFS band 670!!!!
            
            if ~isnan(vcal_nLw(1))&&~isnan(vcal_nLw(2))&&~isnan(vcal_nLw(3))&&~isnan(vcal_nLw(4))&&...
                        ~isnan(vcal_nLw(5))&&~isnan(vcal_nLw(6))
                  if vcal_nLw(1)~=0&&vcal_nLw(2)~=0&&vcal_nLw(3)~=0&&vcal_nLw(4)~=0&&...
                              vcal_nLw(5)~=0&&vcal_nLw(6)
                        vcal_nLw_str = sprintf('%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f',...
                              vcal_nLw(1),vcal_nLw(2),vcal_nLw(3),vcal_nLw(4),...
                              vcal_nLw(5),vcal_nLw(6),vcal_nLw(7),vcal_nLw(8));
                        
                        count = count+1;
                        GOCI_SEAW_GCW_matchups(count).GOCI_ifile = char(GOCI_Data_used(idx0).ifile);
                        GOCI_SEAW_GCW_matchups(count).GOCI_dateline = GOCI_Data_used(idx0).datetime;
                        GOCI_SEAW_GCW_matchups(count).SEAW_Clima_DOY = DOY;
                        GOCI_SEAW_GCW_matchups(count).vcal_nLw = vcal_nLw;

                        GOCI_SEAW_GCW_matchups(count).vcal_nLw_412 = nLw_412;
                        GOCI_SEAW_GCW_matchups(count).vcal_nLw_443 = nLw_443;
                        GOCI_SEAW_GCW_matchups(count).vcal_nLw_490 = nLw_490;
                        GOCI_SEAW_GCW_matchups(count).vcal_nLw_555 = nLw_555;
                        GOCI_SEAW_GCW_matchups(count).vcal_nLw_670 = nLw_670;

                        fprintf(fileID,[char(GOCI_Data_used(idx0).ifile) '=' vcal_nLw_str '\n']);
                        
                  end
            end
      end
end

close(h1)
fclose(fileID);
save('ValCalGOCI.mat','GOCI_SEAW_GCW_matchups','-append')

%%
figure('Color','white','DefaultAxesFontSize',12);
subplot(2,3,1)
hist([GOCI_SEAW_GCW_matchups.vcal_nLw_412])
title('nLw(412)')

subplot(2,3,2)
hist([GOCI_SEAW_GCW_matchups.vcal_nLw_443])
title('nLw(443)')

subplot(2,3,3)
hist([GOCI_SEAW_GCW_matchups.vcal_nLw_490])
title('nLw(490)')

subplot(2,3,4)
hist([GOCI_SEAW_GCW_matchups.vcal_nLw_555])
title('nLw(555)')

subplot(2,3,5)
hist([GOCI_SEAW_GCW_matchups.vcal_nLw_670])
title('nLw(670)')
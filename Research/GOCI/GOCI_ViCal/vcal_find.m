% script to find matchups for GOCI vcal
%% preprocessing
cond_aux = [AQUA_DailyStatMatrix.brdf_opt]==7;
AQUA_DailyStatMatrix_used = AQUA_DailyStatMatrix(cond_aux);clear cond_aux;

cond_aux = [GOCI_Data.brdf_opt]==7;
GOCI_Data_used = GOCI_Data(cond_aux);clear cond_aux;

% cond_aux = [SEAW_Data.brdf_opt]==7;
% SEAW_Data_used = SEAW_Data(cond_aux);clear cond_aux;

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


F0_412 = 172.912;
F0_443 = 187.622;
F0_488 = 194.933;
F0_547 = 186.539;
F0_667 = 152.255;
F0_678 = 148.052;
F0_748 = 128.065;
F0_869 = 95.824;
%% vcal with MODISA
clear GOCI_MODIS_GCW_matchups

fileID = fopen('GOCI_MODIS_GCW_matchups.txt','w');

count = 0;

h1 = waitbar(0,'Initializing ...');

for idx0 = 1:size(AQUA_DailyStatMatrix_used,2)
      
      waitbar(idx0/size(AQUA_DailyStatMatrix_used,2),h1,'Creating matchups file...')
      
      nLw_412 = AQUA_DailyStatMatrix_used(idx0).Rrs_412_filtered_mean*F0_412 ;
      nLw_443 = AQUA_DailyStatMatrix_used(idx0).Rrs_443_filtered_mean*F0_443 ;
      nLw_488 = AQUA_DailyStatMatrix_used(idx0).Rrs_488_filtered_mean*F0_488 ;
      nLw_547 = AQUA_DailyStatMatrix_used(idx0).Rrs_547_filtered_mean*F0_547 ;
      nLw_667 = AQUA_DailyStatMatrix_used(idx0).Rrs_667_filtered_mean*F0_667 ;
      nLw_678 = AQUA_DailyStatMatrix_used(idx0).Rrs_678_filtered_mean*F0_678 ;
      
      vcal_nLw = [nLw_412, nLw_443, nLw_488, nLw_547, nLw_667, nLw_678, 0, 0];
      %%
      if ~isnan(vcal_nLw(1))&&~isnan(vcal_nLw(2))&&~isnan(vcal_nLw(3))&&~isnan(vcal_nLw(4))&&...
                  ~isnan(vcal_nLw(5))&&~isnan(vcal_nLw(6))
            if vcal_nLw(1)~=0&&vcal_nLw(2)~=0&&vcal_nLw(3)~=0&&vcal_nLw(4)~=0&&...
                        vcal_nLw(5)~=0&&vcal_nLw(6)
                  
                  
                  cond_tw = abs(AQUA_DailyStatMatrix_used(idx0).datetime-[GOCI_Data_used.datetime])<=hours(3);
                  
                  ind = find(cond_tw);
                  
                  vcal_nLw_str = sprintf('%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f,%2.5f',...
                        vcal_nLw(1),vcal_nLw(2),vcal_nLw(3),vcal_nLw(4),...
                        vcal_nLw(5),vcal_nLw(6),vcal_nLw(7),vcal_nLw(8));
                  
                  for idx = 1:size(ind,2)
                        
                        count = count+1;
                        GOCI_MODIS_GCW_matchups(count).GOCI_ifile = char(GOCI_Data_used(ind(idx)).ifile);
                        GOCI_MODIS_GCW_matchups(count).AQUA_ifile = AQUA_DailyStatMatrix_used(idx0).ifile;
                        GOCI_MODIS_GCW_matchups(count).AQUA_datetime = AQUA_DailyStatMatrix_used(idx0).datetime;
                        GOCI_MODIS_GCW_matchups(count).vcal_nLw = vcal_nLw;
                        fprintf(fileID,[char(GOCI_Data_used(ind(idx)).ifile) '=' vcal_nLw_str '\n']);
                  end
            end
      end
      
end

close(h1)
fclose(fileID);

save('ValCalGOCI.mat','GOCI_MODIS_GCW_matchups','-append')

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
F0_412 = 172.998;
F0_443 = 190.154;
F0_490 = 196.438;
F0_555 = 182.997;
F0_670 = 151.1;

clear GOCI_SEAW_GCW_matchups

fileID = fopen('GOCI_SEAW_GCW_matchups.txt','w');

count = 0;

h1 = waitbar(0,'Initializing ...');

for idx0 = 1:size(GOCI_Data_used,2)
      
      waitbar(idx0/size(GOCI_Data_used,2),h1,'Creating matchups file...')
      
      DOY = day(GOCI_Data_used(idx0).datetime,'dayofyear');
      
      if abs(timeofday(SEAW_Clima_Final(DOY).datetime)-timeofday(GOCI_Data_used(idx0).datetime))<=hours(3)
            
            nLw_412 = SEAW_Clima_Final(DOY).Rrs_412*F0_412;
            nLw_443 = SEAW_Clima_Final(DOY).Rrs_443*F0_443;
            nLw_490 = SEAW_Clima_Final(DOY).Rrs_490*F0_490;
            nLw_555 = SEAW_Clima_Final(DOY).Rrs_555*F0_555;
            nLw_670 = SEAW_Clima_Final(DOY).Rrs_670*F0_670;
            
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
                        fprintf(fileID,[char(GOCI_Data_used(idx0).ifile) '=' vcal_nLw_str '\n']);
                        
                  end
            end
      end
end

close(h1)
fclose(fileID);
save('ValCalGOCI.mat','GOCI_SEAW_GCW_matchups','-append')
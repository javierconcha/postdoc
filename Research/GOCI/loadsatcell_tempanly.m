function satcell = loadsatcell_tempanly(filepath,sensor_id)
%%

% if exist(fullFileName, 'file')
%   % File exists.  Do stuff....
% else
%   % File does not exist.
%   warningMessage = sprintf('Warning: file does not exist:\n%s', fullFileName);
%   uiwait(msgbox(warningMessage));
% end

%%
% Parameters
fullFileName = [filepath '.param'];

if exist(fullFileName, 'file')
      
      fileID = fopen(fullFileName);
      s = textscan(fileID,'%s','Delimiter','=');
      fclose(fileID);
      
      satcell.ifile           = s{1}{2};
      satcell.ofile 		= s{1}{4};
      satcell.filepath        = filepath;
end



if ~isempty(strfind(filepath,'BRDF0'))
      satcell.brdf_opt = 0;
elseif ~isempty(strfind(filepath,'BRDF3'))
      satcell.brdf_opt = 3;
elseif ~isempty(strfind(filepath,'BRDF7'))
      satcell.brdf_opt = 7;
else
      satcell.brdf_opt = [];
end


%% .output
fullFileName = filepath;
if exist(fullFileName, 'file')
      fileID = fopen(fullFileName);
      s = textscan(fileID,'%s','Delimiter','=');
      fclose(fileID);
      
      % time and Solar Azimuthal and Zenith angle
      idx1 = find(strncmp(s{1},'time',4));
      parval = s{1}{idx1+1};
      
      % %% temporal fix for time recording
      % ifile_char = satcell.ifile;
      %
      % if strcmp(ifile_char(26:27),'00')
      %       parval(12:end) = '00:28:46.887';
      % elseif strcmp(ifile_char(26:27),'01')
      %       parval(12:end) = '01:28:46.887';
      % elseif strcmp(ifile_char(26:27),'02')
      %       parval(12:end) = '02:28:46.887';
      % elseif strcmp(ifile_char(26:27),'03')
      %       parval(12:end) = '03:28:46.887';
      % elseif strcmp(ifile_char(26:27),'04')
      %       parval(12:end) = '04:28:46.887';
      % elseif strcmp(ifile_char(26:27),'05')
      %       parval(12:end) = '05:28:46.887';
      % elseif strcmp(ifile_char(26:27),'06')
      %       parval(12:end) = '06:28:46.887';
      % elseif strcmp(ifile_char(26:27),'07')
      %       parval(12:end) = '07:28:46.887';
      % end
      
      timechar = parval;
      
      %%
      taux = datetime(parval,'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
      satcell.datetime = taux;
      
      % center_lat
      idx1 = find(strncmp(s{1},'center_lat',10));
      satcell.center_lat = str2double(s{1}{idx1+1});
      
      % center_lon
      idx1 = find(strncmp(s{1},'center_lon',10));
      satcell.center_lon = str2double(s{1}{idx1+1});
      
      % center_line
      idx1 = find(strncmp(s{1},'center_line',11));
      satcell.center_line =  str2double(s{1}{idx1+1});
      
      % center_pixel
      idx1 = find(strncmp(s{1},'center_pixel',12));
      satcell.center_pixel =  str2double(s{1}{idx1+1});
      
      % pixel_count
      idx1 = find(strncmp(s{1},'pixel_count',11));
      satcell.pixel_count =  str2double(s{1}{idx1+1});
      
      % unflagged_pixel_count
      idx1 = find(strncmp(s{1},'unflagged',9));
      satcell.unflagged_pixel_count =  str2double(s{1}{idx1+1});
      
      % flagged_pixel_count
      idx1 = find(strncmp(s{1},'flagged',7));
      satcell.flagged_pixel_count =  str2double(s{1}{idx1+1});
      
      %% Solar Azimuthal and Zenith angle
      
      DC  = timechar;
      DV  = datevec(DC);  % [N x 6] array
      DV  = DV(:, 1:3);   % [N x 3] array, no time
      DV2 = DV;
      DV2(:, 2:3) = 0;    % [N x 3], day before 01.Jan
      
      Result = cat(2, DV(:, 1), datenum(DV) - datenum(DV2));
      
      [~,~,~,hour,min,sec] = datevec(taux);
      
      [zen,azm] = sunzen( satcell.center_lat,satcell.center_lon, Result(2), hour, min, sec);
      
      %
      % [Az,El] = SolarAzEl(timechar,satcell.center_lat,satcell.center_lon,0);
      satcell.center_az = azm;
      satcell.center_ze = zen;
end

%% Products

if ~strcmp(sensor_id,'GOCI_vcal')
      
      % latitude
      fullFileName = [filepath '.latitude'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.latitude_center_value                    = str2double(s{1}{6});
            satcell.latitude_valid_pixel_count               = str2double(s{1}{8});
            satcell.latitude_max                                   = str2double(s{1}{10});
            satcell.latitude_min                                   = str2double(s{1}{12});
            satcell.latitude_mean                                  = str2double(s{1}{14});
            satcell.latitude_median                                = str2double(s{1}{16});
            satcell.latitude_stddev                                = str2double(s{1}{18});
            satcell.latitude_rms                                   = str2double(s{1}{20});
            satcell.latitude_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.latitude_filtered_max                    = str2double(s{1}{24});
            satcell.latitude_filtered_min                    = str2double(s{1}{26});
            satcell.latitude_filtered_mean                         = str2double(s{1}{28});
            satcell.latitude_filtered_median                 = str2double(s{1}{30});
            satcell.latitude_filtered_stddev                 = str2double(s{1}{32});
            satcell.latitude_filtered_rms                    = str2double(s{1}{34});
            satcell.latitude_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.latitude_iqr_max                               = str2double(s{1}{38});
            satcell.latitude_iqr_min                               = str2double(s{1}{40});
            satcell.latitude_iqr_mean                              = str2double(s{1}{42});
            satcell.latitude_iqr_median                            = str2double(s{1}{44});
            satcell.latitude_iqr_stddev                            = str2double(s{1}{46});
            satcell.latitude_iqr_rms                               = str2double(s{1}{48});
      end
      
      % longitude
      fullFileName = [filepath '.longitude'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.longitude_center_value                    = str2double(s{1}{6});
            satcell.longitude_valid_pixel_count               = str2double(s{1}{8});
            satcell.longitude_max                                   = str2double(s{1}{10});
            satcell.longitude_min                                   = str2double(s{1}{12});
            satcell.longitude_mean                                  = str2double(s{1}{14});
            satcell.longitude_median                                = str2double(s{1}{16});
            satcell.longitude_stddev                                = str2double(s{1}{18});
            satcell.longitude_rms                                   = str2double(s{1}{20});
            satcell.longitude_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.longitude_filtered_max                    = str2double(s{1}{24});
            satcell.longitude_filtered_min                    = str2double(s{1}{26});
            satcell.longitude_filtered_mean                         = str2double(s{1}{28});
            satcell.longitude_filtered_median                 = str2double(s{1}{30});
            satcell.longitude_filtered_stddev                 = str2double(s{1}{32});
            satcell.longitude_filtered_rms                    = str2double(s{1}{34});
            satcell.longitude_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.longitude_iqr_max                               = str2double(s{1}{38});
            satcell.longitude_iqr_min                               = str2double(s{1}{40});
            satcell.longitude_iqr_mean                              = str2double(s{1}{42});
            satcell.longitude_iqr_median                            = str2double(s{1}{44});
            satcell.longitude_iqr_stddev                            = str2double(s{1}{46});
            satcell.longitude_iqr_rms                               = str2double(s{1}{48});
      end
      
      % Rrs_410
      fullFileName = [filepath '.Rrs_410'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_410_center_value 				= str2double(s{1}{6});
            satcell.Rrs_410_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_410_max 						= str2double(s{1}{10});
            satcell.Rrs_410_min 						= str2double(s{1}{12});
            satcell.Rrs_410_mean 						= str2double(s{1}{14});
            satcell.Rrs_410_median 						= str2double(s{1}{16});
            satcell.Rrs_410_stddev 						= str2double(s{1}{18});
            satcell.Rrs_410_rms 						= str2double(s{1}{20});
            satcell.Rrs_410_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_410_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_410_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_410_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_410_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_410_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_410_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_410_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_410_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_410_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_410_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_410_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_410_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_410_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_410_CV                                    = satcell.Rrs_410_filtered_stddev/satcell.Rrs_410_filtered_mean;
            
      end
      
      %% Products
      % Rrs_412
      fullFileName = [filepath '.Rrs_412'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_412_center_value 				= str2double(s{1}{6});
            satcell.Rrs_412_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_412_max 						= str2double(s{1}{10});
            satcell.Rrs_412_min 						= str2double(s{1}{12});
            satcell.Rrs_412_mean 						= str2double(s{1}{14});
            satcell.Rrs_412_median 						= str2double(s{1}{16});
            satcell.Rrs_412_stddev 						= str2double(s{1}{18});
            satcell.Rrs_412_rms 						= str2double(s{1}{20});
            satcell.Rrs_412_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_412_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_412_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_412_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_412_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_412_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_412_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_412_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_412_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_412_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_412_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_412_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_412_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_412_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_412_CV                                    = satcell.Rrs_412_filtered_stddev/satcell.Rrs_412_filtered_mean;
            
      end
      
      % Rrs_443
      fullFileName = [filepath '.Rrs_443'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_443_center_value 				= str2double(s{1}{6});
            satcell.Rrs_443_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_443_max 						= str2double(s{1}{10});
            satcell.Rrs_443_min 						= str2double(s{1}{12});
            satcell.Rrs_443_mean 						= str2double(s{1}{14});
            satcell.Rrs_443_median 						= str2double(s{1}{16});
            satcell.Rrs_443_stddev 						= str2double(s{1}{18});
            satcell.Rrs_443_rms 						= str2double(s{1}{20});
            satcell.Rrs_443_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_443_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_443_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_443_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_443_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_443_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_443_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_443_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_443_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_443_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_443_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_443_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_443_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_443_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_443_CV                                    = satcell.Rrs_443_filtered_stddev/satcell.Rrs_443_filtered_mean;
            
      end
      
      % Rrs_469
      fullFileName = [filepath '.Rrs_469'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_469_center_value 				= str2double(s{1}{6});
            satcell.Rrs_469_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_469_max 						= str2double(s{1}{10});
            satcell.Rrs_469_min 						= str2double(s{1}{12});
            satcell.Rrs_469_mean 						= str2double(s{1}{14});
            satcell.Rrs_469_median 						= str2double(s{1}{16});
            satcell.Rrs_469_stddev 						= str2double(s{1}{18});
            satcell.Rrs_469_rms 						= str2double(s{1}{20});
            satcell.Rrs_469_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_469_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_469_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_469_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_469_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_469_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_469_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_469_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_469_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_469_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_469_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_469_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_469_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_469_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_469_CV                                    = satcell.Rrs_469_filtered_stddev/satcell.Rrs_469_filtered_mean;
            
      end
      
      
      %% Products
      % Rrs_486
      fullFileName = [filepath '.Rrs_486'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_486_center_value 				= str2double(s{1}{6});
            satcell.Rrs_486_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_486_max 						= str2double(s{1}{10});
            satcell.Rrs_486_min 						= str2double(s{1}{12});
            satcell.Rrs_486_mean 						= str2double(s{1}{14});
            satcell.Rrs_486_median 						= str2double(s{1}{16});
            satcell.Rrs_486_stddev 						= str2double(s{1}{18});
            satcell.Rrs_486_rms 						= str2double(s{1}{20});
            satcell.Rrs_486_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_486_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_486_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_486_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_486_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_486_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_486_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_486_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_486_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_486_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_486_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_486_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_486_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_486_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_486_CV                                    = satcell.Rrs_486_filtered_stddev/satcell.Rrs_486_filtered_mean;
            
      end
      % Rrs_488
      fullFileName = [filepath '.Rrs_488'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_488_center_value 				= str2double(s{1}{6});
            satcell.Rrs_488_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_488_max 						= str2double(s{1}{10});
            satcell.Rrs_488_min 						= str2double(s{1}{12});
            satcell.Rrs_488_mean 						= str2double(s{1}{14});
            satcell.Rrs_488_median 						= str2double(s{1}{16});
            satcell.Rrs_488_stddev 						= str2double(s{1}{18});
            satcell.Rrs_488_rms 						= str2double(s{1}{20});
            satcell.Rrs_488_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_488_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_488_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_488_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_488_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_488_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_488_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_488_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_488_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_488_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_488_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_488_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_488_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_488_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_488_CV                                    = satcell.Rrs_488_filtered_stddev/satcell.Rrs_488_filtered_mean;
            
      end
      
      % Rrs_490
      fullFileName = [filepath '.Rrs_490'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_490_center_value 				= str2double(s{1}{6});
            satcell.Rrs_490_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_490_max 						= str2double(s{1}{10});
            satcell.Rrs_490_min 						= str2double(s{1}{12});
            satcell.Rrs_490_mean 						= str2double(s{1}{14});
            satcell.Rrs_490_median 						= str2double(s{1}{16});
            satcell.Rrs_490_stddev 						= str2double(s{1}{18});
            satcell.Rrs_490_rms 						= str2double(s{1}{20});
            satcell.Rrs_490_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_490_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_490_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_490_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_490_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_490_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_490_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_490_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_490_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_490_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_490_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_490_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_490_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_490_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_490_CV                                    = satcell.Rrs_490_filtered_stddev/satcell.Rrs_490_filtered_mean;
            
      end
      
      % Rrs_531
      fullFileName = [filepath '.Rrs_531'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_531_center_value 				= str2double(s{1}{6});
            satcell.Rrs_531_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_531_max 						= str2double(s{1}{10});
            satcell.Rrs_531_min 						= str2double(s{1}{12});
            satcell.Rrs_531_mean 						= str2double(s{1}{14});
            satcell.Rrs_531_median 						= str2double(s{1}{16});
            satcell.Rrs_531_stddev 						= str2double(s{1}{18});
            satcell.Rrs_531_rms 						= str2double(s{1}{20});
            satcell.Rrs_531_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_531_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_531_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_531_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_531_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_531_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_531_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_531_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_531_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_531_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_531_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_531_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_531_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_531_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_531_CV                                    = satcell.Rrs_531_filtered_stddev/satcell.Rrs_531_filtered_mean;
            
      end
      
      % Rrs_547
      fullFileName = [filepath '.Rrs_547'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_547_center_value 				= str2double(s{1}{6});
            satcell.Rrs_547_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_547_max 						= str2double(s{1}{10});
            satcell.Rrs_547_min 						= str2double(s{1}{12});
            satcell.Rrs_547_mean 						= str2double(s{1}{14});
            satcell.Rrs_547_median 						= str2double(s{1}{16});
            satcell.Rrs_547_stddev 						= str2double(s{1}{18});
            satcell.Rrs_547_rms 						= str2double(s{1}{20});
            satcell.Rrs_547_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_547_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_547_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_547_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_547_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_547_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_547_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_547_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_547_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_547_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_547_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_547_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_547_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_547_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_547_CV                                    = satcell.Rrs_547_filtered_stddev/satcell.Rrs_547_filtered_mean;
            
      end
      
      %% Products
      % Rrs_551
      fullFileName = [filepath '.Rrs_551'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_551_center_value 				= str2double(s{1}{6});
            satcell.Rrs_551_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_551_max 						= str2double(s{1}{10});
            satcell.Rrs_551_min 						= str2double(s{1}{12});
            satcell.Rrs_551_mean 						= str2double(s{1}{14});
            satcell.Rrs_551_median 						= str2double(s{1}{16});
            satcell.Rrs_551_stddev 						= str2double(s{1}{18});
            satcell.Rrs_551_rms 						= str2double(s{1}{20});
            satcell.Rrs_551_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_551_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_551_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_551_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_551_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_551_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_551_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_551_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_551_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_551_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_551_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_551_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_551_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_551_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_551_CV                                    = satcell.Rrs_551_filtered_stddev/satcell.Rrs_551_filtered_mean;
            
      end
      
      % Rrs_555
      fullFileName = [filepath '.Rrs_555'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_555_center_value 				= str2double(s{1}{6});
            satcell.Rrs_555_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_555_max 						= str2double(s{1}{10});
            satcell.Rrs_555_min 						= str2double(s{1}{12});
            satcell.Rrs_555_mean 						= str2double(s{1}{14});
            satcell.Rrs_555_median 						= str2double(s{1}{16});
            satcell.Rrs_555_stddev 						= str2double(s{1}{18});
            satcell.Rrs_555_rms 						= str2double(s{1}{20});
            satcell.Rrs_555_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_555_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_555_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_555_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_555_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_555_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_555_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_555_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_555_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_555_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_555_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_555_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_555_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_555_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_555_CV                                    = satcell.Rrs_555_filtered_stddev/satcell.Rrs_555_filtered_mean;
            
      end
      
      % Rrs_645
      fullFileName = [filepath '.Rrs_645'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_645_center_value 				= str2double(s{1}{6});
            satcell.Rrs_645_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_645_max 						= str2double(s{1}{10});
            satcell.Rrs_645_min 						= str2double(s{1}{12});
            satcell.Rrs_645_mean 						= str2double(s{1}{14});
            satcell.Rrs_645_median 						= str2double(s{1}{16});
            satcell.Rrs_645_stddev 						= str2double(s{1}{18});
            satcell.Rrs_645_rms 						= str2double(s{1}{20});
            satcell.Rrs_645_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_645_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_645_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_645_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_645_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_645_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_645_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_645_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_645_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_645_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_645_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_645_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_645_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_645_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_645_CV                                    = satcell.Rrs_645_filtered_stddev/satcell.Rrs_645_filtered_mean;
            
      end
      
      % Rrs_660
      fullFileName = [filepath '.Rrs_660'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_660_center_value 				= str2double(s{1}{6});
            satcell.Rrs_660_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_660_max 						= str2double(s{1}{10});
            satcell.Rrs_660_min 						= str2double(s{1}{12});
            satcell.Rrs_660_mean 						= str2double(s{1}{14});
            satcell.Rrs_660_median 						= str2double(s{1}{16});
            satcell.Rrs_660_stddev 						= str2double(s{1}{18});
            satcell.Rrs_660_rms 						= str2double(s{1}{20});
            satcell.Rrs_660_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_660_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_660_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_660_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_660_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_660_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_660_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_660_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_660_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_660_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_660_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_660_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_660_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_660_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_660_CV                                    = satcell.Rrs_660_filtered_stddev/satcell.Rrs_660_filtered_mean;
            
      end
      
      % Rrs_667
      fullFileName = [filepath '.Rrs_667'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_667_center_value 				= str2double(s{1}{6});
            satcell.Rrs_667_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_667_max 						= str2double(s{1}{10});
            satcell.Rrs_667_min 						= str2double(s{1}{12});
            satcell.Rrs_667_mean 						= str2double(s{1}{14});
            satcell.Rrs_667_median 						= str2double(s{1}{16});
            satcell.Rrs_667_stddev 						= str2double(s{1}{18});
            satcell.Rrs_667_rms 						= str2double(s{1}{20});
            satcell.Rrs_667_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_667_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_667_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_667_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_667_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_667_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_667_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_667_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_667_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_667_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_667_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_667_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_667_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_667_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_667_CV                                    = satcell.Rrs_667_filtered_stddev/satcell.Rrs_667_filtered_mean;
            
      end
      
      % Rrs_670
      fullFileName = [filepath '.Rrs_670'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_670_center_value                    = str2double(s{1}{6});
            satcell.Rrs_670_valid_pixel_count               = str2double(s{1}{8});
            satcell.Rrs_670_max                                   = str2double(s{1}{10});
            satcell.Rrs_670_min                                   = str2double(s{1}{12});
            satcell.Rrs_670_mean                                  = str2double(s{1}{14});
            satcell.Rrs_670_median                                = str2double(s{1}{16});
            satcell.Rrs_670_stddev                                = str2double(s{1}{18});
            satcell.Rrs_670_rms                                   = str2double(s{1}{20});
            satcell.Rrs_670_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.Rrs_670_filtered_max                    = str2double(s{1}{24});
            satcell.Rrs_670_filtered_min                    = str2double(s{1}{26});
            satcell.Rrs_670_filtered_mean                         = str2double(s{1}{28});
            satcell.Rrs_670_filtered_median                 = str2double(s{1}{30});
            satcell.Rrs_670_filtered_stddev                 = str2double(s{1}{32});
            satcell.Rrs_670_filtered_rms                    = str2double(s{1}{34});
            satcell.Rrs_670_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.Rrs_670_iqr_max                               = str2double(s{1}{38});
            satcell.Rrs_670_iqr_min                               = str2double(s{1}{40});
            satcell.Rrs_670_iqr_mean                              = str2double(s{1}{42});
            satcell.Rrs_670_iqr_median                            = str2double(s{1}{44});
            satcell.Rrs_670_iqr_stddev                            = str2double(s{1}{46});
            satcell.Rrs_670_iqr_rms                               = str2double(s{1}{48});
            satcell.Rrs_670_CV                                    = satcell.Rrs_670_filtered_stddev/satcell.Rrs_670_filtered_mean;
            
      end
      
      % Rrs_671
      fullFileName = [filepath '.Rrs_671'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_671_center_value 				= str2double(s{1}{6});
            satcell.Rrs_671_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_671_max 						= str2double(s{1}{10});
            satcell.Rrs_671_min 						= str2double(s{1}{12});
            satcell.Rrs_671_mean 						= str2double(s{1}{14});
            satcell.Rrs_671_median 						= str2double(s{1}{16});
            satcell.Rrs_671_stddev 						= str2double(s{1}{18});
            satcell.Rrs_671_rms 						= str2double(s{1}{20});
            satcell.Rrs_671_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_671_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_671_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_671_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_671_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_671_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_671_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_671_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_671_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_671_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_671_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_671_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_671_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_671_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_671_CV                                    = satcell.Rrs_671_filtered_stddev/satcell.Rrs_671_filtered_mean;
            
      end
      
      % Rrs_678
      fullFileName = [filepath '.Rrs_678'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_678_center_value 				= str2double(s{1}{6});
            satcell.Rrs_678_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_678_max 						= str2double(s{1}{10});
            satcell.Rrs_678_min 						= str2double(s{1}{12});
            satcell.Rrs_678_mean 						= str2double(s{1}{14});
            satcell.Rrs_678_median 						= str2double(s{1}{16});
            satcell.Rrs_678_stddev 						= str2double(s{1}{18});
            satcell.Rrs_678_rms 						= str2double(s{1}{20});
            satcell.Rrs_678_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_678_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_678_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_678_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_678_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_678_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_678_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_678_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_678_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_678_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_678_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_678_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_678_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_678_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_678_CV                                    = satcell.Rrs_678_filtered_stddev/satcell.Rrs_678_filtered_mean;
            
      end
      
      % Rrs_680
      fullFileName = [filepath '.Rrs_680'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.Rrs_680_center_value 				= str2double(s{1}{6});
            satcell.Rrs_680_valid_pixel_count 			= str2double(s{1}{8});
            satcell.Rrs_680_max 						= str2double(s{1}{10});
            satcell.Rrs_680_min 						= str2double(s{1}{12});
            satcell.Rrs_680_mean 						= str2double(s{1}{14});
            satcell.Rrs_680_median 						= str2double(s{1}{16});
            satcell.Rrs_680_stddev 						= str2double(s{1}{18});
            satcell.Rrs_680_rms 						= str2double(s{1}{20});
            satcell.Rrs_680_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.Rrs_680_filtered_max 				= str2double(s{1}{24});
            satcell.Rrs_680_filtered_min 				= str2double(s{1}{26});
            satcell.Rrs_680_filtered_mean 				= str2double(s{1}{28});
            satcell.Rrs_680_filtered_median 			= str2double(s{1}{30});
            satcell.Rrs_680_filtered_stddev 			= str2double(s{1}{32});
            satcell.Rrs_680_filtered_rms 				= str2double(s{1}{34});
            satcell.Rrs_680_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.Rrs_680_iqr_max 					= str2double(s{1}{38});
            satcell.Rrs_680_iqr_min 					= str2double(s{1}{40});
            satcell.Rrs_680_iqr_mean 					= str2double(s{1}{42});
            satcell.Rrs_680_iqr_median 					= str2double(s{1}{44});
            satcell.Rrs_680_iqr_stddev 					= str2double(s{1}{46});
            satcell.Rrs_680_iqr_rms 					= str2double(s{1}{48});
            satcell.Rrs_680_CV                                    = satcell.Rrs_680_filtered_stddev/satcell.Rrs_680_filtered_mean;
            
      end

     % nLw_410
      fullFileName = [filepath '.nLw_410'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_410_center_value                    = str2double(s{1}{6});
            satcell.nLw_410_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_410_max                                   = str2double(s{1}{10});
            satcell.nLw_410_min                                   = str2double(s{1}{12});
            satcell.nLw_410_mean                                  = str2double(s{1}{14});
            satcell.nLw_410_median                                = str2double(s{1}{16});
            satcell.nLw_410_stddev                                = str2double(s{1}{18});
            satcell.nLw_410_rms                                   = str2double(s{1}{20});
            satcell.nLw_410_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_410_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_410_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_410_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_410_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_410_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_410_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_410_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_410_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_410_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_410_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_410_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_410_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_410_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_410_CV                                    = satcell.nLw_410_filtered_stddev/satcell.nLw_410_filtered_mean;
            
      end
      
      %% Products
      % nLw_412
      fullFileName = [filepath '.nLw_412'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_412_center_value                    = str2double(s{1}{6});
            satcell.nLw_412_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_412_max                                   = str2double(s{1}{10});
            satcell.nLw_412_min                                   = str2double(s{1}{12});
            satcell.nLw_412_mean                                  = str2double(s{1}{14});
            satcell.nLw_412_median                                = str2double(s{1}{16});
            satcell.nLw_412_stddev                                = str2double(s{1}{18});
            satcell.nLw_412_rms                                   = str2double(s{1}{20});
            satcell.nLw_412_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_412_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_412_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_412_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_412_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_412_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_412_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_412_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_412_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_412_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_412_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_412_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_412_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_412_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_412_CV                                    = satcell.nLw_412_filtered_stddev/satcell.nLw_412_filtered_mean;
            
      end
      
      % nLw_443
      fullFileName = [filepath '.nLw_443'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_443_center_value                    = str2double(s{1}{6});
            satcell.nLw_443_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_443_max                                   = str2double(s{1}{10});
            satcell.nLw_443_min                                   = str2double(s{1}{12});
            satcell.nLw_443_mean                                  = str2double(s{1}{14});
            satcell.nLw_443_median                                = str2double(s{1}{16});
            satcell.nLw_443_stddev                                = str2double(s{1}{18});
            satcell.nLw_443_rms                                   = str2double(s{1}{20});
            satcell.nLw_443_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_443_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_443_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_443_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_443_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_443_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_443_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_443_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_443_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_443_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_443_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_443_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_443_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_443_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_443_CV                                    = satcell.nLw_443_filtered_stddev/satcell.nLw_443_filtered_mean;
            
      end
      
      % nLw_469
      fullFileName = [filepath '.nLw_469'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_469_center_value                    = str2double(s{1}{6});
            satcell.nLw_469_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_469_max                                   = str2double(s{1}{10});
            satcell.nLw_469_min                                   = str2double(s{1}{12});
            satcell.nLw_469_mean                                  = str2double(s{1}{14});
            satcell.nLw_469_median                                = str2double(s{1}{16});
            satcell.nLw_469_stddev                                = str2double(s{1}{18});
            satcell.nLw_469_rms                                   = str2double(s{1}{20});
            satcell.nLw_469_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_469_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_469_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_469_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_469_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_469_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_469_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_469_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_469_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_469_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_469_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_469_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_469_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_469_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_469_CV                                    = satcell.nLw_469_filtered_stddev/satcell.nLw_469_filtered_mean;
            
      end
      
      
      %% Products
      % nLw_486
      fullFileName = [filepath '.nLw_486'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_486_center_value                    = str2double(s{1}{6});
            satcell.nLw_486_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_486_max                                   = str2double(s{1}{10});
            satcell.nLw_486_min                                   = str2double(s{1}{12});
            satcell.nLw_486_mean                                  = str2double(s{1}{14});
            satcell.nLw_486_median                                = str2double(s{1}{16});
            satcell.nLw_486_stddev                                = str2double(s{1}{18});
            satcell.nLw_486_rms                                   = str2double(s{1}{20});
            satcell.nLw_486_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_486_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_486_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_486_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_486_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_486_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_486_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_486_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_486_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_486_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_486_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_486_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_486_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_486_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_486_CV                                    = satcell.nLw_486_filtered_stddev/satcell.nLw_486_filtered_mean;
            
      end
      % nLw_488
      fullFileName = [filepath '.nLw_488'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_488_center_value                    = str2double(s{1}{6});
            satcell.nLw_488_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_488_max                                   = str2double(s{1}{10});
            satcell.nLw_488_min                                   = str2double(s{1}{12});
            satcell.nLw_488_mean                                  = str2double(s{1}{14});
            satcell.nLw_488_median                                = str2double(s{1}{16});
            satcell.nLw_488_stddev                                = str2double(s{1}{18});
            satcell.nLw_488_rms                                   = str2double(s{1}{20});
            satcell.nLw_488_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_488_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_488_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_488_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_488_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_488_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_488_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_488_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_488_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_488_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_488_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_488_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_488_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_488_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_488_CV                                    = satcell.nLw_488_filtered_stddev/satcell.nLw_488_filtered_mean;
            
      end
      
      % nLw_490
      fullFileName = [filepath '.nLw_490'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_490_center_value                    = str2double(s{1}{6});
            satcell.nLw_490_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_490_max                                   = str2double(s{1}{10});
            satcell.nLw_490_min                                   = str2double(s{1}{12});
            satcell.nLw_490_mean                                  = str2double(s{1}{14});
            satcell.nLw_490_median                                = str2double(s{1}{16});
            satcell.nLw_490_stddev                                = str2double(s{1}{18});
            satcell.nLw_490_rms                                   = str2double(s{1}{20});
            satcell.nLw_490_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_490_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_490_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_490_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_490_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_490_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_490_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_490_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_490_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_490_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_490_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_490_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_490_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_490_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_490_CV                                    = satcell.nLw_490_filtered_stddev/satcell.nLw_490_filtered_mean;
            
      end
      
      % nLw_531
      fullFileName = [filepath '.nLw_531'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_531_center_value                    = str2double(s{1}{6});
            satcell.nLw_531_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_531_max                                   = str2double(s{1}{10});
            satcell.nLw_531_min                                   = str2double(s{1}{12});
            satcell.nLw_531_mean                                  = str2double(s{1}{14});
            satcell.nLw_531_median                                = str2double(s{1}{16});
            satcell.nLw_531_stddev                                = str2double(s{1}{18});
            satcell.nLw_531_rms                                   = str2double(s{1}{20});
            satcell.nLw_531_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_531_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_531_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_531_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_531_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_531_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_531_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_531_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_531_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_531_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_531_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_531_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_531_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_531_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_531_CV                                    = satcell.nLw_531_filtered_stddev/satcell.nLw_531_filtered_mean;
            
      end
      
      % nLw_547
      fullFileName = [filepath '.nLw_547'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_547_center_value                    = str2double(s{1}{6});
            satcell.nLw_547_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_547_max                                   = str2double(s{1}{10});
            satcell.nLw_547_min                                   = str2double(s{1}{12});
            satcell.nLw_547_mean                                  = str2double(s{1}{14});
            satcell.nLw_547_median                                = str2double(s{1}{16});
            satcell.nLw_547_stddev                                = str2double(s{1}{18});
            satcell.nLw_547_rms                                   = str2double(s{1}{20});
            satcell.nLw_547_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_547_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_547_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_547_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_547_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_547_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_547_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_547_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_547_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_547_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_547_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_547_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_547_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_547_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_547_CV                                    = satcell.nLw_547_filtered_stddev/satcell.nLw_547_filtered_mean;
            
      end
      
      %% Products
      % nLw_551
      fullFileName = [filepath '.nLw_551'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_551_center_value                    = str2double(s{1}{6});
            satcell.nLw_551_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_551_max                                   = str2double(s{1}{10});
            satcell.nLw_551_min                                   = str2double(s{1}{12});
            satcell.nLw_551_mean                                  = str2double(s{1}{14});
            satcell.nLw_551_median                                = str2double(s{1}{16});
            satcell.nLw_551_stddev                                = str2double(s{1}{18});
            satcell.nLw_551_rms                                   = str2double(s{1}{20});
            satcell.nLw_551_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_551_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_551_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_551_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_551_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_551_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_551_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_551_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_551_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_551_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_551_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_551_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_551_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_551_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_551_CV                                    = satcell.nLw_551_filtered_stddev/satcell.nLw_551_filtered_mean;
            
      end
      
      % nLw_555
      fullFileName = [filepath '.nLw_555'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_555_center_value                    = str2double(s{1}{6});
            satcell.nLw_555_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_555_max                                   = str2double(s{1}{10});
            satcell.nLw_555_min                                   = str2double(s{1}{12});
            satcell.nLw_555_mean                                  = str2double(s{1}{14});
            satcell.nLw_555_median                                = str2double(s{1}{16});
            satcell.nLw_555_stddev                                = str2double(s{1}{18});
            satcell.nLw_555_rms                                   = str2double(s{1}{20});
            satcell.nLw_555_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_555_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_555_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_555_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_555_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_555_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_555_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_555_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_555_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_555_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_555_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_555_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_555_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_555_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_555_CV                                    = satcell.nLw_555_filtered_stddev/satcell.nLw_555_filtered_mean;
            
      end
      
      % nLw_645
      fullFileName = [filepath '.nLw_645'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_645_center_value                    = str2double(s{1}{6});
            satcell.nLw_645_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_645_max                                   = str2double(s{1}{10});
            satcell.nLw_645_min                                   = str2double(s{1}{12});
            satcell.nLw_645_mean                                  = str2double(s{1}{14});
            satcell.nLw_645_median                                = str2double(s{1}{16});
            satcell.nLw_645_stddev                                = str2double(s{1}{18});
            satcell.nLw_645_rms                                   = str2double(s{1}{20});
            satcell.nLw_645_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_645_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_645_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_645_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_645_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_645_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_645_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_645_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_645_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_645_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_645_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_645_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_645_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_645_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_645_CV                                    = satcell.nLw_645_filtered_stddev/satcell.nLw_645_filtered_mean;
            
      end
      
      % nLw_660
      fullFileName = [filepath '.nLw_660'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_660_center_value                    = str2double(s{1}{6});
            satcell.nLw_660_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_660_max                                   = str2double(s{1}{10});
            satcell.nLw_660_min                                   = str2double(s{1}{12});
            satcell.nLw_660_mean                                  = str2double(s{1}{14});
            satcell.nLw_660_median                                = str2double(s{1}{16});
            satcell.nLw_660_stddev                                = str2double(s{1}{18});
            satcell.nLw_660_rms                                   = str2double(s{1}{20});
            satcell.nLw_660_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_660_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_660_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_660_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_660_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_660_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_660_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_660_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_660_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_660_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_660_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_660_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_660_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_660_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_660_CV                                    = satcell.nLw_660_filtered_stddev/satcell.nLw_660_filtered_mean;
            
      end
      
      % nLw_667
      fullFileName = [filepath '.nLw_667'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_667_center_value                    = str2double(s{1}{6});
            satcell.nLw_667_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_667_max                                   = str2double(s{1}{10});
            satcell.nLw_667_min                                   = str2double(s{1}{12});
            satcell.nLw_667_mean                                  = str2double(s{1}{14});
            satcell.nLw_667_median                                = str2double(s{1}{16});
            satcell.nLw_667_stddev                                = str2double(s{1}{18});
            satcell.nLw_667_rms                                   = str2double(s{1}{20});
            satcell.nLw_667_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_667_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_667_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_667_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_667_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_667_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_667_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_667_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_667_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_667_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_667_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_667_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_667_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_667_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_667_CV                                    = satcell.nLw_667_filtered_stddev/satcell.nLw_667_filtered_mean;
            
      end
      
      % nLw_670
      fullFileName = [filepath '.nLw_670'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_670_center_value                    = str2double(s{1}{6});
            satcell.nLw_670_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_670_max                                   = str2double(s{1}{10});
            satcell.nLw_670_min                                   = str2double(s{1}{12});
            satcell.nLw_670_mean                                  = str2double(s{1}{14});
            satcell.nLw_670_median                                = str2double(s{1}{16});
            satcell.nLw_670_stddev                                = str2double(s{1}{18});
            satcell.nLw_670_rms                                   = str2double(s{1}{20});
            satcell.nLw_670_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_670_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_670_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_670_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_670_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_670_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_670_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_670_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_670_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_670_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_670_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_670_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_670_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_670_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_670_CV                                    = satcell.nLw_670_filtered_stddev/satcell.nLw_670_filtered_mean;
            
      end
      
      % nLw_671
      fullFileName = [filepath '.nLw_671'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_671_center_value                    = str2double(s{1}{6});
            satcell.nLw_671_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_671_max                                   = str2double(s{1}{10});
            satcell.nLw_671_min                                   = str2double(s{1}{12});
            satcell.nLw_671_mean                                  = str2double(s{1}{14});
            satcell.nLw_671_median                                = str2double(s{1}{16});
            satcell.nLw_671_stddev                                = str2double(s{1}{18});
            satcell.nLw_671_rms                                   = str2double(s{1}{20});
            satcell.nLw_671_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_671_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_671_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_671_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_671_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_671_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_671_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_671_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_671_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_671_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_671_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_671_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_671_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_671_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_671_CV                                    = satcell.nLw_671_filtered_stddev/satcell.nLw_671_filtered_mean;
            
      end
      
      % nLw_678
      fullFileName = [filepath '.nLw_678'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_678_center_value                    = str2double(s{1}{6});
            satcell.nLw_678_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_678_max                                   = str2double(s{1}{10});
            satcell.nLw_678_min                                   = str2double(s{1}{12});
            satcell.nLw_678_mean                                  = str2double(s{1}{14});
            satcell.nLw_678_median                                = str2double(s{1}{16});
            satcell.nLw_678_stddev                                = str2double(s{1}{18});
            satcell.nLw_678_rms                                   = str2double(s{1}{20});
            satcell.nLw_678_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_678_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_678_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_678_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_678_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_678_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_678_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_678_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_678_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_678_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_678_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_678_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_678_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_678_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_678_CV                                    = satcell.nLw_678_filtered_stddev/satcell.nLw_678_filtered_mean;
            
      end
      
      % nLw_680
      fullFileName = [filepath '.nLw_680'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.nLw_680_center_value                    = str2double(s{1}{6});
            satcell.nLw_680_valid_pixel_count               = str2double(s{1}{8});
            satcell.nLw_680_max                                   = str2double(s{1}{10});
            satcell.nLw_680_min                                   = str2double(s{1}{12});
            satcell.nLw_680_mean                                  = str2double(s{1}{14});
            satcell.nLw_680_median                                = str2double(s{1}{16});
            satcell.nLw_680_stddev                                = str2double(s{1}{18});
            satcell.nLw_680_rms                                   = str2double(s{1}{20});
            satcell.nLw_680_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.nLw_680_filtered_max                    = str2double(s{1}{24});
            satcell.nLw_680_filtered_min                    = str2double(s{1}{26});
            satcell.nLw_680_filtered_mean                         = str2double(s{1}{28});
            satcell.nLw_680_filtered_median                 = str2double(s{1}{30});
            satcell.nLw_680_filtered_stddev                 = str2double(s{1}{32});
            satcell.nLw_680_filtered_rms                    = str2double(s{1}{34});
            satcell.nLw_680_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.nLw_680_iqr_max                               = str2double(s{1}{38});
            satcell.nLw_680_iqr_min                               = str2double(s{1}{40});
            satcell.nLw_680_iqr_mean                              = str2double(s{1}{42});
            satcell.nLw_680_iqr_median                            = str2double(s{1}{44});
            satcell.nLw_680_iqr_stddev                            = str2double(s{1}{46});
            satcell.nLw_680_iqr_rms                               = str2double(s{1}{48});
            satcell.nLw_680_CV                                    = satcell.nLw_680_filtered_stddev/satcell.nLw_680_filtered_mean;
            
      end      
      
      % humidity
      fullFileName = [filepath '.humidity'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.humidity_center_value                    = str2double(s{1}{6});
            satcell.humidity_valid_pixel_count               = str2double(s{1}{8});
            satcell.humidity_max                                   = str2double(s{1}{10});
            satcell.humidity_min                                   = str2double(s{1}{12});
            satcell.humidity_mean                                  = str2double(s{1}{14});
            satcell.humidity_median                                = str2double(s{1}{16});
            satcell.humidity_stddev                                = str2double(s{1}{18});
            satcell.humidity_rms                                   = str2double(s{1}{20});
            satcell.humidity_filtered_valid_pixel_count      = str2double(s{1}{22});
            satcell.humidity_filtered_max                    = str2double(s{1}{24});
            satcell.humidity_filtered_min                    = str2double(s{1}{26});
            satcell.humidity_filtered_mean                         = str2double(s{1}{28});
            satcell.humidity_filtered_median                 = str2double(s{1}{30});
            satcell.humidity_filtered_stddev                 = str2double(s{1}{32});
            satcell.humidity_filtered_rms                    = str2double(s{1}{34});
            satcell.humidity_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.humidity_iqr_max                               = str2double(s{1}{38});
            satcell.humidity_iqr_min                               = str2double(s{1}{40});
            satcell.humidity_iqr_mean                              = str2double(s{1}{42});
            satcell.humidity_iqr_median                            = str2double(s{1}{44});
            satcell.humidity_iqr_stddev                            = str2double(s{1}{46});
            satcell.humidity_iqr_rms                               = str2double(s{1}{48});
            satcell.humidity_CV                                    = satcell.humidity_filtered_stddev/satcell.humidity_filtered_mean;
            
      end
      
      % ag_412_mlrc
      fullFileName = [filepath '.ag_412_mlrc'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.ag_412_mlrc_center_value 				= str2double(s{1}{6});
            satcell.ag_412_mlrc_valid_pixel_count 			= str2double(s{1}{8});
            satcell.ag_412_mlrc_max 						= str2double(s{1}{10});
            satcell.ag_412_mlrc_min 						= str2double(s{1}{12});
            satcell.ag_412_mlrc_mean 						= str2double(s{1}{14});
            satcell.ag_412_mlrc_median 						= str2double(s{1}{16});
            satcell.ag_412_mlrc_stddev 						= str2double(s{1}{18});
            satcell.ag_412_mlrc_rms 						= str2double(s{1}{20});
            satcell.ag_412_mlrc_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.ag_412_mlrc_filtered_max 				= str2double(s{1}{24});
            satcell.ag_412_mlrc_filtered_min 				= str2double(s{1}{26});
            satcell.ag_412_mlrc_filtered_mean 				= str2double(s{1}{28});
            satcell.ag_412_mlrc_filtered_median 			= str2double(s{1}{30});
            satcell.ag_412_mlrc_filtered_stddev 			= str2double(s{1}{32});
            satcell.ag_412_mlrc_filtered_rms 				= str2double(s{1}{34});
            satcell.ag_412_mlrc_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.ag_412_mlrc_iqr_max 					= str2double(s{1}{38});
            satcell.ag_412_mlrc_iqr_min 					= str2double(s{1}{40});
            satcell.ag_412_mlrc_iqr_mean 					= str2double(s{1}{42});
            satcell.ag_412_mlrc_iqr_median 					= str2double(s{1}{44});
            satcell.ag_412_mlrc_iqr_stddev 					= str2double(s{1}{46});
            satcell.ag_412_mlrc_iqr_rms 					= str2double(s{1}{48});
      end
      
      
      % chl_ocx
      fullFileName = [filepath '.chl_ocx'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.chl_ocx_center_value 				= str2double(s{1}{6});
            satcell.chl_ocx_valid_pixel_count 			= str2double(s{1}{8});
            satcell.chl_ocx_max 						= str2double(s{1}{10});
            satcell.chl_ocx_min 						= str2double(s{1}{12});
            satcell.chl_ocx_mean 						= str2double(s{1}{14});
            satcell.chl_ocx_median 						= str2double(s{1}{16});
            satcell.chl_ocx_stddev 						= str2double(s{1}{18});
            satcell.chl_ocx_rms 						= str2double(s{1}{20});
            satcell.chl_ocx_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.chl_ocx_filtered_max 				= str2double(s{1}{24});
            satcell.chl_ocx_filtered_min 				= str2double(s{1}{26});
            satcell.chl_ocx_filtered_mean 				= str2double(s{1}{28});
            satcell.chl_ocx_filtered_median 			= str2double(s{1}{30});
            satcell.chl_ocx_filtered_stddev 			= str2double(s{1}{32});
            satcell.chl_ocx_filtered_rms 				= str2double(s{1}{34});
            satcell.chl_ocx_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.chl_ocx_iqr_max 					= str2double(s{1}{38});
            satcell.chl_ocx_iqr_min 					= str2double(s{1}{40});
            satcell.chl_ocx_iqr_mean 					= str2double(s{1}{42});
            satcell.chl_ocx_iqr_median 					= str2double(s{1}{44});
            satcell.chl_ocx_iqr_stddev 					= str2double(s{1}{46});
            satcell.chl_ocx_iqr_rms 					= str2double(s{1}{48});
      end
      
      % chlor_a
      fullFileName = [filepath '.chlor_a'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.chlor_a_center_value 				= str2double(s{1}{6});
            satcell.chlor_a_valid_pixel_count 			= str2double(s{1}{8});
            satcell.chlor_a_max 						= str2double(s{1}{10});
            satcell.chlor_a_min 						= str2double(s{1}{12});
            satcell.chlor_a_mean 						= str2double(s{1}{14});
            satcell.chlor_a_median 						= str2double(s{1}{16});
            satcell.chlor_a_stddev 						= str2double(s{1}{18});
            satcell.chlor_a_rms 						= str2double(s{1}{20});
            satcell.chlor_a_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.chlor_a_filtered_max 				= str2double(s{1}{24});
            satcell.chlor_a_filtered_min 				= str2double(s{1}{26});
            satcell.chlor_a_filtered_mean 				= str2double(s{1}{28});
            satcell.chlor_a_filtered_median 			= str2double(s{1}{30});
            satcell.chlor_a_filtered_stddev 			= str2double(s{1}{32});
            satcell.chlor_a_filtered_rms 				= str2double(s{1}{34});
            satcell.chlor_a_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.chlor_a_iqr_max 					= str2double(s{1}{38});
            satcell.chlor_a_iqr_min 					= str2double(s{1}{40});
            satcell.chlor_a_iqr_mean 					= str2double(s{1}{42});
            satcell.chlor_a_iqr_median 					= str2double(s{1}{44});
            satcell.chlor_a_iqr_stddev 					= str2double(s{1}{46});
            satcell.chlor_a_iqr_rms 					= str2double(s{1}{48});
      end
      
      % kd_490
      fullFileName = [filepath '.kd_490'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.kd_490_center_value 				= str2double(s{1}{6});
            satcell.kd_490_valid_pixel_count 			= str2double(s{1}{8});
            satcell.kd_490_max 						    = str2double(s{1}{10});
            satcell.kd_490_min 						    = str2double(s{1}{12});
            satcell.kd_490_mean 						= str2double(s{1}{14});
            satcell.kd_490_median 						= str2double(s{1}{16});
            satcell.kd_490_stddev 						= str2double(s{1}{18});
            satcell.kd_490_rms 							= str2double(s{1}{20});
            satcell.kd_490_filtered_valid_pixel_count 	= str2double(s{1}{22});
            satcell.kd_490_filtered_max 				= str2double(s{1}{24});
            satcell.kd_490_filtered_min 				= str2double(s{1}{26});
            satcell.kd_490_filtered_mean 				= str2double(s{1}{28});
            satcell.kd_490_filtered_median 				= str2double(s{1}{30});
            satcell.kd_490_filtered_stddev 				= str2double(s{1}{32});
            satcell.kd_490_filtered_rms 				= str2double(s{1}{34});
            satcell.kd_490_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.kd_490_iqr_max 						= str2double(s{1}{38});
            satcell.kd_490_iqr_min 						= str2double(s{1}{40});
            satcell.kd_490_iqr_mean 					= str2double(s{1}{42});
            satcell.kd_490_iqr_median 					= str2double(s{1}{44});
            satcell.kd_490_iqr_stddev 					= str2double(s{1}{46});
            satcell.kd_490_iqr_rms 						= str2double(s{1}{48});
      end
      
      % angstrom
      fullFileName = [filepath '.angstrom'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.angstrom_center_value 				= str2double(s{1}{6});
            satcell.angstrom_valid_pixel_count 			= str2double(s{1}{8});
            satcell.angstrom_max 						= str2double(s{1}{10});
            satcell.angstrom_min 						= str2double(s{1}{12});
            satcell.angstrom_mean 						= str2double(s{1}{14});
            satcell.angstrom_median 					= str2double(s{1}{16});
            satcell.angstrom_stddev 					= str2double(s{1}{18});
            satcell.angstrom_rms 						= str2double(s{1}{20});
            satcell.angstrom_filtered_valid_pixel_count = str2double(s{1}{22});
            satcell.angstrom_filtered_max 				= str2double(s{1}{24});
            satcell.angstrom_filtered_min 				= str2double(s{1}{26});
            satcell.angstrom_filtered_mean 				= str2double(s{1}{28});
            satcell.angstrom_filtered_median 			= str2double(s{1}{30});
            satcell.angstrom_filtered_stddev 			= str2double(s{1}{32});
            satcell.angstrom_filtered_rms 				= str2double(s{1}{34});
            satcell.angstrom_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.angstrom_iqr_max 					= str2double(s{1}{38});
            satcell.angstrom_iqr_min 					= str2double(s{1}{40});
            satcell.angstrom_iqr_mean 					= str2double(s{1}{42});
            satcell.angstrom_iqr_median 				= str2double(s{1}{44});
            satcell.angstrom_iqr_stddev 				= str2double(s{1}{46});
            satcell.angstrom_iqr_rms 					= str2double(s{1}{48});
      end
      
      % brdf
      fullFileName = [filepath '.brdf'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.brdf_center_value 				= str2double(s{1}{6});
            satcell.brdf_valid_pixel_count 			= str2double(s{1}{8});
            satcell.brdf_max 						= str2double(s{1}{10});
            satcell.brdf_min 						= str2double(s{1}{12});
            satcell.brdf_mean 						= str2double(s{1}{14});
            satcell.brdf_median 					= str2double(s{1}{16});
            satcell.brdf_stddev 					= str2double(s{1}{18});
            satcell.brdf_rms 						= str2double(s{1}{20});
            satcell.brdf_filtered_valid_pixel_count = str2double(s{1}{22});
            satcell.brdf_filtered_max 				= str2double(s{1}{24});
            satcell.brdf_filtered_min 				= str2double(s{1}{26});
            satcell.brdf_filtered_mean 				= str2double(s{1}{28});
            satcell.brdf_filtered_median 			= str2double(s{1}{30});
            satcell.brdf_filtered_stddev 			= str2double(s{1}{32});
            satcell.brdf_filtered_rms 				= str2double(s{1}{34});
            satcell.brdf_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.brdf_iqr_max 					= str2double(s{1}{38});
            satcell.brdf_iqr_min 					= str2double(s{1}{40});
            satcell.brdf_iqr_mean 					= str2double(s{1}{42});
            satcell.brdf_iqr_median 				= str2double(s{1}{44});
            satcell.brdf_iqr_stddev 				= str2double(s{1}{46});
            satcell.brdf_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_412
      fullFileName = [filepath '.aot_412'];
      
      if exist(fullFileName, 'file')
            
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            
            satcell.aot_412_center_value 				= str2double(s{1}{6});
            satcell.aot_412_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_412_max 						= str2double(s{1}{10});
            satcell.aot_412_min 						= str2double(s{1}{12});
            satcell.aot_412_mean 						= str2double(s{1}{14});
            satcell.aot_412_median 						= str2double(s{1}{16});
            satcell.aot_412_stddev 						= str2double(s{1}{18});
            satcell.aot_412_rms 						= str2double(s{1}{20});
            satcell.aot_412_filtered_valid_pixel_count = str2double(s{1}{22});
            satcell.aot_412_filtered_max 				= str2double(s{1}{24});
            satcell.aot_412_filtered_min 				= str2double(s{1}{26});
            satcell.aot_412_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_412_filtered_median 			= str2double(s{1}{30});
            satcell.aot_412_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_412_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_412_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_412_iqr_max 					= str2double(s{1}{38});
            satcell.aot_412_iqr_min 					= str2double(s{1}{40});
            satcell.aot_412_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_412_iqr_median 					= str2double(s{1}{44});
            satcell.aot_412_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_412_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_443
      fullFileName = [filepath '.aot_443'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_443_center_value 				= str2double(s{1}{6});
            satcell.aot_443_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_443_max 						= str2double(s{1}{10});
            satcell.aot_443_min 						= str2double(s{1}{12});
            satcell.aot_443_mean 						= str2double(s{1}{14});
            satcell.aot_443_median 						= str2double(s{1}{16});
            satcell.aot_443_stddev 						= str2double(s{1}{18});
            satcell.aot_443_rms 						= str2double(s{1}{20});
            satcell.aot_443_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_443_filtered_max 				= str2double(s{1}{24});
            satcell.aot_443_filtered_min 				= str2double(s{1}{26});
            satcell.aot_443_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_443_filtered_median 			= str2double(s{1}{30});
            satcell.aot_443_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_443_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_443_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_443_iqr_max 					= str2double(s{1}{38});
            satcell.aot_443_iqr_min 					= str2double(s{1}{40});
            satcell.aot_443_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_443_iqr_median 					= str2double(s{1}{44});
            satcell.aot_443_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_443_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_469
      fullFileName = [filepath '.aot_469'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_469_center_value 				= str2double(s{1}{6});
            satcell.aot_469_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_469_max 						= str2double(s{1}{10});
            satcell.aot_469_min 						= str2double(s{1}{12});
            satcell.aot_469_mean 						= str2double(s{1}{14});
            satcell.aot_469_median 						= str2double(s{1}{16});
            satcell.aot_469_stddev 						= str2double(s{1}{18});
            satcell.aot_469_rms 						= str2double(s{1}{20});
            satcell.aot_469_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_469_filtered_max 				= str2double(s{1}{24});
            satcell.aot_469_filtered_min 				= str2double(s{1}{26});
            satcell.aot_469_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_469_filtered_median 			= str2double(s{1}{30});
            satcell.aot_469_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_469_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_469_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_469_iqr_max 					= str2double(s{1}{38});
            satcell.aot_469_iqr_min 					= str2double(s{1}{40});
            satcell.aot_469_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_469_iqr_median 					= str2double(s{1}{44});
            satcell.aot_469_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_469_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_488
      fullFileName = [filepath '.aot_488'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_488_center_value 				= str2double(s{1}{6});
            satcell.aot_488_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_488_max 						= str2double(s{1}{10});
            satcell.aot_488_min 						= str2double(s{1}{12});
            satcell.aot_488_mean 						= str2double(s{1}{14});
            satcell.aot_488_median 						= str2double(s{1}{16});
            satcell.aot_488_stddev 						= str2double(s{1}{18});
            satcell.aot_488_rms 						= str2double(s{1}{20});
            satcell.aot_488_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_488_filtered_max 				= str2double(s{1}{24});
            satcell.aot_488_filtered_min 				= str2double(s{1}{26});
            satcell.aot_488_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_488_filtered_median 			= str2double(s{1}{30});
            satcell.aot_488_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_488_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_488_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_488_iqr_max 					= str2double(s{1}{38});
            satcell.aot_488_iqr_min 					= str2double(s{1}{40});
            satcell.aot_488_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_488_iqr_median 					= str2double(s{1}{44});
            satcell.aot_488_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_488_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_490
      fullFileName = [filepath '.aot_490'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_490_center_value 				= str2double(s{1}{6});
            satcell.aot_490_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_490_max 						= str2double(s{1}{10});
            satcell.aot_490_min 						= str2double(s{1}{12});
            satcell.aot_490_mean 						= str2double(s{1}{14});
            satcell.aot_490_median 						= str2double(s{1}{16});
            satcell.aot_490_stddev 						= str2double(s{1}{18});
            satcell.aot_490_rms 						= str2double(s{1}{20});
            satcell.aot_490_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_490_filtered_max 				= str2double(s{1}{24});
            satcell.aot_490_filtered_min 				= str2double(s{1}{26});
            satcell.aot_490_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_490_filtered_median 			= str2double(s{1}{30});
            satcell.aot_490_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_490_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_490_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_490_iqr_max 					= str2double(s{1}{38});
            satcell.aot_490_iqr_min 					= str2double(s{1}{40});
            satcell.aot_490_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_490_iqr_median 					= str2double(s{1}{44});
            satcell.aot_490_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_490_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_531
      fullFileName = [filepath '.aot_531'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_531_center_value 				= str2double(s{1}{6});
            satcell.aot_531_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_531_max 						= str2double(s{1}{10});
            satcell.aot_531_min 						= str2double(s{1}{12});
            satcell.aot_531_mean 						= str2double(s{1}{14});
            satcell.aot_531_median 						= str2double(s{1}{16});
            satcell.aot_531_stddev 						= str2double(s{1}{18});
            satcell.aot_531_rms 						= str2double(s{1}{20});
            satcell.aot_531_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_531_filtered_max 				= str2double(s{1}{24});
            satcell.aot_531_filtered_min 				= str2double(s{1}{26});
            satcell.aot_531_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_531_filtered_median 			= str2double(s{1}{30});
            satcell.aot_531_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_531_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_531_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_531_iqr_max 					= str2double(s{1}{38});
            satcell.aot_531_iqr_min 					= str2double(s{1}{40});
            satcell.aot_531_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_531_iqr_median 					= str2double(s{1}{44});
            satcell.aot_531_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_531_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_547
      fullFileName = [filepath '.aot_547'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_547_center_value 				= str2double(s{1}{6});
            satcell.aot_547_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_547_max 						= str2double(s{1}{10});
            satcell.aot_547_min 						= str2double(s{1}{12});
            satcell.aot_547_mean 						= str2double(s{1}{14});
            satcell.aot_547_median 						= str2double(s{1}{16});
            satcell.aot_547_stddev 						= str2double(s{1}{18});
            satcell.aot_547_rms 						= str2double(s{1}{20});
            satcell.aot_547_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_547_filtered_max 				= str2double(s{1}{24});
            satcell.aot_547_filtered_min 				= str2double(s{1}{26});
            satcell.aot_547_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_547_filtered_median 			= str2double(s{1}{30});
            satcell.aot_547_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_547_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_547_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_547_iqr_max 					= str2double(s{1}{38});
            satcell.aot_547_iqr_min 					= str2double(s{1}{40});
            satcell.aot_547_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_547_iqr_median 					= str2double(s{1}{44});
            satcell.aot_547_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_547_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_555
      fullFileName = [filepath '.aot_555'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_555_center_value 				= str2double(s{1}{6});
            satcell.aot_555_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_555_max 						= str2double(s{1}{10});
            satcell.aot_555_min 						= str2double(s{1}{12});
            satcell.aot_555_mean 						= str2double(s{1}{14});
            satcell.aot_555_median 						= str2double(s{1}{16});
            satcell.aot_555_stddev 						= str2double(s{1}{18});
            satcell.aot_555_rms 						= str2double(s{1}{20});
            satcell.aot_555_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_555_filtered_max 				= str2double(s{1}{24});
            satcell.aot_555_filtered_min 				= str2double(s{1}{26});
            satcell.aot_555_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_555_filtered_median 			= str2double(s{1}{30});
            satcell.aot_555_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_555_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_555_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_555_iqr_max 					= str2double(s{1}{38});
            satcell.aot_555_iqr_min 					= str2double(s{1}{40});
            satcell.aot_555_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_555_iqr_median 					= str2double(s{1}{44});
            satcell.aot_555_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_555_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_645
      fullFileName = [filepath '.aot_645'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_645_center_value 				= str2double(s{1}{6});
            satcell.aot_645_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_645_max 						= str2double(s{1}{10});
            satcell.aot_645_min 						= str2double(s{1}{12});
            satcell.aot_645_mean 						= str2double(s{1}{14});
            satcell.aot_645_median 						= str2double(s{1}{16});
            satcell.aot_645_stddev 						= str2double(s{1}{18});
            satcell.aot_645_rms 						= str2double(s{1}{20});
            satcell.aot_645_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_645_filtered_max 				= str2double(s{1}{24});
            satcell.aot_645_filtered_min 				= str2double(s{1}{26});
            satcell.aot_645_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_645_filtered_median 			= str2double(s{1}{30});
            satcell.aot_645_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_645_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_645_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_645_iqr_max 					= str2double(s{1}{38});
            satcell.aot_645_iqr_min 					= str2double(s{1}{40});
            satcell.aot_645_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_645_iqr_median 					= str2double(s{1}{44});
            satcell.aot_645_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_645_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_660
      fullFileName = [filepath '.aot_660'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_660_center_value 				= str2double(s{1}{6});
            satcell.aot_660_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_660_max 						= str2double(s{1}{10});
            satcell.aot_660_min 						= str2double(s{1}{12});
            satcell.aot_660_mean 						= str2double(s{1}{14});
            satcell.aot_660_median 						= str2double(s{1}{16});
            satcell.aot_660_stddev 						= str2double(s{1}{18});
            satcell.aot_660_rms 						= str2double(s{1}{20});
            satcell.aot_660_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_660_filtered_max 				= str2double(s{1}{24});
            satcell.aot_660_filtered_min 				= str2double(s{1}{26});
            satcell.aot_660_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_660_filtered_median 			= str2double(s{1}{30});
            satcell.aot_660_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_660_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_660_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_660_iqr_max 					= str2double(s{1}{38});
            satcell.aot_660_iqr_min 					= str2double(s{1}{40});
            satcell.aot_660_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_660_iqr_median 					= str2double(s{1}{44});
            satcell.aot_660_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_660_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_667
      fullFileName = [filepath '.aot_667'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_667_center_value 				= str2double(s{1}{6});
            satcell.aot_667_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_667_max 						= str2double(s{1}{10});
            satcell.aot_667_min 						= str2double(s{1}{12});
            satcell.aot_667_mean 						= str2double(s{1}{14});
            satcell.aot_667_median 						= str2double(s{1}{16});
            satcell.aot_667_stddev 						= str2double(s{1}{18});
            satcell.aot_667_rms 						= str2double(s{1}{20});
            satcell.aot_667_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_667_filtered_max 				= str2double(s{1}{24});
            satcell.aot_667_filtered_min 				= str2double(s{1}{26});
            satcell.aot_667_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_667_filtered_median 			= str2double(s{1}{30});
            satcell.aot_667_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_667_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_667_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_667_iqr_max 					= str2double(s{1}{38});
            satcell.aot_667_iqr_min 					= str2double(s{1}{40});
            satcell.aot_667_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_667_iqr_median 					= str2double(s{1}{44});
            satcell.aot_667_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_667_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_678
      fullFileName = [filepath '.aot_678'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_678_center_value 				= str2double(s{1}{6});
            satcell.aot_678_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_678_max 						= str2double(s{1}{10});
            satcell.aot_678_min 						= str2double(s{1}{12});
            satcell.aot_678_mean 						= str2double(s{1}{14});
            satcell.aot_678_median 						= str2double(s{1}{16});
            satcell.aot_678_stddev 						= str2double(s{1}{18});
            satcell.aot_678_rms 						= str2double(s{1}{20});
            satcell.aot_678_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_678_filtered_max 				= str2double(s{1}{24});
            satcell.aot_678_filtered_min 				= str2double(s{1}{26});
            satcell.aot_678_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_678_filtered_median 			= str2double(s{1}{30});
            satcell.aot_678_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_678_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_678_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_678_iqr_max 					= str2double(s{1}{38});
            satcell.aot_678_iqr_min 					= str2double(s{1}{40});
            satcell.aot_678_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_678_iqr_median 					= str2double(s{1}{44});
            satcell.aot_678_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_678_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_680
      fullFileName = [filepath '.aot_680'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_680_center_value 				= str2double(s{1}{6});
            satcell.aot_680_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_680_max 						= str2double(s{1}{10});
            satcell.aot_680_min 						= str2double(s{1}{12});
            satcell.aot_680_mean 						= str2double(s{1}{14});
            satcell.aot_680_median 						= str2double(s{1}{16});
            satcell.aot_680_stddev 						= str2double(s{1}{18});
            satcell.aot_680_rms 						= str2double(s{1}{20});
            satcell.aot_680_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_680_filtered_max 				= str2double(s{1}{24});
            satcell.aot_680_filtered_min 				= str2double(s{1}{26});
            satcell.aot_680_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_680_filtered_median 			= str2double(s{1}{30});
            satcell.aot_680_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_680_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_680_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_680_iqr_max 					= str2double(s{1}{38});
            satcell.aot_680_iqr_min 					= str2double(s{1}{40});
            satcell.aot_680_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_680_iqr_median 					= str2double(s{1}{44});
            satcell.aot_680_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_680_iqr_rms 					= str2double(s{1}{48});
      end
      
      % aot_862
      fullFileName = [filepath '.aot_862'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_862_center_value                    = str2double(s{1}{6});
            satcell.aot_862_valid_pixel_count               = str2double(s{1}{8});
            satcell.aot_862_max                                   = str2double(s{1}{10});
            satcell.aot_862_min                                   = str2double(s{1}{12});
            satcell.aot_862_mean                                  = str2double(s{1}{14});
            satcell.aot_862_median                                = str2double(s{1}{16});
            satcell.aot_862_stddev                                = str2double(s{1}{18});
            satcell.aot_862_rms                                   = str2double(s{1}{20});
            satcell.aot_862_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_862_filtered_max                    = str2double(s{1}{24});
            satcell.aot_862_filtered_min                    = str2double(s{1}{26});
            satcell.aot_862_filtered_mean                         = str2double(s{1}{28});
            satcell.aot_862_filtered_median                 = str2double(s{1}{30});
            satcell.aot_862_filtered_stddev                 = str2double(s{1}{32});
            satcell.aot_862_filtered_rms                    = str2double(s{1}{34});
            satcell.aot_862_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.aot_862_iqr_max                               = str2double(s{1}{38});
            satcell.aot_862_iqr_min                               = str2double(s{1}{40});
            satcell.aot_862_iqr_mean                              = str2double(s{1}{42});
            satcell.aot_862_iqr_median                            = str2double(s{1}{44});
            satcell.aot_862_iqr_stddev                            = str2double(s{1}{46});
            satcell.aot_862_iqr_rms                               = str2double(s{1}{48});
            satcell.aot_862_CV                                    = satcell.aot_862_filtered_stddev/satcell.aot_862_filtered_mean;
      end
      
      % aot_865
      fullFileName = [filepath '.aot_865'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_865_center_value 				= str2double(s{1}{6});
            satcell.aot_865_valid_pixel_count 			= str2double(s{1}{8});
            satcell.aot_865_max 						= str2double(s{1}{10});
            satcell.aot_865_min 						= str2double(s{1}{12});
            satcell.aot_865_mean 						= str2double(s{1}{14});
            satcell.aot_865_median 						= str2double(s{1}{16});
            satcell.aot_865_stddev 						= str2double(s{1}{18});
            satcell.aot_865_rms 						= str2double(s{1}{20});
            satcell.aot_865_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_865_filtered_max 				= str2double(s{1}{24});
            satcell.aot_865_filtered_min 				= str2double(s{1}{26});
            satcell.aot_865_filtered_mean 				= str2double(s{1}{28});
            satcell.aot_865_filtered_median 			= str2double(s{1}{30});
            satcell.aot_865_filtered_stddev 			= str2double(s{1}{32});
            satcell.aot_865_filtered_rms 				= str2double(s{1}{34});
            satcell.aot_865_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.aot_865_iqr_max 					= str2double(s{1}{38});
            satcell.aot_865_iqr_min 					= str2double(s{1}{40});
            satcell.aot_865_iqr_mean 					= str2double(s{1}{42});
            satcell.aot_865_iqr_median 					= str2double(s{1}{44});
            satcell.aot_865_iqr_stddev 					= str2double(s{1}{46});
            satcell.aot_865_iqr_rms 					= str2double(s{1}{48});
            satcell.aot_865_CV                                    = satcell.aot_865_filtered_stddev/satcell.aot_865_filtered_mean;
      end
      
      % aot_869
      fullFileName = [filepath '.aot_869'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.aot_869_center_value                    = str2double(s{1}{6});
            satcell.aot_869_valid_pixel_count               = str2double(s{1}{8});
            satcell.aot_869_max                                   = str2double(s{1}{10});
            satcell.aot_869_min                                   = str2double(s{1}{12});
            satcell.aot_869_mean                                  = str2double(s{1}{14});
            satcell.aot_869_median                                = str2double(s{1}{16});
            satcell.aot_869_stddev                                = str2double(s{1}{18});
            satcell.aot_869_rms                                   = str2double(s{1}{20});
            satcell.aot_869_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.aot_869_filtered_max                    = str2double(s{1}{24});
            satcell.aot_869_filtered_min                    = str2double(s{1}{26});
            satcell.aot_869_filtered_mean                         = str2double(s{1}{28});
            satcell.aot_869_filtered_median                 = str2double(s{1}{30});
            satcell.aot_869_filtered_stddev                 = str2double(s{1}{32});
            satcell.aot_869_filtered_rms                    = str2double(s{1}{34});
            satcell.aot_869_iqr_valid_pixel_count           = str2double(s{1}{36});
            satcell.aot_869_iqr_max                               = str2double(s{1}{38});
            satcell.aot_869_iqr_min                               = str2double(s{1}{40});
            satcell.aot_869_iqr_mean                              = str2double(s{1}{42});
            satcell.aot_869_iqr_median                            = str2double(s{1}{44});
            satcell.aot_869_iqr_stddev                            = str2double(s{1}{46});
            satcell.aot_869_iqr_rms                               = str2double(s{1}{48});
            satcell.aot_869_CV                                    = satcell.aot_869_filtered_stddev/satcell.aot_869_filtered_mean;
      end
      
      % epsilon
      fullFileName = [filepath '.epsilon'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.epsilon_center_value 				= str2double(s{1}{6});
            satcell.epsilon_valid_pixel_count 			= str2double(s{1}{8});
            satcell.epsilon_max 						= str2double(s{1}{10});
            satcell.epsilon_min 						= str2double(s{1}{12});
            satcell.epsilon_mean 						= str2double(s{1}{14});
            satcell.epsilon_median 						= str2double(s{1}{16});
            satcell.epsilon_stddev 						= str2double(s{1}{18});
            satcell.epsilon_rms 						= str2double(s{1}{20});
            satcell.epsilon_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.epsilon_filtered_max 				= str2double(s{1}{24});
            satcell.epsilon_filtered_min 				= str2double(s{1}{26});
            satcell.epsilon_filtered_mean 				= str2double(s{1}{28});
            satcell.epsilon_filtered_median 			= str2double(s{1}{30});
            satcell.epsilon_filtered_stddev 			= str2double(s{1}{32});
            satcell.epsilon_filtered_rms 				= str2double(s{1}{34});
            satcell.epsilon_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.epsilon_iqr_max 					= str2double(s{1}{38});
            satcell.epsilon_iqr_min 					= str2double(s{1}{40});
            satcell.epsilon_iqr_mean 					= str2double(s{1}{42});
            satcell.epsilon_iqr_median 					= str2double(s{1}{44});
            satcell.epsilon_iqr_stddev 					= str2double(s{1}{46});
            satcell.epsilon_iqr_rms 					= str2double(s{1}{48});
      end
      
      % sena
      fullFileName = [filepath '.sena'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.sena_center_value 				= str2double(s{1}{6});
            satcell.sena_valid_pixel_count 			= str2double(s{1}{8});
            satcell.sena_max 						= str2double(s{1}{10});
            satcell.sena_min 						= str2double(s{1}{12});
            satcell.sena_mean 						= str2double(s{1}{14});
            satcell.sena_median 						= str2double(s{1}{16});
            satcell.sena_stddev 						= str2double(s{1}{18});
            satcell.sena_rms 						= str2double(s{1}{20});
            satcell.sena_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.sena_filtered_max 				= str2double(s{1}{24});
            satcell.sena_filtered_min 				= str2double(s{1}{26});
            satcell.sena_filtered_mean 				= str2double(s{1}{28});
            satcell.sena_filtered_median 			= str2double(s{1}{30});
            satcell.sena_filtered_stddev 			= str2double(s{1}{32});
            satcell.sena_filtered_rms 				= str2double(s{1}{34});
            satcell.sena_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.sena_iqr_max 					= str2double(s{1}{38});
            satcell.sena_iqr_min 					= str2double(s{1}{40});
            satcell.sena_iqr_mean 					= str2double(s{1}{42});
            satcell.sena_iqr_median 					= str2double(s{1}{44});
            satcell.sena_iqr_stddev 					= str2double(s{1}{46});
            satcell.sena_iqr_rms 					= str2double(s{1}{48});
      end
      
      
      
      % sola
      fullFileName = [filepath '.sola'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.sola_center_value 				= str2double(s{1}{6});
            satcell.sola_valid_pixel_count 			= str2double(s{1}{8});
            satcell.sola_max 						= str2double(s{1}{10});
            satcell.sola_min 						= str2double(s{1}{12});
            satcell.sola_mean 						= str2double(s{1}{14});
            satcell.sola_median 						= str2double(s{1}{16});
            satcell.sola_stddev 						= str2double(s{1}{18});
            satcell.sola_rms 						= str2double(s{1}{20});
            satcell.sola_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.sola_filtered_max 				= str2double(s{1}{24});
            satcell.sola_filtered_min 				= str2double(s{1}{26});
            satcell.sola_filtered_mean 				= str2double(s{1}{28});
            satcell.sola_filtered_median 			= str2double(s{1}{30});
            satcell.sola_filtered_stddev 			= str2double(s{1}{32});
            satcell.sola_filtered_rms 				= str2double(s{1}{34});
            satcell.sola_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.sola_iqr_max 					= str2double(s{1}{38});
            satcell.sola_iqr_min 					= str2double(s{1}{40});
            satcell.sola_iqr_mean 					= str2double(s{1}{42});
            satcell.sola_iqr_median 					= str2double(s{1}{44});
            satcell.sola_iqr_stddev 					= str2double(s{1}{46});
            satcell.sola_iqr_rms 					= str2double(s{1}{48});
      end
      
      
      
      % glint_coef
      fullFileName = [filepath '.glint_coef'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.glint_coef_center_value 				= str2double(s{1}{6});
            satcell.glint_coef_valid_pixel_count 			= str2double(s{1}{8});
            satcell.glint_coef_max 						= str2double(s{1}{10});
            satcell.glint_coef_min 						= str2double(s{1}{12});
            satcell.glint_coef_mean 						= str2double(s{1}{14});
            satcell.glint_coef_median 						= str2double(s{1}{16});
            satcell.glint_coef_stddev 						= str2double(s{1}{18});
            satcell.glint_coef_rms 						= str2double(s{1}{20});
            satcell.glint_coef_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.glint_coef_filtered_max 				= str2double(s{1}{24});
            satcell.glint_coef_filtered_min 				= str2double(s{1}{26});
            satcell.glint_coef_filtered_mean 				= str2double(s{1}{28});
            satcell.glint_coef_filtered_median 			= str2double(s{1}{30});
            satcell.glint_coef_filtered_stddev 			= str2double(s{1}{32});
            satcell.glint_coef_filtered_rms 				= str2double(s{1}{34});
            satcell.glint_coef_iqr_valid_pixel_count 		= str2double(s{1}{36});
            satcell.glint_coef_iqr_max 					= str2double(s{1}{38});
            satcell.glint_coef_iqr_min 					= str2double(s{1}{40});
            satcell.glint_coef_iqr_mean 					= str2double(s{1}{42});
            satcell.glint_coef_iqr_median 					= str2double(s{1}{44});
            satcell.glint_coef_iqr_stddev 					= str2double(s{1}{46});
            satcell.glint_coef_iqr_rms 					= str2double(s{1}{48});
      end
      
      % poc
      fullFileName = [filepath '.poc'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.poc_center_value                       = str2double(s{1}{6});
            satcell.poc_valid_pixel_count                  = str2double(s{1}{8});
            satcell.poc_max                                = str2double(s{1}{10});
            satcell.poc_min                                = str2double(s{1}{12});
            satcell.poc_mean                                     = str2double(s{1}{14});
            satcell.poc_median                                   = str2double(s{1}{16});
            satcell.poc_stddev                                   = str2double(s{1}{18});
            satcell.poc_rms                                = str2double(s{1}{20});
            satcell.poc_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.poc_filtered_max                       = str2double(s{1}{24});
            satcell.poc_filtered_min                       = str2double(s{1}{26});
            satcell.poc_filtered_mean                      = str2double(s{1}{28});
            satcell.poc_filtered_median              = str2double(s{1}{30});
            satcell.poc_filtered_stddev              = str2double(s{1}{32});
            satcell.poc_filtered_rms                       = str2double(s{1}{34});
            satcell.poc_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.poc_iqr_max                            = str2double(s{1}{38});
            satcell.poc_iqr_min                            = str2double(s{1}{40});
            satcell.poc_iqr_mean                           = str2double(s{1}{42});
            satcell.poc_iqr_median                               = str2double(s{1}{44});
            satcell.poc_iqr_stddev                               = str2double(s{1}{46});
            satcell.poc_iqr_rms                            = str2double(s{1}{48});
      end
      
      % CV
      if strcmp(sensor_id,'GOCI')
            satcell.median_CV = nanmedian([...
                  satcell.Rrs_412_CV,...
                  satcell.Rrs_443_CV,...
                  satcell.Rrs_490_CV,...
                  satcell.Rrs_555_CV,...
                  satcell.aot_865_CV]);
      elseif strcmp(sensor_id,'AQUA')
            satcell.median_CV = nanmedian([...
                  satcell.Rrs_412_CV,...
                  satcell.Rrs_443_CV,...
                  satcell.Rrs_488_CV,...
                  satcell.Rrs_547_CV,...
                  satcell.aot_869_CV]);
      elseif strcmp(sensor_id,'VIIRS')
            satcell.median_CV = nanmedian([...
                  satcell.Rrs_410_CV,...
                  satcell.Rrs_443_CV,...
                  satcell.Rrs_486_CV,...
                  satcell.Rrs_551_CV,...
                  satcell.aot_862_CV]);
      elseif strcmp(sensor_id,'SEAW')
            satcell.median_CV = nanmedian([...
                  satcell.Rrs_412_CV,...
                  satcell.Rrs_443_CV,...
                  satcell.Rrs_490_CV,...
                  satcell.Rrs_555_CV,...
                  satcell.aot_865_CV]);
      end
      
else
      
      % vgain_412
      fullFileName = [filepath '.vgain_412'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_412_center_value                       = str2double(s{1}{6});
            satcell.vgain_412_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_412_max                                = str2double(s{1}{10});
            satcell.vgain_412_min                                = str2double(s{1}{12});
            satcell.vgain_412_mean                                     = str2double(s{1}{14});
            satcell.vgain_412_median                                   = str2double(s{1}{16});
            satcell.vgain_412_stddev                                   = str2double(s{1}{18});
            satcell.vgain_412_rms                                = str2double(s{1}{20});
            satcell.vgain_412_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_412_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_412_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_412_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_412_filtered_median              = str2double(s{1}{30});
            satcell.vgain_412_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_412_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_412_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_412_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_412_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_412_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_412_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_412_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_412_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_443
      fullFileName = [filepath '.vgain_443'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_443_center_value                       = str2double(s{1}{6});
            satcell.vgain_443_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_443_max                                = str2double(s{1}{10});
            satcell.vgain_443_min                                = str2double(s{1}{12});
            satcell.vgain_443_mean                                     = str2double(s{1}{14});
            satcell.vgain_443_median                                   = str2double(s{1}{16});
            satcell.vgain_443_stddev                                   = str2double(s{1}{18});
            satcell.vgain_443_rms                                = str2double(s{1}{20});
            satcell.vgain_443_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_443_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_443_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_443_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_443_filtered_median              = str2double(s{1}{30});
            satcell.vgain_443_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_443_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_443_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_443_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_443_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_443_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_443_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_443_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_443_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_490
      fullFileName = [filepath '.vgain_490'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_490_center_value                       = str2double(s{1}{6});
            satcell.vgain_490_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_490_max                                = str2double(s{1}{10});
            satcell.vgain_490_min                                = str2double(s{1}{12});
            satcell.vgain_490_mean                                     = str2double(s{1}{14});
            satcell.vgain_490_median                                   = str2double(s{1}{16});
            satcell.vgain_490_stddev                                   = str2double(s{1}{18});
            satcell.vgain_490_rms                                = str2double(s{1}{20});
            satcell.vgain_490_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_490_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_490_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_490_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_490_filtered_median              = str2double(s{1}{30});
            satcell.vgain_490_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_490_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_490_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_490_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_490_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_490_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_490_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_490_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_490_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_555
      fullFileName = [filepath '.vgain_555'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_555_center_value                       = str2double(s{1}{6});
            satcell.vgain_555_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_555_max                                = str2double(s{1}{10});
            satcell.vgain_555_min                                = str2double(s{1}{12});
            satcell.vgain_555_mean                                     = str2double(s{1}{14});
            satcell.vgain_555_median                                   = str2double(s{1}{16});
            satcell.vgain_555_stddev                                   = str2double(s{1}{18});
            satcell.vgain_555_rms                                = str2double(s{1}{20});
            satcell.vgain_555_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_555_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_555_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_555_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_555_filtered_median              = str2double(s{1}{30});
            satcell.vgain_555_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_555_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_555_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_555_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_555_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_555_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_555_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_555_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_555_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_660
      fullFileName = [filepath '.vgain_660'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_660_center_value                       = str2double(s{1}{6});
            satcell.vgain_660_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_660_max                                = str2double(s{1}{10});
            satcell.vgain_660_min                                = str2double(s{1}{12});
            satcell.vgain_660_mean                                     = str2double(s{1}{14});
            satcell.vgain_660_median                                   = str2double(s{1}{16});
            satcell.vgain_660_stddev                                   = str2double(s{1}{18});
            satcell.vgain_660_rms                                = str2double(s{1}{20});
            satcell.vgain_660_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_660_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_660_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_660_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_660_filtered_median              = str2double(s{1}{30});
            satcell.vgain_660_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_660_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_660_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_660_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_660_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_660_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_660_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_660_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_660_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_680
      fullFileName = [filepath '.vgain_680'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_680_center_value                       = str2double(s{1}{6});
            satcell.vgain_680_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_680_max                                = str2double(s{1}{10});
            satcell.vgain_680_min                                = str2double(s{1}{12});
            satcell.vgain_680_mean                                     = str2double(s{1}{14});
            satcell.vgain_680_median                                   = str2double(s{1}{16});
            satcell.vgain_680_stddev                                   = str2double(s{1}{18});
            satcell.vgain_680_rms                                = str2double(s{1}{20});
            satcell.vgain_680_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_680_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_680_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_680_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_680_filtered_median              = str2double(s{1}{30});
            satcell.vgain_680_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_680_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_680_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_680_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_680_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_680_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_680_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_680_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_680_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_745
      fullFileName = [filepath '.vgain_745'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_745_center_value                       = str2double(s{1}{6});
            satcell.vgain_745_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_745_max                                = str2double(s{1}{10});
            satcell.vgain_745_min                                = str2double(s{1}{12});
            satcell.vgain_745_mean                                     = str2double(s{1}{14});
            satcell.vgain_745_median                                   = str2double(s{1}{16});
            satcell.vgain_745_stddev                                   = str2double(s{1}{18});
            satcell.vgain_745_rms                                = str2double(s{1}{20});
            satcell.vgain_745_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_745_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_745_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_745_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_745_filtered_median              = str2double(s{1}{30});
            satcell.vgain_745_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_745_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_745_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_745_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_745_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_745_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_745_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_745_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_745_iqr_rms                            = str2double(s{1}{48});
      end
      
      % vgain_865
      fullFileName = [filepath '.vgain_865'];
      
      if exist(fullFileName, 'file')
            fileID = fopen(fullFileName);
            s = textscan(fileID,'%s','Delimiter','=');
            fclose(fileID);
            satcell.vgain_865_center_value                       = str2double(s{1}{6});
            satcell.vgain_865_valid_pixel_count                  = str2double(s{1}{8});
            satcell.vgain_865_max                                = str2double(s{1}{10});
            satcell.vgain_865_min                                = str2double(s{1}{12});
            satcell.vgain_865_mean                                     = str2double(s{1}{14});
            satcell.vgain_865_median                                   = str2double(s{1}{16});
            satcell.vgain_865_stddev                                   = str2double(s{1}{18});
            satcell.vgain_865_rms                                = str2double(s{1}{20});
            satcell.vgain_865_filtered_valid_pixel_count  = str2double(s{1}{22});
            satcell.vgain_865_filtered_max                       = str2double(s{1}{24});
            satcell.vgain_865_filtered_min                       = str2double(s{1}{26});
            satcell.vgain_865_filtered_mean                      = str2double(s{1}{28});
            satcell.vgain_865_filtered_median              = str2double(s{1}{30});
            satcell.vgain_865_filtered_stddev              = str2double(s{1}{32});
            satcell.vgain_865_filtered_rms                       = str2double(s{1}{34});
            satcell.vgain_865_iqr_valid_pixel_count        = str2double(s{1}{36});
            satcell.vgain_865_iqr_max                            = str2double(s{1}{38});
            satcell.vgain_865_iqr_min                            = str2double(s{1}{40});
            satcell.vgain_865_iqr_mean                           = str2double(s{1}{42});
            satcell.vgain_865_iqr_median                               = str2double(s{1}{44});
            satcell.vgain_865_iqr_stddev                               = str2double(s{1}{46});
            satcell.vgain_865_iqr_rms                            = str2double(s{1}{48});
      end
      
end

% solz
fullFileName = [filepath '.solz'];

if exist(fullFileName, 'file')
      fileID = fopen(fullFileName);
      s = textscan(fileID,'%s','Delimiter','=');
      fclose(fileID);
      satcell.solz_center_value                       = str2double(s{1}{6});
      satcell.solz_valid_pixel_count                  = str2double(s{1}{8});
      satcell.solz_max                                = str2double(s{1}{10});
      satcell.solz_min                                = str2double(s{1}{12});
      satcell.solz_mean                                     = str2double(s{1}{14});
      satcell.solz_median                                   = str2double(s{1}{16});
      satcell.solz_stddev                                   = str2double(s{1}{18});
      satcell.solz_rms                                = str2double(s{1}{20});
      satcell.solz_filtered_valid_pixel_count  = str2double(s{1}{22});
      satcell.solz_filtered_max                       = str2double(s{1}{24});
      satcell.solz_filtered_min                       = str2double(s{1}{26});
      satcell.solz_filtered_mean                      = str2double(s{1}{28});
      satcell.solz_filtered_median              = str2double(s{1}{30});
      satcell.solz_filtered_stddev              = str2double(s{1}{32});
      satcell.solz_filtered_rms                       = str2double(s{1}{34});
      satcell.solz_iqr_valid_pixel_count        = str2double(s{1}{36});
      satcell.solz_iqr_max                            = str2double(s{1}{38});
      satcell.solz_iqr_min                            = str2double(s{1}{40});
      satcell.solz_iqr_mean                           = str2double(s{1}{42});
      satcell.solz_iqr_median                               = str2double(s{1}{44});
      satcell.solz_iqr_stddev                               = str2double(s{1}{46});
      satcell.solz_iqr_rms                            = str2double(s{1}{48});
end

% senz
fullFileName = [filepath '.senz'];

if exist(fullFileName, 'file')
      fileID = fopen(fullFileName);
      s = textscan(fileID,'%s','Delimiter','=');
      fclose(fileID);
      satcell.senz_center_value                       = str2double(s{1}{6});
      satcell.senz_valid_pixel_count                  = str2double(s{1}{8});
      satcell.senz_max                                = str2double(s{1}{10});
      satcell.senz_min                                = str2double(s{1}{12});
      satcell.senz_mean                                     = str2double(s{1}{14});
      satcell.senz_median                                   = str2double(s{1}{16});
      satcell.senz_stddev                                   = str2double(s{1}{18});
      satcell.senz_rms                                = str2double(s{1}{20});
      satcell.senz_filtered_valid_pixel_count  = str2double(s{1}{22});
      satcell.senz_filtered_max                       = str2double(s{1}{24});
      satcell.senz_filtered_min                       = str2double(s{1}{26});
      satcell.senz_filtered_mean                      = str2double(s{1}{28});
      satcell.senz_filtered_median              = str2double(s{1}{30});
      satcell.senz_filtered_stddev              = str2double(s{1}{32});
      satcell.senz_filtered_rms                       = str2double(s{1}{34});
      satcell.senz_iqr_valid_pixel_count        = str2double(s{1}{36});
      satcell.senz_iqr_max                            = str2double(s{1}{38});
      satcell.senz_iqr_min                            = str2double(s{1}{40});
      satcell.senz_iqr_mean                           = str2double(s{1}{42});
      satcell.senz_iqr_median                               = str2double(s{1}{44});
      satcell.senz_iqr_stddev                               = str2double(s{1}{46});
      satcell.senz_iqr_rms                            = str2double(s{1}{48});
end



% % satcell = get_product(filepath,'ozone',satcell);
% satcell = get_product(filepath,'ozone',satcell);

% end
% function satcell = get_product(filepath,str_product,satcell)
% % product
% fullFileName = [filepath '.' str_product];

% if exist(fullFileName, 'file')
%       fileID = fopen(fullFileName);
%       s = textscan(fileID,'%s','Delimiter','=');
%       fclose(fileID);

%       eval(sprintf('satcell.%s_center_value 				=  str2double(s{1}{6});',str_product))
%       eval(sprintf('satcell.%s_valid_pixel_count 			=  str2double(s{1}{8});',str_product))
%       eval(sprintf('satcell.%s_max 							= str2double(s{1}{10});',str_product))
%       eval(sprintf('satcell.%s_min 							= str2double(s{1}{12});',str_product))
%       eval(sprintf('satcell.%s_mean 						= str2double(s{1}{14});',str_product))
%       eval(sprintf('satcell.%s_median 						= str2double(s{1}{16});',str_product))
%       eval(sprintf('satcell.%s_stddev 						= str2double(s{1}{18});',str_product))
%       eval(sprintf('satcell.%s_rms 							= str2double(s{1}{20});',str_product))
%       eval(sprintf('satcell.%s_filtered_valid_pixel_count  	= str2double(s{1}{22});',str_product))
%       eval(sprintf('satcell.%s_filtered_max 				= str2double(s{1}{24});',str_product))
%       eval(sprintf('satcell.%s_filtered_min 				= str2double(s{1}{26});',str_product))
%       eval(sprintf('satcell.%s_filtered_mean 				= str2double(s{1}{28});',str_product))
%       eval(sprintf('satcell.%s_filtered_median 				= str2double(s{1}{30});',str_product))
%       eval(sprintf('satcell.%s_filtered_stddev 				= str2double(s{1}{32});',str_product))
%       eval(sprintf('satcell.%s_filtered_rms 				= str2double(s{1}{34});',str_product))
%       eval(sprintf('satcell.%s_iqr_valid_pixel_count 		= str2double(s{1}{36});',str_product))
%       eval(sprintf('satcell.%s_iqr_max 						= str2double(s{1}{38});',str_product))
%       eval(sprintf('satcell.%s_iqr_min 						= str2double(s{1}{40});',str_product))
%       eval(sprintf('satcell.%s_iqr_mean 					= str2double(s{1}{42});',str_product))
%       eval(sprintf('satcell.%s_iqr_median 					= str2double(s{1}{44});',str_product))
%       eval(sprintf('satcell.%s_iqr_stddev 					= str2double(s{1}{46});',str_product))
%       eval(sprintf('satcell.%s_iqr_rms 						= str2double(s{1}{48});',str_product))
% end
% end

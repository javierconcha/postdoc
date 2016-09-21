function satcell = loadsatcell_tempanly(filepath)
%%

%%
% Parameters
filepathaux = [filepath '.param'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.ifile           = s{1}{2};
satcell.ofile 		= s{1}{4};

%% .output
fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

% time and Solar Azimuthal and Zenith angle
idx1 = find(strncmp(s{1},'time',4));
parval = s{1}{idx1+1};

%% temporal fix for time recording
ifile_char = satcell.ifile;

if strcmp(ifile_char(26:27),'00')
      parval(12:end) = '00:28:46.887';
elseif strcmp(ifile_char(26:27),'01')
      parval(12:end) = '01:28:46.887';
elseif strcmp(ifile_char(26:27),'02')
      parval(12:end) = '02:28:46.887';
elseif strcmp(ifile_char(26:27),'03')
      parval(12:end) = '03:28:46.887';
elseif strcmp(ifile_char(26:27),'04')
      parval(12:end) = '04:28:46.887';
elseif strcmp(ifile_char(26:27),'05')
      parval(12:end) = '05:28:46.887';
elseif strcmp(ifile_char(26:27),'06')
      parval(12:end) = '06:28:46.887';
elseif strcmp(ifile_char(26:27),'07')
      parval(12:end) = '07:28:46.887';
end
    
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

%% Products
% Rrs_412
filepathaux = [filepath '.Rrs_412'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_412_center_value 				= str2double(s{1}{4});
satcell.Rrs_412_valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_412_max 						= str2double(s{1}{8});
satcell.Rrs_412_min 						= str2double(s{1}{10});
satcell.Rrs_412_mean 						= str2double(s{1}{12});
satcell.Rrs_412_median 						= str2double(s{1}{14});
satcell.Rrs_412_stddev 						= str2double(s{1}{16});
satcell.Rrs_412_rms 						= str2double(s{1}{18});
satcell.Rrs_412_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_412_filtered_max 				= str2double(s{1}{22});
satcell.Rrs_412_filtered_min 				= str2double(s{1}{24});
satcell.Rrs_412_filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_412_filtered_median 			= str2double(s{1}{28});
satcell.Rrs_412_filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_412_filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_412_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_412_iqr_max 					= str2double(s{1}{36});
satcell.Rrs_412_iqr_min 					= str2double(s{1}{38});
satcell.Rrs_412_iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_412_iqr_median 					= str2double(s{1}{42});
satcell.Rrs_412_iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_412_iqr_rms 					= str2double(s{1}{46});

% Rrs_443
filepathaux = [filepath '.Rrs_443'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_443_center_value 				= str2double(s{1}{4});
satcell.Rrs_443_valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_443_max 						= str2double(s{1}{8});
satcell.Rrs_443_min 						= str2double(s{1}{10});
satcell.Rrs_443_mean 						= str2double(s{1}{12});
satcell.Rrs_443_median 						= str2double(s{1}{14});
satcell.Rrs_443_stddev 						= str2double(s{1}{16});
satcell.Rrs_443_rms 						= str2double(s{1}{18});
satcell.Rrs_443_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_443_filtered_max 				= str2double(s{1}{22});
satcell.Rrs_443_filtered_min 				= str2double(s{1}{24});
satcell.Rrs_443_filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_443_filtered_median 			= str2double(s{1}{28});
satcell.Rrs_443_filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_443_filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_443_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_443_iqr_max 					= str2double(s{1}{36});
satcell.Rrs_443_iqr_min 					= str2double(s{1}{38});
satcell.Rrs_443_iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_443_iqr_median 					= str2double(s{1}{42});
satcell.Rrs_443_iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_443_iqr_rms 					= str2double(s{1}{46});

% Rrs_490
filepathaux = [filepath '.Rrs_490'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_490_center_value 				= str2double(s{1}{4});
satcell.Rrs_490_valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_490_max 						= str2double(s{1}{8});
satcell.Rrs_490_min 						= str2double(s{1}{10});
satcell.Rrs_490_mean 						= str2double(s{1}{12});
satcell.Rrs_490_median 						= str2double(s{1}{14});
satcell.Rrs_490_stddev 						= str2double(s{1}{16});
satcell.Rrs_490_rms 						= str2double(s{1}{18});
satcell.Rrs_490_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_490_filtered_max 				= str2double(s{1}{22});
satcell.Rrs_490_filtered_min 				= str2double(s{1}{24});
satcell.Rrs_490_filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_490_filtered_median 			= str2double(s{1}{28});
satcell.Rrs_490_filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_490_filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_490_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_490_iqr_max 					= str2double(s{1}{36});
satcell.Rrs_490_iqr_min 					= str2double(s{1}{38});
satcell.Rrs_490_iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_490_iqr_median 					= str2double(s{1}{42});
satcell.Rrs_490_iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_490_iqr_rms 					= str2double(s{1}{46});

% Rrs_555
filepathaux = [filepath '.Rrs_555'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_555_center_value 				= str2double(s{1}{4});
satcell.Rrs_555_valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_555_max 						= str2double(s{1}{8});
satcell.Rrs_555_min 						= str2double(s{1}{10});
satcell.Rrs_555_mean 						= str2double(s{1}{12});
satcell.Rrs_555_median 						= str2double(s{1}{14});
satcell.Rrs_555_stddev 						= str2double(s{1}{16});
satcell.Rrs_555_rms 						= str2double(s{1}{18});
satcell.Rrs_555_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_555_filtered_max 				= str2double(s{1}{22});
satcell.Rrs_555_filtered_min 				= str2double(s{1}{24});
satcell.Rrs_555_filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_555_filtered_median 			= str2double(s{1}{28});
satcell.Rrs_555_filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_555_filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_555_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_555_iqr_max 					= str2double(s{1}{36});
satcell.Rrs_555_iqr_min 					= str2double(s{1}{38});
satcell.Rrs_555_iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_555_iqr_median 					= str2double(s{1}{42});
satcell.Rrs_555_iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_555_iqr_rms 					= str2double(s{1}{46});

% Rrs_660
filepathaux = [filepath '.Rrs_660'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_660_center_value 				= str2double(s{1}{4});
satcell.Rrs_660_valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_660_max 						= str2double(s{1}{8});
satcell.Rrs_660_min 						= str2double(s{1}{10});
satcell.Rrs_660_mean 						= str2double(s{1}{12});
satcell.Rrs_660_median 						= str2double(s{1}{14});
satcell.Rrs_660_stddev 						= str2double(s{1}{16});
satcell.Rrs_660_rms 						= str2double(s{1}{18});
satcell.Rrs_660_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_660_filtered_max 				= str2double(s{1}{22});
satcell.Rrs_660_filtered_min 				= str2double(s{1}{24});
satcell.Rrs_660_filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_660_filtered_median 			= str2double(s{1}{28});
satcell.Rrs_660_filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_660_filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_660_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_660_iqr_max 					= str2double(s{1}{36});
satcell.Rrs_660_iqr_min 					= str2double(s{1}{38});
satcell.Rrs_660_iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_660_iqr_median 					= str2double(s{1}{42});
satcell.Rrs_660_iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_660_iqr_rms 					= str2double(s{1}{46});

% Rrs_680
filepathaux = [filepath '.Rrs_680'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_680_center_value 				= str2double(s{1}{4});
satcell.Rrs_680_valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_680_max 						= str2double(s{1}{8});
satcell.Rrs_680_min 						= str2double(s{1}{10});
satcell.Rrs_680_mean 						= str2double(s{1}{12});
satcell.Rrs_680_median 						= str2double(s{1}{14});
satcell.Rrs_680_stddev 						= str2double(s{1}{16});
satcell.Rrs_680_rms 						= str2double(s{1}{18});
satcell.Rrs_680_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_680_filtered_max 				= str2double(s{1}{22});
satcell.Rrs_680_filtered_min 				= str2double(s{1}{24});
satcell.Rrs_680_filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_680_filtered_median 			= str2double(s{1}{28});
satcell.Rrs_680_filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_680_filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_680_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_680_iqr_max 					= str2double(s{1}{36});
satcell.Rrs_680_iqr_min 					= str2double(s{1}{38});
satcell.Rrs_680_iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_680_iqr_median 					= str2double(s{1}{42});
satcell.Rrs_680_iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_680_iqr_rms 					= str2double(s{1}{46});

% % ag_412_mlrc
% filepathaux = [filepath '.ag_412_mlrc'];
% 
% fileID = fopen(filepathaux);
% s = textscan(fileID,'%s','Delimiter','=');
% fclose(fileID);
% 
% satcell.ag_412_mlrc_center_value 				= str2double(s{1}{4});
% satcell.ag_412_mlrc_valid_pixel_count 			= str2double(s{1}{6});
% satcell.ag_412_mlrc_max 						= str2double(s{1}{8});
% satcell.ag_412_mlrc_min 						= str2double(s{1}{10});
% satcell.ag_412_mlrc_mean 						= str2double(s{1}{12});
% satcell.ag_412_mlrc_median 						= str2double(s{1}{14});
% satcell.ag_412_mlrc_stddev 						= str2double(s{1}{16});
% satcell.ag_412_mlrc_rms 						= str2double(s{1}{18});
% satcell.ag_412_mlrc_filtered_valid_pixel_count 	= str2double(s{1}{20});
% satcell.ag_412_mlrc_filtered_max 				= str2double(s{1}{22});
% satcell.ag_412_mlrc_filtered_min 				= str2double(s{1}{24});
% satcell.ag_412_mlrc_filtered_mean 				= str2double(s{1}{26});
% satcell.ag_412_mlrc_filtered_median 			= str2double(s{1}{28});
% satcell.ag_412_mlrc_filtered_stddev 			= str2double(s{1}{30});
% satcell.ag_412_mlrc_filtered_rms 				= str2double(s{1}{32});
% satcell.ag_412_mlrc_iqr_valid_pixel_count 		= str2double(s{1}{34});
% satcell.ag_412_mlrc_iqr_max 					= str2double(s{1}{36});
% satcell.ag_412_mlrc_iqr_min 					= str2double(s{1}{38});
% satcell.ag_412_mlrc_iqr_mean 					= str2double(s{1}{40});
% satcell.ag_412_mlrc_iqr_median 					= str2double(s{1}{42});
% satcell.ag_412_mlrc_iqr_stddev 					= str2double(s{1}{44});
% satcell.ag_412_mlrc_iqr_rms 					= str2double(s{1}{46});

% angstrom
filepathaux = [filepath '.angstrom'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.angstrom_center_value 				= str2double(s{1}{4});
satcell.angstrom_valid_pixel_count 			= str2double(s{1}{6});
satcell.angstrom_max 						= str2double(s{1}{8});
satcell.angstrom_min 						= str2double(s{1}{10});
satcell.angstrom_mean 						= str2double(s{1}{12});
satcell.angstrom_median 					= str2double(s{1}{14});
satcell.angstrom_stddev 					= str2double(s{1}{16});
satcell.angstrom_rms 						= str2double(s{1}{18});
satcell.angstrom_filtered_valid_pixel_count = str2double(s{1}{20});
satcell.angstrom_filtered_max 				= str2double(s{1}{22});
satcell.angstrom_filtered_min 				= str2double(s{1}{24});
satcell.angstrom_filtered_mean 				= str2double(s{1}{26});
satcell.angstrom_filtered_median 			= str2double(s{1}{28});
satcell.angstrom_filtered_stddev 			= str2double(s{1}{30});
satcell.angstrom_filtered_rms 				= str2double(s{1}{32});
satcell.angstrom_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.angstrom_iqr_max 					= str2double(s{1}{36});
satcell.angstrom_iqr_min 					= str2double(s{1}{38});
satcell.angstrom_iqr_mean 					= str2double(s{1}{40});
satcell.angstrom_iqr_median 				= str2double(s{1}{42});
satcell.angstrom_iqr_stddev 				= str2double(s{1}{44});
satcell.angstrom_iqr_rms 					= str2double(s{1}{46});

% aot_865
filepathaux = [filepath '.aot_865'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.aot_865_center_value 				= str2double(s{1}{4});
satcell.aot_865_valid_pixel_count 			= str2double(s{1}{6});
satcell.aot_865_max 						= str2double(s{1}{8});
satcell.aot_865_min 						= str2double(s{1}{10});
satcell.aot_865_mean 						= str2double(s{1}{12});
satcell.aot_865_median 						= str2double(s{1}{14});
satcell.aot_865_stddev 						= str2double(s{1}{16});
satcell.aot_865_rms 						= str2double(s{1}{18});
satcell.aot_865_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.aot_865_filtered_max 				= str2double(s{1}{22});
satcell.aot_865_filtered_min 				= str2double(s{1}{24});
satcell.aot_865_filtered_mean 				= str2double(s{1}{26});
satcell.aot_865_filtered_median 			= str2double(s{1}{28});
satcell.aot_865_filtered_stddev 			= str2double(s{1}{30});
satcell.aot_865_filtered_rms 				= str2double(s{1}{32});
satcell.aot_865_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.aot_865_iqr_max 					= str2double(s{1}{36});
satcell.aot_865_iqr_min 					= str2double(s{1}{38});
satcell.aot_865_iqr_mean 					= str2double(s{1}{40});
satcell.aot_865_iqr_median 					= str2double(s{1}{42});
satcell.aot_865_iqr_stddev 					= str2double(s{1}{44});
satcell.aot_865_iqr_rms 					= str2double(s{1}{46});

% chl_ocx
filepathaux = [filepath '.chl_ocx'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.chl_ocx_center_value 				= str2double(s{1}{4});
satcell.chl_ocx_valid_pixel_count 			= str2double(s{1}{6});
satcell.chl_ocx_max 						= str2double(s{1}{8});
satcell.chl_ocx_min 						= str2double(s{1}{10});
satcell.chl_ocx_mean 						= str2double(s{1}{12});
satcell.chl_ocx_median 						= str2double(s{1}{14});
satcell.chl_ocx_stddev 						= str2double(s{1}{16});
satcell.chl_ocx_rms 						= str2double(s{1}{18});
satcell.chl_ocx_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.chl_ocx_filtered_max 				= str2double(s{1}{22});
satcell.chl_ocx_filtered_min 				= str2double(s{1}{24});
satcell.chl_ocx_filtered_mean 				= str2double(s{1}{26});
satcell.chl_ocx_filtered_median 			= str2double(s{1}{28});
satcell.chl_ocx_filtered_stddev 			= str2double(s{1}{30});
satcell.chl_ocx_filtered_rms 				= str2double(s{1}{32});
satcell.chl_ocx_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.chl_ocx_iqr_max 					= str2double(s{1}{36});
satcell.chl_ocx_iqr_min 					= str2double(s{1}{38});
satcell.chl_ocx_iqr_mean 					= str2double(s{1}{40});
satcell.chl_ocx_iqr_median 					= str2double(s{1}{42});
satcell.chl_ocx_iqr_stddev 					= str2double(s{1}{44});
satcell.chl_ocx_iqr_rms 					= str2double(s{1}{46});

% chlor_a
filepathaux = [filepath '.chlor_a'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.chlor_a_center_value 				= str2double(s{1}{4});
satcell.chlor_a_valid_pixel_count 			= str2double(s{1}{6});
satcell.chlor_a_max 						= str2double(s{1}{8});
satcell.chlor_a_min 						= str2double(s{1}{10});
satcell.chlor_a_mean 						= str2double(s{1}{12});
satcell.chlor_a_median 						= str2double(s{1}{14});
satcell.chlor_a_stddev 						= str2double(s{1}{16});
satcell.chlor_a_rms 						= str2double(s{1}{18});
satcell.chlor_a_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.chlor_a_filtered_max 				= str2double(s{1}{22});
satcell.chlor_a_filtered_min 				= str2double(s{1}{24});
satcell.chlor_a_filtered_mean 				= str2double(s{1}{26});
satcell.chlor_a_filtered_median 			= str2double(s{1}{28});
satcell.chlor_a_filtered_stddev 			= str2double(s{1}{30});
satcell.chlor_a_filtered_rms 				= str2double(s{1}{32});
satcell.chlor_a_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.chlor_a_iqr_max 					= str2double(s{1}{36});
satcell.chlor_a_iqr_min 					= str2double(s{1}{38});
satcell.chlor_a_iqr_mean 					= str2double(s{1}{40});
satcell.chlor_a_iqr_median 					= str2double(s{1}{42});
satcell.chlor_a_iqr_stddev 					= str2double(s{1}{44});
satcell.chlor_a_iqr_rms 					= str2double(s{1}{46});

% kd_490
filepathaux = [filepath '.kd_490'];

fileID = fopen(filepathaux);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.kd_490_center_value 				= str2double(s{1}{4});
satcell.kd_490_valid_pixel_count 			= str2double(s{1}{6});
satcell.kd_490_max 						    = str2double(s{1}{8});
satcell.kd_490_min 						    = str2double(s{1}{10});
satcell.kd_490_mean 						= str2double(s{1}{12});
satcell.kd_490_median 						= str2double(s{1}{14});
satcell.kd_490_stddev 						= str2double(s{1}{16});
satcell.kd_490_rms 							= str2double(s{1}{18});
satcell.kd_490_filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.kd_490_filtered_max 				= str2double(s{1}{22});
satcell.kd_490_filtered_min 				= str2double(s{1}{24});
satcell.kd_490_filtered_mean 				= str2double(s{1}{26});
satcell.kd_490_filtered_median 				= str2double(s{1}{28});
satcell.kd_490_filtered_stddev 				= str2double(s{1}{30});
satcell.kd_490_filtered_rms 				= str2double(s{1}{32});
satcell.kd_490_iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.kd_490_iqr_max 						= str2double(s{1}{36});
satcell.kd_490_iqr_min 						= str2double(s{1}{38});
satcell.kd_490_iqr_mean 					= str2double(s{1}{40});
satcell.kd_490_iqr_median 					= str2double(s{1}{42});
satcell.kd_490_iqr_stddev 					= str2double(s{1}{44});
satcell.kd_490_iqr_rms 						= str2double(s{1}{46});
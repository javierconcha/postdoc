% function satcell = loadsatcell(filepath)
%%
foldername = './GOCI_AERONET/';
basename = '20141130/COMS_GOCI_L1B_GA_20141130071642.he5_L2n2_val.o';

filepath = [foldername basename];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

% time
idx1 = find(strncmp(s{1},'time',4));
parval = s{1}{idx1+1};
taux = datetime(parval,'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
satcell.datetime = taux;

% center_lat
idx1 = find(strncmp(s{1},'center_lat',10));
satcell.center_lat = str2double(s{1}{idx1+1});

% center_lon
idx1 = find(strncmp(s{1},'center_lon',10));
satcell.center_lon = str2double(s{1}{idx1+1});

% unflagged_pixel_count
idx1 = find(strncmp(s{1},'unflagged',9));
satcell.unflagged_pixel_count =  str2double(s{1}{idx1+1});

% flagged_pixel_count
idx1 = find(strncmp(s{1},'flagged',7));
satcell.flagged_pixel_count =  str2double(s{1}{idx1+1});


% Rrs_412
filepath = [foldername basename '.Rrs_412'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_412.center_value 				= str2double(s{1}{4});
satcell.Rrs_412.valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_412.max 						= str2double(s{1}{8});
satcell.Rrs_412.min 						= str2double(s{1}{10});
satcell.Rrs_412.mean 						= str2double(s{1}{12});
satcell.Rrs_412.median 						= str2double(s{1}{14});
satcell.Rrs_412.stddev 						= str2double(s{1}{16});
satcell.Rrs_412.rms 						= str2double(s{1}{18});
satcell.Rrs_412.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_412.filtered_max 				= str2double(s{1}{22});
satcell.Rrs_412.filtered_min 				= str2double(s{1}{24});
satcell.Rrs_412.filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_412.filtered_median 			= str2double(s{1}{28});
satcell.Rrs_412.filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_412.filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_412.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_412.iqr_max 					= str2double(s{1}{36});
satcell.Rrs_412.iqr_min 					= str2double(s{1}{38});
satcell.Rrs_412.iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_412.iqr_median 					= str2double(s{1}{42});
satcell.Rrs_412.iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_412.iqr_rms 					= str2double(s{1}{46});

% Rrs_443
filepath = [foldername basename '.Rrs_443'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_443.center_value 				= str2double(s{1}{4});
satcell.Rrs_443.valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_443.max 						= str2double(s{1}{8});
satcell.Rrs_443.min 						= str2double(s{1}{10});
satcell.Rrs_443.mean 						= str2double(s{1}{12});
satcell.Rrs_443.median 						= str2double(s{1}{14});
satcell.Rrs_443.stddev 						= str2double(s{1}{16});
satcell.Rrs_443.rms 						= str2double(s{1}{18});
satcell.Rrs_443.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_443.filtered_max 				= str2double(s{1}{22});
satcell.Rrs_443.filtered_min 				= str2double(s{1}{24});
satcell.Rrs_443.filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_443.filtered_median 			= str2double(s{1}{28});
satcell.Rrs_443.filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_443.filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_443.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_443.iqr_max 					= str2double(s{1}{36});
satcell.Rrs_443.iqr_min 					= str2double(s{1}{38});
satcell.Rrs_443.iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_443.iqr_median 					= str2double(s{1}{42});
satcell.Rrs_443.iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_443.iqr_rms 					= str2double(s{1}{46});

% Rrs_490
filepath = [foldername basename '.Rrs_490'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_490.center_value 				= str2double(s{1}{4});
satcell.Rrs_490.valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_490.max 						= str2double(s{1}{8});
satcell.Rrs_490.min 						= str2double(s{1}{10});
satcell.Rrs_490.mean 						= str2double(s{1}{12});
satcell.Rrs_490.median 						= str2double(s{1}{14});
satcell.Rrs_490.stddev 						= str2double(s{1}{16});
satcell.Rrs_490.rms 						= str2double(s{1}{18});
satcell.Rrs_490.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_490.filtered_max 				= str2double(s{1}{22});
satcell.Rrs_490.filtered_min 				= str2double(s{1}{24});
satcell.Rrs_490.filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_490.filtered_median 			= str2double(s{1}{28});
satcell.Rrs_490.filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_490.filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_490.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_490.iqr_max 					= str2double(s{1}{36});
satcell.Rrs_490.iqr_min 					= str2double(s{1}{38});
satcell.Rrs_490.iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_490.iqr_median 					= str2double(s{1}{42});
satcell.Rrs_490.iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_490.iqr_rms 					= str2double(s{1}{46});

% Rrs_555
filepath = [foldername basename '.Rrs_555'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_555.center_value 				= str2double(s{1}{4});
satcell.Rrs_555.valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_555.max 						= str2double(s{1}{8});
satcell.Rrs_555.min 						= str2double(s{1}{10});
satcell.Rrs_555.mean 						= str2double(s{1}{12});
satcell.Rrs_555.median 						= str2double(s{1}{14});
satcell.Rrs_555.stddev 						= str2double(s{1}{16});
satcell.Rrs_555.rms 						= str2double(s{1}{18});
satcell.Rrs_555.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_555.filtered_max 				= str2double(s{1}{22});
satcell.Rrs_555.filtered_min 				= str2double(s{1}{24});
satcell.Rrs_555.filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_555.filtered_median 			= str2double(s{1}{28});
satcell.Rrs_555.filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_555.filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_555.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_555.iqr_max 					= str2double(s{1}{36});
satcell.Rrs_555.iqr_min 					= str2double(s{1}{38});
satcell.Rrs_555.iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_555.iqr_median 					= str2double(s{1}{42});
satcell.Rrs_555.iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_555.iqr_rms 					= str2double(s{1}{46});

% Rrs_660
filepath = [foldername basename '.Rrs_660'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_660.center_value 				= str2double(s{1}{4});
satcell.Rrs_660.valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_660.max 						= str2double(s{1}{8});
satcell.Rrs_660.min 						= str2double(s{1}{10});
satcell.Rrs_660.mean 						= str2double(s{1}{12});
satcell.Rrs_660.median 						= str2double(s{1}{14});
satcell.Rrs_660.stddev 						= str2double(s{1}{16});
satcell.Rrs_660.rms 						= str2double(s{1}{18});
satcell.Rrs_660.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_660.filtered_max 				= str2double(s{1}{22});
satcell.Rrs_660.filtered_min 				= str2double(s{1}{24});
satcell.Rrs_660.filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_660.filtered_median 			= str2double(s{1}{28});
satcell.Rrs_660.filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_660.filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_660.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_660.iqr_max 					= str2double(s{1}{36});
satcell.Rrs_660.iqr_min 					= str2double(s{1}{38});
satcell.Rrs_660.iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_660.iqr_median 					= str2double(s{1}{42});
satcell.Rrs_660.iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_660.iqr_rms 					= str2double(s{1}{46});

% Rrs_680
filepath = [foldername basename '.Rrs_680'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.Rrs_680.center_value 				= str2double(s{1}{4});
satcell.Rrs_680.valid_pixel_count 			= str2double(s{1}{6});
satcell.Rrs_680.max 						= str2double(s{1}{8});
satcell.Rrs_680.min 						= str2double(s{1}{10});
satcell.Rrs_680.mean 						= str2double(s{1}{12});
satcell.Rrs_680.median 						= str2double(s{1}{14});
satcell.Rrs_680.stddev 						= str2double(s{1}{16});
satcell.Rrs_680.rms 						= str2double(s{1}{18});
satcell.Rrs_680.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.Rrs_680.filtered_max 				= str2double(s{1}{22});
satcell.Rrs_680.filtered_min 				= str2double(s{1}{24});
satcell.Rrs_680.filtered_mean 				= str2double(s{1}{26});
satcell.Rrs_680.filtered_median 			= str2double(s{1}{28});
satcell.Rrs_680.filtered_stddev 			= str2double(s{1}{30});
satcell.Rrs_680.filtered_rms 				= str2double(s{1}{32});
satcell.Rrs_680.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.Rrs_680.iqr_max 					= str2double(s{1}{36});
satcell.Rrs_680.iqr_min 					= str2double(s{1}{38});
satcell.Rrs_680.iqr_mean 					= str2double(s{1}{40});
satcell.Rrs_680.iqr_median 					= str2double(s{1}{42});
satcell.Rrs_680.iqr_stddev 					= str2double(s{1}{44});
satcell.Rrs_680.iqr_rms 					= str2double(s{1}{46});

% ag_412_mlrc
filepath = [foldername basename '.ag_412_mlrc'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.ag_412_mlrc.center_value 				= str2double(s{1}{4});
satcell.ag_412_mlrc.valid_pixel_count 			= str2double(s{1}{6});
satcell.ag_412_mlrc.max 						= str2double(s{1}{8});
satcell.ag_412_mlrc.min 						= str2double(s{1}{10});
satcell.ag_412_mlrc.mean 						= str2double(s{1}{12});
satcell.ag_412_mlrc.median 						= str2double(s{1}{14});
satcell.ag_412_mlrc.stddev 						= str2double(s{1}{16});
satcell.ag_412_mlrc.rms 						= str2double(s{1}{18});
satcell.ag_412_mlrc.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.ag_412_mlrc.filtered_max 				= str2double(s{1}{22});
satcell.ag_412_mlrc.filtered_min 				= str2double(s{1}{24});
satcell.ag_412_mlrc.filtered_mean 				= str2double(s{1}{26});
satcell.ag_412_mlrc.filtered_median 			= str2double(s{1}{28});
satcell.ag_412_mlrc.filtered_stddev 			= str2double(s{1}{30});
satcell.ag_412_mlrc.filtered_rms 				= str2double(s{1}{32});
satcell.ag_412_mlrc.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.ag_412_mlrc.iqr_max 					= str2double(s{1}{36});
satcell.ag_412_mlrc.iqr_min 					= str2double(s{1}{38});
satcell.ag_412_mlrc.iqr_mean 					= str2double(s{1}{40});
satcell.ag_412_mlrc.iqr_median 					= str2double(s{1}{42});
satcell.ag_412_mlrc.iqr_stddev 					= str2double(s{1}{44});
satcell.ag_412_mlrc.iqr_rms 					= str2double(s{1}{46});

% angstrom
filepath = [foldername basename '.angstrom'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.angstrom.center_value 				= str2double(s{1}{4});
satcell.angstrom.valid_pixel_count 			= str2double(s{1}{6});
satcell.angstrom.max 						= str2double(s{1}{8});
satcell.angstrom.min 						= str2double(s{1}{10});
satcell.angstrom.mean 						= str2double(s{1}{12});
satcell.angstrom.median 						= str2double(s{1}{14});
satcell.angstrom.stddev 						= str2double(s{1}{16});
satcell.angstrom.rms 						= str2double(s{1}{18});
satcell.angstrom.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.angstrom.filtered_max 				= str2double(s{1}{22});
satcell.angstrom.filtered_min 				= str2double(s{1}{24});
satcell.angstrom.filtered_mean 				= str2double(s{1}{26});
satcell.angstrom.filtered_median 			= str2double(s{1}{28});
satcell.angstrom.filtered_stddev 			= str2double(s{1}{30});
satcell.angstrom.filtered_rms 				= str2double(s{1}{32});
satcell.angstrom.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.angstrom.iqr_max 					= str2double(s{1}{36});
satcell.angstrom.iqr_min 					= str2double(s{1}{38});
satcell.angstrom.iqr_mean 					= str2double(s{1}{40});
satcell.angstrom.iqr_median 					= str2double(s{1}{42});
satcell.angstrom.iqr_stddev 					= str2double(s{1}{44});
satcell.angstrom.iqr_rms 					= str2double(s{1}{46});

% aot_865
filepath = [foldername basename '.aot_865'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.aot_865.center_value 				= str2double(s{1}{4});
satcell.aot_865.valid_pixel_count 			= str2double(s{1}{6});
satcell.aot_865.max 						= str2double(s{1}{8});
satcell.aot_865.min 						= str2double(s{1}{10});
satcell.aot_865.mean 						= str2double(s{1}{12});
satcell.aot_865.median 						= str2double(s{1}{14});
satcell.aot_865.stddev 						= str2double(s{1}{16});
satcell.aot_865.rms 						= str2double(s{1}{18});
satcell.aot_865.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.aot_865.filtered_max 				= str2double(s{1}{22});
satcell.aot_865.filtered_min 				= str2double(s{1}{24});
satcell.aot_865.filtered_mean 				= str2double(s{1}{26});
satcell.aot_865.filtered_median 			= str2double(s{1}{28});
satcell.aot_865.filtered_stddev 			= str2double(s{1}{30});
satcell.aot_865.filtered_rms 				= str2double(s{1}{32});
satcell.aot_865.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.aot_865.iqr_max 					= str2double(s{1}{36});
satcell.aot_865.iqr_min 					= str2double(s{1}{38});
satcell.aot_865.iqr_mean 					= str2double(s{1}{40});
satcell.aot_865.iqr_median 					= str2double(s{1}{42});
satcell.aot_865.iqr_stddev 					= str2double(s{1}{44});
satcell.aot_865.iqr_rms 					= str2double(s{1}{46});

% chl_ocx
filepath = [foldername basename '.chl_ocx'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.chl_ocx.center_value 				= str2double(s{1}{4});
satcell.chl_ocx.valid_pixel_count 			= str2double(s{1}{6});
satcell.chl_ocx.max 						= str2double(s{1}{8});
satcell.chl_ocx.min 						= str2double(s{1}{10});
satcell.chl_ocx.mean 						= str2double(s{1}{12});
satcell.chl_ocx.median 						= str2double(s{1}{14});
satcell.chl_ocx.stddev 						= str2double(s{1}{16});
satcell.chl_ocx.rms 						= str2double(s{1}{18});
satcell.chl_ocx.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.chl_ocx.filtered_max 				= str2double(s{1}{22});
satcell.chl_ocx.filtered_min 				= str2double(s{1}{24});
satcell.chl_ocx.filtered_mean 				= str2double(s{1}{26});
satcell.chl_ocx.filtered_median 			= str2double(s{1}{28});
satcell.chl_ocx.filtered_stddev 			= str2double(s{1}{30});
satcell.chl_ocx.filtered_rms 				= str2double(s{1}{32});
satcell.chl_ocx.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.chl_ocx.iqr_max 					= str2double(s{1}{36});
satcell.chl_ocx.iqr_min 					= str2double(s{1}{38});
satcell.chl_ocx.iqr_mean 					= str2double(s{1}{40});
satcell.chl_ocx.iqr_median 					= str2double(s{1}{42});
satcell.chl_ocx.iqr_stddev 					= str2double(s{1}{44});
satcell.chl_ocx.iqr_rms 					= str2double(s{1}{46});

% chlor_a
filepath = [foldername basename '.chlor_a'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.chlor_a.center_value 				= str2double(s{1}{4});
satcell.chlor_a.valid_pixel_count 			= str2double(s{1}{6});
satcell.chlor_a.max 						= str2double(s{1}{8});
satcell.chlor_a.min 						= str2double(s{1}{10});
satcell.chlor_a.mean 						= str2double(s{1}{12});
satcell.chlor_a.median 						= str2double(s{1}{14});
satcell.chlor_a.stddev 						= str2double(s{1}{16});
satcell.chlor_a.rms 						= str2double(s{1}{18});
satcell.chlor_a.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.chlor_a.filtered_max 				= str2double(s{1}{22});
satcell.chlor_a.filtered_min 				= str2double(s{1}{24});
satcell.chlor_a.filtered_mean 				= str2double(s{1}{26});
satcell.chlor_a.filtered_median 			= str2double(s{1}{28});
satcell.chlor_a.filtered_stddev 			= str2double(s{1}{30});
satcell.chlor_a.filtered_rms 				= str2double(s{1}{32});
satcell.chlor_a.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.chlor_a.iqr_max 					= str2double(s{1}{36});
satcell.chlor_a.iqr_min 					= str2double(s{1}{38});
satcell.chlor_a.iqr_mean 					= str2double(s{1}{40});
satcell.chlor_a.iqr_median 					= str2double(s{1}{42});
satcell.chlor_a.iqr_stddev 					= str2double(s{1}{44});
satcell.chlor_a.iqr_rms 					= str2double(s{1}{46});

% kd_490
filepath = [foldername basename '.kd_490'];

fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);

satcell.kd_490.center_value 				= str2double(s{1}{4});
satcell.kd_490.valid_pixel_count 			= str2double(s{1}{6});
satcell.kd_490.max 						= str2double(s{1}{8});
satcell.kd_490.min 						= str2double(s{1}{10});
satcell.kd_490.mean 						= str2double(s{1}{12});
satcell.kd_490.median 						= str2double(s{1}{14});
satcell.kd_490.stddev 						= str2double(s{1}{16});
satcell.kd_490.rms 						= str2double(s{1}{18});
satcell.kd_490.filtered_valid_pixel_count 	= str2double(s{1}{20});
satcell.kd_490.filtered_max 				= str2double(s{1}{22});
satcell.kd_490.filtered_min 				= str2double(s{1}{24});
satcell.kd_490.filtered_mean 				= str2double(s{1}{26});
satcell.kd_490.filtered_median 			= str2double(s{1}{28});
satcell.kd_490.filtered_stddev 			= str2double(s{1}{30});
satcell.kd_490.filtered_rms 				= str2double(s{1}{32});
satcell.kd_490.iqr_valid_pixel_count 		= str2double(s{1}{34});
satcell.kd_490.iqr_max 					= str2double(s{1}{36});
satcell.kd_490.iqr_min 					= str2double(s{1}{38});
satcell.kd_490.iqr_mean 					= str2double(s{1}{40});
satcell.kd_490.iqr_median 					= str2double(s{1}{42});
satcell.kd_490.iqr_stddev 					= str2double(s{1}{44});
satcell.kd_490.iqr_rms 					= str2double(s{1}{46});
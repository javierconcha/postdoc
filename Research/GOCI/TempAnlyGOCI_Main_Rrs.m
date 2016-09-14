%% Load sat data
clear SatData
fileID = fopen('./GOCI_TemporalAnly/GOCI_ROI_STATS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

%%

for idx0=1:size(s{1},1)
      
      filepath = ['./GOCI_TemporalAnly/GOCI_ROI_STATS/' s{1}{idx0}];
      SatData(idx0) = loadsatcell(filepath);
      
end
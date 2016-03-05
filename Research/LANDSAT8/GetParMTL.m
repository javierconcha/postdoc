function parval=GetParMTL(filepath,parname)
% function to find parameter in the MTL file
% by Javier A. Concha
% 2016-01-21
%% Open file
fileID = fopen(filepath);
s = textscan(fileID,'%s','Delimiter','=');
fclose(fileID);
%% Find parameter value
idx1 = find(strcmp(s{1},[parname ' ']), 1, 'first');

if strcmp(parname,'DATE_ACQUIRED') || strcmp(parname,'SCENE_CENTER_TIME') % When is DATE_ACQUIRED or SCENE_CENTER_TIME not convert to number
    parval = s{1}{idx1+1};
else
    parval = str2double(s{1}{idx1+1});
end
addpath('~/Documents/Research/LANDSAT8/'); % path to the *.m files
addpath('~/Documents/MATLAB/landsat/');
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/Images';

%% Open file with the list of images names
fileID = fopen('./L8_Artic_List.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);


%% Create main figure
figure('Color','white')
ax = worldmap([52 75],[-180 -120]);
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
hold on

for idx=1:size(s{:},1)
    filename = s{1}{idx}; % search on the list of filenames
    filepath = [dirname '/' filename '/' filename '_MTL.txt'];
    LandsatProj(filepath)
    
end




addpath('/Users/jconchas/Documents/Research/')
%% Extract Tara data from SeaBASS file
% dirname = '/Users/jconchas/Documents/Research/Arctic_Data/SeaBASS_ArcticL8/MAINE/boss/Tara_Oceans_Polar_Circle/Pevek_Tuktoyaktuk/archive/';
dirname = '/Users/jconchas/Documents/Research/Arctic_Data/';

% Open file with the list of images names
% fileID = fopen([dirname 'file_list.txt']);
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

for idx=1:size(s{:},1)
      filename = s{1}{idx}; % search on the list of filenames
      % filename = 'Tara_ACS_apcp2013_254ag.sb';
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath);
      
      date_acquired = data{:,1};
      
      time_acquired = datestr(data{:,2},'HH:MM:SS');
      lat = [data{3}];
      lon = [data{4}];
      ag = [data{7:81}];
%       ag_sd = [data{88:168}];
      
%       wavelength = [400.1,404.3,408.5,412.8,417.3,422.1,426.9,431.7,436.3,440.7,445.6,450.9,456,460.6,465.5,470.6,476.1,481.1,486.4,490.9,495.8,500.7,505.7,511.1,516.3,521.5,526.8,531.5,536.1,541.1,546.1,551,556,561.1,566.1,570.7,575.2,579.7,583.7,588.3,592.3,596.7,601.1,606,610.7,615.3,620,624.5,629,633.4,638,642.5,647.3,651.7,656.5,661.3,665.9,670.3,674.7,679.1,683.2,687.2,691.1,695.2,698.9,702.8,706.3,710.2,713.6,717.2,720.8,724.1,727.8,730.8,734,737.2,740.3,742.7,745.7,748.4,750];
      wavelength = [400,402,406,408,410,412,414,416,418,420,422,424,426,428,430,432,434,436,438,440,442,444,446,448,450,452,454,456,458,460,462,464,466,468,470,472,474,476,478,480,482,484,486,488,490,492,494,496,498,500,502,504,506,508,510,512,514,516,518,520,522,524,526,528,530,532,534,536,538,540,542,544,546,548,550];
      
      n = size(ag,1);
      
      figure('Color','white','Name',filename)
%       subplot(2,1,1)
      plot(wavelength,ag')
      ylabel('a or c (m\^-1)')
      str = sprintf('N=%i',n);
      title(str)
      grid on
      
%       subplot(2,1,2)
%       plot(wavelength,ag_sd','r')
%       ylabel('std. dev. a or c (m\^-1)')
%       xlabel('wavelength (nm)')
%       grid on
end
%% Plot Tara data on map
figure('Color','white')
ax = worldmap([45 90],[-180 180]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
hold on
plotm(lat,lon,'r*-')
%% Plot time

t = datetime(date_acquired,'ConvertFrom','yyyymmdd');
t = char(t);
t = [t(:,1:12) time_acquired];
t = datetime(t,'ConvertFrom','yyyymmdd');

figure
plot(t,ag(:,wavelength==440))     
%% Rrs
dirname = '/Users/jconchas/Documents/Research/Arctic_Data/SeaBASS_ArcticL8/MAINE/boss/Tara_Oceans_Polar_Circle/Pevek_Tuktoyaktuk/archive/';

wavelength_short = [340,412,443,465,490,510,532,555,560,589,625,665,670,683,694,710,765,780,875];
filename = 'Tara_Polar_Circle_COPS_surface_20130914.txt';
filepath = [dirname filename];

[data, sbHeader, headerArray] = readsb(filepath);
R = [data{5:23}];
Rrs = [data{24:42}];
Lwn = [data{43:61}];

figure('Color','white','Name',filename)
subplot(3,1,1)
plot(wavelength_short,R)
ylabel('R')
grid on

subplot(3,1,2)
plot(wavelength_short,Rrs)
ylabel('Rrs (sr\^-1)')
grid on

subplot(3,1,3)
plot(wavelength_short,Lwn)
ylabel('Lwn (mW cm\^-2 um\^-1 sr\^-1)')
xlabel('wavelength (nm)')
grid on
%% Look in the Matchup structure the best images selected by visual inspection
fileID = fopen('/Users/jconchas/Documents/Research/Arctic_Data/L8images/Bulk Order 618866/L8 OLI_TIRS/file_list.txt');
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

for n = 1:size(s{:},1)
      disp('----------------------------------')
      disp(s{1}{n})
      for i=1:size(Matchup,2)
            if s{1}{n} == Matchup(i).id_scene
                  Matchup(i)
                  disp('Found it!')
                  break
            end
            
      end     
      path = str2num(s{1}{n}(4:6));
      row  = str2num(s{1}{n}(7:9));
      year = str2num(s{1}{n}(10:13));
      doy  = str2num(s{1}{n}(14:16));
      [yy mm dd] = datevec(datenum(year,1,doy));
      str= datestr(datenum([yy mm dd]),'yyyy-mm-dd');
      t_acq = datetime(str,'InputFormat','yyyy-MM-dd');
      str2 = datestr(t_acq);
      
      h1 = figure(1000);
      [~,~,~,h] = landsat(path,row,str);      
      figure(gcf)
      set(gcf,'Color','white','Name',s{1}{n})
      plotm(lat(Matchup(i).number_d),lon(Matchup(i).number_d),'*-r')
      
      
      disp(['Acquired Date:' str2])
      disp('In situ:')
      t(Matchup(i).number_d)
      [lat(Matchup(i).number_d),lon(Matchup(i).number_d)]
      
      t_diff = t(Matchup(i).number_d) - t_acq;
      
      [Y,I] = min(abs(t_diff));
       
      str3 = sprintf('Taken: %s, Closest in Situ: %s, Diff: %s',str2,datestr(t(Matchup(i).number_d(I))),char(t_diff(I)))
      
      title(str3)
      
      close(h1)
      
end
%%
clear dirname filepath
% for image LC80110252013307LGN00
   plotm(49.9352,  -65.0648,'b*')
   49.8661  -65.1339
   49.7924  -65.2076
   49.7178  -65.2822
   49.6403  -65.3597
   49.5561  -65.4439
   49.4689  -65.5311
   49.9813  -66.0187
   49.8935  -66.1065
   49.8094  -66.1906
   49.7273  -66.2727
   49.6432  -66.3568
   49.9876  -67.0124
   49.8570  -67.1430
   49.6987  -67.3013
   plotm(49.6214,  -67.3786,'*b')
   49.5522  -67.4478
   49.4843  -67.5157
   
   %% Extract Tara data from SeaBASS file
dirname = '/Users/jconchas/Documents/Research/Arctic_Data/SeaBASS_ArcticL8/MAINE/boss/Tara_Oceans_Polar_Circle/Pevek_Tuktoyaktuk/archive/';


% Open file with the list of images names
% fileID = fopen([dirname 'file_list.txt']);
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

% Plot Tara data on map
figure('Color','white')
ax = worldmap([45 90],[-180 180]);
% ax = worldmap('North Pole');
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
geoshow(ax,'worldlakes.shp', 'FaceColor', 'cyan')  
geoshow(ax,'worldrivers.shp', 'Color', 'blue')
hold on    
count = 0;
for idx=1:size(s{:},1)
      disp('------------------------')
      idx
      filename = s{1}{idx} % search on the list of filenames
      % filename = 'Tara_ACS_apcp2013_254ag.sb';
      
      filepath = [dirname filename];
      
      [data, sbHeader, headerArray] = readsb(filepath,'MakeStructure',true);
      plotm(data.lat,data.lon,'*-r')
      waitforbuttonpress
      count = count + size(data.lat,1)
end

addpath('/Users/jconchas/Documents/Research/')
%%
dirname = '/Users/jconchas/Documents/Research/LANDSAT8/SeaBASS_ArcticL8/MAINE/boss/Tara_Oceans_Polar_Circle/Pevek_Tuktoyaktuk/archive/';
filename = 'Tara_ACS_apcp2013_254ag.sb';

filepath = [dirname filename];

[data, sbHeader, headerArray] = readsb(filepath);

clear dirname filepath
%%
ag = [data{7:87}];
wavelength = [400.1,404.3,408.5,412.8,417.3,422.1,426.9,431.7,436.3,440.7,445.6,450.9,456,460.6,465.5,470.6,476.1,481.1,486.4,490.9,495.8,500.7,505.7,511.1,516.3,521.5,526.8,531.5,536.1,541.1,546.1,551,556,561.1,566.1,570.7,575.2,579.7,583.7,588.3,592.3,596.7,601.1,606,610.7,615.3,620,624.5,629,633.4,638,642.5,647.3,651.7,656.5,661.3,665.9,670.3,674.7,679.1,683.2,687.2,691.1,695.2,698.9,702.8,706.3,710.2,713.6,717.2,720.8,724.1,727.8,730.8,734,737.2,740.3,742.7,745.7,748.4,750];

figure
plot(wavelength,ag')
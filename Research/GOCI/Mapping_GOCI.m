addpath '/Users/jconchas/Documents/MATLAB';
%%
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs);
axesm('miller','maplatlim',[20 50],'maplonlim',[110 150]);
framem;  
axm = mlabel('FontSize',fs,...
      'MLabelParallel','south',...
      'MLabelLocation',110:10:150,...
      'MLineLocation',110:10:150); 
axp = plabel('FontSize',fs,...
      'PLabelLocation',20:5:50,...
      'PLineLocation',20:5:50);
tightmap
geoshow('landareas.shp','FaceColor',[0.8 0.8 0.8])
gridm;

% linem(lat, lon, 'LineStyle','none', 'LineWidth',2, 'Color','r', ...
%     'Marker','x', 'MarkerSize',10)

% GOCI footprint
% GOCI_lat_min = 20; % from SeaDAS stats
% GOCI_lat_max = 50;
% 
% GOCI_lon_min = 115;
% GOCI_lon_max = 145;

GOCI_lat_min = 21.5482; % from SeaDAS stats
GOCI_lat_max = 48.2222;

GOCI_lon_min = 111.3343;
GOCI_lon_max = 148.6689;

GOCI_NW_lat =  GOCI_lat_max;
GOCI_NW_lon =  GOCI_lon_min;

GOCI_NE_lat =  GOCI_lat_max;
GOCI_NE_lon =  GOCI_lon_max;

GOCI_SW_lat =  GOCI_lat_min;
GOCI_SW_lon =  GOCI_lon_min;

GOCI_SE_lat =  GOCI_lat_min;
GOCI_SE_lon =  GOCI_lon_max;

% GOCI_NW_lat =  dms2degrees([47 15 0.00]);
% GOCI_NW_lon =  dms2degrees([116 4 48.00]);

% GOCI_NE_lat =  dms2degrees([47 15 0.00]);
% GOCI_NE_lon =  dms2degrees([143 55 12.00]);

% GOCI_SW_lat =  dms2degrees([24 45 0.00]);
% GOCI_SW_lon =  dms2degrees([116 4 48.00]);

% GOCI_SE_lat =  dms2degrees([24 45 0.00]);
% GOCI_SE_lon =  dms2degrees([143 55 12.00]);

GOCI_footprint_lat = [GOCI_NW_lat GOCI_NE_lat GOCI_SE_lat GOCI_SW_lat GOCI_NW_lat];
GOCI_footprint_lon = [GOCI_NW_lon GOCI_NE_lon GOCI_SE_lon GOCI_SW_lon GOCI_NW_lon];

linem(GOCI_footprint_lat,GOCI_footprint_lon,'r','LineWidth',3)

% % GCWS (GOCI Clear Water Subset)
elat = 28.4950;
slat = 26.0960;
slon = 137.3380;
elon = 142.0920;

GCWS_NW_lat =  elat;
GCWS_NW_lon =  slon;

GCWS_NE_lat =  elat;
GCWS_NE_lon =  elon;

GCWS_SW_lat =  slat;
GCWS_SW_lon =  slon;

GCWS_SE_lat =  slat;
GCWS_SE_lon =  elon;

GCWS_footprint_lat = [GCWS_NW_lat GCWS_NE_lat GCWS_SE_lat GCWS_SW_lat GCWS_NW_lat];
GCWS_footprint_lon = [GCWS_NW_lon GCWS_NE_lon GCWS_SE_lon GCWS_SW_lon GCWS_NW_lon];

linem(GCWS_footprint_lat,GCWS_footprint_lon,'b','LineWidth',3)

% L2NORTH=29.4736
% L2SOUTH=24.2842
% L2WEST=131.9067
% L2EAST=142.3193

% GCW (GOCI Clear Water)
GCW_NW_lat =  29.4736; GCW_NW_lon =  131.9067;
GCW_NE_lat =  29.4736; GCW_NE_lon =  142.3193;
GCW_SW_lat =  24.2842; GCW_SW_lon =  131.9067;
GCW_SE_lat =  24.2842; GCW_SE_lon =  142.3193;
GCW_footprint_lat = [GCW_NW_lat GCW_NE_lat GCW_SE_lat GCW_SW_lat GCW_NW_lat];
GCW_footprint_lon = [GCW_NW_lon GCW_NE_lon GCW_SE_lon GCW_SW_lon GCW_NW_lon];

linem(GCW_footprint_lat,GCW_footprint_lon,'m','LineWidth',3)

% slot13	
slot13_NW_lon = 136.5439 ; slot13_NW_lat =	29.221634;
slot13_NE_lon = 143.39365; slot13_NE_lat =	29.371244;
slot13_SE_lon = 142.65186; slot13_SE_lat =	24.170422;
slot13_SW_lon = 136.09251; slot13_SW_lat =	24.010914;

slot13_footprint_lat = [slot13_NW_lat slot13_NE_lat slot13_SE_lat slot13_SW_lat slot13_NW_lat];
slot13_footprint_lon = [slot13_NW_lon slot13_NE_lon slot13_SE_lon slot13_SW_lon slot13_NW_lon];

linem(slot13_footprint_lat,slot13_footprint_lon,'k','LineWidth',3)

% AERONET-OC STATIONS
plotm(33.94199000,124.59291000,'or') % Gageocho
plotm(32.12295300,125.18244700,'or') % Ieodo
plotm(37.42313300,124.73803900,'or') % Socheongcho


% labels
textm(35.2, 121, 'Gageocho',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',20,...
      'FontWeight','bold');

textm(31.7, 124, 'Ieodo',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',20,...
      'FontWeight','bold');

textm(38.5, 121, 'Socheongcho',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',20,...
      'FontWeight','bold');

textm(32, 116, 'China',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',30,...
      'FontWeight','bold');

textm(37, 126.5, 'Korea',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',30,...
      'FontWeight','bold');

textm(36.5, 136, 'Japan',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',30,...
      'FontWeight','bold');

textm(25.5, 138, 'Slot 13',...
      'Color','k',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',25,...
      'FontWeight','normal');

textm(27.5, 137.7, 'GCWS',...
      'Color','b',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',25,...
      'FontWeight','normal');

textm(29, 132.5, 'GCW',...
      'Color','m',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',25,...
      'FontWeight','normal');

textm(23, 145, 'GOCI',...
      'Color','r',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',25,...
      'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [1 1 screen_size(3) screen_size(4)] ); %set to screen size

savedirname = '/Users/jconchas/Documents/Latex/2018_GOCI_paper_vcal/Figures/';
set(gcf,'PaperPositionMode', 'auto')
saveas(gcf,[savedirname 'GOCI_MAP'],'epsc')
% print('-depsc2', [savedirname 'GOCI_MAP'])
epsclean([savedirname 'GOCI_MAP.eps'])

%%

% YSKW (Yellow Sea - Korea West)
YSKW_NW_lat =  37; YSKW_NW_lon =  123.5;
YSKW_NE_lat =  37; YSKW_NE_lon =  126;
YSKW_SW_lat =  33; YSKW_SW_lon =  123.5;
YSKW_SE_lat =  33; YSKW_SE_lon =  126;
YSKW_footprint_lat = [YSKW_NW_lat YSKW_NE_lat YSKW_SE_lat YSKW_SW_lat YSKW_NW_lat];
YSKW_footprint_lon = [YSKW_NW_lon YSKW_NE_lon YSKW_SE_lon YSKW_SW_lon YSKW_NW_lon];

linem(YSKW_footprint_lat,YSKW_footprint_lon,'c','LineWidth',3)

textm(36.8, 123.2, 'YSKW',...
      'Color','c',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',18,...
      'FontWeight','normal');

% POLYGON ((123.5 37, 126 37, 126 33, 123.5 33, 123.5 37))

%% Map for Uncertainty paper
fs = 30;
h = figure('Color','white','DefaultAxesFontSize',fs);
axesm('miller','maplatlim',[20 50],'maplonlim',[110 150]);
framem;  
axm = mlabel('FontSize',fs,...
      'MLabelParallel','south',...
      'MLabelLocation',110:10:150,...
      'MLineLocation',110:10:150); 
axp = plabel('FontSize',fs,...
      'PLabelLocation',20:5:50,...
      'PLineLocation',20:5:50);
tightmap
geoshow('landareas.shp','FaceColor',[0.8 0.8 0.8])
gridm;

% linem(lat, lon, 'LineStyle','none', 'LineWidth',2, 'Color','r', ...
%     'Marker','x', 'MarkerSize',10)

% GOCI footprint
% GOCI_lat_min = 20; % from SeaDAS stats
% GOCI_lat_max = 50;
% 
% GOCI_lon_min = 115;
% GOCI_lon_max = 145;

GOCI_lat_min = 21.5482; % from SeaDAS stats
GOCI_lat_max = 48.2222;

GOCI_lon_min = 111.3343;
GOCI_lon_max = 148.6689;

GOCI_NW_lat =  GOCI_lat_max;
GOCI_NW_lon =  GOCI_lon_min;

GOCI_NE_lat =  GOCI_lat_max;
GOCI_NE_lon =  GOCI_lon_max;

GOCI_SW_lat =  GOCI_lat_min;
GOCI_SW_lon =  GOCI_lon_min;

GOCI_SE_lat =  GOCI_lat_min;
GOCI_SE_lon =  GOCI_lon_max;

% GOCI_NW_lat =  dms2degrees([47 15 0.00]);
% GOCI_NW_lon =  dms2degrees([116 4 48.00]);

% GOCI_NE_lat =  dms2degrees([47 15 0.00]);
% GOCI_NE_lon =  dms2degrees([143 55 12.00]);

% GOCI_SW_lat =  dms2degrees([24 45 0.00]);
% GOCI_SW_lon =  dms2degrees([116 4 48.00]);

% GOCI_SE_lat =  dms2degrees([24 45 0.00]);
% GOCI_SE_lon =  dms2degrees([143 55 12.00]);

GOCI_footprint_lat = [GOCI_NW_lat GOCI_NE_lat GOCI_SE_lat GOCI_SW_lat GOCI_NW_lat];
GOCI_footprint_lon = [GOCI_NW_lon GOCI_NE_lon GOCI_SE_lon GOCI_SW_lon GOCI_NW_lon];

linem(GOCI_footprint_lat,GOCI_footprint_lon,'r','LineWidth',3)

% % GCWS (GOCI Clear Water Subset)
elat = 28.4950;
slat = 26.0960;
slon = 137.3380;
elon = 142.0920;

GCWS_NW_lat =  elat;
GCWS_NW_lon =  slon;

GCWS_NE_lat =  elat;
GCWS_NE_lon =  elon;

GCWS_SW_lat =  slat;
GCWS_SW_lon =  slon;

GCWS_SE_lat =  slat;
GCWS_SE_lon =  elon;

GCWS_footprint_lat = [GCWS_NW_lat GCWS_NE_lat GCWS_SE_lat GCWS_SW_lat GCWS_NW_lat];
GCWS_footprint_lon = [GCWS_NW_lon GCWS_NE_lon GCWS_SE_lon GCWS_SW_lon GCWS_NW_lon];

linem(GCWS_footprint_lat,GCWS_footprint_lon,'b','LineWidth',3)

% L2NORTH=29.4736
% L2SOUTH=24.2842
% L2WEST=131.9067
% L2EAST=142.3193

% GCW (GOCI Clear Water)
% GCW_NW_lat =  29.4736; GCW_NW_lon =  131.9067;
% GCW_NE_lat =  29.4736; GCW_NE_lon =  142.3193;
% GCW_SW_lat =  24.2842; GCW_SW_lon =  131.9067;
% GCW_SE_lat =  24.2842; GCW_SE_lon =  142.3193;
% GCW_footprint_lat = [GCW_NW_lat GCW_NE_lat GCW_SE_lat GCW_SW_lat GCW_NW_lat];
% GCW_footprint_lon = [GCW_NW_lon GCW_NE_lon GCW_SE_lon GCW_SW_lon GCW_NW_lon];
% 
% linem(GCW_footprint_lat,GCW_footprint_lon,'m','LineWidth',3)

% slot13	
% slot13_NW_lon = 136.5439 ; slot13_NW_lat =	29.221634;
% slot13_NE_lon = 143.39365; slot13_NE_lat =	29.371244;
% slot13_SE_lon = 142.65186; slot13_SE_lat =	24.170422;
% slot13_SW_lon = 136.09251; slot13_SW_lat =	24.010914;
% 
% slot13_footprint_lat = [slot13_NW_lat slot13_NE_lat slot13_SE_lat slot13_SW_lat slot13_NW_lat];
% slot13_footprint_lon = [slot13_NW_lon slot13_NE_lon slot13_SE_lon slot13_SW_lon slot13_NW_lon];
% 
% linem(slot13_footprint_lat,slot13_footprint_lon,'k','LineWidth',3)

% AERONET-OC STATIONS
% plotm(33.94199000,124.59291000,'or') % Gageocho
% plotm(32.12295300,125.18244700,'or') % Ieodo
% plotm(37.42313300,124.73803900,'or') % Socheongcho


% labels
% textm(35.2, 121, 'Gageocho',...
%       'HorizontalAlignment','left',...
%       'VerticalAlignment','top',...
%       'FontSize',20,...
%       'FontWeight','bold');
% 
% textm(31.7, 124, 'Ieodo',...
%       'HorizontalAlignment','left',...
%       'VerticalAlignment','top',...
%       'FontSize',20,...
%       'FontWeight','bold');
% 
% textm(38.5, 121, 'Socheongcho',...
%       'HorizontalAlignment','left',...
%       'VerticalAlignment','top',...
%       'FontSize',20,...
%       'FontWeight','bold');

textm(32, 116, 'China',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',30,...
      'FontWeight','bold');

textm(37, 126.5, 'Korea',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',30,...
      'FontWeight','bold');

textm(36.5, 136, 'Japan',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',30,...
      'FontWeight','bold');

% textm(25.5, 138, 'Slot 13',...
%       'Color','k',...
%       'HorizontalAlignment','left',...
%       'VerticalAlignment','top',...
%       'FontSize',25,...
%       'FontWeight','normal');

textm(27.5, 137.7, 'GCWS',...
      'Color','b',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',25,...
      'FontWeight','normal');

% textm(29, 132.5, 'GCW',...
%       'Color','m',...
%       'HorizontalAlignment','left',...
%       'VerticalAlignment','top',...
%       'FontSize',25,...
%       'FontWeight','normal');

textm(23, 145, 'GOCI',...
      'Color','r',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'FontSize',25,...
      'FontWeight','normal');

screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [1 1 screen_size(3) screen_size(4)] ); %set to screen size

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/source/';
set(gcf,'PaperPositionMode', 'auto')
saveas(gcf,[savedirname 'GOCI_MAP_unc'],'epsc')
% print('-depsc2', [savedirname 'GOCI_MAP'])
epsclean([savedirname 'GOCI_MAP_unc.eps'])
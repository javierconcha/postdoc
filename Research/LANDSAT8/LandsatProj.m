

%%
[I,ImageDate,R,h] = landsat(072,021,'2014-07-28');

%%
figure('Color','white')
ax = worldmap([45 90],[170 -120]);
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
linem([R.LatitudeLimits(1) R.LatitudeLimits(1) R.LatitudeLimits(2) R.LatitudeLimits(2) R.LatitudeLimits(1)],...
    [R.LongitudeLimits(1) R.LongitudeLimits(2) R.LongitudeLimits(2) R.LongitudeLimits(1) R.LongitudeLimits(1)],...
    'r');
%%
landsat(072,021,'2014-07-28'); k = waitforbuttonpress;
landsat(077,010,'2014-07-15'); k = waitforbuttonpress;
landsat(078,009,'2014-08-07'); k = waitforbuttonpress;
landsat(078,015,'2014-08-23'); k = waitforbuttonpress;
landsat(079,015,'2014-07-29'); k = waitforbuttonpress;
landsat(079,016,'2014-07-29'); k = waitforbuttonpress;
landsat(079,017,'2014-08-30'); k = waitforbuttonpress;
landsat(079,018,'2014-07-13'); k = waitforbuttonpress;
landsat(079,018,'2014-07-29'); k = waitforbuttonpress;
landsat(080,010,'2014-09-06'); k = waitforbuttonpress;
landsat(080,013,'2014-08-05'); k = waitforbuttonpress;
landsat(080,015,'2014-09-06'); k = waitforbuttonpress;
landsat(080,016,'2014-07-20'); k = waitforbuttonpress;
landsat(080,016,'2014-08-05'); k = waitforbuttonpress;
landsat(080,016,'2014-08-21'); k = waitforbuttonpress;
landsat(080,016,'2014-09-06'); k = waitforbuttonpress;
landsat(080,018,'2014-09-06'); k = waitforbuttonpress;
landsat(081,009,'2014-08-12'); k = waitforbuttonpress;
landsat(081,010,'2014-08-12'); k = waitforbuttonpress;
landsat(082,013,'2014-09-04'); k = waitforbuttonpress;
landsat(082,014,'2014-07-18'); k = waitforbuttonpress;
landsat(082,014,'2014-09-04'); k = waitforbuttonpress;
landsat(082,015,'2014-07-18'); k = waitforbuttonpress;
landsat(082,015,'2014-09-04'); k = waitforbuttonpress;
landsat(082,016,'2014-07-18'); k = waitforbuttonpress;
landsat(082,017,'2014-09-04'); k = waitforbuttonpress;
landsat(083,010,'2014-07-09'); k = waitforbuttonpress;
landsat(083,011,'2014-07-09'); k = waitforbuttonpress;
landsat(083,012,'2014-07-09'); k = waitforbuttonpress;
landsat(083,013,'2014-07-09'); k = waitforbuttonpress;
landsat(084,013,'2014-09-02'); k = waitforbuttonpress;
landsat(084,014,'2014-09-02'); k = waitforbuttonpress;
landsat(084,015,'2014-09-02'); k = waitforbuttonpress;
landsat(084,016,'2014-09-02'); k = waitforbuttonpress;
landsat(087,008,'2014-08-06'); k = waitforbuttonpress;
landsat(087,009,'2014-08-06'); k = waitforbuttonpress;
landsat(087,010,'2014-08-06'); k = waitforbuttonpress;
landsat(087,011,'2014-08-06'); k = waitforbuttonpress;
landsat(087,012,'2014-08-06'); k = waitforbuttonpress;
landsat(087,012,'2014-08-22'); k = waitforbuttonpress;
landsat(087,013,'2014-08-22'); k = waitforbuttonpress;
landsat(088,013,'2014-07-28'); k = waitforbuttonpress;
landsat(088,013,'2014-08-29'); k = waitforbuttonpress;
landsat(089,014,'2014-08-04'); k = waitforbuttonpress;
landsat(090,008,'2014-08-11'); k = waitforbuttonpress;
landsat(090,009,'2014-08-11'); k = waitforbuttonpress;
landsat(090,010,'2014-08-11'); k = waitforbuttonpress;
landsat(090,011,'2014-07-10'); k = waitforbuttonpress;
landsat(090,011,'2014-08-11'); k = waitforbuttonpress;
landsat(090,014,'2014-07-10'); k = waitforbuttonpress;
landsat(090,015,'2014-07-10'); k = waitforbuttonpress;
landsat(090,015,'2014-08-27'); k = waitforbuttonpress;
landsat(090,016,'2014-07-10'); k = waitforbuttonpress;
landsat(090,016,'2014-07-26'); k = waitforbuttonpress;
landsat(090,016,'2014-08-27'); k = waitforbuttonpress;
landsat(090,017,'2014-07-10'); k = waitforbuttonpress;
landsat(090,017,'2014-08-27'); k = waitforbuttonpress;
landsat(148,234,'2014-08-02'); k = waitforbuttonpress;

%%
txt = urlread('http://earthexplorer.usgs.gov/fgdc/4923/LC8LC80720212014209LGN00');


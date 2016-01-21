function LandsatProj(im_id)

% From MTL file

figure('Color','white')
ax = worldmap([52 75],[-180 -120]);
load coastlines
geoshow(ax, coastlat, coastlon,...
'DisplayType', 'polygon', 'FaceColor', [.45 .60 .30])
hold on
geoshow(ax,[R.LatitudeLimits(1) R.LatitudeLimits(2) R.LatitudeLimits(2) R.LatitudeLimits(1) R.LatitudeLimits(1)],...
    [R.LongitudeLimits(1) R.LongitudeLimits(1) R.LongitudeLimits(2) R.LongitudeLimits(2) R.LongitudeLimits(1)],...
    'DisplayType','polygon', 'FaceColor', 'red','FaceAlpha','.3');
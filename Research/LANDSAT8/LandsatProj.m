function LandsatProj(im_id)

    CORNER_UL_LAT_PRODUCT = 56.99286
    CORNER_UL_LON_PRODUCT = -160.06982
    CORNER_UR_LAT_PRODUCT = 56.96465
    CORNER_UR_LON_PRODUCT = -156.13629
    CORNER_LL_LAT_PRODUCT = 54.81793
    CORNER_LL_LON_PRODUCT = -160.01157
    CORNER_LR_LAT_PRODUCT = 54.79192
    CORNER_LR_LON_PRODUCT = -156.29201

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
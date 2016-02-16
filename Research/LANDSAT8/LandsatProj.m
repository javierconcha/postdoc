function LandsatProj(filepath,varargin)

%% Get values from 
parval_UL_LAT = who(filepath,'CORNER_UL_LAT_PRODUCT');
parval_UL_LON = GetParMTL(filepath,'CORNER_UL_LON_PRODUCT');
parval_UR_LAT = GetParMTL(filepath,'CORNER_UR_LAT_PRODUCT');
parval_UR_LON = GetParMTL(filepath,'CORNER_UR_LON_PRODUCT');
parval_LL_LAT = GetParMTL(filepath,'CORNER_LL_LAT_PRODUCT');
parval_LL_LON = GetParMTL(filepath,'CORNER_LL_LON_PRODUCT');
parval_LR_LAT = GetParMTL(filepath,'CORNER_LR_LAT_PRODUCT');
parval_LR_LON = GetParMTL(filepath,'CORNER_LR_LON_PRODUCT');  

parval_PATH = GetParMTL(filepath,'WRS_PATH');
parval_ROW = GetParMTL(filepath,'WRS_ROW');
parval_DATE = GetParMTL(filepath,'DATE_ACQUIRED');

% From MTL file
geoshow([parval_UL_LAT parval_UR_LAT parval_LR_LAT parval_LL_LAT parval_UL_LAT],...
           [parval_UL_LON parval_UR_LON parval_LR_LON parval_LL_LON parval_UL_LON],...
    'DisplayType','polygon', 'FaceColor', 'red','FaceAlpha','.3');

str = sprintf('%2.0f%2.0f ',parval_PATH,parval_ROW);
textm(parval_UL_LAT,parval_UL_LON,str)
%% Set defaults: 
MakeRGB = true;
%% Parse inputs: 
tmp = strcmpi(varargin,'norgb'); 
if any(tmp)
    MakeRGB = false; 
end
%% to use landsat.m (it uses internet to download the image)
if MakeRGB
    [I,ImageDate,R,h] = landsat(parval_PATH,parval_ROW,parval_DATE);
end

%% Clean up: 

if nargout==0 
    clear I R h ImageDate
end
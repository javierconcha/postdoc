function [I,ImageDate,R,h] = landsat(wrs2path,wrs2row,varargin)
% landsat searches the internet for low-resolution Landsat 8 images of 
% specified path and row number and plots the most recent image in georeferenced coordinates. 
% 
%% Syntax 
% 
%  landsat(WRS2path,WRS2row)
%  landsat(...,ImageDate)
%  landsat(...,'nomap')
%  [I,ImageDate,R,h] = landsat(...)
% 
%% Description 
% 
% landsat(WRS2path,WRS2row) plots the most recent available Landsat 8
% image for World Reference System 2 path/row combination given by 
% WRS2path, WRS2row. 
% 
% landsat(...,ImageDate) specifies a search date to start from. By
% default, ImageDate is the current date, and the landsat function
% searches each day going back in time until a valid image is found. If you
% know an exact image date, enter that date instead as a string (e.g.,
% 'January 5, 2014' or in Matlab's datenum format.  If you enter an 
% ImageDate as 'January 5, 2014', landsat will look for an image on that
% date, if no images exist on Jan. 5, it will look on Jan. 4, then Jan. 3, and 
% so on until a valid image is found.  Alternatively, if ImageDate is a negative 
% scalar integer N, searching will begin with today, and skip or ignore the
% most recent N valid images.  
%  
% I = landsat(...,'nomap') returns the Landsat 8 image I and the
% 'nomap' command specifies that no map will be created. If you do not
% have a license for Matlab's Mapping Toolbox, specify 'nomap'.  You
% won't be able to make maps or get georeferencing information, but at
% least you'll get an image. 
% 
% [I,ImageDate,R,h] = landsat(...) also returns a georeferencing matrix
% R, a handle h of plotted image, and the ImageDate in datenum
% format. 
% 
%% How this function works
% This function requires an internet connection. Starting with any
% specified date, or the current date if no date is specified, landsat 
% searches back through time, attempting to access Landsat 8 images on the
% USGS website.  When an image is found, landsat will attempt to
% georeference and plot it. 
% 
% Georeferencing by this function may not always be perfect, and images plotted 
% by this function are of rather low resolution, so if accuracy or precision are 
% important for your work, consider using Level 1 GeoTiff data instead. 
% 
% Currently, this function only attempts to access Landsat 8 data.
% Functionality may be extended to other Landsat missions in the future.
% May not. 
% 
%% Paths and Rows
% The only two required inputs for the landsat function are the WRS2row
% and WRS2path. If you know the lat/lon coordinates of your area of
% interest, you can get path and row information here:
% https://landsat.usgs.gov/tools_latlong.php.  For an acquisition
% calendar, look here: 
% https://landsat.usgs.gov/tools_L8_acquisition_calendar.php.
% 
%% Examples
% % Let's take a look at sunny San Francisco, which is path 44, row 34. 
% % To map the most recent Landsat 8 image, of path 44, row 34, syntax is simple: 
% 
%    landsat(44,34)
% 
% % If the most recent image is cloudy, try looking at the previous image
% % using the -1 command: 
% 
%    landsat(44,34,-1)
% 
% % If that's cloudy too, try -2: 
% 
%    landsat(44,34,-2)
%    
% % To specify an exact date, include the date as a string or datenum: 
% 
%    landsat(44,34,'October 28, 2014')
% 
% % If you don't have the mapping toolbox, you can still get the image
% % and plot it using the 'nomap' tag: 
% 
%    [h,imagedate] = landsat(44,34,'October 28, 2014','nomap')
%    image(A)
%    axis image
% 
%% Author Info: 
% This was written by Chad A. Greene of the University of Texas at Austin's
% Institute for Geophysics (UTIG). December 2014.  Come say hi at 
% http://www.chadagreene.com. 
% 
% See also: geotiffread and geoshow. 

%% Initial input checks: 

narginchk(2,4)
assert(isscalar(wrs2path)==1,'wrs2path must be a scalar. Look up path/row data here: https://landsat.usgs.gov/tools_latlong.php')
assert(isscalar(wrs2row)==1,'wrs2row must be a scalar. Look up path/row data here: https://landsat.usgs.gov/tools_latlong.php')
assert(mod(wrs2path,1)==0,'wrs2path must be a scalar. Look up path/row data here: https://landsat.usgs.gov/tools_latlong.php')
assert(mod(wrs2row,1)==0,'wrs2row must be a scalar. Look up path/row data here: https://landsat.usgs.gov/tools_latlong.php')

%% Set defaults: 

ImageNumber = -1; 
InputDate = floor(now); % today
MakeMap = true; 
MapIsCurrent = false; 
I = []; 

%% Parse inputs: 

numvar = nargin-2; % number of varargin inputs

tmp = strcmpi(varargin,'nomap'); 
if any(tmp)
    MakeMap = false; 
    varargin = varargin(~tmp); 
    numvar = numvar-1; 
end

if numvar>0
    if isnumeric(varargin{1})
        if varargin{1}<1
            ImageNumber = varargin{1}-1; 
        else
            InputDate = varargin{1}; 
        end
    else
        InputDate = floor(datenum(varargin{1})); 
    end
end

assert(isscalar(InputDate)==1,'You can only enter one Image Date.')
assert(InputDate>=datenum(2013,2,11),'You are looking for a Landsat 8 image from before the launch of Landsat 8. Enter a date after Feb. 11, 2013 or leave the date field blank to return the most recent Landsat 8 image.') 

%% Look for images: 


% Limit searching to 45 seconds:
finalTime = datenum(clock + [0, 0, 0, 0, 0, 45]);
while datenum(clock) < finalTime & isempty(I)
    for searchdate = InputDate:-1:datenum(2013,2,11)
        [year,~,~] = datevec(searchdate);            % search year
        doy = datenum(searchdate)-datenum(year,1,0); % search day of year
        
        % Does an image exist for this search date? 
        try
            I = imread(['http://earthexplorer.usgs.gov/browse/landsat_8/',sprintf('%03.f',year),'/',sprintf('%03.f',wrs2path),...
                '/',sprintf('%03.f',wrs2row),'/LC8',sprintf('%03.f',wrs2path),sprintf('%03.f',wrs2row),sprintf('%03.f',year),...
                sprintf('%03.f',doy),'LGN00.jpg']);
            ImageNumber = ImageNumber + 1;  % If the image read above worked, log it. 
        end
        
        % When a valid image is found, break out of the search loop:
        if ImageNumber==0
            break
        end
    end
    
    % And if a valid image is found, we can break out of the timer loop too: 
    if ImageNumber==0
        break
    end
end

% If the loop got to Feb 11, 2013 or timed out, give up now: 
if isempty(I)
    error('No image found.') 
end

ImageDate = datenum(year,1,doy); 


%% Map data: 

if MakeMap
    % License check: 
    if license('test','map_toolbox')~=1
        warning('Mapping Toolbox license not found. I can return the image data, but I cannot map it or give georeferencing information.')
        return
    end

    % Read metadata for georeferencing: 
    txt = urlread(['http://earthexplorer.usgs.gov/fgdc/4923/LC8',sprintf('%03.f',wrs2path),sprintf('%03.f',wrs2row),...
        sprintf('%03.f',year),sprintf('%03.f',doy),'LGN00']);

    % Find G-polygon text in metadata file: 
    latind = regexp(txt,'G-Ring_Latitude');
    lonind = regexp(txt,'G-Ring_Longitude');

    % Get values of polygon vertices: 
    for k = 1:4
        lats(k) = str2double(txt(latind(k)+17:latind(k)+27));
        lons(k) = str2double(txt(lonind(k)+17:lonind(k)+27));
    end

    % Create georasterref:
    R = georasterref('LatLim',[min(lats) max(lats)],...
        'LonLim', [min(lons) max(lons)], ...
             'RasterSize', size(I),'ColumnsStartFrom','north');
            

    % Determine if a map is already open and current:
    try
        if ismap 
            MapIsCurrent = true; 
        end
    end
    
    % If map is not already current, open a new figure and initialize map:
    if ~MapIsCurrent
        figure
        worldmap(I,R)
    end
    
    % Plot map with geoshow: 
    
    % If an Antarctic map is already initialized, use Antarctic Mapping Tools:  
    if MapIsCurrent && strcmpi(getm(gca,'mapprojection'),'stereo')
        assert(exist('ps2ll','file')==2,'It looks like your current map projection is stereographic, so I''m assuming that this is some sort of Antarctica map. Not always a valid assumption, but it''s the best I can do. With this assumption, I want to transform coordinates with a function called ps2ll, with is included in the Antarctic Mapping Tools package found here: http://www.mathworks.com/matlabcentral/fileexchange/47638. Download ps2ll and ll2ps, then try again.') 
        
        [xlim,ylim] = ll2ps(lats,lons); % get map x/y coordinates of image bounding box then make grid 
        [x,y] = meshgrid(linspace(min(xlim),max(xlim),size(I,2)),linspace(max(ylim),min(ylim),size(I,1))); 
        [lat,lon] = ps2ll(x,y); % get lat/lon of every pixel. 
        
        % An imperfect method of getting rid of the black triangles bounding landsat image: 
        lat(sum(I,3)==0) = NaN; 
        lon(sum(I,3)==0) = NaN; 
        
        h = geoshow(lat,lon,I); 
        
    else
    h = geoshow(I,R); 
    end

end

%% Display message if image is from any date other than InputDate: 

if ImageDate ~= InputDate
    disp(['Image taken ',datestr(ImageDate)])
end


%% Clean up: 

if nargout==0 
    clear I R h ImageDate
end

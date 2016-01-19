%% |landsat| documentation
% This function searches the <http://landsat.usgs.gov/landsat8.php USGS website>
% for low-resolution Landsat 8 images of specified path and row number and plots 
% the most recent image in georeferenced coordinates. 

%% Syntax 
% 
%  landsat(WRS2path,WRS2row)
%  landsat(...,ImageDate)
%  landsat(...,'nomap')
%  [I,ImageDate,R,h] = landsat(...)
% 
%% Description 
% 
% |landsat(WRS2path,WRS2row)| plots the most recent available Landsat 8
% image for World Reference System 2
% (<http://landsat.usgs.gov/worldwide_reference_system_WRS.php WRS2>)
% path/row combination given by |WRS2path|, |WRS2row|. 
% 
% |landsat(...,ImageDate)| specifies a search date to start from. By
% default, |ImageDate| is the current date, and the |landsat| function
% searches each day going back in time until a valid image is found. If you
% know an exact image date, enter that date instead as a string (e.g.,
% |'January 5, 2014'| or in Matlab's |datenum| format.  If you enter an 
% |ImageDate| as |'January 5, 2014'|, |landsat| will look for an image on that
% date, if no images exist on Jan. 5, it will look on Jan. 4, then Jan. 3, and 
% so on until a valid image is found.  Alternatively, if |ImageDate| is a negative 
% scalar integer N, searching will begin with today, and skip or ignore the
% most recent N valid images.  
%  
% |I = landsat(...,'nomap')| returns the Landsat 8 image |I| and the
% |'nomap'| command specifies that no map will be created. If you do not
% have a license for Matlab's Mapping Toolbox, specify |'nomap'|.  You
% won't be able to make maps or get georeferencing information, but at
% least you'll get an image. 
% 
% |[I,ImageDate,R,h] = landsat(...)| also returns a georeferencing matrix
% |R|, a handle |h| of plotted image, and the |ImageDate| in |datenum|
% format. 
% 
%% How this function works
% This function requires an internet connection. Starting with any
% specified date, or the current date if no date is specified, |landsat| 
% searches back through time, attempting to access Landsat 8 images on the
% USGS website.  When an image is found, |landsat| will attempt to
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
% The only two required inputs for the |landsat| function are the |WRS2row|
% and |WRS2path|. If you know the lat/lon coordinates of your area of
% interest, you can get path and row information
% <https://landsat.usgs.gov/tools_latlong.php here>.  For an acquisition
% calendar, look
% <https://landsat.usgs.gov/tools_L8_acquisition_calendar.php here>.

%% Example 1: Sunny California
% Let's take a look at sunny San Francisco, which from the <https://landsat.usgs.gov/tools_latlong.php 
% path/row tool> know is path 44, row 34. To map the most recent Landsat 8
% image, of path 44, row 34, syntax is simple: 

landsat(44,34)

%% 
% Whoa, that's not sunny at all! That's about as cloudy as cloudy gets.
% Today, as I'm writing this documention it's December 11, 2014.  As the
% command line message indicates, the most recent available image is that
% one from November 29, 2014.  Let's look farther back in time; we'll look 
% for the image before November 29th.  First we'll clear the current map with |cla|: 

cla 
landsat(44,34,-1)

%% 
% It was also cloudy on November 13th near San Francisco, can you believe
% it?  Let's keep searching back in time: 

cla
landsat(44,34,-2)

%% 
% Ah, that's what I was hoping for.  Sunny as can be on October 28, 2014.
% If you're following along with this example someday in the future,
% |landsat(44,34,-2)| will not always refer to October 28th. To ensure an
% image from October 28, 2014 every time, state it clearly: 

cla
landsat(44,34,'October 28, 2014')

%% 
% Similarly, |landsat(44,34,'October 30, 2014')| would provide the same
% result as above because |landsat| always searches backward through time
% starting at the specified date.  And just for fun we can add Matlab's 
% built-in (rather low resolution) coast line in blue.  We can also add a
% <http://www.mathworks.com/matlabcentral/fileexchange/43500-scalebar-for-maps/content//scalebar_v2/html/scalebar_documentation.html
% |scalebar|> for reference. 

c = load('coast.mat'); 
plotm(c.lat,c.long,'blue','linewidth',2)
scalebar('length',50,'color','white')

%% Example 2: No Mapping Toolbox
% Most of what this function does relies on some tools in the Mapping
% Toolbox. If you don't have the toolbox, or if you simply do not want to 
% plot images on a map, you can get non-georeferenced images with the
% |'nomap'| option. Here we get an image of the Massachusetts coast and 
% show it non-georeferenced: 

close all % clears the figure created above
[I,imdate] = landsat(12,31,'10-Dec-2014','nomap'); 
image(I)
axis image

%% 
% Above, I tried to get an image from December 10th, but the satellite
% didn't fly path 12 that day. As the command window message indicates, the
% image was taken on 

datestr(imdate)

%% 
% That image can be found on the USGS site <http://earthexplorer.usgs.gov/browse/landsat_8/2014/012/031/LC80120312014333LGN00.jpg 
% here> and the associated metadata file is
% <http://earthexplorer.usgs.gov/fgdc/4923/LC80120312014333LGN00 here>.

%% Example 3: Antarctica
% For images around Antarctica, polar stereographic projections provide
% less distortion than a typical world map projection.  If you have a figure 
% window open and the current axes were created with <http://www.mathworks.com/matlabcentral/fileexchange/47638
% Antarctic Mapping Tools>, it's easy to overlay Landsat 8 images. Below we
% open a 400-km-wide <http://www.mathworks.com/matlabcentral/fileexchange/47282-modis-mosaic-of-antarctica/content//html/modismoa_demo.html 
% MODIS Mosaic of Antarctica> image centered on Pine Island Glacier, overlay the most recent 
% Landsat 8 image from path 233, row 113, and then overlay a red grounding
% line using <http://www.mathworks.com/matlabcentral/fileexchange/47640-asaid-grounding-lines/content//html/asaid_documentation.html
% ASAID> data. 

close all
modismoa('pine island glacier',400)
landsat(233,113)
asaid('gl','color','r','linewidth',1)

%% Author Info
% This function and supporting documentation were written by <http://www.chadagreene.com Chad A. Greene> of the University
% of Texas at Austin's Institute for Geophysics (<http://www.ig.utexas.edu/people/students/cgreene/ 
% UTIG>), December 2014. 
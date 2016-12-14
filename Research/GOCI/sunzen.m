function [zen,azm] = sunzen( lat, lon, day, hour, min, sec)
	
% matlab version of Liam Gumley's fortran subroutine 'sunzen.f'
% E.Weisz, Feb-02,2004	
	

% Purpose
% -------
% To compute the zenith and azimuth angles of the center of the sun, 
% as seen by an observer on the surface of the Earth.  The effects of 
% atmospheri% refraction are not accounted for in this routine.

% Revised 
% -------
% 11-NOV-1993
% 
% Programmer
% ----------
% Liam E. Gumley
% Research and Data Systems Corporation
% Code 913, NASA Goddard Space Flight Center
% Greenbelt MD 20771, USA
% gumley@climate.gsfc.nasa.gov

% References
% ----------
% (1) Iqbal, M., 1983:  An Introduction to Solar Radiation.  Academic
%     Press, New York, pp 1-19.

% Input
% -----
% real     lat		latitude of observer (degrees, -90=S, +90=N)
% real     lon		longitude of observer (degrees, -180=W, +180=E)
% real     day		day of the year (1-366)
% real     hour		GMT hours (0-24)
% real     min		GMT minutes (0-1440)
% real     sec		GMT seconds (0-86400)

% Output
% ------
% real     zen		solar zenith angle (degrees), defined as the
%                       the angle between the local zenith and the
%                       line joining the observer and the sun
% real     azm     	solar azimuth angle (degrees), defined as the
%                       rotation angle (clockwise from North) of a 
%                       vector from the observer to the sun
% Accuracy
% --------
% Iqbal (1) claims varying accuracies for the various equations used.
% The day angle does not have a maximum error quoted, but it should be
% small since it is an exact analytical formulation.
% The solar declination is estimated with a maximum error of 0.034 deg.
% The equation of time  is estimated with a maximum error of 0.143 deg.
% The local apparent solar time and hour angle do not have maximum
% errors quoted, but they should be small since they are exact
% analytical formulations.
% The solar zenith and azimuth angle derivations are trigonometric, and
% should be exact, within the limits of machine precision.
% The error in the solar zenith angle due to atmospheri% refraction
% ranges from zero when the sun is directly overhead to about 0.567
% degrees when the sun is at the horizon.
% It should be noted that the sun subtends a finite angle of 32 minutes
% (about 0.533 degrees) when viewed from the surface of the Earth.
% This routine has been tested against results from the program
% Xephem (V 2.4e), by E. Downey (xephem.tar.Z is available by anonymous
% FTP from export.lcs.mit.edu in directory contrib).  This testing
% verified the azimuth angles computed by this routine.

% Notes
% -----
% This subroutine may be run in double precision on systems where the 
% compiler allows automati% use of REAL*8 for REAL variables.
% 
%-----------------------------------------------------------------------

%	implicit real ( a - z )

%	set constants
	
	pi  = acos( -1.0 );
	rtd = 180.0 / pi;
	dtr = pi / 180.0;

%	day angle (radians), eq 1.2.2 in (1)
		
	fr = ( hour * 3600.0 + min * 60.0 + sec ) / 86400.0	;
	da = 2.0 * pi * ( day + fr - 1.0 ) / 365.0;

%	solar declination (radians), eq 1.3.1 in (1)

	dc = ( 0.006918 - 0.399912 * cos( da ) + ...
        0.070257 * sin( da ) - 0.006758 * cos( 2.0 * da ) + ...
        0.000907 * sin( 2.0 * da ) - 0.002697 * cos( 3.0 * da ) + ...
        0.00148 * sin( 3.0 * da ) );

%	equation of time (hours), eq 1.4.1 in (1)

	eq = ( 0.000075 + 0.001868 * cos( da ) - ...
     	0.032077 * sin( da ) - 0.014615 * cos( 2.0 * da ) - ...
        0.04089 * sin( 2.0 * da ) ) * 229.18 / 60.0;

%	local apparent solar time (hours), eq 1.4.2 in (1)

	st = hour + min / 60.0 + sec / 3600.0 +  ...
      ( 4.0 / 60.0 ) * lon + eq;
        if ( st <  0.0 ), st = st + 24.0;, end
        if ( st > 24.0 ), st = st - 24.0;, end
	
%	hour angle (radians), p 15 in (1)
	
	ha = ( 12.0 - st ) * 15.0 * dtr;

%	solar zenith angle (degrees), eq 1.5.1 in (1)

	x = sin( dc ) * sin( dtr * lat ) + ...
       cos( dc ) * cos( dtr * lat ) * cos( ha );
        if ( x > 1.0 ), x = 1.0;,  end
        if ( x < -1.0 ), x = -1.0;,  end
	zen = rtd * acos( x );

%	solar elevation angle (radians)

	el = dtr * ( 90.0 - zen );
	     
%	solar azimuth angle (degrees), eq 1.5.2a in (1)

	x = ( sin( el ) * sin( dtr * lat ) - sin( dc ) ) / ...
      ( cos( el ) * cos( dtr * lat ) );
        if ( x > 1.0 ), x = 1.0;,  end
        if ( x < -1.0 ), x = -1.0;,  end
	azm = rtd * acos( x );
	if ( ha < 0.0 ), azm = -1.0 * azm;,  end
	azm = 180.0 - azm;






dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/MTLDIR/';

% Open file with the list of images names
fileID = fopen([dirname 'file_list.txt']);
s = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

for idx=1:size(s{:},1)
      filename = s{1}{idx}; % search on the list of filenames
      
      filepath = [dirname filename];
      fileID = fopen(filepath);
      C = textscan(fileID,'%s','Delimiter','\n');
      fclose(fileID);
      
      

end
%1    ATTRIBUTE "Scene Start time" {
%       DATATYPE  H5T_STRING {
%          STRSIZE 24;
%          STRPAD H5T_STR_NULLTERM;
%          CSET H5T_CSET_ASCII;
%          CTYPE H5T_C_S1;
%       }
%       DATASPACE  SCALAR
%       DATA {
%+9      (0): "11-AUG-2011 01:15:38.398"
%       }
% 
%2    ATTRIBUTE "Scene center time" {
%       DATATYPE  H5T_STRING {
%          STRSIZE 24;
%          STRPAD H5T_STR_NULLTERM;
%          CSET H5T_CSET_ASCII;
%          CTYPE H5T_C_S1;
%       }
%       DATASPACE  SCALAR
%       DATA {
%       (0): "11-AUG-2011 01:28:47.540"
%       }
%    }
%3    ATTRIBUTE "Scene end time" {
%       DATATYPE  H5T_STRING {
%          STRSIZE 24;
%          STRPAD H5T_STR_NULLTERM;
%          CSET H5T_CSET_ASCII;
%          CTYPE H5T_C_S1;
%       }
%       DATASPACE  SCALAR
%       DATA {
%       (0): "11-AUG-2011 01:42:14.398"
%       }
%       
%4    ATTRIBUTE "Scene lower-left latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 21.5436
%       }
%    }
%5    ATTRIBUTE "Scene lower-left longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 116.419
%       }
%    }
%6    ATTRIBUTE "Scene lower-right latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 21.5436
%       }
%    }
%7    ATTRIBUTE "Scene lower-right longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 143.581
%       }
%    }
%8    ATTRIBUTE "Scene upper-left latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 46.9902
%       }
%    }
%9    ATTRIBUTE "Scene upper-left longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 111.324
%       }
%    }
%10    ATTRIBUTE "Scene upper-right latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 46.9902
%       }
%    }
%11    ATTRIBUTE "Scene upper-right longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 148.676
%       }
%    }

%12    ATTRIBUTE "Sun azimuth angle at scene center" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 2.10855
%       }
%    }
%13    ATTRIBUTE "Sun elevation angle at scene center" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 89.4217
%       }
%    }
%14    ATTRIBUTE "Time synchro UTC" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 3.66341e+08
%       }
%    }
% 
%15    ATTRIBUTE "number of columns" {
%       DATATYPE  H5T_STD_I32LE
%       DATASPACE  SIMPLE { ( 8 ) / ( 8 ) }
%       DATA {
%       (0): 5567, 5567, 5567, 5567, 5567, 5567, 5567, 5567
%       }
%    }
%16    ATTRIBUTE "number of rows" {
%       DATATYPE  H5T_STD_I32LE
%       DATASPACE  SIMPLE { ( 8 ) / ( 8 ) }
%       DATA {
%       (0): 5685, 5685, 5685, 5685, 5685, 5685, 5685, 5685
%       }
%    }
%    
%17       ATTRIBUTE "Product name" {
%       DATATYPE  H5T_STRING {
%          STRSIZE 35;
%          STRPAD H5T_STR_NULLTERM;
%          CSET H5T_CSET_ASCII;
%          CTYPE H5T_C_S1;
%       }
%       DATASPACE  SCALAR
%       DATA {
%       (0): "COMS_GOCI_L1B_GA_20110811011643.he5"
%       }
%    }
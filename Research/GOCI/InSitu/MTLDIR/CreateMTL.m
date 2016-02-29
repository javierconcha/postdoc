% Script to create an estructure with metadata from the h5dump for each
% GOCI image

dirname = '/Users/jconchas/Documents/Research/GOCI/InSitu/MTLDIR/';
clear MTLGOCI
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
      %% Find parameter value
      
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
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene Start time" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+9},'%s','Delimiter','"');      
      MTLGOCI(idx).Scene_Star_time = datetime(temp{:}{2},'InputFormat','dd-MMM-yyyy HH:mm:ss.SSS');      
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
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene center time" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+9},'%s','Delimiter','"');      
      MTLGOCI(idx).Scene_center_time = datetime(temp{:}{2},'InputFormat','dd-MMM-yyyy HH:mm:ss.SSS');
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
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene end time" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+9},'%s','Delimiter','"');      
      MTLGOCI(idx).Scene_end_time = datetime(temp{:}{2},'InputFormat','dd-MMM-yyyy HH:mm:ss.SSS');     
%4    ATTRIBUTE "Scene lower-left latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 21.5436
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene lower-left latitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).LL_lat = str2double(temp{:}{2});
%5    ATTRIBUTE "Scene lower-left longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 116.419
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene lower-left longitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).LL_lon = str2double(temp{:}{2});
%6    ATTRIBUTE "Scene lower-right latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 21.5436
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene lower-right latitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).LR_lat = str2double(temp{:}{2});
%7    ATTRIBUTE "Scene lower-right longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 143.581
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene lower-right longitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).LR_lon = str2double(temp{:}{2});
%8    ATTRIBUTE "Scene upper-left latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 46.9902
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene upper-left latitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).UL_lat = str2double(temp{:}{2});
%9    ATTRIBUTE "Scene upper-left longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 111.324
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene upper-left longitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).UL_lon = str2double(temp{:}{2});
%10    ATTRIBUTE "Scene upper-right latitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 46.9902
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene upper-right latitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).UR_lat = str2double(temp{:}{2});
%11    ATTRIBUTE "Scene upper-right longitude" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 148.676
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Scene upper-right longitude" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).UR_lon = str2double(temp{:}{2});
%12    ATTRIBUTE "Sun azimuth angle at scene center" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 2.10855
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Sun azimuth angle at scene center" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).Sun_AZ_ctr = str2double(temp{:}{2});
%13    ATTRIBUTE "Sun elevation angle at scene center" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 89.4217
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "Sun elevation angle at scene center" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
      MTLGOCI(idx).Sun_EL_ctr = str2double(temp{:}{2});
%14    ATTRIBUTE "Time synchro UTC" {
%       DATATYPE  H5T_IEEE_F32LE
%       DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
%       DATA {
%       (0): 3.66341e+08
%       }
%    }
%       linu = find(strcmp(C{1},'ATTRIBUTE "Time synchro UTC" {'), 1, 'first'); % line number
%       temp = textscan(C{1}{linu+4},'%s','Delimiter',' ');      
%       MTLGOCI(idx).Time_synchro_UTC = str2double(temp{:}{2}); 
%15    ATTRIBUTE "number of columns" {
%       DATATYPE  H5T_STD_I32LE
%       DATASPACE  SIMPLE { ( 8 ) / ( 8 ) }
%       DATA {
%       (0): 5567, 5567, 5567, 5567, 5567, 5567, 5567, 5567
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "number of columns" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ,');      
      MTLGOCI(idx).number_of_columns = [str2double(temp{:}{2}) str2double(temp{:}{4}) str2double(temp{:}{6}) ...
            str2double(temp{:}{8}) str2double(temp{:}{10}) str2double(temp{:}{12}) ...
            str2double(temp{:}{14}) str2double(temp{:}{16})];
%16    ATTRIBUTE "number of rows" {
%       DATATYPE  H5T_STD_I32LE
%       DATASPACE  SIMPLE { ( 8 ) / ( 8 ) }
%       DATA {
%       (0): 5685, 5685, 5685, 5685, 5685, 5685, 5685, 5685
%       }
%    }
      linu = find(strcmp(C{1},'ATTRIBUTE "number of rows" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+4},'%s','Delimiter',' ,');      
      MTLGOCI(idx).number_of_rows = [str2double(temp{:}{2}) str2double(temp{:}{4}) str2double(temp{:}{6}) ...
            str2double(temp{:}{8}) str2double(temp{:}{10}) str2double(temp{:}{12}) ...
            str2double(temp{:}{14}) str2double(temp{:}{16})];  
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
      linu = find(strcmp(C{1},'ATTRIBUTE "Product name" {'), 1, 'first'); % line number
      temp = textscan(C{1}{linu+9},'%s','Delimiter','"');      
      MTLGOCI(idx).Product_name = temp{:}{2};
end
save('MTLGOCI_struct.mat','MTLGOCI')
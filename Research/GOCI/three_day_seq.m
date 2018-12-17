%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3-day set comparison
clear A_idx A three_day_idx cond1 cond2 cond3 cond4 cond5 cond6
clear cond_brdf1 cond_brdf2 cond_brdf3
brdf_opt = 7;

for idx = 1:size(GOCI_DailyStatMatrix,2)-2
      cond_brdf1 = [GOCI_DailyStatMatrix(idx+0).brdf_opt]==brdf_opt;
      cond_brdf2 = [GOCI_DailyStatMatrix(idx+1).brdf_opt]==brdf_opt;
      cond_brdf3 = [GOCI_DailyStatMatrix(idx+2).brdf_opt]==brdf_opt;
      
      
      cond1 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_07]);
      
      
      cond2 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_443_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_443_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_443_07]);
      
      cond3 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_490_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_490_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_490_07]);
      
      cond4 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_555_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_555_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_555_07]);
      
      cond5 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_660_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_660_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_660_07]);
      
      cond6 = ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_680_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_680_07]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_00]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_01]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_02]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_03]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_04]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_05]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_06]) && ...
            ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_680_07]);
      
      if ~isempty(cond1)&&~isempty(cond2)&&~isempty(cond3)&&~isempty(cond4)&&~isempty(cond5)&&~isempty(cond6)...
                  &&~isempty(cond_brdf1)&&~isempty(cond_brdf2)&&~isempty(cond_brdf3)
            if cond1&&cond2&&cond3&&cond4&&cond5&&cond6... % for all bands 
                        &&cond_brdf1&&cond_brdf2&&cond_brdf3
                  three_day_idx(idx)=true;
                  
            else
                  three_day_idx(idx)=false;
            end
      else
            three_day_idx(idx)=false;
      end
end

A_idx= find(three_day_idx); % indeces to 3-day sequences.
%% 3-day sequences plot -- Rrs for two specific cases

% for idx = 1:1*sum(three_day_idx)/4
for idx = [find(A_idx==find([GOCI_DailyStatMatrix.datetime]==datetime(2012,07,28))) ...
            find(A_idx==find([GOCI_DailyStatMatrix.datetime]==datetime(2015,09,01)))]
      % for idx = 1:size(A,2)
      
      % Rrs
      tod_Rrs_412_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_00]];
      tod_Rrs_412_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_01]];
      tod_Rrs_412_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_02]];
      tod_Rrs_412_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_03]];
      tod_Rrs_412_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_04]];
      tod_Rrs_412_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_05]];
      tod_Rrs_412_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_06]];
      tod_Rrs_412_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_07]];

      tod_Rrs_443_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_00]];
      tod_Rrs_443_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_01]];
      tod_Rrs_443_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_02]];
      tod_Rrs_443_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_03]];
      tod_Rrs_443_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_04]];
      tod_Rrs_443_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_05]];
      tod_Rrs_443_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_06]];
      tod_Rrs_443_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_07]];
      
      tod_Rrs_490_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_00]];
      tod_Rrs_490_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_01]];
      tod_Rrs_490_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_02]];
      tod_Rrs_490_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_03]];
      tod_Rrs_490_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_04]];
      tod_Rrs_490_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_05]];
      tod_Rrs_490_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_06]];
      tod_Rrs_490_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_07]];
      
      tod_Rrs_555_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_00]];
      tod_Rrs_555_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_01]];
      tod_Rrs_555_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_02]];
      tod_Rrs_555_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_03]];
      tod_Rrs_555_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_04]];
      tod_Rrs_555_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_05]];
      tod_Rrs_555_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_06]];
      tod_Rrs_555_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_07]];
      
      tod_Rrs_660_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_00]];
      tod_Rrs_660_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_01]];
      tod_Rrs_660_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_02]];
      tod_Rrs_660_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_03]];
      tod_Rrs_660_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_04]];
      tod_Rrs_660_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_05]];
      tod_Rrs_660_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_06]];
      tod_Rrs_660_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_07]];
      
      tod_Rrs_680_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_00]];
      tod_Rrs_680_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_01]];
      tod_Rrs_680_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_02]];
      tod_Rrs_680_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_03]];
      tod_Rrs_680_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_04]];
      tod_Rrs_680_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_05]];
      tod_Rrs_680_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_06]];
      tod_Rrs_680_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_07]];

      % datetime
      tod_Rrs_412_00_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_01_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_02_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_03_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_04_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_05_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_06_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_412_07_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      
      tod_Rrs_443_00_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_01_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_02_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_03_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_04_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_05_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_06_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_443_07_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      
      tod_Rrs_490_00_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_01_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_02_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_03_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_04_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_05_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_06_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_490_07_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      
      tod_Rrs_555_00_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_01_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_02_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_03_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_04_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_05_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_06_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_555_07_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      
      tod_Rrs_660_00_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_01_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_02_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_03_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_04_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_05_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_06_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_660_07_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      
      tod_Rrs_680_00_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_01_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_02_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_03_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_04_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_05_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_06_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      tod_Rrs_680_07_datetime = [[GOCI_DailyStatMatrix(A_idx(idx)).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+1).datetime] [GOCI_DailyStatMatrix(A_idx(idx)+2).datetime]];
      
      
      fs = 30;
      lw = 1.5;
      ms = 16;
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      
      %% Rrs
      % Rrs_412
      % subplot(2,2,1)
      plot(tod_Rrs_412_00_datetime+hours(0),tod_Rrs_412_00,'-or','MarkerSize',ms,'LineWidth',lw)
      ylim([0 0.018])
      hold on
      plot(tod_Rrs_412_01_datetime+hours(1),tod_Rrs_412_01,'-og','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_02_datetime+hours(2),tod_Rrs_412_02,'-ob','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_03_datetime+hours(3),tod_Rrs_412_03,'-ok','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_04_datetime+hours(4),tod_Rrs_412_04,'-oc','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_05_datetime+hours(5),tod_Rrs_412_05,'-om','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_06_datetime+hours(6),tod_Rrs_412_06,'-o','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_412_07_datetime+hours(7),tod_Rrs_412_07,'-o','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      % ylabel('R_{rs}(412) (sr^{-1})','FontSize',fs)
      % xlabel('Time','FontSize',fs)
      % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      
      % Rrs_443
      % subplot(2,2,1)
      plot(tod_Rrs_443_00_datetime+hours(0),tod_Rrs_443_00,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_443_01_datetime+hours(1),tod_Rrs_443_01,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_02_datetime+hours(2),tod_Rrs_443_02,'-^b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_03_datetime+hours(3),tod_Rrs_443_03,'-^k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_04_datetime+hours(4),tod_Rrs_443_04,'-^c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_05_datetime+hours(5),tod_Rrs_443_05,'-^m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_06_datetime+hours(6),tod_Rrs_443_06,'-^','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_443_07_datetime+hours(7),tod_Rrs_443_07,'-^','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      % ylabel('R_{rs}(443) (sr^{-1})','FontSize',fs)
      % xlabel('Time','FontSize',fs)
      % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      
      % Rrs_490
      % subplot(2,2,1)
      plot(tod_Rrs_490_00_datetime+hours(0),tod_Rrs_490_00,'-*r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_490_01_datetime+hours(1),tod_Rrs_490_01,'-*g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_02_datetime+hours(2),tod_Rrs_490_02,'-*b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_03_datetime+hours(3),tod_Rrs_490_03,'-*k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_04_datetime+hours(4),tod_Rrs_490_04,'-*c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_05_datetime+hours(5),tod_Rrs_490_05,'-*m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_06_datetime+hours(6),tod_Rrs_490_06,'-*','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_490_07_datetime+hours(7),tod_Rrs_490_07,'-*','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
      
      % ylabel('R_{rs}(490) (sr^{-1})','FontSize',fs)
      % xlabel('Time','FontSize',fs)
      % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')
      
      % Rrs_555
      % subplot(2,2,1)
      plot(tod_Rrs_555_00_datetime+hours(0),tod_Rrs_555_00,'-xr','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_555_01_datetime+hours(1),tod_Rrs_555_01,'-xg','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_02_datetime+hours(2),tod_Rrs_555_02,'-xb','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_03_datetime+hours(3),tod_Rrs_555_03,'-xk','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_04_datetime+hours(4),tod_Rrs_555_04,'-xc','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_05_datetime+hours(5),tod_Rrs_555_05,'-xm','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_06_datetime+hours(6),tod_Rrs_555_06,'-x','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_555_07_datetime+hours(7),tod_Rrs_555_07,'-x','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)
 
      % Rrs_660
      % subplot(2,2,1)
      plot(tod_Rrs_660_00_datetime+hours(0),tod_Rrs_660_00,'-+r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_660_01_datetime+hours(1),tod_Rrs_660_01,'-+g','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_660_02_datetime+hours(2),tod_Rrs_660_02,'-+b','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_660_03_datetime+hours(3),tod_Rrs_660_03,'-+k','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_660_04_datetime+hours(4),tod_Rrs_660_04,'-+c','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_660_05_datetime+hours(5),tod_Rrs_660_05,'-+m','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_660_06_datetime+hours(6),tod_Rrs_660_06,'-+','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_660_07_datetime+hours(7),tod_Rrs_660_07,'-+','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

      % Rrs_680
      % subplot(2,2,1)
      plot(tod_Rrs_680_00_datetime+hours(0),tod_Rrs_680_00,'-xr','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(tod_Rrs_680_01_datetime+hours(1),tod_Rrs_680_01,'-vg','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_680_02_datetime+hours(2),tod_Rrs_680_02,'-vb','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_680_03_datetime+hours(3),tod_Rrs_680_03,'-vk','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_680_04_datetime+hours(4),tod_Rrs_680_04,'-vc','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_680_05_datetime+hours(5),tod_Rrs_680_05,'-vm','MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_680_06_datetime+hours(6),tod_Rrs_680_06,'-v','Color',[1 0.5 0],'MarkerSize',ms,'LineWidth',lw)
      plot(tod_Rrs_680_07_datetime+hours(7),tod_Rrs_680_07,'-v','Color',[0.5 0 0.5],'MarkerSize',ms,'LineWidth',lw)

      grid on
      ylabel('{\itR}_{rs}(\lambda) (sr^{-1})','FontSize',fs)
      xlabel('Time','FontSize',fs)
      
      datetick('x','mm/dd/yy')
      ax = gca;
      % ax.YLim(1) = 0 ;
      
      ax.XLim(1) = ax.XTick(1)-0.2;
      ax.XLim(2) = ax.XTick(3)+0.5;
      
      %       hleg = legend('412: 0h','412: 1h','412: 2h','412: 3h','412: 4h','412: 5h','412: 6h','412: 7h',...
      %             '443: 0h','443: 1h','443: 2h','443: 3h','443: 4h','443: 5h','443: 6h','443: 7h',...
      %             '490: 0h','490: 1h','490: 2h','490: 3h','490: 4h','490: 5h','490: 6h','490: 7h',...
      %             '555: 0h','555: 1h','555: 2h','555: 3h','555: 4h','555: 5h','555: 6h','555: 7h');
      %       set(hleg,'fontsize',22)
      %       set(hleg,'Location','bestoutside')
      
      set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      
      
end
%
figure(1)
hold on
h = gcf;
% annotations
% 412
annotation(h,'textbox',...
      [0.65 0.80 0.04 0.04],...
      'Color',[0.5 0 0.5],...
      'String',{'412'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 443
annotation(h,'textbox',...
      [0.65 0.65 0.04 0.04],...
      'Color',[0 0 1],...
      'String',{'443'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 490
annotation(h,'textbox',...
      [0.65 0.46 0.04 0.04],...
      'Color',[0 0.5 1],...
      'String',{'490'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 555
annotation(h,'textbox',...
      [0.65 0.22 0.04 0.04],...
      'Color',[0 0.5 0],...
      'String',{'555'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 660
annotation(h,'textbox',...
      [0.61 0.138 0.04 0.04],...
      'Color',[1 0.5 0],...
      'String',{'660'},...
      'FontSize',fs,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 680
annotation(h,'textbox',...
      [0.69 0.138 0.04 0.04],...
      'Color',[1 0 0],...
      'String',{'680'},...
      'FontSize',fs,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1])
%
figure(2)
hold on
h = gcf;
% annotations
% 412
annotation(h,'textbox',...
      [0.65 0.78 0.04 0.04],...
      'Color',[0.5 0 0.5],...
      'String',{'412'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 443
annotation(h,'textbox',...
      [0.65 0.60 0.04 0.04],...
      'Color',[0 0 1],...
      'String',{'443'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 490
annotation(h,'textbox',...
      [0.65 0.41 0.04 0.04],...
      'Color',[0 0.5 1],...
      'String',{'490'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 555
annotation(h,'textbox',...
      [0.65 0.19 0.04 0.04],...
      'Color',[0 0.5 0],...
      'String',{'555'},...
      'FontSize',fs+2,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 660
annotation(h,'textbox',...
      [0.61 0.145 0.02 0.02],...
      'Color',[1 0.5 0],...
      'String',{'660'},...
      'FontSize',fs-1,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1]);

% 680
annotation(h,'textbox',...
      [0.69 0.145 0.02 0.02],...
      'Color',[1 0 0],...
      'String',{'680'},...
      'FontSize',fs-1,...
      'FitBoxToText','off',...
      'EdgeColor',[1 1 1],...
      'BackgroundColor',[1 1 1])

savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/source/';

saveas(gcf,[savedirname '3days_all_' num2str(idx)],'epsc')




%% Plot 3-day sequences -- Rrs per time of day

% for idx = 1:1*sum(three_day_idx)/4
for idx = find(A_idx==find([GOCI_DailyStatMatrix.datetime]==datetime(2015,09,01)))
            
      % for idx = 1:size(A,2)
      
      % Rrs
      tod_Rrs_412_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_00]];
      tod_Rrs_412_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_01]];
      tod_Rrs_412_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_02]];
      tod_Rrs_412_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_03]];
      tod_Rrs_412_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_04]];
      tod_Rrs_412_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_05]];
      tod_Rrs_412_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_06]];
      tod_Rrs_412_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_07]];

      tod_Rrs_443_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_00]];
      tod_Rrs_443_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_01]];
      tod_Rrs_443_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_02]];
      tod_Rrs_443_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_03]];
      tod_Rrs_443_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_04]];
      tod_Rrs_443_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_05]];
      tod_Rrs_443_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_06]];
      tod_Rrs_443_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_07]];
      
      tod_Rrs_490_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_00]];
      tod_Rrs_490_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_01]];
      tod_Rrs_490_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_02]];
      tod_Rrs_490_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_03]];
      tod_Rrs_490_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_04]];
      tod_Rrs_490_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_05]];
      tod_Rrs_490_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_06]];
      tod_Rrs_490_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_07]];
      
      tod_Rrs_555_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_00]];
      tod_Rrs_555_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_01]];
      tod_Rrs_555_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_02]];
      tod_Rrs_555_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_03]];
      tod_Rrs_555_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_04]];
      tod_Rrs_555_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_05]];
      tod_Rrs_555_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_06]];
      tod_Rrs_555_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_07]];
      
      tod_Rrs_660_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_00]];
      tod_Rrs_660_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_01]];
      tod_Rrs_660_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_02]];
      tod_Rrs_660_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_03]];
      tod_Rrs_660_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_04]];
      tod_Rrs_660_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_05]];
      tod_Rrs_660_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_06]];
      tod_Rrs_660_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_07]];
      
      tod_Rrs_680_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_00]];
      tod_Rrs_680_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_01]];
      tod_Rrs_680_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_02]];
      tod_Rrs_680_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_03]];
      tod_Rrs_680_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_04]];
      tod_Rrs_680_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_05]];
      tod_Rrs_680_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_06]];
      tod_Rrs_680_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_07]];

      tod_chlor_a_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_00]];
      tod_chlor_a_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_01]];
      tod_chlor_a_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_02]];
      tod_chlor_a_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_03]];
      tod_chlor_a_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_04]];
      tod_chlor_a_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_05]];
      tod_chlor_a_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_06]];
      tod_chlor_a_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_07]];
 
      tod_poc_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_00]];
      tod_poc_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_01]];
      tod_poc_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_02]];
      tod_poc_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_03]];
      tod_poc_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_04]];
      tod_poc_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_05]];
      tod_poc_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_06]];
      tod_poc_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_07]];
 
      tod_ag_412_mlrc_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_00]];
      tod_ag_412_mlrc_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_01]];
      tod_ag_412_mlrc_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_02]];
      tod_ag_412_mlrc_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_03]];
      tod_ag_412_mlrc_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_04]];
      tod_ag_412_mlrc_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_05]];
      tod_ag_412_mlrc_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_06]];
      tod_ag_412_mlrc_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_07]];
 
      
      fs = 24;
      lw = 2.0;
      ms = 14;

      %% Blue Bands
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      % set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      % set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      % Rrs_412
      % subplot(2,2,1)
      Rrs_412_day1 = [tod_Rrs_412_00(1) tod_Rrs_412_01(1) tod_Rrs_412_02(1) tod_Rrs_412_03(1) tod_Rrs_412_04(1) tod_Rrs_412_05(1) tod_Rrs_412_06(1) tod_Rrs_412_07(1)];
      Rrs_412_day2 = [tod_Rrs_412_00(2) tod_Rrs_412_01(2) tod_Rrs_412_02(2) tod_Rrs_412_03(2) tod_Rrs_412_04(2) tod_Rrs_412_05(2) tod_Rrs_412_06(2) tod_Rrs_412_07(2)];
      Rrs_412_day3 = [tod_Rrs_412_00(3) tod_Rrs_412_01(3) tod_Rrs_412_02(3) tod_Rrs_412_03(3) tod_Rrs_412_04(3) tod_Rrs_412_05(3) tod_Rrs_412_06(3) tod_Rrs_412_07(3)];
      plot(1:8,Rrs_412_day1,'-or','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,Rrs_412_day2,'-og','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,Rrs_412_day3,'-ob','MarkerSize',ms,'LineWidth',lw)

%       legend('Day 1{     }','Day 2{     }','Day 3','Location','northoutside','Orientation','horizontal')
%       legend boxoff

      
      % Rrs_443
      % subplot(2,2,1)
      Rrs_443_day1 = [tod_Rrs_443_00(1) tod_Rrs_443_01(1) tod_Rrs_443_02(1) tod_Rrs_443_03(1) tod_Rrs_443_04(1) tod_Rrs_443_05(1) tod_Rrs_443_06(1) tod_Rrs_443_07(1)];
      Rrs_443_day2 = [tod_Rrs_443_00(2) tod_Rrs_443_01(2) tod_Rrs_443_02(2) tod_Rrs_443_03(2) tod_Rrs_443_04(2) tod_Rrs_443_05(2) tod_Rrs_443_06(2) tod_Rrs_443_07(2)];
      Rrs_443_day3 = [tod_Rrs_443_00(3) tod_Rrs_443_01(3) tod_Rrs_443_02(3) tod_Rrs_443_03(3) tod_Rrs_443_04(3) tod_Rrs_443_05(3) tod_Rrs_443_06(3) tod_Rrs_443_07(3)];
      plot(1:8,Rrs_443_day1,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,Rrs_443_day2,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,Rrs_443_day3,'-^b','MarkerSize',ms,'LineWidth',lw)
      
      % Rrs_490
      % subplot(2,2,1)
      Rrs_490_day1 = [tod_Rrs_490_00(1) tod_Rrs_490_01(1) tod_Rrs_490_02(1) tod_Rrs_490_03(1) tod_Rrs_490_04(1) tod_Rrs_490_05(1) tod_Rrs_490_06(1) tod_Rrs_490_07(1)];
      Rrs_490_day2 = [tod_Rrs_490_00(2) tod_Rrs_490_01(2) tod_Rrs_490_02(2) tod_Rrs_490_03(2) tod_Rrs_490_04(2) tod_Rrs_490_05(2) tod_Rrs_490_06(2) tod_Rrs_490_07(2)];
      Rrs_490_day3 = [tod_Rrs_490_00(3) tod_Rrs_490_01(3) tod_Rrs_490_02(3) tod_Rrs_490_03(3) tod_Rrs_490_04(3) tod_Rrs_490_05(3) tod_Rrs_490_06(3) tod_Rrs_490_07(3)];
      plot(1:8,Rrs_490_day1,'-*r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,Rrs_490_day2,'-*g','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,Rrs_490_day3,'-*b','MarkerSize',ms,'LineWidth',lw)
      
      ylim([0 0.02])
      xlim([0 9])
      xlabel('Time of day (Local Time)','FontSize',fs)
      ax = gca;
      ax.XAxis.TickValues = 0:9;
      ax.XTickLabel = {'','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00',''};
      ax.XTickLabelRotation = -40;

      grid on
      ylabel('{\itR}_{rs}(\lambda) (sr^{-1})','FontSize',fs)

      % 412
      annotation(h,'textbox',...
            [0.85 0.7 0.04 0.04],...
            'Color',[0.5 0 0.5],...
            'String',{'412'},...
            'FontSize',fs+2,...
            'FitBoxToText','off',...
            'EdgeColor',[1 1 1],...
            'BackgroundColor',[1 1 1]);
      
      % 443
      annotation(h,'textbox',...
            [0.85 0.58 0.04 0.04],...
            'Color',[0 0 1],...
            'String',{'443'},...
            'FontSize',fs+2,...
            'FitBoxToText','off',...
            'EdgeColor',[1 1 1],...
            'BackgroundColor',[1 1 1]);
      
      % 490
      annotation(h,'textbox',...
            [0.85 0.43 0.04 0.04],...
            'Color',[0 0.5 1],...
            'String',{'490'},...
            'FontSize',fs+2,...
            'FitBoxToText','off',...
            'EdgeColor',[1 1 1],...
            'BackgroundColor',[1 1 1]);

      saveas(gcf,[savedirname '3days_B'],'epsc')
      %% Green Bands
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      % set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      % set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

      % Rrs_555
      % subplot(2,2,1)
      Rrs_555_day1 = [tod_Rrs_555_00(1) tod_Rrs_555_01(1) tod_Rrs_555_02(1) tod_Rrs_555_03(1) tod_Rrs_555_04(1) tod_Rrs_555_05(1) tod_Rrs_555_06(1) tod_Rrs_555_07(1)];
      Rrs_555_day2 = [tod_Rrs_555_00(2) tod_Rrs_555_01(2) tod_Rrs_555_02(2) tod_Rrs_555_03(2) tod_Rrs_555_04(2) tod_Rrs_555_05(2) tod_Rrs_555_06(2) tod_Rrs_555_07(2)];
      Rrs_555_day3 = [tod_Rrs_555_00(3) tod_Rrs_555_01(3) tod_Rrs_555_02(3) tod_Rrs_555_03(3) tod_Rrs_555_04(3) tod_Rrs_555_05(3) tod_Rrs_555_06(3) tod_Rrs_555_07(3)];
      plot(1:8,Rrs_555_day1,'-or','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,Rrs_555_day2,'-og','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,Rrs_555_day3,'-ob','MarkerSize',ms,'LineWidth',lw)

      ylim([0 0.003])
      xlim([0 9])
      xlabel('Time of day (Local Time)','FontSize',fs)
      ax = gca;
      ax.XAxis.TickValues = 0:9;
      ax.XTickLabel = {'','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00',''};
      ax.XTickLabelRotation = -40;

      grid on
      ylabel('{\itR}_{rs}(\lambda) (sr^{-1})','FontSize',fs)

      
      % 555
      annotation(h,'textbox',...
            [0.85 0.52 0.04 0.04],...
            'Color',[0 0.5 0],...
            'String',{'555'},...
            'FontSize',fs+2,...
            'FitBoxToText','off',...
            'EdgeColor',[1 1 1],...
            'BackgroundColor',[1 1 1]);
      saveas(gcf,[savedirname '3days_G'],'epsc')

      %% Red Bands
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      % set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      % set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

      % Rrs_660
      % subplot(2,2,1)
      Rrs_660_day1 = [tod_Rrs_660_00(1) tod_Rrs_660_01(1) tod_Rrs_660_02(1) tod_Rrs_660_03(1) tod_Rrs_660_04(1) tod_Rrs_660_05(1) tod_Rrs_660_06(1) tod_Rrs_660_07(1)];
      Rrs_660_day2 = [tod_Rrs_660_00(2) tod_Rrs_660_01(2) tod_Rrs_660_02(2) tod_Rrs_660_03(2) tod_Rrs_660_04(2) tod_Rrs_660_05(2) tod_Rrs_660_06(2) tod_Rrs_660_07(2)];
      Rrs_660_day3 = [tod_Rrs_660_00(3) tod_Rrs_660_01(3) tod_Rrs_660_02(3) tod_Rrs_660_03(3) tod_Rrs_660_04(3) tod_Rrs_660_05(3) tod_Rrs_660_06(3) tod_Rrs_660_07(3)];
      plot(1:8,Rrs_660_day1,'-or','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,Rrs_660_day2,'-og','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,Rrs_660_day3,'-ob','MarkerSize',ms,'LineWidth',lw)

      % Rrs_680
      % subplot(2,2,1)
      Rrs_680_day1 = [tod_Rrs_680_00(1) tod_Rrs_680_01(1) tod_Rrs_680_02(1) tod_Rrs_680_03(1) tod_Rrs_680_04(1) tod_Rrs_680_05(1) tod_Rrs_680_06(1) tod_Rrs_680_07(1)];
      Rrs_680_day2 = [tod_Rrs_680_00(2) tod_Rrs_680_01(2) tod_Rrs_680_02(2) tod_Rrs_680_03(2) tod_Rrs_680_04(2) tod_Rrs_680_05(2) tod_Rrs_680_06(2) tod_Rrs_680_07(2)];
      Rrs_680_day3 = [tod_Rrs_680_00(3) tod_Rrs_680_01(3) tod_Rrs_680_02(3) tod_Rrs_680_03(3) tod_Rrs_680_04(3) tod_Rrs_680_05(3) tod_Rrs_680_06(3) tod_Rrs_680_07(3)];
      plot(1:8,Rrs_680_day1,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,Rrs_680_day2,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,Rrs_680_day3,'-^b','MarkerSize',ms,'LineWidth',lw)

      ylim([0 0.0006])
      xlim([0 9])
      xlabel('Time of day (Local Time)','FontSize',fs)
      ax = gca;
      ax.XAxis.TickValues = 0:9;
      ax.XTickLabel = {'','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00',''};
      ax.XTickLabelRotation = -40;

      grid on
      ylabel('{\itR}_{rs}(\lambda) (sr^{-1})','FontSize',fs)

      % 660
      annotation(h,'textbox',...
            [0.85 0.3 0.02 0.02],...
            'Color',[1 0.5 0],...
            'String',{'660'},...
            'FontSize',fs-1,...
            'FitBoxToText','off',...
            'EdgeColor',[1 1 1],...
            'BackgroundColor',[1 1 1]);
      
      % 680
      annotation(h,'textbox',...
            [0.85 0.7 0.02 0.02],...
            'Color',[1 0 0],...
            'String',{'680'},...
            'FontSize',fs-1,...
            'FitBoxToText','off',...
            'EdgeColor',[1 1 1],...
            'BackgroundColor',[1 1 1])
      saveas(gcf,[savedirname '3days_R'],'epsc')

      %% chlor_a
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      % set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      % set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      % subplot(2,2,1)
      chlor_a_day1 = [tod_chlor_a_00(1) tod_chlor_a_01(1) tod_chlor_a_02(1) tod_chlor_a_03(1) tod_chlor_a_04(1) tod_chlor_a_05(1) tod_chlor_a_06(1) tod_chlor_a_07(1)];
      chlor_a_day2 = [tod_chlor_a_00(2) tod_chlor_a_01(2) tod_chlor_a_02(2) tod_chlor_a_03(2) tod_chlor_a_04(2) tod_chlor_a_05(2) tod_chlor_a_06(2) tod_chlor_a_07(2)];
      chlor_a_day3 = [tod_chlor_a_00(3) tod_chlor_a_01(3) tod_chlor_a_02(3) tod_chlor_a_03(3) tod_chlor_a_04(3) tod_chlor_a_05(3) tod_chlor_a_06(3) tod_chlor_a_07(3)];
      plot(1:8,chlor_a_day1,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,chlor_a_day2,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,chlor_a_day3,'-^b','MarkerSize',ms,'LineWidth',lw)

      ylim([0 0.1])
      xlim([0 9])
      xlabel('Time of day (Local Time)','FontSize',fs)
      ax = gca;
      ax.XAxis.TickValues = 0:9;
      ax.XTickLabel = {'','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00',''};
      ax.XTickLabelRotation = -40;

      grid on
      ylabel('Chl-{\it}(mg m^{-3})','FontSize',fs)
      saveas(gcf,[savedirname '3days_C'],'epsc')

      % poc
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      % set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      % set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      % subplot(2,2,1)
      poc_day1 = [tod_poc_00(1) tod_poc_01(1) tod_poc_02(1) tod_poc_03(1) tod_poc_04(1) tod_poc_05(1) tod_poc_06(1) tod_poc_07(1)];
      poc_day2 = [tod_poc_00(2) tod_poc_01(2) tod_poc_02(2) tod_poc_03(2) tod_poc_04(2) tod_poc_05(2) tod_poc_06(2) tod_poc_07(2)];
      poc_day3 = [tod_poc_00(3) tod_poc_01(3) tod_poc_02(3) tod_poc_03(3) tod_poc_04(3) tod_poc_05(3) tod_poc_06(3) tod_poc_07(3)];
      plot(1:8,poc_day1,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,poc_day2,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,poc_day3,'-^b','MarkerSize',ms,'LineWidth',lw)

      ylim([0 50])
      xlim([0 9])
      xlabel('Time of day (Local Time)','FontSize',fs)
      ax = gca;
      ax.XAxis.TickValues = 0:9;
      ax.XTickLabel = {'','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00',''};
      ax.XTickLabelRotation = -40;

      grid on
      ylabel('POC (mg m^{-3})','FontSize',fs)
      saveas(gcf,[savedirname '3days_P'],'epsc')

      % ag_412_mlrc
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',['n = ' num2str(A_idx(idx)) ';idx=' num2str(idx)]);
      % set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);
      % set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
      
      % subplot(2,2,1)
      ag_412_mlrc_day1 = [tod_ag_412_mlrc_00(1) tod_ag_412_mlrc_01(1) tod_ag_412_mlrc_02(1) tod_ag_412_mlrc_03(1) tod_ag_412_mlrc_04(1) tod_ag_412_mlrc_05(1) tod_ag_412_mlrc_06(1) tod_ag_412_mlrc_07(1)];
      ag_412_mlrc_day2 = [tod_ag_412_mlrc_00(2) tod_ag_412_mlrc_01(2) tod_ag_412_mlrc_02(2) tod_ag_412_mlrc_03(2) tod_ag_412_mlrc_04(2) tod_ag_412_mlrc_05(2) tod_ag_412_mlrc_06(2) tod_ag_412_mlrc_07(2)];
      ag_412_mlrc_day3 = [tod_ag_412_mlrc_00(3) tod_ag_412_mlrc_01(3) tod_ag_412_mlrc_02(3) tod_ag_412_mlrc_03(3) tod_ag_412_mlrc_04(3) tod_ag_412_mlrc_05(3) tod_ag_412_mlrc_06(3) tod_ag_412_mlrc_07(3)];
      plot(1:8,ag_412_mlrc_day1,'-^r','MarkerSize',ms,'LineWidth',lw)
      hold on
      plot(1:8,ag_412_mlrc_day2,'-^g','MarkerSize',ms,'LineWidth',lw)
      plot(1:8,ag_412_mlrc_day3,'-^b','MarkerSize',ms,'LineWidth',lw)

      ylim([0 0.03])
      xlim([0 9])
      xlabel('Time of day (Local Time)','FontSize',fs)
      ax = gca;
      ax.XAxis.TickValues = 0:9;
      ax.XTickLabel = {'','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00',''};
      ax.XTickLabelRotation = -40;

      grid on
      ylabel('{\ita}_g(412) (m^{-1})','FontSize',fs)    
      saveas(gcf,[savedirname '3days_A'],'epsc')            
end
%% 3-day sequences stats -- Rrs
clear three_day_seq
for idx = 1:sum(three_day_idx)

      three_day_seq(idx).datetime = GOCI_DailyStatMatrix(A_idx(idx)).datetime;
      
      % Rrs
      three_day_seq(idx).tod_Rrs_412_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_00]];
      three_day_seq(idx).tod_Rrs_412_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_01]];
      three_day_seq(idx).tod_Rrs_412_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_02]];
      three_day_seq(idx).tod_Rrs_412_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_03]];
      three_day_seq(idx).tod_Rrs_412_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_04]];
      three_day_seq(idx).tod_Rrs_412_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_05]];
      three_day_seq(idx).tod_Rrs_412_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_06]];
      three_day_seq(idx).tod_Rrs_412_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_412_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_412_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_412_07]];
      
      three_day_seq(idx).tod_Rrs_443_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_00]];
      three_day_seq(idx).tod_Rrs_443_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_01]];
      three_day_seq(idx).tod_Rrs_443_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_02]];
      three_day_seq(idx).tod_Rrs_443_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_03]];
      three_day_seq(idx).tod_Rrs_443_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_04]];
      three_day_seq(idx).tod_Rrs_443_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_05]];
      three_day_seq(idx).tod_Rrs_443_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_06]];
      three_day_seq(idx).tod_Rrs_443_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_443_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_443_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_443_07]];
      
      three_day_seq(idx).tod_Rrs_490_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_00]];
      three_day_seq(idx).tod_Rrs_490_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_01]];
      three_day_seq(idx).tod_Rrs_490_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_02]];
      three_day_seq(idx).tod_Rrs_490_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_03]];
      three_day_seq(idx).tod_Rrs_490_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_04]];
      three_day_seq(idx).tod_Rrs_490_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_05]];
      three_day_seq(idx).tod_Rrs_490_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_06]];
      three_day_seq(idx).tod_Rrs_490_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_490_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_490_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_490_07]];
      
      three_day_seq(idx).tod_Rrs_555_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_00]];
      three_day_seq(idx).tod_Rrs_555_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_01]];
      three_day_seq(idx).tod_Rrs_555_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_02]];
      three_day_seq(idx).tod_Rrs_555_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_03]];
      three_day_seq(idx).tod_Rrs_555_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_04]];
      three_day_seq(idx).tod_Rrs_555_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_05]];
      three_day_seq(idx).tod_Rrs_555_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_06]];
      three_day_seq(idx).tod_Rrs_555_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_555_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_555_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_555_07]];

      three_day_seq(idx).tod_Rrs_660_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_00]];
      three_day_seq(idx).tod_Rrs_660_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_01]];
      three_day_seq(idx).tod_Rrs_660_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_02]];
      three_day_seq(idx).tod_Rrs_660_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_03]];
      three_day_seq(idx).tod_Rrs_660_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_04]];
      three_day_seq(idx).tod_Rrs_660_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_05]];
      three_day_seq(idx).tod_Rrs_660_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_06]];
      three_day_seq(idx).tod_Rrs_660_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_660_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_660_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_660_07]];
      
      three_day_seq(idx).tod_Rrs_680_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_00]];
      three_day_seq(idx).tod_Rrs_680_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_01]];
      three_day_seq(idx).tod_Rrs_680_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_02]];
      three_day_seq(idx).tod_Rrs_680_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_03]];
      three_day_seq(idx).tod_Rrs_680_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_04]];
      three_day_seq(idx).tod_Rrs_680_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_05]];
      three_day_seq(idx).tod_Rrs_680_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_06]];
      three_day_seq(idx).tod_Rrs_680_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).Rrs_680_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).Rrs_680_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).Rrs_680_07]];
      
      % mean
      three_day_seq(idx).tod_Rrs_412_00_mean = nanmean(three_day_seq(idx).tod_Rrs_412_00);
      three_day_seq(idx).tod_Rrs_412_01_mean = nanmean(three_day_seq(idx).tod_Rrs_412_01);
      three_day_seq(idx).tod_Rrs_412_02_mean = nanmean(three_day_seq(idx).tod_Rrs_412_02);
      three_day_seq(idx).tod_Rrs_412_03_mean = nanmean(three_day_seq(idx).tod_Rrs_412_03);
      three_day_seq(idx).tod_Rrs_412_04_mean = nanmean(three_day_seq(idx).tod_Rrs_412_04);
      three_day_seq(idx).tod_Rrs_412_05_mean = nanmean(three_day_seq(idx).tod_Rrs_412_05);
      three_day_seq(idx).tod_Rrs_412_06_mean = nanmean(three_day_seq(idx).tod_Rrs_412_06);
      three_day_seq(idx).tod_Rrs_412_07_mean = nanmean(three_day_seq(idx).tod_Rrs_412_07);
      three_day_seq(idx).tod_Rrs_443_00_mean = nanmean(three_day_seq(idx).tod_Rrs_443_00);
      three_day_seq(idx).tod_Rrs_443_01_mean = nanmean(three_day_seq(idx).tod_Rrs_443_01);
      three_day_seq(idx).tod_Rrs_443_02_mean = nanmean(three_day_seq(idx).tod_Rrs_443_02);
      three_day_seq(idx).tod_Rrs_443_03_mean = nanmean(three_day_seq(idx).tod_Rrs_443_03);
      three_day_seq(idx).tod_Rrs_443_04_mean = nanmean(three_day_seq(idx).tod_Rrs_443_04);
      three_day_seq(idx).tod_Rrs_443_05_mean = nanmean(three_day_seq(idx).tod_Rrs_443_05);
      three_day_seq(idx).tod_Rrs_443_06_mean = nanmean(three_day_seq(idx).tod_Rrs_443_06);
      three_day_seq(idx).tod_Rrs_443_07_mean = nanmean(three_day_seq(idx).tod_Rrs_443_07);
      three_day_seq(idx).tod_Rrs_490_00_mean = nanmean(three_day_seq(idx).tod_Rrs_490_00);
      three_day_seq(idx).tod_Rrs_490_01_mean = nanmean(three_day_seq(idx).tod_Rrs_490_01);
      three_day_seq(idx).tod_Rrs_490_02_mean = nanmean(three_day_seq(idx).tod_Rrs_490_02);
      three_day_seq(idx).tod_Rrs_490_03_mean = nanmean(three_day_seq(idx).tod_Rrs_490_03);
      three_day_seq(idx).tod_Rrs_490_04_mean = nanmean(three_day_seq(idx).tod_Rrs_490_04);
      three_day_seq(idx).tod_Rrs_490_05_mean = nanmean(three_day_seq(idx).tod_Rrs_490_05);
      three_day_seq(idx).tod_Rrs_490_06_mean = nanmean(three_day_seq(idx).tod_Rrs_490_06);
      three_day_seq(idx).tod_Rrs_490_07_mean = nanmean(three_day_seq(idx).tod_Rrs_490_07);
      three_day_seq(idx).tod_Rrs_555_00_mean = nanmean(three_day_seq(idx).tod_Rrs_555_00);
      three_day_seq(idx).tod_Rrs_555_01_mean = nanmean(three_day_seq(idx).tod_Rrs_555_01);
      three_day_seq(idx).tod_Rrs_555_02_mean = nanmean(three_day_seq(idx).tod_Rrs_555_02);
      three_day_seq(idx).tod_Rrs_555_03_mean = nanmean(three_day_seq(idx).tod_Rrs_555_03);
      three_day_seq(idx).tod_Rrs_555_04_mean = nanmean(three_day_seq(idx).tod_Rrs_555_04);
      three_day_seq(idx).tod_Rrs_555_05_mean = nanmean(three_day_seq(idx).tod_Rrs_555_05);
      three_day_seq(idx).tod_Rrs_555_06_mean = nanmean(three_day_seq(idx).tod_Rrs_555_06);
      three_day_seq(idx).tod_Rrs_555_07_mean = nanmean(three_day_seq(idx).tod_Rrs_555_07);
      three_day_seq(idx).tod_Rrs_660_00_mean = nanmean(three_day_seq(idx).tod_Rrs_660_00);
      three_day_seq(idx).tod_Rrs_660_01_mean = nanmean(three_day_seq(idx).tod_Rrs_660_01);
      three_day_seq(idx).tod_Rrs_660_02_mean = nanmean(three_day_seq(idx).tod_Rrs_660_02);
      three_day_seq(idx).tod_Rrs_660_03_mean = nanmean(three_day_seq(idx).tod_Rrs_660_03);
      three_day_seq(idx).tod_Rrs_660_04_mean = nanmean(three_day_seq(idx).tod_Rrs_660_04);
      three_day_seq(idx).tod_Rrs_660_05_mean = nanmean(three_day_seq(idx).tod_Rrs_660_05);
      three_day_seq(idx).tod_Rrs_660_06_mean = nanmean(three_day_seq(idx).tod_Rrs_660_06);
      three_day_seq(idx).tod_Rrs_660_07_mean = nanmean(three_day_seq(idx).tod_Rrs_660_07);
      three_day_seq(idx).tod_Rrs_680_00_mean = nanmean(three_day_seq(idx).tod_Rrs_680_00);
      three_day_seq(idx).tod_Rrs_680_01_mean = nanmean(three_day_seq(idx).tod_Rrs_680_01);
      three_day_seq(idx).tod_Rrs_680_02_mean = nanmean(three_day_seq(idx).tod_Rrs_680_02);
      three_day_seq(idx).tod_Rrs_680_03_mean = nanmean(three_day_seq(idx).tod_Rrs_680_03);
      three_day_seq(idx).tod_Rrs_680_04_mean = nanmean(three_day_seq(idx).tod_Rrs_680_04);
      three_day_seq(idx).tod_Rrs_680_05_mean = nanmean(three_day_seq(idx).tod_Rrs_680_05);
      three_day_seq(idx).tod_Rrs_680_06_mean = nanmean(three_day_seq(idx).tod_Rrs_680_06);
      three_day_seq(idx).tod_Rrs_680_07_mean = nanmean(three_day_seq(idx).tod_Rrs_680_07);

      % median
      three_day_seq(idx).tod_Rrs_412_00_median = nanmedian(three_day_seq(idx).tod_Rrs_412_00);
      three_day_seq(idx).tod_Rrs_412_01_median = nanmedian(three_day_seq(idx).tod_Rrs_412_01);
      three_day_seq(idx).tod_Rrs_412_02_median = nanmedian(three_day_seq(idx).tod_Rrs_412_02);
      three_day_seq(idx).tod_Rrs_412_03_median = nanmedian(three_day_seq(idx).tod_Rrs_412_03);
      three_day_seq(idx).tod_Rrs_412_04_median = nanmedian(three_day_seq(idx).tod_Rrs_412_04);
      three_day_seq(idx).tod_Rrs_412_05_median = nanmedian(three_day_seq(idx).tod_Rrs_412_05);
      three_day_seq(idx).tod_Rrs_412_06_median = nanmedian(three_day_seq(idx).tod_Rrs_412_06);
      three_day_seq(idx).tod_Rrs_412_07_median = nanmedian(three_day_seq(idx).tod_Rrs_412_07);
      three_day_seq(idx).tod_Rrs_443_00_median = nanmedian(three_day_seq(idx).tod_Rrs_443_00);
      three_day_seq(idx).tod_Rrs_443_01_median = nanmedian(three_day_seq(idx).tod_Rrs_443_01);
      three_day_seq(idx).tod_Rrs_443_02_median = nanmedian(three_day_seq(idx).tod_Rrs_443_02);
      three_day_seq(idx).tod_Rrs_443_03_median = nanmedian(three_day_seq(idx).tod_Rrs_443_03);
      three_day_seq(idx).tod_Rrs_443_04_median = nanmedian(three_day_seq(idx).tod_Rrs_443_04);
      three_day_seq(idx).tod_Rrs_443_05_median = nanmedian(three_day_seq(idx).tod_Rrs_443_05);
      three_day_seq(idx).tod_Rrs_443_06_median = nanmedian(three_day_seq(idx).tod_Rrs_443_06);
      three_day_seq(idx).tod_Rrs_443_07_median = nanmedian(three_day_seq(idx).tod_Rrs_443_07);
      three_day_seq(idx).tod_Rrs_490_00_median = nanmedian(three_day_seq(idx).tod_Rrs_490_00);
      three_day_seq(idx).tod_Rrs_490_01_median = nanmedian(three_day_seq(idx).tod_Rrs_490_01);
      three_day_seq(idx).tod_Rrs_490_02_median = nanmedian(three_day_seq(idx).tod_Rrs_490_02);
      three_day_seq(idx).tod_Rrs_490_03_median = nanmedian(three_day_seq(idx).tod_Rrs_490_03);
      three_day_seq(idx).tod_Rrs_490_04_median = nanmedian(three_day_seq(idx).tod_Rrs_490_04);
      three_day_seq(idx).tod_Rrs_490_05_median = nanmedian(three_day_seq(idx).tod_Rrs_490_05);
      three_day_seq(idx).tod_Rrs_490_06_median = nanmedian(three_day_seq(idx).tod_Rrs_490_06);
      three_day_seq(idx).tod_Rrs_490_07_median = nanmedian(three_day_seq(idx).tod_Rrs_490_07);
      three_day_seq(idx).tod_Rrs_555_00_median = nanmedian(three_day_seq(idx).tod_Rrs_555_00);
      three_day_seq(idx).tod_Rrs_555_01_median = nanmedian(three_day_seq(idx).tod_Rrs_555_01);
      three_day_seq(idx).tod_Rrs_555_02_median = nanmedian(three_day_seq(idx).tod_Rrs_555_02);
      three_day_seq(idx).tod_Rrs_555_03_median = nanmedian(three_day_seq(idx).tod_Rrs_555_03);
      three_day_seq(idx).tod_Rrs_555_04_median = nanmedian(three_day_seq(idx).tod_Rrs_555_04);
      three_day_seq(idx).tod_Rrs_555_05_median = nanmedian(three_day_seq(idx).tod_Rrs_555_05);
      three_day_seq(idx).tod_Rrs_555_06_median = nanmedian(three_day_seq(idx).tod_Rrs_555_06);
      three_day_seq(idx).tod_Rrs_555_07_median = nanmedian(three_day_seq(idx).tod_Rrs_555_07);
      three_day_seq(idx).tod_Rrs_660_00_median = nanmedian(three_day_seq(idx).tod_Rrs_660_00);
      three_day_seq(idx).tod_Rrs_660_01_median = nanmedian(three_day_seq(idx).tod_Rrs_660_01);
      three_day_seq(idx).tod_Rrs_660_02_median = nanmedian(three_day_seq(idx).tod_Rrs_660_02);
      three_day_seq(idx).tod_Rrs_660_03_median = nanmedian(three_day_seq(idx).tod_Rrs_660_03);
      three_day_seq(idx).tod_Rrs_660_04_median = nanmedian(three_day_seq(idx).tod_Rrs_660_04);
      three_day_seq(idx).tod_Rrs_660_05_median = nanmedian(three_day_seq(idx).tod_Rrs_660_05);
      three_day_seq(idx).tod_Rrs_660_06_median = nanmedian(three_day_seq(idx).tod_Rrs_660_06);
      three_day_seq(idx).tod_Rrs_660_07_median = nanmedian(three_day_seq(idx).tod_Rrs_660_07);
      three_day_seq(idx).tod_Rrs_680_00_median = nanmedian(three_day_seq(idx).tod_Rrs_680_00);
      three_day_seq(idx).tod_Rrs_680_01_median = nanmedian(three_day_seq(idx).tod_Rrs_680_01);
      three_day_seq(idx).tod_Rrs_680_02_median = nanmedian(three_day_seq(idx).tod_Rrs_680_02);
      three_day_seq(idx).tod_Rrs_680_03_median = nanmedian(three_day_seq(idx).tod_Rrs_680_03);
      three_day_seq(idx).tod_Rrs_680_04_median = nanmedian(three_day_seq(idx).tod_Rrs_680_04);
      three_day_seq(idx).tod_Rrs_680_05_median = nanmedian(three_day_seq(idx).tod_Rrs_680_05);
      three_day_seq(idx).tod_Rrs_680_06_median = nanmedian(three_day_seq(idx).tod_Rrs_680_06);
      three_day_seq(idx).tod_Rrs_680_07_median = nanmedian(three_day_seq(idx).tod_Rrs_680_07);
      
      % SD
      three_day_seq(idx).tod_Rrs_412_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_00);
      three_day_seq(idx).tod_Rrs_412_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_01);
      three_day_seq(idx).tod_Rrs_412_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_02);
      three_day_seq(idx).tod_Rrs_412_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_03);
      three_day_seq(idx).tod_Rrs_412_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_04);
      three_day_seq(idx).tod_Rrs_412_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_05);
      three_day_seq(idx).tod_Rrs_412_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_06);
      three_day_seq(idx).tod_Rrs_412_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_07);
      three_day_seq(idx).tod_Rrs_443_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_00);
      three_day_seq(idx).tod_Rrs_443_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_01);
      three_day_seq(idx).tod_Rrs_443_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_02);
      three_day_seq(idx).tod_Rrs_443_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_03);
      three_day_seq(idx).tod_Rrs_443_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_04);
      three_day_seq(idx).tod_Rrs_443_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_05);
      three_day_seq(idx).tod_Rrs_443_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_06);
      three_day_seq(idx).tod_Rrs_443_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_07);
      three_day_seq(idx).tod_Rrs_490_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_00);
      three_day_seq(idx).tod_Rrs_490_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_01);
      three_day_seq(idx).tod_Rrs_490_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_02);
      three_day_seq(idx).tod_Rrs_490_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_03);
      three_day_seq(idx).tod_Rrs_490_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_04);
      three_day_seq(idx).tod_Rrs_490_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_05);
      three_day_seq(idx).tod_Rrs_490_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_06);
      three_day_seq(idx).tod_Rrs_490_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_07);
      three_day_seq(idx).tod_Rrs_555_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_00);
      three_day_seq(idx).tod_Rrs_555_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_01);
      three_day_seq(idx).tod_Rrs_555_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_02);
      three_day_seq(idx).tod_Rrs_555_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_03);
      three_day_seq(idx).tod_Rrs_555_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_04);
      three_day_seq(idx).tod_Rrs_555_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_05);
      three_day_seq(idx).tod_Rrs_555_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_06);
      three_day_seq(idx).tod_Rrs_555_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_07);
      three_day_seq(idx).tod_Rrs_660_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_00);
      three_day_seq(idx).tod_Rrs_660_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_01);
      three_day_seq(idx).tod_Rrs_660_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_02);
      three_day_seq(idx).tod_Rrs_660_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_03);
      three_day_seq(idx).tod_Rrs_660_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_04);
      three_day_seq(idx).tod_Rrs_660_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_05);
      three_day_seq(idx).tod_Rrs_660_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_06);
      three_day_seq(idx).tod_Rrs_660_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_07);
      three_day_seq(idx).tod_Rrs_680_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_00);
      three_day_seq(idx).tod_Rrs_680_01_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_01);
      three_day_seq(idx).tod_Rrs_680_02_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_02);
      three_day_seq(idx).tod_Rrs_680_03_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_03);
      three_day_seq(idx).tod_Rrs_680_04_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_04);
      three_day_seq(idx).tod_Rrs_680_05_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_05);
      three_day_seq(idx).tod_Rrs_680_06_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_06);
      three_day_seq(idx).tod_Rrs_680_07_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_07);
      
      % CV
      three_day_seq(idx).tod_Rrs_412_00_CV = three_day_seq(idx).tod_Rrs_412_00_stdv/three_day_seq(idx).tod_Rrs_412_00_mean;
      three_day_seq(idx).tod_Rrs_412_01_CV = three_day_seq(idx).tod_Rrs_412_01_stdv/three_day_seq(idx).tod_Rrs_412_01_mean;
      three_day_seq(idx).tod_Rrs_412_02_CV = three_day_seq(idx).tod_Rrs_412_02_stdv/three_day_seq(idx).tod_Rrs_412_02_mean;
      three_day_seq(idx).tod_Rrs_412_03_CV = three_day_seq(idx).tod_Rrs_412_03_stdv/three_day_seq(idx).tod_Rrs_412_03_mean;
      three_day_seq(idx).tod_Rrs_412_04_CV = three_day_seq(idx).tod_Rrs_412_04_stdv/three_day_seq(idx).tod_Rrs_412_04_mean;
      three_day_seq(idx).tod_Rrs_412_05_CV = three_day_seq(idx).tod_Rrs_412_05_stdv/three_day_seq(idx).tod_Rrs_412_05_mean;
      three_day_seq(idx).tod_Rrs_412_06_CV = three_day_seq(idx).tod_Rrs_412_06_stdv/three_day_seq(idx).tod_Rrs_412_06_mean;
      three_day_seq(idx).tod_Rrs_412_07_CV = three_day_seq(idx).tod_Rrs_412_07_stdv/three_day_seq(idx).tod_Rrs_412_07_mean;
      three_day_seq(idx).tod_Rrs_443_00_CV = three_day_seq(idx).tod_Rrs_443_00_stdv/three_day_seq(idx).tod_Rrs_443_00_mean;
      three_day_seq(idx).tod_Rrs_443_01_CV = three_day_seq(idx).tod_Rrs_443_01_stdv/three_day_seq(idx).tod_Rrs_443_01_mean;
      three_day_seq(idx).tod_Rrs_443_02_CV = three_day_seq(idx).tod_Rrs_443_02_stdv/three_day_seq(idx).tod_Rrs_443_02_mean;
      three_day_seq(idx).tod_Rrs_443_03_CV = three_day_seq(idx).tod_Rrs_443_03_stdv/three_day_seq(idx).tod_Rrs_443_03_mean;
      three_day_seq(idx).tod_Rrs_443_04_CV = three_day_seq(idx).tod_Rrs_443_04_stdv/three_day_seq(idx).tod_Rrs_443_04_mean;
      three_day_seq(idx).tod_Rrs_443_05_CV = three_day_seq(idx).tod_Rrs_443_05_stdv/three_day_seq(idx).tod_Rrs_443_05_mean;
      three_day_seq(idx).tod_Rrs_443_06_CV = three_day_seq(idx).tod_Rrs_443_06_stdv/three_day_seq(idx).tod_Rrs_443_06_mean;
      three_day_seq(idx).tod_Rrs_443_07_CV = three_day_seq(idx).tod_Rrs_443_07_stdv/three_day_seq(idx).tod_Rrs_443_07_mean;
      three_day_seq(idx).tod_Rrs_490_00_CV = three_day_seq(idx).tod_Rrs_490_00_stdv/three_day_seq(idx).tod_Rrs_490_00_mean;
      three_day_seq(idx).tod_Rrs_490_01_CV = three_day_seq(idx).tod_Rrs_490_01_stdv/three_day_seq(idx).tod_Rrs_490_01_mean;
      three_day_seq(idx).tod_Rrs_490_02_CV = three_day_seq(idx).tod_Rrs_490_02_stdv/three_day_seq(idx).tod_Rrs_490_02_mean;
      three_day_seq(idx).tod_Rrs_490_03_CV = three_day_seq(idx).tod_Rrs_490_03_stdv/three_day_seq(idx).tod_Rrs_490_03_mean;
      three_day_seq(idx).tod_Rrs_490_04_CV = three_day_seq(idx).tod_Rrs_490_04_stdv/three_day_seq(idx).tod_Rrs_490_04_mean;
      three_day_seq(idx).tod_Rrs_490_05_CV = three_day_seq(idx).tod_Rrs_490_05_stdv/three_day_seq(idx).tod_Rrs_490_05_mean;
      three_day_seq(idx).tod_Rrs_490_06_CV = three_day_seq(idx).tod_Rrs_490_06_stdv/three_day_seq(idx).tod_Rrs_490_06_mean;
      three_day_seq(idx).tod_Rrs_490_07_CV = three_day_seq(idx).tod_Rrs_490_07_stdv/three_day_seq(idx).tod_Rrs_490_07_mean;
      three_day_seq(idx).tod_Rrs_555_00_CV = three_day_seq(idx).tod_Rrs_555_00_stdv/three_day_seq(idx).tod_Rrs_555_00_mean;
      three_day_seq(idx).tod_Rrs_555_01_CV = three_day_seq(idx).tod_Rrs_555_01_stdv/three_day_seq(idx).tod_Rrs_555_01_mean;
      three_day_seq(idx).tod_Rrs_555_02_CV = three_day_seq(idx).tod_Rrs_555_02_stdv/three_day_seq(idx).tod_Rrs_555_02_mean;
      three_day_seq(idx).tod_Rrs_555_03_CV = three_day_seq(idx).tod_Rrs_555_03_stdv/three_day_seq(idx).tod_Rrs_555_03_mean;
      three_day_seq(idx).tod_Rrs_555_04_CV = three_day_seq(idx).tod_Rrs_555_04_stdv/three_day_seq(idx).tod_Rrs_555_04_mean;
      three_day_seq(idx).tod_Rrs_555_05_CV = three_day_seq(idx).tod_Rrs_555_05_stdv/three_day_seq(idx).tod_Rrs_555_05_mean;
      three_day_seq(idx).tod_Rrs_555_06_CV = three_day_seq(idx).tod_Rrs_555_06_stdv/three_day_seq(idx).tod_Rrs_555_06_mean;
      three_day_seq(idx).tod_Rrs_555_07_CV = three_day_seq(idx).tod_Rrs_555_07_stdv/three_day_seq(idx).tod_Rrs_555_07_mean;
      three_day_seq(idx).tod_Rrs_660_00_CV = three_day_seq(idx).tod_Rrs_660_00_stdv/three_day_seq(idx).tod_Rrs_660_00_mean;
      three_day_seq(idx).tod_Rrs_660_01_CV = three_day_seq(idx).tod_Rrs_660_01_stdv/three_day_seq(idx).tod_Rrs_660_01_mean;
      three_day_seq(idx).tod_Rrs_660_02_CV = three_day_seq(idx).tod_Rrs_660_02_stdv/three_day_seq(idx).tod_Rrs_660_02_mean;
      three_day_seq(idx).tod_Rrs_660_03_CV = three_day_seq(idx).tod_Rrs_660_03_stdv/three_day_seq(idx).tod_Rrs_660_03_mean;
      three_day_seq(idx).tod_Rrs_660_04_CV = three_day_seq(idx).tod_Rrs_660_04_stdv/three_day_seq(idx).tod_Rrs_660_04_mean;
      three_day_seq(idx).tod_Rrs_660_05_CV = three_day_seq(idx).tod_Rrs_660_05_stdv/three_day_seq(idx).tod_Rrs_660_05_mean;
      three_day_seq(idx).tod_Rrs_660_06_CV = three_day_seq(idx).tod_Rrs_660_06_stdv/three_day_seq(idx).tod_Rrs_660_06_mean;
      three_day_seq(idx).tod_Rrs_660_07_CV = three_day_seq(idx).tod_Rrs_660_07_stdv/three_day_seq(idx).tod_Rrs_660_07_mean;
      three_day_seq(idx).tod_Rrs_680_00_CV = three_day_seq(idx).tod_Rrs_680_00_stdv/three_day_seq(idx).tod_Rrs_680_00_mean;
      three_day_seq(idx).tod_Rrs_680_01_CV = three_day_seq(idx).tod_Rrs_680_01_stdv/three_day_seq(idx).tod_Rrs_680_01_mean;
      three_day_seq(idx).tod_Rrs_680_02_CV = three_day_seq(idx).tod_Rrs_680_02_stdv/three_day_seq(idx).tod_Rrs_680_02_mean;
      three_day_seq(idx).tod_Rrs_680_03_CV = three_day_seq(idx).tod_Rrs_680_03_stdv/three_day_seq(idx).tod_Rrs_680_03_mean;
      three_day_seq(idx).tod_Rrs_680_04_CV = three_day_seq(idx).tod_Rrs_680_04_stdv/three_day_seq(idx).tod_Rrs_680_04_mean;
      three_day_seq(idx).tod_Rrs_680_05_CV = three_day_seq(idx).tod_Rrs_680_05_stdv/three_day_seq(idx).tod_Rrs_680_05_mean;
      three_day_seq(idx).tod_Rrs_680_06_CV = three_day_seq(idx).tod_Rrs_680_06_stdv/three_day_seq(idx).tod_Rrs_680_06_mean;
      three_day_seq(idx).tod_Rrs_680_07_CV = three_day_seq(idx).tod_Rrs_680_07_stdv/three_day_seq(idx).tod_Rrs_680_07_mean;

      %% for all 24 points per sequence

      three_day_seq(idx).tod_Rrs_412_All = [three_day_seq(idx).tod_Rrs_412_00 three_day_seq(idx).tod_Rrs_412_01 three_day_seq(idx).tod_Rrs_412_02 ...
                                                three_day_seq(idx).tod_Rrs_412_03 three_day_seq(idx).tod_Rrs_412_04 three_day_seq(idx).tod_Rrs_412_05 ...
                                                three_day_seq(idx).tod_Rrs_412_06 three_day_seq(idx).tod_Rrs_412_07];

      three_day_seq(idx).tod_Rrs_443_All = [three_day_seq(idx).tod_Rrs_443_00 three_day_seq(idx).tod_Rrs_443_01 three_day_seq(idx).tod_Rrs_443_02 ...
                                                three_day_seq(idx).tod_Rrs_443_03 three_day_seq(idx).tod_Rrs_443_04 three_day_seq(idx).tod_Rrs_443_05 ...
                                                three_day_seq(idx).tod_Rrs_443_06 three_day_seq(idx).tod_Rrs_443_07];
      
      three_day_seq(idx).tod_Rrs_490_All = [three_day_seq(idx).tod_Rrs_490_00 three_day_seq(idx).tod_Rrs_490_01 three_day_seq(idx).tod_Rrs_490_02 ...
                                                three_day_seq(idx).tod_Rrs_490_03 three_day_seq(idx).tod_Rrs_490_04 three_day_seq(idx).tod_Rrs_490_05 ...
                                                three_day_seq(idx).tod_Rrs_490_06 three_day_seq(idx).tod_Rrs_490_07];

      three_day_seq(idx).tod_Rrs_555_All = [three_day_seq(idx).tod_Rrs_555_00 three_day_seq(idx).tod_Rrs_555_01 three_day_seq(idx).tod_Rrs_555_02 ...
                                                three_day_seq(idx).tod_Rrs_555_03 three_day_seq(idx).tod_Rrs_555_04 three_day_seq(idx).tod_Rrs_555_05 ...
                                                three_day_seq(idx).tod_Rrs_555_06 three_day_seq(idx).tod_Rrs_555_07];

      three_day_seq(idx).tod_Rrs_660_All = [three_day_seq(idx).tod_Rrs_660_00 three_day_seq(idx).tod_Rrs_660_01 three_day_seq(idx).tod_Rrs_660_02 ...
                                                three_day_seq(idx).tod_Rrs_660_03 three_day_seq(idx).tod_Rrs_660_04 three_day_seq(idx).tod_Rrs_660_05 ...
                                                three_day_seq(idx).tod_Rrs_660_06 three_day_seq(idx).tod_Rrs_660_07];

      three_day_seq(idx).tod_Rrs_680_All = [three_day_seq(idx).tod_Rrs_680_00 three_day_seq(idx).tod_Rrs_680_01 three_day_seq(idx).tod_Rrs_680_02 ...
                                                three_day_seq(idx).tod_Rrs_680_03 three_day_seq(idx).tod_Rrs_680_04 three_day_seq(idx).tod_Rrs_680_05 ...
                                                three_day_seq(idx).tod_Rrs_680_06 three_day_seq(idx).tod_Rrs_680_07];

      three_day_seq(idx).tod_Rrs_412_All_mean = nanmean(three_day_seq(idx).tod_Rrs_412_All);
      three_day_seq(idx).tod_Rrs_443_All_mean = nanmean(three_day_seq(idx).tod_Rrs_443_All);
      three_day_seq(idx).tod_Rrs_490_All_mean = nanmean(three_day_seq(idx).tod_Rrs_490_All);
      three_day_seq(idx).tod_Rrs_555_All_mean = nanmean(three_day_seq(idx).tod_Rrs_555_All);
      three_day_seq(idx).tod_Rrs_660_All_mean = nanmean(three_day_seq(idx).tod_Rrs_660_All);
      three_day_seq(idx).tod_Rrs_680_All_mean = nanmean(three_day_seq(idx).tod_Rrs_680_All);    
      
      three_day_seq(idx).tod_Rrs_412_All_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_All);
      three_day_seq(idx).tod_Rrs_443_All_stdv = nanstd(three_day_seq(idx).tod_Rrs_443_All);
      three_day_seq(idx).tod_Rrs_490_All_stdv = nanstd(three_day_seq(idx).tod_Rrs_490_All);
      three_day_seq(idx).tod_Rrs_555_All_stdv = nanstd(three_day_seq(idx).tod_Rrs_555_All);
      three_day_seq(idx).tod_Rrs_660_All_stdv = nanstd(three_day_seq(idx).tod_Rrs_660_All);
      three_day_seq(idx).tod_Rrs_680_All_stdv = nanstd(three_day_seq(idx).tod_Rrs_680_All); 
      
      three_day_seq(idx).tod_Rrs_412_All_CV = three_day_seq(idx).tod_Rrs_412_All_stdv/three_day_seq(idx).tod_Rrs_412_All_mean;
      three_day_seq(idx).tod_Rrs_443_All_CV = three_day_seq(idx).tod_Rrs_443_All_stdv/three_day_seq(idx).tod_Rrs_443_All_mean;
      three_day_seq(idx).tod_Rrs_490_All_CV = three_day_seq(idx).tod_Rrs_490_All_stdv/three_day_seq(idx).tod_Rrs_490_All_mean;
      three_day_seq(idx).tod_Rrs_555_All_CV = three_day_seq(idx).tod_Rrs_555_All_stdv/three_day_seq(idx).tod_Rrs_555_All_mean;
      three_day_seq(idx).tod_Rrs_660_All_CV = three_day_seq(idx).tod_Rrs_660_All_stdv/three_day_seq(idx).tod_Rrs_660_All_mean;
      three_day_seq(idx).tod_Rrs_680_All_CV = three_day_seq(idx).tod_Rrs_680_All_stdv/three_day_seq(idx).tod_Rrs_680_All_mean; 
      
      three_day_seq(idx).tod_Rrs_412_All_median = nanmedian(three_day_seq(idx).tod_Rrs_412_All);
      three_day_seq(idx).tod_Rrs_443_All_median = nanmedian(three_day_seq(idx).tod_Rrs_443_All);
      three_day_seq(idx).tod_Rrs_490_All_median = nanmedian(three_day_seq(idx).tod_Rrs_490_All);
      three_day_seq(idx).tod_Rrs_555_All_median = nanmedian(three_day_seq(idx).tod_Rrs_555_All);
      three_day_seq(idx).tod_Rrs_660_All_median = nanmedian(three_day_seq(idx).tod_Rrs_660_All);
      three_day_seq(idx).tod_Rrs_680_All_median = nanmedian(three_day_seq(idx).tod_Rrs_680_All);  

      % Normality test
      [three_day_seq(idx).tod_Rrs_412_All_H,three_day_seq(idx).tod_Rrs_412_All_P] = kstest((three_day_seq(idx).tod_Rrs_412_All-three_day_seq(idx).tod_Rrs_412_All_mean)/three_day_seq(idx).tod_Rrs_412_All_stdv);
      [three_day_seq(idx).tod_Rrs_443_All_H,three_day_seq(idx).tod_Rrs_443_All_P] = kstest((three_day_seq(idx).tod_Rrs_443_All-three_day_seq(idx).tod_Rrs_443_All_mean)/three_day_seq(idx).tod_Rrs_443_All_stdv);
      [three_day_seq(idx).tod_Rrs_490_All_H,three_day_seq(idx).tod_Rrs_490_All_P] = kstest((three_day_seq(idx).tod_Rrs_490_All-three_day_seq(idx).tod_Rrs_490_All_mean)/three_day_seq(idx).tod_Rrs_490_All_stdv);
      [three_day_seq(idx).tod_Rrs_555_All_H,three_day_seq(idx).tod_Rrs_555_All_P] = kstest((three_day_seq(idx).tod_Rrs_555_All-three_day_seq(idx).tod_Rrs_555_All_mean)/three_day_seq(idx).tod_Rrs_555_All_stdv);
      [three_day_seq(idx).tod_Rrs_660_All_H,three_day_seq(idx).tod_Rrs_660_All_P] = kstest((three_day_seq(idx).tod_Rrs_660_All-three_day_seq(idx).tod_Rrs_660_All_mean)/three_day_seq(idx).tod_Rrs_660_All_stdv);
      [three_day_seq(idx).tod_Rrs_680_All_H,three_day_seq(idx).tod_Rrs_680_All_P] = kstest((three_day_seq(idx).tod_Rrs_680_All-three_day_seq(idx).tod_Rrs_680_All_mean)/three_day_seq(idx).tod_Rrs_680_All_stdv);
      
end

%% Plot All CV_3-day vs seq number
lw = 2;
fs = 32;

h = figure('Color','white','DefaultAxesFontSize',fs);

cond0 = [three_day_seq.tod_Rrs_412_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_Rrs_412_All_CV = nan;
end
plot(100*[three_day_seq.tod_Rrs_412_All_CV],'LineWidth',lw,'Color',[0.5 0 0.5])
hold on

cond0 = [three_day_seq.tod_Rrs_443_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_Rrs_443_All_CV = nan;
end
plot(100*[three_day_seq.tod_Rrs_443_All_CV],'LineWidth',lw,'Color',[0 0 1])

cond0 = [three_day_seq.tod_Rrs_490_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_Rrs_490_All_CV = nan;
end
plot(100*[three_day_seq.tod_Rrs_490_All_CV],'LineWidth',lw,'Color',[0 0.5 1])

cond0 = [three_day_seq.tod_Rrs_555_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_Rrs_555_All_CV = nan;
end
plot(100*[three_day_seq.tod_Rrs_555_All_CV],'LineWidth',lw,'Color',[0 0.5 0])

cond0 = [three_day_seq.tod_Rrs_660_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_Rrs_660_All_CV = nan;
end
plot(100*[three_day_seq.tod_Rrs_660_All_CV],'LineWidth',lw,'Color',[1 0.5 0])

cond0 = [three_day_seq.tod_Rrs_680_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_Rrs_680_All_CV = nan;
end
plot(100*[three_day_seq.tod_Rrs_680_All_CV],'LineWidth',lw,'Color',[1 0 0])

xlabel('Sequence Number')
ylabel('CV[%]_{3-day} (%)')

legend('{\itR}_{rs}(412){    }','{\itR}_{rs}(443){    }','{\itR}_{rs}(490){    }','{\itR}_{rs}(555){    }','{\itR}_{rs}(660){    }','{\itR}_{rs}(680){    }','Orientation','horizontal','Location','northoutside')
legend boxoff 

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname '3dayseq_all_vs_seqnum'],'epsc')

%% Plot All CV_3-day vs Date
lw = 2;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot([three_day_seq.datetime],100*[three_day_seq.tod_Rrs_412_All_CV],'LineWidth',lw,'Color',[0.5 0 0.5])
hold on
plot([three_day_seq.datetime],100*[three_day_seq.tod_Rrs_443_All_CV],'LineWidth',lw,'Color',[0 0 1])
plot([three_day_seq.datetime],100*[three_day_seq.tod_Rrs_490_All_CV],'LineWidth',lw,'Color',[0 0.5 1])
plot([three_day_seq.datetime],100*[three_day_seq.tod_Rrs_555_All_CV],'LineWidth',lw,'Color',[0 0.5 0])
plot([three_day_seq.datetime],100*[three_day_seq.tod_Rrs_660_All_CV],'LineWidth',lw,'Color',[1 0.5 0])
plot([three_day_seq.datetime],100*[three_day_seq.tod_Rrs_680_All_CV],'LineWidth',lw,'Color',[1 0 0])

xlabel('Date')
ylabel('CV[%]_{3-day} All')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname '3dayseq_all_vs_date'],'epsc')


%% Plot All  stats for CV_3-day vs spectral
three_day_seq_mean = 100*[nanmean([three_day_seq.tod_Rrs_412_All_CV]) nanmean([three_day_seq.tod_Rrs_443_All_CV]) nanmean([three_day_seq.tod_Rrs_490_All_CV]) ...
                        nanmean([three_day_seq.tod_Rrs_555_All_CV]) nanmean([three_day_seq.tod_Rrs_660_All_CV]) nanmean([three_day_seq.tod_Rrs_680_All_CV])];

three_day_seq_median = 100*[nanmedian([three_day_seq.tod_Rrs_412_All_CV]) nanmedian([three_day_seq.tod_Rrs_443_All_CV]) nanmedian([three_day_seq.tod_Rrs_490_All_CV]) ...
                        nanmedian([three_day_seq.tod_Rrs_555_All_CV]) nanmedian([three_day_seq.tod_Rrs_660_All_CV]) nanmedian([three_day_seq.tod_Rrs_680_All_CV])];

three_day_seq_std = 100*[nanstd([three_day_seq.tod_Rrs_412_All_CV]) nanstd([three_day_seq.tod_Rrs_443_All_CV]) nanstd([three_day_seq.tod_Rrs_490_All_CV]) ...
                        nanstd([three_day_seq.tod_Rrs_555_All_CV]) nanstd([three_day_seq.tod_Rrs_660_All_CV]) nanstd([three_day_seq.tod_Rrs_680_All_CV])];

three_day_seq_min = 100*[nanmin([three_day_seq.tod_Rrs_412_All_CV]) nanmin([three_day_seq.tod_Rrs_443_All_CV]) nanmin([three_day_seq.tod_Rrs_490_All_CV]) ...
                        nanmin([three_day_seq.tod_Rrs_555_All_CV]) nanmin([three_day_seq.tod_Rrs_660_All_CV]) nanmin([three_day_seq.tod_Rrs_680_All_CV])];

three_day_seq_max = 100*[nanmax([three_day_seq.tod_Rrs_412_All_CV]) nanmax([three_day_seq.tod_Rrs_443_All_CV]) nanmax([three_day_seq.tod_Rrs_490_All_CV]) ...
                        nanmax([three_day_seq.tod_Rrs_555_All_CV]) nanmax([three_day_seq.tod_Rrs_660_All_CV]) nanmax([three_day_seq.tod_Rrs_680_All_CV])];                                                

h = figure('Color','white','DefaultAxesFontSize',fs,'Name','412');
plot([412 443 490 555 660 680],three_day_seq_mean,'-ok','LineWidth',2.0)
hold on
plot([412 443 490 555 660 680],three_day_seq_median,'--ok','LineWidth',2.0)
plot([412 443 490 555 660 680],three_day_seq_mean+three_day_seq_std,'-ok')
plot([412 443 490 555 660 680],three_day_seq_mean-three_day_seq_std,'-ok')
plot([412 443 490 555 660 680],three_day_seq_min,'--ok')
plot([412 443 490 555 660 680],three_day_seq_max,'--ok')

xlabel('Wavelength (nm)')
ylabel('CV[%]_{3-day} (%)')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname '3dayseq_all_CVstats'],'epsc')

%% 3-day sequences stats -- par

for idx = 1:sum(three_day_idx)
      
      % par
      three_day_seq(idx).tod_chlor_a_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_00]];
      three_day_seq(idx).tod_chlor_a_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_01]];
      three_day_seq(idx).tod_chlor_a_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_02]];
      three_day_seq(idx).tod_chlor_a_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_03]];
      three_day_seq(idx).tod_chlor_a_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_04]];
      three_day_seq(idx).tod_chlor_a_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_05]];
      three_day_seq(idx).tod_chlor_a_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_06]];
      three_day_seq(idx).tod_chlor_a_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).chlor_a_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).chlor_a_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).chlor_a_07]];
      
      three_day_seq(idx).tod_ag_412_mlrc_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_00]];
      three_day_seq(idx).tod_ag_412_mlrc_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_01]];
      three_day_seq(idx).tod_ag_412_mlrc_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_02]];
      three_day_seq(idx).tod_ag_412_mlrc_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_03]];
      three_day_seq(idx).tod_ag_412_mlrc_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_04]];
      three_day_seq(idx).tod_ag_412_mlrc_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_05]];
      three_day_seq(idx).tod_ag_412_mlrc_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_06]];
      three_day_seq(idx).tod_ag_412_mlrc_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).ag_412_mlrc_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).ag_412_mlrc_07]];
      
      three_day_seq(idx).tod_poc_00 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_00] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_00] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_00]];
      three_day_seq(idx).tod_poc_01 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_01] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_01] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_01]];
      three_day_seq(idx).tod_poc_02 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_02] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_02] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_02]];
      three_day_seq(idx).tod_poc_03 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_03] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_03] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_03]];
      three_day_seq(idx).tod_poc_04 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_04] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_04] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_04]];
      three_day_seq(idx).tod_poc_05 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_05] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_05] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_05]];
      three_day_seq(idx).tod_poc_06 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_06] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_06] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_06]];
      three_day_seq(idx).tod_poc_07 = [[GOCI_DailyStatMatrix(A_idx(idx)).poc_07] [GOCI_DailyStatMatrix(A_idx(idx)+1).poc_07] [GOCI_DailyStatMatrix(A_idx(idx)+2).poc_07]];
      
      % mean
      three_day_seq(idx).tod_chlor_a_00_mean = nanmean(three_day_seq(idx).tod_chlor_a_00);
      three_day_seq(idx).tod_chlor_a_01_mean = nanmean(three_day_seq(idx).tod_chlor_a_01);
      three_day_seq(idx).tod_chlor_a_02_mean = nanmean(three_day_seq(idx).tod_chlor_a_02);
      three_day_seq(idx).tod_chlor_a_03_mean = nanmean(three_day_seq(idx).tod_chlor_a_03);
      three_day_seq(idx).tod_chlor_a_04_mean = nanmean(three_day_seq(idx).tod_chlor_a_04);
      three_day_seq(idx).tod_chlor_a_05_mean = nanmean(three_day_seq(idx).tod_chlor_a_05);
      three_day_seq(idx).tod_chlor_a_06_mean = nanmean(three_day_seq(idx).tod_chlor_a_06);
      three_day_seq(idx).tod_chlor_a_07_mean = nanmean(three_day_seq(idx).tod_chlor_a_07);
      
      three_day_seq(idx).tod_ag_412_mlrc_00_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_00);
      three_day_seq(idx).tod_ag_412_mlrc_01_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_01);
      three_day_seq(idx).tod_ag_412_mlrc_02_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_02);
      three_day_seq(idx).tod_ag_412_mlrc_03_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_03);
      three_day_seq(idx).tod_ag_412_mlrc_04_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_04);
      three_day_seq(idx).tod_ag_412_mlrc_05_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_05);
      three_day_seq(idx).tod_ag_412_mlrc_06_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_06);
      three_day_seq(idx).tod_ag_412_mlrc_07_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_07);
      
      three_day_seq(idx).tod_poc_00_mean = nanmean(three_day_seq(idx).tod_poc_00);
      three_day_seq(idx).tod_poc_01_mean = nanmean(three_day_seq(idx).tod_poc_01);
      three_day_seq(idx).tod_poc_02_mean = nanmean(three_day_seq(idx).tod_poc_02);
      three_day_seq(idx).tod_poc_03_mean = nanmean(three_day_seq(idx).tod_poc_03);
      three_day_seq(idx).tod_poc_04_mean = nanmean(three_day_seq(idx).tod_poc_04);
      three_day_seq(idx).tod_poc_05_mean = nanmean(three_day_seq(idx).tod_poc_05);
      three_day_seq(idx).tod_poc_06_mean = nanmean(three_day_seq(idx).tod_poc_06);
      three_day_seq(idx).tod_poc_07_mean = nanmean(three_day_seq(idx).tod_poc_07);
      
      % SD
      three_day_seq(idx).tod_chlor_a_00_stdv = nanstd(three_day_seq(idx).tod_chlor_a_00);
      three_day_seq(idx).tod_chlor_a_01_stdv = nanstd(three_day_seq(idx).tod_chlor_a_01);
      three_day_seq(idx).tod_chlor_a_02_stdv = nanstd(three_day_seq(idx).tod_chlor_a_02);
      three_day_seq(idx).tod_chlor_a_03_stdv = nanstd(three_day_seq(idx).tod_chlor_a_03);
      three_day_seq(idx).tod_chlor_a_04_stdv = nanstd(three_day_seq(idx).tod_chlor_a_04);
      three_day_seq(idx).tod_chlor_a_05_stdv = nanstd(three_day_seq(idx).tod_chlor_a_05);
      three_day_seq(idx).tod_chlor_a_06_stdv = nanstd(three_day_seq(idx).tod_chlor_a_06);
      three_day_seq(idx).tod_chlor_a_07_stdv = nanstd(three_day_seq(idx).tod_chlor_a_07);
      
      three_day_seq(idx).tod_ag_412_mlrc_00_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_00);
      three_day_seq(idx).tod_ag_412_mlrc_01_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_01);
      three_day_seq(idx).tod_ag_412_mlrc_02_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_02);
      three_day_seq(idx).tod_ag_412_mlrc_03_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_03);
      three_day_seq(idx).tod_ag_412_mlrc_04_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_04);
      three_day_seq(idx).tod_ag_412_mlrc_05_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_05);
      three_day_seq(idx).tod_ag_412_mlrc_06_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_06);
      three_day_seq(idx).tod_ag_412_mlrc_07_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_07);
      
      three_day_seq(idx).tod_poc_00_stdv = nanstd(three_day_seq(idx).tod_poc_00);
      three_day_seq(idx).tod_poc_01_stdv = nanstd(three_day_seq(idx).tod_poc_01);
      three_day_seq(idx).tod_poc_02_stdv = nanstd(three_day_seq(idx).tod_poc_02);
      three_day_seq(idx).tod_poc_03_stdv = nanstd(three_day_seq(idx).tod_poc_03);
      three_day_seq(idx).tod_poc_04_stdv = nanstd(three_day_seq(idx).tod_poc_04);
      three_day_seq(idx).tod_poc_05_stdv = nanstd(three_day_seq(idx).tod_poc_05);
      three_day_seq(idx).tod_poc_06_stdv = nanstd(three_day_seq(idx).tod_poc_06);
      three_day_seq(idx).tod_poc_07_stdv = nanstd(three_day_seq(idx).tod_poc_07);
      
      % CV
      three_day_seq(idx).tod_chlor_a_00_CV = three_day_seq(idx).tod_chlor_a_00_stdv/three_day_seq(idx).tod_chlor_a_00_mean;
      three_day_seq(idx).tod_chlor_a_01_CV = three_day_seq(idx).tod_chlor_a_01_stdv/three_day_seq(idx).tod_chlor_a_01_mean;
      three_day_seq(idx).tod_chlor_a_02_CV = three_day_seq(idx).tod_chlor_a_02_stdv/three_day_seq(idx).tod_chlor_a_02_mean;
      three_day_seq(idx).tod_chlor_a_03_CV = three_day_seq(idx).tod_chlor_a_03_stdv/three_day_seq(idx).tod_chlor_a_03_mean;
      three_day_seq(idx).tod_chlor_a_04_CV = three_day_seq(idx).tod_chlor_a_04_stdv/three_day_seq(idx).tod_chlor_a_04_mean;
      three_day_seq(idx).tod_chlor_a_05_CV = three_day_seq(idx).tod_chlor_a_05_stdv/three_day_seq(idx).tod_chlor_a_05_mean;
      three_day_seq(idx).tod_chlor_a_06_CV = three_day_seq(idx).tod_chlor_a_06_stdv/three_day_seq(idx).tod_chlor_a_06_mean;
      three_day_seq(idx).tod_chlor_a_07_CV = three_day_seq(idx).tod_chlor_a_07_stdv/three_day_seq(idx).tod_chlor_a_07_mean;
      
      three_day_seq(idx).tod_ag_412_mlrc_00_CV = three_day_seq(idx).tod_ag_412_mlrc_00_stdv/three_day_seq(idx).tod_ag_412_mlrc_00_mean;
      three_day_seq(idx).tod_ag_412_mlrc_01_CV = three_day_seq(idx).tod_ag_412_mlrc_01_stdv/three_day_seq(idx).tod_ag_412_mlrc_01_mean;
      three_day_seq(idx).tod_ag_412_mlrc_02_CV = three_day_seq(idx).tod_ag_412_mlrc_02_stdv/three_day_seq(idx).tod_ag_412_mlrc_02_mean;
      three_day_seq(idx).tod_ag_412_mlrc_03_CV = three_day_seq(idx).tod_ag_412_mlrc_03_stdv/three_day_seq(idx).tod_ag_412_mlrc_03_mean;
      three_day_seq(idx).tod_ag_412_mlrc_04_CV = three_day_seq(idx).tod_ag_412_mlrc_04_stdv/three_day_seq(idx).tod_ag_412_mlrc_04_mean;
      three_day_seq(idx).tod_ag_412_mlrc_05_CV = three_day_seq(idx).tod_ag_412_mlrc_05_stdv/three_day_seq(idx).tod_ag_412_mlrc_05_mean;
      three_day_seq(idx).tod_ag_412_mlrc_06_CV = three_day_seq(idx).tod_ag_412_mlrc_06_stdv/three_day_seq(idx).tod_ag_412_mlrc_06_mean;
      three_day_seq(idx).tod_ag_412_mlrc_07_CV = three_day_seq(idx).tod_ag_412_mlrc_07_stdv/three_day_seq(idx).tod_ag_412_mlrc_07_mean;
      
      three_day_seq(idx).tod_poc_00_CV = three_day_seq(idx).tod_poc_00_stdv/three_day_seq(idx).tod_poc_00_mean;
      three_day_seq(idx).tod_poc_01_CV = three_day_seq(idx).tod_poc_01_stdv/three_day_seq(idx).tod_poc_01_mean;
      three_day_seq(idx).tod_poc_02_CV = three_day_seq(idx).tod_poc_02_stdv/three_day_seq(idx).tod_poc_02_mean;
      three_day_seq(idx).tod_poc_03_CV = three_day_seq(idx).tod_poc_03_stdv/three_day_seq(idx).tod_poc_03_mean;
      three_day_seq(idx).tod_poc_04_CV = three_day_seq(idx).tod_poc_04_stdv/three_day_seq(idx).tod_poc_04_mean;
      three_day_seq(idx).tod_poc_05_CV = three_day_seq(idx).tod_poc_05_stdv/three_day_seq(idx).tod_poc_05_mean;
      three_day_seq(idx).tod_poc_06_CV = three_day_seq(idx).tod_poc_06_stdv/three_day_seq(idx).tod_poc_06_mean;
      three_day_seq(idx).tod_poc_07_CV = three_day_seq(idx).tod_poc_07_stdv/three_day_seq(idx).tod_poc_07_mean;
      
      %% for all 24 points per sequence

      three_day_seq(idx).tod_chlor_a_All = [three_day_seq(idx).tod_chlor_a_00 three_day_seq(idx).tod_chlor_a_01 three_day_seq(idx).tod_chlor_a_02 ...
                                                three_day_seq(idx).tod_chlor_a_03 three_day_seq(idx).tod_chlor_a_04 three_day_seq(idx).tod_chlor_a_05 ...
                                                three_day_seq(idx).tod_chlor_a_06 three_day_seq(idx).tod_chlor_a_07];

      three_day_seq(idx).tod_poc_All = [three_day_seq(idx).tod_poc_00 three_day_seq(idx).tod_poc_01 three_day_seq(idx).tod_poc_02 ...
                                                three_day_seq(idx).tod_poc_03 three_day_seq(idx).tod_poc_04 three_day_seq(idx).tod_poc_05 ...
                                                three_day_seq(idx).tod_poc_06 three_day_seq(idx).tod_poc_07];
      
      three_day_seq(idx).tod_ag_412_mlrc_All = [three_day_seq(idx).tod_ag_412_mlrc_00 three_day_seq(idx).tod_ag_412_mlrc_01 three_day_seq(idx).tod_ag_412_mlrc_02 ...
                                                three_day_seq(idx).tod_ag_412_mlrc_03 three_day_seq(idx).tod_ag_412_mlrc_04 three_day_seq(idx).tod_ag_412_mlrc_05 ...
                                                three_day_seq(idx).tod_ag_412_mlrc_06 three_day_seq(idx).tod_ag_412_mlrc_07];


      three_day_seq(idx).tod_chlor_a_All_mean = nanmean(three_day_seq(idx).tod_chlor_a_All);
      three_day_seq(idx).tod_poc_All_mean = nanmean(three_day_seq(idx).tod_poc_All);
      three_day_seq(idx).tod_ag_412_mlrc_All_mean = nanmean(three_day_seq(idx).tod_ag_412_mlrc_All);
   
      
      three_day_seq(idx).tod_chlor_a_All_stdv = nanstd(three_day_seq(idx).tod_chlor_a_All);
      three_day_seq(idx).tod_poc_All_stdv = nanstd(three_day_seq(idx).tod_poc_All);
      three_day_seq(idx).tod_ag_412_mlrc_All_stdv = nanstd(three_day_seq(idx).tod_ag_412_mlrc_All);

      
      three_day_seq(idx).tod_chlor_a_All_CV = three_day_seq(idx).tod_chlor_a_All_stdv/three_day_seq(idx).tod_chlor_a_All_mean;
      three_day_seq(idx).tod_poc_All_CV = three_day_seq(idx).tod_poc_All_stdv/three_day_seq(idx).tod_poc_All_mean;
      three_day_seq(idx).tod_ag_412_mlrc_All_CV = three_day_seq(idx).tod_ag_412_mlrc_All_stdv/three_day_seq(idx).tod_ag_412_mlrc_All_mean;

      
      three_day_seq(idx).tod_chlor_a_All_median = nanmedian(three_day_seq(idx).tod_chlor_a_All);
      three_day_seq(idx).tod_poc_All_median = nanmedian(three_day_seq(idx).tod_poc_All);
      three_day_seq(idx).tod_ag_412_mlrc_All_median = nanmedian(three_day_seq(idx).tod_ag_412_mlrc_All);


      % Normality test
      [three_day_seq(idx).tod_chlor_a_All_H,three_day_seq(idx).tod_chlor_a_All_P] = kstest((three_day_seq(idx).tod_chlor_a_All-three_day_seq(idx).tod_chlor_a_All_mean)/three_day_seq(idx).tod_chlor_a_All_stdv);
      [three_day_seq(idx).tod_poc_All_H,three_day_seq(idx).tod_poc_All_P] = kstest((three_day_seq(idx).tod_poc_All-three_day_seq(idx).tod_poc_All_mean)/three_day_seq(idx).tod_poc_All_stdv);
      [three_day_seq(idx).tod_ag_412_mlrc_All_H,three_day_seq(idx).tod_ag_412_mlrc_All_P] = kstest((three_day_seq(idx).tod_ag_412_mlrc_All-three_day_seq(idx).tod_ag_412_mlrc_All_mean)/three_day_seq(idx).tod_ag_412_mlrc_All_stdv);

      
end
%% Stats for CV[%]_3-day for chlor_a, poc, ag_412_mlrc
fs = 32;
lw = 2;
h = figure('Color','white','DefaultAxesFontSize',fs);

cond0 = [three_day_seq.tod_chlor_a_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_chlor_a_All_CV = nan;
end
plot(100*[three_day_seq.tod_chlor_a_All_CV],'LineWidth',lw,'Color',[1 0 0])
hold on

cond0 = [three_day_seq.tod_poc_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_poc_All_CV = nan;
end
plot(100*[three_day_seq.tod_poc_All_CV],'LineWidth',lw,'Color',[0 1 0])

cond0 = [three_day_seq.tod_ag_412_mlrc_All_H]==1;
idx_vec = find(cond0);
for idx = 1:size(idx_vec,2)
      three_day_seq(idx_vec(idx)).tod_ag_412_mlrc_All_CV = nan;
end
plot(100*[three_day_seq.tod_ag_412_mlrc_All_CV],'LineWidth',lw,'Color',[0 0 1])

legend('Chl-{\ita}{    }','POC{    }','{\ita}_g(412){    }','Orientation','horizontal','Location','northoutside')
legend boxoff 

xlabel('Sequence Number')
ylabel('CV[%]_{3-day} (%)')

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'PaperPositionMode','auto'); %set paper pos for printing
set(gcf, 'renderer','painters')
saveas(gcf,[savedirname '3dayseq_par_vs_seqnum'],'epsc')
%%
disp('Prod & min & max & mean & median & SD & N')
fprintf('chlor_a & %.2f & %.2f & %.2f & %.2f & %.2f & %i\n',100*nanmin([three_day_seq.tod_chlor_a_All_CV]),100*nanmax([three_day_seq.tod_chlor_a_All_CV]),...
      100*nanmean([three_day_seq.tod_chlor_a_All_CV]),100*nanmedian([three_day_seq.tod_chlor_a_All_CV]),100*nanstd([three_day_seq.tod_chlor_a_All_CV]),...
      sum(~isnan([three_day_seq.tod_chlor_a_All_CV])))

fprintf('poc & %.2f & %.2f & %.2f & %.2f & %.2f & %i\n',100*nanmin([three_day_seq.tod_poc_All_CV]),100*nanmax([three_day_seq.tod_poc_All_CV]),...
      100*nanmean([three_day_seq.tod_poc_All_CV]),100*nanmedian([three_day_seq.tod_poc_All_CV]),100*nanstd([three_day_seq.tod_poc_All_CV]),...
      sum(~isnan([three_day_seq.tod_poc_All_CV])))

fprintf('ag_412_mlrc & %.2f & %.2f & %.2f & %.2f & %.2f & %i\n',100*nanmin([three_day_seq.tod_ag_412_mlrc_All_CV]),100*nanmax([three_day_seq.tod_ag_412_mlrc_All_CV]),...
      100*nanmean([three_day_seq.tod_ag_412_mlrc_All_CV]),100*nanmedian([three_day_seq.tod_ag_412_mlrc_All_CV]),100*nanstd([three_day_seq.tod_ag_412_mlrc_All_CV]),...
      sum(~isnan([three_day_seq.tod_ag_412_mlrc_All_CV])))
%% Plot
% savedirname = '/Users/jconchas/Documents/Latex/2017_GOCI_paper/Figures/source/';
% fs = 40;
% lw = 3;
% ms = 16;


% %% Rrs_412
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','412');
% xx = 0:7;
% A = [...
%       100*nanmax([three_day_seq.tod_Rrs_412_00_CV]) 100*nanmax([three_day_seq.tod_Rrs_412_01_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_412_02_CV]) 100*nanmax([three_day_seq.tod_Rrs_412_03_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_412_04_CV]) 100*nanmax([three_day_seq.tod_Rrs_412_05_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_412_06_CV]) 100*nanmax([three_day_seq.tod_Rrs_412_07_CV])];

% B = [...
%       100*nanmin([three_day_seq.tod_Rrs_412_00_CV]) 100*nanmin([three_day_seq.tod_Rrs_412_01_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_412_02_CV]) 100*nanmin([three_day_seq.tod_Rrs_412_03_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_412_04_CV]) 100*nanmin([three_day_seq.tod_Rrs_412_05_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_412_06_CV]) 100*nanmin([three_day_seq.tod_Rrs_412_07_CV])];

% plot(xx,A,'--k')
% hold on
% plot(xx,B,'--k')
% hold on
% yy1 = [100*nanmean([three_day_seq.tod_Rrs_412_00_CV])+100*nanstd([three_day_seq.tod_Rrs_412_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_01_CV])+100*nanstd([three_day_seq.tod_Rrs_412_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_02_CV])+100*nanstd([three_day_seq.tod_Rrs_412_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_03_CV])+100*nanstd([three_day_seq.tod_Rrs_412_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_04_CV])+100*nanstd([three_day_seq.tod_Rrs_412_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_05_CV])+100*nanstd([three_day_seq.tod_Rrs_412_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_06_CV])+100*nanstd([three_day_seq.tod_Rrs_412_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_07_CV])+100*nanstd([three_day_seq.tod_Rrs_412_07_CV])];
% yy2 = [100*nanmean([three_day_seq.tod_Rrs_412_00_CV])-100*nanstd([three_day_seq.tod_Rrs_412_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_01_CV])-100*nanstd([three_day_seq.tod_Rrs_412_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_02_CV])-100*nanstd([three_day_seq.tod_Rrs_412_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_03_CV])-100*nanstd([three_day_seq.tod_Rrs_412_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_04_CV])-100*nanstd([three_day_seq.tod_Rrs_412_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_05_CV])-100*nanstd([three_day_seq.tod_Rrs_412_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_06_CV])-100*nanstd([three_day_seq.tod_Rrs_412_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_07_CV])-100*nanstd([three_day_seq.tod_Rrs_412_07_CV])];
% fill([xx fliplr(xx)],[yy1 fliplr(yy2)],[0.0 0.0 0.0])
% alpha(0.15)

% hold on
% yy = [100*nanmean([three_day_seq.tod_Rrs_412_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_412_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_412_07_CV])];
% plot(xx,yy,'-','Color',[0.0 0.0 0.0],'LineWidth',lw)

% yy = [100*nanmedian([three_day_seq.tod_Rrs_412_00_CV]) 100*nanmedian([three_day_seq.tod_Rrs_412_01_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_412_02_CV]) 100*nanmedian([three_day_seq.tod_Rrs_412_03_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_412_04_CV]) 100*nanmedian([three_day_seq.tod_Rrs_412_05_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_412_06_CV]) 100*nanmedian([three_day_seq.tod_Rrs_412_07_CV])];
% plot(xx,yy,'--','Color',[0.0 0.0 0.0],'LineWidth',lw)

% ylim([0 50])

% grid on
% ylabel('{\itCV} [%]_{3-day} for {\itR}_{rs}(412) [%]','FontSize',fs)
% xlabel('Local Time','FontSize',fs)

% set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% xlim([0 7])
% ax = gca;
% ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};

% set(gcf, 'renderer','painters')
% saveas(gcf,[savedirname '3day_CV_412'],'epsc')

% % ylabel('R_{rs}(412) (sr^{-1})','FontSize',fs)
% % xlabel('Time','FontSize',fs)
% % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% %% Rrs_443
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','443');
% xx = 0:7;
% A = [...
%       100*nanmax([three_day_seq.tod_Rrs_443_00_CV]) 100*nanmax([three_day_seq.tod_Rrs_443_01_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_443_02_CV]) 100*nanmax([three_day_seq.tod_Rrs_443_03_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_443_04_CV]) 100*nanmax([three_day_seq.tod_Rrs_443_05_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_443_06_CV]) 100*nanmax([three_day_seq.tod_Rrs_443_07_CV])];

% B = [...
%       100*nanmin([three_day_seq.tod_Rrs_443_00_CV]) 100*nanmin([three_day_seq.tod_Rrs_443_01_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_443_02_CV]) 100*nanmin([three_day_seq.tod_Rrs_443_03_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_443_04_CV]) 100*nanmin([three_day_seq.tod_Rrs_443_05_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_443_06_CV]) 100*nanmin([three_day_seq.tod_Rrs_443_07_CV])];

% plot(xx,A,'--k')
% hold on
% plot(xx,B,'--k')

% hold on
% yy1 = [100*nanmean([three_day_seq.tod_Rrs_443_00_CV])+100*nanstd([three_day_seq.tod_Rrs_443_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_01_CV])+100*nanstd([three_day_seq.tod_Rrs_443_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_02_CV])+100*nanstd([three_day_seq.tod_Rrs_443_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_03_CV])+100*nanstd([three_day_seq.tod_Rrs_443_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_04_CV])+100*nanstd([three_day_seq.tod_Rrs_443_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_05_CV])+100*nanstd([three_day_seq.tod_Rrs_443_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_06_CV])+100*nanstd([three_day_seq.tod_Rrs_443_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_07_CV])+100*nanstd([three_day_seq.tod_Rrs_443_07_CV])];
% yy2 = [100*nanmean([three_day_seq.tod_Rrs_443_00_CV])-100*nanstd([three_day_seq.tod_Rrs_443_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_01_CV])-100*nanstd([three_day_seq.tod_Rrs_443_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_02_CV])-100*nanstd([three_day_seq.tod_Rrs_443_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_03_CV])-100*nanstd([three_day_seq.tod_Rrs_443_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_04_CV])-100*nanstd([three_day_seq.tod_Rrs_443_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_05_CV])-100*nanstd([three_day_seq.tod_Rrs_443_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_06_CV])-100*nanstd([three_day_seq.tod_Rrs_443_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_07_CV])-100*nanstd([three_day_seq.tod_Rrs_443_07_CV])];
% fill([xx fliplr(xx)],[yy1 fliplr(yy2)],[0.0 0.0 0.0])
% alpha(0.15)

% hold on
% yy = [100*nanmean([three_day_seq.tod_Rrs_443_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_443_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_443_07_CV])];
% plot(xx,yy,'-','Color',[0.0 0.0 0.0],'LineWidth',lw)

% yy = [100*nanmedian([three_day_seq.tod_Rrs_443_00_CV]) 100*nanmedian([three_day_seq.tod_Rrs_443_01_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_443_02_CV]) 100*nanmedian([three_day_seq.tod_Rrs_443_03_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_443_04_CV]) 100*nanmedian([three_day_seq.tod_Rrs_443_05_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_443_06_CV]) 100*nanmedian([three_day_seq.tod_Rrs_443_07_CV])];
% plot(xx,yy,'--','Color',[0.0 0.0 0.0],'LineWidth',lw)

% ylim([0 50])

% grid on
% ylabel('{\itCV}[%]_{3-day} for {\itR}_{rs}(443)','FontSize',fs)
% xlabel('Local Time','FontSize',fs)

% set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% xlim([0 7])
% ax = gca;
% ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};

% set(gcf, 'renderer','painters')
% saveas(gcf,[savedirname '3day_CV_443'],'epsc')


% % ylabel('R_{rs}(443) (sr^{-1})','FontSize',fs)
% % xlabel('Time','FontSize',fs)
% % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% %% Rrs_490
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','490');
% xx = 0:7;
% hold on
% A = [...
%       100*nanmax([three_day_seq.tod_Rrs_490_00_CV]) 100*nanmax([three_day_seq.tod_Rrs_490_01_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_490_02_CV]) 100*nanmax([three_day_seq.tod_Rrs_490_03_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_490_04_CV]) 100*nanmax([three_day_seq.tod_Rrs_490_05_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_490_06_CV]) 100*nanmax([three_day_seq.tod_Rrs_490_07_CV])];

% B = [...
%       100*nanmin([three_day_seq.tod_Rrs_490_00_CV]) 100*nanmin([three_day_seq.tod_Rrs_490_01_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_490_02_CV]) 100*nanmin([three_day_seq.tod_Rrs_490_03_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_490_04_CV]) 100*nanmin([three_day_seq.tod_Rrs_490_05_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_490_06_CV]) 100*nanmin([three_day_seq.tod_Rrs_490_07_CV])];

% plot(xx,A,'--k')
% hold on
% plot(xx,B,'--k')

% hold on
% yy1 = [100*nanmean([three_day_seq.tod_Rrs_490_00_CV])+100*nanstd([three_day_seq.tod_Rrs_490_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_01_CV])+100*nanstd([three_day_seq.tod_Rrs_490_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_02_CV])+100*nanstd([three_day_seq.tod_Rrs_490_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_03_CV])+100*nanstd([three_day_seq.tod_Rrs_490_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_04_CV])+100*nanstd([three_day_seq.tod_Rrs_490_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_05_CV])+100*nanstd([three_day_seq.tod_Rrs_490_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_06_CV])+100*nanstd([three_day_seq.tod_Rrs_490_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_07_CV])+100*nanstd([three_day_seq.tod_Rrs_490_07_CV])];
% yy2 = [100*nanmean([three_day_seq.tod_Rrs_490_00_CV])-100*nanstd([three_day_seq.tod_Rrs_490_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_01_CV])-100*nanstd([three_day_seq.tod_Rrs_490_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_02_CV])-100*nanstd([three_day_seq.tod_Rrs_490_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_03_CV])-100*nanstd([three_day_seq.tod_Rrs_490_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_04_CV])-100*nanstd([three_day_seq.tod_Rrs_490_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_05_CV])-100*nanstd([three_day_seq.tod_Rrs_490_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_06_CV])-100*nanstd([three_day_seq.tod_Rrs_490_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_07_CV])-100*nanstd([three_day_seq.tod_Rrs_490_07_CV])];
% fill([xx fliplr(xx)],[yy1 fliplr(yy2)],[0.0 0.0 0.0])
% alpha(0.15)

% hold on
% yy = [100*nanmean([three_day_seq.tod_Rrs_490_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_490_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_490_07_CV])];
% plot(xx,yy,'-','Color',[0.0 0.0 0.0],'LineWidth',lw)

% yy = [100*nanmedian([three_day_seq.tod_Rrs_490_00_CV]) 100*nanmedian([three_day_seq.tod_Rrs_490_01_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_490_02_CV]) 100*nanmedian([three_day_seq.tod_Rrs_490_03_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_490_04_CV]) 100*nanmedian([three_day_seq.tod_Rrs_490_05_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_490_06_CV]) 100*nanmedian([three_day_seq.tod_Rrs_490_07_CV])];
% plot(xx,yy,'--','Color',[0.0 0.0 0.0],'LineWidth',lw)

% ylim([0 50])

% grid on
% ylabel('{\itCV} [%]_{3-day} for {\itR}_{rs}(490)','FontSize',fs)
% xlabel('Local Time','FontSize',fs)

% set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% xlim([0 7])
% ax = gca;
% ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};

% set(gcf, 'renderer','painters')
% saveas(gcf,[savedirname '3day_CV_490'],'epsc')


% % ylabel('R_{rs}(490) (sr^{-1})','FontSize',fs)
% % xlabel('Time','FontSize',fs)
% % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% %% Rrs_555
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','555');
% xx = 0:7;
% A = [...
%       100*nanmax([three_day_seq.tod_Rrs_555_00_CV]) 100*nanmax([three_day_seq.tod_Rrs_555_01_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_555_02_CV]) 100*nanmax([three_day_seq.tod_Rrs_555_03_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_555_04_CV]) 100*nanmax([three_day_seq.tod_Rrs_555_05_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_555_06_CV]) 100*nanmax([three_day_seq.tod_Rrs_555_07_CV])];

% B = [...
%       100*nanmin([three_day_seq.tod_Rrs_555_00_CV]) 100*nanmin([three_day_seq.tod_Rrs_555_01_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_555_02_CV]) 100*nanmin([three_day_seq.tod_Rrs_555_03_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_555_04_CV]) 100*nanmin([three_day_seq.tod_Rrs_555_05_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_555_06_CV]) 100*nanmin([three_day_seq.tod_Rrs_555_07_CV])];

% plot(xx,A,'--k')
% hold on
% plot(xx,B,'--k')

% hold on
% yy1 = [100*nanmean([three_day_seq.tod_Rrs_555_00_CV])+100*nanstd([three_day_seq.tod_Rrs_555_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_01_CV])+100*nanstd([three_day_seq.tod_Rrs_555_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_02_CV])+100*nanstd([three_day_seq.tod_Rrs_555_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_03_CV])+100*nanstd([three_day_seq.tod_Rrs_555_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_04_CV])+100*nanstd([three_day_seq.tod_Rrs_555_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_05_CV])+100*nanstd([three_day_seq.tod_Rrs_555_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_06_CV])+100*nanstd([three_day_seq.tod_Rrs_555_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_07_CV])+100*nanstd([three_day_seq.tod_Rrs_555_07_CV])];
% yy2 = [100*nanmean([three_day_seq.tod_Rrs_555_00_CV])-100*nanstd([three_day_seq.tod_Rrs_555_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_01_CV])-100*nanstd([three_day_seq.tod_Rrs_555_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_02_CV])-100*nanstd([three_day_seq.tod_Rrs_555_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_03_CV])-100*nanstd([three_day_seq.tod_Rrs_555_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_04_CV])-100*nanstd([three_day_seq.tod_Rrs_555_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_05_CV])-100*nanstd([three_day_seq.tod_Rrs_555_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_06_CV])-100*nanstd([three_day_seq.tod_Rrs_555_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_07_CV])-100*nanstd([three_day_seq.tod_Rrs_555_07_CV])];
% fill([xx fliplr(xx)],[yy1 fliplr(yy2)],[0.0 0.0 0.0])
% alpha(0.15)

% hold on
% yy = [100*nanmean([three_day_seq.tod_Rrs_555_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_555_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_555_07_CV])];
% plot(xx,yy,'-','Color',[0.0 0.0 0.0],'LineWidth',lw)

% yy = [100*nanmedian([three_day_seq.tod_Rrs_555_00_CV]) 100*nanmedian([three_day_seq.tod_Rrs_555_01_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_555_02_CV]) 100*nanmedian([three_day_seq.tod_Rrs_555_03_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_555_04_CV]) 100*nanmedian([three_day_seq.tod_Rrs_555_05_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_555_06_CV]) 100*nanmedian([three_day_seq.tod_Rrs_555_07_CV])];
% plot(xx,yy,'--','Color',[0.0 0.0 0.0],'LineWidth',lw)

% ylim([0 50])

% grid on
% ylabel('{\itCV} [%]_{3-day} for {\itR}_{rs}(555)','FontSize',fs)
% xlabel('Local Time','FontSize',fs)

% set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% xlim([0 7])
% ax = gca;
% ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};

% set(gcf, 'renderer','painters')
% saveas(gcf,[savedirname '3day_CV_555'],'epsc')

% %% Rrs_660
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','660');
% xx = 0:7;
% hold on
% A = [...
%       100*nanmax([three_day_seq.tod_Rrs_660_00_CV]) 100*nanmax([three_day_seq.tod_Rrs_660_01_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_660_02_CV]) 100*nanmax([three_day_seq.tod_Rrs_660_03_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_660_04_CV]) 100*nanmax([three_day_seq.tod_Rrs_660_05_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_660_06_CV]) 100*nanmax([three_day_seq.tod_Rrs_660_07_CV])];

% B = [...
%       100*nanmin([three_day_seq.tod_Rrs_660_00_CV]) 100*nanmin([three_day_seq.tod_Rrs_660_01_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_660_02_CV]) 100*nanmin([three_day_seq.tod_Rrs_660_03_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_660_04_CV]) 100*nanmin([three_day_seq.tod_Rrs_660_05_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_660_06_CV]) 100*nanmin([three_day_seq.tod_Rrs_660_07_CV])];

% plot(xx,A,'--k')
% hold on
% plot(xx,B,'--k')

% hold on
% yy1 = [100*nanmean([three_day_seq.tod_Rrs_660_00_CV])+100*nanstd([three_day_seq.tod_Rrs_660_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_01_CV])+100*nanstd([three_day_seq.tod_Rrs_660_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_02_CV])+100*nanstd([three_day_seq.tod_Rrs_660_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_03_CV])+100*nanstd([three_day_seq.tod_Rrs_660_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_04_CV])+100*nanstd([three_day_seq.tod_Rrs_660_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_05_CV])+100*nanstd([three_day_seq.tod_Rrs_660_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_06_CV])+100*nanstd([three_day_seq.tod_Rrs_660_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_07_CV])+100*nanstd([three_day_seq.tod_Rrs_660_07_CV])];
% yy2 = [100*nanmean([three_day_seq.tod_Rrs_660_00_CV])-100*nanstd([three_day_seq.tod_Rrs_660_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_01_CV])-100*nanstd([three_day_seq.tod_Rrs_660_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_02_CV])-100*nanstd([three_day_seq.tod_Rrs_660_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_03_CV])-100*nanstd([three_day_seq.tod_Rrs_660_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_04_CV])-100*nanstd([three_day_seq.tod_Rrs_660_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_05_CV])-100*nanstd([three_day_seq.tod_Rrs_660_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_06_CV])-100*nanstd([three_day_seq.tod_Rrs_660_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_07_CV])-100*nanstd([three_day_seq.tod_Rrs_660_07_CV])];
% fill([xx fliplr(xx)],[yy1 fliplr(yy2)],[0.0 0.0 0.0])
% alpha(0.15)

% hold on
% yy = [100*nanmean([three_day_seq.tod_Rrs_660_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_660_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_660_07_CV])];
% plot(xx,yy,'-','Color',[0.0 0.0 0.0],'LineWidth',lw)

% yy = [100*nanmedian([three_day_seq.tod_Rrs_660_00_CV]) 100*nanmedian([three_day_seq.tod_Rrs_660_01_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_660_02_CV]) 100*nanmedian([three_day_seq.tod_Rrs_660_03_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_660_04_CV]) 100*nanmedian([three_day_seq.tod_Rrs_660_05_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_660_06_CV]) 100*nanmedian([three_day_seq.tod_Rrs_660_07_CV])];
% plot(xx,yy,'--','Color',[0.0 0.0 0.0],'LineWidth',lw)

% ylim([0 100])

% grid on
% ylabel('{\itCV} [%]_{3-day} for {\itR}_{rs}(660)','FontSize',fs)
% xlabel('Local Time','FontSize',fs)

% set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% xlim([0 7])
% ax = gca;
% ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};

% set(gcf, 'renderer','painters')
% saveas(gcf,[savedirname '3day_CV_660'],'epsc')


% % ylabel('R_{rs}(660) (sr^{-1})','FontSize',fs)
% % xlabel('Time','FontSize',fs)
% % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% %% Rrs_680
% h = figure('Color','white','DefaultAxesFontSize',fs,'Name','680');
% xx = 0:7;
% hold on
% A = [...
%       100*nanmax([three_day_seq.tod_Rrs_680_00_CV]) 100*nanmax([three_day_seq.tod_Rrs_680_01_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_680_02_CV]) 100*nanmax([three_day_seq.tod_Rrs_680_03_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_680_04_CV]) 100*nanmax([three_day_seq.tod_Rrs_680_05_CV]) ...
%       100*nanmax([three_day_seq.tod_Rrs_680_06_CV]) 100*nanmax([three_day_seq.tod_Rrs_680_07_CV])];

% B = [...
%       100*nanmin([three_day_seq.tod_Rrs_680_00_CV]) 100*nanmin([three_day_seq.tod_Rrs_680_01_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_680_02_CV]) 100*nanmin([three_day_seq.tod_Rrs_680_03_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_680_04_CV]) 100*nanmin([three_day_seq.tod_Rrs_680_05_CV]) ...
%       100*nanmin([three_day_seq.tod_Rrs_680_06_CV]) 100*nanmin([three_day_seq.tod_Rrs_680_07_CV])];

% plot(xx,A,'--k')
% hold on
% plot(xx,B,'--k')

% hold on
% yy1 = [100*nanmean([three_day_seq.tod_Rrs_680_00_CV])+100*nanstd([three_day_seq.tod_Rrs_680_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_01_CV])+100*nanstd([three_day_seq.tod_Rrs_680_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_02_CV])+100*nanstd([three_day_seq.tod_Rrs_680_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_03_CV])+100*nanstd([three_day_seq.tod_Rrs_680_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_04_CV])+100*nanstd([three_day_seq.tod_Rrs_680_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_05_CV])+100*nanstd([three_day_seq.tod_Rrs_680_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_06_CV])+100*nanstd([three_day_seq.tod_Rrs_680_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_07_CV])+100*nanstd([three_day_seq.tod_Rrs_680_07_CV])];
% yy2 = [100*nanmean([three_day_seq.tod_Rrs_680_00_CV])-100*nanstd([three_day_seq.tod_Rrs_680_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_01_CV])-100*nanstd([three_day_seq.tod_Rrs_680_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_02_CV])-100*nanstd([three_day_seq.tod_Rrs_680_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_03_CV])-100*nanstd([three_day_seq.tod_Rrs_680_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_04_CV])-100*nanstd([three_day_seq.tod_Rrs_680_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_05_CV])-100*nanstd([three_day_seq.tod_Rrs_680_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_06_CV])-100*nanstd([three_day_seq.tod_Rrs_680_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_07_CV])-100*nanstd([three_day_seq.tod_Rrs_680_07_CV])];
% fill([xx fliplr(xx)],[yy1 fliplr(yy2)],[0.0 0.0 0.0])
% alpha(0.15)

% hold on
% yy = [100*nanmean([three_day_seq.tod_Rrs_680_00_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_01_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_02_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_03_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_04_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_05_CV]) ...
%       100*nanmean([three_day_seq.tod_Rrs_680_06_CV]) 100*nanmean([three_day_seq.tod_Rrs_680_07_CV])];
% plot(xx,yy,'-','Color',[0.0 0.0 0.0],'LineWidth',lw)

% yy = [100*nanmedian([three_day_seq.tod_Rrs_680_00_CV]) 100*nanmedian([three_day_seq.tod_Rrs_680_01_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_680_02_CV]) 100*nanmedian([three_day_seq.tod_Rrs_680_03_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_680_04_CV]) 100*nanmedian([three_day_seq.tod_Rrs_680_05_CV]) ...
%       100*nanmedian([three_day_seq.tod_Rrs_680_06_CV]) 100*nanmedian([three_day_seq.tod_Rrs_680_07_CV])];
% plot(xx,yy,'--','Color',[0.0 0.0 0.0],'LineWidth',lw)

% ylim([0 100])

% grid on
% ylabel('{\itCV} [%]_{3-day} for {\itR}_{rs}(680)','FontSize',fs)
% xlabel('Local Time','FontSize',fs)

% set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% set(gcf,'PaperPositionMode','auto'); %set paper pos for printing

% xlim([0 7])
% ax = gca;
% ax.XTickLabel = {'9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'};

% set(gcf, 'renderer','painters')
% saveas(gcf,[savedirname '3day_CV_680'],'epsc')


% % ylabel('R_{rs}(680) (sr^{-1})','FontSize',fs)
% % xlabel('Time','FontSize',fs)
% % legend('0h','1h','2h','3h','4h','5h','6h','7h','Location','northeast')

% clear A B xx yy

% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 3-day set comparison by hour
% clear A_idx A three_day_idx cond1 cond2 cond3 cond4 cond5 cond6
% clear cond_brdf1 cond_brdf2 cond_brdf3
% brdf_opt = 7;

% for idx = 1:size(GOCI_DailyStatMatrix,2)-2
%       cond_brdf1 = [GOCI_DailyStatMatrix(idx+0).brdf_opt]==brdf_opt;
%       cond_brdf2 = [GOCI_DailyStatMatrix(idx+1).brdf_opt]==brdf_opt;
%       cond_brdf3 = [GOCI_DailyStatMatrix(idx+2).brdf_opt]==brdf_opt;
      
      
%       cond_412_00 = ...
%             ~isnan([GOCI_DailyStatMatrix(idx+0).Rrs_412_00]) && ... % the assumption that if at least one band is valid for that hour, the rest will be too!!! Maybe not true
%             ~isnan([GOCI_DailyStatMatrix(idx+1).Rrs_412_00]) && ...
%             ~isnan([GOCI_DailyStatMatrix(idx+2).Rrs_412_00]);
      
           
%       if ~isempty(cond_412_00)...
%                   &&~isempty(cond_brdf1)&&~isempty(cond_brdf2)&&~isempty(cond_brdf3)
%             if cond_412_00... % for all bands 
%                         &&cond_brdf1&&cond_brdf2&&cond_brdf3
%                   three_day_idx(idx)=true;
                  
%             else
%                   three_day_idx(idx)=false;
%             end
%       else
%             three_day_idx(idx)=false;
%       end
% end

% A_idx_412_00= find(three_day_idx); % indeces to 3-day sequences.

% %% 3-day sequences stats -- Rrs
% clear three_day_seq
% for idx = 1:sum(three_day_idx)
      
%       % Rrs
%       three_day_seq(idx).tod_Rrs_412_00 = [[GOCI_DailyStatMatrix(A_idx_412_00(idx)).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx_412_00(idx)+1).Rrs_412_00] [GOCI_DailyStatMatrix(A_idx_412_00(idx)+2).Rrs_412_00]];
     
      
%       % mean
%       three_day_seq(idx).tod_Rrs_412_00_mean = nanmean(three_day_seq(idx).tod_Rrs_412_00);


%       % median
%       three_day_seq(idx).tod_Rrs_412_00_median = nanmedian(three_day_seq(idx).tod_Rrs_412_00);
 
      
%       % SD
%       three_day_seq(idx).tod_Rrs_412_00_stdv = nanstd(three_day_seq(idx).tod_Rrs_412_00);
 
      
%       % CV
%       three_day_seq(idx).tod_Rrs_412_00_CV = three_day_seq(idx).tod_Rrs_412_00_stdv/three_day_seq(idx).tod_Rrs_412_00_mean;

      
% end
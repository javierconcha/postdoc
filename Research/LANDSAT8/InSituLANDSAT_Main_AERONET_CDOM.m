% Script to compare a_CDOM(412) from in situ data vs satellite data
addpath('/Users/jconchas/Documents/Research/LANDSAT8/landsat_matlab/')
addpath('/Users/jconchas/Documents/Research/')
cd '/Users/jconchas/Documents/Research/LANDSAT8';
%% First load data generated from InSituLANDSAT_Main_AERONETOC_Rrs.m
clear
load('L8Matchups_AERONET_Rrs.mat','MatchupRealFilt')

L2ext = {'_L2n1.nc','_L2n2.nc','_L2n2SWIR5x5.nc'};



count0 = 0;
for idx0 = 1:size(L2ext,2)
      cond_ACpar = strcmp({MatchupRealFilt.scene_ACpar}',char(L2ext(idx0)));
      
      Matchup_used = MatchupRealFilt(cond_ACpar);
      
      for idx1 = 1:size(Matchup_used,2)

            if ~isempty(Matchup_used(idx1).Rrs_443_filt_mean)&&...
                        ~isempty(Matchup_used(idx1).Rrs_443_insitu)&&...
                        ~isempty(Matchup_used(idx1).Rrs_561_filt_mean)&&...
                        ~isempty(Matchup_used(idx1).Rrs_555_insitu)
                  if ~isnan(Matchup_used(idx1).Rrs_443_filt_mean)&&...
                              ~isnan(Matchup_used(idx1).Rrs_443_insitu)&&...
                              ~isnan(Matchup_used(idx1).Rrs_561_filt_mean)&&...
                              ~isnan(Matchup_used(idx1).Rrs_555_insitu)
                        
                        count0 = count0+1;
                        
                        scene_id = Matchup_used(idx1).scene_id;
                        doy = str2double(scene_id(14:16));
                        
                        % In Situ CDOM
                        % [DOC,ag412] = doc_algorithm_ag412_daily( Rrs_b,Rrs_g,doy,wl_g)
                        [DOC_ins(count0),ag412_ins(count0)] = doc_algorithm_ag412_daily(...
                              Matchup_used(idx1).Rrs_443_insitu,...
                              Matchup_used(idx1).Rrs_555_insitu,...
                              doy,...
                              '555');
                        
                        % Satellite CDOM
                        % [DOC,ag412] = doc_algorithm_ag412_daily( Rrs_b,Rrs_g,doy,wl_g)
                        [DOC_sat(count0),ag412_sat(count0)] = doc_algorithm_ag412_daily(...
                              Matchup_used(idx1).Rrs_443_filt_mean,...
                              Matchup_used(idx1).Rrs_561_filt_mean,...
                              doy,...
                              '561');
                  end
            end
      end
      
      %% Plot
      cond1 = ag412_ins >=0 & ~isnan(ag412_ins) & ag412_sat >=0 & ~isnan(ag412_sat);
      
      ag412_ins_used = ag412_ins(cond1);
      ag412_sat_used = ag412_sat(cond1);
      
      fs = 16;
      h = figure('Color','white','DefaultAxesFontSize',fs,'Name',char(L2ext(idx0)));
      plot(ag412_ins_used,ag412_sat_used,'ob')
      ylabel('Satellite a_{CDOM}(412)(m^{-1})','FontSize',fs)
      xlabel('In situ a_{CDOM}(412)(m^{-1})','FontSize',fs)
      axis equal
      
      if min(ag412_sat_used) <0
            ag412_sat_min = min(ag412_sat_used)*1.1;
      else
            ag412_sat_min = 0;
      end
      ag412_sat_max = max(ag412_sat_used)*1.05;
      ag412_ins_min = min(ag412_ins_used)*0.95;
      ag412_ins_max = max(ag412_ins_used)*1.05;
      
      ag412_min = min([ag412_sat_min ag412_ins_min]);
      ag412_max = max([ag412_sat_max ag412_ins_max]);
      
      xlim([ag412_min ag412_max])
      ylim([ag412_min ag412_max])
      
      hold on
      plot([ag412_min ag412_max],[ag412_min ag412_max],'--k')
      % plot([0 ag412_max],[0.1*ag412_max 1.1*ag412_max],':k')
      % plot([0 ag412_max],[-0.1*ag412_max 0.9*ag412_max],':k')
      grid on
      leg = legend(['3 h; Total: ' num2str(size(ag412_sat_used,2)) ]);
      ax = gca;
      ax.XTick =ax.YTick;
      
      %% Statistics
      C_insitu_temp = ag412_ins_used;
      
      C_alg_temp = ag412_sat_used;
      
      C_insitu = C_insitu_temp(C_alg_temp>0);
      C_alg = C_alg_temp(C_alg_temp>0);
      
      if size(C_insitu,2) == size(C_alg,2)
            N = size(C_insitu,2);
      else
            error('Number of in situ and satellite points are different!')
      end
      
      PD = abs(C_alg-C_insitu)./C_insitu; % percent difference
      
      Mean_APD = (100/N)*sum(PD);% mean of the absolute percent difference (APD)
      
      Stdv_APD = 100*std(PD);% standard deviation of the absolute difference
      
      Median_APD = 100*median(PD); % a.k.a. MPD
      
      RMSE = sqrt((1/N)*sum((C_alg-C_insitu).^2));
      
      Percentage_Bias = 100*((1/N)*sum(C_alg-C_insitu))/(mean(C_insitu));
      
      ratio_alg_insitu = C_alg./C_insitu;
      
      Median_ratio = median(ratio_alg_insitu);
      
      Q3 = prctile(ratio_alg_insitu,75);
      Q1 = prctile(ratio_alg_insitu,25);
      SIQR = (Q3-Q1)/2; % Semi-interquartile range
      
      %% RMA regression and r-squared (or coefficient of determination)
      regressiontype = 'RMA';
      
      if strcmp(regressiontype,'OLS')
            [a,~] = polyfit(C_insitu,C_alg,1);
      elseif strcmp(regressiontype,'RMA')
            % %%%%%%%% RMA Regression %%%%%%%%%%%%%
            % [[b1 b0],bintr,bintjm] = gmregress(C_insitu,C_alg);
            a(1) = std(C_alg)/std(C_insitu); % slope
            
            if corr(C_insitu,C_alg)<0
                  a(1) = -abs(a(1));
            elseif corr(C_insitu,C_alg)>=0
                  a(1) = abs(a(1));
            end
            
            a(2) = nanmean(C_alg)-nanmean(C_insitu)*a(1); % y intercept
            
      end
      
      maxref = ag412_max;
      
      x1=[0 maxref];
      y1=a(1).*x1+a(2);
      
      figure(h)
      plot(x1,y1,'r-','LineWidth',1.2)
      
      
      SStot = sum((C_alg-nanmean(C_alg)).^2);
      SSres = sum((C_alg-polyval(a,C_insitu)).^2);
      rsq_SS = 1-(SSres/SStot);
      rsq_corr = corr(C_insitu',C_alg')^2; % when OLS rsq_SS and rsq_corr are equal
      
      
      if a(2)>=0
            str1 = sprintf('y: %2.4f x + %2.4f \n R^2: %2.4f; N: %i \n RMSE: %2.4f',...
                  a(1),abs(a(2)),rsq_SS,size(C_insitu,2),RMSE);
            str_reg = sprintf('y: %2.4f x + %2.4f',a(1),abs(a(2)));
      else
            str1 = sprintf('y: %2.4f x - %2.4f \n R^2: %2.4f; N: %i \n RMSE: %2.4f',...
                  a(1),abs(a(2)),rsq_SS,size(C_insitu,2),RMSE);
            str_reg = sprintf('y: %2.4f x - %2.4f',a(1),abs(a(2)));
      end
      
      %       axis([0 maxref 0 maxref])
      
      xLimits = get(gca,'XLim');
      yLimits = get(gca,'YLim');
      xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
      yLoc = yLimits(1)+0.85*(yLimits(2)-yLimits(1));
      figure(h)
      hold on
      text(xLoc,yLoc,str1,'FontSize',fs,'FontWeight','normal');
end
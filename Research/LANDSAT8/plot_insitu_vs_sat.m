function [h,ax,leg] = plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal,which_time_range,L2ext,FID)

%% filtered

eval(sprintf('Matchup_sat = [MatchupReal.Rrs_%s_filt_mean];',wl_sat)); % from satellite
eval(sprintf('Matchup_ins = [MatchupReal.Rrs_%s_insitu];',wl_ins)); % in situ

cond0 =  ~isnan(Matchup_sat)&~isnan(Matchup_ins)&...
      isfinite(Matchup_sat)&isfinite(Matchup_ins); % valid values
% 
% t_diff = [MatchupReal(:).scenetime]-[MatchupReal(:).insitutime];
% cond1 = abs(t_diff) <= years(1); % days(1) !!! Switched to comply with modification
% cond2 = abs(t_diff) <= years(1); % hours(3) !!! Switched to comply with modification

% cond3 = cond0 & cond0; % valid and less than 1 day !!! Switched to comply with modification
% cond4 = cond0 & cond0; % valid and less than 3 hours !!! Switched to comply with modification
% cond5 = Matchup_sat>0;



switch which_time_range
      case '3 hours'
            %%
            Matchup_ins_used = Matchup_ins(cond0);
            Matchup_sat_used = Matchup_sat(cond0);
            
            fs = 16;
            h = figure('Color','white','DefaultAxesFontSize',fs);
            plot(Matchup_ins_used,Matchup_sat_used,'ob')
            ylabel(['Satellite Rrs\_' wl_sat '(sr^{-1})'],'FontSize',fs)
            xlabel(['in situ Rrs\_' wl_ins '(sr^{-1})'],'FontSize',fs)
            axis equal
            
            Rrs_sat_min = min(Matchup_sat_used)*0.95;
            Rrs_sat_max = max(Matchup_sat_used)*1.05;
            Rrs_ins_min = min(Matchup_ins_used)*0.95;
            Rrs_ins_max = max(Matchup_ins_used)*1.05;
            
            Rrs_min = min([Rrs_sat_min Rrs_ins_min]);
            Rrs_max = max([Rrs_sat_max Rrs_ins_max]);
            
            xlim([Rrs_min Rrs_max])
            ylim([Rrs_min Rrs_max])
            
            hold on
            plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k')
            % plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
            % plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
            grid on
            leg = legend(['3 h; Total: ' num2str(sum(cond0)) ]);
            ax = gca;
            ax.XTick =ax.YTick;      
      
      
      
%       case 'all'
%             %%
%             Matchup_ins_used = nan; % for regression
%             Matchup_sat_used = nan; % for regression
%             
%             fs = 16;
%             h = figure('Color','white','DefaultAxesFontSize',fs);
%             plot(Matchup_ins(cond0),Matchup_sat(cond0),'ok')
%             hold on
%             plot(Matchup_ins(cond3),Matchup_sat(cond3),'sr')
%             plot(Matchup_ins(cond4),Matchup_sat(cond4),'*b')
%             ylabel(['Satellite Rrs\_' wl_sat '(sr^{-1})'],'FontSize',fs)
%             xlabel(['in situ Rrs\_' wl_ins '(sr^{-1})'],'FontSize',fs)
%             axis equal
%             
%             eval(['Rrs_sat_min = nanmin(cell2mat({MatchupReal.Rrs_' wl_sat '_filt_mean}))*0.95;'])
%             eval(['Rrs_sat_max = nanmax(cell2mat({MatchupReal.Rrs_' wl_sat '_filt_mean}))*1.05;'])
%             eval(['Rrs_ins_min = nanmin(cell2mat({MatchupReal.Rrs_' wl_ins '_insitu}))*0.95;'])
%             eval(['Rrs_ins_max = nanmax(cell2mat({MatchupReal.Rrs_' wl_ins '_insitu}))*1.05;'])
%             
%             Rrs_min = min([Rrs_sat_min Rrs_ins_min]);
%             Rrs_max = max([Rrs_sat_max Rrs_ins_max]);
%             
%             xlim([Rrs_min Rrs_max])
%             ylim([Rrs_min Rrs_max])
%             
%             hold on
%             plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k')
%             % plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
%             % plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
%             grid on
%             leg = legend(['3 d; N: ' num2str(sum(cond0)) ],['1 d; N: ' num2str(sum(cond3)) ],['3 h; N: ' num2str(sum(cond4)) ]);
%             ax = gca;
%             ax.XTick =ax.YTick;
%             
%       case '3 days'
%             %%
%             Matchup_ins_used = Matchup_ins(cond0); % for regression
%             Matchup_sat_used = Matchup_sat(cond0); % for regression
%             
%             fs = 16;
%             h = figure('Color','white','DefaultAxesFontSize',fs);
%             hp1 = plot(Matchup_ins_used,Matchup_sat_used,'ok');
%             
%             set(hp1,'XDataSource','Matchup_ins_used') 
%             set(hp1,'YDataSource','Matchup_sat_used') 
%             
%             ylabel(['Satellite Rrs\_' wl_sat '(sr^{-1})'],'FontSize',fs)
%             xlabel(['in situ Rrs\_' wl_ins '(sr^{-1})'],'FontSize',fs)
%             axis equal
%             
%             Rrs_sat_min = min(Matchup_sat_used);
%             Rrs_sat_max = max(Matchup_sat_used);
%             Rrs_ins_min = min(Matchup_ins_used);
%             Rrs_ins_max = max(Matchup_ins_used);
%             
%             Rrs_min = min([Rrs_sat_min Rrs_ins_min]);
%             Rrs_max = max([Rrs_sat_max Rrs_ins_max]);
%             
%             xlim([Rrs_min Rrs_max])
%             ylim([Rrs_min Rrs_max])
%             
%             hold on
%             plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k')
%             % plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
%             % plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
%             grid on
%             leg = legend(['3 d; N: ' num2str(sum(cond0))]);
%             ax = gca;
%             ax.XTick =ax.YTick;
%             
%             
%       case '1 day'
%             %%
%             Matchup_ins_used = Matchup_ins; % for regression
%             Matchup_sat_used = Matchup_sat; % for regression
%             
%             fs = 16;
%             h = figure('Color','white','DefaultAxesFontSize',fs);
%             plot(Matchup_ins(cond3),Matchup_sat(cond3),'sr')
%             ylabel(['Satellite Rrs\_' wl_sat '(sr^{-1})'],'FontSize',fs)
%             xlabel(['in situ Rrs\_' wl_ins '(sr^{-1})'],'FontSize',fs)
%             axis equal
%             
%             Rrs_sat_min = min(Matchup_sat_used)*0.95;
%             Rrs_sat_max = max(Matchup_sat_used)*1.05;
%             Rrs_ins_min = min(Matchup_ins_used)*0.95;
%             Rrs_ins_max = max(Matchup_ins_used)*1.05;
%             
%             Rrs_min = min([Rrs_sat_min Rrs_ins_min]);
%             Rrs_max = max([Rrs_sat_max Rrs_ins_max]);
%             
%             xlim([Rrs_min Rrs_max])
%             ylim([Rrs_min Rrs_max])
%             
%             hold on
%             plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k')
%             % plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
%             % plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
%             grid on
%             leg = legend(['1 d; N: ' num2str(sum(cond3)) ]);
%             ax = gca;
%             ax.XTick =ax.YTick;
            
end

if sum(isfinite(Matchup_ins_used))
      %% Statistics
      C_insitu_temp = Matchup_ins_used;
      
      C_alg_temp = Matchup_sat_used;
      
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
      
      maxref = Rrs_max;
      
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
      
      
      % display
      
      disp('-----------------------------------------')
      disp(['Data = ' which_time_range])
      disp(['ACO scheme = ' L2ext])
      disp(['Sat (nm) = ' wl_sat])
      disp(['InSitu (nm) = ' wl_ins])
      disp(['R^2 = ' num2str(rsq_SS)])
      disp(str_reg) % regression equation
      disp(['RMSE = ' num2str(RMSE)])
      disp(['N = ' num2str(size(C_insitu,2))])
      disp(['Mean APD (%) = ' num2str(Mean_APD)])
      disp(['St.Dev. APD (%) = ' num2str(Stdv_APD)])
      disp(['Median APD (%) = ' num2str(Median_APD)])
      disp(['Bias (%) = ' num2str(Percentage_Bias)])
      disp(['Median ratio = ' num2str(Median_ratio)])
      disp(['SIQR = ' num2str(SIQR)])
      disp(['rsq_corr = ' num2str(rsq_corr)])

      % latex table

      fprintf(FID,'%s & ',which_time_range);
      fprintf(FID,'$%s$ & ',L2ext);
      fprintf(FID,'%s & ',wl_sat);
      fprintf(FID,'%s & ',wl_ins);
      fprintf(FID,'%s & ',num2str(rsq_SS));
      fprintf(FID,'$%s$ & ',str_reg); % regression equation
      fprintf(FID,'%s & ',num2str(RMSE));
      fprintf(FID,'%s & ',num2str(size(C_insitu,2)));
      fprintf(FID,'%s & ',num2str(Mean_APD));
      fprintf(FID,'%s & ',num2str(Stdv_APD));
      fprintf(FID,'%s & ',num2str(Median_APD));
      fprintf(FID,'%s & ',num2str(Percentage_Bias));
      fprintf(FID,'%s & ',num2str(Median_ratio));
      fprintf(FID,'%s & ',num2str(SIQR));
      fprintf(FID,'%s',num2str(rsq_corr));
      fprintf(FID,'\\\\ \n');

      
else
      disp('Regression not calculated...')
end

ax = gca;
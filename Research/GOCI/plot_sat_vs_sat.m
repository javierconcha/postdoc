function [h,ax,leg] = plot_sat_vs_sat(parname,wl_x,wl_y,sat_name_x,sat_name_y,x_data,y_data,varargin)

%% filtered
cond0 =  ~isnan(y_data)&~isnan(x_data)&...
      isfinite(y_data)&isfinite(x_data)&...
      y_data>0&x_data>0; % valid values

%% plot
x_data_used = x_data(cond0);
y_data_used = y_data(cond0);

fs = 22;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot(x_data_used,y_data_used,'ob','MarkerSize',12)


axis equal

% if min(y_data_used) <0
%       par_y_data_min = min(y_data_used)*1.1;
% else
% %       par_y_data_min = 0;
%       par_y_data_min = min(y_data_used)*0.95;
% end
% 
% if min(x_data_used) <0
%       par_x_data_min = min(x_data_used)*1.1;
% else
% %       par_x_data_min = 0;
%       par_x_data_min = min(x_data_used)*0.95;
% end
% 
% par_y_data_max = max(y_data_used)*1.05;
% % par_x_data_min = min(x_data_used)*0.95;
% par_x_data_max = max(x_data_used)*1.05;
% 
% % par_min = min([par_y_data_min par_x_data_min]);
% par_min = 0;
% par_max = max([par_y_data_max par_x_data_max]);
% 


switch wl_x
      case '412'
           par_min = 0;
           par_max = 2E-2;
      case '443'
           par_min = 0;
           par_max = 1.5E-2;
      case '490'
           par_min = 0;
           par_max = 10E-3;
      case '555'
           par_min = 0;
           par_max = 3.0E-3;   
      case '547'
           par_min = 0;
           par_max = 3.0E-3;           
      case '660'
           par_min = 0;
           par_max = 1.5E-3;    
      case '667'
           par_min = 0;
           par_max = 1.5E-3;            
      case '680'
           par_min = 0;
           par_max = 1.5E-3;  
      case '678'
           par_min = 0;
           par_max = 1.5E-3;            
end
      
xlim([par_min par_max])
ylim([par_min par_max])

hold on
plot([par_min par_max],[par_min par_max],'--k','LineWidth',1.5)
% plot([0 par_max],[0.1*par_max 1.1*par_max],':k')
% plot([0 par_max],[-0.1*par_max 0.9*par_max],':k')
% grid on
leg = legend(['N: ' num2str(sum(cond0)) ],'Location','SouthEast');
% to show scientific notation in axes

% find how many zeros after the decimal point
x = par_max;
x = abs(x); %in case of negative numbers
n = 0;
while (floor(x*10^n)==0)
      n = n+1;     
end

if n==0 || n==1
      n = 0;
end

ax = gca;

ax.XAxis.Exponent = -n; 
ax.YAxis.Exponent = -n;

ax.XAxis.TickLabelFormat = '%,.2f';
ax.XTick =ax.YTick;
ax.YAxis.TickLabelFormat = '%,.2f';

% set label for plot
switch parname
      case 'Rrs'
            xlabel([sat_name_x ' {\it R}_{rs}(' wl_x ') (10^{' num2str(ax.XAxis.Exponent) '}sr^{-1})'],'FontSize',fs)
            ylabel([sat_name_y ' {\it R}_{rs}(' wl_y ') (10^{' num2str(ax.YAxis.Exponent) '}sr^{-1})'],'FontSize',fs)
      case 'chlor_a'
            xlabel([sat_name_x ' Chl-{\ita}'],'FontSize',fs)
            ylabel([sat_name_y ' Chl-{\ita}'],'FontSize',fs)
      case 'ag_412_mlrc'
            switch sat_name_x
                  case {'GOCI','AQUA'}
                        xlabel([sat_name_x ' a_{g:mlrc}(412)'],'FontSize',fs)
                  case 'VIIRS'
                        xlabel([sat_name_x ' a_{g:mlrc}(410)'],'FontSize',fs)
            end
            switch sat_name_y
                  case {'GOCI','AQUA'}
                        ylabel([sat_name_y ' a_{g:mlrc}(412)'],'FontSize',fs)
                  case 'VIIRS'
                        ylabel([sat_name_y ' a_{g:mlrc}(410)'],'FontSize',fs)
            end
      case 'poc'
            xlabel([sat_name_x ' POC'],'FontSize',fs)
            ylabel([sat_name_y ' POC'],'FontSize',fs)
      case 'angstrom'
            xlabel([sat_name_x ' Angstrom'],'FontSize',fs)
            ylabel([sat_name_y ' Angstrom'],'FontSize',fs)
      case 'aot_865'
            switch sat_name_x
                  case 'GOCI'
                        xlabel([sat_name_x ' AOT(865)'],'FontSize',fs)
                  case 'VIIRS'
                        xlabel([sat_name_x ' AOT(862)'],'FontSize',fs)
                  case 'AQUA'
                        xlabel([sat_name_x ' AOT(869)'],'FontSize',fs)
            end
            switch sat_name_y
                  case 'GOCI'
                        ylabel([sat_name_y ' AOT(865)'],'FontSize',fs)
                  case 'VIIRS'
                        ylabel([sat_name_y ' AOT(862)'],'FontSize',fs)
                  case 'AQUA'
                        ylabel([sat_name_y ' AOT(869)'],'FontSize',fs)
            end
      case 'brdf'
            xlabel([sat_name_x ' BRDF'],'FontSize',fs)
            ylabel([sat_name_y ' BRDF'],'FontSize',fs)
            
end

% write x10^ in the axis labels
TickLabelAux = ax.YTickLabel;
ax.XAxis.Exponent = 0;
ax.YAxis.Exponent = 0;
ax.XTickLabelMode = 'Manual';
ax.YTickLabelMode = 'Manual';
ax.XTickLabel = TickLabelAux;
ax.YTickLabel = TickLabelAux;




%% Stats
if sum(isfinite(x_data_used))
      %% Statistics
      C_insitu_temp = x_data_used;
      
      C_alg_temp = y_data_used;
      
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
      
      maxref = par_max;
      
      x1=[0 maxref];
      y1=a(1).*x1+a(2);
      
      figure(h)
      plot(x1,y1,'r-','LineWidth',1.5)
      
      
      SStot = sum((C_alg-nanmean(C_alg)).^2);
      SSres = sum((C_alg-polyval(a,C_insitu)).^2);
      rsq_SS = 1-(SSres/SStot);
      rsq_corr = corr(C_insitu',C_alg')^2; % when OLS rsq_SS and rsq_corr are equal
      
      % bias
      
      DN = C_alg-C_insitu;
      
      Mean_bias = mean(DN);
      MAE = mean(abs(DN));
      
      N = sum(C_insitu>0&~isnan(C_insitu));
      
%       if a(2)>=0
%             str1 = sprintf('{\\it y} = %2.4f {\\it x} + %2.4f \n{\\it R}^2 = %2.4f; {\\it N} = %i \nRMSE = %2.4f\nMean Bias = %2.5f\nMAE = %2.5f',...
%                   a(1),abs(a(2)),rsq_SS,N,RMSE,Mean_bias,MAE);
%             str_reg = sprintf('{\\it y} = %2.4f {\\it x} + %2.4f',a(1),abs(a(2)));
%       else
%             str1 = sprintf('{\\it y} = %2.4f {\\it x} - %2.4f \n{\\it R}^2 = %2.4f; {\\it N} = %i \nRMSE = %2.4f\nMean Bias = %2.5f\nMAE = %2.5f',...
%                   a(1),abs(a(2)),rsq_SS,N,RMSE,Mean_bias,MAE);
%             str_reg = sprintf('{\\it y} = %2.4f {\\it x} - %2.4f',a(1),abs(a(2)));
%       end
      
      if a(2)>=0
            str1 = sprintf('Mean Bias = %1.6f\nMAE = %1.6f\n{\\it N} = %i',...
                  Mean_bias,MAE,N);
            str_reg = sprintf('{\\it y} = %2.4f {\\it x} + %2.4f',a(1),abs(a(2)));
      else
            str1 = sprintf('Mean Bias = %1.6f\nMAE = %1.6f\n{\\it N} = %i',...
                  Mean_bias,MAE,N);
            str_reg = sprintf('{\\it y} = %2.4f {\\it x} - %2.4f',a(1),abs(a(2)));
      end
      
      xLimits = get(gca,'XLim');
      yLimits = get(gca,'YLim');
      xLoc = xLimits(1)+0.02*(xLimits(2)-xLimits(1));
      yLoc = yLimits(1)+0.87*(yLimits(2)-yLimits(1));
      figure(h)
      hold on
      text(xLoc,yLoc,str1,'FontSize',fs,'FontWeight','normal');
      
      

      
      % display
      
      disp('-----------------------------------------')
      %       disp(['Data = ' which_time_range])
      %       disp(['ACO scheme = ' L2ext])
      disp(['Sat (nm) = ' wl_y])
      disp(['InSitu (nm) = ' wl_x])
      disp(['R^2 = ' num2str(rsq_SS)])
      disp(str_reg) % regression equation
      disp(['RMSE = ' num2str(RMSE)])
      disp(['N = ' num2str(N)])
      disp(['Mean APD (%) = ' num2str(Mean_APD)])
      disp(['St.Dev. APD (%) = ' num2str(Stdv_APD)])
      disp(['Median APD (%) = ' num2str(Median_APD)])
      disp(['Bias (%) = ' num2str(Percentage_Bias)])
      disp(['Median ratio = ' num2str(Median_ratio)])
      disp(['SIQR = ' num2str(SIQR)])
      disp(['rsq_corr = ' num2str(rsq_corr)])
      disp(['Mean Bias = ' num2str(Mean_bias)])
      disp(['MAE = ' num2str(MAE)])
      
      % latex table
      
      if nargin == 8
            fprintf(FID,'%s & ',which_time_range);
            fprintf(FID,'$%s$ & ',L2ext);
            fprintf(FID,'%s & ',wl_y);
            fprintf(FID,'%s & ',wl_x);
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
      end
      
      
else
      disp('Regression not calculated...')
end

ax = gca;
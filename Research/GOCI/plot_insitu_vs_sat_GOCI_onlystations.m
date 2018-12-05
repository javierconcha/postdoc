function [ax,leg] = plot_insitu_vs_sat_GOCI_onlystations(wl_ins,wl_sat,x_data,y_data,x_data_datetime,station_ID,color_line,h,fs,source)

%% filtered

Matchup_ins = x_data;
Matchup_sat = y_data;

cond0 =  ~isnan(Matchup_sat)&~isnan(Matchup_ins)&...
      isfinite(Matchup_sat)&isfinite(Matchup_ins); % valid values

%% plot
Matchup_ins_used = Matchup_ins(cond0);
Matchup_sat_used = Matchup_sat(cond0);

figure(h)
% plot(Matchup_ins_used,Matchup_sat_used,'ob','MarkerSize',12)

axis equal

% station 1: aoc_gageo
cond_plot = station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'o','Color',color_line,'MarkerSize',8,'LineWidth',0.5)

% station 2: aoc_ieodo
cond_plot = station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^','Color',color_line,'MarkerSize',8,'LineWidth',0.5)

% station 3: socheongch
cond_plot = station_ID==3;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'x','Color',color_line,'MarkerSize',8,'LineWidth',0.5)

if min(Matchup_sat_used) <0
      Rrs_sat_min = min(Matchup_sat_used)*1.1;
else
      Rrs_sat_min = 0;
end
Rrs_sat_max = max(Matchup_sat_used)*1.05;
Rrs_ins_min = min(Matchup_ins_used)*0.95;
Rrs_ins_max = max(Matchup_ins_used)*1.05;

Rrs_min = min([Rrs_sat_min Rrs_ins_min]);
Rrs_max = max([Rrs_sat_max Rrs_ins_max]);

switch wl_sat
      case '412'
            lim = [0 16E-3];
      case '443'
            lim = [0 16E-3];
      case '490'
            lim = [0 22E-3];
      case '555'
            lim = [0 25E-3];
      case '660'
            lim = [0 10E-3];
end

xlim(lim)
ylim(lim)

hold on
plot(lim,lim,'--k','LineWidth',1.5)
% plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
% plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
% grid on
box on
leg = legend(['3 h; Total: ' num2str(sum(cond0)) ],'Location','SouthEast');
% to show scientific notation in axes
ax = gca;
ax.XAxis.TickLabelFormat = '%,.1f';
ax.XAxis.Exponent = -3;
ax.XTick =ax.YTick;
ax.YAxis.TickLabelFormat = '%,.1f';
ax.YAxis.Exponent = -3;

xlabel(['In situ {\it R}_{rs}(' wl_ins ') (\times10^{' num2str(ax.XAxis.Exponent) '}sr^{-1})'],'FontSize',fs)
ylabel(['Satellite {\it R}_{rs}(' wl_sat ') (\times10^{' num2str(ax.XAxis.Exponent) '}sr^{-1})'],'FontSize',fs)

% write x10^ in the axis labels
TickLabelAux = ax.YTickLabel;
ax.XAxis.Exponent = 0;
ax.YAxis.Exponent = 0;
ax.XTickLabelMode = 'Manual';
ax.YTickLabelMode = 'Manual';
ax.XTickLabel = TickLabelAux;
ax.YTickLabel = TickLabelAux;



if sum(isfinite(Matchup_ins_used))    
      
%       [~,~,~] = calc_stat(Matchup_ins_0,Matchup_sat_0,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_1,Matchup_sat_1,Rrs_max,wl_sat,wl_ins,FID);      
%       [~,~,~] = calc_stat(Matchup_ins_2,Matchup_sat_2,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_3,Matchup_sat_3,Rrs_max,wl_sat,wl_ins,FID);      
%       [~,~,~] = calc_stat(Matchup_ins_4,Matchup_sat_4,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_5,Matchup_sat_5,Rrs_max,wl_sat,wl_ins,FID);      
%       [~,~,~] = calc_stat(Matchup_ins_6,Matchup_sat_6,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_7,Matchup_sat_7,Rrs_max,wl_sat,wl_ins,FID);
      [x1,y1,~] = calc_stat(Matchup_ins_used,Matchup_sat_used,lim(2),wl_sat,wl_ins,source);
      
      % plot
      figure(h)
      plot(x1,y1,'-','Color',color_line,'LineWidth',2.0)
      
      
      % xLimits = get(gca,'XLim');
      % yLimits = get(gca,'YLim');
      % xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
      % yLoc = yLimits(1)+0.85*(yLimits(2)-yLimits(1));
      % figure(h)
      % hold on
      % text(xLoc,yLoc,str1,'FontSize',fs-1,'FontWeight','normal');
      
else
      disp('Regression not calculated...')
end

ax = gca;

function [x1,y1,str1] = calc_stat(Matchup_ins_used,Matchup_sat_used,Rrs_max,wl_sat,wl_ins,source)

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

PD = abs(C_insitu-C_alg)./C_insitu; % percent difference

Mean_APD = 100*mean(PD);% mean of the absolute percent difference (APD)

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

SStot = sum((C_alg-nanmean(C_alg)).^2);
SSres = sum((C_alg-polyval(a,C_insitu)).^2);
rsq_SS = 1-(SSres/SStot);
rsq_corr = corr(C_insitu',C_alg')^2; % when OLS rsq_SS and rsq_corr are equal

if a(2)>=0
      str1 = sprintf('y: %2.2f x + %2.4f \n R^2: %2.2f; N: %i \n RMSE: %2.4f',...
            a(1),abs(a(2)),rsq_SS,size(C_insitu,2),RMSE);
      str_reg = sprintf('y: %2.2f x + %2.4f',a(1),abs(a(2)));
else
      str1 = sprintf('y: %2.2f x - %2.4f \n R^2: %2.2f; N: %i \n RMSE: %2.4f',...
            a(1),abs(a(2)),rsq_SS,size(C_insitu,2),RMSE);
      str_reg = sprintf('y: %2.2f x - %2.4f',a(1),abs(a(2)));
end

% bias

DN = C_alg-C_insitu;

Mean_bias = mean(DN);
MAE = mean(abs(DN));

% MAE

% display

% disp('-----------------------------------------')
% disp(['Sat (nm) = ' wl_sat])
% disp(['InSitu (nm) = ' wl_ins])
% disp(source)
% disp(['R^2 = ' num2str(rsq_SS,'%2.2f')])
% disp(['m = ' num2str(a(1),'%2.2f')])
% disp(['b = ' num2str(a(2),'%2.4f')])
% disp(['RMSE = ' num2str(RMSE,'%2.4f')])
% disp(['N = ' num2str(size(C_insitu,2))])
% disp(['Mean APD (%) = ' num2str(Mean_APD,'%2.1f')])
% disp(['St.Dev. APD (%) = ' num2str(Stdv_APD,'%2.1f')])
% disp(['Median APD (%) = ' num2str(Median_APD,'%2.2f')])
% disp(['Bias (%) = ' num2str(Percentage_Bias,'%2.1f')])
% disp(['Median ratio = ' num2str(Median_ratio,'%2.2f')])
% disp(['SIQR = ' num2str(SIQR,'%2.2f')])
% disp(['Mean_bias = ' num2str(Mean_bias,'%2.5f')])
% disp(['MAE = ' num2str(MAE,'%2.5f')])


% Sat (nm)  & InSitu (nm)  & R^2  & m  & b  & RMSE  & N  & Mean APD (\%)  & St.Dev. APD (%)  & Median APD (%)  & Bias (%)  & Median ratio  & SIQR  & Mean_bias  & MAE 
fprintf('%s', wl_sat)
fprintf(' & %s', wl_ins)
fprintf(' & %s', source)
fprintf(' & %s', num2str(rsq_SS,'%2.2f'))
fprintf(' & %s', num2str(a(1),'%2.2f')) 
fprintf(' & %s', num2str(a(2),'%2.4f'))
fprintf(' & %s', num2str(RMSE,'%2.4f'))
fprintf(' & %s', num2str(size(C_insitu,2)))
fprintf(' & %s', num2str(Mean_APD,'%2.1f'))
fprintf(' & %s', num2str(Stdv_APD,'%2.1f'))
fprintf(' & %s', num2str(Median_APD,'%2.2f'))
fprintf(' & %s', num2str(Percentage_Bias,'%2.1f'))
fprintf(' & %s', num2str(Median_ratio,'%2.2f'))
fprintf(' & %s', num2str(SIQR,'%2.2f'))
fprintf(' & %s', num2str(Mean_bias,'%2.5f'))
fprintf(' & %s \\\\\n', num2str(MAE,'%2.5f'))

% disp(['rsq_corr = ' num2str(rsq_corr,'%2.2f')])

% latex table

% % if nargin == 6
%       fprintf(FID,'%s (%s) & ',wl_sat,wl_ins);
%       fprintf(FID,'%2.2f & ',rsq_SS);
%       fprintf(FID,'%1.2f & ',a(1)); % regression equation
%       fprintf(FID,'%1.4f & ',a(2)); % regression equation
%       fprintf(FID,'%2.4f & ',RMSE);
%       fprintf(FID,'%2.0f & ',size(C_insitu,2));
%       fprintf(FID,'%2.1f & ',Mean_APD);
%       fprintf(FID,'%2.1f & ',Stdv_APD);
%       fprintf(FID,'%2.1f & ',Median_APD);
%       fprintf(FID,'%2.1f & ',Percentage_Bias);
%       fprintf(FID,'%2.2f & ',Median_ratio);
%       fprintf(FID,'%2.2f ',SIQR);
% %       fprintf(FID,'%2.2f',rsq_corr);
%       fprintf(FID,'\\\\ \n');
% end

function [h,ax,leg] = plot_insitu_vs_sat_GOCI(wl_sat,wl_ins,x_data,y_data,x_data_datetime,station_ID,FID)

%% filtered

Matchup_ins = x_data;
Matchup_sat = y_data;

cond0 =  ~isnan(Matchup_sat)&~isnan(Matchup_ins)&...
      isfinite(Matchup_sat)&isfinite(Matchup_ins); % valid values

%% plot
Matchup_ins_used = Matchup_ins(cond0);
Matchup_sat_used = Matchup_sat(cond0);

fs = 20;
h = figure('Color','white','DefaultAxesFontSize',fs);
% plot(Matchup_ins_used,Matchup_sat_used,'ob','MarkerSize',12)
xlabel(['In situ R_{rs}(' wl_ins ') (sr^{-1})'],'FontSize',fs)
ylabel(['Satellite R_{rs}(' wl_sat ') (sr^{-1})'],'FontSize',fs)
axis equal

% Hour 0
cond_used = cond0&hour(x_data_datetime)==0;
Matchup_ins_0 = Matchup_ins(cond_used);
Matchup_sat_0 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'or','MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^r','MarkerSize',14,'LineWidth',3)

% Hour 1 
cond_used = cond0&hour(x_data_datetime)==1;
Matchup_ins_1 = Matchup_ins(cond_used);
Matchup_sat_1 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'og','MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^g','MarkerSize',14,'LineWidth',3)

% Hour 2
cond_used = cond0&hour(x_data_datetime)==2;
Matchup_ins_2 = Matchup_ins(cond_used);
Matchup_sat_2 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'ob','MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^b','MarkerSize',14,'LineWidth',3)

% Hour 3
cond_used = cond0&hour(x_data_datetime)==3;
Matchup_ins_3 = Matchup_ins(cond_used);
Matchup_sat_3 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'ok','MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^k','MarkerSize',14,'LineWidth',3)

% Hour 4
cond_used = cond0&hour(x_data_datetime)==4;
Matchup_ins_4 = Matchup_ins(cond_used);
Matchup_sat_4 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'oc','MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^c','MarkerSize',14,'LineWidth',3)

% Hour 5
cond_used = cond0&hour(x_data_datetime)==5;
Matchup_ins_5 = Matchup_ins(cond_used);
Matchup_sat_5 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'om','MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^m','MarkerSize',14,'LineWidth',3)

% Hour 6
cond_used = cond0&hour(x_data_datetime)==6;
Matchup_ins_6 = Matchup_ins(cond_used);
Matchup_sat_6 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'o','Color',[1 0.5 0],'MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^','Color',[1 0.5 0],'MarkerSize',14,'LineWidth',3)

% Hour 7
cond_used = cond0&hour(x_data_datetime)==7;
Matchup_ins_7 = Matchup_ins(cond_used);
Matchup_sat_7 = Matchup_sat(cond_used);

% station 1: aoc_gageo
cond_plot = cond_used&station_ID==1;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'o','Color',[0.5 0 0.5],'MarkerSize',14,'LineWidth',3)

% station 2: aoc_ieodo
cond_plot = cond_used&station_ID==2;
Matchup_ins_plot = Matchup_ins(cond_plot);
Matchup_sat_plot = Matchup_sat(cond_plot);
figure(gcf)
hold on
plot(Matchup_ins_plot,Matchup_sat_plot,'^','Color',[0.5 0 0.5],'MarkerSize',14,'LineWidth',3)

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

xlim([Rrs_min Rrs_max])
ylim([Rrs_min Rrs_max])

hold on
plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k','LineWidth',1.5)
% plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
% plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
grid on
leg = legend(['3 h; Total: ' num2str(sum(cond0)) ],'Location','SouthEast');
% to show scientific notation in axes
ax = gca;
ax.XAxis.TickLabelFormat = '%,.1f';
ax.XAxis.Exponent = -3;
ax.YTick =ax.XTick;
ax.YAxis.TickLabelFormat = '%,.1f';
ax.YAxis.Exponent = -3;


if sum(isfinite(Matchup_ins_used))    
      
%       [~,~,~] = calc_stat(Matchup_ins_0,Matchup_sat_0,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_1,Matchup_sat_1,Rrs_max,wl_sat,wl_ins,FID);      
%       [~,~,~] = calc_stat(Matchup_ins_2,Matchup_sat_2,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_3,Matchup_sat_3,Rrs_max,wl_sat,wl_ins,FID);      
%       [~,~,~] = calc_stat(Matchup_ins_4,Matchup_sat_4,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_5,Matchup_sat_5,Rrs_max,wl_sat,wl_ins,FID);      
%       [~,~,~] = calc_stat(Matchup_ins_6,Matchup_sat_6,Rrs_max,wl_sat,wl_ins,FID);
%       [~,~,~] = calc_stat(Matchup_ins_7,Matchup_sat_7,Rrs_max,wl_sat,wl_ins,FID);
      [x1,y1,str1] = calc_stat(Matchup_ins_used,Matchup_sat_used,Rrs_max,wl_sat,wl_ins,FID);
      
      % plot
      figure(h)
      plot(x1,y1,'r-','LineWidth',1.5)
      
      
      xLimits = get(gca,'XLim');
      yLimits = get(gca,'YLim');
      xLoc = xLimits(1)+0.1*(xLimits(2)-xLimits(1));
      yLoc = yLimits(1)+0.85*(yLimits(2)-yLimits(1));
      figure(h)
      hold on
      text(xLoc,yLoc,str1,'FontSize',fs-1,'FontWeight','normal');
      
else
      disp('Regression not calculated...')
end

ax = gca;

function [x1,y1,str1] = calc_stat(Matchup_ins_used,Matchup_sat_used,Rrs_max,wl_sat,wl_ins,FID)

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

% display

disp('-----------------------------------------')
%       disp(['Data = ' which_time_range])
%       disp(['ACO scheme = ' L2ext])
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

% if nargin == 6
      fprintf(FID,'%s (%s) & ',wl_sat,wl_ins);
      fprintf(FID,'%2.2f & ',rsq_SS);
      fprintf(FID,'%1.2f & ',a(1)); % regression equation
      fprintf(FID,'%1.4f & ',a(2)); % regression equation
      fprintf(FID,'%2.4f & ',RMSE);
      fprintf(FID,'%2.0f & ',size(C_insitu,2));
      fprintf(FID,'%2.1f & ',Mean_APD);
      fprintf(FID,'%2.1f & ',Stdv_APD);
      fprintf(FID,'%2.1f & ',Median_APD);
      fprintf(FID,'%2.1f & ',Percentage_Bias);
      fprintf(FID,'%2.2f & ',Median_ratio);
      fprintf(FID,'%2.2f ',SIQR);
%       fprintf(FID,'%2.2f',rsq_corr);
      fprintf(FID,'\\\\ \n');
% end

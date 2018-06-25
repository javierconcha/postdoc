function [g_siqr_mean,g_siqr_std,N_siqr] = plot_gains(datetime_vec,g,wl,FID)

fs = 30;

%% all data
% plot(datetime_vec', g,'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',10)
plot(datetime_vec', g,'ok','Color',[0.5 0.5 0.5],'MarkerSize',12,'LineWidth',3)
%       xlabel('Time','FontSize',fs)
ylabel('Gain Coefficient','FontSize',fs)

%       title(wl{idx0},'FontSize',fs)

% mean all data
ax = gca;
hold on
%       plot(ax.XLim,[nanmean(g) nanmean(g)],'r--')

% semi-interquartile range
Q1 = quantile(g(~isnan(g)),0.25);
Q3 = quantile(g(~isnan(g)),0.75);
cond_siqr = g >= Q1&g <= Q3;
g_siqr = g(cond_siqr);

% plot semi-interquartile range data
datetime_siqr = datetime_vec(cond_siqr);
% plot(datetime_siqr,g_siqr,'ok','MarkerFaceColor', 'k','MarkerSize',10)
plot(datetime_siqr,g_siqr,'ok','MarkerSize',12,'LineWidth',3)

% siqr mean
g_siqr_mean = nanmean(g_siqr);
g_siqr_std =  nanstd(g_siqr);
N_siqr= sum(~isnan(g_siqr));

ylim([0.85 1.15])

% Half screen
screen_size = get(0, 'ScreenSize');
%       origSize = get(gcf, 'Position') % grab original on screen size
set(gcf, 'Position', [1 1 screen_size(3) 0.5*screen_size(4)] ); %set to screen size


% Plot SIQR mean
plot(ax.XLim,[g_siqr_mean g_siqr_mean],'r','LineWidth',2.0)
%       plot(ax.XLim,[Q1 Q1],'b')
%       plot(ax.XLim,[Q3 Q3],'b')






% shrink plot y-axis
ax.PlotBoxAspectRatio(2)=0.25;
ax.YAxis.TickLabelFormat = '%.2f';

% x label with Month and Year
xData = [datenum('01-01-2011') datenum('05-01-2011') datenum('09-01-2011') ...
      datenum('01-01-2012') datenum('05-01-2012') datenum('09-01-2012') ...
      datenum('01-01-2013') datenum('05-01-2013') datenum('09-01-2013') ...
      datenum('01-01-2014') datenum('05-01-2014') datenum('09-01-2014') ...
      datenum('01-01-2015') datenum('05-01-2015') datenum('09-01-2015') ...
      datenum('01-01-2016') datenum('05-01-2016') datenum('09-01-2016') ...
      datenum('01-01-2017') datenum('05-01-2017')];

ax.XTickMode = 'manual';

ax.XTick = xData;

set(gca,'XTickLabel',[]);

if strcmp(wl,'745')
      ylim([0.9 1.0])
end


if strcmp(wl,'680')||strcmp(wl,'745')
      
      datetick(ax,'x','m','keepticks')
      
      x_labels{1} = sprintf('J \n');
      x_labels{2} = sprintf('M\n      2011');
      x_labels{3} = sprintf('S \n');
      
      x_labels{4} = sprintf('J \n');
      x_labels{5} = sprintf('M\n      2012');
      x_labels{6} = sprintf('S \n');
      
      x_labels{7} = sprintf('J \n');
      x_labels{8} = sprintf('M\n      2013');
      x_labels{9} = sprintf('S \n');
      
      x_labels{10} = sprintf('J \n');
      x_labels{11} = sprintf('M\n      2014');
      x_labels{12} = sprintf('S \n');
      
      x_labels{13} = sprintf('J \n');
      x_labels{14} = sprintf('M\n      2015');
      x_labels{15} = sprintf('S \n');
      
      x_labels{16} = sprintf('J \n');
      x_labels{17} = sprintf('M\n      2016');
      x_labels{18} = sprintf('S \n');
      
      x_labels{19} = sprintf('J \n');
      x_labels{20} = sprintf('M\n      2017');
      
      [~,~] = format_ticks(gca,x_labels);
         
end

% Major Ticks
line([datenum('01-01-2012') datenum('01-01-2012')],[0.85 0.88],'Color','k')
line([datenum('01-01-2013') datenum('01-01-2013')],[0.85 0.88],'Color','k')
line([datenum('01-01-2014') datenum('01-01-2014')],[0.85 0.88],'Color','k')
line([datenum('01-01-2015') datenum('01-01-2015')],[0.85 0.88],'Color','k')
line([datenum('01-01-2016') datenum('01-01-2016')],[0.85 0.88],'Color','k')
line([datenum('01-01-2017') datenum('01-01-2017')],[0.85 0.88],'Color','k')

xlim([datenum('01-01-2011') datenum('09-01-2017')])

% Plot SIQR mean for correcting display error
plot(ax.XLim,[g_siqr_mean g_siqr_mean],'r','LineWidth',2.0)

% reference to 1

plot(ax.XLim,[1 1],'--k','LineWidth',1.0)

hl = legend(['Outside SIQR; N=' num2str(sum(~isnan(g)))],...
      ['SIQR; N=' num2str(N_siqr)],...
      ['Mean SIQR=' num2str(g_siqr_mean,'%1.4f\n')]);

set(hl,'FontSize',fs-5);
%% LaTeX

% if strcmp(wl,'412')
%       fprintf(FID,'&%s   \n',wl);
%       fprintf(FID,'&%.4f \n',g_siqr_mean);
%       fprintf(FID,'&%.4f \n',g_siqr_std);
%       fprintf(FID,'&%.4f \n',g_siqr_std/sqrt(N_siqr));
%       fprintf(FID,'&%.0f \n',N_siqr);
%       % fprintf(FID,'\\\\ \n');
% end
% 
% s2 =  {'&680';'&0.9672';'&0.0035';'&0.0002';'&476'};
% 
% fileID = fopen('Gvcal_SW_Table.tex');
% s = textscan(fileID,'%s','Delimiter','\n');
% fclose(fileID);
% 
% s{end+1}=s2;
% 
% formatSpec = '%s %s\n';
% 
% [nrows,ncols] = size(s);
% for row = 1:nrows
%     fprintf(FID,formatSpec,s{row,:});
% end
%% Testing Normality for diurnal values
% Rrs_412
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Rrs_412');
title('Rrs_412')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.Rrs_412_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_412_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_412_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','Rrs_412');
title('Rrs_412')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_00 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_01 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_02 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_04 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_05 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_06 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_H,GOCI_DailyStatMatrix(idx_back(idx)).Rrs_412_P))
      xlabel('x')
      ylabel('F(x)')
end

%% Rrs_443
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Rrs_443');
title('Rrs_443')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.Rrs_443_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_443_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_443_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','Rrs_443');
title('Rrs_443')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_00 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_01 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_02 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_04 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_05 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_06 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_H,GOCI_DailyStatMatrix(idx_back(idx)).Rrs_443_P))
      xlabel('x')
      ylabel('F(x)')
end

%% Rrs_490
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Rrs_490');
title('Rrs_490')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.Rrs_490_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_490_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_490_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','Rrs_490');
title('Rrs_490')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_00 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_01 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_02 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_04 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_05 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_06 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_H,GOCI_DailyStatMatrix(idx_back(idx)).Rrs_490_P))
      xlabel('x')
      ylabel('F(x)')
end

%% Rrs_555
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Rrs_555');
title('Rrs_555')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.Rrs_555_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_555_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_555_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','Rrs_555');
title('Rrs_555')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_00 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_01 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_02 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_04 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_05 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_06 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_H,GOCI_DailyStatMatrix(idx_back(idx)).Rrs_555_P))
      xlabel('x')
      ylabel('F(x)')
end

%% Rrs_660
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Rrs_660');
title('Rrs_660')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.Rrs_660_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_660_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_660_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','Rrs_660');
title('Rrs_660')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_00 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_01 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_02 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_04 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_05 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_06 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_H,GOCI_DailyStatMatrix(idx_back(idx)).Rrs_660_P))
      xlabel('x')
      ylabel('F(x)')
end

%% Rrs_680
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','Rrs_680');
title('Rrs_680')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.Rrs_680_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_680_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.Rrs_680_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','Rrs_680');
title('Rrs_680')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_00 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_01 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_02 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_04 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_05 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_06 GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_H,GOCI_DailyStatMatrix(idx_back(idx)).Rrs_680_P))
      xlabel('x')
      ylabel('F(x)')
end

%% chlor_a
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','chlor_a');
title('chlor_a')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.chlor_a_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.chlor_a_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.chlor_a_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','chlor_a');
title('chlor_a')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_00 GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_01 GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_02 GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_04 GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_05 GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_06 GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_H,GOCI_DailyStatMatrix(idx_back(idx)).chlor_a_P))
      xlabel('x')
      ylabel('F(x)')
end

%% poc
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','poc');
title('poc')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.poc_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.poc_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.poc_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','poc');
title('poc')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).poc_00 GOCI_DailyStatMatrix(idx_back(idx)).poc_01 GOCI_DailyStatMatrix(idx_back(idx)).poc_02 GOCI_DailyStatMatrix(idx_back(idx)).poc_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).poc_04 GOCI_DailyStatMatrix(idx_back(idx)).poc_05 GOCI_DailyStatMatrix(idx_back(idx)).poc_06 GOCI_DailyStatMatrix(idx_back(idx)).poc_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).poc_H,GOCI_DailyStatMatrix(idx_back(idx)).poc_P))
      xlabel('x')
      ylabel('F(x)')
end

%% ag_412_mlrc
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','ag_412_mlrc');
title('ag_412_mlrc')
subplot(2,1,1)
cond1 = [GOCI_DailyStatMatrix.ag_412_mlrc_N_mean]>=3;
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.ag_412_mlrc_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([GOCI_DailyStatMatrix(cond1).datetime],[GOCI_DailyStatMatrix.ag_412_mlrc_P],'o-')
ylabel('p')

xlabel('Date')
%

idx_back = find(cond1);

h = figure('Color','white','Name','ag_412_mlrc');
title('ag_412_mlrc')
for idx = 1:100
      
      diurnal_data =[...
            GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_00 GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_01 GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_02 GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_03 ...
            GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_04 GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_05 GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_06 GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_07];
      
      x = (diurnal_data-nanmean(diurnal_data))/nanstd(diurnal_data);
      
      subplot(10,10,idx)
      cdfplot(x)
      hold on
      x_values = linspace(min(x),max(x));
      plot(x_values,normcdf(x_values,0,1),'r-')
      % legend('Empirical CDF','Standard Normal CDF','Location','best')
      title(sprintf('n=%i;h=%i;p=%1.4f',idx_back(idx),GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_H,GOCI_DailyStatMatrix(idx_back(idx)).ag_412_mlrc_P))
      xlabel('x')
      ylabel('F(x)')
end

%% Testing Normality for 3-day using kstest
%% Rrs_412
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; Rrs_412');
subplot(2,1,1)
plot([three_day_seq.tod_Rrs_412_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_Rrs_412_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; Rrs_412');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_Rrs_412_All-three_day_seq(idx).tod_Rrs_412_All_mean)/three_day_seq(idx).tod_Rrs_412_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_Rrs_412_All_H,three_day_seq(idx).tod_Rrs_412_All_P))
xlabel('x')
ylabel('F(x)')
end

%% Rrs_443
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; Rrs_443');
subplot(2,1,1)
plot([three_day_seq.tod_Rrs_443_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_Rrs_443_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; Rrs_443');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_Rrs_443_All-three_day_seq(idx).tod_Rrs_443_All_mean)/three_day_seq(idx).tod_Rrs_443_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_Rrs_443_All_H,three_day_seq(idx).tod_Rrs_443_All_P))
xlabel('x')
ylabel('F(x)')
end

%% Rrs_490
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; Rrs_490');
subplot(2,1,1)
plot([three_day_seq.tod_Rrs_490_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_Rrs_490_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; Rrs_490');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_Rrs_490_All-three_day_seq(idx).tod_Rrs_490_All_mean)/three_day_seq(idx).tod_Rrs_490_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_Rrs_490_All_H,three_day_seq(idx).tod_Rrs_490_All_P))
xlabel('x')
ylabel('F(x)')
end

%% Rrs_555
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; Rrs_555');
subplot(2,1,1)
plot([three_day_seq.tod_Rrs_555_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_Rrs_555_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; Rrs_555');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_Rrs_555_All-three_day_seq(idx).tod_Rrs_555_All_mean)/three_day_seq(idx).tod_Rrs_555_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_Rrs_555_All_H,three_day_seq(idx).tod_Rrs_555_All_P))
xlabel('x')
ylabel('F(x)')
end

%% Rrs_660
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; Rrs_660');
subplot(2,1,1)
plot([three_day_seq.tod_Rrs_660_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_Rrs_660_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; Rrs_660');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_Rrs_660_All-three_day_seq(idx).tod_Rrs_660_All_mean)/three_day_seq(idx).tod_Rrs_660_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_Rrs_660_All_H,three_day_seq(idx).tod_Rrs_660_All_P))
xlabel('x')
ylabel('F(x)')
end

%% Rrs_680
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; Rrs_680');
subplot(2,1,1)
plot([three_day_seq.tod_Rrs_680_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_Rrs_680_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; Rrs_680');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_Rrs_680_All-three_day_seq(idx).tod_Rrs_680_All_mean)/three_day_seq(idx).tod_Rrs_680_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_Rrs_680_All_H,three_day_seq(idx).tod_Rrs_680_All_P))
xlabel('x')
ylabel('F(x)')
end

%% chlor_a
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; chlor_a');
subplot(2,1,1)
plot([three_day_seq.tod_chlor_a_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_chlor_a_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; chlor_a');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_chlor_a_All-three_day_seq(idx).tod_chlor_a_All_mean)/three_day_seq(idx).tod_chlor_a_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_chlor_a_All_H,three_day_seq(idx).tod_chlor_a_All_P))
xlabel('x')
ylabel('F(x)')
end

%% poc
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; poc');
subplot(2,1,1)
plot([three_day_seq.tod_poc_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_poc_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; poc');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_poc_All-three_day_seq(idx).tod_poc_All_mean)/three_day_seq(idx).tod_poc_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_poc_All_H,three_day_seq(idx).tod_poc_All_P))
xlabel('x')
ylabel('F(x)')
end

%% ag_412_mlrc
h = figure('Color','white','DefaultAxesFontSize',fs,'Name','3-day seq; ag_412_mlrc');
subplot(2,1,1)
plot([three_day_seq.tod_ag_412_mlrc_All_H],'o-')
ylabel('h')

subplot(2,1,2)
plot([three_day_seq.tod_ag_412_mlrc_All_P],'o-')
ylabel('p')

xlabel('sequence number')
% Plotting CDFs
h = figure('Color','white','Name','3-day seq; ag_412_mlrc');
for idx = 1:size(three_day_seq,2)
x = (three_day_seq(idx).tod_ag_412_mlrc_All-three_day_seq(idx).tod_ag_412_mlrc_All_mean)/three_day_seq(idx).tod_ag_412_mlrc_All_stdv;
subplot(10,10,idx)
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')
title(sprintf('n=%i;h=%i;p=%1.4f',idx,three_day_seq(idx).tod_ag_412_mlrc_All_H,three_day_seq(idx).tod_ag_412_mlrc_All_P))
xlabel('x')
ylabel('F(x)')
end
%% Testing relative differences
cond_filter = abs(rel_diff_00) <= nanmean(rel_diff_00)+3*nanstd(rel_diff_00);
data=rel_diff_00(~isnan(rel_diff_00)&cond_filter);
x=(data-nanmean(data))/nanstd(data);
[H,P] = kstest(x,'Alpha',0.01)
[H,P] = lillietest(x,'Alpha',0.01)
figure
cdfplot(x)
hold on
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
%%
figure
x=log(x+100);
% x = x.^2;
x=(x-nanmean(x))/nanstd(x);
[H,P] = kstest(x)
%%
x_tran = log(x+100);
cdfplot(x_tran)
hold on
x_values = linspace(min(x_tran),max(x_tran));
plot(x_values,normcdf(x_values,0,1),'r-')

function [b,X,a,x1,y1,rsq_SS,rsq_corr] = regress_anly(x,y)
cond0 = ~isnan(y');
x0 = datenum(x(cond0)');
y0 = y(cond0)';
X = [ones(length(x0),1) x0];
b = X\y0;

regressiontype = 'OLS';

if strcmp(regressiontype,'OLS')
      [a,~] = polyfit(x0,y0,1);
elseif strcmp(regressiontype,'RMA')
      % %%%%%%%% RMA Regression %%%%%%%%%%%%%
      % [[b1 b0],bintr,bintjm] = gmregress(x0,y0);
      a(1) = std(y0)/std(x0); % slope
      
      if corr(x0,y0)<0
            a(1) = -abs(a(1));
      elseif corr(x0,y0)>=0
            a(1) = abs(a(1));
      end
      
      a(2) = nanmean(y0)-nanmean(x0)*a(1); % y intercept
      
end

x1=[x0(1) x0(end)];
y1=a(1).*x1+a(2);

SStot = sum((y0-nanmean(y0)).^2);
SSres = sum((y0-polyval(a,x0)).^2);
rsq_SS = 1-(SSres/SStot);
rsq_corr = corr(x0,y0)^2; % when OLS rsq_SS and rsq_corr are equal
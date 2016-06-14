function plot_insitu_vs_sat(wl_sat,wl_ins,MatchupReal)

%% filtered

eval(sprintf('Matchup_sat = [MatchupReal.Rrs_%s_filt_mean];',wl_sat)); % from satellite
eval(sprintf('Matchup_ins = [MatchupReal.Rrs_%s_insitu];',wl_ins)); % in situ

cond0 =  ~isnan(Matchup_sat); % valid values

t_diff = [MatchupReal(:).scenetime]-[MatchupReal(:).insitutime];
cond1 = abs(t_diff) <= days(1); % days(1) 
cond2 = abs(t_diff) <= hours(3); % hours(3)

cond3 = cond1 & cond0; % valid and less than 1 day
cond4 = cond2 & cond0; % valid and less than 3 hours

fs = 16;
h = figure('Color','white','DefaultAxesFontSize',fs);
plot(Matchup_ins(cond0),Matchup_sat(cond0),'ok')
hold on
plot(Matchup_ins(cond3),Matchup_sat(cond3),'sr')
plot(Matchup_ins(cond4),Matchup_sat(cond4),'*b')
ylabel(['Satellite Rrs\_' wl_sat '(sr^{-1})'],'FontSize',fs)
xlabel(['in situ Rrs\_' wl_ins '(sr^{-1})'],'FontSize',fs)
axis equal

eval(['Rrs_min = min(cell2mat({MatchupReal(cond0).Rrs_' wl_sat '_filt_mean}))*0.95;'])
eval(['Rrs_max = max(cell2mat({MatchupReal(cond0).Rrs_' wl_sat '_filt_mean}))*1.05;'])

xlim([Rrs_min Rrs_max])
ylim([Rrs_min Rrs_max])

hold on
plot([Rrs_min Rrs_max],[Rrs_min Rrs_max],'--k')
% plot([0 Rrs_max],[0.1*Rrs_max 1.1*Rrs_max],':k')
% plot([0 Rrs_max],[-0.1*Rrs_max 0.9*Rrs_max],':k')
grid on
legend(['3 d; N: ' num2str(sum(cond0)) ],['1 d; N: ' num2str(sum(cond3)) ],['3 h; N: ' num2str(sum(cond4)) ])
ax = gca;
ax.XTick =ax.YTick;
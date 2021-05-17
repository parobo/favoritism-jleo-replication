// ----------------------------------------------------------------------------------------- 
// Table A5: Creating Table A5 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off 

// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 
//tv income difference
gen affected_tvdiff = cond(affected==home, tv_rank_home-tv_rank_away, tv_rank_away-tv_rank_home)
label var affected_tvdiff "Difference in TV income ranking"

gen pos_diff_lseas = pos_affected_lseas-pos_unaffected_lseas
gen pos_diff_before = pos_affected_before - pos_unaffected_before
// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 

foreach indep of varlist att_ahead att_pos_diff m_ahead m_pos_diff{
	local pre = ""
	if "`indep'"=="att_pos_diff" local pre = ""
	if "`indep'"=="m_pos_diff" local pre = ""
	if "`indep'"=="att_ahead" local pre = "1."
	if "`indep'"=="m_ahead" local pre = "1."
	local pre2 = ""
	if "`indep'"=="att_pos_diff" local pre2 = ""
	if "`indep'"=="m_pos_diff" local pre2 = ""
	if "`indep'"=="att_ahead" local pre2 = "i."
	if "`indep'"=="m_ahead" local pre2 = "i."

	
	local controls "i.affected_home c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack"
	
	//1: No fixed effects
	reghdfe wc `pre2'`indep' `controls' if true_awarded==1, vce(cluster $cluster_var) a(goal)
	local `indep'_b1: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se1: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N1 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st1 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st1 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st1 = "\sym{***}"
	
	//2: fixed effects
	reghdfe wc `pre2'`indep' `controls' if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b2: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se2: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N2 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st2 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st2 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st2 = "\sym{***}"
	
	//3: fixed effects & lseas performance
	reghdfe wc `pre2'`indep' `controls' pos_diff_lseas if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b3: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se3: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N3 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st3 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st3 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st3 = "\sym{***}"
	
	//4: fixed effects & this seas performance
	reghdfe wc `pre2'`indep' `controls' pos_diff_before pts_diff if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b4: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se4: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N4 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st4 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st4 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st4 = "\sym{***}"
	
	//5: fixed effects & TV income
	reghdfe wc `pre2'`indep' `controls' affected_tvdiff if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b5: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se5: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N5 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st5 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st5 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st5 = "\sym{***}"

	//6: fixed effects & ELO
	reghdfe wc `pre2'`indep' `controls' elo_affected_pw  if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b6: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se6: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N6 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st6 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st6 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st6 = "\sym{***}"

	//7: fixed effects & TM value
	reghdfe wc `pre2'`indep' `controls' t_value_diff  if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b7: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se7: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N7 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st7 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st7 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st7 = "\sym{***}"
	
	//8: fixed effects & all other 
	reghdfe wc `pre2'`indep' `controls' pos_diff_lseas pos_diff_before pts_diff affected_tvdiff elo_affected_pw t_value_diff pw_invodds_corrected if true_awarded==1, vce(cluster $cluster_var) a(goal refid gameday season affected)
	local `indep'_b8: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se8: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N8 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st8 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st8 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st8 = "\sym{***}"
	}



// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
texdoc init tables/table_a5.tex, replace
tex \begin{table}[H]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Different performance measures}
tex \begin{adjustbox}{max width=\linewidth}
tex	\begin{tabular}{l c c c c c c c c}
tex		\hline\hline
tex		& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)\\\hline

foreach indep of varlist att_ahead att_pos_diff m_ahead m_pos_diff{
	local lb: var label `indep'
	local past = ""
	if "`indep'"=="att_pos_diff" local past = ""
	if "`indep'"=="m_pos_diff" local past = ""
	if "`indep'"=="att_ahead" local past = " (d)"
	if "`indep'"=="m_ahead" local past = " (d)"
	
	tex		`lb'`past'& ``indep'_b1'``indep'_st1' & ``indep'_b2'``indep'_st2' &``indep'_b3'``indep'_st3'&``indep'_b4'``indep'_st4'&``indep'_b5'``indep'_st5'&``indep'_b6'``indep'_st6'&``indep'_b7'``indep'_st7'&``indep'_b8'``indep'_st8'\\
	tex			 & (``indep'_se1')& (``indep'_se2')& (``indep'_se3')& (``indep'_se4')& (``indep'_se5')& (``indep'_se6')& (``indep'_se7')& (``indep'_se8')\\\hline
	tex	 	 N	 & ``indep'_N1'& ``indep'_N2'& ``indep'_N3'& ``indep'_N4'& ``indep'_N5'& ``indep'_N6'& ``indep'_N7'& ``indep'_N8'\\\hline\hline\\
	}

tex Control variables & Yes & Yes & Yes & Yes  & Yes  & Yes  & Yes & Yes\\
tex	Season fixed effects & No & Yes & Yes & Yes  & Yes  & Yes  & Yes &Yes \\
tex	Team fixed effects & No & Yes & Yes & Yes  & Yes  & Yes  & Yes &Yes \\
tex	Gameday fixed effects & No & Yes & Yes & Yes  & Yes  & Yes  & Yes &Yes\\
tex	Referee fixed effects & No & Yes & Yes & Yes  & Yes  & Yes  & Yes &Yes\\
tex	Performance controls: Last season & No & No & Yes & No  & No  & No  & No & Yes \\
tex	Performance controls: Current season & No & No & No & Yes & No & No & No & Yes \\
tex	Performance controls: TV income & No & No & No & No  & Yes  & No  & No &Yes\\
tex	Performance controls: Win probability (ELO based) & No & No & No & No &No & Yes  & No & Yes \\
tex	Performance controls: Transfervalue difference & No & No & No & No &No  & No & Yes & Yes \\
tex	Performance controls: Win probability (odds based) & No & No & No & No &No  & No & No  & Yes \\\hline\hline
tex \multicolumn{9}{p{1.2\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. Control variables include a dummy for the home team, previous wrong decisions (separated by unfavorable and favorable ones for the affected and unaffected team), type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game and stadiums with running tracks. Furthermore they include referee experience and average performance in the season, decisiveness of the call, and the number of spectators. Performance indicators for the last season is the difference in position between teams at the end of the last season. Performance in the current season is measured by the difference in points as well as position in the table before the game. Performance indicators using the difference in ranks according to TV income are based on the actual distribution of TV income that is split between all teams in the first and second Bundesliga and are calculated using the weighted performance in the last 4 seasons. Performance controls using ELO numbers are based on the win probability calculated using ELO numbers collected from clubelo.com and controls for transfervalue are based on the difference in transfervalue in starting formation based on values collected from tranfermarkt.de. Transfervalues are only available between 2005 and 2013, thus explaining the smaller sample. Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}
tex \end{adjustbox}
tex \end{table}
texdoc close

restore

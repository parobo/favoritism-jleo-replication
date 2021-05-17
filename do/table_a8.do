// ----------------------------------------------------------------------------------------- 
// Table A8: Creating Table A8 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

gen halfseason = (gameday>17)
gen l5g = (gameday>29)

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
	
	local controls "i.affected_home r_avg_performance_excl pw_invodds_corrected i.r_prev*favcall* i.goal i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack"

	//1: Tenure as experience
	reghdfe wc `pre2'`indep' `controls' c.r_bltenure i.g_last10min if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b1: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se1: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N1 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st1 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st1 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st1 = "\sym{***}"
	
	//2: Minute and halftime instead of last 10 minutes
	reghdfe wc `pre2'`indep' `controls' c.r_experience c.minute if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b2: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se2: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N2 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st2 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st2 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st2 = "\sym{***}"
	
	//3: half season dummy instead of linear time trend
	reghdfe wc `pre2'`indep' `controls' c.r_experience i.g_last10min i.halfseason if true_awarded==1, vce(cluster $cluster_var) a(refid season affected)
	local `indep'_b3: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se3: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N3 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st3 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st3 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st3 = "\sym{***}"
	
	//4: last 5 game dummy instead of time trend
	reghdfe wc `pre2'`indep' `controls' c.r_experience i.g_last10min i.l5g if true_awarded==1, vce(cluster $cluster_var) a(refid season affected)
	local `indep'_b4: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se4: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N4 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st4 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st4 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st4 = "\sym{***}"
	
	//5: All
	reghdfe wc `pre2'`indep' `controls' c.r_bltenure  i.halfseason i.l5g c.minute if true_awarded==1, vce(cluster $cluster_var) a(refid season affected)
	local `indep'_b5: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se5: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N5 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st5 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st5 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st5 = "\sym{***}"
	}



// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
texdoc init tables/table_a8.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Different specification of control variables}
tex	\begin{tabular}{l c c c c c}
tex		\hline\hline
tex		& (1) & (2) & (3) & (4) & (5) \\\hline

foreach indep of varlist att_ahead att_pos_diff m_ahead m_pos_diff{
	local lb: var label `indep'
	local past = ""
	if "`indep'"=="att_pos_diff" local past = ""
	if "`indep'"=="m_pos_diff" local past = ""
	if "`indep'"=="att_ahead" local past = " (d)"
	if "`indep'"=="m_ahead" local past = " (d)"
	
	tex		`lb'`past' & ``indep'_b1'``indep'_st1' & ``indep'_b2'``indep'_st2' &``indep'_b3'``indep'_st3'&``indep'_b4'``indep'_st4'&``indep'_b5'``indep'_st5'\\
	tex			 & (``indep'_se1')& (``indep'_se2')& (``indep'_se3')& (``indep'_se4')& (``indep'_se5')\\\hline
	tex	 	 N	 & ``indep'_N1'& ``indep'_N2'& ``indep'_N3'& ``indep'_N4'& ``indep'_N5'\\\hline\hline\\
	}

tex Other control variables & Yes & Yes & Yes & Yes  & Yes \\
tex	Referee fixed effects & Yes & Yes & Yes & Yes  & Yes \\
tex	Season fixed effects & Yes & Yes & Yes  & Yes  & Yes \\
tex	Gameday fixed effects & Yes & Yes & No & No & No\\
tex	Tenure & Yes & No  & No  & No  & Yes \\
tex	Gametime (minute) & No & Yes & No & No & Yes \\
tex	Half-season dummies & No & No & Yes & Yes  & Yes\\
tex	Last 5 games & No & No & No & Yes & Yes \\\hline
tex \multicolumn{6}{p{0.95\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. Control variables include a dummy for the home team, previous wrong decisions (separated by unfavorable and favorable ones for the affected and unaffected team), type of the situation (goal or penalty), the last 10 minutes of the game (except when other gametime indicators are included), closeness of the game and stadiums with running tracks. Furthermore they include referee experience (except when tenure details are included) and average performance in the season, decisiveness of the call, and the number of spectators. Tenure refers to years as a Bundesliga referee. Gametime is measured in minutes. Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

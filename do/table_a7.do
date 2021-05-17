// ----------------------------------------------------------------------------------------- 
// Table A7: Creating Table A7 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 

//gamestats are only available for 2000-2008
local game_stats = "g_affected_shots g_unaffected_shots g_affected_fouls g_unaffected_fouls g_affected_ballcontacts g_unaffected_ballcontacts g_affected_possession"

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
	
	local controls "pw_invodds_corrected i.affected_home c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack"
	
	//1: Just formation controls
	reghdfe wc `pre2'`indep' `controls' i.t_formation_affected i.t_formation_unaffected if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b1: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se1: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N1 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st1 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st1 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st1 = "\sym{***}"
	
	//2: Offensive score
	reghdfe wc `pre2'`indep' `controls' t_offscore_diff if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b2: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se2: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N2 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st2 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st2 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st2 = "\sym{***}"
	
	//3: Offensive number of players
	reghdfe wc `pre2'`indep' `controls' t_off_diff if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b3: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se3: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N3 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st3 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st3 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st3 = "\sym{***}"
	
	//4: tactics
	reghdfe wc `pre2'`indep' `controls' `game_stats' if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b4: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se4: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N4 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st4 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st4 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st4 = "\sym{***}"

	//5: all without tactics
	reghdfe wc `pre2'`indep' `controls' i.t_formation_affected i.t_formation_unaffected t_offscore_diff t_off_diff if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b5: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se5: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N5 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st5 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st5 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st5 = "\sym{***}"

	//6: all without tactics
	reghdfe wc `pre2'`indep' `controls' i.t_formation_affected i.t_formation_unaffected t_offscore_diff t_off_diff `game_stats' if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b6: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se6: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N6 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st6 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st6 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st6 = "\sym{***}"
	}



// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 

texdoc init tables/table_a7.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Tactic control variables}
tex	\begin{tabular}{l c c c c c c c c}
tex		\hline\hline
tex		& (1) & (2) & (3) & (4) & (5) & (6)\\\hline

foreach indep of varlist att_ahead att_pos_diff m_ahead m_pos_diff{
	local lb: var label `indep'
	local past = ""
	if "`indep'"=="att_pos_diff" local past = ""
	if "`indep'"=="m_pos_diff" local past = ""
	if "`indep'"=="att_ahead" local past = " (d)"
	if "`indep'"=="m_ahead" local past = " (d)"
	
	tex		`lb'`past'& ``indep'_b1'``indep'_st1' & ``indep'_b2'``indep'_st2' &``indep'_b3'``indep'_st3'&``indep'_b4'``indep'_st4'&``indep'_b5'``indep'_st5'&``indep'_b6'``indep'_st6'\\
	tex			 & (``indep'_se1')& (``indep'_se2')& (``indep'_se3')& (``indep'_se4')& (``indep'_se5')& (``indep'_se6')\\\hline
	tex	 	 N	 & ``indep'_N1'& ``indep'_N2'& ``indep'_N3'& ``indep'_N4'& ``indep'_N5'& ``indep'_N6'\\\hline\hline\\
	}

	tex Control variables & Yes & Yes & Yes & Yes  & Yes  & Yes\\
tex	Season fixed effects & Yes & Yes & Yes  & Yes  & Yes  & Yes \\
tex	Gameday fixed effects & Yes & Yes & Yes  & Yes  & Yes  & Yes\\
tex	Referee fixed effects & Yes & Yes & Yes  & Yes  & Yes  & Yes \\
tex	Team fixed effects & Yes & Yes & Yes  & Yes  & Yes  & Yes\\
tex	Tactic controls: Start formation & Yes & No  & No & No & Yes & Yes \\
tex	Tactic controls: Offensive score & No & Yes & No & No & Yes & Yes \\
tex	Tactic controls: \# attacking players & No & No & Yes  & No  & Yes &Yes\\
tex	Tactic controls: Game statistics & No & No &No & Yes  & No & Yes \\\hline\hline
tex \multicolumn{7}{p{0.95\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy for wrong calls among denied penalties and goals. Debatable decisions are excluded. Control variables include a dummy for the home team, win probability based on betting odds, previous wrong decisions (separated by unfavorable and favorable ones for the affected and unaffected team), type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game and stadiums with running tracks. Furthermore they include referee experience and average performance in the season, decisiveness of the call, and the number of spectators. Tactic indicators for the formation are 14 dummy variables classifying the tactical starting formation for the affected and opposition team. Offensive score measures the difference in the overall offensive positioning in the start formation between the affected and opposing team. Tactic controls using the number of attacking players measure the difference in the number of attacking player in the start formation between the affected and opposition team. Game statistics include the number of shots on target, fouls and balls contacts by both the affected and unaffected team, as well as the ball possession by the affected team. These variables are only available between 2000 and 2007, thus explaining the smaller sample. Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

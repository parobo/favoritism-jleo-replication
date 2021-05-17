// ----------------------------------------------------------------------------------------- 
// Table A15: Creating Table A15 from the paper 
// ----------------------------------------------------------------------------------------- 
preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 
gen pl_value_affected = cond(pl_team==affected,1,-1)*pl_value
gen pl_age_affected = cond(pl_team==affected,1,-1)*pl_age
gen pl_nation1_affected = cond(pl_team==affected,1,-1)*(pl_nation1=="Deutschland" | pl_nation2=="Deutschland" ) if !missing(pl_nation1) | !missing(pl_nation2)

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 

foreach indep of varlist att_ahead m_ahead att_pos_diff m_pos_diff{
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
	
	local controls "pw_invodds_corrected i.affected_home c.r_experience r_avg_performance_excl i.r_prev*favcall* i.goal i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack"
	
	//1: Player value
	reghdfe wc `pre2'`indep' `controls' pl_value_affected if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b1: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se1: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N1 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st1 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st1 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st1 = "\sym{***}"
	
	//2: Age
	reghdfe wc `pre2'`indep' `controls' pl_age_affected if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b2: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se2: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N2 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st2 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st2 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st2 = "\sym{***}"
	
	//3: World Cup Player
	reghdfe wc `pre2'`indep' `controls' pl_wc_affected if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b3: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se3: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N3 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st3 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st3 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st3 = "\sym{***}"
	
	//4: nationality
	reghdfe wc `pre2'`indep' `controls' pl_nation1_affected if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
	local `indep'_b4: di %6.4f `= round(_b[`pre'`indep'],0.0001)'
	local `indep'_se4: di %6.4f `= round(_se[`pre'`indep'], 0.0001)'
	local `indep'_N4 = e(N)
	quietly test `pre'`indep'
	if r(p)<=0.1 local `indep'_st4 = "\sym{*}"
	if r(p)<=0.05 local `indep'_st4 = "\sym{**}"
	if r(p)<=0.01 local `indep'_st4 = "\sym{***}"

	//6: all
	reghdfe wc `pre2'`indep' `controls' pl_value_affected pl_age_affected pl_wc_affected pl_nation1_affected if true_awarded==1, vce(cluster $cluster_var) a(refid gameday season affected)
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
texdoc init tables/table_a15.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Controls for player status}
tex	\begin{tabular}{l c c c c c c c}
tex		\hline\hline
tex		& (1) & (2) & (3) & (4) & (5)\\\hline

foreach indep of varlist att_ahead m_ahead att_pos_diff m_pos_diff{
	local lb: var label `indep'
	local past = ""
	if "`indep'"=="att_pos_diff" local past = ""
	if "`indep'"=="m_pos_diff" local past = ""
	if "`indep'"=="att_ahead" local past = " (d)"
	if "`indep'"=="m_ahead" local past = " (d)"
	
	tex		`lb'`past'& ``indep'_b1'``indep'_st1' & ``indep'_b2'``indep'_st2' &``indep'_b3'``indep'_st3'&``indep'_b4'``indep'_st4'&``indep'_b6'``indep'_st6'\\
	tex			 & (``indep'_se1')& (``indep'_se2')& (``indep'_se3')& (``indep'_se4') & (``indep'_se6')\\\hline
	tex	 	 N	 & ``indep'_N1'& ``indep'_N2'& ``indep'_N3'& ``indep'_N4' & ``indep'_N6'\\\hline\hline\\
	}

	tex Control variables & Yes & Yes & Yes & Yes  & Yes \\
tex	Season fixed effects & Yes & Yes & Yes  & Yes  & Yes  \\
tex	Gameday fixed effects & Yes & Yes & Yes  & Yes  & Yes\\
tex	Referee fixed effects & Yes & Yes & Yes  & Yes  & Yes\\
tex	Team fixed effects & Yes & Yes & Yes  & Yes  & Yes\\
tex	Player status: Player transfervalue & Yes & No  & No & No & Yes \\
tex	Player status: Player age & No & Yes & No & No & Yes\\
tex	Player status: World cup participant & No & No & Yes  & No  & Yes\\
tex	Player status: Nationality same as Ref. & No & No &No & Yes  & Yes \\\hline\hline
tex \multicolumn{6}{p{0.95\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. Control variables include a dummy for the home team, win probability based on betting odds, previous wrong decisions (separated by unfavorable and favorable ones for the affected and unaffected team), type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game and stadiums with running tracks. Furthermore they include referee experience and average performance in the season, decisiveness of the call, and the number of spectators. Player status control using player transfervalue is based on tranfervalue collected from transfermarkt.de. Age is the age of the player at the beginning of the season. World cup participation indicates whether the player has been nominated to a national team that participated in the FIFA worldcup. Finally nationality controls for players who are of the same nationality as the referee. Tranfervalue, age and nationality data is only available between 2005 and 2013, thus explaining the smaller sample.  Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

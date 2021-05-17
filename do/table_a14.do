// ----------------------------------------------------------------------------------------- 
// Table A14: Creating Table A14 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 
gen m_dist_ahead = cond(affected==home, d_home_ref, d_away_ref)
encode affected, gen(aff_code)

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 
fvset base 11 refid
foreach t in "att" "m"{

//for ahead
reghdfe wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & `t'_dist_ahead<=350, vce(cluster $cluster_var) a(season gameday refid  affected)
local `t'_ahead_d1_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_d1_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_d1_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_d1_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_d1_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_d1_st = "\sym{***}"
				
reghdfe wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & `t'_dist_ahead>350, vce(cluster $cluster_var) a(season gameday refid  affected)
local `t'_ahead_d2_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_d2_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_d2_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_d2_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_d2_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_d2_st = "\sym{***}"

//for diff
reghdfe wc i.affected_home `t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & `t'_dist_ahead<=350, vce(cluster $cluster_var) a(season gameday refid  affected)
local `t'_pos_diff_d1_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_d1_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_d1_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_d1_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_d1_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_d1_st = "\sym{***}"
				
reghdfe wc i.affected_home `t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & `t'_dist_ahead>350, vce(cluster $cluster_var) a(season gameday refid  affected)
local `t'_pos_diff_d2_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_d2_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_d2_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_d2_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_d2_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_d2_st = "\sym{***}"
}

//run tests of difference in coefficients between the specifications
foreach t in "att" "m"{
//for ahead
reg wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	i.season i.gameday i.refid  i.aff_code ///
	if true_awarded==1 & `t'_dist_ahead<=350
est store `t'_ahead_l350
reg wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	i.season i.gameday i.refid  i.aff_code ///
	if true_awarded==1 & `t'_dist_ahead>350
est store `t'_ahead_m350
//for diff
reg wc i.affected_home `t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	i.season i.gameday i.refid  i.aff_code ///
	if true_awarded==1 & `t'_dist_ahead<=350
est store `t'_diff_l350

reg wc i.affected_home `t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	i.season i.gameday i.refid  i.aff_code ///
	if true_awarded==1 & `t'_dist_ahead>350
est store `t'_diff_m350

suest `t'_ahead_l350 `t'_ahead_m350, cluster($cluster_var)
test [`t'_ahead_l350_mean]1.`t'_ahead = [`t'_ahead_m350_mean]1.`t'_ahead 
local `t'_ahead_lm_diff: di %6.4f `= round(r(p),0.0001)'

suest `t'_diff_l350 `t'_diff_m350, cluster($cluster_var)
test [`t'_diff_l350_mean]`t'_pos_diff = [`t'_diff_m350_mean]`t'_pos_diff 
local `t'_pos_diff_lm_diff: di %6.4f `= round(r(p),0.0001)'
}

// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
texdoc init tables/table_a14.tex, replace
tex \begin{table}[h]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Referee's distance from high status team}
tex	\begin{tabular}{l c c c}
tex		\hline\hline
tex		& (1) & (2) & (3)\\
tex		& $ d \leq 350$ &$ d>350$ & p-value: $ \beta_1 = \beta_2$ \\\hline

foreach indep of varlist  att_ahead att_pos_diff m_ahead m_pos_diff{
	local lb: var label `indep'
	local past = ""
	if "`indep'"=="att_pos_diff" local past = ""
	if "`indep'"=="m_pos_diff" local past = ""
	if "`indep'"=="att_ahead" local past = " (d)"
	if "`indep'"=="m_ahead" local past = " (d)"
	
	tex		`lb'`past' & ``indep'_d1_b'``indep'_d1_st' & ``indep'_d2_b'``indep'_d2_st' &(``indep'_lm_diff') \\
	tex			 & (``indep'_d1_se')& (``indep'_d2_se') & \\\hline
	tex	 	 N	 & ``indep'_d1_N'& ``indep'_d2_N' & \\\hline\hline\\
	}

tex \multicolumn{4}{p{0.5\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. In each column the sample of games is restricted to games in which the shortest distance of the referee's birthplace to the top team's home town is in the indicated interval. The regressions include controls for the home team, inverse of odds, referee experience and average performance in the season, type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game, decisiveness of the call, the number of spectators, and stadiums with running tracks. Furthermore season, gameday, referee and team fixed effects are included. Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

// ----------------------------------------------------------------------------------------- 
// Table A9: Creating Table A9 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 
encode affected, gen(affected_team)
// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 

foreach t in "att" "m"{
//OLS
//for ahead
reghdfe wc i.affected_home i.`t'_ahead i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_ahead_1_reghdfe_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_1_reghdfe_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_1_reghdfe_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_1_reghdfe_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_1_reghdfe_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_1_reghdfe_st = "\sym{***}"

//for pos diff
reghdfe wc i.affected_home `t'_pos_diff i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_pos_diff_1_reghdfe_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_1_reghdfe_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_1_reghdfe_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_1_reghdfe_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_1_reghdfe_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_1_reghdfe_st = "\sym{***}"

//Logit
//for ahead
logit wc i.affected_home i.`t'_ahead i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack i.season i.gameday i.refid  i.affected_team if true_awarded==1, vce(cluster $cluster_var)

margins, dydx(`t'_ahead) post vce(unconditional)
local `t'_ahead_1_logit_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_1_logit_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_1_logit_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_1_logit_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_1_logit_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_1_logit_st = "\sym{***}"

//for pos diff
logit wc i.affected_home `t'_pos_diff i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack i.season i.gameday i.refid  i.affected_team if true_awarded==1, vce(cluster $cluster_var)

margins, dydx(`t'_pos_diff) post vce(unconditional)
local `t'_pos_diff_1_logit_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_1_logit_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_1_logit_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_1_logit_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_1_logit_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_1_logit_st = "\sym{***}"

//for ahead
poisson wc i.affected_home i.`t'_ahead i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack i.season i.gameday i.refid  i.affected_team if true_awarded==1, vce(cluster $cluster_var)

margins, dydx(`t'_ahead) post vce(unconditional)
local `t'_ahead_1_poisson_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_1_poisson_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_1_poisson_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_1_poisson_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_1_poisson_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_1_poisson_st = "\sym{***}"

//for pos diff
poisson wc i.affected_home `t'_pos_diff i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack i.season i.gameday i.refid  i.affected_team if true_awarded==1, vce(cluster $cluster_var)

margins, dydx(`t'_pos_diff) post vce(unconditional)
local `t'_pos_diff_1_poisson_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_1_poisson_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_1_poisson_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_1_poisson_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_1_poisson_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_1_poisson_st = "\sym{***}"

//for ahead
firthlogit wc i.affected_home i.`t'_ahead i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack i.season i.gameday i.refid  i.affected_team if true_awarded==1
margins, dydx(`t'_ahead) post expression(invlogit(predict(xb)))
local `t'_ahead_1_flogit_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_1_flogit_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_1_flogit_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_1_flogit_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_1_flogit_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_1_flogit_st = "\sym{***}"

//for pos diff
firthlogit wc i.affected_home `t'_pos_diff i.goal pw_invodds_corrected  c.r_experience r_avg_performance_excl i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack i.season i.gameday i.refid  i.affected_team if true_awarded==1

margins, dydx(`t'_pos_diff) post  expression(invlogit(predict(xb)))
local `t'_pos_diff_1_flogit_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_1_flogit_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_1_flogit_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_1_flogit_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_1_flogit_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_1_flogit_st = "\sym{***}"

}
// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 

texdoc init tables/table_a9.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Alternative methods}
tex	\begin{tabular}{l c c c c}
tex		\hline\hline
tex		& (1) & (2) & (3) & (4)\\
tex		& OLS & Logit & Pen. logit & Poisson \\\hline

foreach indep of varlist att_ahead att_pos_diff m_ahead m_pos_diff{
	local lb: var label `indep'
	tex		`lb' (d) & ``indep'_1_reghdfe_b'``indep'_1_reghdfe_st' & ``indep'_1_logit_b'``indep'_1_logit_st' & ``indep'_1_flogit_b'``indep'_1_flogit_st' &``indep'_1_poisson_b'``indep'_1_poisson_st' \\
	tex			 & (``indep'_1_reghdfe_se') & (``indep'_1_logit_se')& (``indep'_1_flogit_se')& (``indep'_1_poisson_se')\\\hline
	tex	 	 N	 & ``indep'_1_reghdfe_N' & ``indep'_1_logit_N'& ``indep'_1_flogit_N'& ``indep'_1_poisson_N' \\\hline\hline
	}

tex \multicolumn{5}{p{\linewidth}}{\footnotesize{\emph{Notes:} Estimates as indicated by column. Average marginal effects; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy variable that takes value 1 for wrong calls among penalties and goals that should be awarded. Debatable decisions are excluded. The regressions include controls for the home team, win probability (odds based), referee experience and average performance in the season excluding the current game, the last 10 minutes of the game, closeness of the game, decisiveness of the call, the number of spectators, accuracy of previous decisions, and stadiums with running tracks. Furthermore season, gameday, referee and team fixed effects are included. Standard errors in parentheses are clustered at the game level except for the firthlogit regression, which does not allow for clustering. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

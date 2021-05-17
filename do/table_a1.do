// ----------------------------------------------------------------------------------------- 
// Table A1: Creating Table A1 from the paper 
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
foreach t in "att" "m"{

//for ahead
reghdfe wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==0, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_ahead_d1_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_d1_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_d1_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_d1_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_d1_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_d1_st = "\sym{***}"

reghdfe wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==1, vce(cluster $cluster_var) a(season gameday refid affected)
	
local `t'_ahead_d2_b: di %6.4f `= round(_b[1.`t'_ahead],0.0001)'
local `t'_ahead_d2_se: di %6.4f `= round(_se[1.`t'_ahead], 0.0001)'
local `t'_ahead_d2_N = e(N)
quietly test 1.`t'_ahead
if r(p)<0.1 local `t'_ahead_d2_st = "\sym{*}"
if r(p)<0.05 local `t'_ahead_d2_st = "\sym{**}"
if r(p)<0.01 local `t'_ahead_d2_st = "\sym{***}"

//for diff
reghdfe wc i.affected_home c.`t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==0, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_pos_diff_d1_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_d1_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_d1_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_d1_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_d1_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_d1_st = "\sym{***}"
				
reghdfe wc i.affected_home c.`t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==1, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_pos_diff_d2_b: di %6.4f `= round(_b[`t'_pos_diff],0.0001)'
local `t'_pos_diff_d2_se: di %6.4f `= round(_se[`t'_pos_diff], 0.0001)'
local `t'_pos_diff_d2_N = e(N)
quietly test `t'_pos_diff
if r(p)<0.1 local `t'_pos_diff_d2_st = "\sym{*}"
if r(p)<0.05 local `t'_pos_diff_d2_st = "\sym{**}"
if r(p)<0.01 local `t'_pos_diff_d2_st = "\sym{***}"


//for ahead
reghdfe wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==0, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_ahome_d1_b: di %6.4f `= round(_b[1.affected_home],0.0001)'
local `t'_ahome_d1_se: di %6.4f `= round(_se[1.affected_home], 0.0001)'
local `t'_ahome_d1_N = e(N)
quietly test 1.affected_home
if r(p)<0.1 local `t'_ahome_d1_st = "\sym{*}"
if r(p)<0.05 local `t'_ahome_d1_st = "\sym{**}"
if r(p)<0.01 local `t'_ahome_d1_st = "\sym{***}"

reghdfe wc i.affected_home i.`t'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==1, vce(cluster $cluster_var) a(season gameday refid affected)
	
local `t'_ahome_d2_b: di %6.4f `= round(_b[1.affected_home],0.0001)'
local `t'_ahome_d2_se: di %6.4f `= round(_se[1.affected_home], 0.0001)'
local `t'_ahome_d2_N = e(N)
quietly test 1.affected_home
if r(p)<0.1 local `t'_ahome_d2_st = "\sym{*}"
if r(p)<0.05 local `t'_ahome_d2_st = "\sym{**}"
if r(p)<0.01 local `t'_ahome_d2_st = "\sym{***}"

//for diff
reghdfe wc i.affected_home c.`t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==0, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_dhome_d1_b: di %6.4f `= round(_b[1.affected_home],0.0001)'
local `t'_dhome_d1_se: di %6.4f `= round(_se[1.affected_home], 0.0001)'
local `t'_dhome_d1_N = e(N)
quietly test 1.affected_home
if r(p)<0.1 local `t'_dhome_d1_st = "\sym{*}"
if r(p)<0.05 local `t'_dhome_d1_st = "\sym{**}"
if r(p)<0.01 local `t'_dhome_d1_st = "\sym{***}"
				
reghdfe wc i.affected_home c.`t'_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl  ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack ///
	if true_awarded==1 & goal==1, vce(cluster $cluster_var) a(season gameday refid affected)

local `t'_dhome_d2_b: di %6.4f `= round(_b[1.affected_home],0.0001)'
local `t'_dhome_d2_se: di %6.4f `= round(_se[1.affected_home], 0.0001)'
local `t'_dhome_d2_N = e(N)
quietly test 1.affected_home
if r(p)<0.1 local `t'_dhome_d2_st = "\sym{*}"
if r(p)<0.05 local `t'_dhome_d2_st = "\sym{**}"
if r(p)<0.01 local `t'_dhome_d2_st = "\sym{***}"
}


// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
texdoc init tables/table_a1.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Separate for goals and penalties}
tex	\begin{tabular}{l c c}
tex		\hline\hline
tex		& (1) & (2) \\
tex		& Penalties & Goals \\\hline

foreach indep of varlist att_ahead att_pos_diff m_ahead m_pos_diff{
	local lb: var label `indep'
	local past = ""
	if "`indep'"=="att_pos_diff" local past = ""
	if "`indep'"=="m_pos_diff" local past = ""
	if "`indep'"=="att_ahead" local past = " (d)"
	if "`indep'"=="m_ahead" local past = " (d)"
	local home = ""
	if "`indep'"=="att_pos_diff" local home = "att_dhome"
	if "`indep'"=="m_pos_diff" local home = "m_dhome"
	if "`indep'"=="att_ahead" local home = "att_ahome"
	if "`indep'"=="m_ahead" local home = "m_ahome"
	
	tex		`lb'`past' & ``indep'_d1_b'``indep'_d1_st' & ``indep'_d2_b'``indep'_d2_st'\\
	tex			 & (``indep'_d1_se')& (``indep'_d2_se')\\
	tex		Home (d) & ``home'_d1_b'``home'_d1_st' & ``home'_d2_b'``home'_d2_st'\\
	tex			 & (``home'_d1_se')& (``home'_d2_se')\\\hline
	tex	 	 N	 & ``home'_d1_N'& ``home'_d2_N'\\\hline\hline\\
	}

tex \multicolumn{3}{p{0.8\linewidth}}{\footnotesize{\emph{Notes:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy variable that takes value 1 for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. In the first column the sample is restricted to include only decision about penalties. The second column contains only decisions on goals. The regressions include controls for the home team, inverse of odds, referee experience and average performance in the season, the last 10 minutes of the game, closeness of the game, decisiveness of the call, the number of spectators, and stadiums with running tracks. Furthermore season, gameday, referee and team fixed effects are included. Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

// ----------------------------------------------------------------------------------------- 
// Table A4: Creating Table A4 from the paper 
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

foreach k in "att" "m"{
foreach s of numlist 0(5)10{
reghdfe wc i.affected_home i.`k'_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal ///
	i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall ///
	spec_num_scaled i.spec_runningtrack if true_awarded==1 & abs(`k'_pos_diff)>=`s', vce(cluster $cluster_var) a(season gameday refid  affected)
local `k'_`s'_b : di %6.4f `= round(_b[1.`k'_ahead],0.0001)'
local `k'_`s'_se : di %6.4f `= round(_se[1.`k'_ahead], 0.0001)'
local `k'_`s'_N = e(N)
if sign(_b[1.`k'_ahead])!=sign(``k'_`s'_b') local `k'_`s'_b = -``k'_`s'_b'
quietly test 1.`k'_ahead
if r(p)<=0.1 local `k'_`s'_st = "\sym{*}"
if r(p)<=0.05 local `k'_`s'_st = "\sym{**}"
if r(p)<=0.01 local `k'_`s'_st = "\sym{***}"
}
}
// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 

texdoc init tables/table_a4.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Different levels of status difference}
tex	\begin{tabular}{l c c c}
tex		\hline\hline
tex		& (1) & (2) & (3)\\
tex		& $ d \geq 0$ & $ d \geq 5$ & $ d \geq 10$ \\\hline
tex		Ahead in ATT (d) &`att_0_b'`att_0_st' & `att_5_b'`att_5_st' &  `att_10_b'`att_10_st' \\
tex		 & (`att_0_se') &(`att_5_se') & (`att_10_se') \\
tex		N& `att_0_N' &`att_5_N' &`att_10_N' \\\hline\\
tex		Ahead in members (d) &`m_0_b'`m_0_st' & `m_5_b'`m_5_st'& `m_10_b'`m_10_st' \\
tex		 & (`m_0_se') & (`m_5_se')& (`m_10_se')\\
tex		N& `m_0_N' & `m_5_N'& `m_10_N'\\\hline\hline
tex \multicolumn{4}{p{0.7\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy variable that takes value 1 for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. The sample is restricted to include only games where the difference in the position in ATT (members) of the clubs in the respective season was at least 0, 5 or 10 as indicated by the respective column. The regressions include controls for the home team, the inverse of odds, referee experience and average performance in the season, type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game, decisiveness of the call, the number of spectators, and stadiums with running tracks. Furthermore season, gameday, referee and team fixed effects are included. Standard errors in parentheses are clustered at the team level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

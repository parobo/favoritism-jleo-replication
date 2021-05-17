// ----------------------------------------------------------------------------------------- 
// Table A12: Creating Table A12 from the paper 
// ----------------------------------------------------------------------------------------- 
preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 
gen close_limit = (r_age>=44) if !missing(r_age)
label var r_agelimit "1 year to age limit"
label var close_limit "3 years to age limit"
// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 
local controls = "i.affected_home pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack"

// ----------------------------------- ATT AHEAD ----------------------------------------------
//agelimit
reghdfe wc i.att_ahead##i.r_agelimit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "1.att_ahead 1.r_agelimit 1.att_ahead#1.r_agelimit"

forval j=1/3{
local h_att_ahead_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local h_att_ahead_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local h_att_ahead_st`j' = "\sym{*}"
if r(p)<0.05 local h_att_ahead_st`j'= "\sym{**}"
if r(p)<0.01 local h_att_ahead_st`j' = "\sym{***}"
}
local h_att_ahead_N = e(N)

//close to agelimit
reghdfe wc i.att_ahead##i.close_limit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "1.att_ahead 1.close_limit 1.att_ahead#1.close_limit"

forval j=1/3{
local p_att_ahead_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local p_att_ahead_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local p_att_ahead_st`j' = "\sym{*}"
if r(p)<0.05 local p_att_ahead_st`j'= "\sym{**}"
if r(p)<0.01 local p_att_ahead_st`j' = "\sym{***}"
}
local p_att_ahead_N = e(N)


// ----------------------------------- ATT DIFF ----------------------------------------------
//agelimit
reghdfe wc c.att_pos_diff##i.r_agelimit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "att_pos_diff 1.r_agelimit att_pos_diff#1.r_agelimit"

forval j=1/3{
local h_att_diff_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local h_att_diff_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local h_att_diff_st`j' = "\sym{*}"
if r(p)<0.05 local h_att_diff_st`j'= "\sym{**}"
if r(p)<0.01 local h_att_diff_st`j' = "\sym{***}"
}
local h_att_diff_N = e(N)

//close to agelimit
reghdfe wc c.att_pos_diff##i.close_limit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "att_pos_diff 1.close_limit att_pos_diff#1.close_limit"

forval j=1/3{
local p_att_diff_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local p_att_diff_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local p_att_diff_st`j' = "\sym{*}"
if r(p)<0.05 local p_att_diff_st`j'= "\sym{**}"
if r(p)<0.01 local p_att_diff_st`j' = "\sym{***}"
}
local p_att_diff_N = e(N)


// ----------------------------------- MEM AHEAD ----------------------------------------------
//agelimit
reghdfe wc i.m_ahead##i.r_agelimit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "1.m_ahead 1.r_agelimit 1.m_ahead#1.r_agelimit"

forval j=1/3{
local h_m_ahead_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local h_m_ahead_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local h_m_ahead_st`j' = "\sym{*}"
if r(p)<0.05 local h_m_ahead_st`j'= "\sym{**}"
if r(p)<0.01 local h_m_ahead_st`j' = "\sym{***}"
}
local h_m_ahead_N = e(N)

//close to agelimit
reghdfe wc i.m_ahead##i.close_limit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "1.m_ahead 1.close_limit 1.m_ahead#1.close_limit"

forval j=1/3{
local p_m_ahead_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local p_m_ahead_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local p_m_ahead_st`j' = "\sym{*}"
if r(p)<0.05 local p_m_ahead_st`j'= "\sym{**}"
if r(p)<0.01 local p_m_ahead_st`j' = "\sym{***}"
}
local p_m_ahead_N = e(N)

// ----------------------------------- MEM DIFF ----------------------------------------------
//agelimit
reghdfe wc c.m_pos_diff##i.r_agelimit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "m_pos_diff 1.r_agelimit m_pos_diff#1.r_agelimit"

forval j=1/3{
local h_m_diff_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local h_m_diff_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local h_m_diff_st`j' = "\sym{*}"
if r(p)<0.05 local h_m_diff_st`j'= "\sym{**}"
if r(p)<0.01 local h_m_diff_st`j' = "\sym{***}"
}
local h_m_diff_N = e(N)

//close to agelimit
reghdfe wc c.m_pos_diff##i.close_limit `controls' if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

tokenize "m_pos_diff 1.close_limit m_pos_diff#1.close_limit"

forval j=1/3{
local p_m_diff_b`j': di %6.4f `= round(_b[``j''],0.0001)'
local p_m_diff_se`j': di %6.4f `= round(_se[``j''],0.0001)'
quietly test ``j''
if r(p)<0.1 local p_m_diff_st`j' = "\sym{*}"
if r(p)<0.05 local p_m_diff_st`j'= "\sym{**}"
if r(p)<0.01 local p_m_diff_st`j' = "\sym{***}"
}
local p_m_diff_N = e(N)


// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 

texdoc init tables/table_a12.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Type II errors: Referees close to retirement}
tex \begin{adjustbox}{max width=\linewidth}
tex	\begin{tabular}{l c c | c c | c c | c c }
tex		\hline\hline
tex 	&\multicolumn{2}{c|}{Ahead in ATT} & \multicolumn{2}{c|}{Difference in ATT position} & \multicolumn{2}{c|}{Ahead in members} & \multicolumn{2}{c}{Difference in member position}\\
tex		& (1) & (2) & (3) & (4) & (5) & (6)& (7) & (8)\\\hline

tex	Status	& `h_att_ahead_b1'`h_att_ahead_st1' & &`h_att_diff_b1'`h_att_diff_st1' & & `h_m_ahead_b1'`h_m_ahead_st1' & &`h_m_diff_b1'`h_m_diff_st1' & \\
tex			& (`h_att_ahead_se1') & & (`h_att_diff_se1') & &  (`h_m_ahead_se1') & & (`h_m_diff_se1') & \\
tex	Status $ \times$ 1 year to age limit	& `h_att_ahead_b3'`h_att_ahead_st3' & & `h_att_diff_b3'`h_att_diff_st3' & &  `h_m_ahead_b3'`h_m_ahead_st3' & & `h_m_diff_b3'`h_m_diff_st3' & \\
tex			& (`h_att_ahead_se3') & & (`h_att_diff_se3') & &  (`h_m_ahead_se3') & & (`h_m_diff_se3') & \\
tex	1 year to age limit	& `h_att_ahead_b2'`h_att_ahead_st2' & & `h_att_diff_b2'`h_att_diff_st2' & &  `h_m_ahead_b2'`h_m_ahead_st2' & & `h_m_diff_b2'`h_m_diff_st2' & \\
tex			& (`h_att_ahead_se2') & & (`h_att_diff_se2') & &  (`h_m_ahead_se2') & & (`h_m_diff_se2') & \\

tex	Status	& & `p_att_ahead_b1'`p_att_ahead_st1' & & `p_att_diff_b1'`p_att_diff_st1' & &  `p_m_ahead_b1'`p_m_ahead_st1' & & `p_m_diff_b1'`p_m_diff_st1' \\
tex			& &(`p_att_ahead_se1') & & (`p_att_diff_se1') & &  (`p_m_ahead_se1') & & (`p_m_diff_se1') \\
tex	Status $ \times$ 3 years to age limit	& & `p_att_ahead_b3'`p_att_ahead_st3' & & `p_att_diff_b3'`p_att_diff_st3' & &  `p_m_ahead_b3'`p_m_ahead_st3' & & `p_m_diff_b3'`p_m_diff_st3' \\
tex			& &(`p_att_ahead_se3') & & (`p_att_diff_se3') & & (`p_m_ahead_se3') & & (`p_m_diff_se3') \\
tex	3 years to age limit	& &`p_att_ahead_b2'`p_att_ahead_st2' & & `p_att_diff_b2'`p_att_diff_st2' & & `p_m_ahead_b2'`p_m_ahead_st2' & & `p_m_diff_b2'`p_m_diff_st2' \\
tex			& &(`p_att_ahead_se2') & & (`p_att_diff_se2') & & (`p_m_ahead_se2') & & (`p_m_diff_se2') \\\hline
tex	N		&`h_att_ahead_N' & `p_att_ahead_N'&`h_att_diff_N' & `p_att_diff_N'& `h_m_ahead_N' & `p_m_ahead_N'&`h_m_diff_N' & `p_m_diff_N' \\\hline\hline

tex \multicolumn{9}{p{\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates. The dependent variable is a dummy for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. The regressions include controls for the home team, inverse of odds, referee experience and average performance in the season, previous wrong decisions (both favorable and unfavorable for the affected and unaffected team), type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game, decisiveness of the call and the number of spectators. Furthermore season, gameday, referee and team fixed effects are included. Standard errors in parentheses are clustered at the team level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}
tex \end{adjustbox}
tex \end{table}
texdoc close

restore

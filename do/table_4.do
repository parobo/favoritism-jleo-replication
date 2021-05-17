// ----------------------------------------------------------------------------------------- 
// Table 4: Creating Table 4 from the paper 
// ----------------------------------------------------------------------------------------- 
preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions or summarize the variables of interest.
// ----------------------------------------------------------------------------------------- 

eststo X1: reghdfe wc i.affected_home i.att_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==0, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly estadd local fs "Yes", replace :X1
quietly estadd local fg "Yes", replace :X1
quietly estadd local ft "Yes", replace :X1
quietly estadd local fr "Yes", replace :X1

eststo X2: reghdfe wc i.affected_home att_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==0, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly estadd local fs "Yes", replace :X2
quietly estadd local fg "Yes", replace :X2
quietly estadd local ft "Yes", replace :X2
quietly estadd local fr "Yes", replace :X2

eststo X3: reghdfe wc i.affected_home i.m_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==0, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly estadd local fs "Yes", replace :X3
quietly estadd local fg "Yes", replace :X3
quietly estadd local ft "Yes", replace :X3
quietly estadd local fr "Yes", replace :X3

eststo X4: reghdfe wc i.affected_home m_pos_diff pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==0, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly estadd local fs "Yes", replace :X4
quietly estadd local fg "Yes", replace :X4
quietly estadd local ft "Yes", replace :X4
quietly estadd local fr "Yes", replace :X4

eststo X5: reghdfe wc i.affected_home pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==0, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly estadd local fs "Yes", replace :X5
quietly estadd local fg "Yes", replace :X5
quietly estadd local ft "Yes", replace :X5
quietly estadd local fr "Yes", replace :X5

// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
//add X5 into the esttab go add specification without status variables.
esttab X1 X2 X3 X4 using "tables/table_4.tex", b(4) se(4) star(* 0.10 ** 0.05 *** 0.01) s(fs fg ft fr N r2, ///
	label("Season FE" "Gameday FE" "Team FE" "Referee FE" "N" "$ R^2$")) replace l noomitted nobaselevels ///
	nodepvars title(Probability of type I errors) compress  nogaps nomti 
restore

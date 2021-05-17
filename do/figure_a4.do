// ----------------------------------------------------------------------------------------- 
// Figure A4: Creating figure a4 from the paper
// ----------------------------------------------------------------------------------------- 
version 14
preserve
set more off

// ----------------------------------- DATA PREPARATION  -----------------------------------
// Creates the necessary variables for the estimation.
// ----------------------------------------------------------------------------------------- 
encode affected, gen(d_affected)

// ----------------------------------- PLOTTING  -------------------------------------------
// Specifying the mrobust check 
// ----------------------------------------------------------------------------------------- 
local dep = "wc"
local controls = "(pw_invodds_corrected | pw_fav | elo_affected_pw) (minute | g_last10min) r_decisivecall (r_age | r_agelimit) (r_experience|r_bltenure|r_tenure) r_avg_performance_excl (r_prevwc |(r_prev_unfavcall r_prev_favcall r_prev_unfavcall_opp r_prev_favcall_opp)) d_home_away g_closegame (spec_num|spec_num_scaled) spec_capacity spec_runningtrack (pos_affected_lseas pos_unaffected_lseas) pts_diff int_qual_lseas int_qual_cseas i.refid i.season i.gameday"

set scheme plottig
mrobust reg `dep' (att_ahead i.d_affected) `controls' if true_awarded==1, vce(cluster $cluster_var)  noinfluence pref(-.0203643,.0051418) sample(1) alpha(.1) 
graph export "figures/figure_a4.png", replace

restore

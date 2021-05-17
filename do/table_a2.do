// ----------------------------------------------------------------------------------------- 
// Table A2: Creating Table A2 from the paper 
// ----------------------------------------------------------------------------------------- 
preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

gen goals_home = cond(goal==1, affected==home & awarded==1,0)
gen goals_away = cond(goal==1, affected==away & awarded==1,0)
gen pw_elo_home = cond(affected==home, elo_affected_pw,1-elo_affected_pw)

collapse (first) season home away att_pos_home att_pos_away m_home_pos m_away_pos pw_home_corrected pw_elo_home r_referee pos_home_before pos_away_before spec_num_scaled (sum) goals_home goals_away, by(gid)

gen att_ahead_home = (att_pos_home<att_pos_away)
gen m_ahead_home = (m_home_pos<m_away_pos)
gen att_home_diff = att_pos_home-att_pos_away
gen m_home_diff = m_home_pos-m_away_pos
gen pts_home = cond(goals_home>goals_away,3,cond(goals_home==goals_away,1,0))

label var pts_home "Points for home team"
label var pw_home_corrected "Win probability (odds based)"
label var pw_elo_home "Win probability (elo based)"
label var att_ahead_home "Ahead in ATT"
label var att_home_diff "ATT-position difference"
label var m_ahead_home "Ahead in Members"
label var m_home_diff "Members-position difference"
label var spec_num_scaled "Visitors (scaled)"

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 

eststo x1: oprobit pts_home pw_home_corrected att_ahead_home spec_num_scaled, vce(robust)
eststo x2: oprobit pts_home pw_elo_home att_ahead_home spec_num_scaled, vce(robust)
eststo x3: oprobit pts_home pw_home_corrected att_home_diff spec_num_scaled, vce(robust)
eststo x4: oprobit pts_home pw_elo_home att_home_diff spec_num_scaled, vce(robust)
eststo x5: oprobit pts_home pw_home_corrected m_ahead_home spec_num_scaled, vce(robust)
eststo x6: oprobit pts_home pw_elo_home m_ahead_home spec_num_scaled, vce(robust)
eststo x7: oprobit pts_home pw_home_corrected m_home_diff spec_num_scaled, vce(robust)
eststo x8: oprobit pts_home pw_elo_home m_home_diff spec_num_scaled, vce(robust)

/// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
esttab x1 x2 x3 x4 x5 x6 x7 x8 using "tables/table_a2.tex", b(4) se(4) star(* 0.10 ** 0.05 *** 0.01) s(N r2_p, ///
	label("N" "Pseudo-$ R^2$")) replace l noomitted nobaselevels ///
	nodepvars title(Ordered Probit Models on game outcome and status) compress nogaps nomti 
restore

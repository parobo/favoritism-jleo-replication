// ----------------------------------------------------------------------------------------- 
// Tables 9 and A16: Creating Tables 9 and A16 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

use "data/extratime.dta", clear

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 

reghdfe h2_extratime h2_home_ahead h2_att_ahead h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)==1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BS1
quietly estadd local fs "Yes", replace :BS1
quietly estadd local fr "Yes", replace :BS1
estadd local pr2 "`pr2'"

reghdfe h2_extratime h2_home_ahead h2_att_diff h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)==1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BS2
quietly estadd local fs "Yes", replace :BS2
quietly estadd local fr "Yes", replace :BS2
estadd local pr2 "`pr2'"

reghdfe h2_extratime h2_home_ahead h2_m_ahead h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)==1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BS3
quietly estadd local fs "Yes", replace :BS3
quietly estadd local fr "Yes", replace :BS3
estadd local pr2 "`pr2'"

reghdfe h2_extratime h2_home_ahead h2_m_diff h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)==1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BS4
quietly estadd local fs "Yes", replace :BS4
quietly estadd local fr "Yes", replace :BS4
estadd local pr2 "`pr2'"


//score diff !=1
reghdfe h2_extratime h2_home_ahead h2_att_ahead h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)>1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BT1
quietly estadd local fs "Yes", replace :BT1
quietly estadd local fr "Yes", replace :BT1
estadd local pr2 "`pr2'"

reghdfe h2_extratime h2_home_ahead h2_att_diff h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)>1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BT2
quietly estadd local fs "Yes", replace :BT2
quietly estadd local fr "Yes", replace :BT2
estadd local pr2 "`pr2'"

reghdfe h2_extratime h2_home_ahead h2_m_ahead h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)>1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BT3
quietly estadd local fs "Yes", replace :BT3
quietly estadd local fr "Yes", replace :BT3
estadd local pr2 "`pr2'"

reghdfe h2_extratime h2_home_ahead h2_m_diff h2_invodds_corrected h2_subs h2_rc h2_yc h2_pen h2_goals c.visitors ///
	if abs(h2_goals_a-h2_goals_h)>1, absorb(season refid) vce(robust)
local pr2 : di %3.2f `= round(e(r2),0.01)'
eststo BT4
quietly estadd local fs "Yes", replace :BT4
quietly estadd local fr "Yes", replace :BT4
estadd local pr2 "`pr2'"
 
// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
esttab BS1 BS2 BS3 BS4 using "tables/table_9.tex", b(4) se(4) star(* 0.10 ** 0.05 *** 0.01) replace l noomitted nobaselevels ///
s(fs fr N r2, label("Season FE" "Referee FE" "N" "$ R^2$")) nodepvars title(Extra time in close games) compress  nogaps nomti

esttab BT1 BT2 BT3 BT4 using "tables/table_a16.tex", b(4) se(4) star(* 0.10 ** 0.05 *** 0.01) replace l noomitted nobaselevels ///
s(fs fr N r2, label("Season FE" "Referee FE" "N" "$ R^2$")) nodepvars title(Extra time in other games) compress  nogaps nomti
	
restore

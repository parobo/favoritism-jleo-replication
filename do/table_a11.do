// ----------------------------------------------------------------------------------------- 
// Table A11: Creating Table A11 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

use "data/pause.dta", clear

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 
local controls "i.dfb i.international c.age##c.age bltenure avgpause"


nbreg pause `controls' i.refid if pause>=0, cluster(refid) iter(5000)
margins, dydx(*) post vce(unconditional)
eststo X1
estadd local reffe "Yes"

nbreg pause wc_tot_den wc_tot_aw `controls' i.refid if pause>=0, cluster(refid) iter(5000)
test wc_tot_den=wc_tot_aw
local t1 = r(p)
margins, dydx(*) post vce(unconditional)
eststo X2
estadd local reffe "Yes"

nbreg pause wc_den_att_ahead wc_den_att_behind wc_aw_att_ahead wc_aw_att_behind  `controls' i.refid if pause>=0, cluster(refid) iter(5000)
test wc_den_att_ahead=wc_den_att_behind
local t2_den = r(p)
test wc_aw_att_ahead=wc_aw_att_behind
local t2_aw = r(p)
margins, dydx(*) post vce(unconditional)
eststo X3
estadd local reffe "Yes"

nbreg pause wc_den_m_ahead wc_den_m_behind wc_aw_m_ahead wc_aw_m_behind `controls' i.refid if pause>=0, cluster(refid) iter(5000)
test wc_den_m_ahead=wc_den_m_behind
local t3_den = r(p)
test wc_aw_m_ahead=wc_aw_m_behind
local t3_aw = r(p)
margins, dydx(*) post vce(unconditional)
eststo X4
estadd local reffe "Yes"

// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
esttab X1 X2 X3 X4 using "tables/table_a11.tex", b(4) se(4) star(* 0.10 ** 0.05 *** 0.01) margin replace l noomitted nobaselevels ///
nodepvars title("Negative binomial models on pause between games (without performance)") compress nogaps nomti scalars("reffe Referee FE")

capture log close
log using logs/table_a11_tests, replace
log on
noisily{
di "Tests for equality of coefficients. p-values."
di "------------"
di "(2) - Type II errors = Type I errors"
di "p-value: `t1'"
di "------------"
di "(3) - Type II errors (ATT ahead) = Type II errors (ATT behind)"
di "p-value: `t2_den'"
di "(3) - Type I errors (ATT ahead) = Type I errors (ATT behind)"
di "p-value: `t2_aw'"
di "------------"
di "(4) -  Type II errors (members ahead) = Type II errors (members behind)"
di "p-value: `t3_den'"
di "(4) - Type I errors (members ahead) = Type I errors (members behind)"
di "p-value: `t3_aw'"
di "------------"
}
log off
log close

restore

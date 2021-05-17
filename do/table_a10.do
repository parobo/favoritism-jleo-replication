// ----------------------------------------------------------------------------------------- 
// Table A10: Creating Table A10 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 
use "data/exit.dta", clear
gen entry = first_season-1

stset season, failure(exit) origin(entry) id(refid) if(agelimit!=1 & !(lname=="Koop" & exit==1))
rename _d r_exit
label var r_exit "Referee exits pool"
rename _t time
label var time "Time in BL"

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions or summarize the variables of interest.
// ----------------------------------------------------------------------------------------- 
local controls "dfb international c.age##c.age i.time"

cloglog r_exit `controls', nolog noomitted noemptycells vsquish cluster(refid)
margins, dydx(dfb international age) post vce(unconditional)
eststo X1
quietly estadd local ts "Yes", replace :X1

cloglog r_exit pg_tot_den pg_tot_aw `controls', nolog noomitted noemptycells vsquish cluster(refid)
test pg_tot_den=pg_tot_aw
local t1 = r(p)
margins, dydx(pg_tot_den pg_tot_aw dfb international age) post vce(unconditional)
eststo X2
quietly estadd local ts "Yes", replace :X2

cloglog r_exit pg_wc_den_att_ahead pg_wc_den_att_behind pg_wc_aw_att_ahead pg_wc_aw_att_behind `controls', nolog noomitted noemptycells vsquish cluster(refid)
test pg_wc_den_att_ahead=pg_wc_den_att_behind
local t2_den = r(p)
test pg_wc_aw_att_ahead=pg_wc_aw_att_behind
local t2_aw = r(p)
margins, dydx(pg_wc_den_att_ahead pg_wc_den_att_behind pg_wc_aw_att_ahead pg_wc_aw_att_behind dfb international age) post vce(unconditional)
eststo X3
quietly estadd local ts "Yes", replace :X3

cloglog r_exit pg_wc_den_m_ahead pg_wc_den_m_behind pg_wc_aw_m_ahead pg_wc_aw_m_behind `controls', nolog noomitted noemptycells vsquish cluster(refid)
test pg_wc_den_m_ahead=pg_wc_den_m_behind
local t3_den = r(p)
test pg_wc_aw_m_ahead=pg_wc_aw_m_behind
local t3_aw = r(p)
margins, dydx(pg_wc_den_m_ahead pg_wc_den_m_behind pg_wc_aw_m_ahead pg_wc_aw_m_behind dfb international age) post vce(unconditional)
eststo X4
quietly estadd local ts "Yes", replace :X4

// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
esttab X1 X2 X3 X4 using "tables/table_a10.tex", b(4) se(4) star(* 0.10 ** 0.05 *** 0.01) margin replace l noomitted nobaselevels ///
s(ts N, label("Tenure FE" "N")) nodepvars title("Complementary log-log models on exit from the referee pool (without performance)") compress nogaps nomti

capture log close
log using logs/table_a10_tests, replace
log on
noisily{
di "Tests for equality of coefficients. p-values."
di "------------"
di "(2) - PG: Type II errors = PG: Type I errors"
di "p-value: `t1'"
di "------------"
di "(3) - PG: Type II errors (ATT ahead) = PG: Type II errors (ATT behind)"
di "p-value: `t2_den'"
di "(3) - PG: Type I errors (ATT ahead) = PG: Type I errors (ATT behind)"
di "p-value: `t2_aw'"
di "------------"
di "(4) - PG: Type II errors (members ahead) = PG: Type II errors (members behind)"
di "p-value: `t3_den'"
di "(4) - PG: Type I errors (members ahead) = PG: Type I errors (members behind)"
di "p-value: `t3_aw'"
di "------------"
}
log off
log close
restore

// ----------------------------------------------------------------------------------------- 
// Figure 3: Creating figure 3 from the paper (without the tests)
// ----------------------------------------------------------------------------------------- 

version 14 
set more off

// ----------------------------------- DATA PREPARATION  -----------------------------------
// Preps the data, such that we have the averages for the figures.
// ----------------------------------------------------------------------------------------- 
preserve

gen cat = ceil(_n/4) if _n<=8
gen pct = .

gen events = "Goal (should be given)" if inlist(_n,1,5)
replace events = "Goal (should not be given)" if inlist(_n,2,6)
replace events = "Penalty (should be given)" if inlist(_n,3,7)
replace events = "Penalty (should not be given)" if inlist(_n,4,8)

label def categ 1 "Away" 2 "Home"
label val cat categ

quietly su wc if true_event =="Goal (should be given)" & affected_home==0
replace pct = r(mean) if events == "Goal (should be given)" & _n ==1
quietly su wc if true_event =="Goal (should be given)" & affected_home==1
replace pct = r(mean) if events == "Goal (should be given)" & _n == 5
quietly su wc if true_event =="Goal (should not be given)" & affected_home==0
replace pct = r(mean) if events == "Goal (should not be given)" &  _n ==2
quietly su wc if true_event =="Goal (should not be given)" & affected_home==1
replace pct = r(mean) if events == "Goal (should not be given)" & _n ==6
quietly su wc if true_event =="Penalty (should be given)" & affected_home==0
replace pct = r(mean) if events == "Penalty (should be given)" & _n ==3
quietly su wc if true_event =="Penalty (should be given)" & affected_home==1
replace pct = r(mean) if events == "Penalty (should be given)" & _n ==7
quietly su wc if true_event =="Penalty (should not be given)" & affected_home==0
replace pct = r(mean) if events == "Penalty (should not be given)" & _n ==4
quietly su wc if true_event =="Penalty (should not be given)" & affected_home==1
replace pct = r(mean) if events == "Penalty (should not be given)" & _n ==8


// ----------------------------------- PLOT ------------------------------------------------
// Creates the raw graph, numbers for differences have to be added by hand.
// ----------------------------------------------------------------------------------------- 
graph bar pct , over(cat, label(labsize(vsmall))) nofill ytitle(Percentage of wrong decisions) yscale(range(0 0.3)) by(events) scheme(plottig)
graph export "figures/figure_3.png", replace
graph close


// ----------------------------------- TEST DIFFERENCES ------------------------------------
// Test the differences between the categories and log them.
// ----------------------------------------------------------------------------------------- 
capture log close
log using logs/figure_3_tests, replace
log on
noisily{
prtest wc if goal==0 & true_awarded==0, by(affected_home)
prtest wc if goal==0 & true_awarded==1, by(affected_home)
prtest wc if goal==1 & true_awarded==0, by(affected_home)
prtest wc if goal==1 & true_awarded==1, by(affected_home)
}
log off
log close

restore

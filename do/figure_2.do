// ----------------------------------------------------------------------------------------- 
// Figure 2: Creating figure 2 from the paper (without the tests)
// ----------------------------------------------------------------------------------------- 

version 14 
set more off
// ----------------------------------- DATA PREPARATION  -----------------------------------
// Preps the data, such that we have the averages for the figures.
// ----------------------------------------------------------------------------------------- 
preserve 

gen cat = ceil(_n/4) if _n<=16
gen ocat = ceil(cat/2)
gen pct = .

gen events = "Goal (should be given)" if inlist(_n,1,5,9,13)
replace events = "Goal (should not be given)" if inlist(_n,2,6,10,14)
replace events = "Penalty (should be given)" if inlist(_n,3,7,11,15)
replace events = "Penalty (should not be given)" if inlist(_n,4,8,12,16)

label def categ 1 "Lower" 2 "Higher" 3 "Fewer" 4 "More"
label def ocateg 1 "ATT position" 2 "Members"
label val cat categ
label val ocat ocateg 

tokenize "att_ahead m_ahead"

foreach n of numlist 1/2{
	quietly su wc if true_event =="Goal (should be given)" & ``n''==0
	replace pct = r(mean) if events == "Goal (should be given)" & ocat ==`n' & cat ==2*(`n'-1)+1
	quietly su wc if true_event =="Goal (should be given)" & ``n''==1
	replace pct = r(mean) if events == "Goal (should be given)" & ocat ==`n' & cat ==2*(`n'-1)+2
	quietly su wc if true_event =="Goal (should not be given)" & ``n''==0
	replace pct = r(mean) if events == "Goal (should not be given)" & ocat ==`n' & cat ==2*(`n'-1)+1
	quietly su wc if true_event =="Goal (should not be given)" & ``n''==1
	replace pct = r(mean) if events == "Goal (should not be given)" & ocat ==`n' & cat ==2*(`n'-1)+2
	quietly su wc if true_event =="Penalty (should be given)" & ``n''==0
	replace pct = r(mean) if events == "Penalty (should be given)" & ocat ==`n' & cat ==2*(`n'-1)+1
	quietly su wc if true_event =="Penalty (should be given)" & ``n''==1
	replace pct = r(mean) if events == "Penalty (should be given)" & ocat ==`n' & cat ==2*(`n'-1)+2
	quietly su wc if true_event =="Penalty (should not be given)" & ``n''==0
	replace pct = r(mean) if events == "Penalty (should not be given)" & ocat ==`n' & cat ==2*(`n'-1)+1
	quietly su wc if true_event =="Penalty (should not be given)" & ``n''==1
	replace pct = r(mean) if events == "Penalty (should not be given)" & ocat ==`n' & cat ==2*(`n'-1)+2
}

// ----------------------------------- PLOT ------------------------------------------------
// Creates the raw graph, numbers for differences have to be added by hand.
// ----------------------------------------------------------------------------------------- 
graph bar pct , over(cat, label(labsize(vsmall))) over(ocat, label(labsize(vsmall))) nofill ytitle(Percentage of wrong decisions) yscale(range(0 0.3)) by(events) scheme(plottig)
graph export "figures/figure_2.png", replace
graph close


// ----------------------------------- TEST DIFFERENCES ------------------------------------
// Test the differences between the categories and log them.
// ----------------------------------------------------------------------------------------- 
capture log close
log using logs/figure_2_tests, replace
log on
noisily{
// ----------------------------------------------------------------------------------------- 
// ---------------------------------- For ahead (ATT) -------------------------------------- 
// -----------------------------------------------------------------------------------------
prtest wc if goal==0 & true_awarded==0, by(att_ahead)
prtest wc if goal==0 & true_awarded==1, by(att_ahead)
prtest wc if goal==1 & true_awarded==0, by(att_ahead)
prtest wc if goal==1 & true_awarded==1, by(att_ahead)
// ----------------------------------------------------------------------------------------- 
// ---------------------------------- For ahead (M) ---------------------------------------- 
// ----------------------------------------------------------------------------------------- 
prtest wc if goal==0 & true_awarded==0, by(m_ahead)
prtest wc if goal==0 & true_awarded==1, by(m_ahead)
prtest wc if goal==1 & true_awarded==0, by(m_ahead)
prtest wc if goal==1 & true_awarded==1, by(m_ahead)
}
log off
log close


restore


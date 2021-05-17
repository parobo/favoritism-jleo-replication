// ----------------------------------------------------------------------------------------- 
// Figures 4 and A7: Creating figures 4 and A7 from the paper (without the tests)
// ----------------------------------------------------------------------------------------- 
version 14
set more off

foreach t in "att" "m"{
preserve

// ----------------------------------- DATA PREPARATION  -----------------------------------
// Preps the data for the plots.
// ----------------------------------------------------------------------------------------- 
mat drop _all
foreach g of numlist 0/1{

local x = 0
quietly foreach diff of numlist 5(5)20{
	noisily di "Trying with `x' to `diff'" 
	tab true_awarded `t'_ahead if abs(`t'_pos_diff)<=`diff' & abs(`t'_pos_diff)>`x' & r_call!=3 & goal==`g', matcell(MDiff)
	
	capture confirm matrix ddiff
	if _rc==111{
		local perc1 = MDiff[2,2]/(MDiff[1,2]+MDiff[2,2])
		local perc2 = MDiff[2,1]/(MDiff[1,1]+MDiff[2,1])
		local percdiff = `perc1'-`perc2'
		di "`percdiff'"
		matrix input ddiff = (`g',1,`x',`diff', `perc1',`percdiff' \ `g',2,`x',`diff', `perc2',`percdiff')
		}
	else{
		local perc1 = MDiff[2,2]/(MDiff[1,2]+MDiff[2,2])
		local perc2 = MDiff[2,1]/(MDiff[1,1]+MDiff[2,1])
		local percdiff = `perc1'-`perc2'
		matrix input xdiff = (`g',1,`x',`diff', `perc1',`percdiff' \ `g',2,`x',`diff', `perc2',`percdiff')
		matrix ddiff = (ddiff\xdiff)
		}
	
	local x = `diff'
}

tab true_awarded `t'_ahead if abs(`t'_pos_diff)>20 & r_call!=3 & goal==`g', matcell(MDiff)
local perc1 = MDiff[2,2]/(MDiff[1,2]+MDiff[2,2])
local perc2 = MDiff[2,1]/(MDiff[1,1]+MDiff[2,1])
local percdiff = `perc1'-`perc2'
matrix input xdiff = (`g',1,20,51, `perc1',`percdiff' \ `g',2,20,51, `perc2',`percdiff')
matrix ddiff = (ddiff\xdiff)
}
mat colnames ddiff = goaldesc pos start end perc difference
svmat ddiff, names(col)

label def pos_label 2 "Behind" 1 "Ahead"
label values pos pos_label
label def end_label 2 "0-2" 5 "1-5" 10 "6-10" 15 "11-15" 20 "16-20" 51 "over 21"
label values end end_label

if "`t'"=="att" local tlabel ="ATT"
if "`t'"=="m" local tlabel ="Member"
gen xtitle = 1
label def xt_label 1 "Difference in `tlabel'-position"
label values xtitle xt_label

// ----------------------------------- PLOT ------------------------------------------------
// Creates the raw graph, numbers for differences have to be added by hand.
// ----------------------------------------------------------------------------------------- 
if "`t'"=="att" local c ="1"
if "`t'"=="m" local c ="2"
graph bar perc if goaldesc==0, over(pos, label(labsize(vsmall))) over(end, label(labsize(small))) over(xtitle, label(labsize(small))) nofill ytitle(Percentage of deserved penalties) scheme(plottig) blabel(bar, format(%5.3f) size(small) position(inside) color(gs15)) bar(1,color(plb1) fintensity(100)) bar(2,color(plr1) fintensity(100)) legend(pos(6) col(2)) bargap(5)
graph export figures/figure_4_`c'.png, replace


graph bar perc if goaldesc==1, over(pos, label(labsize(vsmall))) over(end, label(labsize(small))) over(xtitle, label(labsize(small)))  nofill ytitle(Percentage of deserved goals) scheme(plottig) blabel(bar, format(%5.3f) size(small) position(inside) color(gs15)) bar(1,color(plb1) fintensity(100)) bar(2,color(plr1) fintensity(100)) legend(pos(6) col(2)) bargap(5)
graph export figures/figure_a7_`c'.png, replace

restore
}

// ----------------------------------- TEST DIFFERENCES ------------------------------------
// Test the differences between the categories and log them.
// ----------------------------------------------------------------------------------------- 
capture log close
log using logs/figure_4_1_tests, replace
log on
noisily{
prtest true_awarded if goal==0 & abs(att_pos_diff)>0 & abs(att_pos_diff)<=5 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==0 & abs(att_pos_diff)>5 & abs(att_pos_diff)<=10 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==0 & abs(att_pos_diff)>10 & abs(att_pos_diff)<=15 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==0 & abs(att_pos_diff)>15 & abs(att_pos_diff)<=20 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==0 & abs(att_pos_diff)>20 & r_call!=3, by(att_ahead)
}
log off
log close

capture log close
log using logs/figure_4_2_tests, replace
log on
noisily{
prtest true_awarded if goal==0 & abs(m_pos_diff)>0 & abs(m_pos_diff)<=5 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==0 & abs(m_pos_diff)>5 & abs(m_pos_diff)<=10 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==0 & abs(m_pos_diff)>10 & abs(m_pos_diff)<=15 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==0 & abs(m_pos_diff)>15 & abs(m_pos_diff)<=20 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==0 & abs(m_pos_diff)>20 & r_call!=3, by(m_ahead)
}
log off
log close

log using logs/figure_a7_1_tests, replace
log on
noisily{
prtest true_awarded if goal==1 & abs(att_pos_diff)>0 & abs(att_pos_diff)<=5 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==1 & abs(att_pos_diff)>5 & abs(att_pos_diff)<=10 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==1 & abs(att_pos_diff)>10 & abs(att_pos_diff)<=15 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==1 & abs(att_pos_diff)>15 & abs(att_pos_diff)<=20 & r_call!=3, by(att_ahead)
prtest true_awarded if goal==1 & abs(att_pos_diff)>20 & r_call!=3, by(att_ahead)
}
log off
log close

capture log close
log using logs/figure_a7_2_tests, replace
log on
noisily{
prtest true_awarded if goal==1 & abs(m_pos_diff)>0 & abs(m_pos_diff)<=5 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==1 & abs(m_pos_diff)>5 & abs(m_pos_diff)<=10 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==1 & abs(m_pos_diff)>10 & abs(m_pos_diff)<=15 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==1 & abs(m_pos_diff)>15 & abs(m_pos_diff)<=20 & r_call!=3, by(m_ahead)
prtest true_awarded if goal==1 & abs(m_pos_diff)>20 & r_call!=3, by(m_ahead)
}
log off
log close

// ----------------------------------------------------------------------------------------- 
// Figure A3: Creating figure A3 from the paper 
// ----------------------------------------------------------------------------------------- 
version 14 
set more off

// ----------------------------------- DATA PREPARATION  -----------------------------------
// Preps the data
// ----------------------------------------------------------------------------------------- 
preserve
gen r_birthyear = year(r_birthday)
duplicates drop refid, force
// ----------------------------------- PLOTTING --------------------------------------------
// Creates the plots
// -----------------------------------------------------------------------------------------

hist r_birthyear, scheme(plottig) xtitle(Year of birth) ytitle(Fraction of referees) width(1) frac start(1950) discrete
graph export "figures/figure_a6.png", replace
graph close

restore

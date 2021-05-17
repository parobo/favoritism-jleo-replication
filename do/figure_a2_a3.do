// ----------------------------------------------------------------------------------------- 
// Figure A3: Creating figure A3 from the paper 
// ----------------------------------------------------------------------------------------- 
version 14 
set more off


// ----------------------------------- DATA PREPARATION  -----------------------------------
// Preps the data
// ----------------------------------------------------------------------------------------- 
preserve

keep home att_pos_home m_home_pos season
duplicates drop
sort home season

gen att_change = abs(att_pos_home - att_pos_home[_n-1]) if home == home[_n-1] & season==season[_n-1]+1
gen m_change = abs(m_home_pos - m_home_pos[_n-1]) if home == home[_n-1] & season==season[_n-1]+1

// ----------------------------------- PLOTTING --------------------------------------------
// Creates the plots
// ----------------------------------------------------------------------------------------- 

graph box att_change if season>2000, over(season) scheme(plottig) box(1,fcolor(plb1) fintensity(80))  cw ytitle(Absoulte change in ATT positioning) 
graph export "figures/figure_a2.png", replace
graph close

graph box m_change if season>2000, over(season) scheme(plottig) box(1,fcolor(plb1) fintensity(80))  cw ytitle(Absoulte change in Members positioning) 
graph export "figures/figure_a3.png", replace
graph close

restore

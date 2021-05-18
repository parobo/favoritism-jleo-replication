// ----------------------------------------------------------------------------------------- 
// Figure A1: Creating figure A1 from the paper
// ----------------------------------------------------------------------------------------- 

version 14 
set more off


// ----------------------------------- DATA PREPARATION  ----------------------------------
// Preps the data.
// ----------------------------------------------------------------------------------------- 
preserve 

duplicates drop home season, force
keep home season
rename home team
merge 1:1 team season using data/members_interpolation.dta
drop if _merge ==1
recode _merge (2=0) (3=1), gen(playedBL)
quietly su members_ipol 
replace playedBL = r(max) if playedBL
label var playedBL "Team played in Bundesliga"
// ----------------------------------- PLOT ------------------------------------------------
// Creates the graph.
// ----------------------------------------------------------------------------------------- 
gsort -season -members_ipol team
twoway (bar playedBL season) (scatter members_ipol members season) if season>=1999, by(team) legend(order(2 "Members (extra-/intrapolated)" 3 "Members (data available)" 1 "Team in data") cols(3) pos(6) size(medsmall)) ylabel(,labsize(medsmall) angle(horizontal)) scheme(plottig)
graph export "figures/figure_a1.png", replace
graph close

restore

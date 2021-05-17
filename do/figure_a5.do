// ----------------------------------------------------------------------------------------- 
// Figure A5: Creating figure A5 from the paper
// ----------------------------------------------------------------------------------------- 
version 14 
set more off

// ----------------------------- DATA PREPARATION &  PLOT-----------------------------------
// Preps the data for the figures and plots them.
// ----------------------------------------------------------------------------------------- 
preserve 
collapse (mean) spec_num att_pos_away, by(away season)
collapse (mean) spec_num, by(att_pos_away)

twoway (scatter spec_num att_pos_away) (lfit spec_num att_pos_away), xscale(reverse) scheme(plottig) legend(order(1 "Attendance" 2 "Linear fit") position(6) cols(2)) xlabel(52(3)1) xtitle("ATT position of away team") ytitle("Avg. attendance of visitors")
graph export figures/figure_a5_1.png, replace

restore
preserve
collapse (mean) spec_num m_away_pos, by(away season)
collapse (mean) spec_num, by(m_away_pos)

twoway (scatter spec_num m_away_pos) (lfit spec_num m_away_pos), xscale(reverse) scheme(plottig) legend(order(1 "Attendance" 2 "Linear fit") position(6) cols(2)) xlabel(31(3)1) xtitle("Member position of away team") ytitle("Avg. attendance of visitors")
graph export figures/figure_a5_2.png, replace
restore

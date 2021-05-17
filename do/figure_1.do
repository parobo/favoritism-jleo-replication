// ----------------------------------------------------------------------------------------- 
// Figure 1: Creating figure 1 from the paper
// ----------------------------------------------------------------------------------------- 

version 14 
set more off
// ----------------------------------- DATA PREPARATION  -----------------------------------
// Preps the data, such that we have yearly averages to then create the figure.
// ----------------------------------------------------------------------------------------- 
preserve 
collapse (mean) wc, by(season true_event)

// ----------------------------------- PLOTTING  -------------------------------------------
// Creates the Plot.
// ----------------------------------------------------------------------------------------- 
twoway line wc season, by(true_event) yti("Percentage of wrong decisions") xti(Year) xlabel(2000(4)2012) legend(order(1 "Wrong") cols(3) position(6)) scheme(plottig)

graph export figures/figure_1.png, replace //saves the plot
graph close

restore

// ----------------------------------------------------------------------------------------- 
// Table A3: Creating Table A3 from the paper 
// ----------------------------------------------------------------------------------------- 
preserve
version 14 
set more off

// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

local game_stats = "g_affected_shots g_unaffected_shots g_affected_fouls g_unaffected_fouls g_affected_ballcontacts g_unaffected_ballcontacts g_affected_possession g_unaffected_possession"


// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 

texdoc init tables/table_a3.tex, replace
tex \begin{longtable}{p{3cm}|p{5cm}|p{2cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}|p{1cm}}
tex \hline\hline
tex Variable & Description & Availability & Min. & Max. & Mean & $ \rho_1$ & $ \rho_2$ & $ \rho_3$ & $ \rho_4$ \\\hline\endhead

foreach var of varlist affected_home pw_invodds r_experience r_avg_performance_excl r_prev_favcall r_prev_unfavcall goal g_last10min g_closegame r_decisivecall spec_num_scaled spec_runningtrack `game_stats' {
	local lb: var label `var'
	su season if !missing(`var'), meanonly
	local slow = r(min)
	local shigh = r(max)
	su `var'
	local vlow: di %10.2f `= r(min)'
	local vhigh: di %10.2f `= r(max)'
	local vmean: di %10.2f `= r(mean)'
	quietly correl `var' att_ahead
	local vcor1 : di %3.2f `= r(rho)'
	quietly correl `var' att_pos_diff
	local vcor2 : di %3.2f `= r(rho)'
	quietly correl `var' m_ahead
	local vcor3 : di %3.2f `= r(rho)'
	quietly correl `var' m_pos_diff
	local vcor4 : di %3.2f `= r(rho)'
	tex	`lb' & description added by hand & `slow' -- `shigh' & `vlow' & `vhigh' & `vmean' & `vcor1' & `vcor2'& `vcor3'& `vcor4'\\
	}
tex \end{longtable}
texdoc close
restore

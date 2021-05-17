// ----------------------------------------------------------------------------------------- 
// Table 8: Creating Table 8 from the paper 
// ----------------------------------------------------------------------------------------- 

preserve
version 14
set more off
// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

//create referee specific status variables using performance of teams when referees were young
foreach t in "1t10y" "11t20y" "21t30y"{
	gen r_att_affected_`t'_ahead = cond(affected==home,cond(r_att_home_`t'<r_att_away_`t',1,0),cond(r_att_home_`t'<r_att_away_`t',0,1))
	label var r_att_affected_`t'_ahead "Ahead in rolling ATT"
	gen r_att_affected_`t'_diff = cond(affected==home,r_att_away_`t'-r_att_home_`t',r_att_away_`t'-r_att_home_`t')
	label var r_att_affected_`t'_diff "Difference in rolling ATT"
	}

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions. 
// ----------------------------------------------------------------------------------------- 
foreach t in "1t10y" "11t20y" "21t30y"{
foreach x in "ahead" "diff"{
	if "`x'"=="diff" local z "pos_diff"
	if "`x'"=="ahead" local z "ahead"
	reghdfe wc i.affected_home r_att_affected_`t'_`x' att_`z' pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min ///
	i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)

	local r_att_affected_`t'_`x'_b: di %6.4f `= round(_b[r_att_affected_`t'_`x'],0.0001)'
	local r_att_affected_`t'_`x'_se: di %6.4f `= round(_se[r_att_affected_`t'_`x'], 0.0001)'
	local r_att_affected_`t'_`x'_N = e(N)
	
	if sign(_b[r_att_affected_`t'_`x'])!=sign(`r_att_affected_`t'_`x'_b') local r_att_affected_`t'_`x'_b = -`r_att_affected_`t'_`x'_b'
	quietly test r_att_affected_`t'_`x'
	if r(p)<0.1 local r_att_affected_`t'_`x'_st = "\sym{*}"
	if r(p)<0.05 local r_att_affected_`t'_`x'_st = "\sym{**}"
	if r(p)<0.01 local r_att_affected_`t'_`x'_st = "\sym{***}"
	}
foreach d of numlist 5(5)10{
	reghdfe wc i.affected_home r_att_affected_`t'_ahead att_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min ///
	i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==1 & abs(att_pos_diff)>=`d', vce(cluster $cluster_var) a(season gameday refid  affected)

	local r_att_affected_`t'_`d'_b: di %6.4f `= round(_b[r_att_affected_`t'_ahead],0.0001)'
	local r_att_affected_`t'_`d'_se: di %6.4f `= round(_se[r_att_affected_`t'_ahead], 0.0001)'
	local r_att_affected_`t'_`d'_N = e(N)
	
	if sign(_b[r_att_affected_`t'_ahead])!=sign(`r_att_affected_`t'_`d'_b') local r_att_affected_`t'_`d'_b = -`r_att_affected_`t'_`d'_b'	
	quietly test r_att_affected_`t'_ahead
	if r(p)<0.1 local r_att_affected_`t'_`d'_st = "\sym{*}"
	if r(p)<0.05 local r_att_affected_`t'_`d'_st = "\sym{**}"
	if r(p)<0.01 local r_att_affected_`t'_`d'_st = "\sym{***}"
	}
}


// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 
texdoc init tables/table_8.tex, replace
tex \begin{table}[t]
tex	\centering
tex \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
tex	\caption{Probability of type II errors -- status by referee's birthyear}
tex	\begin{tabular}{l c c c}
tex		\hline\hline
tex		& (1) & (2) & (3)\\
tex		& 1-10 y.o.& 11-20 y.o.& 21-30 y.o.\\\hline


	local lb: var label r_att_affected_1t10y_ahead
	tex		`lb' & `r_att_affected_1t10y_ahead_b'`r_att_affected_1t10y_ahead_st'& `r_att_affected_11t20y_ahead_b'`r_att_affected_11t20y_ahead_st' & `r_att_affected_21t30y_ahead_b'`r_att_affected_21t30y_ahead_st'\\
	tex			 & (`r_att_affected_1t10y_ahead_se')& (`r_att_affected_11t20y_ahead_se')& (`r_att_affected_21t30y_ahead_se')\\\hline
	tex	 	 N	 & `r_att_affected_1t10y_ahead_N' & `r_att_affected_11t20y_ahead_N'& `r_att_affected_21t30y_ahead_N'\\\hline\hline\\
	
	foreach d of numlist 5(5)10 {
	tex		`lb' (diff. $ \geq `d'$ ) & `r_att_affected_1t10y_`d'_b'`r_att_affected_1t10y_`d'_st'& `r_att_affected_11t20y_`d'_b'`r_att_affected_11t20y_`d'_st' & `r_att_affected_21t30y_`d'_b'`r_att_affected_21t30y_`d'_st'\\
	tex			 & (`r_att_affected_1t10y_`d'_se')& (`r_att_affected_11t20y_`d'_se')& (`r_att_affected_21t30y_`d'_se')\\\hline
	tex	 	 N	 & `r_att_affected_1t10y_`d'_N' & `r_att_affected_11t20y_`d'_N'& `r_att_affected_21t30y_`d'_N'\\\hline\hline\\
	
}
		local lb: var label r_att_affected_1t10y_diff
	tex		`lb' & `r_att_affected_1t10y_diff_b'`r_att_affected_1t10y_diff_st'& `r_att_affected_11t20y_diff_b'`r_att_affected_11t20y_diff_st' & `r_att_affected_21t30y_diff_b'`r_att_affected_21t30y_diff_st'\\
	tex			 & (`r_att_affected_1t10y_diff_se')& (`r_att_affected_11t20y_diff_se')& (`r_att_affected_21t30y_diff_se')\\\hline
	tex	 	 N	 & `r_att_affected_1t10y_diff_N' & `r_att_affected_11t20y_diff_N'& `r_att_affected_21t30y_diff_N'\\\hline\hline\\

tex \multicolumn{4}{p{0.6\linewidth}}{\footnotesize{\emph{Note:} Linear probability model estimates; (d) for discrete change of dummy variable from 0 to 1. The dependent variable is a dummy for wrong calls among penalties and goals that should have been awarded. Debatable decisions are excluded. The variable ``Ahead in rolling ATT" is a dummy variable indicating if the affected team was ahead in the rolling all time table (in terms of collected points in the Bundesliga) when the referee was in the age indicated in the respective column. Similarly, ``Ahead in rolling ATT (diff. $ \geq 5$ )" and ``Ahead in rolling ATT (diff. $ \geq 10$ )" are dummy variables taking value 1 if the affected team was ahead in the rolling ATT, but the sample is restricted to only include games in which the difference in the ATT was at least 5 and 10 respectively. Importantly all regressions include controls for whether the the team affected by the decision is ahead in full all time table (our benchmark variable specification) or the ATT-position difference from the full all time table. The regressions furthermore include controls for the home team, inverse of odds, referee experience and average performance in the season, type of the situation (goal or penalty), the last 10 minutes of the game, closeness of the game, decisiveness of the call, the number of spectators, and stadiums with running tracks. Furthermore season, gameday, referee and team fixed effects are included. Standard errors in parentheses are clustered at the game level. $^{***}: p<0.01, ^{**}:p<0.05,^{*}:p<0.1$.}}
tex	\end{tabular}	
tex \end{table}
texdoc close

restore

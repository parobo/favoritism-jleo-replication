// ----------------------------------------------------------------------------------------- 
// Table 1: Creating Table 1 from the paper
// ----------------------------------------------------------------------------------------- 
preserve
version 14
set more off

// ----------------------------------- DATA PREPARATION ------------------------------------
// Prepares the data before creating the table.
// ----------------------------------------------------------------------------------------- 

// ----------------------------------- REGRESSIONS -----------------------------------------
// Run the relevant regressions or summarize the variables of interest.
// ----------------------------------------------------------------------------------------- 

quietly: count if goal==1 & awarded==1 & r_call==2
local g1 = r(N)
quietly: count if goal==1 & awarded==0 & r_call==1
local g2 = r(N)
local g3 = `g1'+`g2'
local g1_p: di %3.1f `=100*`g1'/`g3''
local g2_p: di %3.1f `=100*`g2'/`g3''

quietly: count if goal==1 & awarded==1 & r_call==1
local ng1 = r(N)
quietly: count if goal==1 & awarded==0 & r_call==2
local ng2 = r(N)
local ng3 = `ng1'+`ng2'
local ng1_p: di %3.1f `=100*`ng1'/`ng3''
local ng2_p: di %3.1f `=100*`ng2'/`ng3''

quietly: count if goal==1 & awarded==1 & r_call==3
local dg1 = r(N)
quietly: count if goal==1 & awarded==0 & r_call==3
local dg2 = r(N)
local dg3 = `dg1'+`dg2'
local dg1_p: di %3.1f `=100*`dg1'/`dg3''
local dg2_p: di %3.1f `=100*`dg2'/`dg3''

quietly: count if goal==0 & awarded==1 & r_call==2
local p1 = r(N)
quietly: count if goal==0 & awarded==0 & r_call==1
local p2 = r(N)
local p3 = `p1'+`p2'
local p1_p: di %3.1f `=100*`p1'/`p3''
local p2_p: di %3.1f `=100*`p2'/`p3''

quietly: count if goal==0 & awarded==1 & r_call==1
local np1 = r(N)
quietly: count if goal==0 & awarded==0 & r_call==2
local np2 = r(N)
local np3 = `np1'+`np2'
local np1_p: di %3.1f `=100*`np1'/`np3''
local np2_p: di %3.1f `=100*`np2'/`np3''

quietly: count if goal==0 & awarded==1 & r_call==3
local dp1 = r(N)
quietly: count if goal==0 & awarded==0 & r_call==3
local dp2 = r(N)
local dp3 = `dp1'+`dp2'
local dp1_p: di %3.1f `=100*`dp1'/`dp3''
local dp2_p: di %3.1f `=100*`dp2'/`dp3''

// ----------------------------------- SAVING ----------------------------------------------
// Saving the results.
// ----------------------------------------------------------------------------------------- 

texdoc init tables/table_1.tex, replace
tex \begin{table}[H]
tex	\caption{Descriptive statistics on decisions}
tex \centering
tex \begin{tabular}{lccc}
tex	\hline\hline
tex & Awarded & Not awarded & Total \\ \hline
tex Goal & `g1' (`g1_p'%) & `g2' (`g2_p'%) & `g3' (100%)\\
tex Penalty & `p1' (`p1_p'%) & `p2' (`p2_p'%) & `p3' (100%)\\
tex No goal & `ng1' (`ng1_p'%) & `ng2' (`ng2_p'%) & `ng3' (100%)\\
tex No penalty & `np1' (`np1_p'%) & `np2' (`np2_p'%) & `np3' (100%)\\
tex Goal (deb.) & `dg1' (`dg1_p'%) & `dg2' (`dg2_p'%) & `dg3' (100%)\\
tex Penalty (deb.) & `dp1' (`dp1_p'%) & `dp2' (`dp2_p'%) & `dp3' (100%)\\
tex \hline\hline
tex \multicolumn{4}{p{0.7\linewidth}}{{\footnotesize \emph{Notes:} The table shows the number (and percentage) of awarded and not awarded penalties that were warranted, not warranted or debatable in the period from 2000-2012 in the Bundesliga.}}
tex	\end{tabular}
tex \end{table}
texdoc close

restore

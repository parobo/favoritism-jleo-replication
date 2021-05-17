// ----------------------------------------------------------------------------------------- 
// Figure 5: Creating figure 5 from the paper
// ----------------------------------------------------------------------------------------- 
version 14
set more off

preserve
set seed 3890 //A random seed was chosen using Excels random number generation
matrix drop _all
graph drop _all

//choose iterations
global maxruns = 100000 //minimum 2000, multiple of 2000

// ----------------------------------- DATA PREPARATION  -----------------------------------
// Creates the necessary variables for the estimation.
// ----------------------------------------------------------------------------------------- 


//get regression coefficients to calculate pr(II error| status)
quietly reghdfe wc i.affected_home i.att_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly margins, at(att_ahead==(0 1)) nose post
local pr_t2e_ahead = e(b)[1,2]
local pr_t2e_behind = e(b)[1,1]

//get regression coefficients to calculate pr(II error| no status)
quietly reghdfe wc i.affected_home i.att_ahead pw_invodds_corrected  c.r_experience r_avg_performance_excl i.goal i.r_prev*favcall* i.g_last10min i.g_closegame r_decisivecall spec_num_scaled i.spec_runningtrack if true_awarded==1, vce(cluster $cluster_var) a(season gameday refid  affected)
quietly margins, at(att_ahead) nose post
local pr_t2e_avg = e(b)[1,1]

//Whats probability of penalty turning into a goal
sort gid minute goal
//say that if goal is in same minute or following as penalty, it is direct cause of it
gen pen_to_goal = .
replace pen_to_goal = 0 if event=="Penalty awarded" & (event[_n+1]!="Goal awarded" ///
	| abs(minute[_n+1]-minute)>1 | gid!=gid[_n+1])
replace pen_to_goal = 1 if event=="Penalty awarded" & event[_n+1]=="Goal awarded" ///
	& abs(minute[_n+1]-minute)<=1 & gid==gid[_n+1]

gen goal_from_pen = 1 if event=="Goal awarded" & pen_to_goal[_n-1]==1

//calculate probability of goal from penalty and save it
quietly su pen_to_goal, meanonly
local pr_ptg = `r(mean)'

//remove goals that stem from penalties
drop if goal_from_pen==1

matrix input p = (`pr_ptg',`pr_t2e_ahead',`pr_t2e_behind',`pr_t2e_avg')

//create the events for home and away goals and penalties
gen h_goal = (goal==1 & affected==home & true_awarded==1)
gen a_goal = (goal==1 & affected==away & true_awarded==1)
gen h_pen = (goal==0 & affected==home & true_awarded==1)
gen a_pen = (goal==0 & affected==away & true_awarded==1)
collapse (sum) h_goal-a_pen, by(gid)
drop gid
//note in 87 games we have no events at all: 0-0 and no pen
set obs 3978
foreach v of varlist h_goal-a_pen{
	replace `v'=0 if missing(`v')
}
//generate frequencies
bys h_goal a_goal h_pen a_pen: egen event_freq = count(h_goal) 
replace event_freq=event_freq/3978
duplicates drop 

gen cumfreq = sum(event_freq)
mkmat h_goal-a_pen cumfreq, matrix(RMatrix)

label def event_label 0 "No event" 1 "Goal (home)" 2 "Goal (away)" 3 "Penalty (home)" 4 "Penalty (away)"


//run simulations
local run = 1
quietly while `run' <= $maxruns{
if mod(`run',2)==1{
	local use_status = 1
}
else if mod(`run',2)==0{
	local use_status = 0
}
clear
set obs 306
gen home = ceil(_n/17)
bys home: gen away = cond(_n +home<=18,_n +home, _n +home-18)
egen gid = group(home away)
gen home_ahead = (home<away)
gen rdn_result = runiform()
gen h_goal = .
gen a_goal = .
gen h_pen = .
gen a_pen = .
foreach i of numlist 1(1)191{
	replace h_goal = RMatrix[192-`i',1] if rdn_result<=RMatrix[192-`i',5]
	replace a_goal = RMatrix[192-`i',2] if rdn_result<=RMatrix[192-`i',5]
	replace h_pen = RMatrix[192-`i',3] if rdn_result<=RMatrix[192-`i',5]
	replace a_pen = RMatrix[192-`i',4] if rdn_result<=RMatrix[192-`i',5]
}

foreach v of varlist h_goal-a_pen{
	expand `v'+1, gen(`v'_new)
	foreach vv of varlist h_goal-a_pen{
		replace `vv' = 0 if `v'_new==1
	}
	replace `v'=1 if `v'_new==1
}

egen events = rowtotal(h_goal-a_pen)
keep if events==0 | (h_goal_new==1|a_goal_new==1|h_pen_new==1|a_pen_new==1)

gen event = 0
replace event = 1 if h_goal == 1
replace event = 2 if a_goal == 1
replace event = 3 if h_pen == 1
replace event = 4 if a_pen == 1
label val event event_label

drop h_goal-a_pen_new events

gen affected = home if inlist(event,1,3)
replace affected = away if inlist(event,2,4) 
gen affected_ahead = home_ahead if affected==home
replace affected_ahead = 1-home_ahead if affected==away

gen rdn_t2e = runiform()
gen rdn_pen = runiform()

if `use_status'==1{
gen t2e = cond(affected_ahead==1,rdn_t2e<=p[1,2],rdn_t2e<=p[1,3])
gen h_goals = 0
replace h_goals = 1 if (event==1 & t2e==0) | (event==3 & t2e==0 & rdn_pen<=p[1,1])
gen a_goals = 0
replace a_goals = 1 if (event==2 & t2e==0) | (event==4 & t2e==0 & rdn_pen<=p[1,1])
}
if `use_status'==0{
gen t2e = (rdn_t2e<=p[1,4])
gen h_goals = 0
replace h_goals = 1 if (event==1 & t2e==0) | (event==3 & t2e==0 & rdn_pen<=p[1,1])
gen a_goals = 0
replace a_goals = 1 if (event==2 & t2e==0) | (event==4 & t2e==0 & rdn_pen<=p[1,1])
}


collapse (sum) h_goals a_goals (first) home away home_ahead, by(gid)

gen pts_home = 0
gen pts_away = 0
replace pts_home = 3 if h_goals > a_goals
replace pts_away = 3 if h_goals < a_goals
replace pts_home = 1 if h_goals == a_goals
replace pts_away = 1 if h_goals == a_goals
expand 2, gen(new_obs)
gen team = home 
replace team = away if new_obs==1

gen goals = h_goals if team==home
replace goals = a_goals if team==away

gen pts = pts_home if team==home
replace pts = pts_away if team==away

collapse (sum) pts goals, by(team)

egen pos = rank(pts), field

gen round = `run'
gen type =  `use_status'

capture confirm matrix res
if _rc==111{
	mkmat round type team pts goals pos, matrix(res)
}
else{
	mkmat round type team pts goals pos, matrix(scores)
	mat res = (res\scores)
}
if mod(`run',2000)==0{
	noisily di "Finished run `run'".
	clear
	svmat res, names(col)
	save "$data/boe_simulated_`run'.dta", replace
	matrix drop res
	matrix drop scores
}
local run = `run'+1
}

svmat res, names(col)


use "data/boe_simulated_2000.dta", clear
foreach file of numlist 4000(2000)$maxruns{
	append using "data/boe_simulated_`file'.dta"
}

quietly foreach t of numlist 1/18{
	foreach v of varlist goals pts pos{
		ttest `v' if team==`t',by(type)
		local pooled_std = sqrt(((r(N_1)-1)*r(sd_1)^2 +(r(N_2)-1)*r(sd_2)^2)/r(df_t))
		local diff = r(mu_2)-r(mu_1)
		local ci_l = `diff'-invt(r(df_t),(1-r(level)/100)/2)*sqrt((`pooled_std'^2/r(N_1))+(`pooled_std' ^2/r(N_2)))
		local ci_r = `diff'+invt(r(df_t),(1-r(level)/100)/2)*sqrt((`pooled_std'^2/r(N_1))+(`pooled_std' ^2/r(N_2)))
		local ci1 = cond(`ci_l'<`ci_r', `ci_l',`ci_r')
		local ci2 = cond(`ci_l'>`ci_r', `ci_l',`ci_r')
	
		capture confirm matrix test_`v'
		if _rc==111{
			matrix input test_`v' = (`t',$maxruns,`diff',`ci1',`ci2')
			}
		else{
			matrix input xtest = (`t',$maxruns,`diff',`ci1',`ci2')
			matrix test_`v' = (test_`v'\xtest)
			}
		}
	}

save "data/boe_simulated.dta", replace

clear
mat colnames test_goals = team simulations goals_diff goals_ci1 goals_ci2
mat colnames test_pos = team2 simulations2 pos_diff pos_ci1 pos_ci2
mat colnames test_pts = team3 simulations3 pts_diff pts_ci1 pts_ci2

svmat test_goals, names(col)
svmat test_pts, names(col)
svmat test_pos, names(col)

drop team2 team3 simulations2 simulations3
replace pos_diff = -pos_diff
replace pos_ci1 = -pos_ci1
replace pos_ci2 = -pos_ci2

// ----------------------------------- PLOTTING --------------------------------------------
// creates the plots
// ----------------------------------------------------------------------------------------- 
graph drop _all

twoway (scatter goals_diff team) (rcap goals_ci1 goals_ci2 team), scheme(plottig) legend(order(1 "Advantage though bias" 2 "95% CI") pos(6) cols(2)) xtitle(Position in ATT) ytitle(Difference in final goals) xscale(reverse) xlabel(1(1)18) ylabel(-.75(0.25).75) yline(0) scale(2)
graph rename boe_goals
graph export figures/boe_goals.png, replace
graph close
twoway (scatter pts_diff team) (rcap pts_ci1 pts_ci2 team), scheme(plottig) legend(order(1 "Advantage though bias" 2 "95% CI") pos(6) cols(2)) xtitle(Position in ATT) ytitle(Difference in final points) xscale(reverse) xlabel(1(1)18) ylabel(-.75(0.25).75) yline(0) scale(2)
graph rename boe_pts
graph export figures/boe_pts.png, replace
graph close
twoway (scatter pos_diff team) (rcap pos_ci1 pos_ci2 team), scheme(plottig) legend(order(1 "Advantage though bias" 2 "95% CI") pos(6) cols(2)) xtitle(Position in ATT) ytitle(Difference in final position) xscale(reverse) xlabel(1(1)18) ylabel(-.5(0.25).5) yline(0) scale(1.5)
graph rename boe_pos
graph export figures/boe_pos.png, replace
graph close

restore

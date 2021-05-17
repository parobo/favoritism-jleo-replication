// ----------------------------------- DATA PREPARATION  -----------------------------------
// This do-file prepares the proprietary data and performs the merge with other replication
// data. Please see the readme for detailed information on the required format of the pro-
// prietary data.
// ----------------------------------------------------------------------------------------- 

version 14
set more off
// ----------------------------------- LOADING DATA  ---------------------------------------
// Loads the proprietary data and combines to dataset.
// ----------------------------------------------------------------------------------------- 
import excel using "$data", firstrow clear sheet("Tor")
keep Jahr Spieltag Datum Heim Gast Ereignis Halbzeit Minute Timecode Team SchützeEigentorschütze Schiedsrichterentscheidung
keep if Jahr >=2000 & Jahr <=2012
rename SchützeEigentorschütze Schütze
save data/tmp_goals.dta, replace

import excel using "$data", firstrow clear sheet("Elfmeter")
keep Jahr Spieltag Datum Heim Gast Ereignis Halbzeit Minute Timecode Team Schütze Schiedsrichterentscheidung
keep if Jahr >=2000 & Jahr <=2012
save data/tmp_penalties.dta, replace

import excel using "$data", firstrow clear sheet("Tor nicht gegeben")
keep Jahr Spieltag Datum Heim Gast Ereignis Halbzeit Minute Timecode Team Schütze Schiedsrichterentscheidung
keep if Jahr >=2000 & Jahr <=2012
save data/tmp_no_goals.dta, replace

import excel using "$data", firstrow clear sheet("Elfmeter nicht gegeben")
keep Jahr Spieltag Datum Heim Gast Ereignis Halbzeit Minute Timecode Team Gefoulter Schiedsrichterentscheidung
rename Gefoulter Schütze
keep if Jahr >=2000 & Jahr <=2012
save data/tmp_no_penalties.dta, replace

use data/tmp_goals.dta, clear
append using data/tmp_penalties.dta
append using data/tmp_no_goals.dta
append using data/tmp_no_penalties.dta

save data/ref.dta, replace
erase data/tmp_goals.dta
erase data/tmp_penalties.dta
erase data/tmp_no_goals.dta
erase data/tmp_no_penalties.dta

// ----------------------------------- PREP DATA  ------------------------------------------
// Prepares the data set for merge with supplementary data from replication archive.
// ----------------------------------------------------------------------------------------- 
gen date = Datum - 21916 //Excel's date 0 is differnt than Stata's date 0.
format date %d
drop Datum

rename Jahr season
rename Spieltag gameday
rename Heim home
rename Gast away
rename Ereignis event
rename Halbzeit halftime
rename Minute minute
rename Timecode timecode
rename Team affected
rename Schütze concerningplayer
rename Schiedsrichterentscheidung call

replace event = "Goal awarded" if event=="Tor"
replace event = "Goal denied" if event=="Tor nicht gegeben"
replace event = "Penalty awarded" if event=="Elfmeter"
replace event = "Penalty denied" if event=="Elfmeter nicht gegeben"
gen r_call = cond(call=="richtig",2,cond(call=="strittig",3,1))
label def lb_corr 1 "wrong" 2 "correct" 3 "debatable"
label val r_call lb_corr
drop call
gen wc = cond(r_call==1,1,0)
replace wc = . if r_call==3
gen goal = (strpos(event,"Goal")>0)
label def lb_goal 0 "penalty" 1 "goal"
label val goal lb_goal
gen awarded = (strpos(event,"awarded")>0)
label def lb_awarded 0 "not awarded" 1 "awarded"
label val awarded lb_awarded
gen affected_home = (affected==home)
gen true_awarded = cond(awarded==1 & wc==0, 1,cond(awarded==0 & wc==1,1,0))
gen true_event = cond(true_awarded==1, cond(goal==1, "Goal (should be given)","Penalty (should be given)"), cond(goal==1,"Goal (should not be given)", "Penalty (should not be given)"))

order season gameday date halftime minute timecode home away event goal awarded concerningplayer r_call 

sort season gameday date halftime minute timecode home away event r_call
gen mid = _n

//merge in non-proprietary data 
merge 1:1 mid using data/ref_prep.dta, nogen assert(3)
drop mid
order id gid, before(season)

//generate previously wrong call
sort id
gen r_prevwc = wc[_n-1] if gid==gid[_n-1]
replace r_prevwc = 0 if missing(r_prevwc)

//generate variable that is on prev. wrongly denied decisions for the same team in the same game. 
gen pr_wrongly_den = (r_call==1 & awarded==0)
replace pr_wrongly_den = 0 if r_call==3
//generate variable that is on prev. wrongly awarded decisions for the same team in the same game. 
gen pr_wrongly_aw = (r_call==1 & awarded==1)
replace pr_wrongly_aw = 0 if r_call==3

sort gid affected minute, stable
gen r_prev_unfavcall = 0
replace r_prev_unfavcall =  r_prev_unfavcall[_n-1]+pr_wrongly_den[_n-1] if gid==gid[_n-1] & affected==affected[_n-1]
replace r_prev_unfavcall = (r_prev_unfavcall>0)

gen r_prev_favcall = 0
replace r_prev_favcall =  r_prev_favcall[_n-1]+pr_wrongly_aw[_n-1] if gid==gid[_n-1] & affected==affected[_n-1]
replace r_prev_favcall = (r_prev_favcall>0)

//generate variable that contains all wrongly avarded/ denied decisions (previous)
sort gid minute, stable
gen r_prev_wr_den = 0
gen r_prev_wr_aw = 0
replace r_prev_wr_den =  r_prev_wr_den[_n-1]+pr_wrongly_den[_n-1] if gid==gid[_n-1]
replace r_prev_wr_aw =  r_prev_wr_aw[_n-1]+pr_wrongly_aw[_n-1] if gid==gid[_n-1]

replace r_prev_wr_den = (r_prev_wr_den>0)
replace r_prev_wr_aw = (r_prev_wr_aw>0)

//generate a variable that contains a dummy for if there were decisions that were (un)favorable for the other team
gen r_prev_unfavcall_opp = r_prev_wr_den-r_prev_unfavcall
gen r_prev_favcall_opp = r_prev_wr_aw-r_prev_favcall

drop pr_wrongly_den pr_wrongly_aw r_prev_wr_den r_prev_wr_aw

gen g_last10min = (minute>80)


// ----------------------------------- LABEL DATA  -----------------------------------------
// Label some variables for convenience.
// ----------------------------------------------------------------------------------------- 
label var season Season
label var date Date
label var gameday Gameday
label var minute "Minute of decision"
label var halftime Halftime
label var timecode "Exact time of decision"
label var home "Home team"
label var away "Away team"
label var event "Event category"
label var goal "Goal"
label var awarded "Awarded"
label var concerningplayer "Player affected by decisison"
label var r_call "Correctness of call"
label var affected "Affected Team"
label var wc "Wrong call"
label var affected_home "Home"
label var true_awarded "Should be awarded"
label var true_event "Correct event"
label var r_prevwc "Previous wrong decision"
label var r_prev_unfavcall "Prev. unfav. wrong call"
label var r_prev_favcall "Prev. fav. wrong call"
label var r_prev_unfavcall_opp "Prev. unfav. wrong call (opponent)" 
label var r_prev_favcall_opp "Prev. fav. wrong call (opponent)"
label var g_last10min "Last 10 minutes"


save data/ref.dta, replace


// ----------------------------------- EXIT DATA  ------------------------------------------
// Prepares the data on wrong decisisons for merge with exit data from replication archive.
// ----------------------------------------------------------------------------------------- 
// --------------------- CREATING SEASON RANK & NO. DEN/AW. MISTAKES ------------------------ 
use data/ref.dta, clear
gen wc_aw_att_ahead = (att_ahead==1 & awarded==1 & true_awarded==0)
gen wc_aw_att_behind = (att_ahead==0 & awarded==1 & true_awarded==0)
gen wc_den_att_ahead = (att_ahead==1 & awarded==0 & true_awarded==1)
gen wc_den_att_behind = (att_ahead==0 & awarded==0 & true_awarded==1)
gen wc_aw_m_ahead = (m_ahead==1 & awarded==1 & true_awarded==0)
gen wc_aw_m_behind = (m_ahead==0 & awarded==1 & true_awarded==0)
gen wc_den_m_ahead = (m_ahead==1 & awarded==0 & true_awarded==1)
gen wc_den_m_behind = (m_ahead==0 & awarded==0 & true_awarded==1)

gen wc_aw_att_ahead_diff = (att_ahead==1 & awarded==1 & true_awarded==0)*att_pos_diff
gen wc_aw_att_behind_diff = (att_ahead==0 & awarded==1 & true_awarded==0)*att_pos_diff
gen wc_den_att_ahead_diff = (att_ahead==1 & awarded==0 & true_awarded==1)*att_pos_diff
gen wc_den_att_behind_diff = (att_ahead==0 & awarded==0 & true_awarded==1)*att_pos_diff
gen wc_aw_m_ahead_diff = (m_ahead==1 & awarded==1 & true_awarded==0)*m_pos_diff
gen wc_aw_m_behind_diff = (m_ahead==0 & awarded==1 & true_awarded==0)*m_pos_diff
gen wc_den_m_ahead_diff = (m_ahead==1 & awarded==0 & true_awarded==1)*m_pos_diff
gen wc_den_m_behind_diff = (m_ahead==0 & awarded==0 & true_awarded==1)*m_pos_diff

gen wc_tot_aw = (awarded==1 & true_awarded==0)
gen wc_tot_den = (awarded==0 & true_awarded==1)


// -------------------------------- PREPARE FOR MERGE  ------------------------------------- 
replace r_referee = trim(subinstr(r_referee, "Dr.","",.))
replace r_referee = "Burkard Hufgard" if r_referee =="Burkhard Hufgard"
replace r_referee = "LutzMichael Fröhlich" if r_referee =="Lutz Michael Fröhlich" //special case
split r_referee, gen(name)
rename name1 fname
rename name2 lname
replace fname = "Lutz Michael" if fname =="LutzMichael"
drop r_referee


// -------------------------------- PREPARE FOR YEARLY MERGE  ------------------------------ 
preserve
collapse (sum) wc_* wc, by(season fname lname)
merge 1:1 season fname lname using data/exit_prep.dta, nogen keep(1 3)

gen pg_tot_den = wc_tot_den/numgames
gen pg_tot_aw = wc_tot_aw/numgames
gen pg_wc_den_att_ahead = wc_den_att_ahead/numgames
gen pg_wc_den_att_behind = wc_den_att_behind/numgames
gen pg_wc_aw_att_ahead = wc_aw_att_ahead/numgames
gen pg_wc_aw_att_behind = wc_aw_att_behind/numgames
gen pg_wc_den_m_ahead = wc_den_m_ahead/numgames
gen pg_wc_den_m_behind = wc_den_m_behind/numgames
gen pg_wc_aw_m_ahead = wc_aw_m_ahead/numgames
gen pg_wc_aw_m_behind = wc_aw_m_behind/numgames
label var pg_tot_den "PG: Type II errors"
label var pg_tot_aw "PG: Type I errors"
label var pg_wc_den_att_ahead "PG: Type II errors (ATT ahead)"
label var pg_wc_den_att_behind "PG: Type II errors (ATT behind)"
label var pg_wc_aw_att_ahead "PG: Type I errors (ATT ahead)"
label var pg_wc_aw_att_behind "PG: Type I errors (ATT behind)"
label var pg_wc_den_m_ahead "PG: Type II errors (members ahead)"
label var pg_wc_den_m_behind "PG: Type II errors (members behind)"
label var pg_wc_aw_m_ahead "PG: Type I errors (members ahead)"
label var pg_wc_aw_m_behind "PG: Type I errors (members behind)"

save data/exit.dta, replace

// -------------------------------- PREPARE FOR WEEKLY MERGE  ------------------------------ 
restore
rename date gamedate
collapse (sum) wc_* wc, by(gamedate fname lname)
merge 1:1 gamedate fname lname using data/pause_prep.dta, nogen keep(1 3)
save data/pause.dta, replace

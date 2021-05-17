# Replication files for "Favoritism Towards High-status Clubs: Evidence from German Soccer" (JLEO, 2022)
This repository contains the replication data and code for the paper "Favoritism Towards High-status Clubs: Evidence from German Soccer" (Bose, Feess and Mueller in Journal of Law, Economics and Organization, 2022).
The paper is largely based on proprietary data aquired in 2014 from the company then called Deltatre (formerly Impire - in 2021 Sportec Solution). Because of the proprietary nature of the data we are unable to share this dataset. Furthermore, given the time that has passed and the restructuring of the company, we cannot guarentee that some of the datasets have been restructured by Sportec Solutions. This means that our code might not run smoothly even after the same dataset has been aquired from Sportec Solution.
In the repository, we nevertheless provide replication code for the paper as good as we can. We furthermore provide any data that is not proprietary and used in the paper.

## Contents
### Folders
* do -- contains all Stata do-files in order to 
* data -- contains all the replication data except the proprietary data

### do-files
* master.do -- master do-file. Used to run the replication. User needs to change file paths in here. The file also creates the folders _tables_ and _figures_.
* do/data_prep.do -- do-file called by _master.do_: uses the proprietary data as well as other data in the data folder to create the final datasets (_data/ref.dta_,_data/exit.dta_,_data/pause.dta_)
* do/table_x.do -- do-file called by _master.do_: used to create the table no. _x_ and places it in TeX format in the folder _tables_
* do/figure_x.do -- do-file called by _master.do_: used to create the figure no. _x_ and places it in PNG format in the folder _figures_

### dta-files
* data/members_interpolation.dta -- Stata data file. Called by _do/figure_a1.do_. Contains data on interpolated members of clubs. The data was collected by hand from multiple sources including differnt Websites and print magazines. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|team|team name|
|season|season|
|members|member data collected from various sources|
|members_ipol| members, interpolated|
|members_is_ipol| dummy for seasons when members where interpolatated|

* data/extratime.dta -- Stata data file. Called by _do/table_9_a16.do_. Contains data on extratime for Bundesliga games. The data was collected from https://www.kicker.de. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|gid|Game ID|
|season|Season|
|gameday|Match day|
|date|Date of match|
|home|Home Team|
|away|Away Team|
|visitors|Attendance of spectators|
|h2_goals_h|Goals before injury time [home, halftime 2]|
|h2_goals_a|Goals before injury time [away, halftime 2]|
|h2_subs|Substitutions [halftime 2]|
|h2_rc|Red cards [halftime 2]|
|h2_yc|Yellow Cards [halftime 2]|
|h2_pen|Penalties [halftime 2]|
|h2_goals|Goals [halftime 2]|
|h2_start|Actual Starting Time [haltime 2]|
|h2_end|Actual End Time [halftime 2]|
|h2_extratime|Injury Time [halftime 2]|
|h2_ahead|Team ahead|
|h2_home_ahead|Home team is ahead|
|h2_att_ahead|Ahead in ATT team in front|
|h2_m_ahead|Ahead in members team in front|
|h2_att_diff|ATT-position difference (team in front)|
|h2_m_diff|Member-position difference (team in front)|
|h2_elo_diff|Elo difference from perspective of team in front|
|h2_elo_pw|Win probability (elo based)|
|h2_invodds_corrected|Win probability (odds based)|
|refid|Referee ID|

* data/ref_prep.dta -- Stata data file. Called by _do/prep_data.do_. Contains data needed to create final data _data/ref.dta_. The data was collected from https://www.kicker.de, an older version of https://www.fussballdaten.de, https://www.transfermarkt.de, and http://clubelo.com/. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|mid|merge id|
|id|observation id|
|gid|game id|
|att_ahead|Ahead in ATT|
|att_pos_home|ATT-position of home team|
|att_pos_away|ATT-position of away team|
|att_pos_diff|ATT-position difference|
|att_dist_ahead|Distance of ref. to team ahead in ATT|
|m_home|Members [home]|
|m_home_pos|Member ranking position [home]|
|m_away|Members [away]|
|m_away_pos|Member ranking position [away]|
|m_ahead|Ahead in Members|
|m_pos_diff|Member-position difference|
|pw_home_corrected|Win probability of home team (based on odds) - corrected for bookmakers profit|
|pw_away_corrected|Win probability of away team (based on odds) - corrected for bookmakers profit|
|pw_invodds_corrected|Win probability (odds based)|
|pw_fav|Favorite to win the game|
|elo_home|Elo rating [home]|
|elo_away|Elo rating [away]|
|elo_affected_pw|Win probability (elo based)|
|refid|Referee id|
|r_referee|Referee name|
|r_experience|Referee experience|
|r_decisivecall|Decisive call|
|r_birthday|Referee birthday|
|r_age|Referee age|
|r_agelimit|Referee is at agelimit|
|r_birthplace|Referee birthplace|
|r_nationality|Referee nationality|
|r_confederation|Referee confederation|
|r_team|Referee team|
|r_first_season|Referee first season in BL|
|r_last_season|Referee last season in BL|
|r_job|Referee (other) job|
|r_bltenure|Referee tenure in BL|
|r_tenure|Referee tenure|
|r_avg_performance_excl|Ref. avg. performance (season)|
|r_att_home_1t10y|Rolling ATT [home] by referee age [1,10]|
|r_att_away_1t10y|Rolling ATT [away] by referee age [1,10]|
|r_att_home_11t20y|Rolling ATT [home] by referee age [11,20]|
|r_att_away_11t20y|Rolling ATT [away] by referee age [11,20]|
|r_att_home_21t30y|Rolling ATT [home] by referee age [21,30]|
|r_att_away_21t30y|Rolling ATT [away] by referee age [21,30]|
|spec_num|Number of spectators|
|spec_capacity|Stadium capacity|
|spec_runningtrack|Stadium with running track|
|spec_num_scaled|Spectators (scaled)|
|d_home_away|Distance [home, away]|
|d_home_ref|Distance [home, ref]|
|d_away_ref|Distance [away, ref]|
|pos_home_before|Position home team before game|
|pos_away_before|Position away team before game|
|pos_affected_lseas|Last season position|
|pos_unaffected_lseas|Last season position (opponent)|
|pos_affected_before|Current season position|
|pos_unaffected_before|Current season position (opponent)|
|pts_diff|Pts difference (before game)|
|int_qual_lseas|Internationally qualified last season|
|int_qual_cseas|Internationally qualified current season|
|tv_rank_home|TV income ranking [home]|
|tv_rank_away|TV income ranking [away]|
|g_closegame|Close game|
|g_affected_shotsatgoal|Shots on goal|
|g_unaffected_shotsatgoal|Shots on goal (opponent)|
|g_affected_fouls|Fouls|
|g_unaffected_fouls|Fouls (opponent)|
|g_affected_ballcontacts|Ballcontacts|
|g_unaffected_ballcontacts|Ballcontacts (opponent)|
|g_affected_possession|Ball possession|
|g_unaffected_possession|Ball possession (opponent)|
|pl_team|Team of concerning player|
|pl_value|TM value of concerning player|
|pl_nation1|Nationality of concerning player|
|pl_nation2|Nationality 2 of concerning player|
|pl_birthday|Birthday of concerning player|
|pl_age|Age of concerning player|
|pl_wc_affected|Worldcup player|
|t_offscore_diff|Off. score difference|
|t_value_diff|Transfervalue difference|
|t_formation_affected|Formation [affected]|
|t_formation_unaffected|Formation [unaffected]|
|t_off_diff|Off. player difference|

* data/exit_prep.dta -- Stata data file. Called by _do/prep_data.do_. Contains data needed to create final data _data/exit.dta_. The data was collected from https://www.kicker.de. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|season|Season|
|refid|Referee ID|
|agelimit|Referee is at agelimit|
|fname|First name|
|lname|Last name|
|numgames|Number of games (season)|
|age|Age|
|first_season|First BL season|
|performance|Referee avg. performance (season)|
|exit|Exit after season|
|international|International Referee|
|dfb|DFB Cup Referee|

* data/pause_prep.dta -- Stata data file. Called by _do/prep_data.do_. Contains data needed to create final data _data/pause.dta_. The data was collected from https://www.kicker.de. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|fname|First name|
|lname|Last name|
|age|Age|
|bltenure|Tenure (BL)|
|performance|Performance (scaled)|
|gamedate|Game date|
|refid|Referee ID|
|international|International Referee|
|dfb|DFB Cup Referee|
|pause|Pause before next game|
|avgpause|Expected pause|


## Requirements
All code was run on Mac OS 10.15.7 with Stata/MP 16.1. The following packages need to be installed. For Stata packeges, the code will try to install them if there are not aleady installed, however this might not always work as intended. Therefore it is advised to install them by hand before starting the replication code.

|Package|How?|
|-------|----|
|`ftools`|`ssc install ftools`|
|`reghdfe`|`ssc install reghdfe`, then `reghdfe, compile`|
|`blindschemes`|`ssc install blindschemes`|
|`texdoc`|`ssc install texdoc`|
|`mrobust`|`ssc install mrobust`|
|`firthlogit`|`ssc install firthlogit`|


## Proprietary data
The data was acquired in 2014 and spans the years 2000 until mid 2013. It can be aquired from Sportec Solutions (https://www.sportec-solutions.de/) asking for data on "Qualität der Schiedsrichterentscheidungen". The provided data should contain information on all recorded referee decisions regarding penalties (given or not given) and goals (awarded and not awarded) for the German "Bundesliga". In 2014, we received the data in Excel format, however the data provider might have changed this in the meantime. To ensure that the code we provide does run with the purchased data, please make sure that the data is saved as an excel file and fulfills the following criteria:

* Excel file should contain sheets "Tor", "Elfmeter", "Tor nicht gegeben", "Elfmeter nicht gegeben"
* The sheets should contain at a minimum the following columns, in case columns are named differently, please make sure to correct this before running the replication code

### For sheet "Tor":
|Column Name|Column Content|
|-----------|--------------|
|Jahr|Season of game|
|Spieltag|Match day|
|Datum|Date of game|
|Heim|Home team|
|Gast|Away team|
|Ereignis|Event (Goal)|
|Halbzeit|Halftime|
|Minute|Minute in game|
|Timecode|Exact time of event|
|Team|Team affected|
|SchützeEigentorschütze|Concerning player|
|Schiedsrichterentscheidung|Correctness of referee decision|

### For sheet "Elfmeter" and "Tor nicht gegeben":
|Column Name|Column Content|
|-----------|--------------|
|Jahr|Season of game|
|Spieltag|Match day|
|Datum|Date of game|
|Heim|Home team|
|Gast|Away team|
|Ereignis|Event (Penalty)|
|Halbzeit|Halftime|
|Minute|Minute in game|
|Timecode|Exact time of event|
|Team|Team affected|
|Schütze|Concerning player|
|Schiedsrichterentscheidung|Correctness of referee decision|

### For sheet "Elfmeter nicht gegeben":
|Column Name|Column Content|
|-----------|--------------|
|Jahr|Season of game|
|Spieltag|Match day|
|Datum|Date of game|
|Heim|Home team|
|Gast|Away team|
|Ereignis|Event (Penalty)|
|Halbzeit|Halftime|
|Minute|Minute in game|
|Timecode|Exact time of event|
|Team|Team affected|
|Gefoulter|Concerning player|
|Schiedsrichterentscheidung|Correctness of referee decision|


## How to run the replication
To run the replication, adjust the file _master.do_. Here please update the global macros `path` and `data`. These should contain the filepath to the directory with the _master.do_ file and the filepath to the aquired data (from Sportec Solution, see detailed description above).
Once you have adjusted the path, simply run the do file _master.do_. It will call all other do files and you should end up with all tables in TeX format in the folder _tables_ and with all figures from the paper in the folder _figures_.
The creation of some talbes and figures takes a very long time (24+ hours), they are by default not executed. You can change this in the _master.do_ by setting the appropriate global macro to "True".

## Some final notes
Some figures and tables include tests that have been edited in by hand. In this case. The tests will be run by the replication files and saved in the folder _logs_ and a file named after the figure or table. E.g. _figure_2_tests.smcl_.
Some figures in the paper consist of multiple graphs, in this case, each graph is saved under the _figure_x_y.png_, where _x_ is the figure number and _y_ increases for each graph (e.g. _figure_4_1.png_ and _figure_4_2.png_).

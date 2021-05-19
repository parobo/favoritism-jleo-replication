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
* do/data\_prep.do -- do-file called by _master.do_: uses the proprietary data as well as other data in the data folder to create the final datasets (_data/ref.dta_,_data/exit.dta_,_data/pause.dta_)
* do/table\_x.do -- do-file called by _master.do_: used to create the table no. _x_ and places it in TeX format in the folder _tables_
* do/figure\_x.do -- do-file called by _master.do_: used to create the figure no. _x_ and places it in PNG format in the folder _figures_

### dta-files
* data/members\_interpolation.dta -- Stata data file. Called by _do/figure\_a1.do_. Contains data on interpolated members of clubs. The data was collected by hand from multiple sources including differnt Websites and print magazines. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|team|team name|
|season|season|
|members|member data collected from various sources|
|members\_ipol| members, interpolated|
|members\_is\_ipol| dummy for seasons when members where interpolatated|

* data/extratime.dta -- Stata data file. Called by _do/table\_9\_a16.do_. Contains data on extratime for Bundesliga games. The data was collected from https://www.kicker.de. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|gid|Game ID|
|season|Season|
|gameday|Match day|
|date|Date of match|
|home|Home Team|
|away|Away Team|
|visitors|Attendance of spectators|
|h2\_goals\_h|Goals before injury time [home, halftime 2]|
|h2\_goals\_a|Goals before injury time [away, halftime 2]|
|h2\_subs|Substitutions [halftime 2]|
|h2\_rc|Red cards [halftime 2]|
|h2\_yc|Yellow Cards [halftime 2]|
|h2\_pen|Penalties [halftime 2]|
|h2\_goals|Goals [halftime 2]|
|h2\_start|Actual Starting Time [haltime 2]|
|h2\_end|Actual End Time [halftime 2]|
|h2\_extratime|Injury Time [halftime 2]|
|h2\_ahead|Team ahead|
|h2\_home\_ahead|Home team is ahead|
|h2\_att\_ahead|Ahead in ATT team in front|
|h2\_m\_ahead|Ahead in members team in front|
|h2\_att\_diff|ATT-position difference (team in front)|
|h2\_m\_diff|Member-position difference (team in front)|
|h2\_elo\_diff|Elo difference from perspective of team in front|
|h2\_elo\_pw|Win probability (elo based)|
|h2\_invodds_corrected|Win probability (odds based)|
|refid|Referee ID|

* data/ref\_prep.dta -- Stata data file. Called by _do/prep\_data.do_. Contains data needed to create final data _data/ref.dta_. The data was collected from https://www.kicker.de, an older version of https://www.fussballdaten.de, https://www.transfermarkt.de, and http://clubelo.com/. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|mid|merge id|
|id|observation id|
|gid|game id|
|att\_ahead|Ahead in ATT|
|att\_pos\_home|ATT-position of home team|
|att\_pos\_away|ATT-position of away team|
|att\_pos\_diff|ATT-position difference|
|att\_dist_ahead|Distance of ref. to team ahead in ATT|
|m\_home|Members [home]|
|m\_home\_pos|Member ranking position [home]|
|m\_away|Members [away]|
|m\_away\_pos|Member ranking position [away]|
|m\_ahead|Ahead in Members|
|m\_pos\_diff|Member-position difference|
|pw\_home\_corrected|Win probability of home team (based on odds) - corrected for bookmakers profit|
|pw\_away\_corrected|Win probability of away team (based on odds) - corrected for bookmakers profit|
|pw\_invodds\_corrected|Win probability (odds based)|
|pw\_fav|Favorite to win the game|
|elo\_home|Elo rating [home]|
|elo\_away|Elo rating [away]|
|elo\_affected\_pw|Win probability (elo based)|
|refid|Referee id|
|r\_referee|Referee name|
|r\_experience|Referee experience|
|r\_decisivecall|Decisive call|
|r\_birthday|Referee birthday|
|r\_age|Referee age|
|r\_agelimit|Referee is at agelimit|
|r\_birthplace|Referee birthplace|
|r\_nationality|Referee nationality|
|r\_confederation|Referee confederation|
|r\_team|Referee team|
|r\_first\_season|Referee first season in BL|
|r\_last\_season|Referee last season in BL|
|r\_job|Referee (other) job|
|r\_bltenure|Referee tenure in BL|
|r\_tenure|Referee tenure|
|r\_avg\_performance\_excl|Ref. avg. performance (season)|
|r\_att\_home\_1t10y|Rolling ATT [home] by referee age [1,10]|
|r\_att\_away\_1t10y|Rolling ATT [away] by referee age [1,10]|
|r\_att\_home\_11t20y|Rolling ATT [home] by referee age [11,20]|
|r\_att\_away\_11t20y|Rolling ATT [away] by referee age [11,20]|
|r\_att\_home\_21t30y|Rolling ATT [home] by referee age [21,30]|
|r\_att\_away\_21t30y|Rolling ATT [away] by referee age [21,30]|
|spec\_num|Number of spectators|
|spec\_capacity|Stadium capacity|
|spec\_runningtrack|Stadium with running track|
|spec\_num\_scaled|Spectators (scaled)|
|d\_home\_away|Distance [home, away]|
|d\_home\_ref|Distance [home, ref]|
|d\_away\_ref|Distance [away, ref]|
|pos\_home\_before|Position home team before game|
|pos\_away\_before|Position away team before game|
|pos\_affected\_lseas|Last season position|
|pos\_unaffected\_lseas|Last season position (opponent)|
|pos\_affected\_before|Current season position|
|pos\_unaffected\_before|Current season position (opponent)|
|pts\_diff|Pts difference (before game)|
|int\_qual\_lseas|Internationally qualified last season|
|int\_qual\_cseas|Internationally qualified current season|
|tv\_rank\_home|TV income ranking [home]|
|tv\_rank\_away|TV income ranking [away]|
|g\_closegame|Close game|
|g\_affected\_shotsatgoal|Shots on goal|
|g\_unaffected\_shotsatgoal|Shots on goal (opponent)|
|g\_affected\_fouls|Fouls|
|g\_unaffected\_fouls|Fouls (opponent)|
|g\_affected\_ballcontacts|Ballcontacts|
|g\_unaffected\_ballcontacts|Ballcontacts (opponent)|
|g\_affected\_possession|Ball possession|
|g\_unaffected\_possession|Ball possession (opponent)|
|pl\_team|Team of concerning player|
|pl\_value|TM value of concerning player|
|pl\_nation1|Nationality of concerning player|
|pl\_nation2|Nationality 2 of concerning player|
|pl\_birthday|Birthday of concerning player|
|pl\_age|Age of concerning player|
|pl\_wc\_affected|Worldcup player|
|t\_offscore\_diff|Off. score difference|
|t\_value\_diff|Transfervalue difference|
|t\_formation\_affected|Formation [affected]|
|t\_formation\_unaffected|Formation [unaffected]|
|t\_off\_diff|Off. player difference|

* data/exit\_prep.dta -- Stata data file. Called by _do/prep\_data.do_. Contains data needed to create final data _data/exit.dta_. The data was collected from https://www.kicker.de. For detailed information about the collection process, please contact the authors directly.

|Variable|Description|
|--------|-----------|
|season|Season|
|refid|Referee ID|
|agelimit|Referee is at agelimit|
|fname|First name|
|lname|Last name|
|numgames|Number of games (season)|
|age|Age|
|first\_season|First BL season|
|performance|Referee avg. performance (season)|
|exit|Exit after season|
|international|International Referee|
|dfb|DFB Cup Referee|

* data/pause\_prep.dta -- Stata data file. Called by _do/prep\_data.do_. Contains data needed to create final data _data/pause.dta_. The data was collected from https://www.kicker.de. For detailed information about the collection process, please contact the authors directly.

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
All code was run on Mac OS 10.15.7 with Stata/MP 16.1. The following packages need to be installed. For Stata packages, the code will try to install them if there are not aleady installed, however this might not always work as intended. Therefore it is advised to install them by hand before starting the replication code.

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
Some figures and tables include tests that have been edited in by hand. In this case. The tests will be run by the replication files and saved in the folder _logs_ and a file named after the figure or table. E.g. _figure\_2\_tests.smcl_.
Some figures in the paper consist of multiple graphs, in this case, each graph is saved under the _figure\_x\_y.png_, where _x_ is the figure number and _y_ increases for each graph (e.g. _figure\_4\_1.png_ and _figure\_4\_2.png_).

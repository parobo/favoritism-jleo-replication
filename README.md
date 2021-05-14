# Replication files for "Favoritism Towards High-status Clubs: Evidence from German Soccer" (JLEO, 2022)
This repository contains the replication data and code for the paper "Favoritism Towards High-status Clubs: Evidence from German Soccer" (Bose, Feess and Mueller in Journal of Law, Economics and Organization, 2022).
The paper is largely based on proprietary data aquired in 2014 from the company then called Deltatre (formerly Impire - in 2021 Sportec Solution). Because of the proprietary nature of the data we are unable to share this dataset. Furthermore, given the time that has passed and the restructuring of the company, we cannot guarentee that some of the datasets have been restructured by Sportec Solutions. This means that our code might not run smoothly even after the same dataset has been aquired from Sportec Solution.
In the repository, we nevertheless provide replication code for the paper as good as we can. We furthermore provide any data that is not proprietary and used in the paper.

##Requirements
All code was run on Mac OS 10.15.7 with Stata 14 MP as well as with python 3.6. The following packages need to be installed. For Stata packeges, the code will try to install them if there are not aleady installed, however this might not always work as intended.

|Program|Package|How?|
|-------|-------|----|
|Stata|`reghdfe`|`ssc install reghdfe`|
|-------|-------|----|


##Proprietary data
The data was acquired in 2014 from and spans the years 1992 until mid 2014. It can be aquired from Sportec Solutions (https://www.sportec-solutions.de/). The provided data should contain information on all recorded referee decisions regarding penalties (given or not given), goals (awarded and not awarded) as well as on not given red cards for the German "Bundesliga". In 2014, we received the data in Excel format, however the data provider might have changed this in the meantime. To ensure that the code we provide does run with the purchased data, please make sure that the data is saved as an excel file and contains at a **minimum** the following columns:

|Column Name|Column Content|Possible values|
|-----------|--------------|---------------|
|Year|Year of game| 1992-2013|
|Gameday|Mach day of game|1-34|
|Date|Date of game|15.08.1992-10.05.2014|
|Home|Home team|any team from list below|
|Away|Away team|any team from list below|
|Event|Decision type|"Elfmeter", "Elfmeter nicht gegeben", "Platzverweis nicht gegeben", "Tor", "Tor nicht gegeben"|
|Minute|Gameminute of event|1-96|
|Timecode|Time of event|e.g. "HH:MM:SS.ss"|
|Team|Team affected by event|any team from list below|
|Call|Correctness of call|"richtig","strittig","falsch"|
|ConcerningPlayer|Playername||
|PositionHomebeforeGameday|Standing home before gameday|0-18|
|PositionHomeafterGameday|Standing home after gameday|1-18|
|PositionAwaybeforeGameday|Standing away before gameday|0-18|
|PositionAwayafterGameday|Standing away after gameday|1-18|
|InternationalQualificationPres|Team qualified for international cups previous season|0,1|
|InternationalQualificationCurr|Team qualified for international cups current season|0,1|
|PositionPreseasonHome|Standing home last season|1-18|
|PositionPreseasonAway|Standing away last season|1-18|
|Spectators|Number of spectators|4000-83000|
|Capacity|Stadium capacity|10300-83000|
|Racetrack|Stadium has a racetrack|0,1|
|Referee|Name of referee||
|ShotsatGoalHome|Shots at goal (home)|3-41|
|ShotsatGoalAway|Shots at goal (away)|1-36|
|FoulsHome|Fouls (home)|2-39|
|FoulsAway|Fouls (away)|3-39|
|BallContactsHome|Ballcontacts (home)|0-864|
|BallContactsAway|Ballcontacts (away)|0-873|
|PossessionHome|Ballpossession (home)|0-69.9|
|PossessionAway|Ballpossession (away)|67.98|
|-----------|--------------|---------------|

###Teams included:
"1860 München", "Aachen","Augsburg", "Bielefeld", "Bochum", "Braunschweig", "Bremen", "Cottbus", "Dortmund", "Dresden", "Duisburg", "Düsseldorf", "FC Bayern", "Frankfurt", "Freiburg", "Greuther Fürth", "Hamburg", "Hannover", "Hertha BSC", "Hoffenheim", "K'lautern", "KFC Uerdingen 05", "Karlsruhe", "Köln", "Leverkusen", "M'gladbach", "Mainz", "Nürnberg", "Rostock", "SSV Ulm", "Saarbrücken", "Schalke 04", "St. Pauli", "Stuttgart", "Unterhaching", "VfB Leipzig", "Wattenscheid 09", "Wolfsburg"


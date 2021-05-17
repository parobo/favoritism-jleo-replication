//--------------------------------------------------------------------------------------------------//
// --------------- Favoritism Towards High-status Clubs: Evidence from German Soccer ---------------//
// --------------------------------------- Master Replication --------------------------------------//
//--------------------------------------------------------------------------------------------------//
// Settings:
// Please adjust these settings to fit your computer and folder set-up.
// It is recomended that you do not change the structure of the replication code
// and data after the lines below. 

global path = "/path/to/replication/directory" //insert the path to the directory with the replication data and code
global data = "/path/to/proprietary/data.xlsx" //insert the path to the sportec data that you aquired (please see readme for the format requirements)

global install_packages = "False" //// "True" or "False", choose "False" if you have already installed all required packages, note that an internet connection is required for option "True"

global create_fig5 = "False" // "True" or "False", note that figure 5 takes a very long time to create due to the underlying simulations (100.000)
global create_figa4 = "False" // "True" or "False", note that figure A4 takes a very long time to create due to the many regressions (~100.000) needed
global create_taba9 = "False" // "True" or "False", note that table A9 takes a very long time to create due to penalized logit method used to account for potentially rare events
//--------------------------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------------------------//
set more off
version 14
//Change path and check for completeness of replication files
cd "$path"

noisily di "Checking completeness of replication archive..." 
//files that need to be included
foreach fn in "1" "2" "3" "4_a7" "5" "a1" "a2_a3" "a4" "a5" "a6"{
	capture: confirm file do/figure_`fn'.do
	if _rc !=0{
		di as err "The do-file 'figure_`fn'.do' is missing. Please make sure that you correctly downloaded the full replication archive."
		exit 601
	}
}
foreach fn in "1" "3" "4" "5" "6" "7" "8" "9_a16" "a1" "a2" "a3" "a4" "a5" "a6" "a7" "a8" "a9" "a10" "a11" "a12" "a13" "a14" "a15"{
	capture: confirm file do/table_`fn'.do
	if _rc !=0{
		di as err "The do-file 'table_`fn'.do' is missing. Please make sure that you correctly downloaded the full replication archive."
		exit 601
	}
}

capture confirm file do/data_prep.do
if _rc !=0{
		di as err "The do-file 'data_prep.do' is missing. Please make sure that you correctly downloaded the full replication archive."
		exit 601
	}

foreach dta in "extratime" "members_interpolation" "pause_prep" "exit_prep" "ref_prep"{
	capture confirm file data/`dta'.dta
	if _rc !=0{
		di as err "The data-file '`dta'.dta' is missing. Please make sure that you correctly downloaded the full replication archive."
		exit 601
	}
}

noisily di "Archive complete."

//make the directories for figures and tables
noisily di "Creating directories for tables and figures."
capture mkdir tables
capture mkdir figures
capture mkdir logs

if "$install_packages" =="True"{
//install necessary stata commands
noisily di "Checking Stata packages and installing missing..."
capture ssc install ftools
capture ssc install reghdfe
if _rc!=602{
	reghdfe, compile
}
capture ssc install blindschemes
capture ssc install texdoc
capture ssc install mrobust
capture ssc install firthlogit
noisily di "Checking/installions complete."
}
//--------------------------------------------------------------------------------------------------//
//data prep
noisily di "Preparing datasets for later use..."
run do/data_prep.do
noisily di "Done."

//start running the do-files
global cluster_var = "gid"
//open main dataset
use data/ref.dta, clear
//create the figures
noisily di "Creating figures..."

run do/figure_1.do
do do/figure_2.do
do do/figure_3.do
run do/figure_4_a7.do
if "$create_fig5" =="True"{
	noisily di "Creating figure 5. This may take around 24-48 hours."
	run do/figure_5.do
}
run do/figure_a1.do
run do/figure_a2_a3.do
if "$create_figa4" =="True"{
	noisily di "Creating figure A4. This may take around 24-48 hours."
	run do/figure_a4.do
}
run do/figure_a5.do
run do/figure_a6.do
noisily di "Done."

//create the tables
noisily di "Creating tables..."
texdoc do do/table_1.do
run do/table_3.do
run do/table_4.do
run do/table_5.do
run do/table_6.do
texdoc do do/table_7.do
texdoc do do/table_8.do
run do/table_9_a16.do
texdoc do do/table_a1.do
run do/table_a2.do
texdoc do do/table_a3.do
texdoc do do/table_a4.do
texdoc do do/table_a5.do
texdoc do do/table_a6.do
texdoc do do/table_a7.do
texdoc do do/table_a8.do
if "$create_taba9" =="True"{
	noisily di "Creating table A9. This may take around 24-48 hours."
	texdoc do do/table_a9.do
}
run do/table_a10.do
run do/table_a11.do
texdoc do do/table_a12.do
texdoc do do/table_a13.do
texdoc do do/table_a14.do
texdoc do do/table_a15.do
noisily di "Done."
noisily di "All figures and tables from the paper have been created and placed in the folders figures and tables in. your working directory (with the exception of figures 5 and A4 as well as table A9, unless otherwise specified.)."

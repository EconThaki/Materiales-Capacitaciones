/********************************************************************************
********************************************************************************
	Project: XXXXXX
	
	Name:				[00. Name do file]
	Authors:            XXXX (email) 
	Do file Author:     XXX (email)        
	Date:               XXXX
	Last modified:      XXXX
	Description: 		RESUME OF THE DO FILE 
	Important:			THINGS THAT SHOULD BE TAKEN INTO ACCOUNT WHILE READING THE DOFILE

********************************************************************************
********************************************************************************/

* A. Setting up
clear all 
set scheme plotplain  /// so all your graphs look the same way 

* A.0. Set up folder Structure, globals and outputs
di "current user: `c(username)'"

if "`c(username)'" == "[name of the computer]"{
	global path "[path]"
}

if "`c(username)'" == "[name of the computer]"{
	global path "[path]"
}

	global rawdata   "$path/Data"
	global tables    "$path/Tables"
	global graphs    "$path/Graphs"
	global do_files  "$path/Do Files"
	global usedata   "$path/Use Data"
	
program main
	data
	tables
	graphs
end

program data
*Always comment and write titles of the sections (for example: Cleaning XXX data)
	*Use indent (tab) so your code looks clean
		*for the loops, indent
end

program tables
end

program graphs

*Figure 3:  Daily Number of Hours Above WHO Thresholds and Worked Day and Daily Hours Worked

	use "$rawdata/lmkt_withp_daily_clean.dta", clear
	
	*Panel A: Worked Day
			
		reghdfe worked_day hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef1
		reghdfe worked_day hr_IT2_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef2
		reghdfe worked_day hr_IT3_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r)
		estimates store coef3
		reghdfe worked_day hr_AQG_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef4
		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) (coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), levels(90) ytitle("Effect on Day Worked", axis(1)) vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) order(AQG IT3 IT2 IT1) xtitle("PM 2.5 Pollution Threshold") scheme(plotplain)	
		graph export "$graphs/figure_3a_thresholds_worked_day.png", replace
		estimates clear

	*Panel B: Daily Hours Worked
	
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef1
		reghdfe hours_worked_daily hr_IT2_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef2
		reghdfe hours_worked_daily hr_IT3_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r)
		estimates store coef3
		reghdfe hours_worked_daily hr_AQG_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef4
		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) (coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), levels(90)	ytitle("Effect on Daily Hours Worked", axis(1)) vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) order(AQG IT3 IT2 IT1) xtitle("PM 2.5 Pollution Threshold") scheme(plotplain)
		graph export "$graphs/figure_3b_thresholds_hours_worked_daily.png", replace
		estimates clear
		
*Figure B2: Impact of Same Day and Lagged PM 2.5 on Probability of Working

	use "$usedata/lmkt_withp_daily_lagsforwards_replication.dta", clear

	*Panel A: Full Sample
	
		reghdfe worked_day hr_IT1_PM25 max_TMP lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25 c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc , abs(week_trim_year i.state#i.municipality) vce(r) 

		estimates store coef1
		lincom lag1_hr_IT1_PM25 + lag2_hr_IT1_PM25 + lag3_hr_IT1_PM25 + lag4_hr_IT1_PM25 + lag5_hr_IT1_PM25
		coefplot (coef1, keep(hr_IT1_PM25 lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25) ///
		msymbol(plus) mcolor(black) msize(medsmall)), vert omitted nokey nooffsets  ytitle("`vert_axis'", axis(1)) xtitle("Lags of IT1 PM25")  yline(0) levels(90)
		graph export "$graphs/figure_b2_a_lags_worked.png", replace
		estimates clear
		
	*Panel B: By Formality Status
	
		reghdfe worked_day hr_IT1_PM25 max_TMP lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25 c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if informal==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef1
		lincom lag1_hr_IT1_PM25 + lag2_hr_IT1_PM25 + lag3_hr_IT1_PM25 + lag4_hr_IT1_PM25 + lag5_hr_IT1_PM25

		reghdfe worked_day hr_IT1_PM25 max_TMP lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25 c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if informal==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef2
		lincom lag1_hr_IT1_PM25 + lag2_hr_IT1_PM25 + lag3_hr_IT1_PM25 + lag4_hr_IT1_PM25 + lag5_hr_IT1_PM25

		coefplot (coef1 , keep(hr_IT1_PM25 lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall)) (coef2 , keep(hr_IT1_PM25 lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25)   ///
			msymbol(smx) mcolor(black) msize(med)		), vert omitted nokey nooffsets  ytitle("`vert_axis'", axis(1)) xtitle("Lags of IT1 PM25")  yline(0) levels(90)  legend(order(2 "Formal Workers" 4 "Informal Workers") on) 
		graph export "$graphs/figure_b2_b_lags_day_informal.png", replace
		estimates clear
		
*Figure 4: Impact of Same Day and Lagged PM 2.5 on Daily Hours Worked

	*Panel A: Full Sample
	
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25 c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc , abs(week_trim_year i.state#i.municipality) vce(r) 

		estimates store coef1
		lincom lag1_hr_IT1_PM25 + lag2_hr_IT1_PM25 + lag3_hr_IT1_PM25 + lag4_hr_IT1_PM25 + lag5_hr_IT1_PM25
		coefplot (coef1, keep(hr_IT1_PM25 lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25) ///
					msymbol(plus) mcolor(black) msize(medsmall)), vert omitted nokey nooffsets  ytitle("`vert_axis'", axis(1)) xtitle("Lags of IT1 PM25")  yline(0) levels(90) scheme(plotplain)
		graph export "$graphs/figure_4a_lags_hours.png", replace
		estimates clear
	
	*Panel B: By Formality Status
	
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25 c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if informal==0, abs(week_trim_year i.state#i.municipality) vce(r) 
estimates store coef1
lincom lag1_hr_IT1_PM25 + lag2_hr_IT1_PM25 + lag3_hr_IT1_PM25 + lag4_hr_IT1_PM25 + lag5_hr_IT1_PM25

		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25 c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if informal==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef2
		lincom lag1_hr_IT1_PM25 + lag2_hr_IT1_PM25 + lag3_hr_IT1_PM25 + lag4_hr_IT1_PM25 + lag5_hr_IT1_PM25

		coefplot (coef1 , keep(hr_IT1_PM25 lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall)) (coef2 , keep(hr_IT1_PM25 lag1_hr_IT1_PM25 lag2_hr_IT1_PM25 lag3_hr_IT1_PM25 lag4_hr_IT1_PM25 lag5_hr_IT1_PM25)   ///
			msymbol(smx) mcolor(red) msize(med)		), vert omitted nokey nooffsets  ytitle("`vert_axis'", axis(1)) xtitle("Lags of IT1 PM25")  yline(0) levels(90)  legend(order(2 "Formal Workers" 4 "Informal Workers") on) scheme(plotplain) legend(ring(0) position (5))
		graph export "$graphs/figure_4b_lags_informal.png", replace
		estimates clear	
		
*Figure 5: Impact of Same Day PM 2.5 on Daily Hours Worked by Prior Days' PM 2.5

		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef1
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef4

		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (coef2, keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(coef3, keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (coef4,  keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")), ///
				levels(90)	ytitle("Effect on Daily Hours Worked", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) ///
					xtitle("Sample Restiction") scheme(plotplain) 
					
		graph export "$graphs/figure_5_consecutive.png", replace		
		estimates clear
		
*Figure 6: Impact of Same Day PM 2.5 on Daily Hours Worked by Prior Days' PM 2.5: By Formality Status and By Income

	*Panel A: By Formality Status

		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==0 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store Formal 
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==0 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==0 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==0 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef4

		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==1 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store Informal
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==1 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==1 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & informal==1 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef4

		coefplot (Formal, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (fcoef2, nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(fcoef3, nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (fcoef4, nokey  keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")) ///
					(Informal, keep(hr_IT1_PM25)  msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (icoef2, nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(icoef3, nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (icoef4, nokey  keep(hr_IT1_PM25) msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")), ///
				levels(90)	ytitle("Effect on Daily Hours Worked", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted  nooffsets pstyle(p1 p1 p1 p1) ///
					xtitle("Sample Restiction") scheme(plotplain) legend(ring(0) position (5))						
		graph export "$graphs/figure_6a_consecutive_inf_for.png", replace		
		estimates clear
		
	*Panel B: By Income
	
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==0 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store High 
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==0 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==0 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==0 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef4

		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==1 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store Low
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==1 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==1 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & ing_less2mw==1 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef4

		coefplot (High, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (fcoef2, nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(fcoef3, nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (fcoef4, nokey  keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")) ///
					(Low, keep(hr_IT1_PM25)  msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (icoef2, nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(icoef3, nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (icoef4, nokey  keep(hr_IT1_PM25) msymbol(smx) mcolor(red) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")), ///
				levels(90)	ytitle("Effect on Daily Hours Worked", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted  nooffsets pstyle(p1 p1 p1 p1) ///
					xtitle("Sample Restiction") scheme(plotplain) legend(ring(0) position (5))
		graph export "$graphs/figure_6b_consecutive_inc.png", replace		
		estimates clear
		
*Figure B3: Impact of Same Day PM 2.5 on Daily Hours Worked by Prior Days' PM 2.5: By Wage Status
	
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==1 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store Wage
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==1 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==1 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==1 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store fcoef4

		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==0 & highPM_lag1==0 & highPM_lag2==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store Nonwage
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==0 & highPM_lag1==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef2
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==0 & highPM_lag1==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef3
		reghdfe hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0 & wage_employee==0 & highPM_lag1==1 & highPM_lag2==1, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store icoef4

		coefplot (Wage, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (fcoef2,  nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(fcoef3,  nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (fcoef4,  nokey keep(hr_IT1_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")) ///
					(Nonwage, keep(hr_IT1_PM25)  msymbol(smx) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1 and t-2")) (icoef2,  nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "No PM2.5 t-1")) ///
					(icoef3,  nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1")) (icoef4,  nokey keep(hr_IT1_PM25) msymbol(smx) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = "PM2.5 t-1 and t-2")), ///
				levels(90)	ytitle("Effect on Daily Hours Worked", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nooffsets pstyle(p1 p1 p1 p1) ///
					xtitle("Sample Restiction") 			
		graph export "$graphs/figure_b3_consecutive_wagevnonwage.png", replace		
		estimates clear
		
*Figure B1: Semi-Elasticity of Daily Hours Worked to the Number of Hours Above WHO Thresholds for PM 2.5
		
	use "$rawdata/lmkt_withp_daily_clean.dta", clear
	gen ln_hours_worked_daily=ln(1+hours_worked_daily)

		estimates clear
		reghdfe ln_hours_worked_daily hr_IT1_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef1
		reghdfe ln_hours_worked_daily hr_IT2_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef2
		reghdfe ln_hours_worked_daily hr_IT3_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r)
		estimates store coef3
		reghdfe ln_hours_worked_daily hr_AQG_PM25 max_TMP c.precip##c.precip i.dow c.age##c.age gender c.anios_esc##c.anios_esc if timeline==0, abs(week_trim_year i.state#i.municipality) vce(r) 
		estimates store coef4
			
		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), ///
					levels(90)	ytitle("Semi-Elasticity of Daily Hours Worked", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) ///
					order(AQG IT3 IT2 IT1) ///
					xtitle("PM 2.5 Pollution Threshold")
					
		graph export "$graphs/figure_b1_thresholds_ln_hours_worked_daily.png", replace		
		estimates clear
		
*Figure 7: Daily Number of Hours Above WHO Thresholds and Daily Hospital Admissions for Respiratory Disease

	use "$usedata/hosp_pollution_replication.dta", clear
	
		reghdfe reason_resp hr_AQG_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef4
		reghdfe reason_resp hr_IT3_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef3		
		reghdfe reason_resp hr_IT2_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef2		
		reghdfe reason_resp hr_IT1_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef1
		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), ///
					levels(90)	ytitle("Hospital Admission due to a Respiratory Disease (=1)", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) ///
					order(AQG IT3 IT2 IT1) ///
					xtitle("PM 2.5 Pollution Threshold")
		graph export "$graphs/figure_7_thresholds_resp.png", replace
		estimates clear

*Figure B5: Daily Number of Hours Above WHO Thresholds and Daily Hospital Admissions for Digestive and Circulatory Diseases

		reghdfe reason_dig hr_AQG_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef4
		reghdfe reason_dig hr_IT3_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef3		
		reghdfe reason_dig hr_IT2_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef2
		reghdfe reason_dig hr_IT1_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef1
		reghdfe reason_cv hr_AQG_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef5
		reghdfe reason_cv hr_IT3_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef6
		reghdfe reason_cv hr_IT2_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef7
		reghdfe reason_cv hr_IT1_PM25 if reason_birth==0, abs(i.entmun  i.year#i.month) cluster(locationnumber)
		estimates store coef8

		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG))  (coef8, keep(hr_IT1_PM25)  msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef7, keep(hr_IT2_PM25) msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef6, keep(hr_IT3_PM25) msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef5,  keep(hr_AQG_PM25) msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), ///
				levels(90) legend(order(2 "Digestive" 12 "Circulatory") on) 	ytitle("Hospital Admission due to Circulatory (o)" "and Digestive (+) Diseases (=1)", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) ///
					order(AQG IT3 IT2 IT1) ///
					xtitle("PM 2.5 Pollution Threshold")	
				
		graph export "$graphs/figure_b5_thresholds_digcardio.png", replace
		estimates clear
		
*Figure B4: Daily Number of Hours Above WHO Thresholds and Daily Deaths for Respiratory Diseases

use "$usedata/cdmx_deaths_pollution_replication.dta", clear

		reghdfe reason_resp hr_IT1_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef1
		reghdfe reason_resp hr_IT2_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef2
		reghdfe reason_resp hr_IT3_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef3		
		reghdfe reason_resp hr_AQG_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber) 
		estimates store coef4
		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), ///
					levels(90)	ytitle("Death due to a Respiratory Disease (=1)", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) ///
					order(AQG IT3 IT2 IT1) ///
					xtitle("PM 2.5 Pollution Threshold")
		graph export "$graphs/figure_b4_thresholds_resp_deaths.png", replace
		estimates clear
		
*Figure B6: Daily Number of Hours Above WHO Thresholds and Daily Deaths for Digestive and Circulatory Diseases

		reghdfe reason_dig hr_IT1_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef4
		reghdfe reason_dig hr_IT3_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef3	
		reghdfe reason_dig hr_IT2_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef2
		reghdfe reason_dig hr_IT1_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef1
		reghdfe reason_cv hr_AQG_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef5
		reghdfe reason_cv hr_IT3_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef6
		reghdfe reason_cv hr_IT2_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef7
		reghdfe reason_cv hr_IT1_PM25 , abs(i.ANIO_OCUR##i.MES_OCURR  i.entmun) cluster(locationnumber)
		estimates store coef8

		coefplot (coef1, keep(hr_IT1_PM25)  msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef2, keep(hr_IT2_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef3, keep(hr_IT3_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef4,  keep(hr_AQG_PM25) msymbol(plus) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG))  (coef8, keep(hr_IT1_PM25)  msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT1_PM25 = IT1)) (coef7, keep(hr_IT2_PM25) msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT2_PM25 = IT2)) ///
					(coef6, keep(hr_IT3_PM25) msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_IT3_PM25 = IT3)) (coef5,  keep(hr_AQG_PM25) msymbol(Oh) mcolor(black) msize(medsmall) c(l) lcolor(black) lwidth(med) rename(hr_AQG_PM25 = AQG)), ///
				levels(90) legend(order(2 "Digestive" 12 "Circulatory") on) 	ytitle("Deaths due to Circulatory (o)" "and Digestive (+) Diseases (=1)", axis(1)) ///
					vert yline(0, lcolor(gs4)) omitted nokey nooffsets pstyle(p1 p1 p1 p1) ///
					order(AQG IT3 IT2 IT1) ///
					xtitle("PM 2.5 Pollution Threshold")	
				
		graph export "$graphs/figure_b6_thresholds_digcardio_deaths.png", replace
		estimates clear

		
		
end

main

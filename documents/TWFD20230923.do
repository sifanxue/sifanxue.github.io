*********************************************************************
* Project: Trade, Capital, Investment
* Sifan Xue 
* 2023.09.23

* Using different regressions of trade and FDI diversion, get a rough sense of how much export growth can be attributed to the growing FDI 
*********************************************************************


************************************************
* 0. Set-up 
************************************************

	clear all
	set more off
	pause on
	cap clear matrix
	set mem 1g
	set matsize 1000
	set maxvar 32767
	program drop _all 
	macro drop _all
	eststo clear

	local user "Sifan" 
	
	if "`user'" == "Sifan" { 
		global dir "/Users/sifanxue/Dropbox (Princeton)/Research/intl macro and trade"

	}
	
	* specific subfolder 
	global output0901 "$dir/codes/20230516/20230816/20230901/output20230901"
	global output0816 "$dir/codes/20230516/20230816/20230816/output20230816"
	
	global output0714 "$dir/codes/20230516/20230713/output0714"
	global output0713 "$dir/codes/20230516/20230713/output0713"
	global output0523 "$dir/codes/20230516/20230523/output0523"
	global output0331 "$dir/codes/20230220/20230331/output20230331"
	global output0404 "$dir/codes/20230220/20230331/output20230404"
	global output0412 "$dir/codes/20230220/20230331/output20230412"
	
	

/*
************************************************
* 1. For Export to US 
************************************************
	
	* (1) Coef. EX ~ DI 
	frame create frameUS_exdi
	frame change frameUS_exdi
	use "$output0901/regresult_lEXtoUS_cty_HS6_20230901.dta", clear 
	keep if var == "intCN2018" | var == "intCN2019" | var == "intCN2020" | var == "intCN2021"
	rename var year 
	replace year = "2018" if year == "intCN2018"
	replace year = "2019" if year == "intCN2019"
	replace year = "2020" if year == "intCN2020"
	replace year = "2021" if year == "intCN2021"
	destring year, replace 
	rename coef coef_ex_di 
	keep year coef_ex_di
	
	* (2) Coef. EX ~ FDI 
	frame create frameUS_exfdi
	frame change frameUS_exfdi
	use "$output0901/regresult_lEXtoUS_cty_grFDI_20230901.dta", clear 
	
	keep if var == "intFDI2018" | var == "intFDI2019" | var == "intFDI2020" | var == "intFDI2021"
	rename var year 
	replace year = "2018" if year == "intFDI2018"
	replace year = "2019" if year == "intFDI2019"
	replace year = "2020" if year == "intFDI2020"
	replace year = "2021" if year == "intFDI2021"
	destring year, replace 
	rename coef coef_ex_fdi
	keep year coef_ex_fdi
	tempfile data_ex_fdi
	save `data_ex_fdi'
	
	
	* (3) Coef. FDI ~ DI 
	frame create frameUS_fdidi
	frame change frameUS_fdidi
	use "$output0816/regresult_lFDI_cty_HS6_20230816.dta", clear 
	keep if var == "intCN2018" | var == "intCN2019" | var == "intCN2020" | var == "intCN2021"
	rename var year 
	replace year = "2018" if year == "intCN2018"
	replace year = "2019" if year == "intCN2019"
	replace year = "2020" if year == "intCN2020"
	replace year = "2021" if year == "intCN2021"
	destring year, replace 
	rename coef coef_fdi_di
	keep year coef_fdi_di
	tempfile data_fdi_di
	save `data_fdi_di'
	
	* (4) put together 
	frame change frameUS_exdi
	merge 1:1 year using `data_ex_fdi'
	drop _merge 
	merge 1:1 year using `data_fdi_di'
	drop _merge 
	
	* (5) contribution of FDI 
	local coef_fdi_di2019 = coef_fdi_di[2]
	replace coef_fdi_di = `coef_fdi_di2019' if year != 2019 
	gen FDI_shareUSexport = coef_ex_fdi * coef_fdi_di / coef_ex_di
	rename coef* coefUS*

************************************************
* 2. For Export to all ex. CN  
************************************************
	
	* (1) Coef. EX ~ DI 
	frame create frameCN_exdi
	frame change frameCN_exdi
	use "$output0901/regresult_lEXnoCN_cty_HS6_20230901.dta", clear 
	keep if var == "intCN2018" | var == "intCN2019" | var == "intCN2020" | var == "intCN2021"
	rename var year 
	replace year = "2018" if year == "intCN2018"
	replace year = "2019" if year == "intCN2019"
	replace year = "2020" if year == "intCN2020"
	replace year = "2021" if year == "intCN2021"
	destring year, replace 
	rename coef coef_ex_di 
	keep year coef_ex_di
	
	* (2) Coef. EX ~ FDI 
	frame create frameCN_exfdi
	frame change frameCN_exfdi
	use "$output0901/regresult_lEXnoCN_cty_grFDI_20230901.dta", clear 
	
	keep if var == "intFDI2018" | var == "intFDI2019" | var == "intFDI2020" | var == "intFDI2021"
	rename var year 
	replace year = "2018" if year == "intFDI2018"
	replace year = "2019" if year == "intFDI2019"
	replace year = "2020" if year == "intFDI2020"
	replace year = "2021" if year == "intFDI2021"
	destring year, replace 
	rename coef coef_ex_fdi
	keep year coef_ex_fdi
	tempfile data_ex_fdi
	save `data_ex_fdi'
	
	
	* (3) Coef. FDI ~ DI 
	frame create frameCN_fdidi
	frame change frameCN_fdidi
	use "$output0816/regresult_lFDI_cty_HS6_20230816.dta", clear 
	keep if var == "intCN2018" | var == "intCN2019" | var == "intCN2020" | var == "intCN2021"
	rename var year 
	replace year = "2018" if year == "intCN2018"
	replace year = "2019" if year == "intCN2019"
	replace year = "2020" if year == "intCN2020"
	replace year = "2021" if year == "intCN2021"
	destring year, replace 
	rename coef coef_fdi_di
	keep year coef_fdi_di
	tempfile data_fdi_di
	save `data_fdi_di'
	
	* (4) put together 
	frame change frameCN_exdi
	merge 1:1 year using `data_ex_fdi'
	drop _merge 
	merge 1:1 year using `data_fdi_di'
	drop _merge 
	
	* (5) contribution of FDI 
	local coef_fdi_di2019 = coef_fdi_di[2]
	replace coef_fdi_di = `coef_fdi_di2019' if year != 2019 
	gen FDI_shareCNexport = coef_ex_fdi * coef_fdi_di / coef_ex_di
	rename coef_* coefCN_*
	tempfile data_CNshare 
	save `data_CNshare'
	
************************************************
* 3. Put together and plot 
************************************************
	
	frame change frameUS_exdi
	merge 1:1 year using `data_CNshare'
	drop _merge 
	
	graph bar FDI_shareUSexport FDI_shareCNexport, over(year, label(labsize(*0.6)) gap(*2)) graphregion(fcolor(white)) xsize(20cm) ysize(10cm) inten(35) legend(cols(2) pos(6) lab(1 "Export to US") lab(2 "Total Export ex. CN")) ytitle("Contribution % of FDI to Export Growth") 
	
	graph bar FDI_shareUSexport if year >= 2019, over(year, label(labsize(*0.6)) gap(*2)) graphregion(fcolor(white)) xsize(20cm) ysize(10cm) inten(35) legend(cols(2) pos(6) lab(1 "Export to US")) ytitle("Contribution % of FDI to Export Growth") 
	

************************************************
* 4. Use avg coef
************************************************
	
	drop if year == 2018 
	drop FDI_shareCNexport FDI_shareUSexport 
	collapse (mean) coefUS_ex_di coefUS_ex_fdi coefUS_fdi_di coefCN_ex_di coefCN_ex_fdi coefCN_fdi_di
	
	gen FDI_shareUSexport = coefUS_ex_fdi * coefUS_fdi_di / coefUS_ex_di * 100
	gen FDI_shareCNexport = coefCN_ex_fdi * coefCN_fdi_di / coefCN_ex_di * 100
	
	xx
	
	graph bar FDI_shareUSexport FDI_shareCNexport, graphregion(fcolor(white)) xsize(20cm) ysize(10cm) inten(35) legend(cols(2) pos(6) lab(1 "Export to US") lab(2 "Total Export ex. CN")) ytitle("Contribution % of FDI to Export Growth") 
	

************************************************
* 5. Try to understand country similar to VNM better 
************************************************
		
	* (1) Export: level and growth 
	use "$output0901/BACI_EX_08to21_20230901.dta", clear 
	use "$output0901/BACI_EXnoCN_08to21_20230901.dta", clear 
	use "$output0901/BACI_EXtoUS_08to21_20230901.dta", clear 
	
	
	* (2) FDI: level and growth 
	
	use "$output0331/TotalFDIinStock_allsource_20230331.dta", clear  
	keep if year > 2012
	
	rename ISO3 receiver 
	drop flag_OECDROU flag_UNCTAD 
	
	frame create frame_newdata
	frame change frame_newdata
	use "$output0714/FDIbil13to21_manullycleaned_20230714.dta", clear  
	keep if investor == "CHN" | investor == "W0"
	reshape wide FDI, i(receiver year) j(investor) string 
	tempfile data_newdata
	save `data_newdata'
	
	frame change default 
	merge 1:1 receiver year using `data_newdata'
	replace ILD = FDIW0 if FDIW0 != .
	drop if _merge == 2 
	drop _merge 
	rename receiver ISO3
	
	*/
	
	


************************************************
* 6. Scatter plot for grEX and grFDI 
************************************************
	
	
	
	
	
	
	
	
	
	
	
	
	

************************************************
* 7. Reg: EX ~ Diversion Index + FDI gr
************************************************
	
	
	* (1) Export over years 
// 	use "$output0901/BACI_EX_08to21_20230901.dta", clear 
	
	eststo clear 

foreach dd in EXnoCN EXtoUS {
	
	if "`dd'" == "EXnoCN" {
		local cty "All ex. CN"
	}
	else {
		local cty "US"
	}
	
	use "$output0901/BACI_`dd'_08to21_20230901.dta", clear 
	
	rename exporter ISO3 
	keep if year > 2012
	
	* (2) merge with exposure 
	merge m:1 ISO3 using "$output0816/TWexpo_cty_HS6_20230816.dta"
	drop if _merge != 3
	drop _merge 
	
	* generate interaction terms 
		forvalues yr = 2013(1)2021 {
			gen intCN`yr' = expoCN if year == `yr'
			replace intCN`yr' = 0 if intCN`yr' == .
		}
	sort ISO3 year 
	
	* (3) merge with FDI growth 2017-2019 
	merge m:1 ISO3 using "$output0901/gr_FDI_17toLater_20230901.dta"
	drop if _merge != 3
	drop _merge 
	
	* generate interaction terms 
		forvalues yr = 2013(1)2021 {
			gen intgrFDI`yr' = gr_FDI if year == `yr'
			replace intgrFDI`yr' = 0 if intgrFDI`yr' == .
		}
	sort ISO3 year 
	
	* generate double-interaction terms 
		forvalues yr = 2013(1)2021 {
			gen intexpo_grFDI`yr' = gr_FDI * expoCN if year == `yr'
			replace intexpo_grFDI`yr' = 0 if intexpo_grFDI`yr' == .
		}
	sort ISO3 year 

	
	* (4) Reg 
	* generate var for reg 
	gen lEX = log(EX)
	
	* select sample 
	kountry ISO3, from(iso3c) geo(sov)
	egen regiontime = group(GEO year)
	
	frame copy default temp, replace
	frame change temp 
	
	keep if year == 2017 
	sort EX 
	
	drop if ISO3 == "CHN" 

// 	gen largest = _n >= 148
	gen largest = _n >= 50
	
	drop if NAMES_STD == "British Virgin Islands" | NAMES_STD == "Cyprus" | NAMES_STD == "Luxembourg" | NAMES_STD == "Mauritius" | NAMES_STD == "Malta" 

	keep if largest == 1
	keep ISO 	
	
	tempfile sampleselect
	save `sampleselect'
	frame change default 
	merge m:1 ISO3 using `sampleselect'
	keep if _merge == 3 | ISO3 == "VNM"
	drop _merge 
	* end of sample select 
	
	* regression 
	drop *2017*

	bysort ISO3 (year): gen num = _N  
	drop if num < 9 
	drop if ISO3 == "USA" | ISO3 == "CHN"
	
	reghdfe lEX intCN*, absorb(ISO3 year) vce(cluster ISO3)
	reghdfe lEX intCN* intgrFDI*, absorb(ISO3 year) vce(cluster ISO3)
	reghdfe lEX intCN* intexpo_grFDI*, absorb(ISO3 year) vce(cluster ISO3)
	
// 	regsave using "$output0901/regresult_lEX_cty_HS6_20230901", ci level(90) replace

	* (5) Pooled regression 
	keep ISO3 year expoCN gr_FDI lEX 
	reshape wide lEX, i(ISO3) j(year)
	forvalues yr = 2019(1)2021 {
		gen gr_EX`yr' = lEX`yr' - lEX2017
	}
	keep ISO3 expoCN gr_FDI gr_EX2019 gr_EX2020 gr_EX2021
	reshape long gr_EX, i(ISO3) j(year)
	
	gen int_expo_grFDI = expoCN * gr_FDI
	
	
		* ADD SOME CONTROLS 
		frame create frame_controls 
		frame change frame_controls
		use "$output0901/BACI_`dd'_08to21_20230901.dta", clear 
		keep if year == 2017 
		gen lEX = log(EX)
		rename exporter ISO3 
		tempfile data_ex2017 
		save `data_ex2017'
		
		use "$output0901/gr_FDI_17toLater_20230901.dta", clear 
		keep ILD ISO3
		gen lFDI = log(ILD)
		tempfile data_fdi2017 
		save `data_fdi2017'
		
		use "$output0331/WDI_GDP_20230331.dta", clear 
		keep if year > 2016 
		keep if year < 2022 
		keep ISO3 year GDPpc_cuUS
		gen lGDPpc = log(GDPpc_cuUS)
		drop GDPpc_cuUS
		reshape wide lGDPpc, i(ISO3) j(year)
		forvalues yr = 2018(1)2021 {
			gen gr_lGDPpc`yr' = lGDPpc`yr' - lGDPpc2017
		}
		keep ISO3 lGDPpc2017 lGDPpc2019 lGDPpc2020 lGDPpc2021 gr_lGDPpc2019 gr_lGDPpc2020 gr_lGDPpc2021
		reshape long lGDPpc gr_lGDPpc, i(ISO3) j(year)
		tempfile data_gdppc 
		save `data_gdppc'

		frame change default 
		frame drop frame_controls
	
		merge m:1 ISO3 using `data_ex2017'
		drop if _merge != 3 
		drop _merge 
		merge m:1 ISO3 using `data_fdi2017'
		drop if _merge != 3 
		drop _merge 
		merge 1:1 ISO3 year using `data_gdppc'
		drop if _merge != 3 
		drop _merge 
		
		kountry ISO3, from(iso3c) geo(sov)
		egen regiontime = group(GEO year)
		
		
	label var expoCN "Diversion Index"
	label var gr_FDI "FDK Growth"
	
	binscatter gr_EX gr_FDI if year == 2020, lcolor(ebblue) msymbol(d) mcolor(dkorange) xtitle(FDI Growth (17-19)) ytitle(Export Growth to `cty' (17-20))
	
	graph export "$output0901/Binsca_EXFDI_`dd'_20230927.pdf", replace 
	
// 	 if year == 2020 | year == 2019
// lEX lFDI lGDPpc
// 	eststo `dd'1: reghdfe gr_EX expoCN lEX lFDI lGDPpc if year == 2020, absorb(year) vce(cluster ISO3)
	eststo `dd'1: reg gr_EX expoCN lEX lFDI lGDPpc if year == 2020, cluster(ISO3)
			local r2 = string(round(e(r2_a),.01))
			estadd local R2 "{`r2'}": `dd'1
			estadd local Controls "\checkmark": `dd'1
			local obs = string(e(N))
			estadd local Num_obs "{`obs'}": `dd'1
			
// 	eststo `dd'2: reghdfe gr_EX expoCN gr_FDI lEX lFDI lGDPpc if year == 2020, absorb(year) vce(cluster ISO3)
	eststo `dd'2: reg gr_EX expoCN gr_FDI lEX lFDI lGDPpc if year == 2020, cluster(ISO3)
			local r2 = string(round(e(r2_a),.01))
			estadd local R2 "{`r2'}": `dd'2
			estadd local Controls "\checkmark": `dd'2
			local obs = string(e(N))
			estadd local Num_obs "{`obs'}": `dd'2
			
			
// 	reghdfe gr_EX expoCN gr_FDI int_expo_grFDI, absorb(year) vce(cluster ISO3)
// 	scatter gr_EX gr_FDI if year == 2020
// 	binscatter gr_EX gr_FDI if year == 2020
	
}

	esttab EXnoCN1 EXnoCN2 EXtoUS1 EXtoUS2 using "$output0901/Reg_EXFDI_20230927.txt", replace se label /// 
		star(* 0.1 ** 0.05 *** 0.01) /// 
		keep(expoCN gr_FDI) ///
		order(expoCN gr_FDI) 	
		
	esttab EXnoCN1 EXnoCN2 EXtoUS1 EXtoUS2 using "$output0901/Reg_EXFDI_20230927.tex", replace se label booktabs nonumber ///
		alignment(D{.}{.}{-1}) fragment b(3) ///
		mgroups("To All (ex. CN)" "To US", pattern(1 0 1 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) /// 
		mlabels("(1)" "(2)" "(3)" "(4)") /// 
		stats(Controls R2 Num_obs, ///
			labels("Controls" "R2 adj." "\# of Obs.") ) ///
		star(* 0.1 ** 0.05 *** 0.01) /// 
		nogaps /// 
		keep(expoCN gr_FDI) ///
		order(expoCN gr_FDI) 	
	
	
	
	
	
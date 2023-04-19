
 
global directory "C:\Users\bencar\Box\Real Data Project 3"

* Data Project 3
* Ben Carson

*import and clean up excel files

cd "C:\Users\bencar\Box\Real Data Project 3"
import excel 2020pop, firstrow clear
drop badid CountyFull
rename ID FIPS
rename PopTotal pop2020
save 2020pop, replace

*dropped a bunch of variables and renamed some stuff

import excel zipcounty, firstrow clear
drop RES_RATIO BUS_RATIO OTH_RATIO TOT_RATIO
rename ZIP zip5
rename COUNTY FIPS
save zipcounty, replace

import excel ziphouse, firstrow clear
drop IndexType
rename Quarter quarter
save ziphouse, replace


*prep the data

use ziphouse, clear
rename zip3 prefix
gen str3 zip3 = string(prefix,"%03.0f")
drop prefix
label variable zip3 "3-digit ZIPs"
gen keep = 0
replace keep = 1 if year == 2020
replace keep = 1 if year == 2021
drop if keep == 0
drop keep
drop if quarter != 1
bysort zip3 (year): gen housechange = 100*(index_1995[_n]-index_1995[_n-1])/index_1995[_n-1]
drop if year != 2021
drop index_1995 quarter year
save, replace
clear

*used a api to convert zips to county FIPS

use zipcounty
gen zip3 = substr(zip5,1,3)
joinby zip3 using ziphouse
drop zip5 zip3
collapse housechange, by(FIPS)
save houseindex, replace
*erase zipcounty.dta
*erase ziphouse.dta
clear

*organizing mortality data

use nytcounty
collapse (sum) deaths, by(FIPS)
joinby FIPS using houseindex
save deathindex, replace
*erase houseindex.dta
*erase nytcounty.dta
clear

*add population amounts to get per capita
use 2020pop
joinby FIPS using deathindex
gen mortper100k = (deaths/pop2020)*100000
drop pop2020 deaths
save mortindex, replace
*erase deathindex.dta
*erase 2020pop.dta
clear


*used some code from stack exchange to covert zips to county FIPS
global route "$directory\countywages2021"
cd "$route"
tempfile building
save `building', emptyok
local filenames : dir "$route" files "*.csv"
foreach f of local filenames {
	import delimited using `"`f'"' , rowrange(4:1000) varnames(4) stringcols(_all) clear
	gen source = `"`f'"'
	append using `building'
	save `"`building'"', replace
	}
save "$route\allcountywages2021", replace

*cleaning
drop year quarter noofestablishments employment industry source oneyearemploymentgainlosspercent
rename fips FIPS
rename averageweeklywage avgwage
rename onyearweeklywagesgainlosspercent wagechange
destring avgwage wagechange, replace
drop if avgwage==.

*save to main directoy
cd "C:\Users\bencar\Box\Real Data Project 3"
save wagecounty, replace
clear

cd "$route"
erase "$route\allcountywages2021.dta"
cd "C:\Users\bencar\Box\Real Data Project 3"

fff
use mortindex
joinby FIPS using wagecounty
order areaname usps, last
save mortwagehouse, replace
*erase mortindex.dta
*erase wagecounty.dta
clear


*Do the regression

* check out summaries
use mortwagehouse
sort housechange
sort wagechange
sort mortper100k
sum housechange wagechange mortper100k
histogram mortper100k

*run the regression
gen lmort = log(mortper100k)
gen lwage = log(avgwage)
regress housechange lmort lwage wagechange, robust

* check out the residuals
predict housechangehat
predict error, residuals
sum housechangehat housechange
sum error

*graph this thang
twoway (scatter housechange mortper100k) (lfit housechange mortper100k)


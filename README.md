# dataproject-3

Data Project 3
Ben Carson
ECON 388

PURPOSE: Determine the effects of county COVID mortality rates on housing prices
----------------------------------------------------------------------------

Files in Folder

Do
- BenData3.do

Excel -
- 2020pop.xlsx
- zipcounty.xlsx
- ziphouse.xlsx

STATA -
- nytcounty.dta

TEXT -
- README.txt

FOLDER -
- countywages2021
	- 50 more Excel files should be in this folder; described below.

-----------------------------------

DO-FILE INSTRUCTIONS:

To run, switch out after it says cd throughout the document to be your file path rather than mine
----------------------------------

Excel files

2020pop.xlsx :
The dataset contains redistricting data gathered during the 2020 Census. I obtained the dataset by accessing the source link and customized it to present county level information. Upon downloading the file, I removed extraneous columns and added a new column featuring a 5-digit FIPS code. The dataset has four columns, namely ID, badid, County Full, and PopTotal. 
LINK: https://data.census.gov/cedsci/table?q=United%20States&tid=DECENNIALPL2020.P1

nytcounty.dta :
County data on mortality rates
LINK: https://github.com/nytimes/covid-19-data/blob/master/rolling-averages/us-counties-2020.csv

- zipcounty.xlsx
This is a zip to FIPS dataset to correlate zip codes with county
LINK: https://www.huduser.gov/portal/datasets/usps_crosswalk.html

- ziphouse.xlsx
This is a time series dataset of the Housing Price Index organized by 3-digit ZIP code sourced from the Federal Housing Finance Authority. The webpage offers a line dedicated to Three-Digit ZIP Codes (Developmental Index; Not Seasonally Adjusted) with a convenient [XLSX] file download link situated on the right. After extracting the file, I performed data cleaning by removing the initial four-row header and relabeling variable columns. The relevant variables include zip3, year, Quarter, index_1995, and Index Type. 
LINK: https://www.fhfa.gov/DataTools/Downloads/Pages/House-Price-Index-Datasets.aspx

- The fifty files in the countywages2021 folder
These are wages per county to use in the regression as well, I cleaned, combined and merged these.
LINK: https://data.bls.gov/maps/cew/us

----------------------------------------------------------------------------

additionally, there are a bunch of dta files from what the code generates - when running the code, replace commands will make sure they stay updated or don't get in the way

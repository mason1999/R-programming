# Introduction

This is my STAT3888 assignment. What should be in the folder (if not already in it) are: 

- `README.md`: This file which explains the minimum things which are in the folder and a bit into my assignment
- `Ass1_470408326.Rmd`: The main R-markdown file. All that one needs to do is knit this
- `Assignment1.Rproj`: For book keeping. Allows us to easily reference relative paths
- `clean_data.R`: A script that the main R-markdown file uses. This is where most of the time spent knitting the main R-markdown file goes to
- `data`: A folder which contains the csv files: 

	- `AHS11biomedical.csv`: data set containing biomedical information
	- `AHS11nutrient.csv`: data set containing nutrition information
	- `AHS11food.csv`: data set containing food information
	- `nutmstatDataItems2019.xlsx`: The data diction explaining what the variables are and what the different levels mean. 

# Steps to knit this
If the files `Ass1_470408326.Rmd`, `Assignment1.Rproj`, `clean_data.R` and the csv files from the `data` folder are present, then all  you should need to do is go to the `Ass1_470408326.Rmd` file and knit it. 

# What is my assignment about? 
For this assignment, I was given 3 datasets containing a couple hundred variables with over 12000 observations. The data was from the Australian Health Survey, National Health Survey 2011-2012. What I did was I cleaned the data methodically. Look at the generated report to learn more!

# Legacy code
There is legacy code given by my lecturer in the `CleanData.Rmd`. This is mostly encapsulated in the `clead_data.R` script!

# File:   Describe.R
# Course: R: An Introduction (with RStudio)

# describe() gives you n (sample size), mean, SD, median, 10% trimmed mean, 
# MAD (medium absolute deviation), min/max, range, skewness, kertosis and standard error.
# We need the psych package for this

# INSTALL AND LOAD PACKAGES ################################

library(datasets)  # Load base packages manually

# Installs pacman ("package manager") if needed
if (!require("pacman")) install.packages("pacman")

# Use pacman to load add-on packages as desired
pacman::p_load(pacman, psych) 

# LOAD DATA ################################################

head(iris)

# PSYCH PACKAGE ############################################

# Get info on package
p_help(psych)           # Opens package PDF in browser
p_help(psych, web = F)  # Opens help in R Viewer

# DESCRIBE() ###############################################

# For quantitative variables only.

describe(iris$Sepal.Length)  # One quantitative variable
describe(iris)               # Entire data frame. Note that for categorical 
                             # variables like Species, describe doesn't work
                             # as well on them

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons
detach("package:datasets", unload = TRUE)   # For base

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

# THIS SCRIPT IS BASED OFF THE LECTURER JOHN'S ONE. ESSENTIALLY I HAVE KEPT WHAT HE MADE
# WITH THE MODIFICATION THAT I DISCARDED HIS TECHNICALLY CORRECT DATA AND 
# MODIFIED THE PROC_BIOM DATA TO BE THE TECHINICALLY CORRECT DATA. 

# Suppress start up warnings when loading libraries
library <- function(...) {
  suppressPackageStartupMessages(base::library(...))
}

# Load in all libraries
library(tidyverse)
library(here)      # directory referencing
library(readxl)    # reading Excel files
library(janitor)   # data cleaning 
library(stringr)   # string manimpuation
library(tidyr)     # new tidy functions
library(readr)

# First we read raw data into R.
raw_biom <- read_csv(here::here("data","AHS11biomedical.csv"), col_names = TRUE)
raw_nutr <- read_csv(here::here("data","AHS11nutrient.csv"), col_names = TRUE)
raw_food <- read_csv(here::here("data","AHS11food.csv"), col_names = TRUE)

# Next we are going to create a quiet version of `readxl` function so that warning and 
# other messages don't appear in the knitted version of this document.
quiet_read <- purrr::quietly(readxl::read_excel)

# Read the data dictionary for each of the three data sources which are located
# in sheets 1 to 3 of the "nutmstatDataItems2019.xlsx" file.
dict_biom <- quiet_read(here("data","nutmstatDataItems2019.xlsx"),sheet=1)$result
dict_nutr <- quiet_read(here("data","nutmstatDataItems2019.xlsx"),sheet=2)$result
dict_food <- quiet_read(here("data","nutmstatDataItems2019.xlsx"),sheet=3)$result

# renames the extra columns to new variables. 
dict_biom <- dict_biom %>% janitor::clean_names() %>% rename(extra=x3)  
dict_nutr <- dict_nutr %>% janitor::clean_names() %>% rename(extra1=x3,extra2=x4) 
dict_food <- dict_food %>% janitor::clean_names() %>% rename(extra=x3) 

# Remove any empty rows with only NA's in them
dict_biom <- dict_biom %>% janitor::remove_empty("rows")
dict_nutr <- dict_nutr %>% janitor::remove_empty("rows")
dict_food <- dict_food %>% janitor::remove_empty("rows")

# Remove any empty rows and any duplicate rows
biom_readable <- dict_biom %>% 
  filter(!is.na(variable_name))  

nutr_readable <- dict_nutr %>% 
  filter(!is.na(variable_name)) %>% 
  distinct() 

food_readable <- dict_food %>% 
  filter(!is.na(variable_name)) %>% 
  distinct() 

# Fill the empty row names with the variable name 
dict_biom <- dict_biom %>% tidyr::fill(variable_name)
dict_nutr <- dict_nutr %>% tidyr::fill(variable_name)
dict_food <- dict_food %>% tidyr::fill(variable_name)  

# a function which takes in a dictionary, extracts the variable names, looks at all the rows with that variable name, 
# combines the string together, if there is the word continuous label it continuous. If not, label it as categorical. 
get_type <- function(dict) 
{
  #dict <- dict_nutr
  var_names <- unique(dict$variable_name)
  var_type  <- c()
  for (j in 1:length(var_names))
  {
    # Get all dictionary lines corresponding to a varible
    # (a block of lines)
    dict_block <- dict %>% 
      filter(variable_name==var_names[j])
    
    # Take all of the characters in a block, paste them 
    # together and make all characters lower case
    block_string <- dict_block %>%
      select(-variable_name) %>%
      as.matrix() %>%
      as.vector() %>%
      paste(collapse="") %>%
      tolower()
    
    # Assign variable if we can find the word "continuous"
    # in the block otherwise assume that it is "categorical"
    var_type[j] <- block_string %>% 
      str_detect("continuous") %>% 
      ifelse("continuous","categorical") 
  }
  return(var_type)
}

# Try to infer the data types from the data dictionary
tib1 <- tibble(variable_type=get_type(dict_biom))
tib2 <- tibble(variable_type=rep("continuous",nrow(nutr_readable)))
tib3 <- tibble(variable_type=get_type(dict_food))

# Create a new tibble that takes the readable tibble,
# appends the variable type, and do some minor fixing
# the minor fixing is just fixing up the types of ABSPIC and ABSHID
types_biom <- bind_cols(biom_readable, tib1) %>%
  mutate(variable_type=ifelse(variable_name%in%c("ABSPID","ABSHID"), "string",variable_type))

types_nutr <- bind_cols(nutr_readable, tib2) %>%
  mutate(variable_type=ifelse(variable_name%in%c("ABSPID","ABSHID"), "string",variable_type))

types_food <- bind_cols(food_readable, tib3) %>%
  mutate(variable_type=ifelse(variable_name%in%c("ABSPID","ABSHID"), "string",variable_type)) 

# Split the description varible in the data dictionary into value and meaning columns
get_special_value_meanings <- function(dict)
{
  var_names <- unique(dict$variable_name)
  special   <- tibble(variable_name=c(),
                      value=c(),
                      meaning=c())
  
  for (j in 1:length(var_names)) 
  {
    # Get a block of values from the dictionary
    block <-  dict %>%
      filter(variable_name==var_names[j])
    
    if (nrow(block)>1) {
      # Split  the descrition into value/meaning pairs
      special_block <- block[-1,-c(3:ncol(block))] %>%
        dplyr::filter(!grepl("continuous",tolower(description))) %>%
        separate(col=2, 
                 sep="[.]",
                 into=c("value","meaning")) %>%
        mutate(value=as.numeric(value),
               meaning=tolower(str_trim(meaning))) 
      
      # append these to a block of special value/meaning pairs
      special <- bind_rows(special, special_block)
    }
  }
  return(special)
}

# special values for biomedical, nutrition and food data sets
special_biom <- get_special_value_meanings(dict_biom)
special_nutr <- get_special_value_meanings(dict_nutr) %>% na.omit()
special_food <- get_special_value_meanings(dict_food) %>% na.omit()

# processed data sets: Take all categorical 
# variables and convert them to factors in R
proc_food <- raw_food %>%
  select(-ABSLFID,
         -ABSBID,
         -ABSSID,
         -ABSFID)

categorical_to_factor <- function(types, proc) 
{
  var_names <- colnames(proc)  
  for (i in 1:length(var_names)) 
  {
    # Extract the inferred variable type from the types tibble
    var_type <- types %>% 
      filter(variable_name==var_names[i]) %>%
      select(variable_type) %>%
      as.character()
    
    # If the type is categorical turn the variable into a factor
    if (var_type=="categorical") {
      proc[[var_names[i]]] <- as.factor(proc[[var_names[i]]])
    }
  }
  return(proc)
}

proc_biom <- categorical_to_factor(types_biom,raw_biom)
proc_nutr <- categorical_to_factor(types_nutr,raw_nutr)
proc_food <- categorical_to_factor(types_food,proc_food)

# make the technically correct data: 
n = nrow(proc_biom)
dict_vars_and_vals = list(
  list('BMISC', c(98, 99)), # not applicable, refusal, other reason# recode all the variables with NA's where non-applicable
  list('SMSBC', c(0)), # not applicablefor (i in 1:length(dict_vars_and_vals)) {
  list('FEMLSBC', c(9)), # none apply, not applicable  name = dict_vars_and_vals[[i]][[1]]
  list('PHDKGWBC', c(997, 998, 999)), # not applicable, faulty, refusal, other reason  na_vals = dict_vars_and_vals[[i]][[2]]
  list('PHDCMHBC', c(998, 999)), # not applicable, refusal, other reason  #proc_biom = proc_biom %>% mutate(!!name := ifelse((!! rlang::sym(name)) %in% na_vals, NA, (!! rlang::sym(name))))
  list('PHDCMWBC', c(998, 999)), # not applicable, refusal, other reason  temp = proc_biom[name] %>% pull()
  list('SF2SA1QN', c(99)), # not applicable, not determined  for (j in 1:n) {
  list('INCDEC', c(98, 99)), # not applicable, not stated, not known    if (temp[j] %in% na_vals) {
  list('ADTOTSE', c(9996, 9999)), # not applicable, not known      temp[j] = NA
  list('BDYMSQ04', c(6)), # not applicable, not known if on diet    }
  list('DIASTOL', c(998, 999)), # not applicable, not valid, not measured  }
  list('DIETQ12', c(0, 6)), # not applicable, not known  proc_biom[name] = temp
  list('DIETQ14', c(0, 6)), # not applicable, not known}
  list('DIETQ5', c(0)), # not applicable```
  list('DIETQ8', c(0)), # not applicable
  list('DIETRDI', c(0, 3)), # not applicable, not known### Save the relevant R objects for future use.
  list('SABDYMS', c(0, 8, 9)), # not applicable, not collected, not stated
  list('SLPTIME', c(9998, 9999)), # not known, not applicable```{r}
  list('SMKDAILY', c(0)), # not applicable#save(tech_biom, dict_biom, types_biom, proc_biom, 
  list('SMKSTAT', c(0)), # not applicable#     tech_nutr, dict_nutr, types_nutr, proc_nutr, 
  list('SYSTOL', c(998, 999)), # not applicable, invalid, not measured#     tech_food, dict_food, types_food, proc_food, 
  list('ALTNTR', c(0, 8)), # not applicable, unreported#     file = "tech_data.Rdata")
  list('ALTRESB', c(97, 98)), # Not applicable, not reported
  list('APOBNTR', c(0, 8)), # not applicable, not reportedsave(proc_biom, dict_biom, types_biom, file = "tech_data.Rdata")
  list('APOBRESB', c(97, 98)), # not applicable, not reported```
  list('B12RESB', c(97, 98)), # not applicable, not reported
  list('BIORESPC', c(0)), # not applicable
  list('CHOLNTR', c(0, 8)), # not applicable, not reported
  list('CHOLRESB', c(97, 98)), # not applicable, not reported
  list('CVDMEDST', c(0, 8)), # not applicable, not reported
  list('DIAHBRSK', c(0, 8)), # not applicable, not reported
  list('FASTSTAD', c(0)), # not applicable
  list('FOLATREB', c(97, 98)), # not applicable, not reported
  list('GGTNTR', c(8)), # not reported
  list('GGTRESB', c(97, 98)), # not applicable, not reported
  list('GLUCFPD', c(0, 8)), # not applicable, not reported
  list('GLUCFREB', c(97, 98)),  # not applicable, not reported
  list('HBA1PREB', c(7, 8)), # not applicable, not reported
  list('HDLCHREB', c(7, 8)), # not applicable, not reported
  list('LDLNTR', c(0, 8)), # not applicable, not reported
  list('LDLRESB', c(97, 98)), # not applicable, not reported
  list('TRIGNTR', c(0, 8)), # not applicable, not reported
  list('TRIGRESB', c(97, 98))
)

# recode all the variables with NA's where non-applicable
for (i in 1:length(dict_vars_and_vals)) {
  name = dict_vars_and_vals[[i]][[1]]
  na_vals = dict_vars_and_vals[[i]][[2]]
  #proc_biom = proc_biom %>% mutate(!!name := ifelse((!! rlang::sym(name)) %in% na_vals, NA, (!! rlang::sym(name))))
  temp = proc_biom[name] %>% pull()
  for (j in 1:n) {
    if (temp[j] %in% na_vals) {
      temp[j] = NA
    }
  }
  proc_biom[name] = temp
}

# convert the factors of exercise variables to integers (which is what they should be)
proc_biom = proc_biom %>% mutate(EXLWTBC = as.numeric(as.character(EXLWTBC)))
proc_biom = proc_biom %>% mutate(EXLWMBC = as.numeric(as.character(EXLWMBC)))
proc_biom = proc_biom %>% mutate(EXLWVBC = as.numeric(as.character(EXLWVBC)))

types_biom = types_biom %>% mutate(variable_type = case_when(
  variable_name == 'EXLWTBC' ~ 'continuous',
  variable_name == 'EXLWMBC' ~ 'continuous', 
  variable_name == 'EXLWVBC' ~ 'continuous',
  TRUE ~ variable_type))

save(proc_biom, dict_biom, types_biom, file = "tech_data.Rdata")

# clean up all the variables in our environment
rm(list = ls())
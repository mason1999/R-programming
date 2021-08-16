# To clear console <Ctrl-L>
# To clear workspace rm(list = ls())
#---- Section 1: Basic data types  ----
# Basic Data types, using the class() function, creating vectors
# assigning names to these vectors

# Numerics (decimals)
x <- 4.5
# Integers
x <- 4
# Boolean/logical values
x <- TRUE
# Text/character
x <- "hello"

# To check the data type use the class() function 
# To create a vector:
x <- c(4.5, 4, TRUE, "hello")
x <- c(1, 2, 3, 4)
x <- c("a", "b", "c")
x <- c(TRUE, FALSE)

# Naming a vector
# ex 1
vector_info <- c("Mason Wong", "Data analyst")
vector_titles <- c("Names", "professions")
names(vector_info) <- vector_titles
# ex 2
week_1_paycheck <- c(1, 2, 3, 4, 5)
week_2_paycheck <- c(2, 5, 7, 8, 9)
days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
names(week_1_paycheck) <- days
names(week_2_paycheck) <- days
# vector selection
# Note that 1:4 = c(1, 2, 3, 4)
week_1_paycheck[1:4]
week_1_paycheck[c("Monday", "Tuesday")]
# Selecting from a vector based off inequality
x <- c(12, 5, 15, 37, 3, 2, 90, 55)
y <- x > 20
x[y] # Find all the elements greater than 20 in x. alternatively just do x[x > 20]

#---- Section 2: Matrices ----
# Make a matrix
A <- matrix(1:9, nrow = 3, byrow = FALSE) # goes down to fill
A
B <- matrix(1:9, nrow = 3, byrow = TRUE) # goes right to fill
B

# example with movies: first pos = revenue in Australia. Second pos = revenue overseas
movie_1 <- c(123, 455)
movie_2 <- c(347, 885)
movie_3 <- c(245, 333)
A <- matrix(c(movie_1, movie_2, movie_3), nrow = 3, ncol = 2, byrow = TRUE)

# You can add names to matrices:
location <- c("Australia", "overseas")
movie_names <- c("A", "B", "C")
colnames(A) <- location
A
rownames(A) <- movie_names
A

# Adding columns to matrices
one_to_nine <- matrix(1:9, nrow = 3, byrow = FALSE)
big_matrix <- cbind(A, one_to_nine)
big_matrix
colnames(big_matrix) <- c(location, "one", "four", "seven")
big_matrix

# Adding rows to matrices
# adding a row to the bottom: 5 equally spaced points from 0 to 1
# and adding a row which has values from 95 to 115 up by 5 each time
bigger_matrix = rbind(big_matrix, seq(0, 1, length.out = 5))
bigger_matrix
even_bigger_matrix = rbind(bigger_matrix, seq(from = 95, to = 1000, by = 5)[1:5])
even_bigger_matrix
rownames(even_bigger_matrix) <- c(movie_names, "D", "E")
even_bigger_matrix

# Selecting matrix elements
even_bigger_matrix[1, 2] # single element
even_bigger_matrix[1:3, 2:4] # section of rows 1 to 3 and columns 2 to 4
even_bigger_matrix[ , 1] # Every row, first column ==> get first column
even_bigger_matrix[1, ] # Every column, first row ==> get first row
even_bigger_matrix[-1, ] # Every row EXCEPT the first, Every column ==> exclude first row

# Note * : Mat_2(R) x Mat_2(R) -> Mat_2(R) is element-wise multiplication
# and %*%: Mat_2(R) x Mat_2(R) -> Mat_2(R) is matrix multiplication

#---- Section 3: factors ----
# The factor function recognises there are two levels. 
sex_vector <- c("Male","Female","Female","Male","Male")
factor_sex_vector <- factor(sex_vector)

# Categorial variables: nominal vs ordinal
# nominal
animals <- c("Elephant", "Giraffe", "Donkey", "Horse")
animal_factors <- factor(animals)
# ordinal
temperature <- c("High", "Middle", "Low", "Low", "Middle", "High")
temperature_factors <- factor(temperature, ordered = TRUE, labels = c("Low", "Middle", "High"))

# Changing factor levels naming
sexes <- c("M", "F", "M", "F", "M", "F", "F", "F")
sexes_factor <- factor(sexes, labels = c("f", "m")) # Maps F->f and M->m
levels(sexes_factor) <- c("Female", "Male") # Maps f -> Female and m -> Male

# summarising a factor: summary()
summary(sexes_factor)
summary(temperature_factors)
summary(animal_factors)

# comparing factor elements (only in ordinal)
speed <- c("medium", "slow", "slow", "medium", "fast")
speed_factors <- factor(speed, ordered = TRUE, levels = c("slow", "medium", "fast"))
speed_factors

#---- Section 4: Data frames ----
# Data frame has columns as variables and rows as the observations
# a built in R data frame
mtcars
# use head() or tail() to see the first few observations. 
head(mtcars, n = 3)
tail(mtcars, n = 1)
# use str() to show a quick summary of your data frame. It shows:

# The total number of observations (e.g. 32 car types)
# The total number of variables (e.g. 11 car features)
# A full list of the variables names (e.g. mpg, cyl … )
# The data type of each variable (e.g. num)
# The first few observations
str(mtcars)

# We create our own data frame by concatenating vectors and using the data.frame() function
names <- c("Alice", "Bob", "Jim", "Hannah", "Bill")
age <- c(23, 44, 18, 28, 34)
ID <- c(1234, 5554, 2331, 4444, 7890)
row_names <- c("Participant 1", "Participant 2", "Participant 3", "Participant 4", "Participant 5")
person_df <- data.frame(names, age, ID, row.names = row_names)

# Accessing elements of data frames
person_df # print out whole data frame
person_df[1, 1] # element-wise access
person_df[1:3, 1:2] # row and column access
person_df[-1, ] # Acessing everything execept the first row
person_df["Participant 1", c("names", "age")] # Acessing via row and column names (vars)
person_df[ , "ID"] # Accessing all ID's available ==> returns a row vector
person_df[ID > 3000, "names"] # Select all the people with ID's bigger than 3000
subset(person_df, subset = ID > 3000) # Perhaps people might like this more. It's a bit meh for me

# sorting data and sorting your data frame
temp0 <- c(34, 12, 55, 1, -1)
order(temp0)  # outputs the indices corresponding to the elements in ascending sorted order
sorted <- temp0[order(temp0)]

# We sort our data frame based on Age number
sorted_by_age_df <- person_df[order(age), ]

#---- Section 5: Lists ----
# my random data
my_vector <- 1:10 
my_matrix <- matrix(1:9, ncol = 3)
my_df <- mtcars[1:3,]

# making a list use the list() function
my_list <- list(my_vector, my_matrix, my_df)

# to name the data in your list: method 1
my_list_2 <- list("my vector data" = my_vector, "my matrix data" = my_matrix, "my data frame data" = my_df)
# method 2: use the names() function
my_list_3 <- list(my_vector, my_matrix, my_df)
names(my_list_3) <- c("vectors", "matrices", "data frames")

# Additional example
# data:
school <- "Ryde Secondary College"
students <- c("A", "B", "C")
bought_textbook <- c(TRUE , FALSE, FALSE)
price <- c(30, 60, 60)
my_df <- data.frame(students, bought_textbook, price)

my_list <- list("school" = school, "student info" = my_df)

# To access elements of a list, you use the [[num]] notation
my_list[[1]] # a string
my_list[[2]] # a data frame
my_list[[2]][ , "students"]
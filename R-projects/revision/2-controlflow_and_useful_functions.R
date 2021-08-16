#---- Section 1: conditionals evaluate to booleans----


x <- 3 != 6 # TRUE
x <- 2 > 6 # FALSE
x <- c(1, 2, 3, 4, 5)
x <- x >= 3 # c(FALSE, FALSE, TRUE, TRUE, TRUE)
x <- matrix(1:9, byrow = TRUE, ncol = 3)
x <- x == 9 # [F F F; F F F; F F T]

# Boolean rules & = and, | = or
x <- 3 > 5 | 5 > 3 # true
x <- 3 > 5 & 5 > 3 # false

# ex: matrices: views on a particular day
facebook <- c(17, 7, 5, 16, 8, 13, 14)
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
views <- rbind(facebook, linkedin)
views[1, ] > 10 & views[2, ] < 10 # find's the day which had >10 views for fb AND < 10 views for linkedin

# negation !
!(5 > 3) # <=> 5 <= 3

# example
day1 <- c(2 ,19 ,24 ,22 ,25 ,22 , 0 ,12 ,19 ,23 ,29 ,13 , 7 ,26 , 7 ,32 , 7 , 9 , 0 , 9 , 6 ,17 , 1 , 5 , 2 ,29 ,17 ,26 ,27 , 4 ,22 , 9 , 6 ,18 , 2 ,32 , 5 , 6 ,30 ,34 ,15 ,28 , 6 ,17 , 6 ,18 ,21 ,10 , 6 ,30)
day2 <- c(3 ,23 ,18 ,18 ,25 ,20 , 4 , 3 ,22 ,12 ,27 ,13 ,17 ,27 , 6 ,35 ,17 , 6 , 1 ,12 ,15 ,17 ,12 , 8 , 7 ,25 ,15 ,32 ,29 , 1 ,22 ,11 , 5 ,17 ,12 ,26 ,13 ,10 ,37 ,33 ,19 ,29 , 8 ,22 ,10 ,19 ,27 ,18 ,15 ,28)
day3 <- c(3 ,18 ,15 ,27 ,26 ,29 , 2 ,15 ,22 ,19 ,23 ,20 , 9 ,28 , 4 ,31 , 9 , 3 ,11 , 6 ,15 ,12 , 8 , 0 , 5 ,32 ,17 ,33 ,24 , 1 ,17 , 7 ,12 ,12 ,13 ,20 ,12 ,11 ,32 ,32 ,21 ,30 , 6 ,27 ,17 ,22 ,28 ,20 ,15 ,29)
day4 <- c(6 ,22 ,19 ,26 ,31 ,26 , 2 , 7 ,19 ,25 ,25 ,17 , 5 ,36 ,11 ,35 ,12 ,12 , 6 ,13 ,10 , 4 , 2 , 1 , 3 ,28 ,23 ,30 ,29 , 2 ,20 ,10 , 5 ,22 , 7 ,23 ,11 , 6 ,35 ,35 ,18 ,19 , 7 ,24 ,18 ,17 ,28 ,18 ,15 ,31)
day5 <- c(4 ,23 ,18 ,19 ,24 ,23 , 3 , 1 ,25 ,18 ,29 ,12 ,11 ,29 , 5 ,24 ,13 , 3 , 0 ,12 , 9 ,14 , 4 , 6 , 1 ,28 ,23 ,33 ,26 , 1 ,14 , 8 ,17 ,22 ,10 ,24 , 6 , 6 ,37 ,33 ,22 ,21 ,17 ,18 ,13 ,21 ,26 ,12 ,10 ,24)
day6 <- c(2 ,29 ,22 ,21 ,36 ,22 , 4 ,15 ,24 ,22 ,30 ,22 , 9 ,31 , 5 ,25 , 6 , 8 , 4 ,13 , 7 ,17 , 4 , 3 , 5 ,27 ,17 ,28 ,31 , 7 ,19 ,15 ,17 ,13 , 6 ,25 , 5 , 2 ,41 ,27 ,26 ,19 ,11 ,28 ,10 ,15 ,17 ,19 ,14 ,20)
day7 <- c(0,25,17,25,37,29, 2,11,23,22,17,20, 9,30,15,36,12, 6,11,11,18, 7,11, 1, 5,27,22,26,28, 4,13, 5, 4,12, 2,21,10, 5,42,35,22,26,14,24, 7,23,25,17, 2,25)
# row names for df
row_names = rep("0", 50)
for (i in 1:50) {
  row_names[i] <- paste("Employee", as.character(i))
}
employee_df = data.frame(day1, day2, day3, day4, day5, day6, day7, row.names = row_names)
tues <- employee_df[ , "day2"]
sum(tues[tues > 25 | tues < 5]) # Add all the numbers greater than 25 or less than 5 on tuesday

#---- Section 2: if statements ----
str <- "monday"
if (str == "monday") {
  print("first day!")
} else if (str == "tuesday") {
  print("second day!")
} else {
  print("One of the other days besides first or second day")
}

# & => element-wise AND for vectors
# && => takes FIRST ELEMENT of vector
# | => element-wise OR for vectors
# || => takes FIRST ELEMENT of vector

#---- Section 3: for loops and while loops ----
# while loop
i <- 1
while (i <= 10) {
  str <- sprintf("The value of i is %i", i)
  print(str, quote = FALSE)
  i <- i + 1
}

# for loop
marks <- c(16, 9, 13, 5, 2, 17, 14)
for ( m in marks ) {
  if (m >= 10) {
    cat(sprintf("Good job! You passed and got %i\n", m))
  } else {
    if (m <= 5) {
      cat(sprintf("The score is too embarrasing to print out!\n"))
      next;
    }
    cat(sprintf("Better luck next time buddy, you were %i off passing\n", 10 - m))
  }
}

#---- Section 4: Writing own functions----
printf <- function(...) {
  cat(sprintf(...))
}
# I've added this to the ~/.Rprofile
#---- Section 5: apply functions ----
# lapply() : Takes list or vector X and applies 
maths_people <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
maths_people_list <- strsplit(maths_people, split = ":")
maths_people_list_lower_case <- lapply(maths_people_list, tolower) # returns a list

# ex 2: 
Australia <- list(pop = 4000, 
                  cities = c("Melbourne", "Sydney", "Orange", "Parkes"),
                  country = TRUE)
Australia
Australia_class <- lapply(Australia, class) # returns a vector of characters
Australia_class

#---- Section 6: apply and anonymous functions ----
my_list <- list("first person" = data.frame("mason", 22), "second person" = data.frame("mathew", 23), "third person" = data.frame("mandy", 25))

names(my_list[[1]])[names(my_list[[1]]) == "X.mason."] <- "name"
names(my_list[[1]])[names(my_list[[1]]) == "X22"] <- "age"

names(my_list[[2]])[names(my_list[[2]]) == "X.mathew."] <- "name"
names(my_list[[2]])[names(my_list[[2]]) == "X23"] <- "age"

names(my_list[[3]])[names(my_list[[3]]) == "X.mandy."] <- "name"
names(my_list[[3]])[names(my_list[[3]]) == "X25"] <- "age"

# anonymous function (Just leave out name) and fill out definition
name_of_people <- lapply(my_list, function(x) { return (x[1])})
ages_of_people <- lapply(my_list, function(x) { return (x[2])})

# Using lapply with additional arguments
multiply <- function(x, factor) {
  x * factor
}
lapply(list(1,2,3), multiply, factor = 3)

# if you don't want your screen to be flooded with output, instead of 
# using return, use the invisible() function which prints to screen when you assing it.
copy_one_thousand <- function(x) {
  invisible(rep(x, 1000))
}

#----Section 6: sapply()----
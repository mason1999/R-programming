# File:   Factors.R
# Course: R: An Introduction (with RStudio)

# CREATE DATA ##############################################

(x1 = 1:3)
(y  = 1:9)

# Combine variables
# cbind.data.frame is equivalent to as.data.frame(cbind(x1, y)). Note how
# cbind() will automatically replicate x 3 times so that it's the same size as y
# str() gets the structure of the data frame
(df1 = cbind.data.frame(x1, y))
typeof(df1$x1)
str(df1)

# AS.FACTOR ################################################

(x2  = as.factor(c(1:3)))
(df2 = cbind.data.frame(x2, y))
typeof(df2$x2)
str(df2)

# DEFINE EXISTING VARIABLE AS FACTOR #######################
# We take an exisiting variable and turn it into a factor

# The third line of code reclassifies x3 as a factor and puts it back where
# df3$x3 was
(x3  = c(1:3))
(df3 = cbind.data.frame(x3, y))
(df3$x3 = factor(df3$x3,
  levels = c(1, 2, 3)))
typeof(df3$x3)
str(df3)

# LABELS FOR FACTOR ########################################
# Redefine the levels 1, 2 and 3 with labels "mac", "windows" and "linux"
(x4  = c(1:3))
(df4 = cbind.data.frame(x4, y))
(df4$x4 = factor(df4$x4,
  levels = c(1, 2, 3),
  labels = c("macOS", "Windows", "Linux")))
df4
typeof(df4$x4)
str(df4)

# ORDERED FACTORS AND LABELS ###############################

(x5  = c(1:3))
(df5 = cbind.data.frame(x5, y))
(df5$x5 = ordered(df5$x5,
  levels = c(3, 1, 2),
  labels = c("No", "Maybe", "Yes")))
df5
typeof(df5$x5)
str(df5)

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

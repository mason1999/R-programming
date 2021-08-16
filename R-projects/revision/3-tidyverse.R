#---- Section 1: data wrangling (dplyr) ----
# install.packages("gapminder")
library(gapminder)
library(dplyr)
gapminder
head(gapminder)
str(gapminder)

# REMEMBER THAT VARIABLES ARE THE COLUMNS IN DATA FRAMES!

# filtering your data: filter based off a condition on a variable
gapminder %>% filter(year == 2007) # takes the condition to filer on as the argument
gapminder %>% filter(country == "United States")
gapminder %>% filter(country == "United States", year == 1952) # can do multiple conditions. Equivalent to an AND statement
gapminder %>% filter(country == "China", year == 2002)

# Sorting your data: sort data based off a variable 
gapminder %>% arrange(gdpPercap)
gapminder %>% arrange(desc(gdpPercap))
gapminder %>% filter(year == 2007) %>% arrange(gdpPercap) # filtering by 2007 and arranging data via perCapita

# mutating your data: change a variable OR add a new variable
gapminder %>% mutate(pop = pop/1000000) # change existing variable
gapminder %>% mutate(gdp = gdpPercap * pop) # add new variable called gdp

# Question: find the net gdp of all countries in 2007
gapminder %>% filter(year == 2007) %>% mutate(gdp = gdpPercap * pop) %>% arrange(gdp)
#---- Section 2: ggplot2 (scatter plots and basics) ----
library(gapminder)
library(dplyr)
# subset gapminder data set
gapminder_2007 <- gapminder %>% filter(year == 2007)
# load the library
library(ggplot2)
# Plot from the gapminder_2007 data set, adding aesthetics and layer
gapminder_2007 %>% ggplot() + aes(x = gdpPercap, y = lifeExp) + geom_point() + scale_x_log10()

# Log scales 
gapminder_1952 <- gapminder %>% filter(year == 1952)
gapminder_1952 %>% ggplot() + aes(x = pop, y = gdpPercap) + geom_point() + scale_x_log10() + scale_y_log10()

# color and size aesthetic : add this to aes. 
# continent is categorical variable (i.e factor)
# pop is a numerical one
gapminder_1952 <- gapminder %>% filter(year == 1952)
gapminder_1952 %>% ggplot()+ 
  aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)+
  geom_point() + 
  scale_x_log10()

gapminder_2002 <- gapminder %>% filter(year == 2002)
gapminder_2002
gapminder_2002 %>% ggplot() + 
  aes(x = pop, y = lifeExp, color = continent, size = gdpPercap) +
  geom_point() + 
  scale_x_log10()

# faceting: you can divide your plot into subplots/subgraphs
# do this with facet_wrap(~ var) where var = the variable you want to divide by
gapminder_1997 <- gapminder %>% filter(year == 1997)
gapminder_1997 %>% ggplot()+
  aes(x = pop, y = lifeExp, color = continent)+
  geom_point()+
  scale_x_log10()+
  facet_wrap(~ continent)

# Faceting by year:
gapminder %>% ggplot()+
  aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)+
  scale_x_log10()+
  geom_point()+
  facet_wrap(~ year)
#---- Section 3: verbs summmarise()----
library(dplyr)
library(gapminder) 
# verbs include filter(), summarise(), group_by()

# summarise: the mean life expectancy in the US in 2007
gapminder %>% 
  filter(country == "United States", year == 2007) %>% 
  summarise(mean_life_exp = mean(lifeExp)) # make a new variable called mean_life_exp

# summarising into multiple columns (basically make anoter variable)
gapminder %>%
  filter(year == 2007, country == "United States") %>%
  summarise(mean_life_exp = mean(lifeExp), total_pop_millions = sum(pop)/1000000)

# functions include: mean, sum, median, mean and max

# We find the median life expectancy and mean gdpPercap in 1957 in the US
gapminder %>%
  filter(year == 1957, country == "United States") %>%
  summarise(meadian_life_expectancy = median(lifeExp), mean_gdp_per_cap = mean(gdpPercap))

#---- Section 4: group_by() verb ----
# The group_by() verb takes an existing tbbl and converts it into a GROUPED TBBL
# where operations are performed "by group". the ungroup() removes grouping
library(dplyr)
library(gapminder)
# summarise the gapminder data, treating the whole table as one group
gapminder %>% 
  filter(year == 2007) %>%
  summarise(mean_life_exp = mean(lifeExp), total_pop = sum(pop))

# summarise the gapminder data, partitioning the table into smaller groups
gapminder %>%
  group_by(year) %>% 
  summarise(mean_life_exp = mean(lifeExp), total_pop = sum(pop))

# find the average life expectancy and total population, grouped by continent
gapminder %>%
  group_by(continent) %>%
  summarise(mean_life_exp = mean(lifeExp), total_pop = sum(pop))

# Do the same thing but only for 2007
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarise(mean_life_exp = mean(lifeExp), total_pop = sum(pop))

# We now group by year and continent (we can see how things change over time)
gapminder %>%
  group_by(continent, year) %>%
  summarise(mean_life_exp = mean(lifeExp), total_pop = sum(pop))

#---- Section 5: visualizing summarized data ----
library(gapminder)
library(dplyr)
library(ggplot2)
# ex 1: summarise the gapminder df by grouping into years and then obtaining the mean life expectancy and total poputlation 
by_year <- gapminder %>% 
  group_by(year) %>% 
  summarise(total_pop = sum(pop), mean_life_exp = mean(lifeExp)) 
# plot a scatter plot using the ggplot
by_year %>% ggplot() +
  aes(x = year, y = total_pop) + 
  geom_point() + 
  expand_limits(y = 0) # specify to have the y axis start at y = 0


# ex 2: summarising the data by year AND continent
by_year_and_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarise(total_pop = sum(pop), mean_life_exp = mean(lifeExp))
# plot
by_year_and_continent %>% ggplot() + 
  aes(x = year, y = total_pop, color = continent) + 
  geom_point() + 
  expand_limits(y = 0)

# ex 3: summarise the median life expectancy and max gdp per capita
by_year <- gapminder %>%
  group_by(year) %>%
  summarise(med_life_exp = median(lifeExp), max_gdp_per_cap = max(gdpPercap))
by_year %>% ggplot() + 
  aes(x = year, y = med_life_exp) + 
  geom_point() + 
  expand_limits(y = 0)

# ex 4: 
by_year_and_continent <- gapminder %>% 
  group_by(continent, year) %>%
  summarise(med_gdp_per_cap = median(gdpPercap))
by_year_and_continent %>% ggplot() + 
  aes(x = year, y = med_gdp_per_cap, color = continent) + 
  geom_point() + 
  expand_limits(y = 0)

# ex 5: 
by_continent_2007 <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarise(median_gdpPercap = median(gdpPercap), median_lifeExp = median(lifeExp)) 
by_continent_2007 %>% ggplot() +
  aes(x = median_gdpPercap, y = median_lifeExp, color = continent) + 
  geom_point()

#---- Section 6: line plots (change over time) ----
library(gapminder)
library(dplyr)
library(ggplot2)
# These are basically line scatter plots except geom_point() --> geom_line()

# ex 1: find the median gdpPercap within each year and create a line plot
# graphing the change in median gdpPercap over time as a line graph and make
# sure to show the origin
by_year <- gapminder %>% 
  group_by(year) %>%
  summarise(median_gdp_per_cap = median(gdpPercap))
by_year %>% ggplot() + 
  aes(x = year, y = median_gdp_per_cap) + 
  geom_line() + 
  expand_limits(y = 0)

# ex 2: find the median gdpPercap within each year and continent and plot a line
# plot showing the change of median gdpPercap over time with the continents colorcoded
by_year_and_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarise(median_gdp_per_cap = median(gdpPercap))
by_year_and_continent %>% ggplot() +
  aes(y = median_gdp_per_cap, x = year, color = continent) +
  geom_line() + 
  expand_limits(y = 0)
#---- Section 7: Bar plots (compare statistics for several categories) ----
library(gapminder)
library(dplyr)
library(ggplot2)

# find the average life expectancy of each continent in 2007
by_continent <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarise(average_life_expectancy = mean(lifeExp))

# x is categorical variable, y is the variable determining height of the bars
# Note how bar plots always start at zero. 
by_continent %>% ggplot() + 
  aes(x = continent, y = average_life_expectancy) + 
  geom_col()

# ex 1: find median gdp in each continent in the year 1952. Plot your findings
# on a bar plot with continent as x categorical variable and y as the median 
# gdp per capita
median_gdpPercap_by_continent <- gapminder %>%
  filter(year == 1952) %>%
  group_by(continent) %>%
  summarise(median_gdp = median(gdpPercap))

median_gdpPercap_by_continent %>% ggplot() +
  aes(x = continent, y = median_gdp) + 
  geom_col()
  
# ex 2: filter for observations in the Oceania continent in the year 1952 and
# plot a bar chart with countries as the x axis and gdpPercap as the y axis
by_country_gdp_1952 <- gapminder %>% filter(year == 1952, continent == "Oceania") %>%
  group_by(country)

by_country_gdp_1952 %>% ggplot() +
  aes(x = country, y = gdpPercap) + 
  geom_col()

#---- Section 8: Histograms (distribution of one dimension numeric variable) ----
library(gapminder)
library(dplyr)
library(ggplot2)
# only one asesthetic: the x axis
# can customize the binwidth with geom_histogram(binwidth = something)

# ex 1: filter the data set by the year 1952 and create a new variable which
# represents the population in millions. Next create a histogram of population
# by the millions
data_1952 <- gapminder %>% 
  filter(year == 1952) %>%
  mutate(pop_millions = pop/1000000)
data_1952
data_1952 %>% ggplot() + 
  aes(x = pop_millions) + 
  geom_histogram(bins = 50)

# ex 2: exact same as ex 1 except we put a log scale for the x axis
data_1952 <- gapminder %>% 
  filter(year == 1952) %>%
  mutate(pop_millions = pop/1000000)
data_1952
data_1952 %>% ggplot() + 
  aes(x = pop_millions) + 
  scale_x_log10() + 
  geom_histogram(bins = 50)
#---- Section 9: boxplots (compare distribution of numeric variables among several categories)----
# boxplots allow you to compare the distribution of one variable among say different continents
gapminder_2007 <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent)
gapminder_2007 %>% ggplot() + 
  aes(x = continent, y = lifeExp) + # the x is categorical and y is the numerical variable
  # I interpret it as a sort of "sideways distribution"
  geom_boxplot()

# ex 1: compare the gdp per capita among continents by comparing box plots
gapminder_1952 <- gapminder %>%
  filter(year == 1952) %>%
  group_by(continent)

gapminder_1952 %>% ggplot() + 
  aes(x = continent, y = gdpPercap) + 
  geom_boxplot() + 
  scale_y_log10()

# ex 2: Adding a title to your box plots
  
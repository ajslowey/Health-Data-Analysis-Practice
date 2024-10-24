
library("gapminder")
library("dplyr")
library("ggplot2")

#assign gapminder dataset as gapminder variable
gapminder <- gapminder

# contains pipe (%>%) that connects gapminder dataset and slice function
gapminder %>% 
#slice selects rows of data from dataset
  slice(1:4)

#shows details about dataset (num of variables, rows, type of variable)
glimpse(gapminder)

#looks at frequencies and central tendencies and dispersion
summary(gapminder)

#-------------Basic Plots-----------------------
 #BASIC SCATTER
#set data for graph as gapminder
ggplot(data = gapminder) +
#geom_point for scatter plot with x and y variables from data
#aes function allows for the mapping of x and y and "+" connects functions
  geom_point(mapping = aes(x = year, y = lifeExp)) +
  theme_bw()
#theme is purely for looks, can be adjusted whenever


#ADDING MORE VARIABLES TO A SCATTER

###Scatter plot with third variable by color###
ggplot(data = gapminder) +
  geom_point(mapping = aes(x = year, 
                           y = lifeExp, 
                           colour = continent)) +
  theme_bw()
  #European countries have a high life expectancy
  #African countries have a lower life expectancy
  #One country in Africa looks like an outlier (very low life expectancy)
  #One country in Asia looks like an outlier (very low life expectancy)

#Scatter plot with third variable by size
ggplot(data = gapminder) +
  geom_point(mapping = aes(x = year, 
                           y = lifeExp, 
                           size = gdpPercap)) +
  theme_bw()
  #Higher gdpPercap indicates a higher life expectancy

###Scatter plot with third variable by shape and spacing###

ggplot(data=gapminder) +
  geom_jitter(mapping = aes(x=year,
                            y=lifeExp,
                            shape=continent),
                            width = 0.75, alpha =0.5) +
  theme_bw()
  
  #Jitter disperses points away from each other, alpha sets opacity

###Shape parameter can also be changed with shape argument###

ggplot(data = gapminder) +
  geom_point(mapping = aes(x = year, y = lifeExp), 
             shape = 3) +
  theme_bw()
 
#?pch can show what shape codes exist

#-------------Making Sub Plots-----------------------
#You can split plots based on a factor variable and make subplots using facet().

###Scatter plot split by continent###

ggplot(data = gapminder) +
  geom_point(mapping = aes(x = year, y = lifeExp)) + 
  facet_wrap(~ continent, nrow = 3) +
  theme_bw()
#nrow refers to rows of plots in the output

#-------------Overlaying Plots-----------------------

###Scatter plot### 
ggplot(data = gapminder) +
  geom_point(mapping = aes(x = gdpPercap, y = lifeExp)) +
  theme_bw()

###Smooth line plot###
ggplot(data = gapminder) +
  geom_smooth(mapping = aes(x = gdpPercap, y = lifeExp)) +
  theme_bw()

# `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
  #gam meaning Generalized Additive Model for smoothing
  #formula specifies how smoothing is occurring
  #geo_smooth with GAM is best for relationships that are non linear, allows for
  #more complex modeling

###Smooth line plot with skewness reduction and linetype###
ggplot(data = gapminder) +
  geom_smooth(mapping = aes(x = log(gdpPercap), 
                            y = lifeExp, 
                            linetype = continent)) +
  theme_bw()

#geom_smooth()` using method = 'loess' and formula = 'y ~ x'
  #LOESS is a non-parametric method that fits multiple regressions in local
  #neighborhoods of the data, allowing for flexible, non-linear relationships

###Smooth line plot with color###
ggplot(data = gapminder) +
  geom_smooth(mapping = aes(x = log(gdpPercap), 
                            y = lifeExp, 
                            colour = continent)) +
  theme_bw()

#-------------Combining Different Plots-----------------------
#We can combine more than one geoms (type of plots) to overlay plots.
#The trick is to use multiple geoms in a single line of R code:

###Scatter and Line Smoothing Plot###
ggplot(data = gapminder) +
  geom_point(mapping = aes(x = log(gdpPercap), y = lifeExp)) +
  geom_smooth(mapping = aes(x = log(gdpPercap), y = lifeExp)) +
  theme_bw()

#Condense the above code by passing mapping to ggplot
ggplot(data = gapminder, 
       mapping = aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point() +
  geom_smooth() +
  theme_bw()

#You can adjust these combinations to include line type, color, shape, etc

###Shapes###
ggplot(data = gapminder, 
       mapping = aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(mapping = aes(shape = continent)) +
  geom_smooth() +
  theme_bw()

###Line Types###
ggplot(data=gapminder, mapping=aes(x=log(gdpPercap), y=lifeExp)) +
  geom_point() + 
  geom_smooth(mapping = aes(linetype = continent)) +
  theme_bw()

###Line Types and Shapes###
ggplot(data=gapminder, mapping = aes(x = log(gdpPercap), y=lifeExp)) +
  geom_point(mapping = aes(shape=continent)) +
  geom_smooth(mapping = aes(linetype=continent)) +
  theme_bw()

#-------------Statistical Transformation-----------------------
###Bar chart with continent and its frequency###
ggplot(data=gapminder) +
  geom_bar(mapping = aes(x=continent)) +
  theme_bw()

###Bar char with continent proportion###
ggplot(data=gapminder) +
  geom_bar(mapping = aes(x=continent, y=after_stat(count/sum(count)), group=1))

  #After_stat allows for transformation of computed count into proportions
  #Group = 1 ensures that all bars are treated as part of a single group; Needed
  #when calculating proportions

###More elaborate proportion chart###
gapminder2 <- 
  gapminder %>%
  #dplyr recognizes that we are counting continents, so it adds column "n" to df
  count(continent) %>%
  #mutate recognizes added "n" and does computations and adds perc column
  mutate(perc=n/sum(n)*100)

#Initialize plot with x and y, and fill of bar different for each continent
pl <- ggplot(data=gapminder2, aes(x = continent, y = n, fill = continent)) 

#Create bar chart and use color scale
pl <- pl + geom_col() + scale_fill_grey(start = 0, end = .9)

#Adds labels to bars; paste0 combines "n" and "perc
#Vjust positions text above bar
pl <- pl + geom_text(aes(x = continent, y = n,
                         label = paste0(n, " (", round(perc, 1), "%)"),
                         vjust = -0.5))
#Set theme of plot
pl <- pl + theme_classic()
#Set title of plot
pl <- pl + labs(title = "Bar chart showing counts and percentages")
pl

#-------------Customizing Titles-----------------------
mypop <- ggplot(data=gapminder, mapping = aes(x=log(gdpPercap),
                                              y=lifeExp,
                                              shape=continent)) +
  geom_point(alpha = 0.4) +
  #SE indicated if confidence interval around smoothing line is displayed
  geom_smooth(mapping = aes(color=continent), se=FALSE)

mypop

#Adding a title with ggtitle

mypop + ggtitle("GDP (in log) and life expectancy")

#Adding a multiple line title

mypop <- mypop + ggtitle("GDP (in log) and life expectancy:
                \nData from Gapfinder")
#Adding axis titles
mypop + 
  ylab("Life Expentancy") + 
  xlab("Percapita GDP in log")

#-------------Customizing Themes-----------------------
mypop <- mypop + theme_grey()
mypop


#-------------Adjusting Axes---------------------------
#Adjusting axes tick marks

mypop <- mypop + 
  scale_x_continuous(breaks = seq(0,12,1)) +
  scale_y_continuous(breaks = seq(0,90,10)) 
mypop

#-------------Facet Wrap with Adjustments---------------------------
ggplot(data = gapminder, 
       mapping = aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(alpha = 0.4) +
  geom_smooth(mapping = aes(line =  continent), se = FALSE) +
  facet_wrap(~ continent) +
  ylab("Life Expentancy") + 
  xlab("Percapita GDP in log") +
  theme(legend.position="none") +
  theme_bw()


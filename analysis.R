%%R

not.installed = function(package_name)  !is.element(package_name, installed.packages()[,1])

if (not.installed("RCurl")) install.packages("RCurl")
if (not.installed("plyr")) install.packages("plyr")
if (not.installed("ggplot2")) install.packages("ggplot2")

library(RCurl)
library(plyr)
library(ggplot2)

companies = read.csv("/Users/raghav297/dropbox/Documents/UCLA/UCLA_Spring_14/CS249/Crunchbase/Data/companies.csv")
additions = read.csv("/Users/raghav297/dropbox/Documents/UCLA/UCLA_Spring_14/CS249/Crunchbase/Data/additions.csv")
acquisitions = read.csv("/Users/raghav297/dropbox/Documents/UCLA/UCLA_Spring_14/CS249/Crunchbase/Data/acquisitions.csv")
investments = read.csv("/Users/raghav297/dropbox/Documents/UCLA/UCLA_Spring_14/CS249/Crunchbase/Data/investments.csv")
rounds = read.csv("/Users/raghav297/dropbox/Documents/UCLA/UCLA_Spring_14/CS249/Crunchbase/Data/rounds.csv")

#comparison = ddply(additions, .(content, quarter_str), summarize, total = sum(value))
#print(qplot(quarter_str, total, data= additions, geom = "histogram") + facet_wrap(~ content))
head(additions)

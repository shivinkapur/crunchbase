
library(plyr)
library(reshape
library(reshape2)
features=read.csv("features.csv", header=TRUE)

#frequency of company categories
#total funding per category
#frequency of status
#histogram of founded year

all_companies=read.csv("all_companies.csv", header=TRUE)

# no of companies per rounds
# no of companies in each labelNum
# funding rounds for different years
fundingYearRoundRaised=data.frame(features[,11], features[,10], features[,12])
colnames(fundingYearRoundRaised)=c("funding_year", "funding_round", "raised_amount")

#counting per round for each year
fundingYearRoundRaised=ddply(fundingYearRoundRaised,
 .(funding_year, funding_round), summarize, counts=length(funding_round), total_funding=sum(raised_amount))

#pivoting table
#fundingYearRoundCounts=cast(fundingYearRound, funding_year~funding_round, mean)

#plotting
colnames(fundingYearRoundRaised)=c("funding_year", "funding_round", "no_of_companies", "total_funding")
qplot(funding_year, total_funding, #size=no_of_companies, 
	colour = funding_round, data = fundingYearRoundRaised, geom = "line")

##
fundingYearQRaised=data.frame(features[,11], features[,13], features[,12])
colnames(fundingYearQRaised)= c("funding_year", "funding_quarter", "raised_amount")
fundingYearQRaised= ddply(fundingYearQRaised,
 .(funding_year, funding_quarter), summarize, no_of_companies=length(funding_quarter), total_funding=sum(raised_amount))
qplot(funding_year, total_funding, size=no_of_companies, colour=funding_quarter, data=fundingYearQRaised, geom = "line")


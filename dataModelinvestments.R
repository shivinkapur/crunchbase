not.installed = function(package_name)  !is.element(package_name, installed.packages()[,1])

if (not.installed("RCurl")) install.packages("RCurl")
if (not.installed("plyr")) install.packages("plyr")
if (not.installed("ggplot2")) install.packages("ggplot2")
if (not.installed("scatterplot3d")) install.packages("scatterplot3d")
if (not.installed("plot3D")) install.packages("plot3D")


library(RCurl)
library(plyr)
library(ggplot2)
library(plot3D)
library(scatterplot3d)

investments= read.csv('/Users/shivinkapur/Desktop/Crunchbase/crunchbase/Data/investments.csv')
dim(investments)

investments=data.frame(investments)
summary(investments)

investments$raised_amount_usd= as.numeric(investments$raised_amount_usd)

unique(investments$company_category_code)
investments.web=subset(investments,company_category_code=='web')
head(investments.web)
dim(investments.web)

investments2 <- investments.web[,c(2,19,20)]
head(investments2)
dim(investments2)
length(unique(investments2$company_name))


#web.company.funds= ddply(investments2, .(company_name), total=sum(raised_amount_usd))
#web.company.funds= na.omit(web.company.funds)
#head(web.company.funds)
#dim(web.company.funds)

web.company.funds.new= ddply(investments2, .(company_name,funded_year),summarize, total=sum(raised_amount_usd))
web.company.funds.new= na.omit(web.company.funds.new)
head(web.company.funds.new)
dim(web.company.funds.new)
tail(web.company.funds.new)


#Top 100 Companies
web.company.funds= ddply(investments2, .(company_name),summarize, total=sum(raised_amount_usd))
web.company.funds= na.omit(web.company.funds)
head(web.company.funds)
dim(web.company.funds)

sort_count = sort(web.company.funds$total, decreasing=TRUE)[1:100]
top100=subset(web.company.funds,web.company.funds$total %in% sort_count)
head(top100)

comapnies_Top20=top100[1:20,]$comapny_name
Top20=subset(web.company.funds.new, web.company.funds.new$comapny_name %in% comapnies_Top20)
print(qplot(funded_year, total, data = web.company.funds.new
            , color=company_name, geom = "line")+facet_wrap(~company_name))

Aereo=subset(web.company.funds.new, web.company.funds.new$company_name=="Aereo")

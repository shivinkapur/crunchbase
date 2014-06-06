rounds = read.csv("rounds.csv")
investments = read.csv("investments.csv")
acquisitions = read.csv("acquisitions.csv")
companies = read.csv("companies.csv")

comp_rounds = merge(companies, rounds, by.x = "name", by.y = "company_name")
comp_rounds_inv = merge(comp_rounds, investments, by.x = "name", by.y = "company_name")
write.csv(comp_rounds_inv, "all_data.csv")

all_companies = comp_rounds_inv[c(1:12, 15, 42:54)]

addLabel <- function(val) {
 	label = ""
 	labelNum = 0
 	if(val < 150000) {
 		label = "very low"
 		labelNum = 1
 	} else if(val >= 150000 && val < 839718) {
 		label = "low"
 		labelNum = 2
 	} else if(val >= 839718 && val < 2363486) {
 		label = "lower moderate"
 		labelNum = 3
 	} else if(val >= 2363486 && val < 6000000) {
 		label = "moderate"
 		labelNum = 4
 	} else if(val >= 6000000 && val < 14500000) {
 		label = "higher moderate"
 		labelNum = 5
 	} else if(val >= 14500000 && val < 43818650) {
 		label = "high"
 		labelNum = 6
 	} else {
 		label = "very high"
 		labelNum = 7
 	}
 	return(labelNum)
 }
 
 labelNum = c()
 for(i in all_companies_new$raised_amount_usd.y) {
 	labelNum = c(labelNum, addLabel(i))
 }
 all_companies_new$labelNum = labelNum
 head(all_companies_new)

features = all_companies_new[c(4,6,7,11,13,16,17,21,25,27,28)]
colnames(features)
# Feature names
# [1] "category_code"          "status"                 "country_code"           "funding_rounds"         "founded_year"          
# [6] "investor_category_code" "investor_country_code"  "funding_round_type.y"   "funded_year.y"          "quarters"
#[11] "labelNum"  
#features$funded_year.y = as.character(features$funded_year.y)

features = read.csv("features.csv")
features = features[c(2:4, 6:11,13,14)]

# Converts qualitative to quantitative
new_features = model.matrix(~., data=features)

install.packages("caret")
install.packages("kernlab")
library(caret)
library(kernlab)

# extract descriptors
new_features_2 = as.data.frame(new_features)
descr = new_features_2[c(1:288)]

# Check if predictors have zero variance
removeCol = nearZeroVar(descr)
new_descr = descr[-removeCol]
descr = new_descr

amount = as.character(new_features_2$labelNum)
amount = as.factor(amount)
set.seed(1)

inTrain <- createDataPartition(amount, p = 3/4, list = FALSE)

trainDescr <- descr[inTrain,]
testDescr  <- descr[-inTrain,]
trainClass <- amount[inTrain]
testClass  <- amount[-inTrain]
prop.table(table(amount))
prop.table(table(trainClass))

# Transform predictors since different type of predictor variables may be needed by models
xTrans <- preProcess(trainDescr)
trainDescr <- predict(xTrans, trainDescr)
testDescr  <- predict(xTrans,  testDescr)

set.seed(2)
svmFit <- train(trainDescr, trainClass, method = "svmRadial", tuneLength = 5, scaled = FALSE)


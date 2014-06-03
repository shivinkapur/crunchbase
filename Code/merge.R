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
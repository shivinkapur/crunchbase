acquisitions = read.csv('acquisitions.csv')
companies = read.csv('companies.csv')
investments = read.csv('investments.csv')
rounds = read.csv('rounds.csv')

rounds$raised_amount_usd = gsub(",","",rounds$raised_amount_usd)
rounds$raised_amount_usd = as.numeric(rounds$raised_amount_usd)

# Omit NAs from raised_amount_usd
new_rounds = rounds[complete.cases(rounds[,13]),]
new_rounds$quarters = gsub("([0-9]{4})-","", new_rounds$funded_quarter)

#Grouping
group_category_code = ddply(new_rounds, .(company_category_code), summarize, total_amount = sum(raised_amount_usd))
group_round_category = ddply(new_rounds, .(company_category_code, funding_round_type), summarize, total_amount = sum(raised_amount_usd))
group_category_country = ddply(new_rounds, .(company_category_code, company_country_code), summarize, total_amount = sum(raised_amount_usd))
group_country_round = ddply(new_rounds, .(funding_round_type, company_country_code), summarize, total_amount = sum(raised_amount_usd))
group_country_round_category = ddply(new_rounds, .(funding_round_type, company_country_code, company_category_code), summarize, total_amount = sum(raised_amount_usd))
group_country_year = ddply(new_rounds, .(funded_year, company_country_code), summarize, total_amount = sum(raised_amount_usd))
group_round_year = ddply(new_rounds, .(funded_year, funding_round_type), summarize, total_amount = sum(raised_amount_usd))
group_category_year = ddply(new_rounds, .(funded_year, company_category_code), summarize, total_amount = sum(raised_amount_usd))
group_category_year_round = ddply(new_rounds, .(funded_year, company_category_code, funding_round_type), summarize, total_amount = sum(raised_amount_usd))
group_category_quarter = ddply(new_rounds, .(company_category_code, quarters), summarize, total_amount = sum(raised_amount_usd))
group_round_quarter = ddply(new_rounds, .(funding_round_type, quarters), summarize, total_amount = sum(raised_amount_usd))

group_all = ddply(new_rounds, .(company_category_code, company_country_code, funding_round_type, funded_year), summarize, total_amount = sum(raised_amount_usd))

# Add label based on funding
addLabel <- function(val) {
	label = ""
	if(val < 150000) {
		label = "very low"
	} else if(val >= 150000 && val < 839718) {
		label = "low"
	} else if(val >= 839718 && val < 2363486) {
		label = "lower moderate"
	} else if(val >= 2363486 && val < 6000000) {
		label = "moderate"
	} else if(val >= 6000000 && val < 14500000) {
		label = "higher moderate"
	} else if(val >= 14500000 && val < 43818650) {
		label = "high"
	} else {
		label = "very high"
	}
	return(label)
}

for(i in group_all$total_amount) {
	label = c(label, addLabel(i))
}
group_all$label = label

library(igraph)
#install.packages("Matrix")
library(Matrix)

investments=read.csv("/Users/Work/Documents/CS249/project/crunchbase/Data/investments.csv", header=TRUE)
investments=na.omit(investments)

#print(head(investments))
print(dim(investments))

investor_company=data.frame(investments$investor_name, investments$company_name)
colnames(investor_company)=c("investor", "company")

#taking top1000 companies and investors based on total funding 
company_names_top1000=read.csv("company_names_top1000.csv", header=TRUE)
company_names_top110=company_names_top1000$name[1:150]
investor_companytop110=subset(investor_company, company %in% company_names_top110)
print(dim(investor_companytop110))
#write.csv(company_investor_top1000, "company_investor_top1000.csv")

company_names_top20=company_names_top1000$name[1:25]
investor_companytop20=subset(investor_company, company %in% company_names_top20)
print(dim(investor_companytop20))

company_names_top10=company_names_top1000$name[1:13]
investor_companytop10=subset(investor_company, company %in% company_names_top10)
print(dim(investor_companytop10))

#for top 5 companies, name[1:7]
#taking 5 random companies to find overlap graph (last section)
random_ind=sample(1000,5)
company_names_top110=company_names_top1000$name[random_ind]
investor_companytop110=subset(investor_company, company %in% company_names_top110)
print(dim(investor_companytop110))

#Using this dataframe 
investor_companytop110$investor= as.character(as.vector(investor_companytop110$investor))
investor_companytop110$company= as.character(as.vector(investor_companytop110$company))


#two mode incidence matrix to one mode adjacency matrix conversion

#incidence matrix
A= spMatrix(nrow=length(unique(investor_companytop110$investor)),
	ncol=length(unique(investor_companytop110$company)),
	i=as.numeric(factor(investor_companytop110$investor)),
	j=as.numeric(factor(investor_companytop110$company)),
	x=rep(1, length(as.numeric(investor_companytop110$investor)))  )

row.names(A)= levels(factor(investor_companytop110$investor))
colnames(A)= levels(factor(investor_companytop110$company))

iIC= graph.incidence(A, mode=c("all"))

#plot two-made graph
#check and change these index values everytime 
V(iIC)$color[1:571] <- rgb(1,0,0,.5) #investors 1:2136 for top1000 
V(iIC)$color[572:681] <- rgb(0,1,0,.5) #companies 2137:2967 for top1000

V(iIC)$label <- V(iIC)$name
V(iIC)$label.color <- rgb(0,0,.2,.5)
V(iIC)$label.cex <- .4
V(iIC)$size <- 6
V(iIC)$frame.color <- NA

E(iIC)$color <- rgb(.5,.5,0,.2)

pdf("iIC_top110companies.pdf")
plot(iIC, main="Two-mode incidence graph", layout=layout.fruchterman.reingold)
dev.off()

#clean the network by removing 1 degree edges
iIC <- delete.vertices(iIC, V(iIC)[ degree(iIC)==1 ]) 
V(iIC)$label[1:230] <- NA
V(iIC)$color[1:230] <-  rgb(1,0,0,.1)
V(iIC)$size[1:230] <- 2
 
E(iIC)$width <- .3
E(iIC)$color <- rgb(.5,.5,0,.1)
 
pdf("iIC_top110companies.2.pdf")
plot(iIC, main= "layout.kamada.kawai", layout=layout.kamada.kawai)
dev.off()
 
pdf("iIC_top110companies.3.pdf")
plot(iIC, main="layout.fruchterman.reingold.grid", layout=layout.fruchterman.reingold.grid)
dev.off()
 
#gives best plot : it really emphasizes centrality–the nodes that are most central 
#are nearly always placed in the middle of the plot
pdf("iIC_top110companies.4.pdf")
plot(iIC, main="layout.fruchterman.reingold", layout=layout.fruchterman.reingold)
dev.off()


#Working with adjacency matrix
print(head(A))
Arow= tcrossprod(A) #adjacency matrix for investors
print(head(Arow))

Acol=tcrossprod(t(A)) #adjacency matrix for companies
print(head(Acol))

#adjacency matrix of investors
Ainvestors= graph.adjacency(Arow, mode= "undirected") 

#we need to transform the graph so that multiply edges become an attribute
E(Ainvestors)$weight = count.multiple(Ainvestors)
Ainvestors = simplify(Ainvestors)

#setting plotting parameters
# Set vertex attributes
V(Ainvestors)$label = V(Ainvestors)$name
V(Ainvestors)$label.color = rgb(0,0,.2,.8)
V(Ainvestors)$label.cex = .6
V(Ainvestors)$size = 6
V(Ainvestors)$frame.color = NA
V(Ainvestors)$color = rgb(0,0,1,.5)
 
# Set edge gamma according to edge weight
egam <- (log(E(Ainvestors)$weight)+.3)/max(log(E(Ainvestors)$weight)+.3)
E(Ainvestors)$color <- rgb(.5,.5,0,egam)

pdf("Ainvestors_top110companies.pdf")
plot(Ainvestors, main = "layout.kamada.kawai", layout=layout.kamada.kawai)
plot(Ainvestors, main = "layout.fruchterman.reingold", layout=layout.fruchterman.reingold)
dev.off()

#jaccard similarity
jaccard.similarities= similarity.jaccard(Ainvestors)
pdf("Jaccard_Similarity_Investors.pdf")
heatmap(jaccard.similarities, symm=TRUE, main="J S of Investors (Top 20 Companies)",
	cexRow=0.5, cexCol=0.5)
dev.off()


#adjacency matrix of companies
Acompanies= graph.adjacency(Acol, mode= "undirected") 

#we need to transform the graph so that multiply edges become an attribute
E(Acompanies)$weight = count.multiple(Acompanies)
Acompanies = simplify(Acompanies)

#setting plotting parameters
# Set vertex attributes
V(Acompanies)$label = V(Acompanies)$name
V(Acompanies)$label.color = rgb(0,0,.2,.8)
V(Acompanies)$label.cex = .6
V(Acompanies)$size = 6
V(Acompanies)$frame.color = NA
V(Acompanies)$color = rgb(0,0,1,.5)
 
# Set edge gamma according to edge weight
egam <- (log(E(Acompanies)$weight)+.3)/max(log(E(Acompanies)$weight)+.3)
E(Acompanies)$color <- rgb(.5,.5,0,egam)

pdf("Acompanies_top110companies.pdf")
plot(Acompanies, main = "layout.kamada.kawai", layout=layout.kamada.kawai)
plot(Acompanies, main = "layout.fruchterman.reingold", layout=layout.fruchterman.reingold)
dev.off()


#jaccard similarity
jaccard.similarities= similarity.jaccard(Acompanies)
pdf("Jaccard_Similarity_Companies.pdf")
heatmap(jaccard.similarities, symm=TRUE, main="J S of Top 20 Funded Companies",
	cexRow=0.5, cexCol=0.5, col=blueyellow(64))
dev.off()

#heatmap for correlation between top 20 companies
library(ggplot2)
library(reshape2)
A=as.matrix(A)
m = melt(cor(A))
colnames(m)=c("Company1", "Company2", "value")
p <- ggplot(data=m, aes(x=Company1, y=Company2, fill=value)) + geom_tile()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
red=rgb(1,0,0); green=rgb(0,1,0); blue=rgb(0,0,1); white=rgb(1,1,1)
RtoWrange<-colorRampPalette(c(red, white ) )
WtoGrange<-colorRampPalette(c(white, green) )  
p <- p + scale_fill_gradient2(low=RtoWrange(100), mid=WtoGrange(100), high="gray")
p


#overlap graph for investors for 5 randomly sampled company names
olInvestors= Arow/diag(Arow)
olInvestors=as.matrix(olInvestors)
olInvestorsg= graph.adjacency(olInvestors, weighted=T)

#Degree
V(olInvestorsg)$degree= degree(olInvestorsg)

#Betweenness centrality
V(olInvestorsg)$btwcnt= betweenness(olInvestorsg)

#distribution of connection strength
plot(density(olInvestors), main="Distribution of Connection Strength")

#filter at 1 so that an edge will consists of investor overlap of more than 1 of the investor’s companies in question
olInvestors1 = olInvestors
#olInvestors1[olInvestors<0.5] = 0
olInvestor1g = graph.adjacency(olInvestors1, weighted=T)

#remove loops
olInvestor1g<- simplify(olInvestor1g, remove.multiple=FALSE, remove.loops=TRUE)

#hand placing nodes to make sure no labels overlap
olInvestor1g$layout <- layout.fruchterman.reingold(olInvestor1g)
V(olInvestor1g)$label <- V(olInvestor1g)$name
tkplot(olInvestor1g)

#save layout
olInvestor1g$layout <- tkplot.getcoords(6)

# Set vertex attributes
V(olInvestor1g)$label <- V(olInvestor1g)$name
V(olInvestor1g)$label.color <- rgb(250/256,128/256,114/256, 0.8)
V(olInvestor1g)$size <- 6
V(olInvestor1g)$frame.color <- NA
V(olInvestor1g)$color <- rgb(95/256,158/256,160/256,.5)
 
# Set edge attributes
E(olInvestor1g)$arrow.size <- .3
 
# Set edge gamma according to edge weight
egam <- (E(olInvestor1g)$weight+.1)/max(E(olInvestor1g)$weight+.1)
E(olInvestor1g)$color <- rgb(0.5,0.5,0,egam)

V(olInvestor1g)$label.cex <- degree(olAcqRegions1g)/(max(degree(olAcqRegions1g))) + 0.5
#note, unfortunately one must play with the formula above to get the
#ratio just right

pdf("olInvestor1gcustomlayout.pdf")
plot(olInvestor1g, main="Overlap Network of Investors")
dev.off()

####
#ACQUISITIONS AND COMPANIES

acquisitions=read.csv("/Users/Work/Documents/CS249/project/crunchbase/Data/acquisitions.csv", header=TRUE)
acquisitions=na.omit(acquisitions)
acquirer_company= data.frame(acquisitions$acquirer_name, acquisitions$company_name)
colnames(acquirer_company)=c("acquirer", "company")

acquirer_companytop1000= subset(acquirer_company, company %in% company_names_top1000$name)
dim(acquirer_companytop1000)


#two mode incidence matrix to one mode adjacency matrix conversion

#incidence matrix
A= spMatrix(nrow=length(unique(acquirer_companytop1000$acquirer)),
	ncol=length(unique(acquirer_companytop1000$company)),
	i=as.numeric(factor(acquirer_companytop1000$acquirer)),
	j=as.numeric(factor(acquirer_companytop1000$company)),
	x=rep(1, length(as.numeric(acquirer_companytop1000$acquirer)))  )

row.names(A)= levels(factor(acquirer_companytop1000$acquirer))
colnames(A)= levels(factor(acquirer_companytop1000$company))

iAC= graph.incidence(A, mode=c("all"))

#plot two-made graph
#check and change these index values everytime 
V(iAC)$color[1:82] <- rgb(1,0,0,.5) # acquirers for top1000 
V(iAC)$color[83:167] <- rgb(0,1,0,.5) #companies for top1000

V(iAC)$label <- V(iAC)$name
V(iAC)$label.color <- rgb(0,0,.2,.5)
V(iAC)$label.cex <- .4
V(iAC)$size <- 6
V(iAC)$frame.color <- NA

E(iAC)$color <- rgb(.5,.5,0,.2)

pdf("iAC_top1000companies.pdf")
plot(iAC, main="Two-mode incidence graph", layout=layout.fruchterman.reingold)
dev.off()

#Working with adjacency matrix
print(head(A))
Arow= tcrossprod(A) #adjacency matrix for acquirers
print(head(Arow))

Acol=tcrossprod(t(A)) #adjacency matrix for companies
print(head(Acol))

#adjacency matrix of investors
Aacquirer= graph.adjacency(Arow, mode= "undirected") 

#we need to transform the graph so that multiply edges become an attribute
E(Aacquirer)$weight = count.multiple(Aacquirer)
Aacquirer = simplify(Aacquirer)

#setting plotting parameters
# Set vertex attributes
V(Aacquirer)$label = V(Aacquirer)$name
V(Aacquirer)$label.color = rgb(0,0,.2,.8)
V(Aacquirer)$label.cex = .6
V(Aacquirer)$size = 6
V(Aacquirer)$frame.color = NA
V(Aacquirer)$color = rgb(0,0,1,.5)
 
# Set edge gamma according to edge weight
egam <- (log(E(Aacquirer)$weight)+.3)/max(log(E(Aacquirer)$weight)+.3)
E(Aacquirer)$color <- rgb(.5,.5,0,egam)

pdf("Aacquirer_top1000companies.pdf")
plot(Aacquirer, main = "Adjacency Graph of Acquirers", layout=layout.kamada.kawai)
plot(Aacquirer, main = "Adjacency Graph of Acquirers", layout=layout.fruchterman.reingold)
dev.off()

#jaccard similarity
jaccard.similarities= similarity.jaccard(Aacquirer)
heatmap(jaccard.similarities, symm=TRUE, main="Jaccard Similarity",
	cexRow=0.5, cexCol=0.5)

#adjacency matrix of companies
Acompanies= graph.adjacency(Acol, mode= "undirected") 

#we need to transform the graph so that multiply edges become an attribute
E(Acompanies)$weight = count.multiple(Acompanies)
Acompanies = simplify(Acompanies)

#setting plotting parameters
# Set vertex attributes
V(Acompanies)$label = V(Acompanies)$name
V(Acompanies)$label.color = rgb(0,0,.2,.8)
V(Acompanies)$label.cex = .6
V(Acompanies)$size = 6
V(Acompanies)$frame.color = NA
V(Acompanies)$color = rgb(0,0,1,.5)
 
# Set edge gamma according to edge weight
egam <- (log(E(Acompanies)$weight)+.3)/max(log(E(Acompanies)$weight)+.3)
E(Acompanies)$color <- rgb(.5,.5,0,egam)

pdf("Aacqcompanies_top1000companies.pdf")
plot(Acompanies, main = "Adjacency Graph of Acquired Companies", layout=layout.kamada.kawai)
plot(Acompanies, main = "Adjacency Graph of Acquired Companies", layout=layout.fruchterman.reingold)
dev.off()


#incidence graph for entire dataset 
##USELESS PLOTS
A= spMatrix(nrow=length(unique(acquirer_company$acquirer)),
	ncol=length(unique(acquirer_company$company)),
	i=as.numeric(factor(acquirer_company$acquirer)),
	j=as.numeric(factor(acquirer_company$company)),
	x=rep(1, length(as.numeric(acquirer_company$acquirer)))  )

row.names(A)= levels(factor(acquirer_company$acquirer))
colnames(A)= levels(factor(acquirer_company$company))
row.names(A) = paste(row.names(A), "_acq", sep="")

Arow= tcrossprod(A) #adjacency matrix for acquirers

Acol=tcrossprod(t(A)) #adjacency matrix for companies


iAC= graph.incidence(A, mode=c("all"))

#plot two-made graph
#check and change these index values everytime 
V(iAC)$color[1:5369] <- rgb(1,0,0,.5) # acquirers 
V(iAC)$color[5370:15657] <- rgb(0,1,0,.5) #companies 

V(iAC)$label <- V(iAC)$name
V(iAC)$label.color <- rgb(0,0,.2,.5)
V(iAC)$label.cex <- .4
V(iAC)$size <- 6
V(iAC)$frame.color <- NA

E(iAC)$color <- rgb(.5,.5,0,.2)

pdf("iAC.pdf")
plot(iAC, main="Two-mode incidence graph", layout=layout.fruchterman.reingold)
dev.off()

#clean the network by removing 1 degree edges
iAC <- delete.vertices(iAC, V(iAC)[ degree(iAC)<=1 ]) 
V(iAC)$label[1:1441] <- NA
V(iAC)$color[1:1441] <-  rgb(1,0,0,.1)
V(iAC)$size[1:1441] <- 2
 
E(iAC)$width <- .3
E(iAC)$color <- rgb(.5,.5,0,.1)
 
pdf("iAC.2.pdf")
plot(iAC, main= "Two-mode incidence graph", layout=layout.kamada.kawai)
dev.off()
 
pdf("iAC.3.pdf")
plot(iAC, main="Two-mode incidence graph", layout=layout.fruchterman.reingold.grid)
dev.off()
 
#gives best plot : it really emphasizes centrality–the nodes that are most central 
#are nearly always placed in the middle of the plot
pdf("iAC.4.pdf")
plot(iAC, main="Two-mode incidence graph", layout=layout.fruchterman.reingold)
dev.off()
##

###
#Acquirer Region and Company Region
acq_comRegion= data.frame(acquisitions$acquirer_region, acquisitions$company_region, acquisitions$company_name)
colnames(acq_comRegion)=c("acqRegion", "comRegion", "company")
acq_comRegion= acq_comRegion[acq_comRegion[,1] != "unknown",]
acq_comRegion= acq_comRegion[acq_comRegion[,2] != "unknown",]

acq_comRegion_top1000= subset(acq_comRegion, company %in% company_names_top1000$name)

acq_comRegion$company=NULL
acq_comRegion_top1000$company=NULL

dim(acq_comRegion)
length(unique(acq_comRegion$acqRegion))
length(unique(acq_comRegion$comRegion))

dim(acq_comRegion_top1000)
length(unique(acq_comRegion_top1000$acqRegion))
length(unique(acq_comRegion_top1000$comRegion))


#spare matrix 
A= spMatrix(nrow=length(unique(acq_comRegion_top1000$acqRegion)),
	ncol=length(unique(acq_comRegion_top1000$comRegion)),
	i=as.numeric(factor(acq_comRegion_top1000$acqRegion)),
	j=as.numeric(factor(acq_comRegion_top1000$comRegion)),
	x=rep(1, length(as.numeric(acq_comRegion_top1000$acqRegion)))  )

row.names(A)= levels(factor(acq_comRegion_top1000$acqRegion))
colnames(A)= levels(factor(acq_comRegion_top1000$comRegion))
#row.names(A)= paste(row.names(A), "_acq", sep="")

Arow= tcrossprod(A) #adjacency matrix for acquirer regions

Acol=tcrossprod(t(A)) #adjacency matrix for company regions 

#overlap graph for acquire regions
olAcqRegions= Arow/diag(Arow)
olAcqRegions=as.matrix(olAcqRegions)
olAcqRegionsg= graph.adjacency(olAcqRegions, weighted=T)

#Degree
V(olAcqRegionsg)$degree= degree(olAcqRegionsg)

#Betweenness centrality
V(olAcqRegionsg)$btwcnt= betweenness(olAcqRegionsg)

#distribution of connection strength
plot(density(olAcqRegions), main="Distribution of Connection Strength")

#filter at 1 so that an edge will consists of investor overlap of more than 1 of the investor’s companies in question
olAcqRegions1 = olAcqRegions
#olInvestors1[olInvestors<0.5] = 0
olAcqRegions1g = graph.adjacency(olAcqRegions1, weighted=T)

#remove loops
olAcqRegions1g<- simplify(olAcqRegions1g, remove.multiple=FALSE, remove.loops=TRUE)

#hand placing nodes to make sure no labels overlap
olAcqRegions1g$layout <- layout.fruchterman.reingold(olAcqRegions1g)
V(olAcqRegions1g)$label <- V(olAcqRegions1g)$name
tkplot(olAcqRegions1g)

#save layout
olAcqRegions1g$layout <- tkplot.getcoords(7)

# Set vertex attributes
V(olAcqRegions1g)$label <- V(olAcqRegions1g)$name
V(olAcqRegions1g)$label.color <- rgb(250/256,128/256,114/256, 0.8)
V(olAcqRegions1g)$size <- 6
V(olAcqRegions1g)$frame.color <- NA
V(olAcqRegions1g)$color <- rgb(95/256,158/256,160/256,.5)
 
# Set edge attributes
E(olAcqRegions1g)$arrow.size <- .3
 
# Set edge gamma according to edge weight
egam <- (E(olAcqRegions1g)$weight+.1)/max(E(olAcqRegions1g)$weight+.1)
E(olAcqRegions1g)$color <- rgb(0.5,0.5,0,egam)

V(olAcqRegions1g)$label.cex <- degree(olAcqRegions1g)/(max(degree(olAcqRegions1g))) + 0.5
#note, unfortunately one must play with the formula above to get the
#ratio just right

pdf("olAcqRegions1gcustomlayout.pdf")
plot(olAcqRegions1g, main="Overlap Network for Acquirer Regions")
dev.off()


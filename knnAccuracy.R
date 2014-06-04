resp = read.csv("/Users/ash/Downloads/testClass.csv", header= TRUE)
data249 = read.csv("/Users/ash/Downloads/pred_knn.csv", header = TRUE)

data249$X = NULL
resp$X = NULL
indx = c()
for (i in 1:dim(data249)[1])
{
	temp = which.max(data249[i,])
	indx = c(indx,temp)
}

mean(indx == resp)
# Accuracy: 0.8024241


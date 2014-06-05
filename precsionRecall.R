# finding precision recall for multiclass:

# read predicted values
pred = read.csv("/Users/ash/Downloads/pred_val.csv", header = TRUE)
# read actual values of labels
y1 = read.csv("/Users/ash/Downloads/testClass2.csv", header = TRUE)
y1$X = NULL
pred$X = NULL


#pred = as.numeric(pred)
#y1 = as.numeric(pred)

label = 1

precision1 = c()
recall1 = c()
nr = dim(pred)[1]

for(label in 1:7)
{
  op = pred
  ip = y1
  
  # making non class 0 for predictions
  notLabel_indices1 = which(op!=label,arr.ind = T)
  op[notLabel_indices1] = 0
  
  # making non class 0 for actual labels:
  notLabel_indices2 = which(ip!=label, arr.ind = T)
  ip[notLabel_indices2] = 0
  
  res = 0
  for (i in 1:nr)
  {
    if(ip[i,] == label)
    {
      if(op[i,] == ip[i,] )
        res = res +1
    }
  }
  tp = res
  print("TP:")
  print(res)
  res = 0
  for (i in 1:nr)
  {
    if(ip[i,] == 0)
    {
      if(op[i,] != ip[i,] )
        res = res +1
    }
  }
  fp = res
  print("FP:")
  print(res)
  res = 0
  for (i in 1:nr)
  {
    if(ip[i,] == label)
    {
      if(op[i,] != ip[i,] )
        res = res +1
    }
  }
  fn = res
  print("FN:")
  print(res)
  res = 0
  for (i in 1:nr)
  {
    if(ip[i,] == 0)
    {
      if(op[i,] == ip[i,] )
        res = res +1
    }
  }
  tn = res
  print("TN:")
  print(res)
  
  precision = tp/(tp+fp)
  recall = tp/(tp+fn)
  print(precision)
  print(recall)
  precision1 = rbind(precision1, precision)
  recall1 = rbind(recall1, recall)
}

print('final precision')
print(mean(precision1))
print('final recall')
print(mean(recall1))

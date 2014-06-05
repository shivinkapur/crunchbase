knn = read.csv("results_knn.csv")
trees = read.csv("results_trees 2.csv")
rf = read.csv("results_rf.csv")

new_knn = knn[c(2,3)]
barplot(as.matrix(t(new_knn)), beside = TRUE, col = c("lightcoral", "lightblue3"), border = "white", xlab = "knn", names = c(1,2,3,4,5,6,7), ylab = "Values", main = "Precision and Recall values for knn", legend = c("Precision", "Recall"), args.legend = list(x = "topleft", cex = .7), ylim = c(0, 1))

new_trees = trees[c(2,3)]
barplot(as.matrix(t(new_trees)), beside = TRUE, col = c("lightcoral", "lightblue3"), border = "white",xlab = "knn", names = c(1,2,3,4,5,6,7), ylab = "Values", main = "Precision and Recall values for trees", legend = c("Precision", "Recall"), args.legend = list(x = "topleft", cex = .7), ylim = c(0, 1))

new_rf = rf[c(2,3)]
barplot(as.matrix(t(new_rf)), beside = TRUE, col = c("lightcoral", "lightblue3"), border = "white",xlab = "knn", names = c(1,2,3,4,5,6,7), ylab = "Values", main = "Precision and Recall values for random forests", legend = c("Precision", "Recall"), args.legend = list(x = "topleft", cex = .7), ylim = c(0, 1))

par(mfrow = c(2,1))
precision = as.data.frame(c(knn[2], trees[2], rf[2]))
barplot(as.matrix(t(precision)), beside = TRUE, col = c("lightcoral", "lightblue3", "lightgreen"), border = "white", xlab = "Precision", names = c(1,2,3,4,5,6,7), ylab = "Values", main = "Precision", legend = c("knn", "trees", "rf"), args.legend = list(x = "topleft", cex = .7), ylim = c(0, 1))

recall = as.data.frame(c(knn[3], trees[3], rf[3]))
barplot(as.matrix(t(recall)), beside = TRUE, col = c("lightcoral", "lightblue3", "lightgreen"), border = "white",xlab = "Recall", names = c(1,2,3,4,5,6,7), ylab = "Values", main = "Recall", legend = c("knn", "trees", "rf"), args.legend = list(x = "topleft", cex = .7), ylim = c(0, 1))

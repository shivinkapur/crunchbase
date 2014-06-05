from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.cross_validation import cross_val_score
from sklearn import tree
from sklearn.tree import DecisionTreeClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.externals.six import StringIO  
from sklearn.naive_bayes import GaussianNB
from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import RandomForestClassifier
#import pydot 
import pandas as pd
import numpy as np 
import pylab as pl
import pickle
import os

class classify:
	def __init__(self):
		self.descr = []
		self.target = []
		self.test_descr = []
		self.test_target = []
		self.results = []

	def read_target(self, filename, type):
		df = pd.read_csv(filename, index_col = 0)
		if type == "train":
			self.target = df.x.tolist()
		else:
			self.test_target = df.x.tolist()

	def read_descr(self, filename, type):
		df = pd.read_csv(filename, index_col = 0)
		dft = df.transpose()

		colnames = list(dft.columns.values)
		print df.columns.values

		for i in colnames:
			if type == "train":
				self.descr.append(dft[i].tolist())
			else:
				self.test_descr.append(dft[i].tolist())


	def knn_classify(self):
		knn = KNeighborsClassifier()
		knn.fit(self.descr, self.target)
		pred = knn.predict(self.test_descr)

		pd.df.write_csv("pred_val.csv")

		accuracy = np.where(pred == self.test_target, 1, 0).sum() / float(len(self.test_target))
		print "Accuracy: %3f" %  accuracy

		#self.results.append([n, accuracy])

	def knn_plot(self):
		self.results = pd.DataFrame(self.results, columns=["n", "accuracy"])
		pl.plot(self.results.n, self.results.accuracy)
		pl.title("Accuracy with Increasing K")
		pl.show()

	def svm_classify(self):
		print "SVM"

		clf = SVC()
		clf.fit(self.descr, self.target)
		mean = clf.score(self.test_descr, self.test_target)
		print "Mean : %3f" % mean

		pred = clf.predict(self.test_descr)
		accuracy = np.where(pred == self.test_target, 1, 0).sum() / float(len(self.test_target))
		print "Accuracy: %3f" % accuracy

	def tree_classify(self):
		print "Trees"

		clf = DecisionTreeClassifier()
		clf.fit(self.descr, self.target)
		mean = clf.score(self.test_descr, self.test_target)
		print "Accuracy : %3f" % mean

		# Ten-fold cross validation
		#cv_score = cross_val_score(clf, self.descr, self.target, cv=10)
		#print "CV Score", cv_score

		#print "Tree object", clf.tree_
		print "Classes", clf.classes_
		print "Feature Importances", clf.feature_importances_
		#print "Parameters", clf.get_params()

		#with open("tree.dot", 'w') as f:
		#	f = tree.export_graphviz(clf, out_file=f)

		#os.unlink('tree.dot')

	def lr_classify(self):
		print "Logistic Regression"

		clf = LogisticRegression()
		clf.fit(self.descr, self.target)
		mean = clf.score(self.test_descr, self.test_target)
		print "Mean : %3f" % mean
		print "Coefficients ", clf.coef_
		print "Intercept ", clf.intercept_
		print "Confidence Score ",clf.decision_function(self.descr)
		print "Predict Probability ", clf.predict_proba(self.descr)
		print "Transform ", clf.transform(self.descr)

	def nb_classify(self):
		print "Naive Bayes"

		clf = GaussianNB()
		clf.fit(self.descr, self.target)
		mean = clf.score(self.test_descr, self.test_target)

		pred = clf.predict(self.test_descr)
		accuracy = np.where(pred == self.test_target, 1, 0).sum() / float(len(self.test_target))
		print "Accuracy: %3f" % accuracy

		print "Mean : %3f" % mean
		print "Probability ", clf.class_prior_
		print "Mean of each feature per class ", clf.theta_
		print "Variance of each feature per class ", clf.sigma_
		print "Predict Probability ", clf.predict_proba(self.descr)

	def sgd_classify(self):
		print "Stochastic Gradient Descent"

		clf = SGDClassifier()
		clf.fit(self.descr, self.target)
		mean = clf.score(self.test_descr, self.test_target)

		print "Mean : %3f" % mean
		print "Probability ", clf.coef_
		print "Mean of each feature per class ", clf.intercept_
		print "Confidence Score ",clf.decision_function(self.descr)
		print "Predict Probability ", clf.predict_proba(self.descr)
		print "Transform ", clf.transform(self.descr)


	def rf_classify(self):
		print "Random Forest"

		clf = RandomForestClassifier()
		clf.fit(self.descr, self.target)
		mean = clf.score(self.test_descr, self.test_target)
		pred = clf.predict(self.test_descr)

		print "Pred ", pred
		print "Mean : %3f" % mean
		print "Feature Importances ", clf.feature_importances_
		print "Predict Probability ", clf.predict_proba(self.descr)
		print "Transform ", clf.transform(self.descr)



cl = classify()
cl.read_target('trainClass.csv', "train")
cl.read_descr('trainDescr.csv', "train")
cl.read_target('testClass.csv', "test")
cl.read_descr('testDescr.csv', "test")
cl.knn_classify()
#cl.knn_plot()
#cl.svm_classify()
#cl.tree_classify()
#cl.lr_classify()
#cl.nb_classify()
#cl.sgd_classify()
#cl.rf_classify()

from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import ExtraTreesClassifier
import types

def ab_classify(self):
	print "Adaboost"
	clf = AdaBoostClassifier()
	clf.fit(self.descr, self.target)
	mean = clf.score(self.test_descr, self.test_target)
	pred = clf.predict(self.test_descr)

	print "Pred ", pred
	print "Mean : %3f" % mean
	print "Feature Importances ", clf.feature_importances_

def et_classify(self):
	print "Extra Trees"
	clf = ExtraTreesClassifier()
	clf.fit(self.descr, self.target)
	mean = clf.score(self.test_descr, self.test_target)
	pred = clf.predict(self.test_descr)

	print "Pred ", pred
	print "Mean : %3f" % mean
	print "Feature Importances ", clf.feature_importances_

def gb_classify(self):
	print "Gradient Boostin"
	clf = GradientBoostingClassifier()
	clf.fit(self.descr, self.target)
	mean = clf.score(self.test_descr, self.test_target)
	pred = clf.predict(self.test_descr)

	print "Pred ", pred
	print "Mean : %3f" % mean
	print "Feature Importances ", clf.feature_importances_

cl.ab_classify = types.MethodType( ab_classify, cl )
cl.gb_classify = types.MethodType( gb_classify, cl )
cl.et_classify = types.MethodType( et_classify, cl )
#cl.ab_classify()
#cl.gb_classify()
#cl.et_classify()
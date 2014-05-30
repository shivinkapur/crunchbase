import csv

with open('acquisitions.csv') as csvfile:
	for row in csvfile:
		print ', '.join(row)
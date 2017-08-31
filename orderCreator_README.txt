Author  :  Daniel DeVeau
Written : April 2017
Edited  : August 31, 2017

orderCreator.py: A Python script to generate and output example restaurant order data, for use by RestSeched.mod.

Run commands:
	'python orderCreator.py #orders' ('-o outputfile.txt')
	'python orderCreator.py -h' for help

Summary:
	Given a number of orders as input, orderCreator generates two matrices of size maxTableSize X numOrders.
	The first matrix represents the cooktime of every job, where a '0' indicates a nonexistand job. 
		e.g. j[3][6] represents the cooktime of the 4th job in the 7th order.
	The second matrix represents the station mapping of the corresponding jobs.
		e.g. s[3][6] represents the index of the cooking station for the 4th job in the 7th order.

	By including '-o' and a .txt filename, orderCreator will write the resulting matrices to a file.

Changelog:
	v1.0 Initial Submission. Hardcoded presents include: cook times=[2,3,5] ; maxTable size=5 ; numStations=3 ; tableProbs=[0.1,0.25,0.2,0.25,0.2]
Author  :  Daniel DeVeau
Written : April 2017
Edited  : September 1, 2017

orderCreator.py: A Python script to generate and output example restaurant order data for use by RestSeched.mod.

Run commands:
	'python orderCreator.py'
	-h tag for help from argparse
    -i tag controls the number of files to create
    -n tag controls the number of orders to generate
    -o tag will output orders in a txt or dat file, the latter of which can be provided with RestSched.mod for optimization.
       Alternatively, one may directly paste the order matrices into RestScehd.mod data section.

Summary:
	Given a number of orders as input, orderCreator generates two matrices:
	The first matrix represents the cooktime of every job, where a '0' indicates a nonexistand job. 
		e.g. j[3][6] represents the cooktime of the 4th job in the 7th order.
	The second matrix represents the station mapping of the corresponding jobs.
		e.g. s[3][6] represents the index of the cooking station for the 4th job in the 7th order.

Options:



Changelog:
	v1.0 Initial Submission. Hardcoded presents include: cook times=[2,3,5] ; maxTable size=5 ; numStations=3 ; tableProbs=[0.1,0.25,0.2,0.25,0.2]
    v1.0 Overhauled formatting/whitespace, cleaned up naming conventions, added support for .dat files and multiple iterations at once.
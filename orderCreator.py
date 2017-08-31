# orderCreator.py
# Author: Daniel DeVeau
# Date  : August 31 2017

# MODULES
import sys
import random
import argparse
from collections import defaultdict


#assuming tablesize=5. I could create a parameter later, but that alters the probability of any table size being chosen. 

# Globals
times = [2,3,5]
maxTable= 5
numStations = 3
numOrders = 0
tableProbs = [0.1,0.25,0.2,0.25,0.2]

#
# Method: orderGenerator
# Input : # of orders to generate
# Output:
# Notes:
#

def orderGenerator(numO):
    global numOrders
    numOrders = numO
    #allJobs is a dict of lists where allJobs[i][j] is the cooktime of the ith job of order J
    allJobs= defaultdict(list)
    #allStations is a dict of lists where allStations[i][j] is the station index of the ith job of order job
    allStations = defaultdict(list)

    for i in range(numOrders): #i = order number

        rando = random.random() #randomly choose table size
        pVal=tableProbs[0]
        size = 1
        while rando>pVal:
            pVal+=tableProbs[size]
            size+=1
        for j in range(maxTable):
            cooktime = (random.choice(times) if size>=j+1 else 0) #choose randomly among the set of cooktimes
            station = (random.randint(1,numStations) if size>=j+1 else 0) #choose a station randomly
            allJobs[j].append(cooktime) #fill allJobs
            allStations[j].append(station) #fill allStations

    print("Job Cooktimes:")
    for j in range(maxTable):
        print(allJobs[j])
    print("Corresponding Job Stations:")
    for j in range(maxTable):
        print(allStations[j])
    return (allJobs,allStations)
    
    

#takes dictionaries of order jobs and stations, and creates a text file with job and station paramaters R and S in LP readable matrix format 
def createText(jobDict,stationDict,filename):
    file=open(filename, 'w')
    jobDef = list()
    jobDef.append("param R:")
    jobDef.extend(range(1,numOrders+1))
    jobDef.append(":=")
    #paramHead represents the first line defining the param, e.g. : param R: 1 2 3 4 5 6 7 8 9 10 :=
    paramHead= ' '.join(str(item) for item in jobDef)
    file.write(paramHead)
    file.write('\n')
    for i in range(maxTable):
        jobList = jobDict[i]
        jobList.insert(0,i+1)
        file.write(' '.join(str(item) for item in jobList))
        file.write('\n')
    jobDef[0]="param S:"
    paramHead= ' '.join(str(item) for item in jobDef)
    file.write(paramHead)
    file.write('\n')
    for i in range(maxTable):
        stationList = stationDict[i]
        stationList.insert(0,i+1)
        file.write(' '.join(str(item) for item in stationList))
        file.write('\n')
    file.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('numOrders', type = int, help="input the number of food orders to generate")
    parser.add_argument('-o','--output', nargs = '?', help="optionally output results to a text file",required = False)
    args = parser.parse_args()
    (j,s) = orderGenerator(args.numOrders)
    if args.output:
        createText(j,s,args.output)
        
    
    
if __name__ == "__main__":
    main()
        
        
'''
Reference table:
Table size distribution
P(1)=.1
P(2)=.25
P(3)=.2
P(4)=.25
P(5)=.2

Food order probabilities: Uniform
Station probabilies: Uniform

Appetizers?

'''

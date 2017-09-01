# orderCreator.py
# Author : Daniel DeVeau
# Date   : September 1 2017
# Version: 1.1
# Summary: orderCreator generates mock restaurant orders based on the TABLE_PROBS probability distribution. See README for more info


# MODULES
import sys
import random
import argparse
from collections import defaultdict

# GLOBALS

#lambda=0 finds the schedule with optimal makespan. 
#lambda=large integer finds schedule with minimal completion time among all orders
LAMBDA = 0

# Max jobs in an order, equivalent to param maxi in RestSched.mod
MAX_TABLE= 5

# Max time units considered by solver, equivalent to param T in RestSched.mod
MAX_TIME=45

# Number of cooking stations, equivalent to param p in RestSched.mod
NUM_STATIONS = 3

# Max concurrent jobs on any station, equivalent to param C in RestSched.mod
STATION_CAPACITY = 5

# TABLE_PROBS[i] is the likelihood of any order having i+1 job(s).
# NOTE: These values should be altered for testing purposes, but I find them reasonably realistic.
TABLE_PROBS = [0.1,0.25,0.2,0.25,0.2]

# Possible food cooktimes
TIMES = [2,3,5]

# Max difference in completion time between order and any job in order. w in RestSched.mod. See README
WAIT=0

# Function: order_generator
# Input   : # of orders to generate
# Output  : tuple of matrices, (jobs cooktimes, job stations)
def order_generator(numOrders):
    # all_jobs is a dict of lists where allJobs[i][j] is the cooktime of the ith job of order J
    # allStations is a dict of lists where allStations[i][j] is the station index of the ith job of order j
    allJobs     = defaultdict(list)
    allStations = defaultdict(list)

    for i in range(numOrders):
        tableSize = random.randint(1,MAX_TABLE)
        for j in range(MAX_TABLE):
            # choose random cooktime among the set of cooktime options, else 0 for nonexistant job
            cooktime = (random.choice(TIMES) if tableSize>=j+1 else 0)
            # Choose station UAR, else 0 for nonexistant job
            station = (random.randint(1,NUM_STATIONS) if tableSize>=j+1 else 0)
            # Populate allJobs
            allJobs[j].append(cooktime)
            # Populate allStations
            allStations[j].append(station)

    print('Job Cooktimes:')
    for j in range(MAX_TABLE):
        print(allJobs[j])
    print('Corresponding Job Stations:')
    for j in range(MAX_TABLE):
        print(allStations[j])
    return (allJobs,allStations)
    # END order_generator

# Function: create_text
# Input   : dictionaries of order jobs and stations
# Output  : Writes output from order_generator to text file in LP readable matrix format.
def create_text(jobDict,stationDict,numOrders,iteration,extension):
    if extension == 'dat':
        name = str(numOrders) + 'Orders_'+str(iteration)+'.dat'
    else:
        name = str(numOrders) + 'Orders_'+str(iteration)+'.txt'
    # Open for writing
    file=open(name, 'w')

    # Write param values to dat file
    if extension == 'dat':
        file.write('param num := ' + str(numOrders) + ';' + '\n')
        file.write('param maxi := ' + str(MAX_TABLE) + ';' + '\n')
        file.write('param T := ' + str(MAX_TIME) + ';' + '\n')
        file.write('param p := ' + str(NUM_STATIONS) + ';' + '\n')
        file.write('param w := ' + str(WAIT) + ';' + '\n')
        file.write('param lambda := ' + str(LAMBDA) + ';' + '\n')
        file.write('param C :=')
        for i in range(1,NUM_STATIONS+1):
            file.write(' ' + str(i) +' ' + str(STATION_CAPACITY))
        file.write(';' + '\n')
        
    # Write cooktimes matrix R
    jobDef = list()
    jobDef.append('param R:')
    # Add order indices
    jobDef.extend(range(1,numOrders+1))
    jobDef.append(':=')
    #paramHead represents the first line defining the param, e.g. : param R: 1 2 3 4 5 6 7 8 9 10 :=
    paramHead= ' '.join(str(item) for item in jobDef)
    file.write(paramHead)
    file.write("\n")
    for i in range(MAX_TABLE):
        jobList = jobDict[i]
        jobList.insert(0,i+1)
        file.write(' '.join(str(item) for item in jobList))
        if extension=='dat' and i+1==MAX_TABLE:
            file.write(';')
        file.write("\n")
        
    # Write stations matrix S
    jobDef[0]="param S:"
    paramHead= ' '.join(str(item) for item in jobDef)
    file.write(paramHead)
    file.write("\n")
    for i in range(MAX_TABLE):
        stationList = stationDict[i]
        stationList.insert(0,i+1)
        file.write(' '.join(str(item) for item in stationList))
        if extension=='dat' and i+1==MAX_TABLE:
            file.write(';')
        file.write("\n")
    file.close()
    return
    # END create_text

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n','--numOrders', type = int, default=20, help="input the number of food orders to generate. Default=20")
    parser.add_argument('-i','--iterations',type= int,default=1,help="Optionally input the number of iterations")
    parser.add_argument('-o','--output',choices=['dat','txt'],help="save orders to a file, please provide 'dat' or 'txt' for the respective file type")
    args = parser.parse_args()

    for i in range(args.iterations):
        (j,s) = order_generator(args.numOrders)
        if args.output:
            create_text(j,s,args.numOrders,i+1,args.output)
    return

if __name__ == "__main__":
    main()

# Reference table:
# Table size distribution
# P(1)=.1
# P(2)=.25
# P(3)=.2
# P(4)=.25
# P(5)=.2

# Food order probabilities: Uniform
# Station probabilies: Uniform


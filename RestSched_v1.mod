/*
Restaurant Scheduler Integer Program v1.1
Authors: Daniel DeVeau, Dr. Kamesh Munagala
August 2017

Changelog:
    v1.1 - Formatting and commenting

Example Commands:
    GLPK: glpsol --math RestSched_v1.mod -o 'Output_filename'.out

    CPLEX: 'read RestSched_v1.lp'
                'set mip tolerances mipgap 0.x'
                'optimize'
                'display solution variables -'

    Convert .mod to .lp format: 'glpsol --check --wlp RestSched_v1.lp --math RestSched_v1.mod'
    'set mip tolerances' controls the gap tolerated between the integer optimal solution and the solution of the best node remaining.
/*

/* PARAMETERS: */
/* T - Max amt. of time units considered  */
param T;

/* p -  Number of unique machines */
param p; 

/* w - Max number of time units allowed between jobs in an order aka 'wait' *
param w;

/* lambda=0 finds the schedule with optimal makespan. */
/* lambda=large integer finds schedule with minimal completion time of all orders*/
param lambda;

/* Number of orders to be scheduled */
param num, integer, > 0;

/* Maximum number of jobs in an order */
param maxi, integer, >0;

/* O - Set of Orders */
set O:= 1..num;
/* K - Possible # of jobs in any order*/
set K:= 1..maxi;
/* M - Set of machines */
set M:= 1..p;

/* Map of job cooktimes. Vertical axis represents order number */
param R{k in K, o in O};

/* Map of the corresponding machine for every job */
param S{k in K, o in O};

/* Maching capacities */
param C{m in M};

/* Order decision variable ; 1 if Order o finishes at time t */
var Y{o in O, t in 1..T}, binary;

/* Job decision variable ; 1 if JOB k in ORDER o finishes at time t */
var X{o in O, k in K, t in 1..T}, binary;

/* Max Completion time solution variable*/
var Z >= 0;

/* Optimization function */
minimize prep: Z + lambda/num * sum{o in O, t in 1..T} Y[o,t]*t;

/* Constraint 1: every order is completed before max completion time */
s.t. makespan {o in O}:
	sum{t in 1..T} Y[o,t]*t <= Z;

/* Constraint 2: All jobs are completed with in the order completion time and the allowed wait */
s.t. wait{o in O, k in K, t in 1..T}:
	sum{s in max(t-w,1)..t}  X[o,k,s]>= (if (R[k,o] > 0) then 1 else 0) * Y[o,t];

/* Constraint 3: All orders  are completed only once */
s.t. feasible{o in O}:
	sum{t in 1..T} Y[o,t]=1;

/* Constraint 4: Max concurrent jobs on a station must never exceed that station's capacity */
s.t. capacity{m in M, t in 1..T}:
	sum{o in O, k in K} sum{s in t..min(T,t+R[k,o]-1)} X[o,k,s] * (if (S[k,o] = m) then 1 else 0) <= C[m];

/* Constraint 5: Jobs cannot begin before the first time unit */
s.t. length{o in O, k in K, t in 1..R[k,o]}:
	X[o,k,t] = 0;

data;

param num    := 20;
param maxi   := 5;
param T      := 60;
param p      := 3;
/* NOTE: See README for explanation of wait w=0 */
param w      := 0;
param lambda := 0;
/* Format: machine# capacity machine# capacity ... */
param C      := 1 5 2 5 3 5;

param R: 1  2  3  4  5  6  7  8   9  10  11  12  13  14  15  16  17  18  19  20 :=
	  1  2	2  2  2  2  3  3  3   3   3   5   5   5   5   5   2   2   2   2   2
 	  2  0  2  2  2  2  0  3  3   3   3   0   5   5   5   5   2   3   3   2   5
	  3  0  0  2  2  2  0  0  3   3   3   0   0   5   5   5   2   3   5   2   5
	  4  0  0  0  2  2  0  0  0   3   3   0   0   0   5   5   3   3   5   2   5
	  5  0  0  0  0  2  0  0  0   0   3   0   0   0   0   5   5   5   5   5   5 ;

param S: 1  2  3  4  5  6  7  8   9  10  11  12  13  14  15  16  17  18  19  20 :=
	  1  1	2  1  1  2  2  3  2   2   3   3   1   3   3   1   1   3   2   1   3
 	  2  0  3  2  2  3  0  1  3   3   1   0   2   1   1   2   2   1   3   2   1
	  3  0  0  3  3  1  0  0  1   1   2   0   0   2   2   3   3   2   1   3   2
	  4  0  0  0  1  2  0  0  0   2   3   0   0   0   3   1   1   3   2   1   3
	  5  0  0  0  0  3  0  0  0   0   1   0   0   0   0   2   2   1   3   2   1 ;

end;

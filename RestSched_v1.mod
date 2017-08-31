/* Restaurant Scheduler Integer Program v1.0
Authors: Daniel DeVeau, Dr. Kamesh Munagala
April 18, 2017 */


/* GLPK: run with glpsol --math name.mod -o name.out 
CPLEX Convert: glpsol --check --wlp rest1.lp --math rest1.mod
Run: read rest1.lp / set mip tolerances mipgap 0.x / optimize 
display solution variables - */


param T;					/* Max amt. of time allowed */
param p;  					/* Number of unique machines */
param w;  					/* coldness */
param lambda;				/* 0->Makespan, high->Completion Time  */
param num, integer, > 0; 	/* # of orders */
param maxi, integer, >0; 	/* max # of jobs in an order */

set O:= 1..num; 			/* Set of Orders */
set K:= 1..maxi;   			/* Possible # of jobs	*/
set M:= 1..p;				/* Set of machines */
param R{k in K, o in O};    /* Composition of food orders by cooktime */
param S{k in K, o in O};	/* Station corresponding to each job */
param C{m in M};			/* Station indices, e.g. C[1]=Fryer, C[2]=Grill C[3]=Sautee  */

var Y{o in O, t in 1..T}, binary;
							/* =1 if Order o finishes at time t */

var X{o in O, k in K, t in 1..T}, binary;
							/* =1 if JOB k in ORDER o finishes at time t */

var Z >= 0;
							/* = Max Completion time */

minimize prep: Z + lambda/num * sum{o in O, t in 1..T} Y[o,t]*t;

s.t. makespan {o in O}:
	sum{t in 1..T} Y[o,t]*t <= Z;

s.t. loose{o in O, k in K, t in 1..T}:
	sum{s in max(t-w,1)..t}  X[o,k,s]>= (if (R[k,o] > 0) then 1 else 0) * Y[o,t];
	
s.t. feasible{o in O}: 
	sum{t in 1..T} Y[o,t]=1;

s.t. capacity{m in M, t in 1..T}:
	sum{o in O, k in K} sum{s in t..min(T,t+R[k,o]-1)} X[o,k,s] * (if (S[k,o] = m) then 1 else 0) <= C[m];

s.t. length{o in O, k in K, t in 1..R[k,o]}:
	X[o,k,t] = 0;
	
data;

param num := 20;
param maxi := 5;
param T := 60 ;
param p := 3;
param w := 0; 
param lambda := 10;
param C:= 1 5 2 5 3 5;


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

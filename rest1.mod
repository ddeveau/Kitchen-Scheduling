/* run with glpsol --math name.mod -o name.out */


param T;
param w;  					/* coldness */
param p;  					/* Number of parallel machines */
param c; 					/* Capacity of each machine (not necessarily uniform) */
param num, integer, > 0; 	/* # of orders */
param maxi, integer, >0; 	/* max # of jobs in an order */
param x, integer, >0; 		/* Extra time to avoid domain error*/

set O:= 1..num; 			/* Set of Orders */
set K:= 1..maxi;   
param R{k in K, o in O};    /* Composition of food orders, each Ki is cooktime of item i */

var Yot{o in O, t in 1..T}, binary;
							/* =1 if Order o finishes at time t */

var Xkt{o in O, k in K, t in 1..T+x}, binary;
							/* =1 if JOB k in ORDER o finishes at time t */

minimize prep: sum{o in O, t in 1..T} Yot[o,t]*t;

s.t. loose{o in O, k in K, t in 1..T}:
	sum{s in max(t-w,1)..t} Xkt[o,k,s]>=Yot[o,t];
	
s.t. total{o in O}: 
	sum{t in 1..T} Yot[o,t]=1;

s.t. capacity{t in 1..T}:
	sum{o in O, k in K} sum{s in t..t+R[k,o]} Xkt[o,k,s]<=p*c;

s.t. length{o in O, k in K, t in 1..R[k,o]}:
	Xkt[o,k,t] = 0;
	
data;

param num := 5;
param maxi := 3;
param T := 15;
param w := 2; 
param c := 5;
param p := 1;
param x := 6;

param R: 1 2 3 4 5 :=
	  1	 5 5 3 3 2
	  2  5 2 3 2 0
	  3  3 0 2 2 0;
	  

end;

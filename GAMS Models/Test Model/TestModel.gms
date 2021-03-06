
$title Test Model: Engineering Hall Evacuation Optimization


* ----------------------------------------------------------------------------------
*  SETS, PARAMS, & VARS
* ----------------------------------------------------------------------------------

sets
	T time /0*50/;
alias(T,S);


* NODES -----------------------------------------------------------

sets
	N superset of nodes /rh1*rh18,hh1*hh2,c1*c15,l1*l4,
		o1*o4,b1,e1*e3/;
alias(N,N1,N2,N3);

sets
	S1(N) pathway nodes /rh1*rh18,hh1*hh2/
	S2(N) source nodes /c1*c15,l1*l4,o1*o4,b1/
	S3(N) sink nodes /e1*e3/;
sets
	RH(S1) room-hall intersection /rh1*rh18/
	HH(S1) hall-hall intersection /hh1*hh2/
	SH(S1) stair-hall intersection;
sets
	C(S2) classroom /c1*c15/
	L(S2) lab /l1*l4/
	O(S2) office /o1*o4/
	B(S2) bathroom /b1/;
sets
	E(S3) exits /e1*e3/;
sets
	NE(N) not exit /rh1*rh18,hh1*hh2,c1*c15,l1*l4,
		o1*o4,b1/;

* ARCS ------------------------------------------------------------

sets
	ARCS(N1,N2);

* source-hall arcs

ARCS('c1','rh1') = yes;
ARCS('c2','rh2') = yes;
ARCS('c3','rh3') = yes;
ARCS('c4','rh5') = yes;
ARCS('c5','rh6') = yes;
ARCS('c6','rh6') = yes;
ARCS('c7','rh5') = yes;
ARCS('c8','rh8') = yes;
ARCS('c9','rh9') = yes;
ARCS('c10','rh11') = yes;
ARCS('c11','rh14') = yes;
ARCS('c12','rh15') = yes;
ARCS('c13','rh16') = yes;
ARCS('c14','rh17') = yes;
ARCS('c15','rh17') = yes;

ARCS('l1','rh4') = yes;
ARCS('l2','rh10') = yes;
ARCS('l3','rh12') = yes;
ARCS('l4','rh14') = yes;

ARCS('o1','rh1') = yes;
ARCS('o2','rh7') = yes;
ARCS('o3','rh18') = yes;
ARCS('o4','rh18') = yes;

ARCS('b1','rh13') = yes;

* hall-exit arcs

ARCS('rh1','e1') = yes;
ARCS('rh6','e2') = yes;
ARCS('rh18','e3') = yes;

* hall-hall arcs

ARCS('rh1','rh2') = yes;
ARCS('rh2','rh3') = yes;
ARCS('rh3','rh4') = yes;
ARCS('rh4','hh1') = yes;
ARCS('hh1','rh5') = yes;
ARCS('rh5','rh6') = yes;
ARCS('hh1','rh7') = yes;
ARCS('rh7','rh8') = yes;
ARCS('rh8','rh9') = yes;
ARCS('rh9','rh10') = yes;
ARCS('rh10','hh2') = yes;
ARCS('hh2','rh11') = yes;
ARCS('rh11','rh12') = yes;
ARCS('rh12','rh13') = yes;
ARCS('rh13','rh14') = yes;
ARCS('rh14','rh15') = yes;
ARCS('rh15','rh16') = yes;
ARCS('rh16','rh17') = yes;
ARCS('rh17','rh18') = yes;

* mirrored arcs

ARCS(N1,N2)$(ARCS(N2,N1)) = yes;

* PARAMETERS ----------------------------------------------------

parameters
	a		area of floor that a person takes up
	start(N)	num people starting at node N
	p		time period length in seconds
	r		rate at which people walk
	tau(N1,N2)	number of time periods to traverse arc
	cap(N1,N2)	capacity of arc
	d(N1,N2)	length of arc (distance between nodes)
	w(N1,N2)	width of arc (hallway width);	

a = 9;
start(C) = 30;
start(L) = 15;
start(O) = 10;
start(B) = 2;
p = 1;
r = 5;

tau(ARCS(S2,S1)) = 1;
cap(ARCS(S2,S1)) = 3;

* hall-hall, hall exit: cap and tao

cap('rh1','rh2') = 15;
cap('rh2','rh3') = 6;
cap('rh3','rh4') = 9;
cap('rh4','hh1') = 9;
cap('hh1','rh5') = 12;
cap('rh5','rh6') = 18;
cap('hh1','rh7') = 12;
cap('rh7','rh8') = 18;
cap('rh8','rh9') = 6;
cap('rh9','rh10') = 6;
cap('rh10','hh2') = 18;
cap('hh2','rh11') = 12;
cap('rh11','rh12') = 12;
cap('rh12','rh13') = 24;
cap('rh13','rh14') = 18;
cap('rh14','rh15') = 30;
cap('rh15','rh16') = 36;
cap('rh16','rh17') = 24;
cap('rh17','rh18') = 30;
cap('rh1','e1') = 6;
cap('rh6','e2') = 9;
cap('rh18','e3') = 18;

tau('rh1','rh2') = 5;
tau('rh2','rh3') = 2;
tau('rh3','rh4') = 3;
tau('rh4','hh1') = 3;
tau('hh1','rh5') = 4;
tau('rh5','rh6') = 6;
tau('hh1','rh7') = 4;
tau('rh7','rh8') = 6;
tau('rh8','rh9') = 2;
tau('rh9','rh10') = 2;
tau('rh10','hh2') = 6;
tau('hh2','rh11') = 2;
tau('rh11','rh12') = 2;
tau('rh12','rh13') = 4;
tau('rh13','rh14') = 3;
tau('rh14','rh15') = 5;
tau('rh15','rh16') = 6;
tau('rh16','rh17') = 4;
tau('rh17','rh18') = 5;
tau('rh1','e1') = 2;
tau('rh6','e2') = 3;
tau('rh18','e3') = 3;

tau(N1,N2)$(tau(N1,N2) = 0) = tau(N2,N1);
cap(N1,N2)$(cap(N1,N2) = 0) = cap(N2,N1);

parameter 
	totPop;
totPop = sum(N, start(N));


* VARIABLES -------------------------------------------------------

positive variables
	x(N1,N2,T)
	y(N,T);
binary variable
	z(T);
free variable
	totalTime;


* ----------------------------------------------------------------------------------
*  MODEL
* ----------------------------------------------------------------------------------

equations
	objEqn
	floBal(N2,T)
	arcCap(N1,N2,T)
	pop(T)
	xConst(N1,N2,T);

objEqn..
	totalTime =E= sum(T, z(T));

floBal(N2,T)$(ord(T)>1)..
	y(N2,T) =E= y(N2,T-1) + sum((N1,S)$((ord(S)=ord(T)-tau(N1,N2)) 
		and (ARCS(N1,N2) or ARCS(N2,N1))), x(N1,N2,S)) 
		- sum(N3$(ARCS(N2,N3) or ARCS(N3,N2)), x(N2,N3,T-1));
	
arcCap(N1,N2,T)..
	cap(N1,N2) =G= sum(S$((ord(S)>=ord(T)-tau(N1,N2)+1) 
		and (ord(S)<=ord(T))), x(N1,N2,S)+x(N2,N1,S));

pop(T)$(ord(T)>1)..
	sum(E, y(E,T)) + totPop*z(T) =G= totPop;

xConst(N1,N2,T)$(ARCS(N1,N2))..
	x(N1,N2,T) =L= cap(N1,N2)/tau(N1,N2);

y.fx(S2,T)$(ord(T)=1) = start(S2);
y.fx(E,T)$(ord(T)=1) = 0;


* ----------------------------------------------------------------------------------
*  SOLVE MODEL 
* ----------------------------------------------------------------------------------

option limrow = 5;
option optcr = 1e-6;
option optca = 0;

model Test_Evac /all/;
solve Test_Evac using mip minimizing totalTime;

display totalTime.L;
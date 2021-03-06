
$title:		Engineering Hall Evacuation Optimization
$author:	Cody Frehr


* ----------------------------------------------------------------------------------
*  SETS, PARAMS, & VARS
* ----------------------------------------------------------------------------------

sets
	T time /0*750/;
alias(T,S);


* NODES -----------------------------------------------------------

sets
	N node superset /b1*b22,c1*c40,f1*f15,h1*h8,l1*l132,m1*m12
		o1*o78,p1,r1*r23,u1*u260,hh1*hh60,rf1*rf7,rh1*rh354
		sh1*sh112,e1*e20/;
alias(N,N1,N2,N3);

sets
	S1(N) pathway nodes /hh1*hh60,rh1*rh354,sh1*sh112/
	S2(N) source nodes /b1*b22,c1*c40,f1*f15,h1*h8,l1*l132,
		m1*m12,o1*o78,p1,r1*r23,u1*u260/
	S3(N) sink nodes /e1*e20/;
sets
	RH(S1) room-hall intersection /rh1*rh354/
	HH(S1) hall-hall intersection /hh1*hh60/
	SH(S1) stair-hall intersection /sh1*sh112/;
sets
	B(S2) bathroom /b1*b22/
	C(S2) classroom /c1*c40/
	F(S2) conference /f1*f15/
	H(S2) shop /h1*h8/
	L(S2) lab /l1*l132/
	M(S2) computer lab /m1*m12/
	O(S2) office /o1*o78/
	P(S2) penthouse /p1/
	R(S2) research /r1*r23/
	U(S2) solo office /u1*u260/;
sets
	E(S3) exits /e1*e20/;
sets
	NE(N) not exit /b1*b22,c1*c40,f1*f15,h1*h8,l1*l132,m1*m12
		o1*o78,p1,r1*r23,u1*u260,hh1*hh60,rf1*rf7,rh1*rh354
		sh1*sh112/;


* ARCS ------------------------------------------------------------

table
	adjTable(N1,N2) binary indicator of node adjacency
$ondelim
$include Adj_Table.csv
$offdelim

table
	capTable(N2,N2) table of arc capacity values
$ondelim
$include Cap_Table.csv
$offdelim

table
	tauTable(N1,N2) table of arc tau values
$ondelim
$include Tau_Table.csv
$offdelim

sets
	ARCS(N1,N2);
ARCS(N1,N2) = yes$(adjTable(N1,N2)=1);


* PARAMETERS ------------------------------------------------------

parameters
	area		area of floor that a person takes up
	start(N)	num people starting at node N
	period		time period length in seconds
	rate		rate at which people walk
	tau(N1,N2)	number of time periods to traverse arc
	cap(N1,N2)	capacity of arc;

area = 9;
start(B) = 2;
start(C) = 30;
start(F) = 0;
start(H) = 2;
start(L) = 4;
start(M) = 10;
start(O) = 5;
start(P) = 0;
start(R) = 2;
start(U) = 1;
period = 1;
rate = 5;
tau(ARCS(N1,N2)) = tauTable(N1,N2);
cap(ARCS(N1,N2)) = capTable(N1,N2);

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
	sysPop(T)
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

sysPop(T)$(ord(T)>1)..
	sum(E, y(E,T)) + totPop*z(T) =G= totPop;

xConst(N1,N2,T)$(ARCS(N1,N2))..
	x(N1,N2,T) =L= cap(N1,N2)/tau(N1,N2);

y.fx(S2,T)$(ord(T)=1) = start(S2);
y.fx(E,T)$(ord(T)=1) = 0;


* ----------------------------------------------------------------------------------
*  SOLVE MODEL 
* ----------------------------------------------------------------------------------

option limrow = 100;
option optcr = 1e-6;
option optca = 0;

model Engineering_Hall_Evacuation /all/;
solve Engineering_Hall_Evacuation using mip minimizing totalTime;

display totalTime.L;
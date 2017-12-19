getSum([H|T],X,R):-X=:=0,R is 0,!.
getSum([],0,0).
getSum([H|T],X,R):-X1 is X-1, getSum(T,X1,R1), R is H+R1.

shufleList(L,0,L).
shufleList([H|T],X,R):-X1 is X-1, shufleList(T,X1,R),!.

getlist([],[],0).
getlist([H1|T1],[H2],X):-X=:=1,H2 is H1,!.
getlist(L,[H2],X):-X=:=2,getSum(L,2,R),H2 is R/2,!.
getlist(L,[H2|T2],X):-getSum(L,3,R), H2 is R/3, X1 is X-3, shufleList(L,3,R1), getlist(R1,T2,X1).

inputlist([],X):-X=:=0,!.
inputlist([H|T],X):-read(H),X1 is X-1, inputlist(T,X1).

start(X):-
	inputlist(L,X),
	getlist(L,R,X),
    write(R).

removeLast([H|[]],[],H).
removeLast([H|T],[H|R],R2):-removeLast(T,R,R2).

moveOne([],[]).
moveOne([H|[]],[H|[]]).
moveOne([H|T],[HR|TR]):-removeLast([H|T],TR,HR).

moveX(L,0,L):-!.
moveX(L,X,R):-X1 is X-1, moveOne(L,R1), moveX(R1,X1,R).

inputlist([],X):-X=:=0,!.
inputlist([H|T],X):-read(H),X1 is X-1, inputlist(T,X1).

start(N,X):-
	inputlist(L,N),
	moveX(L,X,R),
    write(R).

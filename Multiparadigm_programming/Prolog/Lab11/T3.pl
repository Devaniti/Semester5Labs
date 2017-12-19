sum(D,N,R):- N =< D, R = N,!.
sum(D,N,R):- N1 is N-D, sum(D,N1,R1),R is N+R1.
start:- write('enter N '),read(N),sum(1,N,R),write(R).

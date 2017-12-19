mysum(N,R):- N > 100, R = 0,!.
mysum(N,R):- N1 is N+1, mysum(N1,R1),R is (1/N/N)+R1.

degree(_,0,1):-!.
degree(A,1,A):-!.
degree(A,N,R):-N =< 0, N1 is (-N), degree(A,N1,R1), R is 1/R1,!.
degree(A,N,R):-N1 is N-1, degree(A,N1,R1), R is A * R1.

degree2(_,0,1):-!.
degree2(A,1,A):-!.
degree2(A,N,R):-(N mod 2) =:= 0, N1 is (N div 2), degree2(A,N1,R1), R is (R1 * R1),!.

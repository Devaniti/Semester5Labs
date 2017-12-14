(defun fact1(A) 
	(cond 
		((= A 0) 1)
		(T ((lambda (A B) (* A B)) A (fact1 (- A 1))))
	)
)

(print 
	(fact1 6)
)

(defun fact2(A) 
	(cond 
		((= A 0) 1)
		(T (let 
			(
				(C A)
				(D (fact2 (- A 1)))
			)
			(* C D)
		))
	)
)

(print 
	(fact2 6)
)

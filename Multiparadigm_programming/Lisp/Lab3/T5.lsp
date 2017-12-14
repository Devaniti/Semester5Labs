(defun exs (A B)
	(cond 
		((null A) nil)
		((not (atom (car A))) (exs (cdr A) B))
		((= (car A) B) T)
		(T (exs (cdr A) B))
	)
)

(defun incl (A B)
	(cond
		((null B) T)
		(T (and (exs A (car B)) (incl A (cdr B))))
	)
)
(defun f (A B N)
	(cond 
		((= N 0) (incl A B))
		(T 
			(cond
				((null A) nil)
				((atom (car A)) (f (cdr A) B N))
				(T (or (f (cdr A) B N) (f (car A) B (- N 1))))
			)
		)
	)
)

(print
	(f '(0 2 (3 (9 6) 4)(0) ((3))) '(9 6) 2)
)

(print
	(f '(0 2 (3 (9 6) 4)(0) ((3))) '(3) 2)
)

(print
	(f '(0 2 (3 (9 6) 4)(0) ((3))) '(0) 2)
)
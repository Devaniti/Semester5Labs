(defun rev1(A)
	(
		(lambda (A)
			(cond 
				((atom A) A)
				(T (append (rev1 (cdr A)) (list (car A))))
			)
		) A
	)
)
(defun V1(A) 
	(cond 
		((atom A) A)
		(T (append (rev1 A) (V1 (cdr A))))
	)
)
(print 
	(V1 '(1 2 3 4 5 6))
)

(defun rev2(A)
	(let ((B A))
		(cond 
			((atom B) B)
			(T (append (rev2 (cdr B)) (list (car B))))
		)
	)
)
(defun V2(A) 
	(cond 
		((atom A) A)
		(T (append (rev2 A) (V2 (cdr A))))
	)
)
(print 
	(V2 '(1 2 3 4 5 6))
)
(defun rev(A) 
	(cond 
		((atom A) A)
		(T (append (rev (cdr A)) (list (car A))))
	)
)
(defun T1(A) 
	(cond 
		((atom A) A)
		(T (append (rev A) (T1 (cdr A))))
	)
)
(print 
	(T1 '(1 2 3 4 5 6))
)
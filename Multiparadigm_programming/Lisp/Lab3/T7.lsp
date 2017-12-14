(defun ins(A B)
	(cond
		((null B) (list A))
		((> A (car B)) (cons (car B) (ins A (cdr B))))
		(T (cons A (ins (car B) (cdr B))))
	)
)

(defun checksort(A)
	(cond
		((null (cdr A)) T)
		((> (car A) (cadr A)) nil)
		(T (checksort (cdr A)))
	)
)

(defun T3(A)
	(cond
		((checksort A) A)
		(T (T3 (ins (car A) (cdr A))))
	)
)
 
(print
	(T3 '(1 9 2 7 4 3 0))
)

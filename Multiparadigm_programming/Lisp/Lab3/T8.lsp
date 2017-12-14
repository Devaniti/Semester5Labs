(defun mrg (A B)
	(cond
		((null A) B)
		((null B) A)
		((< (car A) (car B)) (cons (car A) (mrg (cdr A) B)))
		(T (cons (car B) (mrg A (cdr B))))
	)
)

(print
	(mrg '(0 2 3 5 9 12) '(1 2 6 7 8))
)
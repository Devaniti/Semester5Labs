(defun insert (A B)
   (cond ((null A) (LIST B))
         ((> (CAR A) B) (CONS B A))
         (T (CONS (CAR A) (insert (cdr A) B)))))

(defun insertionsort(A B)
	(cond 
		((null A) B)
		(T (insertionsort(cdr A) (insert B (CAR A))))
	)
)

(defun shellround (A B C)
	(cond 
		((null A) C) 
		(T 
			(cond 
				((>  B (LENGTH A)) (APPEND C (insertionsort A nil)))
				(T (APPEND C (insertionsort(subseq A 0 B) nil) (shellround (subseq A B (LENGTH A)) B C)))
			)
		)
	)
)

(defun shellsort (A B) 
	(cond 
		((null (cdr B)) (shellround A (CAR B) '()))
		(T (shellsort (shellround A (CAR B) '()) (cdr B)))
	)
)

(defun sendgewick() 
	'(1 8 23 77 281 1073 4193 16577 65921 262913)
)

(defun sortWithShellAndSedgewick (A) 
	(shellsort A (sendgewick))
)

(print (sortWithShellAndSedgewick '(5 6 8 4 2 0 2 6 10 9)))
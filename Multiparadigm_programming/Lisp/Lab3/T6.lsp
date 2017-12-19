(defun T6(A)
	(mapcar (lambda(A) (cons (string-capitalize (car A)) (cdr A))) A)
)

(print 
	(T6 '(("hello" "world") ("test" "sentence") ("This" "is" "already" "capitalized")))
)
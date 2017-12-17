(defun pow(A B)
	(cond
		((= B 0) 1)
		((> B 0) (* A (pow A (- B 1))))
		(T (* (/ 1 A) (pow A (+ B 1))))
	)
)

(defun my_eval(A)
	(cond
		((atom A) A)
		((equal 'car    (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)))))
		((equal 'cdr    (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)))))
		((equal 'atom   (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)))))
		((equal 'cons   (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal 'list   (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal 'equal  (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal '*      (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal '/      (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal '+      (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal '-      (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal '=      (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		((equal 'pow    (car A)) (let ((A A)) (funcall (car A) (my_eval (cadr A)) (my_eval (caddr A)))))
		(T A)
	)
)
                

(print (my_eval '(+ (pow 2 10) (pow 2 -1)))))
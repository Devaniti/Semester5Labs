
(defvar db)
(setf db '())

(defun insert(A) 
	(setf db (append (list A) db))
)

(defun select(A)
	(print A)
)

(defun where(A B)
	(remove nil (mapcar B A))
)

(defun update(A) ;update with nil to delete
	(setf db (remove nil (mapcar A db)))
)

(defun ins (A B cmp)
	(cond
		((null B) (cons A '()))
		((funcall cmp A (car B)) (cons A B))
		(T (cons (car B) (ins A (cdr B) cmp)))
	)
)

(defun insSort (A cmp)
	(cond
		((null A) '())
	    (T (ins (car A) (insSort (cdr A) cmp) cmp))
	)
)



(insert '(1 2 3))
(insert '((3 2 1)))
(insert '("a" "b" "c"))

(select db)

(select (where db (
	lambda(A) 
	(cond
		((atom (car A)) A)
		(T nil)
	)
)))

(update 
	(
	lambda(A) 
	(cond
		((atom (car A)) A)
		(T (car A))
	)
))

(select (where db (
	lambda(A) 
	(cond
		((atom (car A)) A)
		(T nil)
	)
)))

(update 
	(
	lambda(A) 
	(cond
		((numberp (car A)) A)
		(T  nil)
	)
))

(select db) 


(insert '(2 2 4))
(insert '(7 3 7))
(insert '(5 2 1))

(select (insSort db 
	(lambda (A B)
		(< (car A) (car B))
	)
))

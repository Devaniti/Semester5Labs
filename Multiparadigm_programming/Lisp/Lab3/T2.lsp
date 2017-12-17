(defun der (e) 
	(cond 
		((null e) 0) 
		((equal e 'x) 1)
		((atom e) 0)
		((null (cdr e)) (der (car e)))
		((null (cddr e))
		(cond 
			((equal (car e) '+ ) (der (cadr e)))
			((equal (car e) '- ) (list '- (der (cadr e))))
			(t (derfun (car e) (cadr e))) ) 
		) 
		(t (derexpr (car e) (cadr e) (caddr e))) 
    )
)

(defun derexpr (arg1 op arg2 )
    (cond 
		((equal op '+ ) (deradd arg1 arg2 ))
		((equal op '- ) (dersub arg1 arg2 ))
		((equal op '* ) (dermult arg1 arg2))
		((equal op '/ ) (derdiv arg1 arg2))
		((equal op '^ ) (derpower arg1 arg2))
		(t (print 'err)) 
    )
)

(defun derfun (fun arg)
    (cond 
		((equal 'SIN fun) (list (list 'COS arg) '* (der arg) ))
		((equal 'COS fun) (list (list '- (list 'SIN arg)) '*
		(der arg) ))
		((equal 'EXP fun) (list (list 'EXP (list arg)) '*
		(der arg) ))
		((equal 'LOG fun) (list (der arg) '/ arg ))
		(t (print 'illegal_function)) 
    )
)

(defun deradd (arg1 arg2)
    (list (der arg1) '+ (der arg2))
)

(defun dersub (arg1 arg2)
    (list (der arg1) '- (der arg2))
)

(defun derdiv (arg1 arg2)
    (list 
		(list (list (der arg1) '* arg2)
		'- (list arg1 '* (der arg2) ))
		'/ (list arg2 '^ '2)
    )
)

(defun dermult (arg1 arg2)
    (list (list (der arg1) '* arg2)
     '+ (list arg1 '* (der arg2)) 
    )
)

(defun derpower (arg1 arg2)
    (list (list arg1 '^ arg2)
     '* (dermult arg2 (list 'LOG(list arg1)))
    )
)

(print(der '(sin (x))))
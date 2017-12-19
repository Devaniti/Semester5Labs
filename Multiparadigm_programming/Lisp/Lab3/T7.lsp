(defun isIn(A B)
	(cond
		((null B) nil)
		((equal A (car B)) T)
		(T (isIn A (cdr B)))
	)
)

(defun isVowel(A)
	(isIn A '(#\a #\e #\o #\u #\i #\y #\A #\E #\O #\U #\I #\Y))
)

(defun divideByChar(A)
	(cond 
		((equal A "") nil)
		(T (cons (char A 0) (divideByChar (subseq A 1))))
	)
)

(defun splitSyllables(A B)
	(cond
		((null A) "")
		((equal (car A) #\space) (concatenate 'string " " (splitSyllables (cdr A) T)))
		(B 
			(concatenate 'string 
				(make-string 1 :initial-element (car A)) 
				(splitSyllables (cdr A) (not (isVowel (car A))))
			)
		)
		((isVowel (car A)) 
			(concatenate 'string "_" (make-string 1 :initial-element (car A)) (splitSyllables (cdr A) nil))
		)
		(T 
			(concatenate 'string (make-string 1 :initial-element (car A)) (splitSyllables (cdr A) nil))
		)
	)
)

(defun T7(A)
	(splitSyllables (divideByChar A) T)
)


(print (T7 "Word one bublegum"))
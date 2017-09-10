(setq L1 '(Y U I))
(setq L2 '(G1 G2 G3))
(setq L3 '(KK LL MM JJJ))
(print 
((lambda (A B C)
(list (car A)(car B)(car C))) 
L1 L2 L3)
)
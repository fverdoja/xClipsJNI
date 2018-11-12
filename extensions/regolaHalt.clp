;; REGOLA AGGIUNTA PER FAR FUNZIONARE L'INTERFACCIA

(defrule stop-on-env
   (declare (salience 21))
?f1 <-  (status (time ?i))
        (exec (time ?i)) =>
        (halt)) 
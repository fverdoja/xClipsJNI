; Questo programma contiene il simulatore dell'agente di Rescue2011
;
;contiene piccole modifiche rispetto alle versioni precedenti per ovviare  
;a qualche incongruenza segnalata dagli studenti per le attività di drill

(defmodule MAIN (export ?ALL))

(deftemplate exec
      (slot time) 
      (slot action 
          (allowed-values go turnright turnleft drill 
                          load_debris unload_debris inform done))
       (slot param1)
       (slot param2))


(deftemplate status (slot time) (slot result) )

(deftemplate prior_cell 
                  (slot pos-r)
                  (slot pos-c)
                  (slot contains (allowed-values empty debris wall gate outdoor)))
 

(deftemplate perc-vision
	(slot time)
	(slot pos-r)
	(slot pos-c)
	(slot direction)
	(slot perc1 (allowed-values  empty debris wall gate outdoor))
	(slot perc2 (allowed-values  empty debris wall gate outdoor)) 
	(slot perc3 (allowed-values  empty debris wall gate outdoor))
	(slot perc4 (allowed-values  empty debris wall gate outdoor))
	(slot perc5 (allowed-values  empty debris wall gate outdoor))
	(slot perc6 (allowed-values  empty debris wall gate outdoor))
	(slot perc7 (allowed-values  empty debris wall gate outdoor))
	(slot perc8 (allowed-values  empty debris wall gate outdoor))
	(slot perc9 (allowed-values  empty debris wall gate outdoor))
	              )


(deftemplate perc-acoust
	(slot time)
	(slot pos-r)
	(slot pos-c)
	(slot ac (allowed-values no yes)))



(deftemplate perc-drill  
	(slot time)
	(slot pos-r)
	(slot pos-c)
	(slot drill (allowed-values yes no fail)) )


(deftemplate perc-bump  
	(slot time)
	(slot pos-r)
	(slot pos-c)
	(slot direction)
	(slot bump (allowed-values no yes)) )

(deftemplate perc-loaded  
	(slot time)
	(slot robotpos-r)
	(slot robotpos-c)
	(slot loaded  (allowed-values yes no)) )


; questa asserzione va ovviamente cambiata a seconda del tipo di ambiente che
; si utilizza
(deffacts init (create) (maxduration 21))

(deffacts initialmap
             (prior_cell (pos-r 1) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 2) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 3) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 4) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 5) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 6) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 7) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 8) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 9) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 10) (contains outdoor))
             (prior_cell (pos-r 1) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 2) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 2) (pos-c 2) (contains wall))
             (prior_cell (pos-r 2) (pos-c 3) (contains wall))
             (prior_cell (pos-r 2) (pos-c 4) (contains wall))
             (prior_cell (pos-r 2) (pos-c 5) (contains gate))
             (prior_cell (pos-r 2) (pos-c 6) (contains wall))
             (prior_cell (pos-r 2) (pos-c 7) (contains wall))
             (prior_cell (pos-r 2) (pos-c 8) (contains wall))
             (prior_cell (pos-r 2) (pos-c 9) (contains gate))
             (prior_cell (pos-r 2) (pos-c 10) (contains wall))
             (prior_cell (pos-r 2) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 3) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 3) (pos-c 2) (contains wall))
             (prior_cell (pos-r 3) (pos-c 3) (contains empty))
             (prior_cell (pos-r 3) (pos-c 4) (contains empty))
             (prior_cell (pos-r 3) (pos-c 5) (contains empty))
             (prior_cell (pos-r 3) (pos-c 6) (contains empty))
             (prior_cell (pos-r 3) (pos-c 7) (contains empty))
             (prior_cell (pos-r 3) (pos-c 8) (contains empty))
             (prior_cell (pos-r 3) (pos-c 9) (contains empty))
             (prior_cell (pos-r 3) (pos-c 10) (contains wall))
             (prior_cell (pos-r 3) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 4) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 4) (pos-c 2) (contains wall))
             (prior_cell (pos-r 4) (pos-c 3) (contains empty))
             (prior_cell (pos-r 4) (pos-c 4) (contains empty))
             (prior_cell (pos-r 4) (pos-c 5) (contains empty))
             (prior_cell (pos-r 4) (pos-c 6) (contains empty))
             (prior_cell (pos-r 4) (pos-c 7) (contains wall))
             (prior_cell (pos-r 4) (pos-c 8) (contains empty))
             (prior_cell (pos-r 4) (pos-c 9) (contains empty))
             (prior_cell (pos-r 4) (pos-c 10) (contains wall))
             (prior_cell (pos-r 4) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 5) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 5) (pos-c 2) (contains wall))
             (prior_cell (pos-r 5) (pos-c 3) (contains empty))
             (prior_cell (pos-r 5) (pos-c 4) (contains wall))
             (prior_cell (pos-r 5) (pos-c 5) (contains wall))
             (prior_cell (pos-r 5) (pos-c 6) (contains empty))
             (prior_cell (pos-r 5) (pos-c 7) (contains wall))
             (prior_cell (pos-r 5) (pos-c 8) (contains wall))
             (prior_cell (pos-r 5) (pos-c 9) (contains wall))
             (prior_cell (pos-r 5) (pos-c 10) (contains wall))
             (prior_cell (pos-r 5) (pos-c 11) (contains outdoor))
	     (prior_cell (pos-r 6) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 6) (pos-c 2) (contains wall))
             (prior_cell (pos-r 6) (pos-c 3) (contains empty))
             (prior_cell (pos-r 6) (pos-c 4) (contains empty))
             (prior_cell (pos-r 6) (pos-c 5) (contains wall))
             (prior_cell (pos-r 6) (pos-c 6) (contains empty))
             (prior_cell (pos-r 6) (pos-c 7) (contains empty))
             (prior_cell (pos-r 6) (pos-c 8) (contains empty))
             (prior_cell (pos-r 6) (pos-c 9) (contains empty))
             (prior_cell (pos-r 6) (pos-c 10) (contains wall))
             (prior_cell (pos-r 6) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 7) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 7) (pos-c 2) (contains gate))
             (prior_cell (pos-r 7) (pos-c 3) (contains empty))
             (prior_cell (pos-r 7) (pos-c 4) (contains empty))
             (prior_cell (pos-r 7) (pos-c 5) (contains wall))
             (prior_cell (pos-r 7) (pos-c 6) (contains empty))
             (prior_cell (pos-r 7) (pos-c 7) (contains empty))
             (prior_cell (pos-r 7) (pos-c 8) (contains empty))
             (prior_cell (pos-r 7) (pos-c 9) (contains empty))
             (prior_cell (pos-r 7) (pos-c 10) (contains gate))
             (prior_cell (pos-r 7) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 8) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 8) (pos-c 2) (contains wall))
             (prior_cell (pos-r 8) (pos-c 3) (contains empty))
             (prior_cell (pos-r 8) (pos-c 4) (contains empty))
             (prior_cell (pos-r 8) (pos-c 5) (contains wall))
             (prior_cell (pos-r 8) (pos-c 6) (contains empty))
             (prior_cell (pos-r 8) (pos-c 7) (contains empty))
             (prior_cell (pos-r 8) (pos-c 8) (contains empty))
             (prior_cell (pos-r 8) (pos-c 9) (contains empty))
             (prior_cell (pos-r 8) (pos-c 10) (contains wall))
             (prior_cell (pos-r 8) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 9) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 9) (pos-c 2) (contains wall))
             (prior_cell (pos-r 9) (pos-c 3) (contains wall))
             (prior_cell (pos-r 9) (pos-c 4) (contains wall))
             (prior_cell (pos-r 9) (pos-c 5) (contains wall))
             (prior_cell (pos-r 9) (pos-c 6) (contains wall))
             (prior_cell (pos-r 9) (pos-c 7) (contains gate))
             (prior_cell (pos-r 9) (pos-c 8) (contains wall))
             (prior_cell (pos-r 9) (pos-c 9) (contains wall))
             (prior_cell (pos-r 9) (pos-c 10) (contains wall))
             (prior_cell (pos-r 9) (pos-c 11) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 1) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 2) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 3) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 4) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 5) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 6) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 7) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 8) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 9) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 10) (contains outdoor))
             (prior_cell (pos-r 10) (pos-c 11) (contains outdoor))
             )



(defrule createworld 
        (create) => 
        (focus ENV))
        
        
;; SI PASSA AL MODULO AGENT SE NON  E' ESAURITO IL TEMPO (indicato da maxduration)

(defrule go-on-agent
   (declare (salience 20))
        (maxduration ?d)
        (status (time ?t&:(< ?t ?d)) (result no))
 => 
        ;(printout t crlf crlf)
        ;(printout t "vado ad agent  " ?t)
        (focus AGENT))

;; tempo esaurito

(defrule finish1
   (declare (salience 20))
        (maxduration ?d)
        (status (time ?d) (result no))
        (penalty ?p)
          => 
        (printout t crlf crlf)
          (printout t "time over   " ?d)
          (printout t crlf crlf)
          (printout t "penalty:" ?p)
          (printout t crlf crlf)
          (halt))

;; l'agent ha dichiarato che ha terminato il suo compito (messaggio done)

(defrule finish2
   (declare (salience 20))
        (status (time ?t) (result done))
        (penalty ?p)
          => 
        (printout t crlf crlf)
          (printout t "done at time   " ?t)
          (printout t crlf crlf)
          (printout t "penalty:" ?p)
          (printout t crlf crlf)
          (halt))


;; SI BLOCCA TUTTO SE OCCORRE DISASTER 

(defrule disaster
   (declare (salience 20))
        (status (time ?t) (result disaster))
 => 
        (printout t crlf crlf)
        (printout t "game over at time " ?t)
        (halt))



;; SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO AZIONE DA FARE

(defrule go-on-env
    (declare (salience 20))
?f1 <-  (status (time ?i))
        (exec (time ?i)) =>
        (focus ENV))
        


;; *************************************
;; *************************************
;; MODULO ENV
;;
;; *************************************



(defmodule ENV (import MAIN ?ALL)(export ?ALL))

(deftemplate cell 
                  (slot pos-r)
                  (slot pos-c)
                  (slot contains (allowed-values empty debris wall gate outdoor)))


(deftemplate debriscontent 
	(slot pos-r)
	(slot pos-c)
        (slot person (allowed-values yes no)))



(deftemplate agentstatus 
	(slot time) 
	(slot pos-r)
	(slot pos-c) 
	(slot direction)
	(slot loaded))

 
(deftemplate discovered 
	(slot time) 
	(slot pos-r)
	(slot pos-c) 
	(slot value)
	)
                         
(defrule creation
 ?f1 <- (create) =>
     (assert (cell (pos-r 1) (pos-c 1) (contains outdoor))
             (cell (pos-r 1) (pos-c 2) (contains outdoor))
             (cell (pos-r 1) (pos-c 3) (contains outdoor))
             (cell (pos-r 1) (pos-c 4) (contains outdoor))
             (cell (pos-r 1) (pos-c 5) (contains outdoor))
             (cell (pos-r 1) (pos-c 6) (contains outdoor))
             (cell (pos-r 1) (pos-c 7) (contains outdoor))
             (cell (pos-r 1) (pos-c 8) (contains outdoor))
             (cell (pos-r 1) (pos-c 9) (contains outdoor))
             (cell (pos-r 1) (pos-c 10) (contains outdoor))
             (cell (pos-r 1) (pos-c 11) (contains outdoor))
             (cell (pos-r 2) (pos-c 1) (contains outdoor))
             (cell (pos-r 2) (pos-c 2) (contains wall))
             (cell (pos-r 2) (pos-c 3) (contains wall))
             (cell (pos-r 2) (pos-c 4) (contains wall))
             (cell (pos-r 2) (pos-c 5) (contains gate))
             (cell (pos-r 2) (pos-c 6) (contains wall))
             (cell (pos-r 2) (pos-c 7) (contains wall))
             (cell (pos-r 2) (pos-c 8) (contains wall))
             (cell (pos-r 2) (pos-c 9) (contains gate))
             (cell (pos-r 2) (pos-c 10) (contains wall))
             (cell (pos-r 2) (pos-c 11) (contains outdoor))
             (cell (pos-r 3) (pos-c 1) (contains outdoor))
             (cell (pos-r 3) (pos-c 2) (contains wall))
             (cell (pos-r 3) (pos-c 3) (contains empty))
             (cell (pos-r 3) (pos-c 4) (contains debris))
             (cell (pos-r 3) (pos-c 5) (contains empty))
             (cell (pos-r 3) (pos-c 6) (contains empty))
             (cell (pos-r 3) (pos-c 7) (contains empty))
             (cell (pos-r 3) (pos-c 8) (contains empty))
             (cell (pos-r 3) (pos-c 9) (contains empty))
             (cell (pos-r 3) (pos-c 10) (contains wall))
             (cell (pos-r 3) (pos-c 11) (contains outdoor))
             (cell (pos-r 4) (pos-c 1) (contains outdoor))
             (cell (pos-r 4) (pos-c 2) (contains wall))
             (cell (pos-r 4) (pos-c 3) (contains empty))
             (cell (pos-r 4) (pos-c 4) (contains debris))
             (cell (pos-r 4) (pos-c 5) (contains empty))
             (cell (pos-r 4) (pos-c 6) (contains empty))
             (cell (pos-r 4) (pos-c 7) (contains debris))
             (cell (pos-r 4) (pos-c 8) (contains debris))
             (cell (pos-r 4) (pos-c 9) (contains empty))
             (cell (pos-r 4) (pos-c 10) (contains wall))
             (cell (pos-r 4) (pos-c 11) (contains outdoor))
             (cell (pos-r 5) (pos-c 1) (contains outdoor))
             (cell (pos-r 5) (pos-c 2) (contains wall))
             (cell (pos-r 5) (pos-c 3) (contains empty))
             (cell (pos-r 5) (pos-c 4) (contains wall))
             (cell (pos-r 5) (pos-c 5) (contains wall))
             (cell (pos-r 5) (pos-c 6) (contains empty))
             (cell (pos-r 5) (pos-c 7) (contains wall))
             (cell (pos-r 5) (pos-c 8) (contains wall))
             (cell (pos-r 5) (pos-c 9) (contains wall))
             (cell (pos-r 5) (pos-c 10) (contains wall))
             (cell (pos-r 5) (pos-c 11) (contains outdoor))
	     (cell (pos-r 6) (pos-c 1) (contains outdoor))
             (cell (pos-r 6) (pos-c 2) (contains debris))
             (cell (pos-r 6) (pos-c 3) (contains empty))
             (cell (pos-r 6) (pos-c 4) (contains empty))
             (cell (pos-r 6) (pos-c 5) (contains wall))
             (cell (pos-r 6) (pos-c 6) (contains empty))
             (cell (pos-r 6) (pos-c 7) (contains debris))
             (cell (pos-r 6) (pos-c 8) (contains debris))
             (cell (pos-r 6) (pos-c 9) (contains empty))
             (cell (pos-r 6) (pos-c 10) (contains wall))
             (cell (pos-r 6) (pos-c 11) (contains outdoor))
             (cell (pos-r 7) (pos-c 1) (contains outdoor))
             (cell (pos-r 7) (pos-c 2) (contains debris))
             (cell (pos-r 7) (pos-c 3) (contains empty))
             (cell (pos-r 7) (pos-c 4) (contains empty))
             (cell (pos-r 7) (pos-c 5) (contains wall))
             (cell (pos-r 7) (pos-c 6) (contains empty))
             (cell (pos-r 7) (pos-c 7) (contains empty))
             (cell (pos-r 7) (pos-c 8) (contains debris))
             (cell (pos-r 7) (pos-c 9) (contains empty))
             (cell (pos-r 7) (pos-c 10) (contains gate))
             (cell (pos-r 7) (pos-c 11) (contains outdoor))
             (cell (pos-r 8) (pos-c 1) (contains outdoor))
             (cell (pos-r 8) (pos-c 2) (contains wall))
             (cell (pos-r 8) (pos-c 3) (contains empty))
             (cell (pos-r 8) (pos-c 4) (contains empty))
             (cell (pos-r 8) (pos-c 5) (contains wall))
             (cell (pos-r 8) (pos-c 6) (contains empty))
             (cell (pos-r 8) (pos-c 7) (contains empty))
             (cell (pos-r 8) (pos-c 8) (contains empty))
             (cell (pos-r 8) (pos-c 9) (contains debris))
             (cell (pos-r 8) (pos-c 10) (contains wall))
             (cell (pos-r 8) (pos-c 11) (contains outdoor))
             (cell (pos-r 9) (pos-c 1) (contains outdoor))
             (cell (pos-r 9) (pos-c 2) (contains wall))
             (cell (pos-r 9) (pos-c 3) (contains wall))
             (cell (pos-r 9) (pos-c 4) (contains wall))
             (cell (pos-r 9) (pos-c 5) (contains wall))
             (cell (pos-r 9) (pos-c 6) (contains wall))
             (cell (pos-r 9) (pos-c 7) (contains gate))
             (cell (pos-r 9) (pos-c 8) (contains debris))
             (cell (pos-r 9) (pos-c 9) (contains debris))
             (cell (pos-r 9) (pos-c 10) (contains wall))
             (cell (pos-r 9) (pos-c 11) (contains outdoor))
             (cell (pos-r 10) (pos-c 1) (contains outdoor))
             (cell (pos-r 10) (pos-c 2) (contains outdoor))
             (cell (pos-r 10) (pos-c 3) (contains outdoor))
             (cell (pos-r 10) (pos-c 4) (contains outdoor))
             (cell (pos-r 10) (pos-c 5) (contains outdoor))
             (cell (pos-r 10) (pos-c 6) (contains outdoor))
             (cell (pos-r 10) (pos-c 7) (contains outdoor))
             (cell (pos-r 10) (pos-c 8) (contains outdoor))
             (cell (pos-r 10) (pos-c 9) (contains outdoor))
             (cell (pos-r 10) (pos-c 10) (contains outdoor))
             (cell (pos-r 10) (pos-c 11) (contains outdoor))
             )


     
     (assert (debriscontent (pos-r 3) (pos-c 4) (person yes))
             (debriscontent (pos-r 4) (pos-c 4) (person no))
             (debriscontent (pos-r 4) (pos-c 7) (person no))
             (debriscontent (pos-r 4) (pos-c 8) (person yes))
             (debriscontent (pos-r 6) (pos-c 2) (person no))
             (debriscontent (pos-r 6) (pos-c 7) (person yes))
             (debriscontent (pos-r 6) (pos-c 8) (person no))
             (debriscontent (pos-r 7) (pos-c 3) (person no))
             (debriscontent (pos-r 7) (pos-c 8) (person yes))
             (debriscontent (pos-r 8) (pos-c 9) (person yes))
             (debriscontent (pos-r 9) (pos-c 8) (person no))
             (debriscontent (pos-r 9) (pos-c 9) (person no))
             )
     (assert (discovered (time 0) (pos-r 3) (pos-c 4) (value no))
             (discovered (time 0) (pos-r 4) (pos-c 8) (value no))
             (discovered (time 0) (pos-r 6) (pos-c 7) (value no))
             (discovered (time 0) (pos-r 7) (pos-c 8) (value no))
             (discovered (time 0) (pos-r 8) (pos-c 9) (value no))
             )
     (retract ?f1)
     (assert (status (time 0) (result no))
             (agentstatus (pos-r 2) (pos-c 5) (time 0)(direction up) (loaded no))
             (penalty 0))
     (focus MAIN))


;;*****************************************************
;;*****************************************************
;;      AZIONI DI MOVIMENTO
;;


(defrule move-up-ok 
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c)(direction up))
        (cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains empty|gate))
        
       => (modify  ?f1 (pos-r (+ ?r 1)) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))


(defrule move-up-bump 
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c)(direction up))
        (cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains wall|debris|outdoor))
  ?f3<- (penalty ?p)
        => (modify  ?f1 (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-bump (time (+ ?i 1))(pos-r ?r) (pos-c ?c) (direction up)
                              (bump yes))
                   (penalty (+ ?p 500))
                    )
           (retract ?f3))

(defrule move-down-ok     
   (declare (salience 20)) 
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c)(direction down))
        (cell (pos-r =(- ?r 1)) (pos-c ?c) (contains empty|gate))
        => (modify  ?f1 (pos-r (- ?r 1)) (time (+ ?i 1)))
           (modify  ?f2 (time (+ ?i 1))))
           


(defrule move-down-bump     
  (declare (salience 20)) 
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c)(direction down))
        (cell (pos-r =(- ?r 1)) (pos-c ?c) (contains wall|debris|outdoor))
  ?f3<- (penalty ?p)       
        => 
           (modify  ?f1 (time (+ ?i 1)))
           (modify  ?f2 (time (+ ?i 1)))
           (assert (perc-bump (time (+ ?i 1))(pos-r ?r) (pos-c ?c) (direction down)
                              (bump yes))
                   (penalty (+ ?p 500))
                   )
           (retract ?f3))



(defrule move-left-ok 
   (declare (salience 20))     
   ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c) (direction left)) 
        (cell (pos-r ?r) (pos-c =(- ?c 1)) (contains empty|gate))
        => (modify  ?f1 (pos-c (- ?c 1)) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))


(defrule move-left-bump 
   (declare (salience 20))     
   ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c) (direction left))
        (cell (pos-r ?r) (pos-c =(- ?c 1)) (contains wall|debris|outdoor))
  ?f3<- (penalty ?p)
        => (modify ?f1 (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-bump (time (+ ?i 1))(pos-r ?r) (pos-c ?c) (direction left)
                              (bump yes))
                   (penalty (+ ?p 500))
                   )
           (retract ?f3))


(defrule move-right-ok
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c) (direction right))
        (cell (pos-r ?r) (pos-c =(+ ?c 1)) (contains empty|gate))
        => (modify  ?f1 (pos-c (+ ?c 1))(time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))


(defrule move-right-bump
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  go))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c) (direction right))
        (cell (pos-r ?r) (pos-c =(+ ?c 1)) (contains wall|debris|outdoor))
  ?f3<- (penalty ?p)
        => (modify ?f1 (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-bump (time (+ ?i 1))(pos-r ?r) (pos-c ?c) (direction right)
                             (bump yes))
                   (penalty (+ ?p 500))
           )
           (retract ?f3))




(defrule turnleft1
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnleft))
  ?f1<- (agentstatus (direction left))
        => (modify  ?f1 (direction down) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnleft2
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnleft))
  ?f1<- (agentstatus (direction down ))
        => (modify  ?f1 (direction right) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnleft3
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnleft))
  ?f1<- (agentstatus (direction right))
        => (modify  ?f1 (direction up) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnleft4
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnleft))
  ?f1<- (agentstatus (direction up))
        => (modify  ?f1 (direction left) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnright1
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnright))
  ?f1<- (agentstatus (direction left))
        => (modify  ?f1 (direction up) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnright2
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnright))
  ?f1<- (agentstatus (direction up))
        => (modify  ?f1 (direction right) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnright3
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnright))
  ?f1<- (agentstatus (direction right))
        => (modify  ?f1 (direction down) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))

(defrule turnright4
   (declare (salience 20))      
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  turnright))
  ?f1<- (agentstatus (direction down))
        => (modify  ?f1 (direction left) (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1))))


;;*****************************************************
;;
;;       DRILL
;;


(defrule drill-up-ok
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains debris))
        (debriscontent (pos-r ?r) (pos-c ?c) (person ?p))
  ?f1<- (agentstatus (pos-r =(- ?r 1)) (pos-c ?c)(direction up))
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill  (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill ?p)))
           )

(defrule drill-up-ko
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains ~debris))
  ?f1<- (agentstatus (pos-r ?r1) (pos-c ?c)(direction up))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill fail))
                   (penalty (+ ?p 200))
                   )
           (retract ?f3))


(defrule drill-down-ok
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains debris))
        (debriscontent (pos-r ?r) (pos-c ?c) (person ?p))
  ?f1<- (agentstatus (pos-r =(+ ?r 1)) (pos-c ?c)(direction down))
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill  (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill ?p)))
           )           


(defrule drill-down-ko
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains ~debris))
  ?f1<- (agentstatus (pos-r ?r1) (pos-c ?c)(direction down))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill fail))
                   (penalty (+ ?p 200))
                   )
           (retract ?f3))


(defrule drill-right-ok
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains debris))
        (debriscontent (pos-r ?r) (pos-c ?c) (person ?p))
  ?f1<- (agentstatus (pos-c =(- ?c 1)) (pos-r ?r)(direction right))
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill  (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill ?p)))
           )

(defrule drill-right-ko
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains ~debris))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c1)(direction right))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill fail))
                   (penalty (+ ?p 200))
                   )
           (retract ?f3))


(defrule drill-left-ok
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains debris))
        (debriscontent (pos-r ?r) (pos-c ?c) (person ?p))
  ?f1<- (agentstatus (pos-c =(+ ?c 1)) (pos-r ?r)(direction left))
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill  (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill ?p)))
           )

(defrule drill-left-ko
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?r) (param2 ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains ~debris))
  ?f1<- (agentstatus (pos-r ?r) (pos-c ?c1)(direction left))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill (time (+ ?i 1)) (pos-r ?r) (pos-c ?c) (drill fail))
                   (penalty (+ ?p 200))
                   )
           (retract ?f3))



(defrule drill_KO_too_far
   (declare (salience 19))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  drill) (param1 ?x) (param2 ?y))
  ?f1<- (agentstatus (time ?i) (pos-r ?r) (pos-c ?c))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-drill (time (+ ?i 1)) (pos-r ?x) (pos-c ?y) (drill fail))
                   (penalty (+ ?p 200))
                   )
           (retract ?f3))


;;;;******************************
;;;;******************************
;;;;          LOAD_DEBRIS



(defrule load_OK_up
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person no))
  ?f1<- (agentstatus (time ?i) (pos-r =(- ?x 1)) (pos-c ?y) (loaded no))
        => (modify  ?f1  (time (+ ?i 1)) (loaded yes))
           (modify ?f3 (contains empty))
           (modify ?f2 (time (+ ?i 1)))
           (retract ?f4)
           (assert (perc-loaded  (time (+ ?i 1)) (robotpos-r =(- ?x 1))
	                       (robotpos-c ?y) (loaded  yes)))
           )

(defrule load_person_up
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person yes))
  ?f1<- (agentstatus (time ?i) (pos-r =(- ?x 1)) (pos-c ?y))
        => 
           (modify ?f2 (time (+ ?i 1)) (result disaster))
           (printout t crlf crlf)
           (printout t "disaster at time " ?i)
           (printout t crlf crlf)
           (printout t "exec of load_debris with person in (" ?x ","  ?y ")")
           (printout t crlf crlf)
           (focus MAIN)
           )

(defrule load_OK_down
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person no))
  ?f1<- (agentstatus (time ?i) (pos-r =(+ ?x 1)) (pos-c ?y) (loaded no))
        => (modify  ?f1  (time (+ ?i 1)) (loaded yes))
           (modify ?f3 (contains empty))
           (modify ?f2 (time (+ ?i 1)))
           (retract ?f4)
           (assert (perc-loaded (time (+ ?i 1)) (robotpos-r =(+ ?x 1))
	                       (robotpos-c ?y) (loaded  yes)))
           )
           
 (defrule load_person_down
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person yes))
  ?f1<- (agentstatus (time ?i) (pos-r =(+ ?x 1)) (pos-c ?y))
        => 
           (modify ?f2 (time (+ ?i 1)) (result disaster))
           (printout t "disaster at time " ?i)
           (printout t crlf crlf)
           (printout t "exec of load_debris with person in (" ?x ","  ?y ")")
           (printout t crlf crlf)
           (focus MAIN)
           )



 
(defrule load_OK_right
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person no))
  ?f1<- (agentstatus (time ?i) (pos-r ?x) (pos-c =(- ?y 1)) (loaded no))
        => (modify  ?f1  (time (+ ?i 1)) (loaded yes))
           (modify ?f3 (contains empty))
           (modify ?f2 (time (+ ?i 1)))
           (retract ?f4)
           (assert (perc-loaded (time (+ ?i 1)) (robotpos-r ?x)
	                       (robotpos-c =(- ?y 1)) (loaded  yes)))
           )

(defrule load_person_right
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person yes))
  ?f1<- (agentstatus (time ?i) (pos-r ?x) (pos-c =(- ?y 1)))
        => 
           (modify ?f2 (time (+ ?i 1)) (result disaster))
           (printout t crlf crlf)
           (printout t "disaster at time " ?i)
           (printout t crlf crlf)
           (printout t "exec of load_debris with person in (" ?x ","  ?y ")")
           (focus MAIN)
           )
          
    

  (defrule load_OK_left
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person no))
  ?f1<- (agentstatus (time ?i) (pos-r ?x) (pos-c =(+ ?y 1)) (loaded no))
        => (modify  ?f1  (time (+ ?i 1)) (loaded yes))
           (modify ?f3 (contains empty))
           (modify ?f2 (time (+ ?i 1)))
           (retract ?f4)
           (assert (perc-loaded  (time (+ ?i 1)) (robotpos-r ?x)
	                       (robotpos-c =(+ ?y 1)) (loaded  yes)))
           )

(defrule load_person_left
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains debris))
  ?f4<- (debriscontent (pos-r ?x) (pos-c ?y) (person yes))
  ?f1<- (agentstatus (time ?i) (pos-r ?x) (pos-c =(+ ?y 1)))
        => 
           (modify ?f2 (time (+ ?i 1)) (result disaster))
           (printout t crlf crlf)
           (printout t "disaster at time " ?i)
           (printout t crlf crlf)
           (printout t "exec of load_debris with person in (" ?x ","  ?y ")")
           (printout t crlf crlf)
           (focus MAIN)
           )
                   

(defrule load_KO
   (declare (salience 19))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  load_debris) (param1 ?x) (param2 ?y))
  ?f1<- (agentstatus (time ?i) (pos-r ?r) (pos-c ?c) (loaded ?load))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-loaded  (time (+ ?i 1)) (robotpos-r ?r)
	                       (robotpos-c ?c) (loaded ?load))
                   (penalty (+ ?p 200)))
           (retract ?f3)
           )



;;;;******************************
;;;;******************************
;;;;          UNLOAD_DEBRIS




(defrule unload_OK_up
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  unload_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains empty))
  ?f1<- (agentstatus (time ?i) (pos-r =(- ?x 1)) (pos-c ?y) (loaded yes))
            
        => (modify  ?f1  (time (+ ?i 1)) (loaded no))
           (modify ?f3 (contains debris))
           (modify ?f2 (time (+ ?i 1)))
           (assert (debriscontent (pos-r ?x) (pos-c ?y) (person no))
                   (perc-loaded  (time (+ ?i 1)) (robotpos-r =(- ?x 1))
	                       (robotpos-c ?y) (loaded  no)))
           )


(defrule unload_OK_down
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  unload_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains empty))
  ?f1<- (agentstatus (time ?i) (pos-r =(+ ?x 1)) (pos-c ?y) (loaded yes))
            
        => (modify  ?f1  (time (+ ?i 1)) (loaded no))
           (modify ?f3 (contains debris))
           (modify ?f2 (time (+ ?i 1)))
           (assert (debriscontent (pos-r ?x) (pos-c ?y) (person no))
                   (perc-loaded (time (+ ?i 1)) (robotpos-r =(+ ?x 1))
	                       (robotpos-c ?y) (loaded  no)))
           )


           

(defrule unload_OK_right
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  unload_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains empty))
  ?f1<- (agentstatus (time ?i) (pos-r ?x) (pos-c =(- ?y 1)) (loaded yes))
            
        => (modify  ?f1  (time (+ ?i 1)) (loaded no))
           (modify ?f3 (contains debris))
           (modify ?f2 (time (+ ?i 1)))
           (assert (debriscontent (pos-r ?x) (pos-c ?y) (person no))
                   (perc-loaded (time (+ ?i 1)) (robotpos-r ?x)
	                       (robotpos-c =(- ?y 1)) (loaded  no)))
           )

(defrule unload_OK_left
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  unload_debris) (param1 ?x) (param2 ?y))
  ?f3<- (cell (pos-r ?x) (pos-c ?y) (contains empty))
  ?f1<- (agentstatus (time ?i) (pos-r ?x) (pos-c =(+ ?y 1)) (loaded yes))
            
        => (modify  ?f1  (time (+ ?i 1)) (loaded no))
           (modify ?f3 (contains debris))
           (modify ?f2 (time (+ ?i 1)))
           (assert (debriscontent (pos-r ?x) (pos-c ?y) (person no))
                   (perc-loaded  (time (+ ?i 1)) (robotpos-r ?x)
	                       (robotpos-c =(+ ?y 1)) (loaded  no)))
           )


(defrule unload_KO
   (declare (salience 19))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  unload_debris) (param1 ?x) (param2 ?y))
  ?f1<- (agentstatus (time ?i) (pos-r ?r) (pos-c ?c) (loaded ?load))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (perc-loaded (time (+ ?i 1)) (robotpos-r ?r)
	                       (robotpos-c ?c) (loaded ?load))
                   (penalty (+ ?p 200)))
           (retract ?f3)
           )




;;;;******************************
;;;;******************************
;;;;          INFORM


(defrule inform_ok
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  inform) (param1 ?x) (param2 ?y))
        (debriscontent (pos-r ?x) (pos-c ?y) (person yes))
  ?f3<- (discovered (time ?i) (pos-r ?x) (pos-c ?y) (value no))
  ?f1<- (agentstatus (time ?i))
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (modify ?f3 (value yes))
           )

(defrule inform_repeated
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  inform) (param1 ?x) (param2 ?y))
        (discovered (time ?i) (pos-r ?x) (pos-c ?y) (value yes))
  ?f1<- (agentstatus (time ?i))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (retract ?f3)
           (assert (penalty (+ ?p 50)))
           )

(defrule inform_KO
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  inform) (param1 ?x) (param2 ?y))
        (not (debriscontent (pos-r ?x) (pos-c ?y) (person yes)))
  ?f1<- (agentstatus (time ?i))
  ?f3<- (penalty ?p)
        => (modify  ?f1  (time (+ ?i 1)))
           (modify ?f2 (time (+ ?i 1)))
           (assert (penalty (+ ?p 2000)))
           (retract ?f3))


;;;;******************************
;;;;******************************
;;;;          DONE


(defrule done-undiscovered
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  done))
  ?f3<- (discovered (time ?i) (pos-r ?x) (pos-c ?y) (value no))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 1500)))
           (retract ?f1 ?f3)
           )


(defrule done-no-gate
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  done))
        (agentstatus (time ?i) (pos-r ?r) (pos-c ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains ~gate))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 200)))
           (retract ?f1)
          (modify ?f2 (time (+ ?i 1)) (result done))
           (focus MAIN)
)


(defrule done-in-gate
   (declare (salience 20))    
  ?f2<- (status (time ?i)) 
        (exec (time ?i) (action  done))
        (agentstatus (time ?i) (pos-r ?r) (pos-c ?c))
        (cell (pos-r ?r) (pos-c ?c) (contains gate))

        => 
          (modify ?f2 (time (+ ?i 1)) (result done))
           (focus MAIN)
)




;;;;******************************************
;;;;******************************************
;;;;          GESTIONE PENALTY

(defrule penalty-manager1
   (declare (salience 10))    
        (status (time ?i))
        (debriscontent (pos-r ?r) (pos-c ?c) (person yes))
  ?f1<- (discovered (time =(- ?i 1)) (pos-r ?r) (pos-c ?c) (value no)) 
  ?f3<- (penalty ?p)
        => (assert (discovered (time ?i) (pos-r ?r) (pos-c ?c) (value no))
                   (penalty (+ ?p 5)))
           (retract ?f3 ?f1)
           )


(defrule penalty-manager2
   (declare (salience 10))    
        (status (time ?i))
        (debriscontent (pos-r ?r) (pos-c ?c) (person yes))
  ?f1<- (discovered (time =(- ?i 1)) (pos-r ?r) (pos-c ?c) (value yes)) 
        => (assert (discovered (time ?i) (pos-r ?r) (pos-c ?c) (value yes))
                   )
           (retract ?f1)
           )


(defrule time-over-undiscovered
   (declare (salience 9))
        (maxduration ?d)    
  ?f2<- (status (time ?d) (result no)) 
  ?f3<- (discovered (time ?i) (pos-r ?x) (pos-c ?y) (value no))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 1000)))
           (retract ?f1 ?f3)
           )


;;;;******************************************
;;;;******************************************
;;;;          GENERAZIONE PERCEZIONI ACUSTICHE


(defrule percept-acoust-yes
(declare (salience 8))
     (agentstatus (pos-r ?r) (pos-c ?c) (time ?t))
     (or (and (cell (pos-r ?r) (pos-c ?c) (contains debris))
              (debriscontent (pos-r ?r) (pos-c ?c) (person yes)))
         (and (cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains debris))
              (debriscontent (pos-r =(+ ?r 1)) (pos-c ?c) (person yes)))
         (and (cell (pos-r =(- ?r 1)) (pos-c ?c) (contains debris))
              (debriscontent (pos-r =(- ?r 1)) (pos-c ?c) (person yes)))
         (and (cell (pos-r ?r) (pos-c =(+ ?c 1)) (contains debris))
              (debriscontent (pos-r ?r) (pos-c =(+ ?c 1)) (person yes)))
         (and (cell (pos-r ?r) (pos-c =(- ?c 1)) (contains debris))
              (debriscontent (pos-r ?r) (pos-c =(- ?c 1)) (person yes)))
      )
     => (assert (perc-acoust (time ?t) (pos-r ?r) (pos-c ?c) (ac yes)))
        )


(defrule percept-acoust-no
(declare (salience 7))
     (agentstatus (pos-r ?r) (pos-c ?c) (time ?t))
     (not (perc-acoust (time ?t)))
     => (assert (perc-acoust (time ?t) (pos-r ?r) (pos-c ?c) (ac no)))
        )







;;;;******************************************
;;;;******************************************
;;;;          GENERAZIONE PERCEZIONI VISIVE


(defrule percept-up
(declare (salience 5))
  ?f1<- (agentstatus (time ?t) (pos-r ?r) (pos-c ?c) (direction up)) 
        (cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x1))
        (cell (pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x2))
        (cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x3))
        (cell (pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x4))
        (cell (pos-r ?r)  (pos-c ?c)  (contains ?x5))
        (cell (pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x6))
        (cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x7))
        (cell (pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x8))
        (cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x9))
      => 
        (assert (perc-vision (time ?t) (pos-r ?r) (pos-c ?c) (direction up) 
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
        (focus MAIN)
       )


(defrule percept-down
(declare (salience 5))
  ?f1<- (agentstatus (time ?t) (pos-r ?r) (pos-c ?c) (direction down)) 
        (cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x1))
        (cell (pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x2))
        (cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x3))
        (cell (pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x4))
        (cell (pos-r ?r)  (pos-c ?c)  (contains ?x5))
        (cell (pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x6))
        (cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x7))
        (cell (pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x8))
        (cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x9))
        
     => 
        (assert (perc-vision (time ?t) (pos-r ?r) (pos-c ?c) (direction down) 
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
        (focus MAIN)
       )




(defrule percept-right
(declare (salience 5))
  ?f1<- (agentstatus (time ?t) (pos-r ?r) (pos-c ?c) (direction right)) 
        (cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x1))
        (cell (pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x2))
        (cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x3))
        (cell (pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x4))
        (cell (pos-r ?r)  (pos-c ?c)  (contains ?x5))
        (cell (pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x6))
        (cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x7))
        (cell (pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x8))
        (cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x9))
     => 
        (assert (perc-vision (time ?t) (pos-r ?r) (pos-c ?c) (direction right) 
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
        (focus MAIN)
       )




(defrule percept-left
(declare (salience 5))
  ?f1<- (agentstatus (time ?t) (pos-r ?r) (pos-c ?c) (direction left)) 
        (cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x1))
        (cell (pos-r ?r)  (pos-c =(- ?c 1)) (contains ?x2))
        (cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x3))
        (cell (pos-r =(- ?r 1)) (pos-c ?c)  (contains ?x4))
        (cell (pos-r ?r)  (pos-c ?c)  (contains ?x5))
        (cell (pos-r =(+ ?r 1)) (pos-c ?c)  (contains ?x6))
        (cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x7))
        (cell (pos-r ?r)  (pos-c =(+ ?c 1)) (contains ?x8))
        (cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x9))
     => 
        (assert (perc-vision (time ?t) (pos-r ?r) (pos-c ?c) (direction left) 
                           (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
                           (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
                           (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)))
        (focus MAIN)
       )





(defmodule AGENT (import MAIN ?ALL))

(deftemplate kagent (slot time) (slot pos-r) (slot pos-c) (slot direction) (slot load))

(defrule  beginagent
    (declare (salience 10))
    (status (time 0))
    => 
    (assert (kagent (time 0) (pos-r 2) (pos-c 5) (direction up) (load no)))
    )

;;(defrule ask_act
 ;;?f <-   (status (time ?t))
  ;;  =>  (printout t crlf crlf)
   ;;     (printout t "action to be executed at time:" ?t)
    ;;    (printout t crlf crlf)
     ;;   (modify ?f (result no)))

(defrule exec_act
    (status (time ?t))
    (exec (time ?t))
 => (focus MAIN))



; Nel seguito viene riportata una semplice sequenza di comandi che dovrebbe
; servire a verificare il comportamento del modulo ENV nel dominio descritto 
; nel file precedente

;(assert (exec (action go) (time 0)))
;(assert (exec (action go) (time 1)))
;(assert (exec (action go) (time 2)))
;(assert (exec (action load_debris) (time  3) (param1 4) (param2 4))) 

;(assert (exec (action unload_debris) (time  4) (param1 3) (param2 5)))
;(assert (exec (action turnleft) (time 5)))
;(assert (exec (action go) (time 6)))
;(assert (exec (action drill) (time 7) (param1 3) (param2 4)))
;(assert (exec (action turnleft) (time 8)))
;(assert (exec (action drill) (time 9) (param1 3) (param2 4)))
;(assert (exec (action inform) (time 10)( param1 3) (param2 4)))
;(assert (exec (action turnright) (time 11)))
;(assert (exec (action go) (time 12)))
;(assert (exec (action turnright) (time 13)))
;(assert (exec (action go) (time 14)))

;(assert (exec (action go) (time 15)))
;(assert (exec (action load_debris) (time  16) (param1 6) (param2 2))) 
;(assert (exec (action unload_debris) (time  17) (param1 6) (param2 4)))
;(assert (exec (action turnleft) (time 18)))
;(assert (exec (action go) (time 19)))
;(assert (exec (action go) (time 20)))
;

(defrule turno0
 ?f <-   (status (time 0))
    =>  (printout t crlf crlf)
        (printout t "aziono 0")
        (printout t crlf crlf)
        (assert (exec (action go) (time 0))))

(defrule turno1
 ?f <-   (status (time 1))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action go) (time 1))))

(defrule turno2
 ?f <-   (status (time 2))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action go) (time 2))))

(defrule turno3
 ?f <-   (status (time 3))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action load_debris) (time  3) (param1 4) (param2 4))))

(defrule turno4
 ?f <-   (status (time 4))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action unload_debris) (time  4) (param1 3) (param2 5))))


(defrule turno5
 ?f <-   (status (time 5))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action turnleft) (time 5))))

(defrule turno6
 ?f <-   (status (time 6))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action go) (time 6))))

(defrule turno7
 ?f <-   (status (time 7))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action drill) (time 7) (param1 3) (param2 4))))

(defrule turno8
 ?f <-   (status (time 8))
    =>  (printout t crlf crlf)
        (printout t crlf crlf)
        (assert (exec (action turnleft) (time 8))))

(defrule turno9  ?f <-   (status (time 9))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action drill) (time 9) (param1 3) (param2 4))))
(defrule turno10  ?f <-   (status (time 10))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action inform) (time 10)( param1 3) (param2 4))))
(defrule turno11  ?f <-   (status (time 11))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action turnright) (time 11))))
(defrule turno12  ?f <-   (status (time 12))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action go) (time 12))))
(defrule turno13  ?f <-   (status (time 13))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action turnright) (time 13))))
(defrule turno14  ?f <-   (status (time 14))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action go) (time 14))))

(defrule turno15  ?f <-   (status (time 15))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action go) (time 15))))
(defrule turno16  ?f <-   (status (time 16))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action load_debris) (time  16) (param1 6) (param2 2))))
(defrule turno17  ?f <-   (status (time 17))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action unload_debris) (time  17) (param1 6) (param2 4))))
(defrule turno18  ?f <-   (status (time 18))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action turnleft) (time 18))))
(defrule turno19  ?f <-   (status (time 19))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action go) (time 19))))
(defrule turno20  ?f <-   (status (time 20))     =>  (printout t crlf crlf)         (printout t crlf crlf)(assert (exec (action go) (time 20))))



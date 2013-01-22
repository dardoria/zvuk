(in-package :zvuk)

(defun test-with-sound (freq)
    (with-sound    
	(let ((testo (make-oscil freq)))
	  (loop repeat (* 100000)
	     do (outa (oscil testo))))))

(defun simple()
  (let ((o1 (mus-make-oscil 440.0d0 0.0d0))
	(o2 (mus-make-oscil 550.0d0 0.0d0)))
    (loop repeat 20
       collect (values 
		
		(mus-oscil o1 0.0d0 0.0d0)
		(mus-oscil o2 0.0d0 0.0d0)))))


	  
    
(in-package :zvuk)

;; (defun produce-sound ()
;;   (let ((testo (make-oscil)))
;;     (loop repeat 100
;;        do (let ((outbuffer (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16)))) 
;; 	    (loop for i below (length outbuffer)
;; 	       do (setf (aref outbuffer i) (mus-sample-to-short (oscil testo))))
;; 	    (send-message *mailbox* outbuffer)))))

;; (defun test ()
;;   (stop-player)
;;   (start-player)
;;   (produce-sound))

(defun test ()
  (zvuk-out)
  (zvuk-out2)
  (zvuk-out3))

(defun zvuk-out ()
  (make-thread '%z-run))
  

(defun zvuk-out2 ()
  (make-thread '%z-run2))

(defun zvuk-out3 ()
  (make-thread '%z-run3))

(defun %z-run ()
  (let ((testo (make-oscil)))
    (loop repeat (* 10000)
	 do (outa (oscil testo)))))

(defun %z-run2 ()
  (let ((testo (make-oscil 600.0)))
    (loop repeat (* 10000)
	 do (outb (oscil testo)))))

(defun %z-run3 ()
  (let ((testo (make-oscil 600.0)))
    (loop repeat (* 10000)
	 do (outb (oscil testo)))))

(defun test-with-sound ()
    (with-sound    
	(let ((testo (make-oscil 600.0)))
	  (loop repeat (* 10000)
	     do (outb (oscil testo))))))

  (defun simple()
  (let ((o1 (mus-make-oscil 440.0d0 0.0d0))
	(o2 (mus-make-oscil 550.0d0 0.0d0)))
    (loop repeat 20
       collect (values 
		
		(mus-oscil o1 0.0d0 0.0d0)
		(mus-oscil o2 0.0d0 0.0d0)))))


	  
    
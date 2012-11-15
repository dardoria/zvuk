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
  (zvuk-out2))

(defun zvuk-out ()
  (make-thread '%z-run))
  

(defun zvuk-out2 ()
  (make-thread '%z-run2))

(defun %z-run ()
  (let ((testo (make-oscil)))
    (loop repeat (* 5000)
	 do (outa (oscil testo)))))

(defun %z-run2 ()
  (let ((testo (make-oscil 550.0)))
    (loop repeat (* 1000)
	 do (outb (oscil testo)))))

;       do (let ((outbuffer (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16)))) 
;	    (loop for i below (length outbuffer)
;	       do (setf (aref outbuffer i) (mus-sample-to-short (oscil testo))))
;	    (outb outbuffer)))))
    
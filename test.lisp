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

(defun zvuk-out ()
  (make-thread '%z-run))
  

(defun zvuk-out2 ()
  (make-thread '%z-run2))

(defun %z-run ()
  (let ((mailbox (make-mailbox))
	(testo (make-oscil)))

    (send-message *mailbox* mailbox)

    (loop repeat 500
       do (let ((outbuffer (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16)))) 
	    (loop for i below (length outbuffer)
	       do (setf (aref outbuffer i) (mus-sample-to-short (oscil testo))))
	    (send-message mailbox outbuffer)))))


(defun %z-run2 ()
  (let ((mailbox (make-mailbox))
	(testo (make-oscil 550.0)))

    (send-message *mailbox* mailbox)

    (loop repeat 100
       do (let ((outbuffer (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16)))) 
	    (loop for i below (length outbuffer)
	       do (setf (aref outbuffer i) (mus-sample-to-short (oscil testo))))
	    (send-message mailbox outbuffer)))))
    
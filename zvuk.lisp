(in-package :zvuk)

;;;; set error and print handler
(defcallback mus-error-handler :void ((type :int) (msg :pointer))
  (declare (ignorable type))
  (error "~a" (foreign-string-to-lisp msg)))

(mus-error-set-handler (callback mus-error-handler))

(defcallback mus-print-handler :void ((msg :pointer))
  (print (foreign-string-to-lisp msg)))

(mus-print-set-handler (callback mus-print-handler))

(defvar *srate* 44100)
(defvar *channels* 1)
(defvar *default-frequency* 0.0)

(defvar *mailbox* (make-mailbox))
(defparameter *player* nil)

(defun play-file (filename)
  (let ((fd (mus-sound-open-input filename)))
    (unless (= fd -1)
      (let* ((channels (mus-sound-chans filename))
	     (srate (mus-sound-srate filename))
	     (frames (mus-sound-frames filename))
	     (buffers (foreign-alloc :pointer :count channels)))
	;;allocate buffers for reading file
	(loop for p from 0 below channels
	   do (setf (mem-aref buffers :pointer p) (foreign-alloc :double :count *buffer-size*)))
	
	(loop for i from 0 below frames by *buffer-size*
	     
	   ;;read from file
	   do (let ((outbuffer (make-array (* *buffer-size* channels) :element-type '(signed-byte 16))))
		(mus-sound-read fd 0 (- *buffer-size* 1) channels buffers)
		(loop for k from 0 below *buffer-size*
		   for j from 0 by channels
		   do (loop for n from 0 below channels
			 do (setf (aref outbuffer (+ j n)) 
				  (mus-sample-to-short (mem-aref (mem-aref buffers :pointer n) :double k)))))
		(send-message *mailbox* outbuffer)))

	(mus-sound-close-input fd)
	;;(loop for i below chans
	;;   do (foreign-free (mem-aref bufs :pointer i)))
	;;(foreign-free bufs)
	;;(foreign-free obuf)
	))))

(defstruct (player (:constructor %make-player (out-buffer out-bytes)))
  (out-buffer)
  (out-bytes)
  (thread)
  (dac))

(defun make-player ()
  (let* ((outbytes (* *buffer-size* *channels* 2))
	 (out-buffer (foreign-alloc :short :count (* *buffer-size* *channels*))))
    (%make-player out-buffer outbytes)))

(defun start-player ()
  (when (or (not *player*) (not (thread-alive-p (player-thread *player*))))
    (setf *player* (make-player))
    (setf (player-thread *player*) (make-thread '%run-player))))

(defun stop-player ()
  (when (and *player* (thread-alive-p (player-thread *player*)))
    (foreign-free (player-out-buffer *player*))
    (mus-audio-close (player-dac *player*))
    (setf *mailbox* (make-mailbox))
    (terminate-thread (player-thread *player*))))

(defun %run-player ()
  ;;todo check if initialization was successfull
  (mus-audio-initialize)
  (setf (player-dac *player*) (mus-audio-open-output 
			       +mus-audio-default+ *srate* *channels* +mus-audio-compatible-format+ (player-out-bytes *player*)))
  (loop (multiple-value-bind (sound status)
	    (receive-message *mailbox*)
	  (when status
	    (unwind-protect 
		 (progn
					;(setf (mem-aref (player-out-buffer *player*) :short) (mus-sample-to-short sound))
		   (mus-audio-write (player-dac *player*) sound (player-out-bytes *player*))))))))
  
(defun produce-sound ()
  (let ((testo (make-oscil)))
    (loop repeat 100
       do (let ((outbuffer (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16)))) 
	    (loop for i below (length outbuffer)
	       do (setf (aref outbuffer i) (mus-sample-to-short (oscil testo))))
	    (send-message *mailbox* outbuffer)))))

(defun test ()
  (stop-player)
  (start-player)
  (produce-sound))
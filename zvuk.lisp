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
	(loop for i below channels
	   do (foreign-free (mem-aref buffers :pointer i)))
	(foreign-free buffers)))))

(defstruct (player (:constructor %make-player (out-buffer out-bytes)))
  (out-buffer)
  (out-bytes)
  (thread)
  (dac)
  (sounds '()))

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
  (loop (multiple-value-bind (sound-queue status)
	    (receive-message *mailbox*)
	  (when status
	    (setf (player-sounds *player*) (push sound-queue (player-sounds *player*)))
	    
	    (loop repeat 500
	       do (loop for sound-queue in (player-sounds *player*)
		     do (multiple-value-bind (sound ok)
			    (receive-message sound-queue)
			  (when ok
			    ;;todo handle errors
			    (mus-audio-write (player-dac *player*) sound (player-out-bytes *player*))))))))))
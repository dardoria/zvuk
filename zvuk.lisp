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

;;todo get rid of this
(defparameter *player* nil)
(defparameter *controller* nil)

(defmacro with-sound (&rest body) 
  `(make-thread (lambda ()
		  (send-message (controller-message-box *controller*) :start)
		  (unwind-protect
		       (progn ,@body)
		    (send-message (controller-message-box *controller*) :stop)))))

(defun outa (sound)
  (send-message (aref (player-tracks *player*) 0) sound))

(defun outb (sound)
  (send-message (aref (player-tracks *player*) 1) sound))

(defun play-file (filename)
  (let ((fd (mus-sound-open-input filename)))
    (unless (= fd -1)
      (let* ((channels (mus-sound-chans filename))
	     (frames (mus-sound-frames filename))
	     ;;todo use lisp arrays here
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
		(outa outbuffer)))

	(mus-sound-close-input fd)
	(loop for i below channels
	   do (foreign-free (mem-aref buffers :pointer i)))
	(foreign-free buffers)))))

;;;;Controller
(defstruct (controller (:constructor %make-controller (#|thread |# player message-box)))
  ;;todo do i need this
  ;;(thread)
  (player)
  (message-box))

(defun make-controller (&optional (tracks-count 2))
  (let ((controller (%make-controller 
		     ;;todo do i need this?
		     ;;(make-thread '%run-controller)
		     (make-player tracks-count)
		     (make-mailbox))))
    (make-thread 'run-controller :arguments '(controller))
    controller))

(defun run-controller (controller)
  ;;todo receive commands
  ;;todo process commands
  )

(defun initialize ()
  (setf *controller* (make-controller)))

;;;; Player  
(defstruct (player (:constructor %make-player (out-bytes tracks)))
  (out-bytes)
  (thread)
  (dac)
  (tracks))

(defun make-player (&optional (tracks-count 2))
  (let ((outbytes (* *buffer-size* *channels* 2))
	(tracks (make-array tracks-count :initial-contents (loop repeat tracks-count collect (make-mailbox)))))
    (%make-player outbytes tracks)))

(defun start-player ()
  (when (or (not *player*) (not (thread-alive-p (player-thread *player*))))
    (setf *player* (make-player))
    (setf (player-thread *player*) (make-thread '%run-player))))

(defun stop-player ()
  (when *player* 
    (mus-audio-close (player-dac *player*))
    (terminate-thread (player-thread *player*)))

  (setf *player* nil))

(defun %run-player ()
  ;;todo check if initialization was successfull
  (mus-audio-initialize)
  (setf (player-dac *player*) (mus-audio-open-output 
			       +mus-audio-default+ *srate* *channels* +mus-audio-compatible-format+ (player-out-bytes *player*)))


  (loop 
     :with outbuffer = (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16))
     :do (loop for i below (length outbuffer)
	    do (let ((snd (loop for track across (player-tracks *player*)
			     :with sample = 0
			     :do (multiple-value-bind (sound ok)
				     (receive-message-no-hang track)
				   (when ok
				     (incf sample sound)))
			     :finally (return (/ sample (length (player-tracks *player*)))))))
		 (setf (aref outbuffer i) (mus-sample-to-short snd))))
     :do (mus-audio-write (player-dac *player*) outbuffer (player-out-bytes *player*))))
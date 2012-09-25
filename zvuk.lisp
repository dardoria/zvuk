(in-package :zvuk)

(defvar *srate* 44100)
(defvar *channels* 1)
(defvar *default-frequency* 0.0)

(defvar *mailbox* (make-mailbox))
(defparameter *player* nil)

(defun play-file (filename)
  (let ((fd (mus-sound-open-input filename)))
    (unless (= fd -1)
      (let* ((chans (mus-sound-chans filename))
	     (srate (mus-sound-srate filename))
	     (frames (mus-sound-frames filename))
	     (outbytes (* *buffer-size* chans 2))
	     (bufs (foreign-alloc :pointer :count chans))
	     (obuf (foreign-alloc :short :count (* *buffer-size* chans)))
	     (afd 0))
	(loop for i from 0 below chans
	   do (setf (mem-aref bufs :pointer i) (foreign-alloc :double :count *buffer-size*)))

	(setf afd (mus-audio-open-output +mus-audio-default+ srate chans +mus-audio-compatible-format+ outbytes))

	(unless (= afd -1)
	  (loop for i from 0 below frames by *buffer-size*
	     do (mus-sound-read fd 0 (- *buffer-size* 1) chans bufs)
	     do (loop for k from 0 below *buffer-size*
		   for j from 0 by chans
		   do (loop for n from 0 below chans
			 do (setf (mem-aref obuf :short (+ j n)) 
					    (mus-sample-to-short (mem-aref (mem-aref bufs :pointer n) :double k)))))
	     do (mus-audio-write afd obuf outbytes))
	  (mus-audio-close afd)
	  (mus-sound-close-input fd)
	  (loop for i below chans
	     do (foreign-free (mem-aref bufs :pointer i)))
	  (foreign-free bufs)
	  (foreign-free obuf))))))

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
		   (setf (mem-aref (player-out-buffer *player*) :short) (mus-sample-to-short sound))
		   (mus-audio-write (player-dac *player*) (player-out-buffer *player*) (player-out-bytes *player*))))))))
  
(defun produce-sound ()
  (let ((testo (make-oscil)))
    (loop for i to 10
       do (send-message *mailbox* (oscil testo)))))

(defun test ()
  (stop-player)
  (start-player)
  (produce-sound))
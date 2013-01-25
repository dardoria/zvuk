;; Copyright 2012 Boian Tzonev <boiantz@gmail.com>

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(cl:in-package :zvuk)

;;;; set error and print handler
;;todo find a better place for these
(defcallback mus-error-handler :void ((type :int) (msg :pointer))
  (declare (ignorable type))
  (error "~a~%" (foreign-string-to-lisp msg)))

(mus-error-set-handler (callback mus-error-handler))

(defcallback mus-print-handler :void ((msg :pointer))
  (print (foreign-string-to-lisp msg)))

(mus-print-set-handler (callback mus-print-handler))

;;todo get rid of global vars
(defvar *srate* 44100)
(defvar *channels* 1)
(defvar *default-frequency* 0.0)

(defparameter *controller* nil)

(defmacro with-sound (&rest body) 
  `(make-thread (lambda ()
		  (send-message (controller-message-box *controller*) :start)
		  (unwind-protect
		       (progn ,@body)
		    (send-message (controller-message-box *controller*) :stop)))))

(defun outa (sound)
  (send-message (aref (player-tracks (controller-player *controller*)) 0) sound))

(defun outb (sound)
  (send-message (aref (player-tracks (controller-player *controller*)) 1) sound))

(defun play-file (filename)
  ;;todo this doesn't work currently
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;Controller
(defstruct (controller (:constructor %make-controller (player message-box)))
  (player)
  (message-box))

(defun make-controller (&optional (tracks-count 2))
  (let ((controller (%make-controller 
		     ;;todo do i need this?
		     ;;(make-thread '%run-controller)
		     (make-player tracks-count)
		     (make-mailbox))))
    (make-thread 'run-controller :arguments (list controller))
    controller))

(defun run-controller (controller)
  (let ((stream-count 0))
    (loop for command = (receive-message (controller-message-box controller))
       do (ecase command
	    ((:start) (incf stream-count))
	    ((:stop) (decf stream-count)))

	 ;;when stream count is 0 the player thread will stop automatically
	 ;;this means that currently the stop command is a no-op
	 (when (> stream-count 0)
	     (start-player controller)))))

(defun initialize ()
  (setf *controller* (make-controller)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(defun start-player (controller)
  (when (not (and (controller-player controller)
		  (player-thread (controller-player controller))
		  (thread-alive-p (player-thread (controller-player controller)))))
    (setf (controller-player controller) (make-player))
    (setf (player-thread (controller-player controller)) 
	  (make-thread '%run-player :arguments (list (controller-player controller))))))

(defun stop-player (controller)
  (when (and (controller-player controller)
	     (player-thread (controller-player controller))
	     (thread-alive-p (player-thread (controller-player controller))))
    (mus-audio-close (player-dac (controller-player controller)))
    (terminate-thread (player-thread (controller-player controller)))))

(defun %run-player (player)
  (mus-audio-initialize)
  (setf (player-dac player) (mus-audio-open-output 
			     +mus-audio-default+ *srate* *channels* +mus-audio-compatible-format+ (player-out-bytes player)))

  (loop
     ;;todo this buffer should be cleaned
     :with outbuffer = (make-array (* *buffer-size* *channels*) :element-type '(signed-byte 16))
     :with track-count = 0
     :do (loop named outer for i below (length outbuffer)
	    :do (setf track-count 0)
	    :do (let ((snd (loop for track across (player-tracks player)
			      :with sample = 0
			      :do (multiple-value-bind (sound ok)
				      (receive-message-no-hang track)
				    (when ok
				      (incf track-count)
				      (incf sample sound)))
			      :finally (if (> track-count 0)
					   (return (/ sample track-count))
					   (return-from outer)))))
		  (setf (aref outbuffer i) (mus-sample-to-short snd))))
     :do (mus-audio-write (player-dac player) outbuffer (player-out-bytes player))
     :while (> track-count 0)))
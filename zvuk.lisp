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
  (send-message (aref (player-channels (controller-player *controller*)) 0) sound))

(defun outb (sound)
  (send-message (aref (player-channels (controller-player *controller*)) 1) sound))

(defun out-any (sound channel-number)
  (send-message (aref (player-channels (controller-player *controller*)) channel-number) sound))

(defun play-file (filename)
  (with-sound
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
	       do (mus-sound-read fd 0 (- *buffer-size* 1) channels buffers)
	       ;; output samples
	       do (loop for k from 0 below *buffer-size*
		     for j from 0 by channels
		     do (loop for n from 0 below channels
			   do (outa (mem-aref (mem-aref buffers :pointer n) :double k)))))

	    (mus-sound-close-input fd)
	    (loop for i below channels
	       do (foreign-free (mem-aref buffers :pointer i)))
	    (foreign-free buffers))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;Controller
(defstruct (controller (:constructor %make-controller (player message-box)))
  (player)
  (message-box))

(defun make-controller (&optional (channels-count 2))
  (let ((controller (%make-controller 
		     ;;todo do i need this?
		     ;;(make-thread '%run-controller)
		     (make-player channels-count)
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

(defun initialize (&optional (channels-count 2))
  (setf *controller* (make-controller channels-count)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Player
(defstruct (player (:constructor %make-player (out-bytes channels)))
  (out-bytes)
  (thread)
  (dac)
  (channels))

(defun make-player (&optional (channels-count 2))
  (let ((outbytes (* *buffer-size* *channels* 2))
	(channels (make-array channels-count :initial-contents (loop repeat channels-count collect (make-mailbox)))))
    (%make-player outbytes channels)))

(defun start-player (controller)
  (when (not (and (controller-player controller)
		  (player-thread (controller-player controller))
		  (thread-alive-p (player-thread (controller-player controller)))))
    (setf (controller-player controller) (make-player (length (player-channels (controller-player controller)))))
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
     :with channel-count = 0
     :do (loop named outer for i below (length outbuffer)
	    :do (setf channel-count 0)
	    :do (let ((snd (loop for channel across (player-channels player)
			      :with sample = 0
			      :do (multiple-value-bind (sound ok)
				      (receive-message-no-hang channel)
				    (when ok
				      (incf channel-count)
				      (incf sample sound)))
			      :finally (if (> channel-count 0)
					   (return (/ sample channel-count))
					   (return-from outer)))))
		  (setf (aref outbuffer i) (mus-sample-to-short snd))))
     :do (mus-audio-write (player-dac player) outbuffer (player-out-bytes player))
     :while (> channel-count 0)))
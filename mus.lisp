;;    Copyright 2012 Boian Tzonev <boiantz@gmail.com>

;;    Licensed under the Apache License, Version 2.0 (the "License");
;;     you may not use this file except in compliance with the License.
;;     You may obtain a copy of the License at

;;        http://www.apache.org/licenses/LICENSE-2.0

;;    Unless required by applicable law or agreed to in writing, software
;;     distributed under the License is distributed on an "AS IS" BASIS,
;;     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;;     See the License for the specific language governing permissions and
;;     limitations under the License.

(cl:in-package :zvuk)

(defconstant +two-pi+ (* 2 pi))


(defun hz->radians (val) (* val (/ +two-pi+ *srate*)))

(defun array-interp (fn x &optional size)
  (let ((len (or size (length fn))))
    (if (< x 0.0) (incf x len))
    (multiple-value-bind
	(int-part frac-part)
	(truncate x)
      (if (>= int-part len)
	  (setf int-part (mod int-part len)))
      (if (zerop frac-part)
	  (aref fn int-part)
	(+ (aref fn int-part)
	   (* frac-part (- (aref fn (if (< (1+ int-part) len) (1+ int-part) 0))
			   (aref fn int-part))))))))

(defun rectangular->polar (rdat idat)
  (let ((len (length rdat)))
    (loop for i from 0 below len do
      (let ((temp (sqrt (+ (sqr (aref rdat i)) (sqr (aref idat i))))))
	(setf (aref idat i) (- (atan (aref idat i) (aref rdat i))))
	(setf (aref rdat i) temp)))
    rdat))

;;;;delay
(defstruct (delay (:constructor %make-delay (size line loc zloc zsize zdly type)))
  size
  line
  (loc 0)
  (zloc 0)
  (zsize 0)
  (dloc 0.0)
  (zdly nil)
  (xscl 0.0)
  (yscl 0.0)
  (type :mus-interp-none))

(defun make-delay (size initial-contents initial-element max-size type)
  (let ((lsize (round (or max-size size))))
    (%make-delay
     (floor size) ;size
     (if initial-contents ;line
	 (make-double-array lsize :initial-contents initial-contents)
	 (if initial-element
	     (make-double-array lsize :initial-element (double initial-element))
	     (make-double-array lsize)))
     0 ;loc
     (and max-size (- max-size size)) ;zloc
     lsize ;zsize
     max-size ;zdly
     (or type ;type
	 (if max-size
	     :mus-interp-linear
	     :mus-interp-none)))))

(defun tap (d &optional (offset 0.0))
  (if (delay-zdly d)
      (if (= offset 0.0)
	  (aref (delay-line d) (delay-zloc d))
	(array-interp (delay-line d) (- (delay-zloc d) offset) (delay-zsize d)))
    (if (= offset 0.0)
	(aref (delay-line d) (delay-loc d))
      (aref (delay-line d) (floor (mod (- (delay-loc d) offset) (delay-size d)))))))

(defun delay-tick (d input)
  (setf (aref (delay-line d) (delay-loc d)) (double input))
  (incf (delay-loc d))
  (if (delay-zdly d)
      (progn
	(if (<= (delay-zsize d) (delay-loc d)) (setf (delay-loc d) 0))
	(incf (delay-zloc d))
	(if (<= (delay-zsize d) (delay-zloc d)) (setf (delay-zloc d) 0)))
    (if (<= (delay-size d) (delay-loc d)) (setf (delay-loc d) 0)))
  input)

(defun delay (d input &optional (pm 0.0))
  (prog1
      (tap d pm)
    (delay-tick d input)))

;;;;all-pass
(defstruct (all-pass (:include delay)
		     (:constructor %make-all-pass (size line loc zloc zsize zdly yscl xscl type))))

(defun make-all-pass (feedback feedforward size initial-contents initial-element max-size type)
  (let ((lsize (round (or max-size size))))
    (%make-all-pass
     ;;size
     (floor size)
     ;;line
     (if initial-contents
	 (make-double-array lsize :initial-contents initial-contents)
	 (if initial-element
	     (make-double-array lsize :initial-element (double initial-element))
	     (make-double-array lsize)))
     ;;loc
     0
     ;;zloc
     (and max-size (- max-size size))
     ;;zsize
     lsize
     ;;zdly
     max-size
     ;;yscl
     feedback
     ;;xscl
     feedforward
     ;;type
     (or type
	 (if max-size
	     :mus-interp-linear
	     :mus-interp-none)))))

(defun all-pass (d input &optional (pm 0.0))
  (let ((d-in (+ input (* (delay-yscl d) (tap d pm)))))
    (+ (delay d d-in pm)
       (* (delay-xscl d) d-in))))

;;;;comb
(defstruct (comb (:include delay)
		 (:constructor %make-comb (loc xscl size zsize zdly zloc line type))))

(defun make-comb (scaler size initial-contents initial-element max-size type)
  (let ((lsize (round (or max-size size))))
    (%make-comb
     0
     scaler
     (floor size)
     lsize
     max-size
     (and max-size (- max-size size))
     (if initial-contents
	 (make-double-array lsize :initial-contents initial-contents)
	 (if initial-element
	     (make-double-array lsize :initial-element (double initial-element))
	     (make-double-array lsize)))
     (or type
	 (if max-size
	     :mus-interp-linear
	     :mus-interp-none)))))

(defun comb (d input &optional (pm 0.0))
  (delay d (+ input (* (delay-xscl d) (tap d pm)))))

;;;; asymmetric-fm
(defstruct (asymmetric-fm (:constructor %make-asymmetric-fm (r freq ratio phase cosr sinr)))
  r freq ratio phase cosr sinr)

(defun make-asymmetric-fm (&optional (frequency *default-frequency*) (initial-phase 0.0) (r 1.0) (ratio 1.0))
  (if (/= r 0.0)
      (%make-asymmetric-fm r (hz->radians frequency) ratio initial-phase (* 0.5 (- r (/ 1.0 r))) (* 0.5 (+ r (/ 1.0 r))))))

(defun asymmetric-fm (af index &optional (fm 0.0))
  (let* ((th (asymmetric-fm-phase af))
	 (mth (* (asymmetric-fm-ratio af) th))
	 (cr (asymmetric-fm-cosr af))
	 (sr (asymmetric-fm-sinr af))
	 (result (* (exp (* index cr (+ 1.0 (cos mth)))) (cos (+ th (* sr index (sin mth)))))))
    (incf (asymmetric-fm-phase af) (+ (asymmetric-fm-freq af) fm))
    (when (or (> (asymmetric-fm-phase af) 100.0) (< (asymmetric-fm-phase af) -100.0))
      (setf (asymmetric-fm-phase af) (mod (asymmetric-fm-phase af) +two-pi+)))
    result))

;;;;oscil
(defstruct (oscil (:constructor %make-oscil (freq phase)))
  freq phase)

(defun make-oscil (&optional (frequency 440.0) (initial-phase 0.0))
  (%make-oscil (hz->radians frequency) initial-phase))

(defun oscil (gen &optional (fm-input 0.0) (pm-input 0.0))
  (prog1
      (sin (+ (oscil-phase gen) pm-input))
    (incf (oscil-phase gen) (+ (oscil-freq gen) fm-input))
    ;; if we were being extremely careful, we'd add the fm-input into the sin call at the start too.
    (when (or (> (oscil-phase gen) 100.0) (< (oscil-phase gen) -100.0))
      (setf (oscil-phase gen) (mod (oscil-phase gen) +two-pi+)))))

;;;;triangle-wave
(defstruct (triangle-wave (:constructor %make-triangle-wave (current-value freq phase base)))
  current-value freq phase base)

(defun fix-up-phase (s)
  (if (plusp (triangle-wave-phase s))
      (loop while (>= (triangle-wave-phase s) +two-pi+) do (decf (triangle-wave-phase s) +two-pi+))
    (loop while (minusp (triangle-wave-phase s)) do (incf (triangle-wave-phase s) +two-pi+))))

(defun tri-val (amplitude phase)
  (* amplitude (if (< phase (/ pi 2.0)) phase
		 (if (< phase (/ (* 3.0 pi) 2.0))
		     (- pi phase)
		   (- phase +two-pi+)))))

(defun make-triangle-wave (&optional (frequency *default-frequency*) (amplitude 1.0) (initial-phase 0.0))
  (%make-triangle-wave
   (/ (tri-val amplitude initial-phase) (/ pi 2.0))
   (hz->radians frequency)
   initial-phase
   (/ (* 2 amplitude) pi)))

(defun triangle-wave (s &optional (fm 0.0))
  (prog1
      (triangle-wave-current-value s)
    (incf (triangle-wave-phase s) (+ (triangle-wave-freq s) fm))
    (if (or (minusp (triangle-wave-phase s))
	    (>= (triangle-wave-phase s) +two-pi+))
	(fix-up-phase s))
    (setf (triangle-wave-current-value s) (tri-val (triangle-wave-base s) (triangle-wave-phase s)))))

;;;;square-wave
(defstruct (square-wave (:include triangle-wave)
			(:constructor %make-square-wave (current-value freq phase base width)))
  (width))

(defun make-square-wave (&optional (frequency *default-frequency*) (amplitude 1.0) (initial-phase 0.0))
  (%make-square-wave
   (if (< initial-phase pi) 0.0 amplitude)
   (hz->radians frequency)
   initial-phase
   amplitude
   pi))

(defun square-wave (s &optional (fm 0.0))
  (prog1
      (square-wave-current-value s)
    (incf (square-wave-phase s) (+ (square-wave-freq s) fm))
    (if (or (minusp (square-wave-phase s))
	    (>= (square-wave-phase s) +two-pi+))
	(fix-up-phase s))
    (setf (square-wave-current-value s) (if (< (square-wave-phase s) (square-wave-width s)) (square-wave-base s) 0.0))))

;;;;sawtooth-wave
(defstruct (sawtooth-wave (:include triangle-wave)
			  (:constructor %make-sawtooth-wave (current-value freq phase base))))

(defun make-sawtooth-wave (&optional (frequency *default-frequency*) (amplitude 1.0) (initial-phase pi))
  (%make-sawtooth-wave
		 (* amplitude (/ (- initial-phase pi) pi))
		 (hz->radians frequency)
		 initial-phase
		 (/ amplitude pi)))

(defun sawtooth-wave (s &optional (fm 0.0))
  (prog1
      (sawtooth-wave-current-value s)
    (incf (sawtooth-wave-phase s) (+ (sawtooth-wave-freq s) fm))
    (if (or (minusp (sawtooth-wave-phase s))
	    (>= (sawtooth-wave-phase s) +two-pi+))
	(fix-up-phase s))
    (setf (sawtooth-wave-current-value s) (* (sawtooth-wave-base s) (- (sawtooth-wave-phase s) pi)))))


;;;;pulse-train
(defstruct (pulse-train (:include triangle-wave)
			(:constructor %make-pulse-train (current-value freq phase base))))

(defun make-pulse-train (&optional (frequency *default-frequency*) (amplitude 1.0) (initial-phase +two-pi+))
  (%make-pulse-train
   0.0
   (hz->radians frequency)
   initial-phase	; this will give us an immediate pulse
   amplitude))		; another version alternates sign

(defun pulse-train (s &optional (fm 0.0))
  (prog1
      (if (>= (abs (pulse-train-phase s)) +two-pi+)
	  (progn
	    (fix-up-phase s)
	    (pulse-train-base s))		;triggered upon overflow in a sense, so will jitter around if period not integer
					; use ncos for a better pulse
	0.0)
    (incf (pulse-train-phase s) (+ (pulse-train-freq s) fm))))
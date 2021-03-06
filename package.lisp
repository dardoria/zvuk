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

(cl:defpackage :zvuk
  (:use :cl :cffi :sb-thread :sb-concurrency)
  (:export #:load-sample-file
	   #:pulse-train
	   #:make-pulse-train
	   #:sawtooth-wave
	   #:make-sawtooth-wave
	   #:square-wave
	   #:make-square-wave
	   #:triangle-wave
	   #:make-triangle-wave
	   #:tri-val
	   #:fix-up-phase
	   #:oscil
	   #:make-oscil
	   #:asymmetric-fm
	   #:make-asymmetric-fm
	   #:comb
	   #:make-comb
	   #:all-pass
	   #:make-all-pass
	   #:delay
	   #:delay-tick
	   #:tap
	   #:make-delay
	   #:rectangular->polar
	   #:hz->radians
	   #:initialize
	   #:with-sound
	   #:outa
	   #:outb
	   #:out-any))


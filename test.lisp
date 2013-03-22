;; Copyright 2012 Boian Tzonev <boiantz@gmail.com>

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;    http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(cl:in-package :zvuk)

(defun test-with-sound (freq)
    (with-sound    
	(let ((testo (make-oscil freq)))
	  (loop repeat (* 100000)
	     do (out-any (oscil testo) 0)))))

(defun simple()
  (let ((o1 (mus-make-oscil 440.0d0 0.0d0))
	(o2 (mus-make-oscil 550.0d0 0.0d0)))
    (loop repeat 20
       collect (values 		
		(mus-oscil o1 0.0d0 0.0d0)
		(mus-oscil o2 0.0d0 0.0d0)))))

(defun test-sample-file (file-name channel start samples)
  (let ((sample-array 
	 (load-sample-file file-name channel start samples)))
    (with-sound
	(loop for sample across sample-array
	   do (outa sample)))))

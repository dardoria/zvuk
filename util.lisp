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

(defmacro double (x) `(coerce ,x 'double-float))

(defmacro sqr (x) `(* ,x ,x))

(defmacro make-double-array (lim &key initial-contents initial-element)
  (let ((ic initial-contents)
	(ie initial-element))
    (if ic
	`(make-array ,lim :element-type 'double-float :initial-contents (map 'list #'(lambda (n) (double n)) ,ic))
      (if ie
	  `(make-array ,lim :element-type 'double-float :initial-element (double ,ie))
	`(make-array ,lim :element-type 'double-float :initial-element (coerce 0.0 'double-float))
	))))

(defmacro make-double-float-array (lim &key initial-contents initial-element)
  (let ((ic initial-contents)
	(ie initial-element))
    (if ic
	`(make-array ,lim :element-type 'double-float :initial-contents (map 'list #'(lambda (n) (double n)) ,ic))
      (if ie
	  `(make-array ,lim :element-type 'double-float :initial-element (double ,ie))
	`(make-array ,lim :element-type 'double-float :initial-element (coerce 0.0 'double-float))
	))))
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

(cl:defpackage #:zvuk-asd
  (:use :cl :asdf))

(cl:in-package :zvuk-asd)

(asdf:defsystem :zvuk
  :name "zvuk"
  :serial t
  :depends-on (:cffi :ffa :sb-concurrency)
  :components ((:file "package")
	       (:file "library")
	       (:file "sndlib")
	       (:file "clm")
	       (:file "util")
               (:file "zvuk")
	       (:file "mus")
	       (:file "phase-vocoder")))


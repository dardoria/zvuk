;;;; zvuk.asd
(defpackage #:zvuk-asd
  (:use :cl :asdf))

(in-package :zvuk-asd)

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


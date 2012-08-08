;;;; zvuk.asd

(asdf:defsystem #:zvuk
  :serial t
  :depends-on (#:cffi #:ffa)
  :components ((:file "package")
	       (:file "library")
	       (:file "sndlib")
	       (:file "clm")
	       (:file "util")
               (:file "zvuk")
	       (:file "mus")))


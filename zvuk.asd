;;;; zvuk.asd

(asdf:defsystem #:zvuk
  :serial t
  :depends-on (#:cffi)
  :components ((:file "package")
	       (:file "library")
	       (:file "sndlib")
	       (:file "clm")
               (:file "zvuk")))

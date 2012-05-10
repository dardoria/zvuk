;;;; zvuk.asd

(asdf:defsystem #:clmsndlib
  :serial t
  :depends-on (#:cffi)
  :components ((:file "package")
	       (:file "library")
	       (:file "sndlib")
	       (:file "clm")
               (:file "zvuk")))


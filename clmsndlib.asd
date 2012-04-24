;;;; clmsndlib.asd

(asdf:defsystem #:clmsndlib
  :serial t
  :depends-on (#:cffi)
  :components ((:file "package")
               (:file "clmsndlib")))


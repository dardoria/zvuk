(in-package #:clmsndlib)

(define-foreign-library sndlib
  (:unix (:or "libsndlib.so" "/usr/local/lib/libsndlib.so"))
  (t (:default "libsndlib")))

(use-foreign-library sndlib)
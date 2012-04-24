(in-package #:clmsndlib)

(define-foreign-library sndlib
    (:unix "libsndlib.so")
  (t (:default "libsndlib")))

(use-foreign-library sndlib)
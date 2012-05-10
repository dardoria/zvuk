(in-package #:zvuk)

(define-foreign-library sndlib
  (:unix (:or "libsndlib.so" "/usr/local/lib/libsndlib.so"))
  (t (:default "libsndlib")))

(use-foreign-library sndlib)

(defvar *buffer-size*
  #+(or darwin macos macosx)   
  256
  #+windows
  8192
  #+linux
  4096)

(defvar +mus-audio-default+ 0)

(defun mus-sample-to-short (n)
  (truncate (* n (ash 1 15))))
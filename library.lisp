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
  1024)

(defvar +mus-audio-default+ 0)

(defun mus-sample-to-short (n)
  (truncate (* n (ash 1 15))))

(defcallback mus-error-handler :void ((type :int) (msg :pointer))
  (declare (ignorable type))
  (error "~a" (foreign-string-to-lisp msg)))

(mus-error-set-handler (callback mus-error-handler))

(defcallback mus-print-handler :void ((msg :pointer))
  (print (foreign-string-to-lisp msg)))

(mus-print-set-handler (callback mus-print-handler))
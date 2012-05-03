(in-package #:clmsndlib)

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

(defconst +mus-audio-default+ 0)

(and #-darwin #+little-endian)
(defconst +mus-audio-compatible-format+ :mus-lshort)

(defun mus-sample-to-short (n)
  (* n (ash 1 15)))

(defun mus-sound-read (fd beg end chans bufs)
  (mus-file-read fd beg end chans bufs))
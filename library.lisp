;;    Copyright 2012 Boian Tzonev <boiantz@gmail.com>

;;    Licensed under the Apache License, Version 2.0 (the "License");
;;     you may not use this file except in compliance with the License.
;;     You may obtain a copy of the License at

;;        http://www.apache.org/licenses/LICENSE-2.0

;;    Unless required by applicable law or agreed to in writing, software
;;     distributed under the License is distributed on an "AS IS" BASIS,
;;     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;;     See the License for the specific language governing permissions and
;;     limitations under the License.

(cl:in-package #:zvuk)

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
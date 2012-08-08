(cl:in-package :zvuk)

(defmacro double (x) `(coerce ,x 'double-float))

(defmacro sqr (x) `(* ,x ,x))

(defmacro make-double-array (lim &key initial-contents initial-element)
  (let ((ic initial-contents)
	(ie initial-element))
    (if ic
	`(make-array ,lim :element-type 'double-float :initial-contents (map 'list #'(lambda (n) (double n)) ,ic))
      (if ie
	  `(make-array ,lim :element-type 'double-float :initial-element (double ,ie))
	`(make-array ,lim :element-type 'double-float :initial-element (coerce 0.0 'double-float))
	))))

(defmacro make-double-float-array (lim &key initial-contents initial-element)
  (let ((ic initial-contents)
	(ie initial-element))
    (if ic
	`(make-array ,lim :element-type 'double-float :initial-contents (map 'list #'(lambda (n) (double n)) ,ic))
      (if ie
	  `(make-array ,lim :element-type 'double-float :initial-element (double ,ie))
	`(make-array ,lim :element-type 'double-float :initial-element (coerce 0.0 'double-float))
	))))
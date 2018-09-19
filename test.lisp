;;;; test.lisp

(in-package #:enter-box)

(edit-box)

(enter-box:edit-box)

(defparameter *dim-type*
  (mapcar
   #'(lambda (el)
       (list el (dim-string-by-dim-name el)))
   (dim-name-list)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cmd-hide-wdget(widget)
  (pack-forget widget))

(defun cmd-show-wdget(widget)
  (pack widget))

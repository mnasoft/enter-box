;;;; cl-user-funcs.lisp

(in-package #:enter-box )

(defun enter-box-import-symbols ()
  (import '(enter-box:edit-box
	    enter-box:spring-dialog
	    enter-box:e-box-demo-2)
	  (find-package :cl-user)))

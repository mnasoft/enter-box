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

(e-box-b-ok  e-box) (make-instance 'button     :master e-box :text "Ok"   :width 3
					:command (lambda ()
						   (setf (e-box-rez e-box) (vd* (read-from-string (text (e-box-eb e-box)))
										(dimensionp (text (e-box-dm-cb e-box))))
							 *e-box-rez* (e-box-rez e-box))
						   (format t "~S" (e-box-rez e-box))
						   (setf *exit-mainloop* t)))

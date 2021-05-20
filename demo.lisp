;;;; demo.lisp

(in-package #:enter-box)

(export 'edit-box )
(defun edit-box (&key (l-edit-text 10.0) (state 2) vtype dimension (label "Значение"))
"@b(Описание:) edit-box возвращает число с размерностью, 
которое можно ввести при помощи диалогового окна.
@b(Пример использования:)
@begin[lang=lisp](code)
(edit-box ) 
@end(code)
"
  (let ((rez nil))
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (e-box (make-instance 'e-box 
				   :master frame
				   :label label
				    
				   :l-edit-text l-edit-text
				   :state state
				   :vtype vtype
				   :dimension dimension))
	     (b-ok  (make-instance 'button :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf (e-box-val e-box) (mdv:vd* (read-from-string (text (e-box-l-edit e-box)))
									   (mdv:quantity-from-string (text (e-box-dm-cb e-box))))
						    rez (e-box-val e-box))
					      (format t "~S" (e-box-val e-box))
					      (setf *exit-mainloop* t)))))
	(bind b-ok "<Return>"
	      (lambda (event)
		(declare (ignore event))
		(setf (e-box-val e-box) (mdv:vd* (read-from-string (text (e-box-l-edit e-box)))
					     (mdv:quantity-from-string (text (e-box-dm-cb e-box))))
		      rez (e-box-val e-box))
		(format t "~S" (e-box-val e-box))
		(setf *exit-mainloop* t)))
	(pack frame)
	(pack e-box :side :left :padx 5 :pady 5)
	(pack b-ok  :side :left :padx 5 :pady 5)))
    rez))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *e-box-rez* nil)

(defun e-box-demo-2 ()
  (with-ltk ()
    (let* ((frame (make-instance 'frame))
	   (p-in  (make-instance 'e-box :label "P_in " :master frame :l-edit-text 155.0 ))
	   (p-out (make-instance 'e-box :label "P_out" :master frame :l-edit-text 101.0))
	   (dp    (make-instance 'e-box :label "ΔP   " :master frame :l-edit-text 101.0))
	   )
      (pack frame)
      (pack p-in  :side :top)
      (pack p-out :side :top)
      (pack dp    :side :top)))
  *e-box-rez*)

;;;; (e-box-demo-2)

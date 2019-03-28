;;;; [[d:/PRG/msys32/home/namatv/quicklisp/local-projects/ltk/enter-box/demo.lisp]]

(in-package #:enter-box)

(defun edit-box (&key (l-edit-text 10.0) (state 2) vtype dimension)
  (let ((rez nil))
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (e-box (make-instance 'e-box
				   :master frame
				   :l-edit-text l-edit-text
				   :state state
				   :vtype vtype
				   :dimension dimension))
	     (b-ok  (make-instance 'button :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf (e-box-val e-box) (vd* (read-from-string (text (e-box-l-edit e-box)))
									   (dimensionp (text (e-box-dm-cb e-box))))
						    rez (e-box-val e-box))
					      (format t "~S" (e-box-val e-box))
					      (setf *exit-mainloop* t)))))
	(bind b-ok "<Return>"
	      (lambda (event)
		(declare (ignore event))
		(setf (e-box-val e-box) (vd* (read-from-string (text (e-box-l-edit e-box)))
					     (dimensionp (text (e-box-dm-cb e-box))))
		      rez (e-box-val e-box))
		(format t "~S" (e-box-val e-box))
		(setf *exit-mainloop* t)))
	(pack frame)
	(pack e-box :side :left :padx 5 :pady 5)
	(pack b-ok  :side :left :padx 5 :pady 5)))
    rez))

;;;; (edit-box )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun e-box-demo-1 ()
  (let ((d-w-r (vd* 0.2 "mm"))
	(d-m-r (vd* 2.6 "mm"))
	(f-1-r (vd* 0.4 "N"))
	(l-0-r (vd* 7.5 "mm"))
	)
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (d-w   (make-instance 'e-box :label "d-w" :master frame :l-edit-text (format nil "~F" (mdv:vd-val d-w-r)) :vtype (first (mdv:quantity-name d-w-r)) :dimension (mdv:unit-name d-w-r nil)))
	     (d-m   (make-instance 'e-box :label "d-m" :master frame :l-edit-text (format nil "~F" (mdv:vd-val d-m-r)) :vtype (first (mdv:quantity-name d-m-r)) :dimension (mdv:unit-name d-m-r nil)))
	     (f-1   (make-instance 'e-box :label "f-1" :master frame :l-edit-text (format nil "~F" (mdv:vd-val f-1-r)) :vtype (first (mdv:quantity-name f-1-r)) :dimension (mdv:unit-name f-1-r nil)))
	     (l-0   (make-instance 'e-box :label "l-0" :master frame :l-edit-text (format nil "~F" (mdv:vd-val l-0-r)) :vtype (first (mdv:quantity-name l-0-r)) :dimension (mdv:unit-name l-0-r nil)))
	     (b-ok  (make-instance 'button :master frame :text "Ok"   :width 3
				   :command (lambda () ;;;;;;
					      (setf *exit-mainloop* t)))))
	(bind (e-box-l-edit d-w) "<Return>"
	      (lambda (event)
		(declare (ignore event))
		(setf (e-box-val d-w) (vd* (read-from-string (text (e-box-l-edit d-w))) (dimensionp (text (e-box-dm-cb d-w))))
		      d-w-r (e-box-val d-w))))
	(bind (e-box-l-edit d-m) "<Return>"
	      (lambda (event)
		(declare (ignore event))
		(setf (e-box-val d-m) (vd* (read-from-string (text (e-box-l-edit d-m))) (dimensionp (text (e-box-dm-cb d-m))))
		      d-m-r (e-box-val d-m))))

	(pack frame) (pack d-w :side :top) (pack d-m :side :top) (pack l-0 :side :top) (pack f-1 :side :top) (pack b-ok :side :top)))
    (list d-w-r d-m-r)))

;;;; (e-box-demo-1)

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



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
   	   
(defun spring-dialog ()
  (let* ((spr (make-instance 'mspr:spring ))
	 (d-w-r (vd* (mspr:d-w spr)  "mm"))
	 (d-m-r (vd* (mspr:d-m spr)  "mm"))
	 (n-w-r (vd* (mspr:n-w spr)))
	 (l-0-r (vd* (mspr:l-0 spr) "mm"))
	 )
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (d-w   (make-instance 'e-box :label "d-w" :master frame :l-edit-text (format nil "~F" (mdv:vd-val d-w-r)) :vtype (first (mdv:quantity-name d-w-r)) :dimension (mdv:unit-name d-w-r nil))) ;; Диаметр проволоки 
	     (d-m   (make-instance 'e-box :label "d-m" :master frame :l-edit-text (format nil "~F" (mdv:vd-val d-m-r)) :vtype (first (mdv:quantity-name d-m-r)) :dimension (mdv:unit-name d-m-r nil))) ;; Средний диаметр пружины 
	     (l-0   (make-instance 'e-box :label "l-0" :master frame :l-edit-text (format nil "~F" (mdv:vd-val l-0-r)) :vtype (first (mdv:quantity-name l-0-r)) :dimension (mdv:unit-name l-0-r nil))) ;; Высота пружины в свободном состоянии
	     (n-w   (make-instance 'e-box :label "n-w" :master frame :l-edit-text (format nil "~F" (mdv:vd-val n-w-r)) :vtype (first (mdv:quantity-name n-w-r)) :dimension (mdv:unit-name n-w-r nil))) ;; Количество рабочих витков
	     (b-ok  (make-instance 'button :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf (mspr:d-w spr) (* (mdv:vd-val d-w-r) 1000)
						    (mspr:d-m spr) (* (mdv:vd-val d-m-r) 1000)
				      		    (mspr:l-0 spr) (* (mdv:vd-val l-0-r) 1000)
						    (mspr:n-w spr) (mdv:vd-val n-w-r))
					      
					      (setf *exit-mainloop* t)))))
	(pack frame) (pack d-w :side :top) (pack d-m :side :top) (pack l-0 :side :top) (pack n-w :side :top)  (pack b-ok :side :top)))
    (list d-w-r d-m-r spr)))

;;;; (f-1-r (vd* 0.4 "N"))	     
;;;; (f-1   (make-instance 'e-box :label "f-1" :master frame :l-edit-text (format nil "~F" (mdv:vd-val f-1-r)) :vtype (first (mdv:quantity-name f-1-r)) :dimension (mdv:unit-name f-1-r nil))) ;; Первая сила     
;;;; (pack f-1 :side :top)

;;;; (spring-dialog)

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

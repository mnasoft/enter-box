;;;; test.lisp

(in-package :enter-box)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   	   
(defun spring-dialog ()
  (let* ((spr (make-instance 'mspr:spring ))
	 (d-w-r (mdv:vd* (mspr:d-w spr)  "mm"))
	 (d-m-r (mdv:vd* (mspr:d-m spr)  "mm"))
	 (n-w-r (mdv:vd* (mspr:n-w spr)))
	 (l-0-r (mdv:vd* (mspr:l-0 spr) "mm"))
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

;;;; (f-1-r (mdv:vd* 0.4 "N"))	     
;;;; (f-1   (make-instance 'e-box :label "f-1" :master frame :l-edit-text (format nil "~F" (mdv:vd-val f-1-r)) :vtype (first (mdv:quantity-name f-1-r)) :dimension (mdv:unit-name f-1-r nil))) ;; Первая сила     
;;;; (pack f-1 :side :top)

;;;; (spring-dialog)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(edit-box :l-edit-text 25.4 :state 3 :vtype "length" :dimension "km")

(e-box-demo-2)


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(ql:quickload :idelchik)

(idelchik:k *gas*)

(defparameter *gas* (make-instance 'idelchik:<gas> ))


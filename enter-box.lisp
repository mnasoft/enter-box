;;;; enter-box.lisp

(in-package #:enter-box)

;;; "enter-box" goes here. Hacks and glory await!


(defparameter *dim-type* '(("pressure" ("MPa" "kPa" "Pa" "kgf/mm^2" "kgf/cm^2" "kgf/m^2" "mm_Hg" "mm_H2O") "Pa")
			   ("length" ("Mm" "km" "m" "mm" "μm" ) "m")
			   ("force"  ("MN" "tf" "kN" "kgf" "N" "gf") "N")))

(defun calc-state (state)
  "Вычисляет состояние видимости виджетов
Пример использования:
;;;; (calc-state 0)
;;;; (calc-state 1)
;;;; (calc-state 2)
;;;; (calc-state 3)
;;;; (calc-state 550)
"
  (case state
    (0         (list nil   nil  nil   t   nil   t   ))
    (1         (list   t   nil  nil   t     t   t   ))
    (2         (list   t   nil    t   t     t   t   ))
    (3         (list   t     t    t   t     t   nil ))
    (otherwise (list   t     t    t   t     t   t   ))))



(defparameter *eb-state* '(    2  (nil   nil  nil nil   nil nil ))
  "                      '(state  (b-< vt-cb t-lb  eb dm-cb b-< ))"
  )

(defun cmd-pack-items (widgets)
  (mapcar
   #'(lambda (st wgt)
       (when st (pack wgt :side :left :padx 5 :pady 5)))
   (calc-state (first *eb-state*))
   widgets))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; e-box
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *e-box-rez* nil)

(defclass e-box (frame)
  ((val    :accessor e-box-val    :initform nil)
   (b-<    :accessor e-box-b-<    :initform nil)
   (vt-cb  :accessor e-box-vt-cb  :initform nil)
   (t-lb   :accessor e-box-t-lb   :initform nil)
   (l-edit :accessor e-box-l-edit :initform nil :documentation "Line edit widget")
   (dm-cb  :accessor e-box-dm-cb  :initform nil)
   (b->    :accessor e-box-b->    :initform nil)))

(defmethod initialize-instance :after ((e-box e-box) &key (l-edit-text 20.0) (label "Label" ))
  (let* ((val-type (mapcar #'first *dim-type*)))
    (setf
     (e-box-b-<   e-box) (make-instance 'button     :master e-box :text "<" :width 2)
     (e-box-vt-cb e-box) (make-instance 'combobox   :master e-box :width 25
					:text (first val-type) :values val-type)
     (e-box-t-lb   e-box) (make-instance 'label     :master e-box :text label)
     (e-box-l-edit e-box) (make-instance 'entry     :master e-box :width 8 :text l-edit-text)
     (e-box-dm-cb  e-box) (make-instance 'combobox  :master e-box :width 8
					:text   (third (assoc (first val-type) *dim-type* :test #'string=))
					:values (second (assoc (first val-type) *dim-type* :test #'string=)))
     (e-box-b->   e-box) (make-instance 'button     :master e-box :text ">"    :width 2))
    (bind  (e-box-b-< e-box) "<ButtonRelease-1>"
	   (lambda (event)
	     (declare (ignore event))
	     (pack-forget-all e-box)
	     (setf (first *eb-state*) (max (1- (first *eb-state*)) 0))
	     (cmd-pack-items
	      (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
		    (e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box))))) 
    (bind  (e-box-b-> e-box)  "<ButtonRelease-1>"
	   (lambda (event)
	     (declare (ignore event))
	     (pack-forget-all e-box)
	     (setf (first *eb-state*) (min (1+ (first *eb-state*)) 3))
	     (cmd-pack-items
	      (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
		    (e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))))
    (bind (e-box-vt-cb e-box) "<<ComboboxSelected>>"
	  (lambda (event)
            (declare (ignore event))
	    (setf (options (e-box-dm-cb e-box)) (second (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
	    (setf (text (e-box-dm-cb e-box))  (third (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
            (finish-output)))
    (bind (e-box-dm-cb e-box) "<<ComboboxSelected>>"
	  (lambda (event)
            (declare (ignore event))
	    (setf (text (e-box-l-edit e-box))
		  (format nil "~a"
			  (/(* (read-from-string (text (e-box-l-edit e-box)) )
			       (vd-val (dimensionp (third (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))))
			    (vd-val (dimensionp (text (e-box-dm-cb e-box))))))
		  )
	    (setf (third (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)) (text (e-box-dm-cb e-box)))
	    (finish-output)))
    (pack-forget-all e-box)    
    (cmd-pack-items
     (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
	   (e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))))
	   
(defun edit-box (&key (l-edit-text 10.0) )
  (let ((rez nil))
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (e-box (make-instance 'e-box  :master frame :l-edit-text l-edit-text))
	     (b-ok  (make-instance 'button :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf (e-box-val e-box) (vd* (read-from-string (text (e-box-l-edit e-box)))
									   (dimensionp (text (e-box-dm-cb e-box))))
						    rez (e-box-val e-box))
					      (format t "~S" (e-box-val e-box))
					      (setf *exit-mainloop* t)))))
	(pack frame)
	(pack e-box :side :left :padx 5 :pady 5)
	(pack b-ok  :side :left :padx 5 :pady 5)))
  rez))

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

(edit-box :l-edit-text 25.4)
 (e-box-demo-2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



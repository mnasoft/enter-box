;;;; enter-box.lisp

(in-package #:enter-box)

;;; "enter-box" goes here. Hacks and glory await!
(defmacro mnas-bind (accessor instanse event callback)
  `(bind (,accessor ,instanse) ,event (lambda (event) (declare (ignore event)) (,callback ,instanse ,event))))

(defmacro mnas-binds (accessor instanse callback events)
  (cons 'progn
	(mapcar
	 #'(lambda (el) (list 'mnas-bind accessor instanse el callback))
	 events)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    (0         (list nil   nil  nil      t   nil   t ))
    (1         (list   t   nil  nil      t     t   t ))
    (2         (list   t   nil    t      t     t   t ))
    (3         (list   t     t    t      t     t nil ))
    (otherwise (list   t     t    t      t     t   t ))
;;;;                 b-< vt-cb t-lb l-edit dm-cb b-< 
    ))

(defun cmd-pack-items (state widgets)
  (mapcar
   #'(lambda (st wgt)
       (when st (pack wgt :side :left :padx 5 :pady 5)))
   (calc-state state)
   widgets))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; e-box
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *e-box-rez* nil)

(defclass e-box (frame)
  ((val    :accessor e-box-val    :initform nil)
   (state  :accessor e-box-state  :initform   2 :initarg :state
	   :documentation "Целое значение от 0 до 3.
Отвечает за состояние видимости виджетов, входящих в класс e-box.
При state равном: 
 - 0 отображается минимальное количество виджетов;
 - 3 отображается максимальное количество виджетов")
   (b-<    :accessor e-box-b-<    :initform nil
	   :documentation "Кнопка вызывает уменьшение количества отображаемых виджетов класса e-box")
   (vt-cb  :accessor e-box-vt-cb  :initform nil)
   (t-lb   :accessor e-box-t-lb   :initform nil)
   (l-edit :accessor e-box-l-edit :initform nil :documentation "Line edit widget")
   (dm-cb  :accessor e-box-dm-cb  :initform nil)
   (b->    :accessor e-box-b->    :initform nil
	   :documentation "Кнопка вызывает увеличение количества отображаемых виджетов класса e-box")))

(defgeneric l-edit-changed (e-box  text))

(defmethod  l-edit-changed ((e-box e-box) text)
  (setf (e-box-val e-box)
	(vd* (read-from-string (text (e-box-l-edit e-box)))
	     (dimensionp (text (e-box-dm-cb e-box)))))
  (e-box-val e-box)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (finish-output))

(defgeneric e-box-dm-cb-Selected (e-box  text))

(defmethod e-box-dm-cb-Selected  ((e-box e-box) text)
  (let ((new-dims (dimensionp (text (e-box-dm-cb e-box)))))
    (format t "Event:~S; val=~S~%" text (e-box-val e-box))
    (when
	(and (e-box-val e-box)
	     (equal (vd-dims (e-box-val e-box)) (vd-dims new-dims)) )
      (setf (text (e-box-l-edit e-box)) (format nil "~S" (vd-val (vd/ (e-box-val e-box) new-dims))))
      (format t "~S~%" (text (e-box-l-edit e-box))))
    (finish-output)))

(defgeneric e-box-b->Pressed (e-box  text))

(defmethod e-box-b->Pressed  ((e-box e-box) text)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (pack-forget-all e-box)
  (setf (e-box-state e-box) (min (1+ (e-box-state e-box)) 3))
  (cmd-pack-items (e-box-state e-box)
		  (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			(e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box))))

(defgeneric e-box-b-<Pressed (e-box  text))

(defmethod e-box-b-<Pressed  ((e-box e-box) text)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (pack-forget-all e-box)
  (setf (e-box-state e-box) (max (1- (e-box-state e-box)) 0))
  (cmd-pack-items (e-box-state e-box)
		  (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			(e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box))))

(defgeneric e-box-vt-cb-Selected (e-box  text))

(defmethod e-box-vt-cb-Selected  ((e-box e-box) text)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (setf (options (e-box-dm-cb e-box)) (second (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
  (setf (text (e-box-dm-cb e-box))  (third (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
  (finish-output))

(defmethod initialize-instance :after ((e-box e-box)
				       &key
					 (l-edit-text 20.0)
					 (label "Label" )
					 vtype
					 (dimension (third  (assoc vtype *dim-type* :test #'string=)))) 
  (let* ((val-type (mapcar #'first *dim-type*)))
    (unless (member vtype val-type :test #'equal)
      (setf vtype (first val-type)))
    (unless (member dimension (second (assoc vtype *dim-type* :test #'string=)) :test #'equal)
      (setf dimension (third  (assoc vtype *dim-type* :test #'string=))))
    (setf
     (e-box-b-<   e-box) (make-instance 'button     :master e-box :text "<" :width 2)
     (e-box-vt-cb e-box) (make-instance 'combobox   :master e-box :width 25
					:text vtype :values val-type)
     (e-box-t-lb   e-box) (make-instance 'label     :master e-box :text label)
     (e-box-l-edit e-box) (make-instance 'entry     :master e-box :width 8 :text l-edit-text)
     (e-box-dm-cb  e-box) (make-instance 'combobox  :master e-box :width 8
					 :text   dimension
					 :values (second (assoc vtype *dim-type* :test #'string=)))
     (e-box-b->   e-box) (make-instance 'button     :master e-box :text ">"    :width 2))
    (mnas-binds e-box-b-< e-box  e-box-b-<Pressed ("<ButtonRelease-1>" "<Return>"))
    (mnas-binds e-box-b-> e-box  e-box-b->Pressed ("<ButtonRelease-1>" "<Return>"))
    (mnas-bind e-box-vt-cb e-box "<<ComboboxSelected>>" e-box-vt-cb-Selected)
    (mnas-binds e-box-l-edit e-box  l-edit-changed
		("<Return>" "<Key>" ;;; "<Tab>" "<Leave>" "<FocusOut>"
			    ))
    (mnas-bind e-box-dm-cb e-box "<<ComboboxSelected>>" e-box-dm-cb-Selected)
    (pack-forget-all e-box)    
    (cmd-pack-items (e-box-state e-box)
		    (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			  (e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(assoc "length" enter-box::*dim-type* :test #'string=)

(e-box-demo-1)
(edit-box )

(first (mdv:quantity-name (mdv:vd* 0.2 "mm")))

(mdv:unit-name (vd* 0.2 "mm") nil)
(format nil "~F" (mdv:vd-val (vd* 0.2 "mm")))


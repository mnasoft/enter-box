;;;; enter-box.lisp

(in-package #:cl-user)

(defpackage #:enter-box
  (:nicknames "MEB")
  (:use #:cl #:ltk #:ltk-mw) ; #:mnas-dim-value #:mnas-list
  (:export e-box)
  (:export edit-box
;;	   e-box-demo-1
	   e-box-demo-2
   	   spring-dialog
	   )
  (:export enter-box-import-symbols)
  (:documentation "Enter-Box представляет виджет для ввода чисел с размерностью. 
Для детального описания см. README.org")
  )

;;;; (declaim (optimize (compilation-speed 0) (debug 3) (safety 0) (space 0) (speed 0)))

(in-package #:enter-box)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(export 'e-box-l-edit-changed )
(defgeneric e-box-l-edit-changed (e-box  text)
  (:documentation "Реактор изменения содержимого l-edit"))

(export 'e-box-dm-cb-Selected )
(defgeneric e-box-dm-cb-Selected (e-box  text)
  (:documentation "Реактор выбора элемента из списка dm-cb"))

(export 'e-box-b->Pressed     )
(defgeneric e-box-b->Pressed     (e-box  text)
  (:documentation "Реактор нажатия на кнопку b->"))

(export 'e-box-b-<Pressed     )
(defgeneric e-box-b-<Pressed     (e-box  text)
  (:documentation "Реактор нажатия на кнопку b-<"))

(export 'e-box-vt-cb-Selected )
(defgeneric e-box-vt-cb-Selected (e-box  text))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(export 'e-box)
(export 'e-box-val)
(export 'e-box-state)
(export 'e-box-b-<)
(export 'e-box-vt-cb)
(export 'e-box-t-lb)
(export 'e-box-l-edit)
(export 'e-box-dm-cb)
(export 'e-box-b->)

(defclass e-box (frame)
  ((val    :accessor e-box-val    :initform nil)
   (state  :accessor e-box-state  :initform   2 :initarg :state
	   :documentation "Целое значение от 0 до 3.
Отвечает за состояние видимости виджетов, входящих в класс e-box.
При state равном: 
 - 0 отображается минимальное количество виджетов;
 - 3 отображается максимальное количество виджетов")
   (b-<    :accessor e-box-b-<    :initform nil :documentation
"Button.   Вызывает уменьшение количества отображаемых виджетов класса e-box.")
   (vt-cb  :accessor e-box-vt-cb  :initform nil :documentation
"ComboBox. Содержит типы величин. Например: длина, давление, время etc.")
   (t-lb   :accessor e-box-t-lb   :initform nil :documentation
"Label.    Содержит текстовую метку.")
   (l-edit :accessor e-box-l-edit :initform nil :documentation
"Entry.    
Окно ввода значений.")
   (dm-cb  :accessor e-box-dm-cb  :initform nil
	   :documentation
"ComboBox. 
Содержит размерности для определенного типа величины. 
Например для типа величины давление: МПа, кПа, Па, мм вод.ст. etc.")
   (b->    :accessor e-box-b->    :initform nil :documentation
"Button.   
Вызывает увеличение количества отображаемых виджетов класса e-box")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
			   ("force"  ("MN" "tf" "kN" "kgf" "N" "gf") "N")
   			   ("mass flow rate"  ("t/s" "kg/s" "kg/h" "g/s") "kg/s")
			   ("dimensionless" ("ul") "ul")))

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

(defmethod  e-box-l-edit-changed ((e-box e-box) text)
  "COOOOOOOOOOOOOOOOO
"
  (format t "~&e-box-l-edit-changed:start ... ")
  (format t "Event:~S; val=~S" text (e-box-val e-box))
  (setf (e-box-val e-box)
	(mdv:vd* (read-from-string (text (e-box-l-edit e-box)))
	     (mdv:quantity-from-string (text (e-box-dm-cb e-box))) ;;;; (dimensionp (text (e-box-dm-cb e-box)))
	     )) 
  (format t "Event:~S; val=~S" text (e-box-val e-box))
  (format t "... e-box-l-edit-changed:end~%")
  (finish-output))

(defmethod e-box-dm-cb-Selected  ((e-box e-box) text)
  (format t "~&e-box-dm-cb-Selected:start ... ")
  (format t "Event:~S; val=~S" text (e-box-val e-box))
  (let ((new-dims (mdv:quantity-from-string (text (e-box-dm-cb e-box)))))
    (when (and (e-box-val e-box)
	       (equal (mdv:vd-dims (e-box-val e-box)) (mdv:vd-dims new-dims)) )
      (setf (text (e-box-l-edit e-box)) (format nil "~S" (mdv:vd-val (mdv:vd/ (e-box-val e-box) new-dims))))))
  (format t "-> val=~S" (e-box-val e-box))
  (format t "... e-box-dm-cb-Selected:end~%")    
  (finish-output))

(defmethod e-box-b->Pressed  ((e-box e-box) text)
  (format t "~&e-box-b->Pressed:start ... ")
  (format t "Event:~S; val=~S" text (e-box-val e-box))
  (pack-forget-all e-box)
  (setf (e-box-state e-box) (min (1+ (e-box-state e-box)) 3))
  (cmd-pack-items (e-box-state e-box)
		  (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			(e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))
  (format t "-> val=~S" (e-box-val e-box))
  (format t "... e-box-b->Pressed:end~%")
  (finish-output))

(defmethod e-box-b-<Pressed  ((e-box e-box) text)
  (format t "~&e-box-b-<Pressed:start ... ")
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (pack-forget-all e-box)
  (setf (e-box-state e-box) (max (1- (e-box-state e-box)) 0))
  (cmd-pack-items (e-box-state e-box)
		  (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			(e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))
  (format t "-> val=~S" (e-box-val e-box))
  (format t "... e-box-b-<Pressed:end~%")
  (finish-output))

(defmethod e-box-vt-cb-Selected  ((e-box e-box) text)
  (format t "~&e-box-vt-cb-Selected:start ... ")
  (format t "Event:~S; val=~S" text (e-box-val e-box))
  (setf (options (e-box-dm-cb e-box)) (second (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
  (setf (text (e-box-dm-cb e-box))  (third (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
  (setf (e-box-val e-box)
	(mdv:vd* (read-from-string (text (e-box-l-edit e-box)))
	     (mdv:quantity-from-string (text (e-box-dm-cb e-box)))))
  (format t "-> val=~S" (e-box-val e-box))
  (format t "... e-box-vt-cb-Selected:end~%")
  (finish-output))

(defmethod initialize-instance :after ((e-box e-box)
				       &key
					 (l-edit-text 20.0)
					 (label "Label" )
					 vtype
					 (dimension (third  (assoc vtype *dim-type* :test #'string=)))) 
  (let* ((val-type (mapcar #'first *dim-type*)))
    (unless (member vtype val-type :test #'equal) (setf vtype (first val-type)))
    (unless (member dimension (second (assoc vtype *dim-type* :test #'string=)) :test #'equal)
      (setf dimension (third  (assoc vtype *dim-type* :test #'string=))))
    (setf (e-box-b-<    e-box) (make-instance 'button    :master e-box :width 2 :text "<" )
	  (e-box-vt-cb  e-box) (make-instance 'combobox  :master e-box :width 25 :text vtype  :values val-type)
	  (e-box-t-lb   e-box) (make-instance 'label     :master e-box :text label)
	  (e-box-l-edit e-box) (make-instance 'entry     :master e-box :width 8 :text l-edit-text)
	  (e-box-dm-cb  e-box) (make-instance 'combobox  :master e-box :width 8 :text dimension :values (second (assoc vtype *dim-type* :test #'string=)))
	  (e-box-b->    e-box) (make-instance 'button    :master e-box :text ">"    :width 2))
    (mnas-binds e-box-b-< e-box  e-box-b-<Pressed ("<ButtonRelease-1>" "<Return>"))
    (mnas-binds e-box-b-> e-box  e-box-b->Pressed ("<ButtonRelease-1>" "<Return>"))
    (mnas-bind  e-box-vt-cb e-box "<<ComboboxSelected>>" e-box-vt-cb-Selected)
    (mnas-binds e-box-l-edit e-box  e-box-l-edit-changed ("<Return>" "<Key>")) ;;; "<Tab>" "<Leave>" "<FocusOut>"
    (mnas-bind  e-box-dm-cb e-box "<<ComboboxSelected>>" e-box-dm-cb-Selected)
    (pack-forget-all e-box)    
    (cmd-pack-items (e-box-state e-box)
		    (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			  (e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))
    (setf (e-box-val e-box)
	  (mdv:vd* (read-from-string (text (e-box-l-edit e-box)))
	       (mdv:quantity-from-string (text (e-box-dm-cb e-box)))))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

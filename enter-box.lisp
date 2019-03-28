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



;;;; classes.lisp
(in-package #:enter-box)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; e-box
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

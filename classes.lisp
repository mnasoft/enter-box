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
   (b-<    :accessor e-box-b-<    :initform nil :documentation "Button.   Вызывает уменьшение количества отображаемых виджетов класса e-box.")
   (vt-cb  :accessor e-box-vt-cb  :initform nil :documentation "ComboBox. Содержит типы величин. Например: длина, давление, время etc.")
   (t-lb   :accessor e-box-t-lb   :initform nil :documentation "Label.    Содержит текстовую метку.")
   (l-edit :accessor e-box-l-edit :initform nil :documentation "Entry.    Окно ввода значений.")
   (dm-cb  :accessor e-box-dm-cb  :initform nil :documentation "ComboBox. Содержит размерности для определенного типа величины. Например для типа величины давление: МПа, кПа, Па, мм вод.ст. etc.")
   (b->    :accessor e-box-b->    :initform nil :documentation "Button.   Вызывает увеличение количества отображаемых виджетов класса e-box")))

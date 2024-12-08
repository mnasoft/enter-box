;;;; ./src/demo.lisp

(defpackage :enter-box/demo
  (:nicknames "MEB/DEMO")
  (:use #:cl
        #:ltk
        #:ltk-mw
        #:enter-box/core) 
  (:export edit-box
           )
  (:documentation
   "Пакет Enter-Box/Demo представляет виджет для ввода чисел с
 размерностью. Для детального описания см. README.org") )

(in-package :enter-box/demo)

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
	     (e-box (make-instance '<e-box> 
				   :master frame
				   :label label
				   :l-edit-text l-edit-text
				   :state state
				   :vtype vtype
				   :dimension dimension))
	     (b-ok  (make-instance 'button
                                   :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf (<e-box>-val e-box)
                                                    (mdv:vd* (read-from-string (text (<e-box>-l-edit e-box)))
							     (mdv/calc:quantity-from-string (text (<e-box>-dm-cb e-box))))
						    rez (<e-box>-val e-box))
					      (format t "~S" (<e-box>-val e-box))
					      (setf *exit-mainloop* t)))))
	(bind b-ok "<Return>"
	      (lambda (event)
		(declare (ignore event))
		(setf (<e-box>-val e-box) (mdv:vd* (read-from-string (text (<e-box>-l-edit e-box)))
					           (mdv/calc:quantity-from-string (text (<e-box>-dm-cb e-box))))
		      rez (<e-box>-val e-box))
		(format t "~S" (<e-box>-val e-box))
		(setf *exit-mainloop* t)))
	(pack frame)
	(pack e-box :side :left :padx 5 :pady 5)
	(pack b-ok  :side :left :padx 5 :pady 5)))
    rez))

;;;; (edit-box)
;;;; (edit-box :l-edit-text 10.0 :state 2 :vtype "tempetarure" :label "Значение")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;; package.lisp

(defpackage #:enter-box)

(defpackage #:enter-box
  (:nicknames "meb")
  (:use #:cl #:ltk #:ltk-mw #:mnas-list #:mnas-dim-value)
  (:export enter-box::e-box)
  (:export enter-box::edit-box
;;	   enter-box::e-box-demo-1
	   enter-box::e-box-demo-2
   	   enter-box::spring-dialog
	   )
  (:export enter-box::enter-box-import-symbols)
  (:documentation "Enter-Box представляет виджет для ввода чисел с размерностью. 
Для детального описания см. README.org")
  )

;;;; (declaim (optimize (compilation-speed 0) (debug 3) (safety 0) (space 0) (speed 0)))

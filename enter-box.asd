;;;; enter-box.asd

(defsystem "enter-box"
  :description "Enter-Box представляет виджет для ввода чисел с размерностью"
  :author "Mykola Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on (#:ltk #:ltk-mw #:mnas-dim-value ) ; #:mnas-spring #:mnas-list 
  :serial nil
  :components ((:file "enter-box" )
	       (:file "demo"          :depends-on ( "enter-box" ))
;;	       (:file "cl-user-funcs" :depends-on ( "enter-box" "demo"))
	       )
  :long-description "Enter-Box представляет виджет для ввода чисел с размерностью
Для детального описания см. README.org"
  )

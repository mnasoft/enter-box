;;;; enter-box.asd

(defsystem #:enter-box
  :description "Describe enter-box here"
  :author "Nick Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on (#:ltk #:ltk-mw #:mnas-list #:mnas-dim-value)
  :serial t
  :components ((:file "package")
               (:file "enter-box")
	       (:file "cl-user-funcs")))


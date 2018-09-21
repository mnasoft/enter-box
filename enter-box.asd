;;;; enter-box.asd

(defsystem #:enter-box
  :description "Describe enter-box here"
  :author "Nick Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on (#:ltk #:ltk-mw #:mnas-list #:mnas-dim-value)
  :serial nil
  :components ((:file "package")
               (:file "enter-box" :depends-on ("package"))
	       (:file "cl-user-funcs" :depends-on ("package" "enter-box"))))


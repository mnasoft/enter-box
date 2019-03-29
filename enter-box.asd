;;;; enter-box.asd

(defsystem #:enter-box
  :description "Describe enter-box here"
  :author "Nick Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on (#:ltk #:ltk-mw #:mnas-list #:mnas-dim-value #:mnas-spring)
  :serial nil
  :components ((:file "package")
	       (:file "defgenerics"   :depends-on ("package"))
	       (:file "classes"       :depends-on ("package"))
               (:file "enter-box"     :depends-on ("package" "classes" "defgenerics"))
               (:file "defmethods"    :depends-on ("package" "classes" "defgenerics"))
	       (:file "demo"          :depends-on ("package" "classes" "enter-box" "defmethods"))
	       (:file "cl-user-funcs" :depends-on ("package" "enter-box" "demo" "defmethods"))
	       ))

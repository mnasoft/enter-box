;;;; enter-box.asd

(asdf:defsystem #:enter-box
  :description "Describe enter-box here"
  :author "Nick Matvyeyev"
  :license "GNU GPLv3"
  :depends-on (#:ltk #:ltk-mw #:mnas-list)
  :serial t
  :components ((:file "package")
               (:file "enter-box")))


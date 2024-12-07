;;;; enter-box.asd

(defsystem "enter-box"
  :description
  "Система Enter-Box представляет виджет для ввода чисел с размерностью."
  :author "Mykola Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on ("enter-box/core"
               "enter-box/demo"
               )
  :serial nil
  :components ((:module "src"
		:serial nil
                :components ((:file "enter-box"))))
  :long-description "Enter-Box представляет виджет для ввода чисел с
 размерностью. Для детального описания см. README.org")

(defsystem "enter-box/core"
  :description
  "Система Enter-Box/Core представляет виджет для ввода чисел с размерностью."
  :author "Mykola Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on ("ltk"
               "ltk-mw"
               "mnas-dim-value"
               "mnas-dim-value/calc"
               )
  :serial nil
  :components ((:module "src/core"
		:serial nil
                :components ((:file "core"))))
  :long-description "Enter-Box представляет виджет для ввода чисел с
 размерностью. Для детального описания см. README.org" )

(defsystem "enter-box/demo"
  :description
  "Система Enter-Box/Demo представляет демонстрацию виджета для ввода
  чисел с размерностью."
  :author "Mykola Matvyeyev <mnasoft@gmail.com>"
  :license "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 or later"
  :depends-on ("enter-box/core")
  :serial nil
  :components ((:module "src/demo"
		:serial nil
                :components ((:file "demo")))))



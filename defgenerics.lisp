;;;; defgenerics.lisp
(in-package #:enter-box)

(defgeneric e-box-l-edit-changed       (e-box  text)
  (:documentation
   "Реактор изменения содержимого l-edit"))

(defgeneric e-box-dm-cb-Selected (e-box  text)
  (:documentation
   "Реактор выбора элемента из списка dm-cb")
  )
(defgeneric e-box-b->Pressed     (e-box  text)
  (:documentation
   "Реактор нажатия на кнопку b->")
  )
(defgeneric e-box-b-<Pressed     (e-box  text)
    (:documentation
     "Реактор нажатия на кнопку b-<"))

(defgeneric e-box-vt-cb-Selected (e-box  text))

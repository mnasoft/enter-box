;;;; enter-box-bak.lisp

(in-package #:enter-box)

;;; "enter-box" goes here. Hacks and glory await!


(defparameter *dim-type* '(("pressure" ("MPa" "kPa" "Pa" "kgf/mm^2" "kgf/cm^2" "kgf/m^2" "mm_Hg" "mm_H2O") "Pa")
			   ("length" ("Mm" "km" "m" "mm" "μm" ) "m")
			   ("force"  ("MN" "tf" "kN" "kgf" "N" "gf") "N")))

(defun cmd-hide-wdget(widget)
  (pack-forget widget))

(defun cmd-show-wdget(widget)
  (pack widget))

(defun calc-state (state)
  "Вычисляет состояние видимости виджетов
Пример использования:
;;;; (calc-state 0)
;;;; (calc-state 1)
;;;; (calc-state 2)
;;;; (calc-state 3)
;;;; (calc-state 550)
"
  (case state
    (0         (list nil   nil  nil   t   nil   t       t))
    (1         (list   t   nil  nil   t     t   t       t))
    (2         (list   t   nil    t   t     t   t       t))
    (3         (list   t     t    t   t     t   nil     t))
    (otherwise (list   t     t    t   t     t   t       t))))



(defparameter *eb-state* '(    2  (nil   nil  nil nil   nil nil  nil))
  "                      '(state  (b-< vt-cb t-lb  eb dm-cb b-< b-ok))"
  )

(defun cmd-pack-items (widgets)
  (mapcar
   #'(lambda (st wgt)
       (when st (pack wgt :side :left :padx 5 :pady 5)))
   (calc-state (first *eb-state*))
   widgets))

(defun edit-box()
  (let ((val-type (mapcar #'first *dim-type*))
	(rez nil)
	;;(state 2)
	)
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (b-<   (make-instance 'button     :master frame :text "<" :width 2))
             (vt-cb (make-instance 'combobox   :master frame :width 25
				   :text (first val-type) :values val-type))
	     (t-lb  (make-instance 'label      :master frame :text "Label" )) ;;;; t-lb

	     (eb    (make-instance 'entry      :master frame :width 8 :text "10.0" ))
             (dm-cb (make-instance 'combobox   :master frame :width 8
				   :text   (third (assoc (first val-type) *dim-type* :test #'string=))
				   :values (second (assoc (first val-type) *dim-type* :test #'string=))))

	     (b->   (make-instance 'button     :master frame :text ">"    :width 2 :command (lambda () (format t "~&>~&"))))
	     (b-ok  (make-instance 'button     :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf rez (vd* (read-from-string (text eb))(dimensionp (text dm-cb))))
;;;;					      (setf rez (format nil "~&~A~A~&" (text eb) (text dm-cb)))
					      (setf *exit-mainloop* t)))))
	(bind  b-< "<ButtonRelease-1>"
	       (lambda (event)
		 (declare (ignore event))
		 (pack-forget-all frame)
		 (setf (first *eb-state*) (max (1- (first *eb-state*)) 0))
		 (cmd-pack-items (list b-< vt-cb t-lb eb dm-cb b-> b-ok)))) 

	(bind  b-> "<ButtonRelease-1>"
	       (lambda (event)
		 (declare (ignore event))
		 (pack-forget-all frame)
		 (setf (first *eb-state*) (min (1+ (first *eb-state*)) 3))
		 (cmd-pack-items (list b-< vt-cb t-lb eb dm-cb b-> b-ok))))
	(bind vt-cb "<<ComboboxSelected>>"
	      (lambda (event)
                (declare (ignore event))
		(setf (options dm-cb) (second (assoc (text vt-cb) *dim-type* :test #'equal)))
		(setf (text dm-cb)  (third (assoc (text vt-cb) *dim-type* :test #'equal)))
                (finish-output)))
	(bind dm-cb "<<ComboboxSelected>>"
	      (lambda (event)
                (declare (ignore event))
		(setf (text eb)
		      (format nil "~a"
			      (/(* (read-from-string (text eb) )
			       (vd-val (dimensionp (third (assoc (text vt-cb) *dim-type* :test #'equal)))))
			       (vd-val (dimensionp (text dm-cb)))))
                      )
		(setf (third (assoc (text vt-cb) *dim-type* :test #'equal) ) (text dm-cb))
		
		(finish-output)))
	(pack frame)
	(pack-forget-all frame)
	(cmd-pack-items (list b-< vt-cb t-lb eb dm-cb b-> b-ok))))
    rez))

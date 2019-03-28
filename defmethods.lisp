;;;; defmethods.lisp

(in-package #:enter-box)

(defmethod  l-edit-changed ((e-box e-box) text)
  (setf (e-box-val e-box)
	(vd* (read-from-string (text (e-box-l-edit e-box)))
	     (dimensionp (text (e-box-dm-cb e-box)))))
  (e-box-val e-box)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (finish-output))

(defmethod e-box-dm-cb-Selected  ((e-box e-box) text)
  (let ((new-dims (dimensionp (text (e-box-dm-cb e-box)))))
    (format t "Event:~S; val=~S~%" text (e-box-val e-box))
    (when
	(and (e-box-val e-box)
	     (equal (vd-dims (e-box-val e-box)) (vd-dims new-dims)) )
      (setf (text (e-box-l-edit e-box)) (format nil "~S" (vd-val (vd/ (e-box-val e-box) new-dims))))
      (format t "~S~%" (text (e-box-l-edit e-box))))
    (finish-output)))

(defmethod e-box-b->Pressed  ((e-box e-box) text)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (pack-forget-all e-box)
  (setf (e-box-state e-box) (min (1+ (e-box-state e-box)) 3))
  (cmd-pack-items (e-box-state e-box)
		  (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			(e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box))))



(defmethod e-box-b-<Pressed  ((e-box e-box) text)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (pack-forget-all e-box)
  (setf (e-box-state e-box) (max (1- (e-box-state e-box)) 0))
  (cmd-pack-items (e-box-state e-box)
		  (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			(e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box))))



(defmethod e-box-vt-cb-Selected  ((e-box e-box) text)
  (format t "Event:~S; val=~S~%" text (e-box-val e-box))
  (setf (options (e-box-dm-cb e-box)) (second (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
  (setf (text (e-box-dm-cb e-box))  (third (assoc (text (e-box-vt-cb e-box)) *dim-type* :test #'equal)))
  (finish-output))

(defmethod initialize-instance :after ((e-box e-box)
				       &key
					 (l-edit-text 20.0)
					 (label "Label" )
					 vtype
					 (dimension (third  (assoc vtype *dim-type* :test #'string=)))) 
  (let* ((val-type (mapcar #'first *dim-type*)))
    (unless (member vtype val-type :test #'equal)
      (setf vtype (first val-type)))
    (unless (member dimension (second (assoc vtype *dim-type* :test #'string=)) :test #'equal)
      (setf dimension (third  (assoc vtype *dim-type* :test #'string=))))
    (setf
     (e-box-b-<   e-box) (make-instance 'button     :master e-box :text "<" :width 2)
     (e-box-vt-cb e-box) (make-instance 'combobox   :master e-box :width 25
					:text vtype :values val-type)
     (e-box-t-lb   e-box) (make-instance 'label     :master e-box :text label)
     (e-box-l-edit e-box) (make-instance 'entry     :master e-box :width 8 :text l-edit-text)
     (e-box-dm-cb  e-box) (make-instance 'combobox  :master e-box :width 8
					 :text   dimension
					 :values (second (assoc vtype *dim-type* :test #'string=)))
     (e-box-b->   e-box) (make-instance 'button     :master e-box :text ">"    :width 2))
    (mnas-binds e-box-b-< e-box  e-box-b-<Pressed ("<ButtonRelease-1>" "<Return>"))
    (mnas-binds e-box-b-> e-box  e-box-b->Pressed ("<ButtonRelease-1>" "<Return>"))
    (mnas-bind e-box-vt-cb e-box "<<ComboboxSelected>>" e-box-vt-cb-Selected)
    (mnas-binds e-box-l-edit e-box  l-edit-changed
		("<Return>" "<Key>" ;;; "<Tab>" "<Leave>" "<FocusOut>"
			    ))
    (mnas-bind e-box-dm-cb e-box "<<ComboboxSelected>>" e-box-dm-cb-Selected)
    (pack-forget-all e-box)    
    (cmd-pack-items (e-box-state e-box)
		    (list (e-box-b-< e-box) (e-box-vt-cb e-box) (e-box-t-lb e-box)
			  (e-box-l-edit e-box) (e-box-dm-cb e-box) (e-box-b-> e-box)))))

;;;; ./src/demo.lisp

(defpackage #:enter-box/demo
  (:nicknames "MEB/DEMO")
  (:use #:cl #:ltk #:ltk-mw #:enter-box/core) ; #:mnas-dim-value #:mnas-list
  (:export edit-box
           e-box-demo-2)
  (:documentation
   "Пакет Enter-Box/Demo представляет виджет для ввода чисел с
 размерностью. Для детального описания см. README.org") )

(in-package #:enter-box/demo)

(defun edit-box (&key (l-edit-text 10.0) (state 2) vtype dimension (label "Значение"))
  "@b(Описание:) edit-box возвращает число с размерностью, 
которое можно ввести при помощи диалогового окна.
@b(Пример использования:)
@begin[lang=lisp](code)
(edit-box ) 
@end(code)
"
  (let ((rez nil))
    (with-ltk ()
      (let* ((frame (make-instance 'frame))
	     (e-box (make-instance '<e-box> 
				   :master frame
				   :label label
				   :l-edit-text l-edit-text
				   :state state
				   :vtype vtype
				   :dimension dimension))
	     (b-ok  (make-instance 'button
                                   :master frame :text "Ok"   :width 3
				   :command (lambda ()
					      (setf (<e-box>-val e-box)
                                                    (mdv:vd* (read-from-string (text (<e-box>-l-edit e-box)))
							     (mdv:quantity-from-string (text (<e-box>-dm-cb e-box))))
						    rez (<e-box>-val e-box))
					      (format t "~S" (<e-box>-val e-box))
					      (setf *exit-mainloop* t)))))
	(bind b-ok "<Return>"
	      (lambda (event)
		(declare (ignore event))
		(setf (<e-box>-val e-box) (mdv:vd* (read-from-string (text (<e-box>-l-edit e-box)))
					           (mdv:quantity-from-string (text (<e-box>-dm-cb e-box))))
		      rez (<e-box>-val e-box))
		(format t "~S" (<e-box>-val e-box))
		(setf *exit-mainloop* t)))
	(pack frame)
	(pack e-box :side :left :padx 5 :pady 5)
	(pack b-ok  :side :left :padx 5 :pady 5)))
    rez))

;;;; (edit-box)
;;;; (edit-box :l-edit-text 10.0 :state 2 :vtype "tempetarure" :label "Значение")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *e-box-rez* nil)

(defun e-box-demo-2 ()
  (with-ltk ()
    (let* ((rb-variable 1)
           (frame    (make-instance 'frame :name "frame-p"))
           (frame-l  (make-instance 'frame :master frame   :name "frame-l"))
           (frame-r  (make-instance 'frame :master frame   :name "frame-r"))
           (frame-p  (make-instance 'frame :master frame-l :name "frame-p"))
           (frame-kμ (make-instance 'frame :master frame-l :name "frame-kμ"))
           (frame-rb (make-instance 'frame :master frame-l :name "frame-rb"))           
           (frame-t  (make-instance 'frame :master frame-r :name "frame-t"))
           (culc     (make-instance 'button :text "Culc"   :name "culc"))
           (rb-g     (make-instance 'radio-button
                                    :master frame-rb
                                    :text "Расход G"
                                    :name "rb-g"
                                    :value 0
                                    :variable rb-variable
                                    :command
                                    #'(lambda (event)
                                        (declare (ignore event))
                                        (setf rb-variable 0))))
           (rb-f    (make-instance 'radio-button
                                   :master frame-rb :text "Площадь F"
                                   :name "rb-f"
                                   :value 1
                                   :variable rb-variable
                                   :command
                                   #'(lambda (event)
                                       (declare (ignore event))
                                       (setf rb-variable 1))))
           (rb-p-in (make-instance 'radio-button
                                   :master frame-rb
                                   :text "Давление P_in"
                                   :name "r-b-p-in"
                                   :value 2
                                   :variable rb-variable
                                   :command
                                   #'(lambda (event)
                                       (declare (ignore event))
                                       (setf rb-variable 2))))
	   (p-in  (make-instance '<e-box> :label "P_in " :master frame-p :vtype "pressure" :l-edit-text 201.325 :dimension "kPa"))
	   (p-out (make-instance '<e-box> :label "P_out" :master frame-p :vtype "pressure" :l-edit-text 101.325 :dimension "kPa"))
	   (dp    (make-instance '<e-box> :label "ΔP   " :master frame-p :vtype "pressure" :l-edit-text 100.000 :dimension "kPa"))
           (area  (make-instance '<e-box> :label "A    " :master frame-p :vtype "area"     :l-edit-text 27.0))
           (μ     (make-instance '<e-box> :label "μ    " :master frame-kμ :vtype "molecular mass" :l-edit-text 0.02895))
           (k     (make-instance '<e-box> :label "k    " :master frame-kμ :vtype "dimensionless" :l-edit-text 1.4))
           (t-in  (make-instance '<e-box> :label "T_in " :master frame-t :vtype "tempetarure" :l-edit-text (+ 273.15 15.0)))
           (t-out (make-instance '<e-box> :label "T_out" :master frame-t :vtype "tempetarure" :l-edit-text (+ 273.15)))
           (ρ-in  (make-instance '<e-box> :label "ρ_in " :master frame-t :vtype "density" :l-edit-text 1.2))
           (ρ-out (make-instance '<e-box> :label "ρ_out" :master frame-t :vtype "density" :l-edit-text 1.3))
           (W     (make-instance '<e-box> :label "W    " :master frame-t :vtype "velocity" :l-edit-text 0.0))
           (W-kr  (make-instance '<e-box> :label "W_kr " :master frame-t :vtype "velocity" :l-edit-text 0.0))
           (G     (make-instance '<e-box> :label "G    " :master frame-t :vtype "mass flow rate" :l-edit-text 0.0))
           (G-kr  (make-instance '<e-box> :label "G-kr " :master frame-t :vtype "mass flow rate" :l-edit-text 0.0))
           )
      (labels
          ((dp-func (event)
	     (declare (ignore event))
             (setf (<e-box>-val dp) (mdv:vd- (<e-box>-val p-in) (<e-box>-val p-out)))
             (<e-box>-val-changed dp))
           (p-in-func (event)
	     (declare (ignore event))
             (setf (<e-box>-val p-in) (mdv:vd+  (<e-box>-val dp) (<e-box>-val p-out)))
             (<e-box>-val-changed p-in))
           (culc-Presse (event)
             (declare (ignore event))
             (cond
               ((= rb-variable 0)
                #+nil (break "Расход G: ~A" rb-variable)
                (setf (<e-box>-val G) (mdv:vd*
                                       (mdv:quantity-by-dimension-string "kg/s")
                                       (idelchik:mass-flow-rate
                                        (make-instance 'idelchik:<forsunka> :area (mdv:vd-val (<e-box>-val area))) 
                                        (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-in )) :pressure (mdv:vd-val (<e-box>-val p-in)))
                                        (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-out)) :pressure (mdv:vd-val (<e-box>-val p-out)))
                                        (make-instance 'idelchik:<gas-k-mu> :mu (mdv:vd-val (<e-box>-val μ)) :k (mdv:vd-val (<e-box>-val k))))))
                (<e-box>-val-changed G)
                (setf (<e-box>-val W) (mdv:vd*
                                       (mdv:quantity-by-dimension-string "m/s")
                                       (idelchik:velocity-by-param-in-out  
                                        (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-in )) :pressure (mdv:vd-val (<e-box>-val p-in)))
                                        (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-out)) :pressure (mdv:vd-val (<e-box>-val p-out)))
                                        (make-instance 'idelchik:<gas-k-mu> :mu (mdv:vd-val (<e-box>-val μ)) :k (mdv:vd-val (<e-box>-val k))))))
                (<e-box>-val-changed W))
               ((= rb-variable 1)
                #+nil (break "Площадь F: ~A" rb-variable)
                (setf (<e-box>-val area)
                      (mdv:vd* (mdv:quantity-by-dimension-string "m^2")
                               (idelchik:<forsunka>-area
                                (idelchik:area-by-mass-flow-rate
                                 (make-instance 'idelchik:<forsunka> :area (mdv:vd-val (<e-box>-val area)))
                                 (mdv:vd-val (<e-box>-val G))
                                 (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-in )) :pressure (mdv:vd-val (<e-box>-val p-in)))
                                 (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-out)) :pressure (mdv:vd-val (<e-box>-val p-out)))
                                 (make-instance 'idelchik:<gas-k-mu> :mu (mdv:vd-val (<e-box>-val μ)) :k (mdv:vd-val (<e-box>-val k)))))))
                (<e-box>-val-changed area))
               ((= rb-variable 2)
                #+nil
                (break "Давление P_in: ~A" #+nil (ltk:value rb-f) rb-variable)
                (setf (<e-box>-val p-in)
                      (mdv:vd* (mdv:quantity-by-dimension-string "Pa")
                               (idelchik:pressure
                                (idelchik:param_in-by-mass-flow-rate
                                 (make-instance 'idelchik:<forsunka> :area (mdv:vd-val (<e-box>-val area)))
                                 (mdv:vd-val (<e-box>-val G))
                                 (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-in )) :pressure (mdv:vd-val (<e-box>-val p-in)))
                                 (make-instance 'idelchik:<param> :tempreche (mdv:vd-val (<e-box>-val t-out)) :pressure (mdv:vd-val (<e-box>-val p-out)))
                                 (make-instance 'idelchik:<gas-k-mu> :mu (mdv:vd-val (<e-box>-val μ)) :k (mdv:vd-val (<e-box>-val k)))))))
                (<e-box>-val-changed p-in))
               )))
        (bind p-in "<FocusOut>" #'dp-func)   (bind (<e-box>-l-edit p-in)  "<Return>" #'dp-func)
        (bind p-in "<FocusOut>" #'dp-func)   (bind (<e-box>-l-edit p-out) "<Return>" #'dp-func)
        (bind dp   "<FocusOut>" #'p-in-func) (bind (<e-box>-l-edit dp)    "<Return>" #'p-in-func)
        (bind culc "<ButtonRelease-1>" #'culc-Presse #+nil "<Return>"))
;;;;      
      (pack frame)
      (pack frame-l  :side :left)
      (pack frame-r  :side :left)
      
      (pack frame-p  :side :top)
      (pack frame-kμ :side :top)
      (pack frame-t  :side :left)
      (pack frame-rb :side :top)
      
      (pack p-in    :side :top) (pack p-out   :side :top) (pack dp      :side :top)
      (pack area    :side :top) (pack k       :side :top) (pack μ       :side :top)
      
      (pack culc    :side :top)
      
      (pack rb-g    :side :top) (pack rb-f    :side :top) (pack rb-p-in :side :top)
      (pack t-in    :side :top)
      (pack t-out   :side :top)
      (pack ρ-in    :side :top)
      (pack ρ-out   :side :top)
      (pack W       :side :top)
      (pack W-kr    :side :top)
      (pack G       :side :top)
      (pack G-kr    :side :top)      
      *e-box-rez*)))

;;;; (e-box-demo-2)

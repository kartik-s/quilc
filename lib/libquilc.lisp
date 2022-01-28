(require '#:asdf)

(asdf:load-system '#:sbcl-librarian)
(asdf:load-system '#:quilc)

(in-package #:quilc)

(sbcl-librarian:define-handle-type quil-program "quil_program")
(sbcl-librarian:define-handle-type chip-specification "chip_specification")

(sbcl-librarian:define-enum-type error-type "error_t"
  ("ERROR_SUCCESS" 0)
  ("ERROR_FAIL" 1))
(sbcl-librarian:define-error-map error-map error-type 0
  (t (condition) (declare (ignore condition)) 1))

(defun print-link (stream link &optional colon-p at-sign-p)
  (declare (ignore colon-p at-sign-p))
  (let* ((cxns (cl-quil::hardware-object-cxns link))
         (qubit0 (cl-quil::vnth 0 (cl-quil::vnth 0 cxns)))
         (qubit1 (cl-quil::vnth 1 (cl-quil::vnth 0 cxns))))
    (format stream "~a -- ~a" qubit0 qubit1)))

(defun print-chip-spec (chip-spec)
  (format t "~a qubits, ~a links~%" (cl-quil::chip-spec-n-qubits chip-spec) (cl-quil::chip-spec-n-links chip-spec))
  (format t "~%links:~%~{~/quilc:print-link/~%~}~%" (coerce (cl-quil::chip-spec-links chip-spec) 'list)))

(sbcl-librarian:define-library libquilc (:error-map error-map
                                         :function-linkage "QUILC_API"
                                         :function-prefix "quilc_")
  (:literal "/* types */")
  (:type quil-program chip-specification error-type)
  (:literal "/* functions */")
  (:function
   (safely-parse-quil quil-program ((source :string)))
   (print-program :void ((program quil-program)))
   (compiler-hook quil-program ((program quil-program) (chip-spec chip-specification)))
   (cl-quil::build-nq-linear-chip chip-specification ((n :int)))
   (quil::read-chip-spec-file chip-specification ((filename :string)))
   (print-chip-spec :void ((chip-spec chip-specification)))))

(sbcl-librarian:build-bindings libquilc ".")
(sbcl-librarian:build-python-bindings libquilc ".")
(sbcl-librarian:build-core-and-die libquilc ".")

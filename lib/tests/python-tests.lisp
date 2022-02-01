;;;; python-tests.lisp
;;;;
;;;; Author: Kartik Singh

(in-package #:libquilc-tests)

(deftest test-python-compile-quil ()
  (uiop:with-current-directory ("lib/")
    (let* ((input-source "H 0")
           (parsed-program (cl-quil:safely-parse-quil input-source))
           (chip-spec (cl-quil::build-nq-linear-chip 8))
           (processed-program (cl-quil:compiler-hook parsed-program chip-spec))
           (expected-output (quilc::print-program processed-program nil)))
      (multiple-value-bind (output error-output exit-code)
          (uiop:run-program '("python3" "tests/python/compile_quil.py") :env '((:PYTHONPATH . ".")) :input `(,input-source) :output :string)
        (is (string= output expected-output))))))

(deftest test-python-compile-protoquil ()
  (uiop:with-current-directory ("lib/")
    (let* ((input-source "H 0")
           (parsed-program (cl-quil:safely-parse-quil input-source))
           (chip-spec (cl-quil::build-nq-linear-chip 8))
           (processed-program (cl-quil:compiler-hook parsed-program chip-spec :protoquil t))
           (expected-output (quilc::print-program processed-program nil)))
      (multiple-value-bind (output error-output exit-code)
          (uiop:run-program '("python3" "tests/python/compile_protoquil.py") :env '((:PYTHONPATH . ".")) :input `(,input-source) :output :string)
        (is (string= output expected-output))))))

(deftest test-python-print-chip-spec ()
  (is nil))

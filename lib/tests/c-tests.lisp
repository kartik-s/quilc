;;;; c-tests.lisp
;;;;
;;;; Author: Kartik Singh

(in-package #:libquilc-tests)

(deftest test-build-lib ()
  "Test that libquilc builds."
  (uiop:with-current-directory ("lib/")
    (multiple-value-bind (output error-output exit-code)
        (uiop:run-program "make")
      (is (eql exit-code 0)))))

(deftest test-build-c-tests ()
  "Test that the C tests build."
  (uiop:with-current-directory ("lib/tests/c/")
    (multiple-value-bind (output error-output exit-code)
        (uiop:run-program "make")
      (is (eql exit-code 0)))))

(deftest test-compile-quil ()
  "Test compiling Quil programs."
  (uiop:with-current-directory ("lib/")
    (let* ((input-source "H 0")
           (parsed-program (cl-quil:safely-parse-quil input-source))
           (chip-spec (cl-quil::build-nq-linear-chip 8))
           (processed-program (cl-quil:compiler-hook parsed-program chip-spec))
           (expected-output (quilc::print-program processed-program nil)))
      (multiple-value-bind (output error-output exit-code)
          (uiop:run-program "tests/c/compile-quil" :input `(,input-source) :output :string)
        (is (string= output expected-output))))))

(deftest test-compile-protoquil ()
  "Test compiling ProtoQuil programs."
  (uiop:with-current-directory ("lib/")
    (let* ((input-source "H 0")
           (parsed-program (cl-quil:safely-parse-quil input-source))
           (chip-spec (cl-quil::build-nq-linear-chip 8))
           (processed-program (cl-quil:compiler-hook parsed-program chip-spec :protoquil t))
           (expected-output (quilc::print-program processed-program nil)))
      (multiple-value-bind (output error-output exit-code)
          (uiop:run-program "tests/c/compile-protoquil" :input `(,input-source) :output :string)
        (is (string= output expected-output))))))

(deftest test-print-chip-spec ()
  (is t))

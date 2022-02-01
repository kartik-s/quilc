;;;; c-tests.lisp
;;;;
;;;; Author: Kartik Singh

(in-package #:libquilc-tests)

(deftest test-build-lib ()
  "Test that libquilc builds."
  (uiop:chdir "lib")
  (multiple-value-bind (output error-output exit-code)
      (uiop:run-program "make")
    (is (eql exit-code 0))))

(deftest test-build-c-tests ()
  "Test that the C tests build."
  (uiop:chdir "tests/c")
  (multiple-value-bind (output error-output exit-code)
      (uiop:run-program "make")
    (is (eql exit-code 0))))

(deftest test-compile-quil ()
  "Test compiling Quil programs."
  (multiple-value-bind (output error-output exit-code)
      (uiop:run-program "tests/c/compile-quil" :input '("H 0") :output :string)
    (is (eql exit-code 0))))

(deftest test-compile-protoquil ()
  (is t))

(deftest test-print-chip-spec ()
  (is t))

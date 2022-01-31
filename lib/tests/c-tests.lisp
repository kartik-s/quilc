;;;; c-tests.lisp
;;;;
;;;; Author: Kartik Singh

(in-package #:libquilc-tests)

(deftest test-build-lib ()
  "Test that libquilc builds."
  (multiple-value-bind (output error-output exit-code)
      (format t "~a" (uiop:getcwd))
      (uiop:run-program "make" :output t)
    (is exit-code 0)))

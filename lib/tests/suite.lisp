;;;; tests/suite.lisp
;;;;
;;;; Author: Kartik Singh

(in-package #:libquilc-tests)

(defun run-libquilc-tests (&key (verbose nil) (headless nil))
  "Run all libquilc tests. If VERBOSE is T, print out lots of test info. If HEADLESS is T, disable interactive debugging and quit on completion."
  (setf fiasco::*test-run-standard-output* (make-broadcast-stream *standard-output*))
  (cond
    ((null headless)
     (run-package-tests :package ':libquilc-tests
                        :verbose verbose
                        :describe-failures t
                        :interactive t))
    (t
     (let ((successp (run-package-tests :package ':libquilc-tests
                                        :verbose t
                                        :describe-failures t
                                        :interactive nil)))
       (uiop:chdir "lib")
       (uiop:run-program "make" "clean")
       (uiop:quit (if successp 0 1))))))

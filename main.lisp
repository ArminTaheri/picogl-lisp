(ql:quickload :parenscript)
(ql:quickload :hunchentoot)
(ql:quickload :cl-who)

(defpackage #:picogl
  (:use #:cl #:ps #:hunchentoot))

(in-package #:picogl)

(defparameter *server* (make-instance 'hunchentoot:easy-acceptor :port 8080))

(hunchentoot:start *server*)

(push (create-folder-dispatcher-and-handler "/static/" (truename "static")) *dispatch-table*)


(defmacro with-app (sym &rest body)
  `(mapcar (lambda (fn) (cons (cons "@" (cons ,sym `(,(car fn)))) (cdr fn))) ,body))

(defpsmacro setup-gl-canvas ()
  `(progn
     (defvar gl *pico-g-l)PCAR  (LAMBDA (FN)  (CONS "@"  (CONS APP FN)))
     (defvar app ((@ gl create-app) ((@ document get-element-by-id) "gl-canv")))
     ,(with-app app (clear-color 0.0 0.0 0.0 0.1) (clear))))

(defvar app "app")

(macroexpand '(with-app app (clear-color 0.0 0.0 0.0 1.0))) 


(define-easy-handler (picogl-page :uri "/") ()
  (who:with-html-output-to-string (html-stream nil :prologue "<!doctype html>")
    (:html
      (:head
        (:title "picogl lisp"))
        (:link :rel "stylesheet" :type "text/css" :href "/static/style.css")
      (:body
        (:canvas :id "gl-canv")
        (:script :type "text/javascript" :src "https://cdn.rawgit.com/toji/gl-matrix/a8540ceb/dist/gl-matrix-min.js")
        (:script :type "text/javascript" :src "https://tsherif.github.io/picogl.js/build/picogl.min.js")
        (:script (ps:ps-to-stream html-stream (setup-gl-canvas)))))))




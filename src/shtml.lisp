(defpackage #:asha/shtml
  (:use #:cl)
  (:export #:element
           #:element-name
           #:element-props
           #:element-children
           #:make-element*
           #:render-element))
(in-package #:asha/shtml)

(defstruct element
  name props children)

(defun check-name (shtml)
  (cond ((not (listp shtml))
         (error "SHTML should be a list."))
        ((zerop (length shtml))
         (error "empty list is not SHTML."))
        ((not (keywordp (first shtml)))
         (error "first element of shtml must be a keyword."))
        (t (first shtml))))

(defun get-props (shtml-rest)
  (loop
    :for (k v . rest) :on shtml-rest :by #'cddr
    :with props := nil
    :do (cond ((and (keywordp k) (stringp v))
               (progn
                 (push v props)
                 (push k props)))
              ((keywordp k)
               (error (format nil "value ~s should be a string." v)))
              (t (return  (values props (if (null v)
                                            (list k)
                                            (cons k (cons v rest)))))))
    :finally (return (values props nil))))

(defun make-element* (e)
  (cond ((null e)
         (error "shtml must have its name."))
        ((functionp e) e)
        (t (let ((name (check-name e)))
             (multiple-value-bind (props children)
                 (get-props (rest e))
               (make-element :name name
                             :props props
                             :children (loop
                                         :for c :in children
                                         :collect (if (listp c) (make-element* c) c))))))))

;; https://developer.mozilla.org/en-US/docs/Glossary/Empty_element
(defvar +empty-elements+
  '(:area :base :br :col :embed :hr :img :input :link :meta :param :source :track :wbr))

(defun render-shtml-element (e params indent)
  (format *standard-output* "~v,0t<~(~a~)~{~^ ~(~a~)=\"~a\"~}>~%" indent
          (element-name e) (element-props e))
  (loop
    :for c :in (element-children e)
    :do (render-element c params (+ indent 2)))
  (unless (member (element-name e) +empty-elements+)
    (format *standard-output* "~v,0t</~(~a~)>~%" indent (element-name e))))

(defun render-element (e &optional params (indent 0))
  (typecase e
    (string (format *standard-output* "~v,0t~a~%" indent e))
    (element (render-shtml-element e params indent))
    (function (render-shtml-element (make-element* (funcall e params)) params indent))
    (t (error "it's not a shtml element: ~s." e))))

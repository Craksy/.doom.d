;;; amnesia/project-wizard/project-wizard.el -*- lexical-binding: t; -*-
;;; project-wizard.el --- A package for creating new projects -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Silas Wagner
;;
;; Author: Silas Wagner <http://github/amnesia>
;; Maintainer: Silas Wagner <hiiamnesia@gmail.com>
;; Created: January 13, 2021
;; Modified: January 13, 2021
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/amnesia/project-wizard
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  A package for creating new projects
;;
;;; Code:

(defvar project-wizard--projects-dir nil
  "The place where new projects are created")

(defvar project-wizard-item-handlers nil
  "A list that maps symbol names to item handlers.")

(defun file-from-template (file &optional template-name)
  "Create FILE if it doesn't already exist.
If TEMPLATE-NAME is provided try to find it and expand it.
TODO: add more options, like passing env variables for expansion, or optionally
opening the file for interactive snippet expansion."
  (let ((buf (find-file-noselect file))
        template)
    (with-current-buffer buf
      (when template-name
        ;; save the buffer to make sure the file exists in case the template
        ;; wants to use the current file name for some kind of expansion.
        (save-buffer)
        (erase-buffer) ;; REVIEW: should we even touch the file if it exists?
        (set-auto-mode)
        (setq template (yas-lookup-snippet template-name))
        (yas-expand-snippet template))
      (save-buffer))))

(defun mandatory-or-chose-p (type id args)
  "Return non nil if ITEM does not have the `:optional' property, or if the
user responds with yes to include in an interactive y-or-n-prompt"
  (or
   (not (plist-get args :optional))
   (y-or-n-p (format "Include %s %s?" type id))))

(defmacro define-item-handler (name args &rest body)
  (declare (indent defun))
    `(add-to-list 'project-wizard-item-handlers '(,name (lambda ,args ,@body))))

(defun determine-string (object kind)
  "determine how to interpret OBJECT and return a string accordingly.
If OBJECT is a string, return it as is.
If it is a list of strings have the user select between elements in CDR using
CAR as prompt.
otherwise attempt to evaluate object as a function"
  (cond
   ((stringp object)
    object)
   ((consp object)
    (if (seq-every-p 'stringp object)
        (ivy-read (format "Choose a %s" kind) object :require-match t)
      (eval object)))
   (t
    (message "Invalid object %s" (type-of object)))))

;; this function servers both as the entry point for building the directory
;; structure as well as the item handler for (dir ...) items
;; each item in structure can be a:
;; string: create empty file, or directory if it contains a slash
;;
;; A list where first item is a string:
;; create a folder with CAR as name and process CDR as child elements.
;;
;; A call to a function with the signature:
;; `FN(project-name curdir &rest args)'
;; which will be called with CDR as ARGS.
(defun create-project-dir (structure curdir)
  (dolist (item structure)
    (cond
     ;;if item is a string just add a dir with that name.
     ((stringp item)
      (message "add dir %s" (concat curdir item))
      (mkdir (expand-file-name item curdir) t))
     ;;if item is a cons cell, look at CAR to identify what kind of item it is
     ((consp item)
      (let ((itcar (car item)))
        (cond ((stringp itcar)
               (mkdir (expand-file-name itcar curdir) t)
               (create-project-dir (cdr item) (expand-file-name itcar curdir)))
              ((symbolp itcar)
               (get-handler curdir item))))))))

(defun get-handler (curdir item)
  (let ((type (car item))
        (id (cadr item))
        (args (cddr item)))
    (when (mandatory-or-chose-p type id args)
      (if-let (handler (assoc type project-wizard-item-handlers))
          (apply (cadr handler) curdir args)
        (message "no handler found type: %s" type)))))


(define-item-handler file (curdir &rest args)
  (let ((name (plist-get args :name))
        (optional (plist-get args :optional))
        (template (plist-get args :template)))
    (message "creating file in %s\nargs: %s" curdir args)
    (file-from-template
     (expand-file-name (determine-string name "filename") curdir)
     (when template template))))

(provide 'project-wizard)
;;; project-wizard.el ends here

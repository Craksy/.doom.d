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
    (if (consp item)
        )))

;; create a file from a file template... i need to figure out how to expand the
;; file template the first time the file is opened or fill it out automatically
(defun file-from-template (name file)
  nil)

;; just for reference to the recursive thing
(defun print-rec (structure &optional level)
  (let ((indent (make-string (* 2 level) ? )))
    (dolist (item structure)
      (if (consp item)
          (progn
            (message "%s%s/" indent (car item))
            (print-rec (cdr item) (1+ level)))
        (message "%s%s" indent item)))))


(provide 'project-wizard)
;;; project-wizard.el ends here

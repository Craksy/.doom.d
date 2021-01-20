;;; custom-fuctions.el -*- lexical-binding: t; -*-
(evil-define-operator ex-operator (beg end type)
  "Execute an ex command on region defined by operator"
  (interactive "<R>")
  (evil-visual-select beg end type)
  (evil-ex "`<,`>"))

(evil-define-operator evil-aya-create-operator (beg end type)
  "Create an autosnippet from region"
  (interactive "<R>")
  (aya-create beg end))

(evil-define-operator ex-substitute-operator (beg end type)
  "evil substitute in the region define by operator"
  (interactive "<R>")
  (evil-visual-select beg end type)
  (evil-ex "`<,`>s/"))

;; I always forget the syntax and properties, so this is pretty handy.
(defun open-yasnippet-documentation ()
  "Open the YASnippet documentation in a new window"
  (interactive)
  (find-file-other-window "~/.emacs.d/.local/straight/repos/yasnippet/doc/index.org"))

(defun open-new-org-buffer ()
  (interactive)
  (let ((buffer (generate-new-buffer "*new org*")))
    (set-window-buffer nil buffer)
    (with-current-buffer buffer
      (org-mode))))

;; this was just me playing around while trying to learn elisp..
(defun write-something()
  (insert
   (propertize (+doom-dashboard--center
                +doom-dashboard--width
                "The quieter you become, the more you'll hear\n\n")
               'face 'doom-dashboard-loaded)))

(push 'write-something (nthcdr 1 +doom-dashboard-functions))


(defvar common-buffer-types '(
                              ("Elisp" . emacs-lisp-mode)
                              ("Python" . python-mode)
                              ("Org" . org-mode)
                              ("Text" . text-mode))
  "Major mode options for `open-new-buffer-type'")

(defun open-new-buffer-type (&optional mode)
  (interactive)
  (let ((buffer (generate-new-buffer "*new buffer*")))
    (set-window-buffer nil buffer)
    (with-current-buffer buffer
      (if mode
          (funcall mode)
        (ivy-read "Mode: " common-buffer-types
                  :action (lambda (item) (interactive) (funcall (cdr item))))))))

;;; amnesia/project-wizard/test.el -*- lexical-binding: t; -*-

;; just a bunch of snippets to test the functions in project-wizard.el
(setq project-wizard--projects-dir "~/wizard-test/" )
(let ((item '(file :name (format "filename.py") :optional "want to include test?")))
  (apply 'file-item-handler (cons "~/wizard-test/" (cdr item))))

(let ((test-loc "~/wizard-test/")
      (test-struc '("src"
                    ("docs"
                     (file "test file"
                           :name "test"
                           :optional "bar")
                     (file "a readme"
                           :name ("README" "README.md" "README.org"))
                     "subdocs")
                    "assets/images"
                    "lib")))
  (create-project-dir test-struc test-loc))


(get-handler "~/wizard-test/" '(file "README"
                                     :name "Readme.txt"
                                     :optional t))

(setq project-wizard-item-handlers nil)
(add-to-list 'project-wizard-item-handlers '(file . #'file-item-handler))
(add-to-list 'project-wizard-item-handlers '(msg . #'message))


(funcall #'file-item-handler "hello" '(:optional))
(message "func: %s\ntype: %s\nargs: %s" (cadr (assoc 'file project-wizard-item-handlers)) "hello" '(:optional))

(functionp (cadr (assoc 'file project-wizard-item-handlers)))

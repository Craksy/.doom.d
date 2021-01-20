;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;Load config modules
(load! "custom-functions.el") ;;utilities and helpers that my config depends on
(load! "keybindings.el")      ;;My key bindings

;; General configuration variables
(setq
 ;; Personal information used by different packages
 user-full-name    "Silas Wagner"
 user-mail-address "hiiamnesia@gmail.com"

 ;; Looks
 doom-theme                'doom-dracula
 doom-font                 "FiraCode Nerd Font Mono-11" ;;"DejaVu Sans Code-11"
 fancy-splash-image        "~/Pictures/Wallpapers/doom-purple.png"

 ;; Misc
 evil-split-window-below   t
 evil-vsplit-window-right  t
 evil-ex-substitute-global t
 display-line-numbers-type 'visual
 which-key-idle-delay      0.3
 +ivy-buffer-preview       t
 yas-triggers-in-field     t
 ;; ispell-dictionary         "en-custom"

 ;;Org stuff.
 org-directory      "~/Documents/org/"
 org-agenda-files   '("~/Documents/org/notes.org"
                      "~/Documents/org/todo.org"
                      "~/Documents/org/today.org"
                      "~/Documents/org/projects.org"
                      "~/Documents/org/school.org")
 org-roam-directory "/home/amnesia/Documents/org-roam/")

;; Each path is relative to `+mu4e-mu4e-mail-path', which is ~/.mail by default
(set-email-account! "gmail"
  '((mu4e-sent-folder       . "/gmail/Sent Mail/")
    (mu4e-drafts-folder     . "/gmail/Drafts/")
    (mu4e-trash-folder      . "/gmail/Trash/")
    (mu4e-refile-folder     . "/gmail/All Mail/")
    (smtpmail-smtp-user     . "hiiamnesia@gmail.com")
    (mu4e-compose-signature . "---\nSilas Wagner")))

;; Package specific configurations
;; Org-mode
(after! org
  (setq org-startup-with-inline-images t)

  (add-to-list 'org-capture-templates
               '("s" "Scheduled Task" entry
                 (file+headline "todo.org" "Inbox")
                 "* [ ] %?\n SCHEDULED: %t"))

  (add-hook! org-mode
             #'+org-pretty-mode))


(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-custom-commands
        '(("d" "Chad-genda"
           ((agenda "" ((org-agenda-span 3)
                        (org-agenda-start-day "-0d")
                        (org-super-agenda-groups
                         '((:name "Schedule"
                            :time-grid t
                            :date today
                            :scheduled today
                            :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:name "Due"
                             :deadline today)
                            (:name "Due soon"
                             :deadline future)
                            (:name "Projects"
                             :tag "Projects")
                            (:name "School stuff"
                             :tag "School")
                            (:name "Needs refiling"
                             :tag "Refile")))))))))
  :config
  (org-super-agenda-mode))


;; Projectile
(after! projectile
  (setq projectile-auto-discover t
        projectile-ignored-projects '("/tmp/" "~/" "~/emacs.d/.local/")
        projectile-project-search-path '("~/projects/"))
  (defun projectile-ignored-project-function(path)
    (or (mapcar (lambda (p) (s-starts-with-p p path))
             projectile-ignored-projects))))

;; Avy
(after! avy
  (setq avy-all-windows t
        avy-single-candidate-jump t
        avy-timeout-seconds 0.3))

;; Elcord
(use-package! elcord
  :init
  (setq
   elcord-display-buffer-details nil
   elcord-use-major-mode-as-main-icon t)
  :config
  (elcord-mode))

(after! company
  (setq company-show-numbers t)
  (set-company-backend! '(text-mode fundemental-mode markdown-mode)
    '(:separate
      company-ispell
      company-yasnippet
      company-files)))

(use-package! info-colors
  :commands (info-colors-fontify-node))
(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(use-package! tron-legacy-theme)

(defadvice! prompt-for-buffer (&rest _)
  "switch buffer"
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/projectile-find-file))

;;; keybindings.el -*- lexical-binding: t; -*-

;; Leader mappings
(defvar doom-leader-yas-map (make-sparse-keymap ))
(map! :leader
      ;; Mostly did this one to get comfortable with the `map!'
      :desc "Snippets" "y" doom-leader-yas-map
      (:prefix "y"
       :desc "Insert Snippet"            "y" 'yas-insert-snippet
       :desc "Create new snippet"        "c" '+snippets/new
       :desc "Create new alias"          "A" '+snippets/new-alias
       :desc "Create new autosnippet"    "a" 'evil-aya-create-operator
       :desc "Find private snippet"      "p" '+snippets/find-private
       :desc "Find snippets for mode"    "m" '+snippets/find-for-current-mode
       :desc "Find any snippet"          "P" '+snippets/find
       :desc "Edit snippet"              "e" '+snippets/edit
       :desc "YASnippet Docs"            "d" 'open-yasnippet-documentation)
      ;;Numbered windows.
      :desc "GoWin 1" "1" 'winum-select-window-1
      :desc "GoWin 2" "2" 'winum-select-window-2
      :desc "GoWin 3" "3" 'winum-select-window-3
      :desc "GoWin 4" "4" 'winum-select-window-4
      :desc "GoWin 5" "5" 'winum-select-window-5
      ;; Misc overides and additions
      (:prefix "w"
       :desc "Window Hydra" "SPC" '+hydra/window-nav/body)

      (:prefix "o"
       :desc "Open ranger" "f" 'ranger
       :desc "Open calc" "c" 'calc)

      (:prefix "f"
       :desc "Open Dired" "f" 'dired-jump)

      (:prefix "s"
       :desc "evil ex substitute" "o" 'ex-substitute-operator
       :desc "Search Buffer" "s" 'counsel-grep-or-swiper
       :desc "Search Buffer" "b" '+default/search-buffer)

      (:prefix "b"
       :desc "New Org buffer" "o" 'open-new-org-buffer)

      (:prefix "TAB"
       :desc "Previous workspace" "TAB" '+workspace/other
       :desc "Display tab bar" "TAB" '+workspace/other))


(map! :leader
      :desc "evaluate expression" ":" 'pp-eval-expression
      :desc "Counsel M-x" ";" 'counsel-M-x)

;; ;; Since i have ; and : swapped in my keyboard layout, I am swapping evil-repeat
;; ;; forward/reverse in order to have forward repeat on a key without a modifier
;; (map! :map evil-snipe-parent-transient-map
;;       "," 'evil-snipe-repeat
;;       ";" 'evil-snipe-repeat-reverse
;;       )

(map! :nv "C-;" 'ex-operator
      :n  "C-k" 'lsp-ui-doc-glance
      :n  "<menu>" 'menu-bar-open)

(map! :map org-roam-backlinks-mode-map
      :n "TAB" 'org-next-link
      :n "S-TAB" 'org-previous-link)

;; modify which-key replacements to group all winum-select keys under a single
;; item.
(after! which-key
  (push
   '(("1" . "winum-select-window-1") . ("1..5" . "Go to Window"))
   which-key-replacement-alist)
  (push
   '((nil . "winum-select-window-[2-5]") . t)
   which-key-replacement-alist))

(after! org-super-agenda
  (map! :map org-super-agenda-header-map
        "j" 'nil
        "k" 'nil))

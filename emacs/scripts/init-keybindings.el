(provide 'init-keybindings)

;; (defun my/setup-magit-keys ()
;;   "Setup keybindings for magit"
;;   (interactive)
;;   (general-define-key
;;    :prefix leader
;;    :keymaps '(normal visual emacs)
;;    "g" 'magit-status))

(defun my/setup-evil-keys ()
  ;;Exit insert mode by pressing j and then j quickly
  (use-package key-chord
    :ensure t
    :config
    (setq key-chord-two-keys-delay 1)
    (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
    ;; (key-chord-define evil-insert-state-map "JJ" ('evil-normal-state "o"))
    (key-chord-mode 1)))

(defun my/setup-projectile-keys ()
  "Setup keybindings for projectile"
  (interactive)
  (general-define-key
   :prefix leader
   :keymaps '(normal visual emacs)
   "p" 'projectile-find-file
   "P" 'projectile-switch-project))

(defun my/setup-elfeed-keys ()
  "Setup keybindings for elfeed"
  (interactive)
  (general-define-key
   :prefix leader
   :keymaps '(normal visual emacs)
   "r" 'elfeed)
  (general-define-key
   :states 'normal
   :keymaps '(elfeed-search-mode-map)
   "f" 'elfeed-search-set-filter
   "r" 'elfeed-update
   "o" 'elfeed-search-show-entry
   "q" 'elfeed-kill-buffer)
  (general-define-key
   :states 'normal
   :keymaps '(elfeed-show-mode-map)
   "q" 'elfeed-kill-buffer
   "n" 'elfeed-show-next
   "p" 'elfeed-show-prev))

(defun my/setup-window-keys ()
  "Setup keybindings for window management"
  (interactive)
  (general-define-key
   :keymaps '(normal visual motion)
   "C-h" 'windmove-left
   "C-k" 'windmove-up
   "C-l" 'windmove-right
   "C-j" 'windmove-down
   "C-S-l" 'evil-window-increase-width
   "C-S-h" 'evil-window-decrease-width
   "C-S-k" 'evil-window-increase-height
   "C-S-j" 'evil-window-decrease-height)
  (general-define-key
   :prefix leader
   :keymaps '(normal)
   "wh" 'split-window-right
   "wl" (lambda () (interactive) (split-window-right) (other-window 1))
   "wk" 'split-window-below
   "wj" (lambda () (interactive) (split-window-below) (other-window 1))
   "wf" 'delete-other-windows
   "wd" 'evil-delete-buffer))

(defun my/setup-elisp-keys ()
  "Setup keybindings for emacs-lisp-mode"
  (interactive)
  (general-define-key
   :prefix leader
   :states '(normal visual)
   :keymaps 'lisp-mode-shared-map
   "er" 'eval-region
   "eb" 'eval-buffer
   "ed" 'eval-defun
   "es" 'eval-last-sexp
   "ee" 'eval-expression))

(defun my/setup-folding-keys ()
  "Setup keybindings for folding"
  (interactive)
  (general-define-key
   :prefix leader
   :keymaps '(normal visual emacs)
   "zR" 'hs-hide-all
   "zM" 'hs-show-all
   "za" 'hs-toggle-hiding))

(defun my/setup-comment-keys ()
  "Setup keybindings for commenting"
  (interactive)
  (general-define-key
   :prefix leader
   :keymaps '(normal visual emacs)
   "c" 'comment-line))

(defun my/setup-ivy-keys ()
  "Setup keybindings for ivy"
  (interactive)
  (general-define-key
   :prefix leader
   :keymaps '(normal visual emacs)
   "f" 'counsel-find-file))

(use-package general
  :ensure t
  ;; :after (evil magit elfeed projectile)
  :after (evil elfeed projectile)
  :config
  ;; (general-create-definer my/leader-keys
  ;;   :keymaps '(normal insert visual emacs)
  ;;   :prefix "SPC"
  ;;   :global-prefix "C-SPC")

  ;; (my/leader-keys
  ;;  "t" '(:ignore t :which-key "toggles")
  ;;  "tt" '(counsel-load-theme :which-key "choose theme"))

  (setq leader "<SPC>")
  (my/setup-comment-keys)
  (my/setup-elfeed-keys)
  (my/setup-elisp-keys)
  (my/setup-evil-keys)
  (my/setup-folding-keys)
  (my/setup-ivy-keys)
  ;; (my/setup-magit-keys)
  (my/setup-projectile-keys)
  (my/setup-window-keys)
  )

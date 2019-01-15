(provide 'init-keybindings)

;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
;; (setq w32-pass-lwindow-to-system nil)
;; (setq w32-lwindow-modifier 'super) ; Left Windows key

;; (setq w32-pass-rwindow-to-system nil)
;; (setq w32-rwindow-modifier 'super) ; Right Windows key

;; (setq w32-pass-apps-to-system nil)
;; (setq w32-apps-modifier 'hyper) ; Menu/App key

(defun my/setup-magit-keys ()
  "Setup keybindings for magit"
  (interactive)
  (general-define-key
    :prefix leader
    :keymaps '(normal visual emacs)
    "g" 'magit-status))

(defun my/setup-evil-keys ()
  (general-define-key
    :pefix "j"
    :status '(insert)
    "j" 'evil-force-normal-state))

(defun my/setup-projectile-keys ()
  "Setup keybindings for projectile"
  (interactive)
  (general-define-key
    :prefix leader
    :keymaps '(normal visual emacs)
    "p" 'projectile-find-file
    "P" 'projectile-switch-project))

(use-package general
             :ensure t
             :after (evil magit)
             :config
             (setq leader "<SPC>")
             (my/setup-evil-keys)
             (my/setup-magit-keys)
             (my/setup-projectile-keys)
             )

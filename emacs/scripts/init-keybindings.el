(provide 'init-keybindings)

(defun my/setup-magit-keys ()
  "Setup keybindings for magit"
  (interactive)
  (general-define-key
    :prefix leader
    :keymaps '(normal visual emacs)
    "g" 'magit-status))

(defun my/setup-evil-keys ()
  ;;Exit insert mode by pressing j and then j quickly
  (require 'key-chord)
  (setq key-chord-two-keys-delay 1)
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
  (key-chord-mode 1)
  )

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

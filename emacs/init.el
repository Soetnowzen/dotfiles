(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/scripts")

(require 'init-use-package)
(require 'init-evil)
(require 'init-keybindings)
(require 'init-magit)
(require 'init-org)
(require 'init-projectile)
(require 'init-theme)

(defun mp-display-message ()
  (interactive)
  ;; Place your code below this line, but inside the bracket.
  (message "Hello World!")
  )

;; (server-start)

;; save backups in separate directory
(setq backup-directory-alist `(("." . "~/.emacs.d/.backups")))
;; save auto saves in separate directory
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/.auto-saves" t)))

;; follow symlinks
(setq vc-follow-symlinks t)

;; disable lock files
(setq create-lockfiles nil)

;; show matching parens
(show-paren-mode 1)
(setq show-paren-delay 0)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(package-selected-packages
   (quote
    (## solarized-theme evil-collection evil-visualstar evil-surround use-package evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


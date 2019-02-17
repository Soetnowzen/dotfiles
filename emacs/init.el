(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/scripts")

(require 'init-use-package)
(require 'init-autopair)
(require 'init-elfeed)
(require 'init-evil)
(require 'init-folding)
(require 'init-keybindings)
(require 'init-magit)
(require 'init-org)
(require 'init-projectile)
(require 'init-theme)
(require 'init-whitespace)

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

;; Enable folding
(defun my-hide-all ()
  (interactive)
  (hs-minor-mode)
  (hs-hide-all))
(add-hook 'prog-mode-hook 'my-hide-all)

;; indent with spaces by default
(setq-default indent-tabs-mode nil)
(setq-default tabs-width 4)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(elfeed-feeds
   (quote
    ("http://feeds.feedburner.com/Explosm" "https://www.mmo-champion.com/external.php?do=rss&type=newcontent&sectionid=1&days=120&count=10")))
 '(package-selected-packages
   (quote
    (telephone-line color-theme-solarized elfeed autopair key-chord ## solarized-theme evil-collection evil-visualstar evil-surround use-package evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


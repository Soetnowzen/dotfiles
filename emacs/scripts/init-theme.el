(provide 'init-theme)

;; load main emacs theme
(use-package
  solarized-theme
  :ensure t)
;; (load-theme 'solarized-dark)
(load-theme 'solarized-light)

;; margin stuff
;;(set-frame-parameter nil 'internal-border-width 10)

;; disable gui fluff
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; show line numbers
(global-display-line-numbers-mode t)

;; hide welcome screen
(setq inhibit-startup-screen t)

;; highlight the current line
(global-hl-line-mode +1)

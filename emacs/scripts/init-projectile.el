(provide 'init-projectile)

(use-package projectile
             :ensure t
             :after (ivy)
             :bind-keymap
             ("C-c p" . projectile-command-map)
             ("s-p" . projectile-command-map)
             :init
             ;; Have a default project location
             (when (file-directory-p "~/Documents/Code")
               (setq projectile-project-search-path '("~/Documents/Code")))
             :config
             (add-to-list 'projectile-globally-ignored-directories "*node_modules")
             (setq projectile-enable-caching t)
             (setq projectile-completion-system 'ivy)
             (projectile-mode))

;; Adds extra commands, but might be too much with little gain
;; (use-package counsel-projectile
;;   :config (counsel-projectile-mode))

;; For projectile-ag
(use-package ag
             :ensure t
             :after (projectile))

;; Keybindings
(projectile-mode +1)
;; (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

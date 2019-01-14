(provide 'init-magit)

(use-package magit
             :ensure t
             :config
             (add-hook 'magit-mode-hook (lambda () (display-line-number-mode -1))))

(use-package evil-magit
             :ensure t
             :after magit)

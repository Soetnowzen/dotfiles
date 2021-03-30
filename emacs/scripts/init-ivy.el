(provide 'init-ivy)

(use-package ivy
  :ensure t
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d". ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  ;; slim down ivy display
  ;; (setq ivy-count-format ""
        ;; ivy-display-style nil
        ;; ivy-minibuffer-faces nil
  ;; )
  )

(use-package counsel
  :ensure t
  :after (ivy)
  :config
  (counsel-mode))

;; more intelligent order when using counsel-M-x
(use-package smex
  :ensure t
  :config
  :after (counsel)
  (smex-initialize))

;; Displays informations about commands in ivy.
(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode 1))

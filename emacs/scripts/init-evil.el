(provide 'init-evil)

;; (setq true t)
(setq evil-want-keybinding nil)

(defun my/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
             :ensure t
             :init
             (setq evil-want-C-u-scroll t)
             :hook (evil-mode . my/evil-hook)
             :config
             (evil-mode 1)
             (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
             ;; Use visual line motions even outside of visual-line-mode buffers
             (evil-global-set-key 'motion "j" 'evil-next-visual-line)
             (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
             ;; allow cursor to move past last character - useful in lisp for
             ;; evaluating last sexp
             ;; (setq evil-move-cursor-back t)
             (setq evil-move-beyond-eol t))

(use-package evil-surround
             :ensure t
             :after (evil)
             :config
             (global-evil-surround-mode 1))

(use-package evil-visualstar
             :ensure t
             :after (evil)
             :config
             (global-evil-visualstar-mode))

(use-package evil-collection
  :ensure t
  :after evil
  (evil-collection-init))

(setq evil-fold-list
      '(((hs-minor-mode)
	 :open-all hs-show-all :close-all hs-hide-all :toggle hs-toggle-hiding :open hs-show-block :open-rec nil :close hs-hide-block :close-level my-hs-hide-level)
	((hide-ifdef-mode)
	 :open-all show-ifdefs :close-all hide-ifdefs :toggle nil :open show-ifdef-block :open-rec nil :close hide-ifdef-block)
	((outline-mode outline-minor-mode org-mode markdown-mode)
	 :open-all show-all :close-all
	 #[nil "\300\301!\207"
	       [hide-sublevels 3]
	       2]
	 :toggle outline-toggle-children :open
	 #[nil "\300 \210\301 \207"
	       [show-entry show-children]
	       1]
	 :open-rec show-subtree :close hide-subtree :close-level hide-leaves)
	)
      )

(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))

(defun complete-next (arg)
  (company-complete-common-or-cycle))
(defun complete-previous (arg)
  (company-complete-common-or-cycle -1))

(setq evil-complete-next-func 'complete-next)
(setq evil-complete-previous-func 'complete-previous)

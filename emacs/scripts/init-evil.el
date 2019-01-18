(provide 'init-evil)

;; (setq true t)
(setq evil-want-keybinding nil)

(use-package evil
             :ensure t
             :init
             (setq evil-want-C-u-scroll t)
             :config
             (evil-mode 1)
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
             :ensure t)

(setq evil-fold-list
      '(((hs-minor-mode)
         :open-all hs-show-all :close-all hs-hide-all :toggle hs-toggle-hiding :open hs-show-block :open-rec nil :close hs-hide-block :close-level my-hs-hide-level)
        ((hide-ifdef-mode)
         :open-all show-ifdefs :close-all hide-ifdefs :toggle nil :open show-ifdef-block :open-rec nil :close hide-ifdef-block)
        ((outline-mode outline-minor-mode org-mode markdown-mode)
         :open-all show-all :close-all
         #[nil "\300\301!\207"
               [hide-sublevels 1]
               2]
         :toggle outline-toggle-children :open
         #[nil "\300 \210\301 \207"
               [show-entry show-children]
               1]
         :open-rec show-subtree :close hide-subtree :close-level hide-leaves)
        )
      )
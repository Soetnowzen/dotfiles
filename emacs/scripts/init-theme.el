(provide 'init-theme)

(use-package solarized-theme
  :ensure t
  :config
  ;; (load-theme 'solarized-dark t))
  (load-theme 'solarized-selenized-black t))

;; disable gui fluff
;; (scroll-bar-mode -1)
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)

;; Set up the visible bell
(setq visible-bell t)

;; show line numbers
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook term-mode-hook shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; highlight the current line
(global-hl-line-mode +1)

;; Make emacs transparent
;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;; (defun toggle-transparency ()
;;   (interactive)
;;   (let ((alpha (frame-parameter nil 'alpha)))
;;     (set-frame-parameter
;;      nil 'alpha
;;      (if (eql (cond ((numberp alpha) alpha)
;;                     ((numberp (cdr alpha)) (cadr alpha))))
;;          100)
;;      '(85 . 50) '(100 . 100))))
;; (global-set-key (kbd "C-c t") 'toggle-transparency)

;; ;; Set transparency of emacs
;; (defun transparency (value)
;;   "Sets the transparency of the frame window. 0=transparent/100=opaque"
;;   (interactive "nTransparency Value 0 - 100 opaque:")
;;   (set-frame-parameter (selected-frame) 'alpha value))

(use-package telephone-line
  :ensure t
  :after (evil)
  :config
  ;; setup modeline
  (telephone-line-defsegment telephone-line-file-name-absolute-path-segment ()
			     buffer-file-name)
  (setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-vc-segment
                     telephone-line-erc-modified-channels-segment
                     telephone-line-process-segment))
          (nil    . (;; telephone-line-file-name-absolute-path-segment
		     ;; telephone-line-minor-mode-segment
                     telephone-line-buffer-segment
		     ))
	  ))
  (setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil   . (telephone-line-airline-position-segment))))
  (telephone-line-mode t))

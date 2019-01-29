(provide 'init-theme)

(if (< emacs-major-version 24)
    (progn
      ;; (add-to-list 'load-path "~/.emacs.d/theme/emacs-color-theme-solarized")
      (require 'color-theme-solarized)
      (color-theme-solarized))
  ;; (add-to-list 'custom-theme-load-path "~/.emacs.d/theme/emacs-color-theme-solarized")
  (load-theme 'solarized t)
  )

(add-hook 'after-make-frame-functions
	  (lambda (frame)
	    (let ((mode (if (display-graphic-p frame) 'light 'dark)))
	      (set-frame-parameter frame 'background-mode mode)
	      (set-terminal-parameter frame 'background-mode mode))
	    (enable-theme 'solarized)))

;; disable gui fluff
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; show line numbers
(global-display-line-numbers-mode t)

;; highlight the current line
(global-hl-line-mode +1)

;; setup modeline
(telephone-line-defsegment telephone-line-file-name-absolute-path-segment ()
  buffer-file-name)

(use-package telephone-line
  :ensure t
  :after (evil)
  :config
  (setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-vc-segment
                     telephone-line-process-segment))
          (nil    . (telephone-line-file-name-absolute-path-segment
		     ;; telephone-line-minor-mode-segment
		     ))
	  ))
  (setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil   . (telephone-line-airline-position-segment))))
  
(telephone-line-mode t))

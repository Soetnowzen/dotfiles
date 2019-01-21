(provide 'init-whitespace)

;; Show whitespace characters
(progn
  ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; http://ergoemacs.org/emacs/whitespace-mode.html
  (setq whitespace-style (quote (tabs tab-mark trailing line-tail)))

  ;; Make whitespace-mode and whitespace-newline-mode use “¶” for end of line char and “▷” for tab.
  (setq whitespace-display-mappings
	;; all numbers are unicode codepoint in decimal. e.g. (insert-char 182 1)
	'(
	  (space-mark 32 [183] [46]) ; SPACE 32 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
	  (newline-mark 10 [182 10]) ; LINE FEED,
	  (tab-mark 9 [9655 9] [92 9]) ; tab
	  )))

;; (autoload 'whitespace-mode "whitespace" "Toggle whitespace visualization." t)
;; (autoload 'whitespace-toggle-options "whitespace"
;;   "Toggle local `whitespace-mode` options." t)
;; (autoload 'whitespace-toggle-options "tabs"
;;   "Toggle local `whitespace-mode` options." t)

(use-package whitespace
  :ensure t
  :config
  (global-whitespace-mode)
  ;; (global-whitespace-toggle-options '(tabs trailing lines-tail tab-mark))
  )
;; (global-whitespace-toggle-options '(tabs trailing line-tail tab-mark))

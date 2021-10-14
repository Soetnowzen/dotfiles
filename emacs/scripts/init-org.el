(provide 'init-org)

(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  ;; :hook (org-mode . my/org-mode-setup)
  :config
  (setq org-ellipsis " >")

  ;; add org directory (allows searching for todos and scheduling items)
  (setq org-agenda-files (list "~/org/personal"
                               "~/Documents/notes"))

  ;; Sets org refile levels of headers.
  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; Adding new org keywords
  (setq org-todo-keywords
        '((sequence "TODO(t)" "ON HOLD(h)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELED(c)")
          ;; (sequence "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANCEL(k@)")
          ))

  )

;; Enable easy templates (<q for quote blocks, <s for source blocks)
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; ;; Prevent org-mode from truncating lines by default
;; (setq org-startup-truncated nil)

;; ;; remove automatic indentation of org source blocks
;; (setq org-edit-src-content-indentation 0)

;; add timestamp to completed todos
(setq org-log-done 'time)

;; prevent indentation after sections
(setq org-adapt-indentation nil)

;; (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

;; set org tag column
(setq org-tags-column -80)

;; open links in same window
;(setq org-link-frame-setup (file . find-file))

;; set org templates
(setq org-capture-templates `(("t" "Remente TODO" entry (file+olp "~/org/remente/notes.org" "Tasks" "Active")
         "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a>>\n[%<%Y-%m-%d %a>]\n%a"
         :prepend t) ))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((python . t)
    (emacs-lisp . t)
    (shell . t)))
(defun my-org-confirm-babel-evaluate (lang body)
  (not (member lang '("python" "bash"))))

(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;; Redisplay inlined images after source block execution
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;; (require 'org-drill)

(use-package evil-org
             :ensure t
             :after org
             :config
             (add-hook 'org-mode-hook 'evil-org-mode)
             (add-hook 'evil-org-mode-hook
                       (lambda ()
                         (evil-org-set-key-theme)))
             (setq org-file-apps
                   '(("\\.png\\'" . "feh --scale-down \"%s\"")
                     ("\\.jpg\\'" . "feh --scale-down \"%s\"")
                     (auto-mode . emacs)
                     ("\\.mm\\'" . default)
                     ("\\.x?html?\\'" . default)
                     ("\\.pdf\\'" . default)))
             ;; (setq org-ellipsis "  ")
             (setq org-startup-indented t))

;; (use-package org-bullets
;;              :ensure t
;;              :after org
;;              :config
;;              (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;              (setq org-bullets-bullet-list '("")))

;; (use-package ob-http
;;              :ensure t
;;              :config
;;              (org-babel-do-load-languages
;;                'org-babel-load-languages
;;                '((emacs-lisp . t)
;;                  (lisp . t)
;;                  (http . t))))

;; (use-package org-pomodoro
;;              :ensure t
;;              :commands (org-pomodoro)
;;              :config
;;              (setq alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil)))))

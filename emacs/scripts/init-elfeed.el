(provide 'init-elfeed)

(use-package elfeed
  :ensure t
  :config
  (global-set-key (kbd "C-x w") 'elfeed)
  (elfeed-add-feed "https://www.mmo-champion.com/external.php?do=rss&type=newcontent&sectionid=1&days=120&count=10")
  (elfeed-add-feed "http://feeds.feedburner.com/Explosm"))
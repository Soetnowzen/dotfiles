(provide 'init-elfeed)

(use-package elfeed
  :ensure t
  :config
  (global-set-key (kbd "C-x w") 'elfeed)
  (elfeed-add-feed "https://www.mmo-champion.com/external.php?do=rss&type=newcontent&sectionid=1&days=120&count=10")
  (elfeed-add-feed "http://feeds.feedburner.com/Explosm")
  (elfeed-add-feed "http://www.ilikeradio.se/podcasts/nordigt/feed")
  (elfeed-add-feed "https://darklegacycomics.com/feed.xml")
  )

;; RET: view selected entry in a buffer
;;   b: open selected entries in your browser (browse-url)
;;   y: copy selected entries URL to the clipboard
;;   r: mark selected entries as read
;;   u: mark selected entries as unread
;;   +: add a specific tag to selected entries
;;   -: remove a specific tag from selected entries


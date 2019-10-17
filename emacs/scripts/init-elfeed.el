(provide 'init-elfeed)

(use-package elfeed
  :ensure t
  :config
  (global-set-key (kbd "C-x w") 'elfeed)
  (setq elfeed-feeds '(("http://darklegacycomics.com/feed.xml" comics)
                       ("http://feed.khz.se/nordigt" podcasts)
                       ("http://feeds.feedburner.com/Explosm" comics)
                       ("http://swedroid.se/feed" news)
                       ("http://www.ilikeradio.se/podcasts/nordigt/feed" podcasts)
                       ("http://www.mmo-champion.com/external.php?do=rss&type=newcontent&sectionid=1&days=120&count=10" news)
                       ("https://www.wowhead.com/news/rss/all" news)
                       ))
  (elfeed-search-set-filter "@6-months-ago")
  )

;; RET: view selected entry in a buffer
;;   b: open selected entries in your browser (browse-url)
;;   y: copy selected entries URL to the clipboard
;;   r: mark selected entries as read
;;   u: mark selected entries as unread
;;   +: add a specific tag to selected entries
;;   -: remove a specific tag from selected entries


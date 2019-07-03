(provide 'init-elfeed)

(use-package elfeed
  :ensure t
  :config
  (global-set-key (kbd "C-x w") 'elfeed)
  ;; (elfeed-add-feed "http://feeds.feedburner.com/Explosm")
  ;; (elfeed-add-feed "http://www.ilikeradio.se/podcasts/nordigt/feed")
  ;; (elfeed-add-feed "https://darklegacycomics.com/feed.xml")
  ;; (elfeed-add-feed "https://feed.khz.se/nordigt")
  ;; (elfeed-add-feed "https://swedroid.se/feed")
  ;; (elfeed-add-feed "https://www.mmo-champion.com/external.php?do=rss&type=newcontent&sectionid=1&days=120&count=10")
  (setq elfeed-feeds '(("https://www.mmo-champion.com/external.php?do=rss&type=newcontent&sectionid=1&days=120&count=10" news)
                       ("http://feeds.feedburner.com/Explosm" comics)
                       ("https://swedroid.se/feed" news)
                       ("https://feed.khz.se/nordigt" podcasts)
                       ("http://www.ilikeradio.se/podcasts/nordigt/feed" podcasts)
                       ("https://darklegacycomics.com/feed.xml" comics)
                       ("http://feeds.feedburner.com/blogspot/hsDu" android) ;; Android Developers Blog
                       ("http://oremacs.com/atom.xml" emacs)                 ;; (or emacs)
                       ("http://pragmaticemacs.com/feed/" emacs)             ;; Pragmatic Emacs
                       ("http://planet.emacsen.org/atom.xml" emacs)          ;; Planet Emacsen
                       ("http://feeds.bbci.co.uk/news/science_and_environment/rss.xml" news) ;; BBC News - Science & Environment
                       ("https://www.theverge.com/rss/index.xml" news) ;; The Verge
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


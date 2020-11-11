(use-package! org
  (setq! org-log-done t)
  (setq! org-todo-keywords '((sequence "TODO" "DONE")
                            (sequence "BUG" "WISHLIST" "|" "FIXED" "WONTFIX" "NOTABUG")
                            (sequence "PENDING" "REPEAT" "|" "FAILED" "SUCCESS")))
  (put 'org-beginning-of-line 'CUA 'move)
  (put 'org-end-of-line 'CUA 'move))

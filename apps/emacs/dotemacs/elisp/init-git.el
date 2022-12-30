(use-package magit
  :bind ("C-c G" . magit))

;; (use-package git-gutter
;;   :init
;;   (global-git-gutter-mode t)
;;   (setq git-gutter:hide-gutter t)
;;   (add-to-list 'git-gutter:update-hooks 'focus-in-hook)
;;   (add-to-list 'git-gutter:update-commands 'other-window))

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  ;; (diff-hl-flydiff-mode)
  :hook
  (diff-hl-mode-on . (lambda ()
		       (unless (window-system)
			 (diff-hl-margin-local-mode))))
  ('magit-pre-refresh . diff-hl-magit-pre-refresh)
  ('magit-post-refresh . diff-hl-magit-post-refresh))

;; load diff mode on cli commit
(add-to-list 'auto-mode-alist '("/COMMIT_EDITMSG\\'" . diff-mode))

(provide 'init-git)

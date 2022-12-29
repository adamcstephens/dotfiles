(use-package magit
  :bind ("C-c G" . magit))

(use-package git-gutter
  :init
  (global-git-gutter-mode t)
  (setq git-gutter:hide-gutter t)
  (add-to-list 'git-gutter:update-hooks 'focus-in-hook)
  (add-to-list 'git-gutter:update-commands 'other-window))

;; load diff mode on cli commit
(add-to-list 'auto-mode-alist '("/COMMIT_EDITMSG\\'" . diff-mode))

(provide 'init-git)

(use-package magit
  :bind ("C-c G" . magit))

(use-package git-gutter
  :init
  (global-git-gutter-mode t))

(provide 'init-git)

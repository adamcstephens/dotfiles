(use-package projectile
  :init (projectile-mode +1)
  :config (progn (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
		 (setq projectile-auto-discover t)
		 (setq projectile-project-search-path '(("~/projects/" . 1) ("~/git/" . 1) ("~/.dotfiles" . 0)))))

(use-package direnv
  :config
  (direnv-mode))

(provide 'init-project)

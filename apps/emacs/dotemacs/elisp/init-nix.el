(use-package nix-mode
  :mode "\\.nix\\'"
  :config
  (cl-pushnew '("Nix" alejandra) format-all-default-formatters)
  )

(provide 'init-nix)

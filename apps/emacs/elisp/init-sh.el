(use-package bash-ts-mode :mode "\\.sh\\'")

(use-package fish-mode :mode ("\\.fish\\'" . fish-mode))

(use-package nushell-ts-mode :mode "\\.nu\\'")

(use-package sh-script :init (setq sh-basic-offset 2))

(provide 'init-sh)

(use-package fish-mode :mode ("\\.fish\\'" . fish-mode))

(use-package
  sh-script
  :straight (:type built-in)
  :config (setq sh-basic-offset 2))

(provide 'init-sh)

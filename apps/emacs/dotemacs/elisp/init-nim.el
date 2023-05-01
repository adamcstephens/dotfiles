(use-package
  nim-mode
  :straight nil
  :mode "\\.nim\\'"
  :config (cl-pushnew '("Nim" nimpretty) format-all-default-formatters))

(provide 'init-nim)

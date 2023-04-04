(use-package
  nim-mode
  :mode "\\.nim\\'"
  :config (cl-pushnew '("Nim" nimpretty) format-all-default-formatters))

(provide 'init-nim)

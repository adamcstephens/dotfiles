(use-package haskell-mode
  :mode "\\.hs\\'"
  :init
  (cl-pushnew '("Haskell" ormolu) format-all-default-formatters))

(provide 'init-haskell)

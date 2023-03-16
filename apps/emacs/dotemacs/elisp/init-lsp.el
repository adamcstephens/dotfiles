(use-package
  eglot
  :straight (:type built-in)
  :defer t
  :ensure nil
  :commands (eglot eglot-ensure)
  :hook ((nix-mode . eglot-ensure))
  :config (add-to-list 'eglot-server-programs '((nix-mode) "nil")))

(provide 'init-lsp)

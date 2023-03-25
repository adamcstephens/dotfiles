(defun dot/eglot-format-on-save ()
  (add-hook 'before-save-hook 'eglot-format-buffer -10 t))

(use-package
  eglot
  :straight (:type built-in)
  :defer t
  :commands (eglot eglot-ensure)
  :hook
  ((nix-mode . eglot-ensure)
    (nix-mode . dot/eglot-format-on-save)
    (haskell-mode . eglot-ensure)
    (haskell-mode . dot/eglot-format-on-save))
  :config
  (add-to-list 'eglot-server-programs '((nix-mode) "nil"))
  (setq-default eglot-workspace-configuration
    '
    ((haskell (formattingProvider . "ormolu"))
      (nil (formatting (command . ["alejandra"]))))))

(use-package
  treesit-auto
  :config
  (setq treesit-auto-install nil)
  (global-treesit-auto-mode))

(provide 'init-lsp)

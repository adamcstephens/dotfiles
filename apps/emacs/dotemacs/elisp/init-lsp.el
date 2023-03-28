(defun dot/eglot-format-on-save ()
  (eglot-ensure)
  (add-hook 'before-save-hook 'eglot-format-buffer -10 t))

(use-package
  eldoc-box
  :commands (eldoc-box-hover-mode eldoc-box-hover-at-point-mode)
  :custom (eldoc-box-clear-with-C-g t))

(use-package
  eglot
  :straight (:type built-in)
  :defer t
  :commands (eglot eglot-ensure)
  :hook
  ((nix-mode . dot/eglot-format-on-save)
    (go-ts-mode . dot/eglot-format-on-save)
    (haskell-mode . dot/eglot-format-on-save))
  :bind
  (:map
    eglot-diagnostics-map
    ("<mouse-3>" . eglot-code-actions-at-mouse))
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

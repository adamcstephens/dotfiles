(defun dot/eglot-mode-setup ()
  (eglot-ensure)
  (add-hook 'before-save-hook 'eglot-format-buffer -10 t))

(defun dot/eglot-goimports ()
  (eglot-code-actions nil nil "source.organizeImports" t))

(use-package eldoc-box :custom (eldoc-box-clear-with-C-g t))

(use-package
  eglot
  :commands (eglot eglot-ensure)
  :hook
  ((bash-ts-mode . eglot-ensure)
    (clojure-mode . dot/eglot-mode-setup)
    (elixir-ts-mode . dot/eglot-mode-setup)
    (go-ts-mode . dot/eglot-mode-setup)
    (go-ts-mode
      .
      (lambda () (add-hook 'before-save-hook 'dot/eglot-goimports)))
    (haskell-mode . dot/eglot-mode-setup)
    (nix-mode . eglot-ensure)
    (nim-mode . eglot-ensure)
    (tsx-ts-mode . dot/eglot-mode-setup)
    (typescript-mode . dot/eglot-mode-setup)
    (typescript-ts-mode . dot/eglot-mode-setup))
  :bind
  (:map
    eglot-diagnostics-map
    ("<mouse-3>" . eglot-code-actions-at-mouse))
  :config
  (add-to-list 'eglot-server-programs '((elixir-ts-mode) "elixir-ls"))
  (add-to-list 'eglot-server-programs '((nix-mode) "nil"))
  (add-to-list 'eglot-server-programs '((nim-mode) "nimlsp"))
  (add-to-list
    'eglot-server-programs
    '
    ((js-ts-mode tsx-ts-mode typescript-ts-mode)
      .
      dot/ecma-server-program))
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

(defun dot/eglot-mode-setup ()
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
  ((go-ts-mode . dot/eglot-mode-setup)
    (haskell-mode . dot/eglot-mode-setup)
    (nix-mode . dot/eglot-mode-setup)
    (tsx-ts-mode . dot/eglot-mode-setup)
    (typescript-mode . dot/eglot-mode-setup)
    (typescript-ts-mode . dot/eglot-mode-setup))
  :bind
  (:map
    eglot-diagnostics-map
    ("<mouse-3>" . eglot-code-actions-at-mouse))
  :config
  (add-to-list 'eglot-server-programs '((nix-mode) "nil"))
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

(use-package bash-ts-mode :straight (:type built-in) :mode "\\.sh\\'")

(use-package fish-mode :mode ("\\.fish\\'" . fish-mode))

(use-package
  nushell-mode
  :straight (:type git :host github :repo "azzamsa/emacs-nushell")
  :mode "\\.nu\\'")

(use-package
  sh-script
  :straight (:type built-in)
  :config (setq sh-basic-offset 2))

(provide 'init-sh)

(use-package bash-ts-mode :mode "\\.sh\\'")

(use-package fish-mode :mode ("\\.fish\\'" . fish-mode))

(use-package
  nushell-mode
  :straight (:type git :host github :repo "azzamsa/emacs-nushell")
  :mode "\\.nu\\'")

(use-package sh-script :init (setq sh-basic-offset 2))

(provide 'init-sh)

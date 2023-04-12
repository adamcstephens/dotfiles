(use-package
  kbd-mode
  :straight (:type git :host github :repo "kmonad/kbd-mode")
  :mode "\\.kbd\\'"
  :hook (kbd-mode . (lambda () (elisp-autofmt-mode -1))))

(provide 'init-kmonad)

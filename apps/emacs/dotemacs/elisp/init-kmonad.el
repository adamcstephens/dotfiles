(use-package kbd-mode
  :straight (kbd-mode :type: git :host github :repo "kmonad/kbd-mode")
  :mode "\\.kbd\\'"
  :commands kbd-mode)

(provide 'init-kmonad)

(use-package editorconfig
  :diminish
  :ensure
  :config
  (editorconfig-mode 1))

(use-package whitespace
  :ensure nil
  :init
  (global-whitespace-mode)
  (setq whitespace-style '(face tabs trailing))
  )

(provide 'init-editor)

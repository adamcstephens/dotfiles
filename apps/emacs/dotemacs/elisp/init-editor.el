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

;; allow for running commands without selecting a region
(use-package whole-line-or-region
  :init
  (whole-line-or-region-global-mode)
  (global-unset-key (kbd "C-/"))
  :bind
  ("C-_" . whole-line-or-region-comment-dwim)
  ("C-/" . whole-line-or-region-comment-dwim))

;; better undo support
(use-package undo-fu
  :init
  (global-set-key (kbd "C-r") 'undo-fu-only-redo))

;; store undo across sessions
(use-package undo-fu-session
  :init
  (global-undo-fu-session-mode))

;; moving lines up and down can be handy
(use-package move-text
  :init
  (move-text-default-bindings))

;; pair handling
(use-package smartparens
  :init
  (smartparens-mode t)
  (smartparens-strict-mode t))



(provide 'init-editor)

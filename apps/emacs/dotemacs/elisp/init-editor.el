(use-package
  editorconfig
  :diminish
  :ensure
  :config (editorconfig-mode 1))

(use-package
  whitespace
  :diminish global-whitespace-mode
  :ensure nil
  :init
  (global-whitespace-mode)
  (setq whitespace-style '(face tabs trailing)))

;; allow for running commands without selecting a region
(use-package
  whole-line-or-region
  :diminish whole-line-or-region-local-mode
  :init
  (whole-line-or-region-global-mode)
  (global-unset-key (kbd "C-/"))
  :bind
  ("C-_" . whole-line-or-region-comment-dwim)
  ("C-/" . whole-line-or-region-comment-dwim))

;; better undo support
(use-package
  undo-fu
  :init (global-set-key (kbd "C-r") 'undo-fu-only-redo))

;; store undo across sessions
(use-package undo-fu-session :init (global-undo-fu-session-mode))

;; moving lines up and down can be handy
(use-package move-text :init (move-text-default-bindings))

;; better dired
(use-package
  dirvish
  :init (dirvish-override-dired-mode)
  :config
  (setq dired-mouse-drag-files t)
  (setq mouse-drag-and-drop-region-cross-program t))

(use-package
  flyspell
  :custom
  (ispell-program-name "aspell")
  (aspell-dictionary "en_US")
  :hook (org-mode . flyspell-mode))

(use-package
  flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

;; support clipboards in terminals
(use-package clipetty :init (global-clipetty-mode 1))

(provide 'init-editor)

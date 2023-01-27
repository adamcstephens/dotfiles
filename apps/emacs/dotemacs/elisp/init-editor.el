(use-package editorconfig :ensure :config (editorconfig-mode 1))

(use-package
  whitespace
  :ensure nil
  :init
  (global-whitespace-mode)
  (setq whitespace-style '(face tabs trailing))
  (add-hook 'before-save-hook 'whitespace-cleanup))

;; allow for running commands without selecting a region
(use-package
  whole-line-or-region
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
(use-package
  move-dup
  :bind
  (("M-<up>" . move-dup-move-lines-up)
    ("M-S-<up>" . move-dup-duplicate-up)
    ("M-<down>" . move-dup-move-lines-down)
    ("M-S-<down>" . move-dup-duplicate-down)))

;; better dired
(use-package
  dirvish
  :init (dirvish-override-dired-mode)
  :config
  ;; Don't worry, Dirvish is still performant even if you enable all these attributes
  (setq dirvish-attributes
    '
    (vc-state subtree-state
      all-the-icons
      collapse
      git-msg
      file-time
      file-size))
  (setq dired-mouse-drag-files t)
  (setq mouse-drag-and-drop-region-cross-program t)
  :bind
  (("C-c f" . dirvish-fd)
    :map dirvish-mode-map ; Dirvish inherits `dired-mode-map'
    ("a" . dirvish-quick-access)
    ("f" . dirvish-file-info-menu)
    ("y" . dirvish-yank-menu)
    ("N" . dirvish-narrow)
    ("^" . dirvish-history-last)
    ("h" . dirvish-history-jump) ; remapped `describe-mode'
    ("s" . dirvish-quicksort) ; remapped `dired-sort-toggle-or-edit'
    ("v" . dirvish-vc-menu) ; remapped `dired-view-file'
    ("TAB" . dirvish-subtree-toggle)
    ("M-f" . dirvish-history-go-forward)
    ("M-b" . dirvish-history-go-backward)
    ("M-l" . dirvish-ls-switches-menu)
    ("M-m" . dirvish-mark-menu)
    ("M-t" . dirvish-layout-toggle)
    ("M-s" . dirvish-setup-menu)
    ("M-e" . dirvish-emerge-menu)
    ("M-j" . dirvish-fd-jump)))

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

(use-package key-chord :commands (key-chord-mode))

(use-package
  key-seq
  :after (key-chord meow)
  :init
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.05)
  (key-seq-define meow-insert-state-keymap "jj" 'meow-insert-exit))

(use-package
  persistent-scratch
  :init (persistent-scratch-autosave-mode 1))

(provide 'init-editor)

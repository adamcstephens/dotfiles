(defun dot/open-in-finder ()
  (interactive)
  (shell-command "open -R ."))

(defun dot/top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))
(global-set-key (kbd "C-^") 'dot/top-join-line)

(use-package
  avy
  :init
  (avy-setup-default)
  (global-set-key (kbd "C-c C-j") 'avy-resume))

(use-package editorconfig :ensure :config (editorconfig-mode 1))

(use-package expand-region :bind ("C-=" . er/expand-region))

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
  :init (whole-line-or-region-global-mode))

;; better undo support
(use-package
  undo-fu
  :bind (("C-x u" . undo-fu-only-undo) ("C-r" . undo-fu-only-redo)))

;; store undo across sessions
(use-package undo-fu-session :init (undo-fu-session-global-mode))

(use-package vundo)

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
  persistent-scratch
  :init (persistent-scratch-autosave-mode 1))

(use-package
  substitute
  :straight (substitute :type git :host sourcehut :repo "protesilaos/substitute")
  :init (setq substitute-highlight t)
  :bind ("M-# b" . substitute-target-in-buffer))

(use-package
  olivetti
  :custom
  (olivetti-margin-width 5)
  (olivetti-style nil))

(provide 'init-editor)

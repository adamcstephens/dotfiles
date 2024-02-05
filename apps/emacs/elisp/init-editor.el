(defun dot/auto-create-missing-dirs ()
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(defun dot/open-in-finder ()
  (interactive)
  (shell-command "open -R ."))

(add-to-list
 'find-file-not-found-functions
 #'dot/auto-create-missing-dirs)

(use-package
  avy
  :init (avy-setup-default)
  :bind (("s-g" . avy-goto-line) ("C-c C-j" . avy-resume)))

(use-package clipetty :init (global-clipetty-mode 1))

(use-package
  dirvish
  :init
  (dirvish-override-dired-mode)
  (setq dirvish-attributes
	'
	(vc-state subtree-state
		  all-the-icons
		  collapse
		  file-time
		  file-size))
  (setq dired-mouse-drag-files t)
  (setq mouse-drag-and-drop-region-cross-program t)
  :bind
  (:map
   dirvish-mode-map ; Dirvish inherits `dired-mode-map'
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

(use-package editorconfig :init (editorconfig-mode 1))

(use-package expand-region :bind ("C-=" . er/expand-region))

(use-package
  flyspell
  :custom
  (ispell-program-name "aspell")
  (aspell-dictionary "en_US")
  :hook (text-mode . flyspell-mode))

(use-package
  flyspell-correct
  :after flyspell
  :bind
  (:map
   flyspell-mode-map
   ("C-;" . flyspell-correct-wrapper)))

(use-package
  kkp
  :config
  ;; (setq kkp-alt-modifier 'alt) ;; use this if you want to map the Alt keyboard modifier to Alt in Emacs (and not to Meta)
  (global-kkp-mode +1))

(use-package
  move-dup
  :bind
  (("M-<up>" . move-dup-move-lines-up)
   ("M-S-<up>" . move-dup-duplicate-up)
   ("M-<down>" . move-dup-move-lines-down)
   ("M-S-<down>" . move-dup-duplicate-down)))

(use-package
  mwim
  :init
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
   ("C-e" . mwim-end-of-code-or-line)
   ("<home>" . mwim-beginning-of-line-or-code)
   ("<end>" . mwim-end-of-line-or-code)))

(use-package
  substitute
  :config (setq substitute-highlight t)
  :bind ("M-# b" . substitute-target-in-buffer))

(use-package
  undo-fu
  :bind
  (("C-x u" . undo-fu-only-undo)
   ("C-r" . undo-fu-only-redo)
   ("<undo>" . undo-fu-only-undo)
   ("C-_" . undo-fu-only-undo)
   ("C-/" . undo-fu-only-undo)
   ("C-z" . undo-fu-only-undo)
   ("C-S-z" . undo-fu-only-redo)))

(use-package undo-fu-session :init (undo-fu-session-global-mode))

(use-package vundo)

(use-package
  whitespace
  :config (setq whitespace-style '(face tabs trailing))
  :init (global-whitespace-mode)
  :hook (before-save . whitespace-cleanup))

(provide 'init-editor)

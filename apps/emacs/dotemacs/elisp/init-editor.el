(defun dot/auto-create-missing-dirs ()
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(defun dot/open-in-finder ()
  (interactive)
  (shell-command "open -R ."))

(defun dot/top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))

(global-set-key (kbd "C-^") 'dot/top-join-line)

(add-to-list
  'find-file-not-found-functions
  #'dot/auto-create-missing-dirs)

(use-package
  avy
  :init
  (avy-setup-default)
  (global-set-key (kbd "C-c C-j") 'avy-resume))

(use-package clipetty :init (global-clipetty-mode 1))

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

(use-package editorconfig :ensure :config (editorconfig-mode 1))

(use-package
  edwina
  :disabled
  :config
  (setq display-buffer-base-action '(display-buffer-below-selected))
  (edwina-setup-dwm-keys)
  (edwina-mode 1))

(use-package expand-region :bind ("C-=" . er/expand-region))

(use-package
  flyspell
  :custom
  (ispell-program-name "aspell")
  (aspell-dictionary "en_US")
  :hook (org-mode . flyspell-mode))

(use-package
  flyspell-correct
  :after flyspell
  :bind
  (:map
    flyspell-mode-map
    ("C-;" . flyspell-correct-wrapper)
    ("[down-mouse-3]" . flyspell-correct-word)))

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
  (require 'better-bw-word)
  (global-unset-key (kbd "C-a"))
  (global-unset-key (kbd "C-e"))
  (global-unset-key (kbd "<home>"))
  (global-unset-key (kbd "<end>"))
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
    ("C-e" . mwim-end-of-code-or-line)
    ("<home>" . mwim-beginning-of-line-or-code)
    ("<end>" . mwim-end-of-line-or-code)
    ("C-<left>" . nate/backward-word)
    ("M-<left>" . nate/backward-word)
    ("C-<right>" . nate/forward-word)
    ("M-<right>" . nate/forward-word)
    ("C-<backspace>" . nate/backward-kill-word)))

(use-package
  olivetti
  :custom
  (olivetti-margin-width 5)
  (olivetti-style nil))

(use-package
  persistent-scratch
  :init (persistent-scratch-autosave-mode 1))

(use-package
  run-command
  :bind ("C-c c" . run-command)
  :config
  (defun dot/run-command-recipes ()
    (list
      (list
        :command-name "nix-flake-update"
        :command-line "nix flake update"
        :display "nix flake update")
      (list
        :command-name "bb-repl"
        :command-line "bb --nrepl-server"
        :display "Babashka REPL"
        :hook
        (lambda ()
          (sleep-for 0.25)
          (cider-connect-clj (list :host "localhost" :port 1667))))))
  (add-to-list 'run-command-recipes 'dot/run-command-recipes)
  :custom (run-command-default-runner 'run-command-runner-vterm))

(use-package
  substitute
  :straight
  (substitute
    :type git
    :host sourcehut
    :repo "protesilaos/substitute")
  :init (setq substitute-highlight t)
  :bind ("M-# b" . substitute-target-in-buffer))

(use-package transpose-frame :commands transpose-frame)

(use-package
  undo-fu
  :bind
  (("C-x u" . undo-fu-only-undo)
    ("C-r" . undo-fu-only-redo)
    ("<undo>" . undo-fu-only-undo)
    ("C-_" . undo-fu-only-undo)
    ("C-/" . undo-fu-only-undo)))

(use-package undo-fu-session :init (undo-fu-session-global-mode))

(use-package vundo)

(use-package
  whitespace
  :ensure nil
  :init
  (global-whitespace-mode)
  (setq whitespace-style '(face tabs trailing))
  (add-hook 'before-save-hook 'whitespace-cleanup))

(use-package
  whole-line-or-region
  :init (whole-line-or-region-global-mode))

(provide 'init-editor)

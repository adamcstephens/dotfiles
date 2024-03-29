(use-package
  emacs
  :ensure nil
  :init
  ;; Don't generate backups or lockfiles. While auto-save maintains a copy so long
  ;; as a buffer is unsaved, backups create copies once, when the file is first
  ;; written, and never again until it is killed and reopened. This is better
  ;; suited to version control, and I don't want world-readable copies of
  ;; potentially sensitive material floating around our filesystem.
  (setq
    create-lockfiles nil
    make-backup-files nil
    ;; But in case the user does enable it, some sensible defaults:
    version-control t ; number each backup file
    backup-by-copying t ; instead of renaming current file (clobbers links)
    delete-old-versions t ; clean up after itself
    kept-old-versions 5
    kept-new-versions 5
    backup-directory-alist (list (cons "." (concat user-emacs-directory "backup/")))
    tramp-backup-directory-alist backup-directory-alist)

  ;; escape is too much muscle memory for me
  (global-set-key [escape] 'keyboard-escape-quit)

  ;; keep what's already in the clipboard before overwriting the kill ring
  (setq save-interprogram-paste-before-kill t)

  ;; But turn on auto-save, so we have a fallback in case of crashes or lost data.
  ;; Use `recover-file' or `recover-session' to recover them.
  (setq
    auto-save-default t
    ;; Don't auto-disable auto-save after deleting big chunks. This defeats
    ;; the purpose of a failsafe. This adds the risk of losing the data we
    ;; just deleted, but I believe that's VCS's jurisdiction, not ours.
    auto-save-include-big-deletions t
    ;; Keep it out of `doom-emacs-dir' or the local directory.
    auto-save-list-file-prefix (concat user-emacs-directory "autosave/")
    tramp-auto-save-directory (concat user-emacs-directory "tramp-autosave/")
    auto-save-file-name-transforms
    (list
      (list
        "\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
        ;; Prefix tramp autosaves to prevent conflicts with local ones
        (concat auto-save-list-file-prefix "tramp-\\2") t)
      (list ".*" auto-save-list-file-prefix t)))

  ;; enable mouse mode for terminal
  (unless (display-graphic-p)
    (xterm-mouse-mode 1))

  ;; copy on mouse highlight
  (setq mouse-drag-copy-region 'non-empty)

  ;; don't jump when scrolling off screen
  (setq scroll-conservatively 101)
  ;; keep at least this many lines while scrolling
  (setq scroll-margin 4)

  ;; enable line numbers
  ;; (global-display-line-numbers-mode)

  ;; store recent files
  (recentf-mode 1)
  (setq recentf-max-menu-items 25)
  (setq recentf-max-saved-items 25)

  ;;disable splash screen and startup message
  (setq inhibit-startup-message t)
  (setq initial-scratch-message nil)

  ;; enable file/dired reading from disk
  (setq global-auto-revert-non-file-buffers t)
  (global-auto-revert-mode)

  ;; try and quiet errors i can't/won't fix
  (setq native-comp-async-report-warnings-errors 'silent)

  ;; store customizations in non init.el
  (setq custom-file (concat user-emacs-directory "custom.el"))
  (load custom-file)

  ;; wrap isearch
  (setq isearch-wrap-pause 'no)

  ;; this is recommended to be disabled if in ssh_config
  (setq tramp-use-ssh-controlmaster-options nil)

  ;; focus help
  (setq help-window-select t)
  ;; focus all new windows
  (defadvice split-window (after split-window-after activate)
    (other-window 1))

  ;; follow symlinks in vcs without prompting
  (setq vc-follow-symlinks t)

  ;; enable autopairs
  (electric-pair-mode t)

  ;; replace region with yank
  (delete-selection-mode 1)

  ;; screens are bigger, but we still want code to be reasonable in length
  (set-fill-column 120)

  ;;
  ;; vertico recommendations
  ;;
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons
      (format "[CRM%s] %s"
        (replace-regexp-in-string
          "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'"
          ""
          crm-separator)
        (car args))
      (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
    '(read-only t cursor-intangible t face minibuffer-prompt))

  ;; allow running more minibuffers from a first
  (setq enable-recursive-minibuffers t)

  ;; Use `consult-completion-in-region' if Vertico is enabled.
  ;; Otherwise use the default `completion--in-region' function.
  (setq completion-in-region-function
    (lambda (&rest args)
      (apply
        (if vertico-mode
          #'consult-completion-in-region
          #'completion--in-region)
        args)))

  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  (setq tab-always-indent 'complete)

  (setq display-line-numbers-grow-only t)

  ;;
  ;; keybindings to builtin functions
  ;;
  (global-set-key (kbd "C-c f s") 'save-buffer)
  ;; describe function is better than the faq
  (global-set-key (kbd "C-h C-f") 'describe-function)
  (global-set-key (kbd "C-h C-s") 'describe-symbol)

  (global-set-key (kbd "M-p") 'mark-paragraph)

  (define-key minibuffer-local-map (kbd "C-j") 'next-line)
  (define-key minibuffer-local-map (kbd "C-k") 'previous-line)
  (define-key minibuffer-local-map (kbd "C-u") 'kill-whole-line)
  (define-key
    minibuffer-local-map
    (kbd "C-<backspace>")
    'backward-kill-word)

  (global-set-key (kbd "<mouse-8>") 'previous-buffer)
  (global-set-key (kbd "<mouse-9>") 'next-buffer)

  ;; scratch buffer
  (global-set-key (kbd "C-c x") 'scratch-buffer)

  (global-set-key (kbd "C-x B") 'switch-to-buffer)

  :bind (("s-t" . tab-new) ("s-j" . windmove-down))

  :hook
  ((minibuffer-setup . cursor-intangible-mode)
    ;; make scripts executable
    (after-save . executable-make-buffer-file-executable-if-script-p)
    ;; enable hl-line but not globally since it's flaky in vterm
    (prog-mode . hl-line-mode)
    (text-mode . hl-line-mode)
    (prog-mode . (lambda () (display-line-numbers-mode t)))))

(provide 'init-emacs)

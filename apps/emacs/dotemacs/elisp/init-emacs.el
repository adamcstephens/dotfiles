(use-package emacs
  :ensure nil
  :init
  ;; Don't generate backups or lockfiles. While auto-save maintains a copy so long
  ;; as a buffer is unsaved, backups create copies once, when the file is first
  ;; written, and never again until it is killed and reopened. This is better
  ;; suited to version control, and I don't want world-readable copies of
  ;; potentially sensitive material floating around our filesystem.
  (setq create-lockfiles nil
	make-backup-files nil
	;; But in case the user does enable it, some sensible defaults:
	version-control t     ; number each backup file
	backup-by-copying t   ; instead of renaming current file (clobbers links)
	delete-old-versions t ; clean up after itself
	kept-old-versions 5
	kept-new-versions 5
	backup-directory-alist (list (cons "." (concat user-emacs-directory "backup/")))
	tramp-backup-directory-alist backup-directory-alist)

  ;; But turn on auto-save, so we have a fallback in case of crashes or lost data.
  ;; Use `recover-file' or `recover-session' to recover them.
  (setq auto-save-default t
	;; Don't auto-disable auto-save after deleting big chunks. This defeats
	;; the purpose of a failsafe. This adds the risk of losing the data we
	;; just deleted, but I believe that's VCS's jurisdiction, not ours.
	auto-save-include-big-deletions t
	;; Keep it out of `doom-emacs-dir' or the local directory.
	auto-save-list-file-prefix (concat user-emacs-directory "autosave/")
	tramp-auto-save-directory  (concat user-emacs-directory "tramp-autosave/")
	auto-save-file-name-transforms
	(list (list "\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
                    ;; Prefix tramp autosaves to prevent conflicts with local ones
                    (concat auto-save-list-file-prefix "tramp-\\2") t)
              (list ".*" auto-save-list-file-prefix t)))

  ;; increase GC theshold. this can apparently be bad, but good?
  (setq gc-cons-threshold (* 1024 1024 20))

  ;; disable menu, tool, and bars
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  ;; enable mouse mode for terminal
  (unless (display-graphic-p)
    (xterm-mouse-mode 1))

  ;; enable line numbers
  (global-display-line-numbers-mode)

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

  ;;
  ;; keybindings to builtin functions
  ;;
  (global-set-key (kbd "C-c f s") 'save-buffer)
  ;; describe function is better than the faq
  (global-set-key "\C-h\ \C-f" 'describe-function)

  (define-key minibuffer-local-map (kbd "C-j") 'next-line)
  (define-key minibuffer-local-map (kbd "C-k") 'previous-line)
  (define-key minibuffer-local-map (kbd "C-u") 'kill-whole-line)
  (define-key minibuffer-local-map (kbd "C-<backspace>") 'backward-kill-word)

  )

(provide 'init-emacs)

(setq backup-directory-alist '(("" . "~/.cache/emacs/backup")))

(setq version-control t ;; Use version numbers for backups.
      kept-new-versions 10 ;; Number of newest versions to keep.
      kept-old-versions 0 ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t) ;; Copy all files, don't rename them.

(setq gc-cons-threshold (* 1024 1024 20))

;; disable menu and tool bars
(menu-bar-mode -1)
(tool-bar-mode -1)

;; enable mouse mode for terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; enable line numbers
(global-display-line-numbers-mode)

(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;;disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(global-set-key "\C-h\ \C-f" 'describe-function)

(provide 'init-emacs)

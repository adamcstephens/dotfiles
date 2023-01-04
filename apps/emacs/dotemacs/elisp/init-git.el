(use-package magit
  :bind ("C-c G" . magit)
  :init
  (setq magit-save-repository-buffers nil))

(use-package git-gutter
  :diminish
  :init
  (global-git-gutter-mode t)
  (setq git-gutter:hide-gutter t)
  (add-to-list 'git-gutter:update-hooks 'focus-in-hook)
  (add-to-list 'git-gutter:update-commands 'other-window))

(use-package diff-hl
  :disabled
  :init
  (global-diff-hl-mode)
  ;; (diff-hl-flydiff-mode)
  :hook
  (diff-hl-mode-on . (lambda ()
		       (unless (window-system)
			 (diff-hl-margin-local-mode))))
  ('magit-pre-refresh . diff-hl-magit-pre-refresh)
  ('magit-post-refresh . diff-hl-magit-post-refresh))

(use-package git-auto-commit-mode)

;; load diff mode on cli commit
(add-to-list 'auto-mode-alist '("/COMMIT_EDITMSG\\'" . diff-mode))

;; tweak the vc output in the mode line
(advice-add #'vc-git-mode-line-string :filter-return #'my-replace-git-status)
(defun my-replace-git-status (tstr)
  (let* ((tstr (replace-regexp-in-string "Git" "" tstr))
         (first-char (substring tstr 0 1))
         (rest-chars (substring tstr 1)))
    (cond
     ((string= ":" first-char) ;;; Modified
      (replace-regexp-in-string "^:" "!" tstr))
     ((string= "-" first-char) ;; No change
      (replace-regexp-in-string "^-" "" tstr))
     (t tstr))))

(provide 'init-git)

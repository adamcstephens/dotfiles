(use-package
  magit
  :bind ("C-c G" . magit)
  :init (setq magit-save-repository-buffers nil))

(use-package
  diff-hl
  :init
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  ;; (diff-hl-flydiff-mode)
  :hook
  (diff-hl-mode-on
    .
    (lambda ()
      (unless (window-system)
        (diff-hl-margin-local-mode))))
  ('magit-pre-refresh . diff-hl-magit-pre-refresh)
  ('magit-post-refresh . diff-hl-magit-post-refresh))

(use-package
  git-auto-commit-mode
  :init
  (setq gac-automatically-push-p t)
  (setq-default gac-debounce-interval 6000))

;; load diff mode on cli commit
(add-to-list 'auto-mode-alist '("/COMMIT_EDITMSG\\'" . diff-mode))

;; tweak the vc output in the mode line
(advice-add
  #'vc-git-mode-line-string
  :filter-return #'dot/replace-git-status)
(defun dot/replace-git-status (tstr)
  (let*
    (
      (tstr (replace-regexp-in-string "Git" "" tstr))
      (first-char (substring tstr 0 1))
      (rest-chars (substring tstr 1)))
    (cond
      ((string= ":" first-char) ;;; Modified
        (replace-regexp-in-string "^:" "!" tstr))
      ((string= "-" first-char) ;; No change
        (replace-regexp-in-string "^-" "" tstr))
      (t
        tstr))))

(provide 'init-git)

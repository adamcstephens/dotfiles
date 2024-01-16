(use-package
  magit
  :commands git-commit-mode
  :bind (("C-c g" . magit-file-dispatch))
  :hook ((focus-in . magit-refresh)
         (git-commit-mode . evil-insert-state))
  :config (setq magit-save-repository-buffers nil))

;; (use-package forge :after magit)

(use-package
  diff-hl
  :init
  (require 'diff-hl-margin)
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  ;; (diff-hl-flydiff-mode)
  :hook
  (diff-hl-mode-on . (lambda () (unless (window-system) (diff-hl-margin-local-mode))))
  ('magit-pre-refresh . diff-hl-magit-pre-refresh)
  ('magit-post-refresh . diff-hl-magit-post-refresh))

(use-package
  git-auto-commit-mode
  :config
  (setq gac-automatically-push-p t)
  (setq gac-commit-additional-flag "--no-gpg-sign")
  (setq-default gac-debounce-interval 6000))

;; load diff mode on cli commit
(add-to-list
 'auto-mode-alist
 '("/COMMIT_EDITMSG\\'" . git-commit-mode))

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

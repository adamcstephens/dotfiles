(defun dot/elisp-format-local ()
  (setq-local indent-tabs-mode nil)
  (setq-local lisp-indent-function nil)
  (setq-local lisp-indent-offset 2))

(defun dot/no-format ()
  (interactive)
  (remove-hook 'before-save-hook 'eglot-format-buffer t))

(use-package
  apheleia
  :config
  (setf (alist-get 'shfmt apheleia-formatters) '("shfmt"))
  (setf (alist-get 'just apheleia-formatters)
    '("just" "--unstable" "--fmt" "--justfile" filepath))
  (setf (alist-get 'just-mode apheleia-mode-alist) '(just))
  :hook
  ((bash-ts-mode . apheleia-mode)
    (fish-mode . apheleia-mode)
    (just-mode . apheleia-mode)
    (yaml-ts-mode . apheleia-mode)))

(use-package
  elisp-autofmt
  :hook
  ((emacs-lisp-mode . elisp-autofmt-mode)
    (emacs-lisp-mode . dot/elisp-format-local)
    (yuck-mode . elisp-autofmt-mode)
    (yuck-mode . dot/elisp-format-local))
  :custom
  (elisp-autofmt-empty-line-max 1)
  (elisp-autofmt-on-save-p 'always)
  (elisp-autofmt-style 'fixed))

(provide 'init-format)

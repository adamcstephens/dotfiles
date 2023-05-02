(defun dot/elisp-format-local ()
  (setq-local indent-tabs-mode nil)
  (setq-local lisp-indent-function nil)
  (setq-local lisp-indent-offset 2))

(defun dot/no-format ()
  (interactive)
  (remove-hook 'before-save-hook 'eglot-format-buffer t))

(defun dot/apheleia-setup ())

(use-package
  apheleia
  :config
  (require 'apheleia-core)
  (setf (alist-get 'shfmt apheleia-formatters) '("shfmt" "-i" "2"))
  (add-to-list
    'apheleia-formatters
    '(just-fmt . ("just" "--unstable" "--fmt" "--justfile" filepath)))
  (add-to-list 'apheleia-mode-alist '(just-mode . just-fmt))
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

(defun dot/elisp-format-local ()
  (setq-local indent-tabs-mode nil)
  (setq-local lisp-indent-function nil)
  (setq-local lisp-indent-offset 2))

(defun dot/no-format ()
  (interactive)
  (remove-hook 'before-save-hook 'eglot-format-buffer t)
  (apheleia-mode -1))

(defun dot/apheleia-setup ())

(use-package
  apheleia
  ;; :init (apheleia-global-mode)
  :config (require 'apheleia-core)
  (dolist
    (formatter-cmd
      '
      (
        (just-fmt
          .
          ("just" "--unstable" "--fmt" "--justfile" filepath))
        (nixfmt . ("alejandra")) (shfmt . ("shfmt" "-i" "2"))))
    (add-to-list #'apheleia-formatters formatter-cmd))

  (dolist
    (formatter-mode
      '((just-mode . just-fmt) (emacs-lisp-mode . lisp-indent)))
    (add-to-list #'apheleia-mode-alist formatter-mode))

  :hook
  ((bash-ts-mode . apheleia-mode)
    (fish-mode . apheleia-mode)
    (js-ts-mode . apheleia-mode)
    (json-ts-mode . apheleia-mode)
    (just-mode . apheleia-mode)
    (nix-mode . apheleia-mode)
    (terraform-mode . apheleia-mode)
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

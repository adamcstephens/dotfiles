(defun dot/elisp-format-local ()
  (setq-local indent-tabs-mode nil)
  (setq-local lisp-indent-function nil)
  (setq-local lisp-indent-offset 2))

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

(use-package
  apheleia
  :config (add-to-list 'apheleia-formatters '(shfmt . ("shfmt")))
  :hook ((fish-mode . apheleia-mode) (bash-ts-mode . apheleia-mode)))

;; (use-package apheleia
;;   :config
;;   (apheleia-global-mode +1)
;;   (cl-pushnew '(alejandra . ("alejandra")) apheleia-formatters :test #'equal)
;;   (cl-pushnew '(nix-mode . alejandra) apheleia-mode-alist :test #'equal))

(provide 'init-format)

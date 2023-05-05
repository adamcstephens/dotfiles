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
  ;; :init (apheleia-global-mode)
  :config (require 'apheleia-core)
  (dolist
      (formatter-cmd
       '
       ((just-fmt . ("just" "--unstable" "--fmt" "--justfile" filepath))
        (nixfmt . ("alejandra"))
        (shfmt . ("shfmt" "-i" "2"))))
    (add-to-list #'apheleia-formatters formatter-cmd))

  (dolist
      (formatter-mode
       '
       ((just-mode . just-fmt)
        (emacs-lisp-mode . lisp-indent)))
    (add-to-list #'apheleia-mode-alist formatter-mode))

  :hook
  ((bash-ts-mode . apheleia-mode)
   (emacs-lisp-mode . apheleia-mode)
   (fish-mode . apheleia-mode)
   (just-mode . apheleia-mode)
   (nix-mode . apheleia-mode)
   (yaml-ts-mode . apheleia-mode)))

(provide 'init-format)

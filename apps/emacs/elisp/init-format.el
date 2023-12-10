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
  :config
  (dolist
    (formatter-cmd '((just-fmt . ("just" "--unstable" "--fmt" "--justfile" filepath))
                      (nixfmt . ("alejandra"))
                      (shfmt . ("shfmt" "-i" "2"))
                      (biome . ("biome" "format" "--stdin-file-path" filepath))))
    (add-to-list #'apheleia-formatters formatter-cmd))

  (dolist
    (formatter-mode
      '((js-jsx-mode . biome)
         (js-ts-mode . biome)
         (json-ts-mode . biome)
         (just-mode . just-fmt)
         (emacs-lisp-mode . lisp-indent)))
    (add-to-list #'apheleia-mode-alist formatter-mode))

  :hook
  ((bash-ts-mode . apheleia-mode)
    (emacs-lisp-mode . apheleia-mode)
    (fish-mode . apheleia-mode)
    (js-jsx-mode . apheleia-mode)
    (js-ts-mode . apheleia-mode)
    (json-ts-mode . apheleia-mode)
    (just-mode . apheleia-mode)
    (nix-mode . apheleia-mode)
    (terraform-mode . apheleia-mode)
    (yaml-ts-mode . apheleia-mode)))

(provide 'init-format)

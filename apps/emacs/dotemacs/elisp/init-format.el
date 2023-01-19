(use-package
  format-all
  :config
  (progn
    (add-hook 'prog-mode-hook 'format-all-mode)
    (add-hook 'prog-mode-hook 'format-all-ensure-formatter)))

(use-package
  elisp-autofmt
  :hook (emacs-list-mode . elisp-autofmt-mode)
  :custom
  (elisp-autofmt-empty-line-max 1)
  (elisp-autofmt-on-save-p 'always)
  (elisp-autofmt-style 'fixed))

;; (use-package apheleia
;;   :config
;;   (apheleia-global-mode +1)
;;   (cl-pushnew '(alejandra . ("alejandra")) apheleia-formatters :test #'equal)
;;   (cl-pushnew '(nix-mode . alejandra) apheleia-mode-alist :test #'equal))

(provide 'init-format)

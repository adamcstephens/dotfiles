(use-package format-all
  :config
  (progn
    (add-hook 'prog-mode-hook 'format-all-mode)
    (add-hook 'prog-mode-hook 'format-all-ensure-formatter)))

;; (use-package apheleia
;;   :config
;;   (apheleia-global-mode +1)
;;   (cl-pushnew '(alejandra . ("alejandra")) apheleia-formatters :test #'equal)
;;   (cl-pushnew '(nix-mode . alejandra) apheleia-mode-alist :test #'equal))

(provide 'init-format)

(use-package
  terraform-mode
  :mode "\\.tf\\'"
  :config
  (defun my-terraform-mode-init ()
    (outline-minor-mode 1))

  (add-hook 'terraform-mode-hook 'my-terraform-mode-init))


(provide 'init-terraform)

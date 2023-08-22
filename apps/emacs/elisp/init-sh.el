(use-package bash-ts-mode :mode "\\.sh\\'")

(use-package fish-mode :mode ("\\.fish\\'" . fish-mode))

(use-package
  nushell-ts-mode
  :straight
  (nushell-ts-mode
    :type git
    :host github
    :repo "herbertjones/nushell-ts-mode")
  :config (require 'nushell-ts-babel)
  (with-eval-after-load 'org-contrib
    (org-babel-do-load-languages
      'org-babel-load-languages
      '(nushell . t))))

(use-package sh-script :init (setq sh-basic-offset 2))

(provide 'init-sh)

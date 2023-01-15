(use-package vterm
  :custom
  (vterm-max-scrollback 41000))

(use-package multi-vterm
  :bind
  ("C-c v" . multi-vterm-project))

(provide 'init-term)

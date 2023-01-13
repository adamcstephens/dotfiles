(use-package vterm
  :bind
  ("C-c v" . vterm))

(use-package multi-vterm
  :commands
  (multi-vterm multi-vterm-project multi-vterm-dedicated-toggle))

(provide 'init-term)

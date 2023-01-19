(use-package vterm
  :bind
  (:map vterm-mode-map
	("C-u" . (lambda () (interactive) (vterm-send-key (kbd "C-u"))))
	("M-h" . windmove-left)
	("M-l" . windmove-right))
  :custom
  (vterm-max-scrollback 41000))

(use-package multi-vterm
  :bind
  ("C-c v" . multi-vterm-project))

(provide 'init-term)

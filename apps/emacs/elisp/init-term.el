(use-package
  vterm
  :bind
  (:map
    vterm-mode-map
    ("C-u" .
      (lambda ()
        (interactive)
        (vterm-send-key (kbd "C-u")))))
  :custom (vterm-max-scrollback 41000))

(use-package
  multi-vterm
  :bind
  ("C-c v" . multi-vterm-project)
  ("M-V" . multi-vterm-project))

(provide 'init-term)

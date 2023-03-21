(use-package
  yaml-mode
  :hook (yaml-mode . (lambda () (variable-pitch-mode -1))))

(provide 'init-yaml)

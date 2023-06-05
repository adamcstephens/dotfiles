(use-package
  yaml-ts-mode
  :hook (yaml-ts-mode . (lambda () (variable-pitch-mode -1))))

(provide 'init-yaml)

(use-package
  yaml-ts-mode
  :straight (:type built-in)

  :hook (yaml-ts-mode . (lambda () (variable-pitch-mode -1))))

(provide 'init-yaml)

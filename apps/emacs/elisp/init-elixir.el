(use-package
  elixir-ts-mode
  ;; only load mode with elixir files
  :mode "\\.exs?\\'")

(use-package
  heex-ts-mode
  :hook (heex-ts-mode . (lambda () (variable-pitch-mode -1))))

(provide 'init-elixir)

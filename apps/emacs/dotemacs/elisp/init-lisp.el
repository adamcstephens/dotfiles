(use-package
  cider
  :config (setq cider-repl-display-help-banner nil)
  :bind
  (:map
    cider-repl-mode-map
    ("<up>" . cider-repl-previous-input)
    ("<down>" . cider-repl-history-forward)))

(use-package dash)

(use-package
  lispy
  ;; :straight nil
  :hook
  ((emacs-lisp-mode . (lambda () (lispy-mode 1)))
    (clojure-mode . (lambda () (lispy-mode 1)))))

(provide 'init-lisp)

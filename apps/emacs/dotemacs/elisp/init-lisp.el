(defun dot/ielm-init-history ()
  (let ((path (expand-file-name "ielm/history" user-emacs-directory)))
    (make-directory (file-name-directory path) t)
    (setq-local comint-input-ring-file-name path))
  (setq-local comint-input-ring-size 10000)
  (setq-local comint-input-ignoredups t)
  (comint-read-input-ring))

(defun dot/ielm-write-history (&rest _args)
  (with-file-modes #o600(comint-write-input-ring)))

(use-package
  cider
  :config (setq cider-repl-display-help-banner nil)
  :bind
  (:map
    cider-repl-mode-map
    ("<up>" . cider-repl-previous-input)
    ("<down>" . cider-repl-history-forward)))

(use-package comint :straight (:type built-in))

(use-package dash :straight (:type built-in))

(use-package
  ielm
  :after (comint)
  :straight (:type built-in)
  :config (advice-add 'ielm-send-input :after 'dot/ielm-write-history)
  :hook
  ((ielm-mode .eldoc-mode)
    (ielm-mode . hide-mode-line-mode)
    (ielm-mode . dot/ielm-init-history)
    (ielm-mode . lispy-mode))
  :bind
  (:map
    inferior-emacs-lisp-mode-map
    ("C-l" . comint-clear-buffer)
    ("C-r" . comint-dynamic-list-input-ring)
    ("<down>" . comint-next-input)
    ("<up>" . comint-previous-input)))

(use-package
  lispy
  :straight (:type built-in)
  :hook
  ((emacs-lisp-mode . (lambda () (lispy-mode 1)))
    (clojure-mode . (lambda () (lispy-mode 1)))))

(provide 'init-lisp)

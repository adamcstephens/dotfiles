(use-package cider)

(use-package dash)

(use-package lispy :hook emacs-lisp-mode . (lambda () (lispy-mode 1)))

(use-package
  puni
  :disabled
  :defer t
  :init
  ;; The autoloads of Puni are set up so you can enable `puni-mode` or
  ;; `puni-global-mode` before `puni` is actually loaded. Only after you press
  ;; any key that calls Puni commands, it's loaded.
  (puni-global-mode)
  :hook (vterm-mode . puni-disable-puni-mode))

(provide 'init-lisp)

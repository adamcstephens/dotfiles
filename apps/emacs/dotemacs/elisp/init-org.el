(use-package org
  :mode ("\\.org\\'" . org-mode)
  :init
  (setq org-directory "~/org/")
  (setq org-startup-indented t
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-startup-with-inline-images t
	org-image-actual-width '(300))
  :hook
  (org-mode . (lambda () (display-line-numbers-mode -1)))
  :bind
  ("C-c a" . org-agenda))

(use-package org-superstar
  :hook
  (org-mode . (lambda () (org-superstar-mode 1)))
  :init
  (setq org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿")))

(provide 'init-org)

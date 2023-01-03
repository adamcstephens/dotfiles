;; the org package itself
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :init
  (setq org-directory "~/org/")
  (setq org-startup-indented t
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-startup-with-inline-images t
	org-image-actual-width '(300))
  :config
  (setq org-attach-id-dir (expand-file-name ".attach/" org-directory))
  :hook
  (org-mode . (lambda () (display-line-numbers-mode -1)))
  ;; (org-mode . variable-pitch-mode)
  :bind
  ("C-c a" . org-agenda))

;; set some better icons
(use-package org-superstar
  :hook
  (org-mode . (lambda () (org-superstar-mode 1)))
  :init
  (setq org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿")))

(use-package org-download
  :after (org)
  :config
  (org-download-enable))

(provide 'init-org)

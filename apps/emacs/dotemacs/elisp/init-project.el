(use-package persp-mode :init (persp-mode 1))

;; enable automatic project integration with persp
(use-package
  persp-mode-project-bridge
  :after persp-mode
  :hook
  (persp-mode-project-bridge-mode
    .
    (lambda ()
      (if persp-mode-project-bridge-mode
        (persp-mode-project-bridge-find-perspectives-for-all-buffers)
        (persp-mode-project-bridge-kill-perspectives))))
  (persp-mode . persp-mode-project-bridge-mode)
  :init (persp-mode-project-bridge-mode 1)
  :config (setq persp-emacsclient-init-frame-behaviour-override "main"))

(use-package
  direnv
  :config (direnv-mode)
  ;; don't display loaded env message
  (setq direnv-always-show-summary nil)
  ;; don't display blocked env message
  (add-to-list 'warning-suppress-types '(direnv)))

(use-package
  consult-project-extra
  :bind (("H-SPC" . consult-project-extra-find)))

(use-package
  treemacs
  :bind
  (:map
    global-map
    ("M-0" . treemacs-select-window)
    ("C-x t 1" . treemacs-delete-other-windows)
    ("C-x t t" . treemacs)
    ("C-x t d" . treemacs-select-directory)
    ("C-x t B" . treemacs-bookmark)
    ("C-x t C-t" . treemacs-find-file)
    ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-magit :after (treemacs magit) :ensure t)

(use-package
  treemacs-persp
  :after (treemacs persp-mode)
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(provide 'init-project)

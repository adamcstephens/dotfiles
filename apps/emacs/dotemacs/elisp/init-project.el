(use-package
  direnv
  :config (direnv-mode)
  ;; don't display loaded env message
  (setq direnv-always-show-summary nil)
  ;; don't display blocked env message
  (add-to-list 'warning-suppress-types '(direnv)))

(use-package
  project
  :init (setq project-switch-commands #'project-find-file)
  :bind
  (("H-SPC" . project-find-file)
    ("C-c p p" . project-switch-project)
    ("C-c p p" . project-switch-project)
    ("C-c p d" . project-dired)))

(use-package
  tabspaces
  :hook (after-init . tabspaces-mode)
  :commands
  (tabspaces-switch-or-create-workspace
    tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "main")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*")))

(use-package persp-mode :disabled :init (persp-mode 1))

;; enable automatic project integration with persp
(use-package
  persp-mode-project-bridge
  :disabled
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

(provide 'init-project)

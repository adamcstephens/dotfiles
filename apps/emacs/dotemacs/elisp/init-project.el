(use-package persp-mode
  :init
  (persp-mode 1))

(use-package persp-mode-project-bridge
  :after persp-mode
  :hook
  (persp-mode-project-bridge-mode . (lambda ()
                                      (if persp-mode-project-bridge-mode
                                          (persp-mode-project-bridge-find-perspectives-for-all-buffers)
                                        (persp-mode-project-bridge-kill-perspectives))))
  (persp-mode . persp-mode-project-bridge-mode)
  :init
  (persp-mode-project-bridge-mode 1)
  :config
  (setq persp-emacsclient-init-frame-behaviour-override "main")
  :bind
  (("C-c p p" . persp-switch)))

(use-package direnv
  :config
  (direnv-mode)
  (setq direnv-always-show-summary nil))

(use-package consult-project-extra
  :init
  (setq project-switch-commands #'consult-project-extra-find)
  :bind
  (("H-SPC" . consult-project-extra-find)))

(provide 'init-project)

(use-package workroom
  :disabled
  :config
  (setq workroom-command-map-prefix (kbd "C-c w"))
  (workroom-mode 1)
  (workroom-desktop-save-mode 1)
  (workroom-auto-project-workroom-mode 1)
  :bind
  (("C-c p w" . workroom-switch)
   ("C-c b" . workroom-switch-to-buffer)))

(use-package direnv
  :config
  (direnv-mode)
  (setq direnv-always-show-summary nil))

(use-package consult-project-extra
  :straight t
  :init
  (setq project-switch-commands #'consult-project-extra-find)
  :bind
  (("C-c p f" . consult-project-extra-find)
   ("H-SPC" . consult-project-extra-find)))

;; project keys
(global-set-key (kbd "C-c p p") 'project-switch-project)
;; load dired instead of prompting
(global-set-key (kbd "C-c p d") 'project-dired)

;; enable tab mode but hide the bar
(setq tab-bar-show nil)
(tab-bar-mode 1)

(provide 'init-project)

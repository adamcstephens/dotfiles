(use-package workroom
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

(use-package project-tab-groups
  :disabled
  :config
  (project-tab-groups-mode 1))

(use-package tab-bar-echo-area
  :disabled
  :config
  (tab-bar-echo-area-mode 1))

(use-package consult-project-extra
  :straight t
  :init
  (setq project-switch-commands #'consult-project-extra-find)
  :bind
  (("C-c p f" . consult-project-extra-find)
   ("H-SPC" . consult-project-extra-find)))

;; load dired instead of prompting
;; project keys
(global-set-key (kbd "C-c p p") 'project-switch-project)
(global-set-key (kbd "C-c p d") 'project-dired)

;; enable tab mode but hide the bar
(setq tab-bar-show nil)
(tab-bar-mode 1)

;; tab keys
;; (global-set-key (kbd "C-c t s") 'tab-switch)
;; (global-set-key (kbd "C-c t j") 'tab-previous)
;; (global-set-key (kbd "C-c t k") 'tab-next)
;; (global-set-key (kbd "C-c t l") 'tab-bar-switch-to-recent-tab)

;; add a default tab layout
;; (tab-new)
;; (tab-rename "Main" 1)

(provide 'init-project)

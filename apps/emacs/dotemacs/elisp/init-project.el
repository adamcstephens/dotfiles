(defun project-tab-groups-tab-line-tabs-window-project-buffers ()
  "Return a list of tabs that should be displayed in the tab line.
Same as `tab-line-tabs-window-buffers', but if the current buffer
belongs to a project, all other buffers that don't belong to that
project are filtered out."
  (let ((window-buffers (tab-line-tabs-window-buffers)))
    (if-let*
      (
        (pr (project-current))
        (project-buffers (project--buffers-to-kill pr)))
      (seq-filter
        (lambda (buf) (member buf project-buffers))
        window-buffers)
      window-buffers)))

;; (use-package
;;   burly
;;   :straight (:host github :repo "alphapapa/burly.el")
;;   :init (burly-tabs-mode t))

(use-package
  direnv
  :init (direnv-mode)
  ;; don't display loaded env message
  (setq direnv-always-show-summary nil)
  ;; don't display blocked env message
  (add-to-list 'warning-suppress-types '(direnv)))

(use-package
  project
  :init (setq project-switch-commands #'project-find-file)
  :bind
  (("s-f" . project-find-file)
    ("s-u" . project-switch-project)
    ("C-c p p" . project-switch-project)
    ("C-c p d" . project-dired)))

;; (use-package workroom)

;; (use-package
;;   project-tab-groups
;;   :ensure
;;   :config
;;   (project-tab-groups-mode 1)
;;   (setq tab-line-tabs-function
;;     #'project-tab-groups-tab-line-tabs-window-project-buffers))

;; (use-package
;;   project-mode-line-tag
;;   :ensure
;;   :config (project-mode-line-tag-mode 1))

;; (use-package
;;   persp-mode
;;   :init (persp-mode 1)
;;   :bind (("s-y" . persp-switch))
;;   :custom (persp-kill-foreign-buffer-behaviour 'kill))

;; ;; enable automatic project integration with persp
;; (use-package
;;   persp-mode-project-bridge
;;   :after persp-mode
;;   :hook
;;   (persp-mode-project-bridge-mode
;;     .
;;     (lambda ()
;;       (if persp-mode-project-bridge-mode
;;         (persp-mode-project-bridge-find-perspectives-for-all-buffers)
;;         (persp-mode-project-bridge-kill-perspectives))))
;;   (persp-mode . persp-mode-project-bridge-mode)
;;   :init (persp-mode-project-bridge-mode 1)
;;   :config (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; (use-package
;;   tabspaces
;;   :disabled
;;   :hook (after-init . tabspaces-mode)
;;   :commands
;;   (tabspaces-switch-or-create-workspace
;;     tabspaces-open-or-create-project-and-workspace)
;;   :custom
;;   (tabspaces-use-filtered-buffers-as-default t)
;;   (tabspaces-default-tab "main")
;;   (tabspaces-remove-to-default t)
;;   (tabspaces-include-buffers '("*scratch*")))

(provide 'init-project)

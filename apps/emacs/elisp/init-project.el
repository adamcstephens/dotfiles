(defun project-tab-groups-tab-line-tabs-window-project-buffers ()
  "Return a list of tabs that should be displayed in the tab line.
Same as `tab-line-tabs-window-buffers', but if the current buffer
belongs to a project, all other buffers that don't belong to that
project are filtered out."
  (let ((window-buffers (tab-line-tabs-window-buffers)))
    (if-let*
	((pr (project-current)) (project-buffers (project--buffers-to-kill pr)))
	(seq-filter (lambda (buf)
                      (member buf project-buffers))
		    window-buffers) window-buffers)))

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

(use-package
  project-rootfile
  :init
  (add-to-list 'project-find-functions #'project-rootfile-try-detect t))

(provide 'init-project)

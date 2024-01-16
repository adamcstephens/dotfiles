(use-package evil
  :init
  (evil-mode 1)
  (evil-set-leader nil (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>bb") 'consult-project-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>bk") 'kill-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>e") 'org-export-dispatch)
  (evil-define-key 'normal 'global (kbd "<leader>f") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader>g") 'magit)
  (evil-define-key 'normal 'global (kbd "<leader>j") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader>r") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader>s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>v") 'multi-vterm-project)

  ;; allow return to open links
  (define-key evil-motion-state-map (kbd "RET") nil)
  )

(use-package evil-collection
  :after evil
  :init
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :init
  (evil-commentary-mode))

(use-package evil-org
  :after evil
  :hook
  (org-mode . evil-org-mode))

(provide 'init-modal)

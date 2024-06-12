(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (evil-mode 1)
  (evil-set-leader nil (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>bb") 'consult-project-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>bk") 'kill-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>e") 'org-export-dispatch)
  (evil-define-key 'normal 'global (kbd "<leader>f") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader>p") 'project-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader>g") 'magit)
  (evil-define-key 'normal 'global (kbd "<leader>j") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader>oa") 'org-agenda-list)
  (evil-define-key 'normal 'global (kbd "<leader>oc") 'org-capture)
  (evil-define-key 'normal 'global (kbd "<leader>or") 'org-refile)
  (evil-define-key 'normal 'global (kbd "<leader>r") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader>s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>tn") 'tab-new)
  (evil-define-key 'normal 'global (kbd "<leader>td") 'tab-close)
  (evil-define-key 'normal 'global (kbd "<leader>v") 'multi-vterm-project)

  ;; allow return to open links
  (define-key evil-motion-state-map (kbd "RET") nil)

  (evil-set-undo-system 'undo-redo)
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

(use-package evil-terminal-cursor-changer
  :after evil
  :init
  (evil-terminal-cursor-changer-activate))

(provide 'init-modal)

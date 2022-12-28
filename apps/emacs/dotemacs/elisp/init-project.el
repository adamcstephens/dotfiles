;; (use-package projectile
;;   :init (projectile-mode +1)
;;   :config (progn (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; 		 (setq projectile-auto-discover t)
;; 		 (setq projectile-project-search-path '(("~/projects/" . 1) ("~/git/" . 1) ("~/.dotfiles" . 0)))))

(use-package direnv
  :config
  (direnv-mode))

;; (defun dot--tabspace-setup ()
;;   "Set up tabspace at startup."
;;   ;; Add *Messages* and *splash* to Tab \`Home\'
;;   (tabspaces-mode 1)
;;   (progn
;;     (tab-bar-rename-tab "Home")
;;     (when (get-buffer "*Messages*")
;;       (set-frame-parameter nil
;;                            'buffer-list
;;                            (cons (get-buffer "*Messages*")
;;                                  (frame-parameter nil 'buffer-list))))
;;     (when (get-buffer "*splash*")
;;       (set-frame-parameter nil
;;                            'buffer-list
;;                            (cons (get-buffer "*splash*")
;;                                  (frame-parameter nil 'buffer-list))))))

;; (defun dot--tabspace-consult ()
;;   (with-eval-after-load 'consult
;;     ;; hide full buffer list (still available with "b" prefix)
;;     (consult-customize consult--source-buffer :hidden t :default nil)
;;     ;; set consult-workspace buffer list
;;     (defvar consult--source-workspace
;;       (list :name     "Workspace Buffers"
;;             :narrow   ?w
;;             :history  'buffer-name-history
;;             :category 'buffer
;;             :state    #'consult--buffer-state
;;             :default  t
;;             :items    (lambda () (consult--buffer-query
;; 				  :predicate #'tabspaces--local-buffer-p
;; 				  :sort 'visibility
;; 				  :as #'buffer-name)))

;;       "Set workspace buffer list for consult-buffer.")
;;     (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

;; (use-package tabspaces
;;   :hook (after-init . tabspaces-mode) ;; use this only if you want the minor-mode loaded at startup.
;;   :init
;;   (add-hook 'after-init-hook #'dot--tabspace-setup)
;;   :config
;;   (dot--tabspace-consult)
;;   :commands (tabspaces-switch-or-create-workspace
;;              tabspaces-open-or-create-project-and-workspace)
;;   :custom
;;   (tabspaces-use-filtered-buffers-as-default t)
;;   (tabspaces-default-tab "Default")
;;   (tabspaces-remove-to-default t)
;;   (tabspaces-include-buffers '("*scratch*")))

;; (use-package tree-sitter
;;  :ensure nil)

(use-package project-tab-groups
  :config
  (project-tab-groups-mode 1))

(use-package consult-jump-project
  :load-path "~/code/emacs/consult-jump-project/"
  :straight (consult-jump-project :type git :host github :repo "jdtsmith/consult-jump-project")
  :custom (consult-jump-direct-jump-modes '(dired-mode))
  :bind ("C-x p j" . consult-jump-project))

(setq project-switch-commands #'project-find-file)
(global-set-key (kbd "C-c f") 'project-find-file)

(provide 'init-project)

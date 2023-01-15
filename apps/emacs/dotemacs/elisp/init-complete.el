;; completion UI
(use-package vertico
  :straight (:files (:defaults "extensions/*"))
  :init
  (vertico-mode)
  :bind (:map vertico-map
              ("C-<backspace>" . vertico-directory-up))

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :init
  (marginalia-mode))

;; add some more searching commands
(use-package consult
  :bind
  (("C-c i" . consult-imenu)
   ("C-c b" . consult-project-buffer)
   ("C-c p s" . consult-ripgrep)
   ("C-c p r" . consult-recent-file)))

;; completion style
(use-package fussy
  :ensure t
  :config
  (push 'fussy completion-styles)
  (setq
   ;; For example, project-find-file uses 'project-files which uses
   ;; substring completion by default. Set to nil to make sure it's using
   ;; flx.
   completion-category-defaults nil
   completion-category-overrides nil))

;; (use-package prescient
;;   :init
;;   (push 'prescient completion-styles)
;;   (prescient-persist-mode 1))

;; (use-package vertico-prescient
;;   :init
;;   (vertico-prescient-mode 1))

;; jump from completion to other tasks
(use-package embark
  :bind
  (("M-o" . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; discover shortcuts easier in the minibuffer
(use-package which-key
  :diminish
  :init
  (which-key-mode))

;; snippets!
(use-package yasnippet
  :init
  (yas-global-mode 1))

(provide 'init-complete)

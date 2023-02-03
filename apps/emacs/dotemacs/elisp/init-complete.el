;; completion UI
(use-package
  vertico
  :straight (:files (:defaults "extensions/*"))
  :init (vertico-mode)
  :bind (:map vertico-map ("C-<backspace>" . vertico-directory-up))

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
(use-package savehist :init (savehist-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia :init (marginalia-mode))

;; add some more searching commands
(use-package
  consult
  :bind
  (("C-c i" . consult-imenu)
    ("C-c b" . consult-project-buffer)
    ("C-c p s" . consult-ripgrep)
    ("C-c p r" . consult-recent-file)))

;; completion style
;; (use-package
;;   fussy
;;   :ensure t
;;   :config
;;   (push 'fussy completion-styles)
;;   (setq
;;    ;; For example, project-find-file uses 'project-files which uses
;;    ;; substring completion by default. Set to nil to make sure it's using
;;    ;; flx.
;;    completion-category-defaults nil
;;    completion-category-overrides nil))

(use-package
  prescient
  :config
  (push 'prescient completion-styles)
  (prescient-persist-mode 1))

(use-package vertico-prescient :init (vertico-prescient-mode 1))

;; jump from completion to other tasks
(use-package
  embark
  :bind
  (("M-o" . embark-act)
    ("C-;" . embark-dwim)
    ("C-h B" . embark-bindings))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list
    'display-buffer-alist
    '
    ("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
      nil
      (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package
  embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; discover shortcuts easier in the minibuffer
(use-package which-key :init (which-key-mode))

;; snippets!
(use-package yasnippet :init (yas-global-mode 1))

;; Add extensions
(use-package
  cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  ;; :bind
  ;; (("C-c p p" . completion-at-point) ;; capf
  ;;   ("C-c p t" . complete-tag) ;; etags
  ;;   ("C-c p d" . cape-dabbrev) ;; or dabbrev-completion
  ;;   ("C-c p h" . cape-history)
  ;;   ("C-c p f" . cape-file)
  ;;   ("C-c p k" . cape-keyword)
  ;;   ("C-c p s" . cape-symbol)
  ;;   ("C-c p a" . cape-abbrev)
  ;;   ("C-c p i" . cape-ispell)
  ;;   ("C-c p l" . cape-line)
  ;;   ("C-c p w" . cape-dict)
  ;;   ("C-c p \\" . cape-tex)
  ;;   ("C-c p _" . cape-tex)
  ;;   ("C-c p ^" . cape-tex)
  ;;   ("C-c p &" . cape-sgml)
  ;;   ("C-c p r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )

(provide 'init-complete)

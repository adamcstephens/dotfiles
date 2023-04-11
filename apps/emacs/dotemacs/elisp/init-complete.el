(use-package
  cape
  ;; Add extensions
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

(use-package
  cape-yasnippet
  :after (cape yasnippet)
  :straight (:type git :host github :repo "elken/cape-yasnippet")
  :hook
  (eglot-managed-mode
    .
    (lambda ()
      (add-to-list 'completion-at-point-functions #'cape-yasnippet))))

(use-package
  capf-tabnine
  :disabled
  :straight
  (:host
    github
    :repo "50ways2sayhard/tabnine-capf"
    :files ("*.el" "*.sh"))
  :hook (kill-emacs . tabnine-capf-kill-process)
  :config
  (add-to-list
    'completion-at-point-functions
    #'tabnine-completion-at-point))

(use-package
  consult
  ;; add some more searching commands
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind
  ( ;; C-c bindings (mode-specific-map)
    ("C-c M-x" . consult-mode-command)
    ("C-c h" . consult-history)
    ("C-c k" . consult-kmacro)
    ("C-c m" . consult-man)
    ("C-c i" . consult-info)
    ([remap Info-search] . consult-info)
    ;; C-x bindings (ctl-x-map)
    ("C-x M-:" . consult-complex-command) ;; orig. repeat-complex-command
    ("C-x b" . consult-project-buffer) ;; orig. switch-to-buffer
    ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
    ("C-x 5 b" . consult-buffer-other-frame) ;; orig. switch-to-buffer-other-frame
    ("C-x r b" . consult-bookmark) ;; orig. bookmark-jump
    ("C-x p b" . consult-project-buffer) ;; orig. project-switch-to-buffer
    ;; Custom M-# bindings for fast register access
    ;; ("M-#" . consult-register-load)
    ;; ("M-'" . consult-register-store) ;; orig. abbrev-prefix-mark (unrelated)
    ;; ("C-M-#" . consult-register)
    ;; Other custom bindings
    ("M-y" . consult-yank-pop) ;; orig. yank-pop
    ;; M-g bindings (goto-map)
    ("M-g e" . consult-compile-error)
    ("M-g f" . consult-flymake) ;; Alternative: consult-flycheck
    ("M-g g" . consult-goto-line) ;; orig. goto-line
    ("M-g M-g" . consult-goto-line) ;; orig. goto-line
    ("M-g o" . consult-outline) ;; Alternative: consult-org-heading
    ("M-g m" . consult-mark)
    ("M-g k" . consult-global-mark)
    ("M-g i" . consult-imenu)
    ("M-g I" . consult-imenu-multi)
    ;; M-s bindings (search-map)
    ("M-s d" . consult-find)
    ("M-s D" . consult-locate)
    ("M-s g" . consult-grep)
    ("M-s G" . consult-git-grep)
    ("M-s r" . consult-ripgrep)
    ("M-s l" . consult-line)
    ("M-s L" . consult-line-multi)
    ("M-s k" . consult-keep-lines)
    ("M-s u" . consult-focus-lines)
    ;; Isearch integration
    ("M-s e" . consult-isearch-history)
    :map
    isearch-mode-map
    ("M-e" . consult-isearch-history) ;; orig. isearch-edit-string
    ("M-s e" . consult-isearch-history) ;; orig. isearch-edit-string
    ("M-s l" . consult-line) ;; needed by consult-line to detect isearch
    ("M-s L" . consult-line-multi) ;; needed by consult-line to detect isearch
    ;; Minibuffer history
    :map
    minibuffer-local-map
    ("M-s" . consult-history) ;; orig. next-matching-history-element
    ("M-r" . consult-history)) ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq
    register-preview-delay 0.5
    register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq
    xref-show-xrefs-function #'consult-xref
    xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
    consult-theme
    :preview-key
    '(:debounce 0.2 any)
    consult-ripgrep
    consult-git-grep
    consult-grep
    consult-bookmark
    consult-recent-file
    consult-xref
    consult--source-bookmark
    consult--source-file-register
    consult--source-recent-file
    consult--source-project-recent-file
    ;; :preview-key "M-."
    :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  (consult-customize consult--source-buffer :hidden t :default nil))

(use-package
  copilot
  :disabled
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :commands copilot-mode
  ;; :hook (prog-mode . copilot-mode)
  :bind
  (("M-S-<iso-lefttab>" . copilot-complete)
    :map
    copilot-completion-map
    ("C-g" . 'copilot-clear-overlay)
    ("M-p" . 'copilot-previous-completion)
    ("M-n" . 'copilot-next-completion)
    ("<tab>" . 'copilot-accept-completion)
    ("M-f" . 'copilot-accept-completion-by-word)
    ("M-<return>" . 'copilot-accept-completion-by-line)))

(use-package corfu :init (global-corfu-mode) :custom (corfu-auto t))

(use-package
  embark
  ;; jump from completion to other tasks
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

(use-package
  embark-consult
  ;; Consult users will also want the embark-consult package.
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package
  marginalia
  ;; Enable rich annotations using the Marginalia package
  :init (marginalia-mode))

(use-package
  orderless
  :custom (completion-styles '(orderless basic))
  (completion-category-overrides
    '((file (styles basic partial-completion)))))

(use-package
  savehist
  :straight (:type built-in)
  ;; Persist history over Emacs restarts. Vertico sorts by history position.
  :init (savehist-mode))

(use-package
  ;; completion UI
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

(use-package vertico-prescient :init (vertico-prescient-mode 1))

(use-package wgrep)

(use-package
  which-key
  ;; discover shortcuts easier in the minibuffer
  :init (which-key-mode))

(use-package yasnippet :init (yas-global-mode 1))

(use-package yasnippet-snippets :after yasnippet)

(provide 'init-complete)

(defun dot/variable-font () "SF Pro")
(defun dot/font-height () (if (eq system-type 'darwin) 130 105))

(defun dot/gui-setup ()
  (interactive)
  ;; disable menu, tool, and bars
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  (set-face-attribute 'default nil :font (font-spec :family "JetBrainsMono Nerd Font") :height (dot/font-height))
  (set-face-attribute 'fixed-pitch nil :family (face-attribute 'default :family))
  (set-face-attribute 'bold nil :family (face-attribute 'default :family))
  (set-face-attribute 'italic nil :family (face-attribute 'default :family))
  (set-face-attribute 'variable-pitch nil :font (font-spec :family (dot/variable-font)) :height 1.0)

  (add-hook 'text-mode-hook #'(lambda () (variable-pitch-mode t)))

  (setq
   modus-themes-italic-constructs t
   modus-themes-bold-constructs t
   ;; add identifiers to code blocks
   modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}
   ;; org tables/blocks should be fixed-pitch
   modus-themes-mixed-fonts t
   ;; modus-themes-variable-pitch-ui nil

   ;; custom org faces
   modus-themes-headings
   '((1 . (variable-pitch 1.1))
     (2 . (1.05))
     (agenda-date . (1.1))
     (agenda-structure . (variable-pitch light 1.3))
     (t . (1.0))))
  (load-theme 'modus-vivendi :no-confirm))


;; run this hook after we have initialized the first time
(add-hook 'after-init-hook 'dot/gui-setup)
;; re-run this hook if we create a new frame from daemonized Emacs
(add-hook 'server-after-make-frame-hook 'dot/gui-setup)

(use-package modus-themes
  :init
  (dot/gui-setup))

;; enable ligatures
(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
				       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
				       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
				       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
				       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
				       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
				       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
				       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
				       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
				       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
				       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
				       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
				       "\\\\" "://"))
  (global-ligature-mode t))

;; allow visualizing colors, but don't enable it by default
(use-package rainbow-mode
  :commands rainbow-mode)

;; diminish the mode line
(use-package diminish
  :config
  (diminish 'eldoc-mode))

;; colored pairs
(use-package prism
  :disabled
  :init
  (setq prism-num-faces 16)

  (prism-set-colors
   :desaturations '(0) ; do not change---may lower the contrast ratio
   :lightens '(0)      ; same
   :colors (modus-themes-with-colors
             (list fg-main
                   magenta
                   blue
                   green
                   fg-main
                   cyan
                   yellow
                   yellow-faint))))

(use-package all-the-icons)

(use-package doom-modeline
  :config
  (setq doom-modeline-buffer-encoding 'nondefault)
  :init
  (doom-modeline-mode 1))

(use-package telephone-line
  :disabled
  :after (meow)
  :demand
  :init
  ;; add meow support
  (defun telephone-line-modal-face (active)
    (cond ((not active) 'mode-line-inactive)
          ((and meow-normal-mode (region-active-p)) 'telephone-line-evil-visual)
          (meow-normal-mode 'telephone-line-evil-normal)
          (meow-insert-mode 'telephone-line-evil-insert)
          (meow-motion-mode 'telephone-line-evil-emacs)
          (meow-keypad-mode 'telephone-line-evil-operator)
	  (meow-beacon-mode 'telephone-line-evil-replace)))
  ;; style the line
  (setq telephone-line-primary-left-separator 'telephone-line-cubed-left
	telephone-line-secondary-left-separator 'telephone-line-cubed-hollow-left
	telephone-line-primary-right-separator 'telephone-line-cubed-right
	telephone-line-secondary-right-separator 'telephone-line-cubed-hollow-right)
  :config
  (telephone-line-mode t))

(use-package auto-dark
  :after (modus-themes)
  :config
  (setq auto-dark-dark-theme 'modus-vivendi)
  (setq auto-dark-light-theme 'modus-operandi)
  (when (and (eq system-type 'darwin) (eq window-system 'ns)) (setq auto-dark-allow-osascript t))
  (auto-dark-mode t))

(provide 'init-theme)

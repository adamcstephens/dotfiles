(progn
  (set-face-attribute 'default nil :font (font-spec :family "JetBrainsMono Nerd Font") :height 130)
  (set-face-attribute 'fixed-pitch nil :family (face-attribute 'default :family))
  (set-face-attribute 'bold nil :family (face-attribute 'default :family))
  (set-face-attribute 'italic nil :family (face-attribute 'default :family))
  (set-face-attribute 'variable-pitch nil :font (font-spec :family "SF Pro") :height 1.0)

  (add-hook 'text-mode-hook '(lambda () (variable-pitch-mode t)))

  (require-theme 'modus-themes)
  (setq
   modus-themes-italic-constructs t
   modus-themes-bold-constructs t
   ;; add identifiers to code blocks
   modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}
   ;; org tables/blocks should be fixed-pitch
   modus-themes-mixed-fonts t
   modus-themes-variable-pitch-ui t

   ;; custom org faces
   modus-themes-headings
   '((1 . (variable-pitch 1.5))
     (2 . (1.3))
     (agenda-date . (1.3))
     (agenda-structure . (variable-pitch light 1.8))
     (t . (1.1))))
  (load-theme 'modus-vivendi :no-confirm))

;; enable ligatures
(use-package ligature
  :load-path "path-to-ligature-repo"
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

(provide 'init-theme)

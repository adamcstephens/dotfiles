;; doom-sonokai-andromeda-theme.el --- Port of Monokai Pro -*- lexical-binding: t; no-byte-compile: t; -*-
(require 'doom-themes)

(defgroup doom-sonokai-andromeda-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-sonokai-andromeda-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-sonokai-andromeda-theme
  :type '(choice integer boolean))

(def-doom-theme doom-sonokai-andromeda
  "A port of VS Code's Monokai Pro"

  ;;     let palette = {
          ;; \ 'black':      ['#181a1c',   '237'],
          ;; \ 'bg0':        ['#2b2d3a',   '235'],
          ;; \ 'bg1':        ['#333648',   '236'],
          ;; \ 'bg2':        ['#363a4e',   '236'],
          ;; \ 'bg3':        ['#393e53',   '237'],
          ;; \ 'bg4':        ['#3f445b',   '237'],
          ;; \ 'bg_red':     ['#ff6188',   '203'],
          ;; \ 'diff_red':   ['#55393d',   '52'],
          ;; \ 'bg_green':   ['#a9dc76',   '107'],
          ;; \ 'diff_green': ['#394634',   '22'],
          ;; \ 'bg_blue':    ['#77d5f0',   '110'],
          ;; \ 'diff_blue':  ['#354157',   '17'],
          ;; \ 'diff_yellow':['#4e432f',   '54'],
          ;; \ 'fg':         ['#e1e3e4',   '250'],
          ;; \ 'red':        ['#fb617e',   '203'],
          ;; \ 'orange':     ['#f89860',   '215'],
          ;; \ 'yellow':     ['#edc763',   '179'],
          ;; \ 'green':      ['#9ed06c',   '107'],
          ;; \ 'blue':       ['#6dcae8',   '110'],
          ;; \ 'purple':     ['#bb97ee',   '176'],
          ;; \ 'grey':       ['#7e8294',   '246'],
          ;; \ 'grey_dim':   ['#5a5e7a',   '240'],
          ;; \ 'none':       ['NONE',      'NONE']
          ;; \ }

  ;; name        gui       256       16
  ((bg         '("#2b2d3a" nil       nil          ))
   (bg-alt     '("#333648" nil       nil          ))
   (base0      '("#0a0b0f" "#0a0b0f" "black"      ))
   (base1      '("#1f222d" "#1f222d"              ))
   (base2      '("#34384b" "#34384b"              ))
   (base3      '("#3f435a" "#3f435a" "brightblack"))
   (base4      '("#545a78" "#545a78" "brightblack"))
   (base5      '("#697096" "#697096" "brightblack"))
   (base6      '("#878dab" "#878dab" "brightblack"))
   (base7      '("#a5a9c0" "#a5a9c0" "brightblack"))
   (base8      '("#d2d4e0" "#d2d4e0" "white"      ))
   (fg         '("#e1e3e4" "#e1e3e4" "white"))
   (fg-alt     '("#c9cdcf" "#c9cdcf" "white"))

   (grey       '("#7e8294" "#7e8294" "brightblack"))
   (red        '("#fb617e" "#fb617e" "red"))
   (orange     '("#f89860" "#f89860" "orange"))
   (green      '("#9ed06c" "#9ed06c" "green"))
   (teal       green)
   (yellow     '("#edc763" "#edc763" "yellow"))
   (blue       '("#6dcae8" "#6dcae8" "blue"))
   (dark-blue  '("#0e4658" "#0e4658" "blue"))
   (magenta    '("#bb97ee" "#bb97ee" "magenta"))
   (violet     magenta)
   (cyan       blue)
   (dark-cyan  dark-blue)

   ;; face categories
   (highlight      base8)
   (vertical-bar   (doom-lighten bg 0.1))
   (selection      base3)
   (builtin        blue)
   (comments       grey)
   (doc-comments   yellow)
   (constants      violet)
   (functions      green)
   (keywords       red)
   (methods        green)
   (operators      magenta)
   (type           blue)
   (strings        yellow)
   (variables      base8)
   (numbers        violet)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    fg-alt)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (modeline-bg     bg-alt)
   (modeline-bg-alt `(,(car bg) ,@(cdr base1)))
   (modeline-fg     fg-alt)
   (modeline-fg-alt comments)
   (-modeline-pad
    (when doom-sonokai-andromeda-padded-modeline
      (if (integerp doom-sonokai-andromeda-padded-modeline)
          doom-sonokai-andromeda-padded-modeline
        4))))

  ;; --- faces ------------------------------
  (
   ;; I-search
   (match                                        :foreground fg :background base3)
   (isearch                                      :inherit 'match :box `(:line-width 2 :color ,yellow))
   (lazy-highlight                               :inherit 'match)
   (isearch-fail                                 :foreground red)

   ;; deadgrep
   (deadgrep-match-face                          :inherit 'match :box `(:line-width 2 :color ,yellow))

   ;; swiper
   (swiper-background-match-face-1               :inherit 'match :bold bold)
   (swiper-background-match-face-2               :inherit 'match)
   (swiper-background-match-face-3               :inherit 'match :foreground green)
   (swiper-background-match-face-4               :inherit 'match :bold bold :foreground green)
   (swiper-match-face-1                          :inherit 'isearch :bold bold)
   (swiper-match-face-2                          :inherit 'isearch)
   (swiper-match-face-3                          :inherit 'isearch :foreground green)
   (swiper-match-face-4                          :inherit 'isearch :bold bold :foreground green)
   (swiper-line-face                             :inherit 'hl-line)

   ;; Centaur tabs
   (centaur-tabs-selected :foreground yellow :background bg)
   (centaur-tabs-unselected :foreground fg-alt :background bg-alt)
   (centaur-tabs-selected-modified :foreground yellow :background bg)
   (centaur-tabs-unselected-modified :foreground fg-alt :background bg-alt)
   (centaur-tabs-active-bar-face :background yellow)
   (centaur-tabs-modified-marker-selected :inherit 'centaur-tabs-selected :foreground base8)
   (centaur-tabs-modified-marker-unselected :inherit 'centaur-tabs-unselected :foreground base8)

   ;; Doom modeline
   (doom-modeline-bar :background yellow)
   (doom-modeline-buffer-path       :foreground blue :bold bold)
   (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)

   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground yellow :bold bold)

   ;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground violet)
   (rainbow-delimiters-depth-2-face :foreground blue)
   (rainbow-delimiters-depth-3-face :foreground orange)
   (rainbow-delimiters-depth-4-face :foreground green)
   (rainbow-delimiters-depth-5-face :foreground violet)
   (rainbow-delimiters-depth-6-face :foreground yellow)
   (rainbow-delimiters-depth-7-face :foreground blue)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-alt :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))

   ;; treemacs
   (treemacs-file-face :foreground fg-alt)

   ;; tooltip
   (tooltip :background base2 :foreground fg-alt))

  ;; --- variables --------------------------
  ;; ()
  )

(provide 'doom-sonokai-andromeda-theme)
;;; doom-sonokai-andromeda-theme.el ends here

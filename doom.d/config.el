;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Adam C Stephens"
      user-mail-address "adam@valkor.net")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-old-hope)
(setq doom-old-hope-brighter-comments t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;; Add to ~/.doom.d/config.el
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 13 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :size 13)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 19))

(setq doom-modeline-icon nil)

(setq doom-localleader-key ",")

;; (defun set-exec-path-from-shell-PATH ()
;;   "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

;; This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
;;   (interactive)
;;   (setq path-separator " ")
;;   (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "fish --login -i -c 'echo $PATH' 2>/dev/null"))))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (cond (IS-MAC
;;        (set-exec-path-from-shell-PATH)))

;; disable completion of words in org mode
(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))

;; automatically revert buffers to on-disk
(global-auto-revert-mode t)

(after! org
  (require 'ox-latex)
  (require 'org-tempo)

  ;; Interpret "_" and "^" for export when braces are used.
  (setq org-export-with-sub-superscripts '{})
  (setq org-link-descriptive nil)

  ;; syntax highlight latex export
  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted"))
        org-latex-pdf-process
        '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq org-latex-classes
        '(("article" "\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{Times New Roman}
% dont indent paragraphs
\\usepackage{parskip}
[DEFAULT-PACKAGES]
\\hypersetup{colorlinks = true, urlcolor = blue, linkcolor = black}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ("syllabus"
           "\\documentclass[11pt]{article}
\\usepackage[margin=1in]{geometry}
\\usepackage{graphicx,wrapfig,subfig}
\\usepackage{fontspec}
\\setmainfont{Times New Roman}
\\usepackage{caption,anyfontsize}
\\makeatletter
% here, adjust captions
\\l@addto@macro\\captionfont{\\fontsize{9}{7}\\selectfont}
\\makeatother
% required to change the spacing
\\usepackage{setspace}
%\\doublespacing
\\usepackage{boxedminipage}
\\usepackage{fancyhdr}
\\pagestyle{fancy}
%clear default header/footer
\\fancyhf{}
\\usepackage{lastpage}
% center sections
\\usepackage{sectsty}
\\sectionfont{\\centering}
% move title up, but this still leaves space to section
%\\usepackage{titling}
%\\setlength{\\droptitle}{-10em}
\\usepackage[table]{xcolor}
\\usepackage{colortbl}
[DEFAULT-PACKAGES]
% customize link colors
\\hypersetup{colorlinks = true, urlcolor = blue, linkcolor = black}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}"))))

  (setq org-latex-compiler "xelatex")

  (setq my-presentation-template '("#+TITLE:
#+SUBTITLE:
#+REVEAL_TITLE_SLIDE: <h1>%t</h1><h2>%s</h2><h3>%A %a</h3>
#+OPTIONS: toc:nil tags:nil timestamp:nil reveal_width:1680 reveal_height:1050 reveal_embed_local_resources:t reveal_klipsify_src:t
#+REVEAL_THEME: ../../../presentations/pikestreet.css
#+REVEAL_TITLE_SLIDE_BACKGROUND: ../../../presentations/images/annie-spratt-MwbKwAZeTXs-unsplash.jpg
#+REVEAL_DEFAULT_SLIDE_BACKGROUND: ../../../presentations/images/jeremy-bishop-G9i_plbfDgk-unsplash.jpg
#+REVEAL_KLIPSE_CSS_URL: ../../../presentations/codemirror.css
#+REVEAL_MIN_SCALE: 1.0
#+REVEAL_MAX_SCALE: 1.0
#+REVEAL_CODEMIRROR_CONFIG: codemirror_options_in: {
#+REVEAL_CODEMIRROR_CONFIG:   autoCloseBrackets: true
#+REVEAL_CODEMIRROR_CONFIG: }

* Plan :noexport:
** Review and Bridge-In
** Objectives
** Points
** Activities
** Assessments
** Closure
* Reflect :noexport:
"))

  (tempo-define-template "my-presentation-template" my-presentation-template "<P" "Insert presentation template")

  (setq my-presentation-template-white '("#+TITLE:
#+SUBTITLE:
#+REVEAL_TITLE_SLIDE: <h1>%t</h1><h2>%s</h2><h3>%A %a</h3>
#+OPTIONS: toc:nil tags:nil timestamp:nil reveal_width:1680 reveal_height:1050 reveal_embed_local_resources:t reveal_klipsify_src:t
#+REVEAL_THEME: ../../../presentations/white.css
#+REVEAL_TITLE_SLIDE_BACKGROUND: ../../../presentations/images/hans-isaacson-pebZGqHqg28-unsplash.jpg
#+REVEAL_DEFAULT_SLIDE_BACKGROUND: ../../../presentations/images/almas-salakhov-DgJJh9JlcZg-unsplash.jpg
#+REVEAL_MIN_SCALE: 1.0
#+REVEAL_MAX_SCALE: 1.0
#+REVEAL_CODEMIRROR_CONFIG: codemirror_options_in: {
#+REVEAL_CODEMIRROR_CONFIG:   autoCloseBrackets: true
#+REVEAL_CODEMIRROR_CONFIG: }

* Plan :noexport:
** Review and Bridge-In
** Objectives
** Points
** Activities
** Assessments
** Closure
* Reflect :noexport:
"))
  (tempo-define-template "my-presentation-template-white" my-presentation-template-white "<PW" "Insert presentation template (white)")

  (tempo-define-template "my-properties" '(":PROPERTIES:\n\n:END:\n") "<p" "Insert properties")

  (defun org-slides-export ()
    (when (string-match "slides-.*\\.org" (file-name-nondirectory (buffer-file-name)))
      (org-re-reveal-export-to-html)
      )
    )
  (add-hook 'after-save-hook 'org-slides-export)
  )

(after! org-re-reveal
  (setq org-re-reveal-history t))

(after! ispell
  (setq ispell-personal-dictionary "~/.aspell.en.pws"))

(after! evil
  (setq evil-kill-on-visual-paste nil)
  (setq evil-shift-width 2))

;; use emacs bindings in insert-mode so we can copy/paste
;; (setq evil-disable-insert-state-bindings t)
;; (setq evil-want-keybinding nil)
;; (setq evil-escape-key-sequence nil))

;; don't prompt on quit
(setq confirm-kill-emacs nil)

(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n")))
(when (string-prefix-p "wayland" (getenv "WAYLAND_DISPLAY"))
  (setq interprogram-cut-function 'wl-copy)
  (setq interprogram-paste-function 'wl-paste))

;; force full ranger mode
(after! ranger (setq ranger-override-dired 'ranger))

(after! format-all (setq +format-on-save-enabled-modes '(not sgml-mode html-mode sql-mode tex-mode latex-mode org-msg-edit-mode)))

(use-package! git-auto-commit-mode)
(after! git-auto-commit-mode
  (setq-default gac-debounce-interval 300))

(after! heaven-and-hell
  (setq heaven-and-hell-themes
        '((light . doom-one-light)
          (dark . doom-old-hope)))
  ;; Optionall, load themes without asking for confirmation.
  (setq heaven-and-hell-load-theme-no-confirm t)
  (map!
   :g "<f6>" 'heaven-and-hell-toggle-theme
   ;; Sometimes loading default theme is broken. I couldn't figured that out yet.
   :leader "<f6>" 'heaven-and-hell-load-default-theme)
  )

(add-hook 'after-init-hook 'heaven-and-hell-init-hook)

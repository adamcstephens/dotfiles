;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Adam C Stephens")

(setq my-doom-theme-dark 'doom-old-hope)
(setq my-doom-theme-light 'tsdh-light)
(setq doom-theme my-doom-theme-dark)
(setq doom-old-hope-brighter-comments t)
(setq doom-modeline-icon nil)
(setq doom-localleader-key ",")


(setq display-line-numbers-type t)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 19))


;; disable completion of words in org mode
(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))

;; automatically revert buffers to on-disk
(global-auto-revert-mode t)

;; org settings
(setq org-directory "~/org/")
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

  (defun org-html-export-to-mhtml (async subtree visible body)
    (cl-letf (((symbol-function 'org-html--format-image) 'format-image-inline))
      (org-html-export-to-html nil subtree visible body)))

  (defun format-image-inline (source attributes info)
    (let* ((ext (file-name-extension source))
           (prefix (if (string= "svg" ext) "data:image/svg+xml;base64," "data:;base64,"))
           (data (with-temp-buffer (url-insert-file-contents source) (buffer-string)))
           (data-url (concat prefix (base64-encode-string data)))
           (attributes (org-combine-plists `(:src ,data-url) attributes)))
      (org-html-close-tag "img" (org-html--make-attribute-string attributes) info)))

  (org-export-define-derived-backend 'html-inline-images 'html
    :menu-entry '(?h "Export to HTML" ((?m "As MHTML file" org-html-export-to-mhtml))))
  )

(after! org-re-reveal
  (setq org-re-reveal-history t))

(after! ispell
  (setq ispell-personal-dictionary "~/.aspell.en.pws"))

(after! evil
  (setq evil-kill-on-visual-paste nil)
  (setq evil-shift-width 2)
  )

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

(after! format-all (setq +format-on-save-enabled-modes '(not sgml-mode html-mode sql-mode tex-mode latex-mode org-msg-edit-mode yaml-mode)))

(use-package! git-auto-commit-mode)
(after! git-auto-commit-mode
  (setq-default gac-debounce-interval 300))

(after! heaven-and-hell
  (setq heaven-and-hell-themes
        '((light . doom-one-light)
          (dark . doom-old-hope)))
  (setq heaven-and-hell-load-theme-no-confirm t)
  )

(add-hook 'after-init-hook 'heaven-and-hell-init-hook)

(after! telega
  (setq telega-server-libs-prefix "/usr"))

(defun get-string-from-file (filePath)
  "Return file content as string."
  (with-temp-buffer
    (if (file-exists-p filePath)
        (insert-file-contents filePath)
      ""
      )
    (buffer-string)))

(setq my-dark-mode-statefile (concat (getenv "HOME") "/.dotfiles/.dark-mode.state"))
(defun toggle-dark (&optional _)
  "Load the current dark mode state"
  (interactive)
  (if (string= (string-trim (get-string-from-file my-dark-mode-statefile)) "false")
      (load-theme my-doom-theme-light t) (load-theme my-doom-theme-dark t))
  )
(add-to-list 'after-make-frame-functions 'toggle-dark)
(if file-notify--library (file-notify-add-watch my-dark-mode-statefile '(change) 'toggle-dark))
(toggle-dark)

(setq projectile-enable-caching nil)

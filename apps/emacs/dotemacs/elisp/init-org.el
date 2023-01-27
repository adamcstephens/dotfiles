;; allow refiling to any org file
(defun dot/org-refile-candidates ()
  (directory-files-recursively
    org-directory
    "^[[:alnum:]].*\\.org\\'"))

(defun dot/org-slides-export ()
  (when
    (string-match
      "slides-.*\\.org"
      (file-name-nondirectory (buffer-file-name)))
    (org-re-reveal-export-to-html)))

(defun dot/org-slides-export-setup ()
  (add-hook 'after-save-hook #'dot/org-slides-export nil 'local))

;; the org package itself
(use-package
  org
  :mode ("\\.org\\'" . org-mode)
  :init (require 'ox-latex)

  ;; setup some dirs
  (setq org-directory "~/org/")
  (setq org-default-notes-file (concat org-directory "notes.org"))

  ;; stop hiding links
  (setq org-link-descriptive nil)

  ;; indent text according to structure
  (setq org-startup-indented t)
  ;; (setq org-pretty-entities t)
  ;; (setq org-hide-emphasis-markers t)
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width '(300))

  ;; enter to follow links
  (setq org-return-follows-link t)

  ;; don't add validate link to bottom of html files
  (setq org-html-validation-link nil)

  ;; refile using my func
  (add-to-list
    'org-refile-targets
    '(dot/org-refile-candidates :maxlevel . 3))

  ;; let the completion engine sort them
  (setq org-outline-path-complete-in-steps nil)

  ;; allow refiling to top-level of files
  (setq org-refile-use-outline-path 'file)

  ;; syntax highlight latex export
  (setq org-latex-src-block-backend 'listings)
  ;; (setq org-latex-packages-alist '(("" "minted")))

  ;; async export
  (setq org-export-in-background nil)

  ;; better font support
  (setq org-latex-pdf-process
    '
    ("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
      "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

  ;; custom article for syllabus
  (setq org-latex-classes
    '
    (
      ("article"
        "\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{SF Pro}
% dont indent paragraphs
\\usepackage{parskip}
\\usepackage{fancyhdr}
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
\\setmainfont{SF Pro}
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

  :config (setq org-attach-id-dir (expand-file-name ".attach/" org-directory))
  :hook
  (org-mode . (lambda () (display-line-numbers-mode -1)))
  (org-mode . dot/org-slides-export-setup)
  ;; (org-mode . variable-pitch-mode)
  :bind
  ("C-c o a" . org-agenda)
  ("C-c o c" . org-capture))

;; set some better icons
(use-package
  org-superstar
  :hook (org-mode . (lambda () (org-superstar-mode 1)))
  :init (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "⁖")))

(use-package org-download :after (org) :config (org-download-enable))

(use-package org-re-reveal :init (setq org-re-reveal-history t))

;; Show hidden emphasis markers
(use-package org-appear :disabled :hook (org-mode . org-appear-mode))

;; make list entering better
(use-package org-autolist :hook (org-mode . org-autolist-mode))

(use-package ox-pandoc)

(provide 'init-org)

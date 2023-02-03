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

(defun dot/org-html--format-image (source attributes info)
  "Optionally embed image into html as base64."
  (let
    (
      (source
        (replace-regexp-in-string
          "file://" ""
          (replace-regexp-in-string "%20" " " source
            nil 'literal)))) ;; not sure whether this is necessary
    (if (string= "svg" (file-name-extension source))
      (org-html--svg-image source attributes info)
      (if t
        (org-html-close-tag
          "img"
          (format "src=\"data:image/%s;base64,%s\"%s %s"
            (or (file-name-extension source) "")
            (base64-encode-string
              (with-temp-buffer
                (insert-file-contents-literally
                  (expand-file-name source))
                (buffer-string)))
            (file-name-nondirectory source)
            (org-html--make-attribute-string attributes))
          info)
        (org-html-close-tag
          "img"
          (org-html--make-attribute-string
            (org-combine-plists
              (list
                :src source
                :alt
                (if (string-match-p "^ltxpng/" source)
                  (org-html-encode-plain-text
                    (org-find-text-property-in-string
                      'org-latex-src
                      source))
                  (file-name-nondirectory source)))
              attributes))
          info)))))

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

  ;; (add-to-list
  ;;   'org-capture-templates
  ;;   '
  ;;   (
  ;;     ("m"
  ;;       "Meeting Notes"
  ;;       entry
  ;;       (file+headline (concat org-directory "kent.org") "Meetings")
  ;;       "* %T ")))

  :config
  (setq org-attach-id-dir (expand-file-name ".attach/" org-directory))
  (advice-add
    #'org-html--format-image
    :override #'dot/org-html--format-image)
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

(use-package
  org-present
  :hook
  (
    (org-present-mode
      .
      (lambda ()
        (org-present-big)
        (org-display-inline-images)
        (org-present-hide-cursor)
        (org-present-read-only)
        (hide-mode-line-mode 1)))
    (org-present-mode-quit
      .
      (lambda ()
        (org-present-small)
        (org-remove-inline-images)
        (org-present-show-cursor)
        (hide-mode-line-mode -1)
        (org-present-read-write)))))

(use-package hide-mode-line)

(provide 'init-org)

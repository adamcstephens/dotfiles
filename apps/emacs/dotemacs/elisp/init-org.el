;; the org package itself
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :init
  (require 'ox-latex)

  (setq org-directory "~/org/")
  (setq org-default-notes-file (concat org-directory "notes.org"))
  (setq org-startup-indented t
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-startup-with-inline-images t
	org-image-actual-width '(300))

  ;; copy latex config from https://so.nwalsh.com/2020/01/05-latex
  (setq org-latex-default-packages-alist
	'(("" "graphicx" t)
          ("" "grffile" t)
          ("" "longtable" nil)
          ("" "wrapfig" nil)
          ("" "rotating" nil)
          ("normalem" "ulem" t)
          ("" "amsmath" t)
          ("" "textcomp" t)
          ("" "amssymb" t)
          ("" "capt-of" nil)
          ("" "hyperref" nil)))
  (setq org-latex-compiler "xelatex")
  (setq org-latex-pdf-process
	(list (concat "latexmk -"
                      org-latex-compiler
                      " -recorder -synctex=1 -bibtex-cond %b")))
  (setq org-latex-listings t)

  (setq org-latex-classes
	'(("article"
	   "\\RequirePackage{fix-cm}
\\PassOptionsToPackage{svgnames}{xcolor}
\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{Manrope3}
\\setsansfont[Scale=MatchLowercase]{Manrope3}
\\setmonofont[Scale=MatchLowercase]{JetBrainsMono Nerd Font}
\\usepackage{sectsty}
\\allsectionsfont{\\sffamily}
\\usepackage{enumitem}
\\setlist[description]{style=unboxed,font=\\sffamily\\bfseries}
\\usepackage{listings}
\\lstset{frame=single,aboveskip=1em,
	framesep=.5em,backgroundcolor=\\color{AliceBlue},
	rulecolor=\\color{LightSteelBlue},framerule=1pt}
\\usepackage{xcolor}
\\newcommand\\basicdefault[1]{\\scriptsize\\color{Black}\\ttfamily#1}
\\lstset{basicstyle=\\basicdefault{\\spaceskip1em}}
\\lstset{literate=
	    {§}{{\\S}}1
	    {©}{{\\raisebox{.125ex}{\\copyright}\\enspace}}1
	    {«}{{\\guillemotleft}}1
	    {»}{{\\guillemotright}}1
	    {Á}{{\\'A}}1
	    {Ä}{{\\\"A}}1
	    {É}{{\\'E}}1
	    {Í}{{\\'I}}1
	    {Ó}{{\\'O}}1
	    {Ö}{{\\\"O}}1
	    {Ú}{{\\'U}}1
	    {Ü}{{\\\"U}}1
	    {ß}{{\\ss}}2
	    {à}{{\\`a}}1
	    {á}{{\\'a}}1
	    {ä}{{\\\"a}}1
	    {é}{{\\'e}}1
	    {í}{{\\'i}}1
	    {ó}{{\\'o}}1
	    {ö}{{\\\"o}}1
	    {ú}{{\\'u}}1
	    {ü}{{\\\"u}}1
	    {¹}{{\\textsuperscript1}}1
            {²}{{\\textsuperscript2}}1
            {³}{{\\textsuperscript3}}1
	    {ı}{{\\i}}1
	    {—}{{---}}1
	    {’}{{'}}1
	    {…}{{\\dots}}1
            {⮠}{{$\\hookleftarrow$}}1
	    {␣}{{\\textvisiblespace}}1,
	    keywordstyle=\\color{DarkGreen}\\bfseries,
	    identifierstyle=\\color{DarkRed},
	    commentstyle=\\color{Gray}\\upshape,
	    stringstyle=\\color{DarkBlue}\\upshape,
	    emphstyle=\\color{Chocolate}\\upshape,
	    showstringspaces=false,
	    columns=fullflexible,
	    keepspaces=true}
\\usepackage[a4paper,margin=1in,left=1.5in]{geometry}
\\usepackage{parskip}
\\makeatletter
\\renewcommand{\\maketitle}{%
  \\begingroup\\parindent0pt
  \\sffamily
  \\Huge{\\bfseries\\@title}\\par\\bigskip
  \\LARGE{\\bfseries\\@author}\\par\\medskip
  \\normalsize\\@date\\par\\bigskip
  \\endgroup\\@afterindentfalse\\@afterheading}
\\makeatother
[DEFAULT-PACKAGES]
\\hypersetup{linkcolor=Blue,urlcolor=DarkBlue,
  citecolor=DarkRed,colorlinks=true}
\\AtBeginDocument{\\renewcommand{\\UrlFont}{\\ttfamily}}
[PACKAGES]
[EXTRA]"
	   ("\\section{%s}" . "\\section*{%s}")
	   ("\\subsection{%s}" . "\\subsection*{%s}")
	   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	   ("\\paragraph{%s}" . "\\paragraph*{%s}")
	   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))

	  ("report" "\\documentclass[11pt]{report}"
	   ("\\part{%s}" . "\\part*{%s}")
	   ("\\chapter{%s}" . "\\chapter*{%s}")
	   ("\\section{%s}" . "\\section*{%s}")
	   ("\\subsection{%s}" . "\\subsection*{%s}")
	   ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))

	  ("book" "\\documentclass[11pt]{book}"
	   ("\\part{%s}" . "\\part*{%s}")
	   ("\\chapter{%s}" . "\\chapter*{%s}")
	   ("\\section{%s}" . "\\section*{%s}")
	   ("\\subsection{%s}" . "\\subsection*{%s}")
	   ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

  ;; syntax highlight latex export

  ;; (setq org-latex-listings 'minted
  ;; org-latex-packages-alist '(("" "minted")))

  ;;   ;; better font support
  ;;   (setq org-latex-pdf-process
  ;; 	'("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
  ;; 	  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

  ;;   ;; custom article for syllabus
  ;;   (setq org-latex-classes
  ;;         '(("article" "\\documentclass[11pt]{article}
  ;; \\usepackage{fontspec}
  ;; \\setmainfont{Manrope3}
  ;; % dont indent paragraphs
  ;; \\usepackage{parskip}
  ;; [DEFAULT-PACKAGES]
  ;; \\hypersetup{colorlinks = true, urlcolor = blue, linkcolor = black}"
  ;;            ("\\section{%s}" . "\\section*{%s}")
  ;;            ("\\subsection{%s}" . "\\subsection*{%s}")
  ;;            ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
  ;;            ("\\paragraph{%s}" . "\\paragraph*{%s}")
  ;;            ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
  ;;           ("syllabus"
  ;;            "\\documentclass[11pt]{article}
  ;; \\usepackage[margin=1in]{geometry}
  ;; \\usepackage{graphicx,wrapfig,subfig}
  ;; \\usepackage{fontspec}
  ;; \\setmainfont{Manrope3}
  ;; \\usepackage{caption,anyfontsize}
  ;; \\makeatletter
  ;; % here, adjust captions
  ;; \\l@addto@macro\\captionfont{\\fontsize{9}{7}\\selectfont}
  ;; \\makeatother
  ;; % required to change the spacing
  ;; \\usepackage{setspace}
  ;; %\\doublespacing
  ;; \\usepackage{boxedminipage}
  ;; \\usepackage{fancyhdr}
  ;; \\pagestyle{fancy}
  ;; %clear default header/footer
  ;; \\fancyhf{}
  ;; \\usepackage{lastpage}
  ;; % center sections
  ;; \\usepackage{sectsty}
  ;; \\sectionfont{\\centering}
  ;; % move title up, but this still leaves space to section
  ;; %\\usepackage{titling}
  ;; %\\setlength{\\droptitle}{-10em}
  ;; \\usepackage[table]{xcolor}
  ;; \\usepackage{colortbl}
  ;; [DEFAULT-PACKAGES]
  ;; % customize link colors
  ;; \\hypersetup{colorlinks = true, urlcolor = blue, linkcolor = black}"
  ;;            ("\\section{%s}" . "\\section*{%s}")
  ;;            ("\\subsection{%s}" . "\\subsection*{%s}")
  ;;            ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
  ;;            ("\\paragraph{%s}" . "\\paragraph*{%s}")))
  ;; )

  :config
  (setq org-attach-id-dir (expand-file-name ".attach/" org-directory))
  :hook
  (org-mode . (lambda () (display-line-numbers-mode -1)))
  ;; (org-mode . variable-pitch-mode)
  :bind
  ("C-c a" . org-agenda))

;; set some better icons
(use-package org-superstar
  :hook
  (org-mode . (lambda () (org-superstar-mode 1)))
  :init
  (setq org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿")))

(use-package org-download
  :after (org)
  :config
  (org-download-enable))

(use-package org-re-reveal
  :init
  (setq org-re-reveal-history t))

(provide 'init-org)

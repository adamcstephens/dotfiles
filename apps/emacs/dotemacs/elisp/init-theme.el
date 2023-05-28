(defun dot/variable-font ()
  "SF Pro")

(defun dot/font-height ()
  (if (eq system-type 'darwin)
    130
    105))

(defun dot/gui-setup ()
  (interactive)

  (setq initial-scratch-message nil)
  (setq inhibit-startup-screen t)

  ;; (when (< (length command-line-args) 2)
  ;;   (when (display-graphic-p)
  ;;     (when (not (string-match-p "magit" (buffer-name)))
  ;;       (dot/show-welcome-buffer))))

  ;; disable menu, tool, and bars
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tab-bar-mode 1)

  (set-face-attribute 'default nil
    :font (font-spec :family "JetBrains Mono")
    :height (dot/font-height))
  (set-face-attribute 'fixed-pitch nil
    :family (face-attribute 'default :family))
  (set-face-attribute 'bold nil
    :family (face-attribute 'default :family))
  (set-face-attribute 'italic nil
    :family (face-attribute 'default :family))
  (set-face-attribute 'variable-pitch nil
    :font (font-spec :family (dot/variable-font))
    :height 1.0)

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
    '
    ((1 . (variable-pitch 1.1))
      (2 . (1.05))
      (agenda-date . (1.1))
      (agenda-structure . (variable-pitch light 1.3))
      (t . (1.0))))
  (load-theme 'modus-vivendi :no-confirm)

  (setq global-mode-string (system-name))

  (when (and (eq system-type 'darwin) (eq window-system 'ns))
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    (add-to-list 'default-frame-alist '(ns-appearance . dark))
    (setq auto-dark-allow-osascript t)
    (auto-dark-mode t)))

;; run this hook after we have initialized the first time
;; (add-hook 'after-init-hook 'dot/gui-setup)
;; re-run this hook if we create a new frame from daemonized Emacs
(add-hook 'server-after-make-frame-hook 'dot/gui-setup)

(defun dot/show-welcome-buffer ()
  "Show *Welcome* buffer."

  (with-current-buffer (get-buffer-create "*Welcome*")
    (setq truncate-lines t)
    (let*
      (
        (buffer-read-only)
        (image-path "~/.config/emacs/dotemacs/emacs.png")
        (image (create-image image-path))
        (size (image-size image))
        (height (cdr size))
        (width (car size))
        (top-margin (floor (/ (- (window-height) height) 2)))
        (left-margin (floor (/ (- (window-width) width) 2)))
        (title "Welcome to Emacs!"))
      (erase-buffer)
      (setq mode-line-format nil)
      (goto-char (point-min))
      (insert (make-string top-margin ?\n))
      (insert (make-string left-margin ?\ ))
      (insert-image image)
      (insert "\n\n\n")
      (insert
        (make-string
          (floor (/ (- (window-width) (string-width title)) 2))
          ?\ ))
      (insert title))
    (setq cursor-type nil)
    (read-only-mode +1)
    (switch-to-buffer (current-buffer))
    (local-set-key (kbd "q") 'kill-this-buffer)))

(use-package all-the-icons)

(use-package
  auto-dark
  :after (modus-themes)
  :init
  (setq auto-dark-dark-theme 'modus-vivendi)
  (setq auto-dark-light-theme 'modus-operandi))

(use-package diff-ansi :commands (diff-ansi-mode diff-ansi-buffer))

(use-package
  doom-modeline
  :init
  (setq doom-modeline-buffer-encoding 'nondefault)
  (doom-modeline-mode 1))

;; (defun dot/project-dashboard ()
;;   (interactive)
;;   (defvar dash nil)
;;   (let
;;     (
;;       (dashboard-set-init-info nil)
;;       (dashboard-banner-logo-title nil))
;;     (setq dash (lambda () (dashboard-open))))
;;   (funcall dash))

;; (defun dot/dashboard-recentf-project (list-size)
;;   (insert "Custom Text"))

;; (use-package
;;   dashboard
;;   :init
;;   ;; (setq dashboard-set-init-info nil)
;;   ;; (setq dashboard-set-footer nil)
;;   ;; (setq dashboard-banner-logo-title nil)
;;   ;; (setq dashboard-startup-banner 'logo)
;;   ;; (setq dashboard-center-content t)
;;   ;; (setq dashboard-item-generators '((custom . dot/project-dashboard)))
;;   ;; (add-to-list
;;   ;;   'dashboard-item-generators
;;   ;;   '(recentf-project . dot/dashboard-recentf-project))
;;   ;; (setq dashboard-items '((recentf-project)))
;;   (setq dashboard-center-content t)
;;   (setq dashboard-projects-backend 'project-el)
;;   (setq dashboard-items
;;     '((projects . 5) (bookmarks . 5) (recents . 5))))

(use-package hide-mode-line :hook (vterm-mode . hide-mode-line-mode))

(use-package
  ligature
  :init
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures
    'prog-mode
    '
    ("|||>"
      "<|||"
      "<==>"
      "<!--"
      "####"
      "~~>"
      "***"
      "||="
      "||>"
      ":::"
      "::="
      "=:="
      "==="
      "==>"
      "=!="
      "=>>"
      "=<<"
      "=/="
      "!=="
      "!!."
      ">=>"
      ">>="
      ">>>"
      ">>-"
      ">->"
      "->>"
      "-->"
      "---"
      "-<<"
      "<~~"
      "<~>"
      "<*>"
      "<||"
      "<|>"
      "<$>"
      "<=="
      "<=>"
      "<=<"
      "<->"
      "<--"
      "<-<"
      "<<="
      "<<-"
      "<<<"
      "<+>"
      "</>"
      "###"
      "#_("
      "..<"
      "..."
      "+++"
      "/=="
      "///"
      "_|_"
      "www"
      "&&"
      "^="
      "~~"
      "~@"
      "~="
      "~>"
      "~-"
      "**"
      "*>"
      "*/"
      "||"
      "|}"
      "|]"
      "|="
      "|>"
      "|-"
      "{|"
      "[|"
      "]#"
      "::"
      ":="
      ":>"
      ":<"
      "$>"
      "=="
      "=>"
      "!="
      "!!"
      ">:"
      ">="
      ">>"
      ">-"
      "-~"
      "-|"
      "->"
      "--"
      "-<"
      "<~"
      "<*"
      "<|"
      "<:"
      "<$"
      "<="
      "<>"
      "<-"
      "<<"
      "<+"
      "</"
      "#{"
      "#["
      "#:"
      "#="
      "#!"
      "##"
      "#("
      "#?"
      "#_"
      "%%"
      ".="
      ".-"
      ".."
      ".?"
      "+>"
      "++"
      "?:"
      "?="
      "?."
      "??"
      ";;"
      "/*"
      "/="
      "/>"
      "//"
      "__"
      "~~"
      "(*"
      "*)"
      "\\\\"
      "://"))
  (global-ligature-mode t))

(use-package modus-themes :init (dot/gui-setup))

(use-package
  rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode :commands rainbow-mode)

(provide 'init-theme)

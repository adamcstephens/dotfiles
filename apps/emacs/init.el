;; bootstrap straight.el
(defvar bootstrap-version)
(setq straight-repository-branch "develop")
(let
    (
     (bootstrap-file
      (expand-file-name "straight/repos/straight.el/bootstrap.el"
			user-emacs-directory))
     (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent
         'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; make straight.el default
(straight-use-package 'use-package)

(require 'use-package)
;; (require 'use-package-ensure)
;; (setq use-package-always-ensure t)

(use-package dotemacs-nix-env)
(use-package gcmh :init (gcmh-mode 1))

;; load all elisp files
(add-to-list
 'load-path
 (expand-file-name "elisp" user-emacs-directory))

(require 'init-emacs)
(require 'init-theme)
(require 'init-lib)
(require 'init-key)

(require 'init-complete)
(require 'init-editor)
(require 'init-git)
;; (require 'init-lsp)
(require 'init-modal)
(require 'init-org)
(require 'init-format)
(require 'init-project)

;; (require 'init-lisp)
(require 'init-markdown)
(require 'init-nix)
(require 'init-sh)
;; (require 'init-yaml)

(require 'kill-with-intelligence)

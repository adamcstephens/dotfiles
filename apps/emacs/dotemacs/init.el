;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; make straight.el default
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; load all elisp files
(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))

(require 'init-emacs)

(require 'init-complete)
;; (require 'init-evil)
(require 'init-git)
(require 'init-key)
(require 'init-lsp)
(require 'init-meow)
(require 'init-org)
(require 'init-format)
(require 'init-project)
(require 'init-theme)

(require 'init-just)
(require 'init-markdown)
(require 'init-nix)
(require 'init-sh)
(require 'init-ssh)

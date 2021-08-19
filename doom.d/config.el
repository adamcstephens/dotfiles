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
(setq doom-theme 'doom-one)

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

(setq doom-localleader-key ",")

(after! elfeed
        (setq elfeed-use-curl t)
        (elfeed-set-timeout 120)
        (add-hook! 'elfeed-search-mode-hook 'elfeed-update)
        (elfeed-protocol-enable))

(after! elfeed-protocol
        (setq elfeed-feeds '(
                ("fever+https://adam@rss.egret.valkor.net"
                        :api-url "https://rss.egret.valkor.net/api/fever.php"
                        :password (password-store-get "freshrss/api")
                        ))))

(cond (IS-MAC
        (add-to-list 'exec-path "/opt/homebrew/bin")))

;; Disable completion of words in org mode
(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
  (add-hook! org-mode (zz/adjust-org-company-backends))

;; automatically revert buffers to on-disk
(global-auto-revert-mode t)

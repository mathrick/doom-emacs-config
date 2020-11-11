;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Maciej Katafiasz"
      user-mail-address "mathrick@gmail.com")

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

(setq! doom-font (font-spec :family "monofur for Powerline" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; Make line numbers stand out a little from the buffer contents,
;; otherwise it's too confusing
(custom-theme-set-faces! 'doom-gruvbox
  '(line-number :background "#2f2f2f"))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)


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

(load! "+commands")
(load! "+keys")

(use-package! ls-lisp)

(setq diff-switches "-u")
(setq ediff-custom-diff-options "-u")

(set-default 'truncate-lines t)
;; also truncate in vertically split windows
(setq truncate-partial-width-windows nil)

(add-hook! 'after-init-hook
  (setq cua-auto-tabify-rectangles nil)
  (setq cua-enable-cua-keys nil)
  (setq cua-enable-cursor-indications nil)
  (setq cua-enable-modeline-indications nil)
  (cua-mode))

(setq! uniquify-buffer-name-style 'post-forward-angle-brackets)

(use-package! menu-bar
  :config
  (menu-bar-mode))

(use-package! glasses
  :init
  (setq! glasses-face 'bold)
  (setq! glasses-original-separator "")
  (setq! glasses-separator "")
  :hook
  (c-mode-common . glasses-mode)
  (c-mode-common . auto-fill-mode))

(dolist (command '(narrow-to-region
                   upcase-region
                   downcase-region
                   set-goal-column
                   scroll-left))
  (put command 'disabled nil))

(use-package! smartparens-config
              ;; This is an ugly hack, but sp-override-key-bindings doesn't work
              ;; if set during init for some reason, so we're "deferring" it until
              ;; afterwards
              :defer 0
              :config
              (setq! sp-base-key-bindings 'paredit)
              (setq! sp-override-key-bindings
                     '(("M-<up>"    . nil)
                       ("M-<down>"  . nil)
                       ("M-<left>"  . nil)
                       ("M-<right>"  . nil)
                       ("C-<right>" . nil)
                       ("C-<left>"  . nil)

                       ("C-M-<right>" . sp-forward-sexp) ;; navigation
                       ("C-M-<left>"  . sp-backward-sexp)
                       ("C-M-<up>"    . sp-backward-up-sexp)
                       ("C-M-<down>"  . sp-down-sexp)
                       ("ESC <up>"    . sp-splice-sexp-killing-backward)
                       ("M-S-<up>"    . sp-splice-sexp-killing-backward)
                       ("ESC <down>"  . sp-splice-sexp-killing-forward)
                       ("M-S-<down>"  . sp-splice-sexp-killing-forward)
                       ("M-?"         . sp-convolute-sexp)

                       ("M-(" . (lambda ()
                                  (interactive)
                                  (sp-wrap-with-pair "(")))))
              (smartparens-global-strict-mode)
              :bind
              (([remap kill-line] . sp-kill-hybrid-sexp)))

(use-package! icomplete-vertical
  :config
  ;; Any value greater than 0 results in a long delay before minibuffer prompt
  ;; is actually shown
  (setq! icomplete-compute-delay 0)
  (icomplete-mode)
  (icomplete-vertical-mode))

(use-package! org
  :init
  (setq org-CUA-compatible t)
  (setq org-replace-disputed-keys t)
  (setq org-disputed-keys '(([(shift up)] . [(meta p)])
                            ([(shift down)] . [(meta n)])
                            ([(shift left)] . [(meta -)])
                            ([(shift right)] . [(meta +)])
                            ([(meta left)] . [(super left)])
                            ([(meta right)] . [(super right)])
                            ([(meta up)] . [(super up)])
                            ([(meta down)] . [(super down)])
                            ([(control shift right)] . [(meta shift +)])
                            ([(control shift left)] . [(meta shift -)])))

  :config
  (setq! org-log-done 'time)
  (setq! org-odd-levels-only t)
  (setq! org-todo-keywords '((sequence "TODO" "DONE")
                             (sequence "BUG" "WISHLIST" "|" "FIXED" "WONTFIX" "NOTABUG")
                             (sequence "PENDING" "REPEAT" "|" "FAILED" "SUCCESS")))
  (setq! org-agenda-files (list "~/org/work.org"
                                "~/org/projects.org"
                                "~/org/misc.org"))

  (put 'org-beginning-of-line 'CUA 'move)
  (put 'org-end-of-line 'CUA 'move))

(use-package! multiple-cursors
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-M->" . mc/skip-to-next-like-this)
   ("M->" . mc/mark-all-dwim)
   :map mc/keymap
   ;; I hate RET cancelling MC, I have C-g for that
   ("<return>" . nil)))

(use-package! mc-cycle-cursors
  :after multiple-cursors)

(use-package! rectangular-region-mode
  :after multiple-cursors
  :bind ("M-<return>" . set-rectangular-region-anchor))

(use-package semantic
  :config
  (setq semantic-default-submodes
        '(global-semantic-decoration-mode
          global-semantic-highlight-edits-mode
          global-semantic-highlight-func-mode
          global-semantic-idle-completions-mode
          global-semantic-idle-scheduler-mode
          global-semantic-idle-summary-mode
          global-semantic-show-parser-state-mode
          global-semantic-show-unmatched-syntax-mode
          global-semantic-stickyfunc-mode))
  (semantic-mode))
(use-package ede
  :config (global-ede-mode 1))

;; The built-in GNU style is broken, fix it
(defconst my-c-style
  '("gnu" (c-offsets-alist . ((arglist-close . c-lineup-arglist)
                              (substatement-open   . 0)
                              (case-label          . 4)
                              (statement-case-open . 0)
                              (block-open          . 0)
                              (knr-argdecl-intro   . -)))))
(c-add-style "Corrected GNU" my-c-style nil)
(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (csharp-mode . "c#")
                        (other . "Corrected gnu")))

;;;; Elisp
;; Replace package prefixes in elisp with :
(use-package nameless
  :hook (emacs-lisp-mode . nameless-mode))

;;;; Common Lisp
(defun define-cl-indent (el)
  (put (car el) 'common-lisp-indent-function
       (if (symbolp (cdr el))
           (get (cdr el) 'common-lisp-indent-function)
         (cadr el))))

(define-cl-indent '(&rest (&whole 2 &rest 2)))
(define-cl-indent '(if   (4 4 2)))
(define-cl-indent '(restart-bind . handler-bind))

;; Mode-specific info lookup (mostly for ANSI CL)
(use-package! info-look
  :config
  (info-lookup-add-help
   :mode 'lisp-mode
   :regexp "[^][()'\" \t\n]+"
   :ignore-case t
   :doc-spec '(("(ansicl)Symbol Index" nil nil nil))))

;; Use roswell-managed CL implementation
(setq! inferior-lisp-program "ros -Q run")

(use-package! dtrt-indent
  :config
  (dtrt-indent-mode t))


;; Default config for SLY binds M-_ to sly-edit-uses, but that's supposed to be
;; undo-tree-redo, so let's set it up here
(use-package! sly
  :bind
  (:map sly-mode-map ("M-_" . nil)))
(use-package! undo-tree
  :bind
  ("M-_" . undo-tree-redo))

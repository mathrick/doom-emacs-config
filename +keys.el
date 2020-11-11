;;; ~/doom-elisp/+keys.el -*- lexical-binding: t; -*-

(use-package! windmove
  :config
  (windmove-default-keybindings 'meta))

(symbol-macrolet ((local! (current-local-map)))
  (add-hook! dired-mode
    (bind-keys :map local!
               ("r" . wdired-change-to-wdired-mode)))

  (add-hook! 'c-mode-common-hook
    (bind-keys :map local!
               ("C-<right>" . c-forward-into-nomenclature)
               ("C-<left>" .  c-backward-into-nomenclature)))

  (add-hook! lisp-mode
    (bind-keys :map local!
               ("C-c S-RET" . slime-macroexpand-1-inplace)
               ("C-c M-M" .   slime-macroexpand-all-inplace)))

  (add-hook! emacs-lisp-mode
    (bind-keys :map local!
               ("C-c C-c" . eros-eval-defun))))

(put 'c-backward-into-nomenclature 'CUA 'move)
(put 'c-forward-into-nomenclature 'CUA 'move)

(put 'camelCase-forward-word 'CUA 'move)
(put 'camelCase-backward-word 'CUA 'move)

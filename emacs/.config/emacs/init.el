;; To reload this file, run M-x eval-buffer

;; customized variables go here
(setq custom-file "~/.config/emacs/emacs-custom.el")

;; Initialize package
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package
;; -p means "predicate"
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
;; Install all packages specified by use-package
(setq use-package-always-ensure t)

;; Theming
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default display-line-numbers 'relative)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)
(set-face-attribute 'variable-pitch nil :font "DejaVu Serif" :height 120)

;; run M-x nerd-icons-install-fonts after installing
(use-package nerd-icons)
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
(use-package doom-modeline
  :config
  (setq doom-modeline-modal-modern-icon nil)
  :init
  (doom-modeline-mode 1))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-gruvbox t)
  (doom-themes-org-config))

(use-package spacious-padding
  :init
  (spacious-padding-mode 1))

;; Now the real stuff starts!
(setq make-backup-files nil)
(use-package undo-tree
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.cache/emacs/undo/")))
  :init
  (global-undo-tree-mode))

(use-package evil
  :init
  (setq evil-undo-system 'undo-tree)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1))

;; vterm requires libtool-bin
(use-package vterm
  :config
  (setq vterm-shell "/usr/bin/fish")
  )

;; Completion packages
(use-package vertico
  :init
  (vertico-mode 1)
  (savehist-mode 1)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

(use-package consult)

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Keybinds
(which-key-mode t)
(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer vitix/keymap
			  :keymaps '(normal insert visual emacs)
			  :prefix "SPC"
			  :global-prefix "C-SPC")
  (vitix/keymap
   "SPC" '(consult-buffer :which-key "Consult Buffer")
   "C-SPC" '(consult-buffer :which-key "Consult Buffer")
   "f" '(consult-find :which-key "Consult [F]ind")
   "t" '(vterm :which-key "[T]erminal")

   "h" '(:ignore t :which-key "[H]arpoon")
   "hs" '(bookmark-save :which-key "Harpoon [S]ave")
   "hl" '(bookmark-save :which-key "Harpoon [L]oad")
   "hf" '(consult-bookmark :which-key "Harpoon [F]ind")
   "hd" '(bookmark-delete :which-key "Harpoon [D]elete")
   )

  (general-define-key
   :states 'normal
   "-" #'dired-jump)

  (general-define-key
   :keymaps 'dired-mode-map
   "-" #'dired-up-directory)
  )

;; Dired
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
;; R - rename/relocate file
;; C - copy file
;; D - delete file
;; d - mark for deletion
;; x - delete
;; m - mark
;; t - toggle mark
;; u - unmark
;; k - hide files (does not delete)
;; g - reload dired
;; M - modify permissions (chmod syntax)
;; C-x C-q - make buffer writeable, then use C-c C-c to save changes

;; M-n inserts the filepath under point into minibuffer


(use-package magit)

;; for next hacking sessions:
;; - org mode: roam, babel
;; - magit+dotfiles

;; distant future:
;; - LSP
;; - treesitter


;; always keep this at the end so customizations stay
(load custom-file)

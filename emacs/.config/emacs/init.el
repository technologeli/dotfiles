  (setq custom-file "~/.config/emacs/emacs-custom.el")

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

  (setq inhibit-startup-message t)
  (setq ring-bell-function 'ignore)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1)
  (setq-default display-line-numbers 'relative)

  (defun vitix/init-fonts ()
    (setq vitix/fixed-font-height 140)
    (setq vitix/variable-font-height 140)
    (setq vitix/fixed-font "JetBrains Mono")
    (setq vitix/variable-font "Inter")
    (set-face-attribute 'default nil :font vitix/fixed-font :height vitix/fixed-font-height)
    (set-face-attribute 'fixed-pitch nil :font vitix/fixed-font :height vitix/fixed-font-height)
    (set-face-attribute 'variable-pitch nil :font vitix/variable-font :height vitix/variable-font-height)
    )
  (vitix/init-fonts)

  ;; run M-x nerd-icons-install-fonts after installing
  (use-package nerd-icons)
  (use-package nerd-icons-dired
    :hook
    (dired-mode . nerd-icons-dired-mode))
   (use-package doom-modeline
     :config
     (setq doom-modeline-modal-modern-icon nil)
     (setq doom-modeline-height 25)
     (setq doom-modeline-position-line-format '(""))
     (setq doom-modeline-percent-position '(-3 ""))
     :init
     (doom-modeline-mode 1))

  ;; (use-package doom-themes
  ;;   :config
  ;;   (setq doom-themes-enable-bold t)
  ;;   (setq doom-themes-enable-italic t)
  ;;   (load-theme 'doom-gruvbox t)
  ;;   (doom-themes-org-config))


  (use-package ef-themes
    :init
    (setq ef-themes-mixed-fonts t)
    (setq ef-themes-bold-constructs t)
    (setq ef-themes-italic-constructs t)
    (setq ef-themes-variable-pitch-ui nil)
    (setq ef-themes-prompts '(bold))
    (setq ef-themes-completions '((matches . (bold))
				     (selection . ())))
    (setq ef-themes-to-toggle '(ef-dream ef-kassio))
    (setq ef-themes-headings '((1 . (1.2))
			       (2 . (1.15))
			       (3 . (1.1))
			       (t . (1.05))))
    :config
    (ef-themes-load-theme 'ef-dream)
    )

  (use-package spacious-padding
    :init
    (spacious-padding-mode 1))

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
    (evil-mode 1)
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
    )

  ;; vterm requires libtool-bin
  (use-package vterm
    :config
    (setq vterm-shell "/usr/bin/fish")
    )

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
      "e" '(ef-themes-toggle :which-key "[E]f Themes Toggle")

      "h" '(:ignore t :which-key "[H]arpoon")
      "hs" '(bookmark-save :which-key "Harpoon [S]ave")
      "hl" '(bookmark-load :which-key "Harpoon [L]oad")
      "hf" '(consult-bookmark :which-key "Harpoon [F]ind")
      "hd" '(bookmark-delete :which-key "Harpoon [D]elete")
      )

    (general-define-key
     :states 'normal
     "-" #'dired-jump
     "zf" #'evil-toggle-fold)

    (general-define-key
     :keymaps 'dired-mode-map
     "-" #'dired-up-directory)

    (general-define-key
     :keymaps 'vterm-mode-map
     "C-S-v" #'vterm-yank)
    )

  (add-hook 'dired-mode-hook #'dired-hide-details-mode)

  (use-package magit)

  (defun vitix/org-mode-setup ()
    (variable-pitch-mode)
    (org-indent-mode)
    )
  (use-package org
    :hook (org-mode . vitix/org-mode-setup)
    :config
    (setq org-hide-emphasis-markers t)
    (setq org-src-preserve-indentation t)
    )

  (use-package org-appear
    :init
    (add-hook 'org-mode-hook 'org-appear-mode)
    )

  (use-package org-bullets
    :after org
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-structure-template-alist '(("s" . "src")
				     ("e" . "src emacs-lisp")
				     ("p" . "src python")))

  (use-package denote
    :hook (dired-mode . denote-dired-mode)
    :bind
    (("C-c n n" . denote)
     ("C-c n r" . denote-rename-file)
     ("C-c n l" . denote-link)
     ("C-c n d" . denote-dired)
     ("C-c n g" . denote-grep))
    :config
    (setq denote-directory (expand-file-name "~/tome"))
    (denote-rename-buffer-mode 1)
    (setq denote-known-keywords '()))

  (use-package consult-denote
    :bind
    (("C-c n f" . consult-denote-find)
     ("C-c n g" . consult-denote-grep))
    :config
    (consult-denote-mode 1))

  (use-package denote-journal
    :hook (calendar-mode . denote-journal-calendar-mode)
    :bind
    (("C-c n t" . denote-journal-new-or-existing-entry)
     ("C-c n s" . denote-journal-link-or-create-entry))
    :config
    ;; save journal entries in denote-directory
    (setq denote-journal-directory nil)
    (setq denote-journal-keyword "journal")
    (setq denote-journal-title-format 'day-date-month-year)
    )

  (load custom-file)

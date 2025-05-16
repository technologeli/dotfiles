;; -*- lexical-binding: t; -*-

(setq custom-file "~/.config/emacs/emacs-custom.el")

  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
  			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
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
    (setq vitix/fixed-font-height 120)
    (setq vitix/variable-font-height 120)
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
  (setq ef-themes-headings '((0 . (1.75))
                             (1 . (1.2))
                             (2 . (1.15))
                             (3 . (1.1))
                             (t . (1.05))))
  :config
  (ef-themes-load-theme 'ef-dream))

(use-package spacious-padding)
  
(defun spacious-padding-workaround ()
  "Workaround issues with `spacious-padding-mode' when using emacsclient."
  (when server-mode
    (spacious-padding-mode 1)))
(add-hook 'server-after-make-frame-hook #'spacious-padding-workaround)

(defun vitix/window (function)
  (when (mode-line-window-selected-p)
    (eval function)))

(defface vitix/modeline-highlighted-face
    `((t
       :background ,(ef-themes-get-color-value 'fg-alt)
       :foreground ,(ef-themes-get-color-value 'bg-main)
       :inherit bold))
    "Face for a highlighted background for the modeline")

(defvar-local vitix/modeline-buffer-name
    '(:eval (propertize (buffer-name) 'face 'bold)))

(defvar-local vitix/modeline-major-mode
    '(:eval
      (vitix/window
	'(propertize
	 (capitalize (replace-regexp-in-string "-mode" "" (symbol-name major-mode)))
	 'face 'bold))))

(defvar-local vitix/modeline-meow-mode
    '(:eval
      (vitix/window
       '(propertize
	 (if (bound-and-true-p meow-mode) " M " "")
	 'face 'vitix/modeline-highlighted-face))))

(defvar-local vitix/modeline-buffer-modified
    '(:eval
      (vitix/window
       '(propertize (if (and (buffer-modified-p) (buffer-file-name)) " * " "")
	            'face 'vitix/modeline-highlighted-face))))

(defun vitix/eat-minor-mode ()
    (cond (eat--semi-char-mode " (semi-char)")
	  (eat--char-mode " (char)")
	  (eat--line-mode " (line)")
	  (t " (emacs)")
	  ))

(defvar-local vitix/modeline-eat-minor-mode
    '(:eval
      (vitix/window
       '(propertize
	 (if (string-equal (symbol-name major-mode) "eat-mode")
	   (vitix/eat-minor-mode)
	   "")))))

(dolist (var '(vitix/modeline-meow-mode
	       vitix/modeline-buffer-name
	       vitix/modeline-major-mode
	       vitix/modeline-eat-minor-mode
	       vitix/modeline-buffer-modified))
  (put var 'risky-local-variable t))

(setq-default
 mode-line-format
 '("%e"
   vitix/modeline-meow-mode
   " "
   vitix/modeline-buffer-name
   " "
   vitix/modeline-buffer-modified
   mode-line-format-right-align
   vitix/modeline-major-mode
   vitix/modeline-eat-minor-mode
   "  "
   ))

  (setq make-backup-files nil)
  (use-package undo-tree
    :config
    (setq undo-tree-history-directory-alist '(("." . "~/.cache/emacs/undo/")))
    :init
    (global-undo-tree-mode))

(setq auth-sources '("~/.authinfo.gpg"))

(defun vitix/disable-backups () 
  "Disable backups and autosaving for files ending in \".gpg\" or those in \"/dev\"."
  (when (and (buffer-file-name) 
             (or (string-match "\\.gpg\\'" (buffer-file-name))
		 (string-match "^/dev" (buffer-file-name)))) 
    (setq-local backup-inhibited t) 
    (setq-local undo-tree-auto-save-history nil) 
    (auto-save-mode -1))) 
(add-hook 'find-file-hook #'vitix/disable-backups)

(setq history-add-new-input nil)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak-dh)
  (meow-motion-define-key
   ;; Use e to move up, n to move down.
   ;; Since special modes usually use n to move down, we only overwrite e here.
   '("e" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   '("?" . meow-cheatsheet)
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("/" . meow-visit)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("e" . meow-prev)
   '("E" . meow-prev-expand)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("m" . meow-left)
   '("M" . meow-left-expand)
   '("i" . meow-right)
   '("I" . meow-right-expand)
   '("j" . meow-join)
   '("k" . meow-kill)
   '("l" . meow-line)
   '("L" . meow-goto-line)
   '("h" . meow-mark-word)
   '("H" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("r" . meow-replace)
   '("s" . meow-insert)
   '("S" . meow-open-above)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-search)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . meow-delete)
   '("X" . meow-backward-delete)
   '("y" . meow-save)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(use-package meow
  :init
  (setq meow-expand-hint-remove-delay 0)
  :config
  (meow-setup)
  (meow-global-mode 1))

(use-package eat
  :bind
  ("C-c t s" . #'eat-semi-char-mode)
  ("C-c t e" . #'eat-emacs-mode))

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

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

  (use-package magit)

  (defun vitix/org-mode-setup ()
    (variable-pitch-mode)
    (vitix/init-fonts)
    (visual-line-mode)
    (org-indent-mode)
    )
  (use-package org
    :hook (org-mode . vitix/org-mode-setup)
    :config
    (setq org-hide-emphasis-markers t)
    (setq org-src-preserve-indentation t)
    (setq org-return-follows-link t)
    (setq org-startup-truncated nil)
    (setq org-directory "~/tome")
    :bind
    ("C-c C-h" . #'org-fold-hide-entry)
    ("C-c C-s" . #'org-fold-show-entry))

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
                                     ("p" . "src python")
				     ("t" . "src sh :tangle no")))

(use-package org-capture
  :ensure nil ; org-capture comes with emacs, just use this to configure it
  :config
  (setq org-capture-templates
        '(("l" "Log" entry
           (file+headline denote-journal-path-to-new-or-existing-entry "Log")
           "* %<%I:%M %p> - %?"
           )
          ("t" "Task" entry
           (file+headline denote-journal-path-to-new-or-existing-entry "Task")
           "* TODO %?"
           )
          ("i" "TTRPG Idea" entry
           (file+headline "20250507T140321--ttrpg-ideas__ttrpg.org" "Ideas")
           "* %?")))
  :bind
  ("C-c c" . org-capture))

(setq org-todo-keywords '((sequence
                           "TODO(t)"
                           "WAIT(w@/!)"
                           "|"
                           "DONE(d/!)"
                           "STOP(s@/!)")))
(setq org-todo-keyword-faces
      `(("TODO" . ,(ef-themes-get-color-value 'green))
	("WAIT" . ,(ef-themes-get-color-value 'yellow-warmer))
	("DONE" . ,(ef-themes-get-color-value 'bg-dim))
	("STOP" . ,(ef-themes-get-color-value 'fg-dim))))
(set-face-attribute 'org-headline-done nil
		    :foreground (ef-themes-get-color-value 'bg-dim))

(use-package org-agenda
  :ensure nil
  :config
  (setq org-agenda-files (list org-directory))
  :bind
  ("C-c a" . org-agenda))

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

(use-package denote-org)

(add-to-list 'exec-path "/home/eli/.volta/bin")
(add-to-list 'exec-path "/home/eli/.local/bin")

(use-package eglot
  :ensure nil
  :config
  (global-eldoc-mode t)
  :bind
  (("C-c e r" . #'eglot-rename)
  ("C-c e f n" . #'flymake-goto-next-error)
  ("C-c e f p" . #'flymake-goto-prev-error)
  ("C-c e c" . #'eglot-code-actions)
  ("C-c e d" . #'xref-find-definitions)
  ("C-c e k" . #'eldoc)))

(use-package corfu
  :bind (:map corfu-map
              ("M-SPC" . corfu-insert-separator)
              ("M-y" . corfu-insert)
              ("RET" . nil))
  :init
  (global-corfu-mode t)
  (corfu-history-mode t))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  )

(which-key-mode 1)
(defvar-keymap vitix/harpoon-keymap
  :doc "Harpoon, but its actually bookmarks"
  "s" #'bookmark-save
  "l" #'bookmark-load
  "f" #'consult-bookmark
  "d" #'bookmark-delete)

(defvar-keymap vitix/prefix-keymap
  :doc "My custom keymap!"
  "b" #'consult-buffer
  "t" #'eat
  "-" #'dired-jump
  "S-t" #'ef-themes-toggle
  "e" #'eglot
  "z" #'meow-global-mode
  "h" vitix/harpoon-keymap)

(keymap-set global-map "C-t" vitix/prefix-keymap)
(global-set-key (kbd "C-o") #'other-window)
(define-key dired-mode-map (kbd "-") #'dired-up-directory)

(use-package view
  :ensure nil
  :config
  (define-key global-map (kbd "C-v") #'View-scroll-half-page-forward)
  (define-key global-map (kbd "M-v") #'View-scroll-half-page-backward)
  )

(load custom-file)

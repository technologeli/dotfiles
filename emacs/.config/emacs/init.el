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
    (spacious-padding-mode 1)
    (remove-hook 'server-after-make-frame-hook #'spacious-padding-workaround)))
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

(defvar-local vitix/modeline-god-mode
    '(:eval
      (vitix/window
       '(propertize
	 (when (bound-and-true-p god-local-mode) " G ")
	 'face 'vitix/modeline-highlighted-face))))

(defvar-local vitix/modeline-buffer-modified
    '(:eval
      (vitix/window
       '(propertize (when (and (buffer-modified-p) (buffer-file-name)) " * ")
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
	 (when (string-equal (symbol-name major-mode) "eat-mode")
	   (vitix/eat-minor-mode))))))

(dolist (var '(vitix/modeline-god-mode
	       vitix/modeline-buffer-name
	       vitix/modeline-major-mode
	       vitix/modeline-eat-minor-mode
	       vitix/modeline-buffer-modified))
  (put var 'risky-local-variable t))

(setq-default
 mode-line-format
 '("%e"
   vitix/modeline-god-mode
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

(defun insert-semicolon ()
  "Insert a semicolon character."
  (interactive)
  (insert ";"))

(global-set-key (kbd "C-;") #'insert-semicolon)

(use-package god-mode
  :config
  (god-mode)
  (global-set-key (kbd ";") #'god-local-mode)
  (define-key god-local-mode-map (kbd ";") #'god-local-mode)
  (define-key god-local-mode-map (kbd ".") #'repeat)
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'split-window-below)
  (global-set-key (kbd "C-x C-3") #'split-window-right)
  (global-set-key (kbd "C-x C-0") #'delete-window)
  (global-set-key (kbd "C-o") #'other-window)
  (define-key god-local-mode-map (kbd "[") #'backward-paragraph)
  (define-key god-local-mode-map (kbd "]") #'forward-paragraph)
  (which-key-mode t)
  (which-key-enable-god-mode-support)
  )

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package eat)

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
                                     ("p" . "src python")))

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

;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

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

(defvar-keymap vitix/harpoon-keymap
  :doc "Harpoon, but its actually bookmarks"
  "C-s" #'bookmark-save
  "C-l" #'bookmark-load
  "C-f" #'consult-bookmark
  "C-d" #'bookmark-delete)

(defvar-keymap vitix/prefix-keymap
  :doc "My custom keymap!"
  "C-b" #'consult-buffer
  "C-t" #'eat
  "C--" #'dired-jump
  "C-S-t" #'ef-themes-toggle
  "C-e" #'eglot
  "C-h" vitix/harpoon-keymap)

(keymap-set global-map "C-t" vitix/prefix-keymap)
(define-key dired-mode-map (kbd "-") #'dired-up-directory)

(load custom-file)

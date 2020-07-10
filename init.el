(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defvar myPackages
  '(better-defaults
    elpy
    flycheck
    blacken
    sphinx-doc
    org-bullets
    multiple-cursors
    )
  )

;; https://github.com/ianpan870102/vscode-dark-plus-emacs-theme/
;; dark theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'vscode-dark t)

;; better-defaults
(require 'better-defaults)

(defun window-bck()
  (interactive)
  (other-window -1)
  )

;; python development
(require 'elpy)
(elpy-enable)
;; enable flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(define-key (current-global-map) (kbd "C-c C-n") 'elpy-flymake-next-error)
;; add jedi backend
(setq elpy-rpc-backend "jedi")
(define-key (current-global-map) (kbd "M-'") 'flymake-goto-next-error)
(define-key (current-global-map) (kbd "M-\"") 'flymake-goto-prev-error)
;; enable jedi-direx -- tree style view for python source code
(eval-after-load "python"
  '(define-key python-mode-map "\C-c x" 'jedi-direx:pop-to-buffer))
(add-hook 'jedi-mode-hook 'jedi-direx:setup)

(add-hook 'ein:notebook-multilang-mode (lambda ()
                                         (define-key ein:notebook-mode-map (kbd "M-E") 'ein:worksheet-goto-prev-input)
                                         (define-key ein:notebook-mode-map (kbd "M-e") 'ein:worksheet-goto-next-input)))

;; movement
(define-key (current-global-map) (kbd "M-o") 'other-window)
(define-key (current-global-map) (kbd "M-O") 'window-bck)

(define-key (current-global-map) (kbd "M-i") 'previous-line)
(define-key (current-global-map) (kbd "M-k") 'next-line)
(define-key (current-global-map) (kbd "M-j") 'backward-char)
(define-key (current-global-map) (kbd "M-l") 'forward-char)

(define-key (current-global-map) (kbd "M-U") 'downcase-word)
(define-key (current-global-map) (kbd "C-u") 'universal-argument)
;; C-c M-d at start of function definition to insert REst docstring
(add-hook 'python-mode-hook (lambda ()
			      (require 'sphinx-doc)
			      (sphinx-doc-mode t)))

;; visual-regexp-steroids
;; https://github.com/benma/visual-regexp-steroids.el/
;;(add-to-list 'load-path "folder-to/visual-regexp/")
;;(add-to-list 'load-path "folder-to/visual-regexp-steroids/")
;;(require 'visual-regexp-steroids) 
;;(define-key global-map (kbd "C-c r") 'vr/replace)
;;(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
;;(define-key global-map (kbd "C-c m") 'vr/mc-mark)
;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
;;(define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
;;(define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s

;; spaced repitition is useful
;;(require 'org-drill)
;; I like pretty bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; add multiple-cursor support
(require 'multiple-cursors)
;; add a cursor to each line in active region
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "M-]") 'mc/mark-next-like-this)
(global-set-key (kbd "M-[") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-|") 'mc/mark-all-like-this)

;; emacs application framework
;; https://github.com/manateelazycat/emacs-application-framework
;;require 'eaf)

;; company-mode auto-completion
(require 'company)

;; load shell PATH environment
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; enable projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; enable direx -- a tree style document viewer
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; enable dired-filter
(add-hook 'dired-after-readin-hook (lambda () (dired-filter-mode 1)))
(add-hook 'dired-filter-mode-hook (lambda () (dired-filter-group-mode 1))) 

;; enable helm-themes
(require 'helm-config)
(require 'helm-themes)

;; helm-mode configs http://tuhdo.github.io/helm-intro.html
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "C-x C-f") 'helm-find-files-files)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)
(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

;; dot-mode
(use-package graphviz-dot-mode
             :ensure t
             :config
             (setq graphviz-dot-indent-width 4))
(use-package company-graphviz-dot)

(load-theme 'pastelmac)

(server-start)


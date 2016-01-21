(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-logical-line)))

;; make cursor movement keys under right hand's home-row.
(global-set-key (kbd "M-j") 'backward-char) ; was indent-new-comment-line
(global-set-key (kbd "M-l") 'forward-char)  ; was downcase-word
(global-set-key (kbd "M-i") 'previous-line) ; was tab-to-tab-stop
(global-set-key (kbd "M-k") 'next-line) ; was kill-sentence

;; Package manager code
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; Set by custom themes
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "1a85b8ade3d7cf76897b338ff3b20409cb5a5fbed4e45c6f38c98eee7b025ad4" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "46fd293ff6e2f6b74a5edf1063c32f2a758ec24a5f63d13b07a20255c074d399" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "758da0cfc4ecb8447acb866fb3988f4a41cf2b8f9ca28de9b21d9a68ae61b181" "7fbb8d064286706fb1e319c9d3c0a8eafc2efe6b19380aae9734c228b05350ae" "b1fdbb009af22a58788857cc5d44a4835a38088492ff0f3fea40857338cf0c3b" "2b5aa66b7d5be41b18cc67f3286ae664134b95ccc4a86c9339c886dfd736132d" "bc89fda3d232a3daa4eb3a9f87d6ffe1272fea46e4cf86686d9e8078e4209e2c" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "7356632cebc6a11a87bc5fcffaa49bae528026a78637acd03cae57c091afd9b9" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" default)))
 '(display-time-mode t)
 '(fringe-mode nil nil (fringe))
 '(inhibit-startup-screen t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

;; ;; set color of line numbers
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(linum ((t (:inherit (shadow default) :background "#181818" :foreground "#1d91ff")))))

(global-linum-mode)
(color-theme-approximate-on)

(require 'ansi-color) (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Scheme interpreter config
;;; Always do syntax highlighting
(global-font-lock-mode 1)

;;; Also highlight parens
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode 1)

;;; This is the binary name of my scheme implementation
(setq scheme-program-name "scm")

;;; org-mode bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq x-select-enable-clipboard t
      x-select-enable-primary t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR." t)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(load-theme 'underwater)
(delete-selection-mode 1)

;; ctags code
(setq path-to-ctags "/usr/local/bin/ctags") ;; <- your ctags path here

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )

;; enable auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;; sublimity-mode
(add-to-list 'load-path "/path/to/.emacs.d/sublimity/")
(require 'sublimity)
(require 'sublimity-scroll)
(require 'sublimity-map)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; highlight line number of currently selected line
(require 'hl-line)
(defface my-linum-hl
  `((t :inherit linum :background ,(face-background 'hl-line nil t)))
  "Face for the current line number."
  :group 'linum)

(defvar my-linum-format-string "%3d")

(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

(defun my-linum-get-format-string ()
  (let* ((width (1+ (length (number-to-string
                             (count-lines (point-min) (point-max))))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-format)

(defun my-linum-format (line-number)
  (propertize (format my-linum-format-string line-number) 'face
              (if (eq line-number my-linum-current-line-number)
                  'my-linum-hl
                'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

;; org-mode Eisenhower matrix
(fset 'make-eisenhower-matrix
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([124 45 43 45 43 45 43 45 43 45 124 return 124 32 124 60 52 62 124 60 50 52 62 124 60 49 53 62 124 60 49 48 62 124 3 45 134217835 return 124 32 124 32 124 32 60 32 50 52 32 104 111 117 114 115 32 124 32 60 32 55 50 32 104 114 115 134217826 134217826 134217826 134217836 delete delete 5 32 124 32 62 32 55 50 32 104 114 115 32 124 3 45 134217835 return 124 32 124 32 72 105 103 104 32 124 32 124 32 124 32 124 3 45 134217835 return 124 80 tab 134217835 124 32 114 tab 134217835 124 32 105 tab 134217835 124 32 111 tab 134217835 124 32 114 tab 134217835 124 32 105 tab 134217835 124 32 116 tab 134217835 124 32 121 tab 134217833 134217833 134217833 77 101 100 134217835 134217835 134217835 134217835 3 45 134217834 3 45 134217835 5 return 124 tab 76 111 119 3 45 134217833 134217833 134217833 134217833 134217833 134217833 134217833 134217833 134217833 134217833 134217836 134217836 134217836 134217836 134217836 134217833] 0 "%d")) arg)))

;; (fset 'make-eisenhower-matrix
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([124 45 43 45 43 45 124 return 124 32 124 32 68 117 101 32 115 111 111 110 32 124 32 68 117 101 32 108 97 116 101 114 32 124 return 124 45 43 45 43 45 124 return 124 32 73 109 112 111 114 116 97 110 116 32 124 32 124 32 124 return 124 45 43 45 43 45 124 return 124 78 111 116 32 105 109 112 111 114 116 97 110 116 32 124 32 124 32 124 return 124 45 43 45 43 45 124 3 3 134217833 134217833 134217833 134217826 134217830 134217836 134217836 134217836 134217836 134217836 134217836 134217836] 0 "%d")) arg)))



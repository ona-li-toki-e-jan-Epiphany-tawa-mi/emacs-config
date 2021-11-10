(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Removes menu bar.
;; https://stackoverflow.com/questions/53958292/remove-the-emacs-menu-bar
(menu-bar-mode -1)
;; Removes tool bar.
;; https://kb.mit.edu/confluence/display/istcontrib/Disabling+the+Emacs+menubar%2C+toolbar%2C+or+scrollbar
(tool-bar-mode -1) 

;; Prevents the splash screen from displaying.
;; https://freethegnu.wordpress.com/2007/12/15/how-to-prevent-emacs-from-showing-the-splash-screen
(setq inhibit-splash-screen t)

;; Defaults to full-screen mode.
;; https://www.emacswiki.org/emacs/FullScreen
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; Duplicates a line with C-c d.
;; https://stackoverflow.com/questions/88399/how-do-i-duplicate-a-whole-line-in-emacs#88737
(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
With argument N, make N copies.
With negative N, comment out original line and use the absolute value."
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region        ;Get region if active, otherwise line
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
                          (newline))))))
        (dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
          (insert text))))
    (if use-region nil                  ;Only if we're working with a line (not a region)
      (let ((pos (- (point) (line-beginning-position)))) ;Save column
        (if (> 0 n)                             ;Comment out original with negative arg
            (comment-region (line-beginning-position) (line-end-position)))
        (forward-line 1)
        (forward-char pos)))))
(global-set-key (kbd "C-c d") 'duplicate-line-or-region)

;; Keybind for seaching through buffers.
(global-set-key (kbd "C-c f") 'multi-occur)

;; Displays line numbers in programming mode.
;; https://emacs.stackexchange.com/questions/278/how-do-i-display-line-numbers-in-emacs-not-in-the-mode-line.
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Opens the config with C-c o.
(defun visit-config ()
  (interactive)
  (find-file "~/.emacs"))
(global-set-key (kbd "C-c o") 'visit-config)

;; Move fast using alt and arrow keys.
(global-set-key (kbd "M-<up>") (kbd "M-v"))
(global-set-key (kbd "M-<down>") (kbd "C-v"))

;; Runs Dired on startup.
(defun init-dired ()
  (interactive)
  (dired "~/"))
(add-hook 'after-init-hook 'init-dired)

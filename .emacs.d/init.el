(tool-bar-mode -1)
(menu-bar-mode -1)
(display-battery-mode 1)
(setq display-time-day-and-date t)
(display-time-mode 1)

(when (>= emacs-major-version 24)
  (progn
    ;; load emacs 24's package system. Add MELPA repository.
    (require 'package)
    (add-to-list
     'package-archives
     '("melpa" . "https://melpa.org/packages/")
     t))

  (when (< emacs-major-version 27) (package-initialize)))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package evil
  :init
  (evil-mode 1))

(use-package monokai-pro-theme
  :config 
  (load-theme 'monokai-pro t))

(use-package exwm)
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(require 'exwm-randr)
(add-hook 'exwm-randr-screen-change-hook
	  (lambda ()
	    (if (string= "true\n" (shell-command-to-string "xrandr | awk '/HDMI-2 connected/ {print \"true\"}'"))
		  (setq exwm-randr-workspace-output-plist '(0 "HDMI-2" 1 "eDP-1" 2 "HDMI-2" 3 "eDP-1" 4 "HDMI-2" 5 "eDP-1" 6 "HDMI-2" 7 "eDP-1" 8 "HDMI-2"))
		(setq exwm-randr-workspace-output-plist '(0 "eDP-1")))))
(setq exwm-workspace-warp-cursor t)
(setq exwm-workspace-number 8)
(exwm-randr-enable)
(require 'exwm-systemtray)
(exwm-systemtray-enable)


;; (require 'xml)
;; (defun test ()
;;   (let ((menu (with-temp-buffer
;; 		(insert (shell-command-to-string "xdgmenumaker -f compizboxmenu"))
;; 		(libxml-parse-xml-region (point-min) (point-max)))))
;;     (dolist (element (dom-by-tag menu 'menu))
;;       (print (cdr (car (nth 1 element)))))))


(server-start)

(defvar efs/polybar-process nil
  "Holds the process of the running Polybar instance, if any")

(defun efs/kill-panel ()
  (interactive)
  (when efs/polybar-process
    (ignore-errors
      (kill-process efs/polybar-process)))
  (setq efs/polybar-process nil))

(defun efs/start-panel ()
  (interactive)
  (efs/kill-panel)
  (setq efs/polybar-process (start-process-shell-command "polybar" nil "polybar --reload panel")))

(defun efs/send-polybar-hook (module-name hook-index)
  (start-process-shell-command "polybar-msg" nil (format "polybar-msg hook %s %s" module-name hook-index)))

(defun efs/send-polybar-exwm-workspace ()
(efs/send-polybar-hook "exwm-workspace" 1))

;; Update panel indicator when workspace changes
(add-hook 'exwm-workspace-switch-hook #'efs/send-polybar-exwm-workspace)
(efs/start-panel)
(defun run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(run-in-background "pasystray")
(run-in-background "nm-applet")
(run-in-background "picom --config /etc/xdg/picom.conf")
(run-in-background "xfsettingsd")
(run-in-background "xsetroot -cursor_name left_ptr")

(use-package display-line-numbers
  :init
  (global-display-line-numbers-mode t)
  :custom
  (display-line-numbers-type 'relative))

(use-package which-key
  :config
  (which-key-setup-side-window-bottom)
  :custom
  (which-key-idle-delay 0)
  :init
  (which-key-mode))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package diminish)

(use-package ivy
  :diminish ivy-mode
  :init
  (ivy-mode)
  :custom
  (ivy-use-virtual-buffer t)
  (enable-recursive-minibuffers t)
  :bind
  ("C-s" . 'swiper)
  ("C-c C-r" . 'ivy-resume)
  ("<f6>" . 'ivy-resume))

(use-package counsel
  :diminish counsel-mode
  :init
  (counsel-mode))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package company
  :diminish company-mode
)
;; LSP
(use-package lsp-mode
  :config
  (add-hook 'c-mode-hook #'lsp)
  (add-hook 'after-init-hook 'global-company-mode))

(use-package lsp-java 
  :config
  (add-hook 'java-mode-hook #'lsp))

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(global-auto-revert-mode 1)
(recentf-mode 1)

(use-package projectile
  :diminish projectile-mode
  :init
  (projectile-mode +1)
  :bind
  ("C-c p" . 'projectile-command-map))

(use-package counsel-projectile
  :init
  (counsel-projectile-mode))

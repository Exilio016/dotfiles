(tool-bar-mode -1)
(menu-bar-mode -1)

(when (>= emacs-major-version 24)
  (progn
    ;; load emacs 24's package system. Add MELPA repository.
    (require 'package)
    (add-to-list
     'package-archives
     '("melpa" . "https://melpa.org/packages/")
     t))

  (when (< emacs-major-version 27) (package-initialize)))

(require 'evil)
(evil-mode 1)

(load-theme 'monokai-pro t)

(setq explicit-shell-file-name "/usr/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '("--login" "--interactive"))
(defun zsh-shell-mode-setup ()
  (setq-local comint-process-echoes t))
(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)


(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(require 'exwm-randr)
(add-hook 'exwm-randr-screen-change-hook
	  (lambda ()
	    (if (string= "true\n" (shell-command-to-string "xrandr | awk '/HDMI-2 connected/ {print \"true\"}'"))
		(progn
		  (start-process-shell-command
		   "xrandr" nil "xrandr --output eDP-1 --mode 1600x900 --pos 1920x578 --rotate normal --output DP-1 --off --output HDMI-1 --off --output HDMI-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal")
		  (setq exwm-randr-workspace-output-plist '(0 "HDMI-2" 1 "eDP-1" 2 "HDMI-2" 3 "eDP-1" 4 "HDMI-2" 5 "eDP-1" 6 "HDMI-2" 7 "eDP-1" 8 "HDMI-2")))
	      (progn
		(start-process-shell-command
		 "xrandr" nil "xrand --output eDP-1 --mode 1600x900 --pos 0x0 --rotate normal")
		(setq exwm-randr-workspace-output-plist '(0 "eDP-1")))
		)))
(setq exwm-workspace-warp-cursor t)
(setq exwm-workspace-number 8)
(exwm-randr-enable)

(require 'xml)
(defun test ()
  (let ((menu (with-temp-buffer
		(insert (shell-command-to-string "xdgmenumaker -f compizboxmenu"))
		(libxml-parse-xml-region (point-min) (point-max)))))
    (dolist (element (dom-by-tag menu 'menu))
      (print (cdr (car (nth 1 element)))))))


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

(run-in-background "nm-applet")
(run-in-background "pasystray")
(run-in-background "picom --config $HOME/.config/picom.conf")

(global-display-line-numbers-mode t)
(which-key-setup-side-window-bottom)
(which-key-mode)
(setq which-key-idle-delay 0)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(ivy-mode)
(setq ivy-use-virtual-buffer t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(counsel-mode)
(require 'ivy-rich)
(ivy-rich-mode 1)

;; LSP
(add-hook 'c-mode-hook #'lsp)
(setq lsp-keymap-prefix "C-c l")
(add-hook 'after-init-hook 'global-company-mode)
(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(global-auto-revert-mode 1)
(recentf-mode 1)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(counsel-projectile-mode)


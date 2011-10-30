;;; Rails
(require 'anything-of-rails)

(defun current-buffer-rails-root ()
  (let ((rails-project-root (locate-dominating-file default-directory "Gemfile")))
    (when (and rails-project-root
               (file-exists-p (concat rails-project-root "config/application.rb")))
      (expand-file-name rails-project-root))))

(defun set-rails-minor-mode ()
  (if (current-buffer-rails-root)
      (rails-minor-mode t)))

(add-hook 'find-file-hook 'set-rails-minor-mode)
(add-hook 'dired-mode-hook 'set-rails-minor-mode)

(define-minor-mode rails-minor-mode
  "RubyOnRails"
  nil
  " RoR")

(provide 'rails)
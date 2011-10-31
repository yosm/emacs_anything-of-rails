;;; Rails
(require 'anything-of-rails)

(defun set-rails-minor-mode ()
  (when (current-buffer-rails-root)
    (rails-minor-mode t)))

(add-hook 'find-file-hook 'set-rails-minor-mode)
(add-hook 'dired-mode-hook 'set-rails-minor-mode)

(define-minor-mode rails-minor-mode
  "RubyOnRails"
  nil
  " RoR")

(provide 'rails)

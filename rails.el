;;; Rails
(require 'anything-of-rails)

(defun set-rails-minor-mode ()
  (when (current-buffer-rails-root)
    (rails-minor-mode t)))

(defvar rails-minor-mode-map
  (let ((map (make-keymap)))
    map))

(add-hook 'find-file-hook 'set-rails-minor-mode)
(add-hook 'dired-mode-hook 'set-rails-minor-mode)

(defvar anything-of-rails-boot-key (kbd "C-;"))

(define-key rails-minor-mode-map anything-of-rails-boot-key 'anything-of-rails)
(define-key anything-map anything-of-rails-boot-key 'abort-recursive-edit)

(define-minor-mode rails-minor-mode
  "RubyOnRails"
  nil
  " RoR"
  rails-minor-mode-map)

(provide 'rails)

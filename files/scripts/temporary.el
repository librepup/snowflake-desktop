(defun process-temporary-file ()
  "Process the 'Temporary' file."
  (interactive)
  ;; Delete the file if it exists
  (when (file-exists-p "~/.Temporary")
    (delete-file "~/.Temporary"))

  ;; Write new data to the file
  (with-temp-buffer
    (insert-file-literally "~/.Temporary")
    (write-region (point-min) (point-max))
    (switch-to-buffer "Temporary")))

  ;; Open the buffer and add a function to delete the frame
  (pop-to-buffer-same-window "Temporary")
  (add-hook 'delete-frame-functions
           (lambda (frame)
             (when (get-buffer "Temporary")
               (kill-buffer "Temporary"))))

;; Set the keybinding for Ctrl+S-r
(global-set-key (kbd "C-S-r") '(shell-command "bash ~/.Temporary"))

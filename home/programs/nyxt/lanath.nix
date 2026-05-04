{ pkgs, ... }:
{
  home.packages = [ pkgs.nyxt ];

  xdg.configFile."nyxt/config.lisp".text = ''
    (in-package #:nyxt-user)

    ;;; ---------------------------------------------------------
    ;;; Load theme managed by theme-switch
    ;;; ---------------------------------------------------------
    (let ((theme-file (merge-pathnames "theme.lisp" (files:config-directory))))
      (when (uiop:file-exists-p theme-file)
        (load theme-file)))

    ;;; ---------------------------------------------------------
    ;;; VSCode-style keybindings
    ;;; Override the default Emacs/vi maps with familiar shortcuts
    ;;; ---------------------------------------------------------
    (define-configuration buffer
      ((override-map
        (let ((map (make-keymap "vscode-map")))
          (define-key map
            ;; --- Tab / buffer management ---
            "C-t"       'make-buffer-focus
            "C-w"       'delete-current-buffer
            "C-shift-t" 'reopen-buffer
            "C-tab"     'switch-buffer-next
            "C-shift-tab" 'switch-buffer-previous

            ;; --- Navigation ---
            "M-left"    'history-backwards
            "M-right"   'history-forwards
            "C-l"       'set-url
            "C-r"       'reload-current-buffer
            "F5"        'reload-current-buffer

            ;; --- Command palette & search ---
            "C-shift-p" 'execute-command
            "C-p"       'switch-buffer
            "C-f"       'search-buffer
            "C-g"       'follow-hint

            ;; --- Bookmarks & history ---
            "C-d"       'bookmark-current-url
            "C-h"       'list-history
            "C-shift-b" 'list-bookmarks

            ;; --- Window ---
            "C-n"       'make-window

            ;; --- Zoom ---
            "C-equal"   'zoom-page
            "C-minus"   'unzoom-page
            "C-0"       'reset-page-zoom

            ;; --- CUA clipboard ---
            "C-c"       'copy
            "C-v"       'paste
            "C-x"       'cut
            "C-a"       'select-all
            "C-z"       'undo
            "C-shift-z" 'redo

            ;; --- Misc ---
            "F11"       'toggle-fullscreen)
          map))))

    ;;; ---------------------------------------------------------
    ;;; Readable follow-hint overlay
    ;;; ---------------------------------------------------------
    (define-configuration nyxt/mode/hint:hint-mode
      ((nyxt/mode/hint:hints-alphabet "ASDFGHJKL")
       (style (str:concat %slot-default%
                (theme:themed-css (theme *browser*)
                  ("nyxt-hint"
                   :font-size "14px"
                   :font-weight "bold"
                   :font-family "monospace"
                   :padding "2px 5px"
                   :border-radius "4px"
                   :box-shadow "0 1px 4px rgba(0,0,0,0.4)")
                  ("nyxt-hint.nyxt-select-hint"
                   :font-size "14px"
                   :font-weight "bold"))))))

    ;;; ---------------------------------------------------------
    ;;; Show all open buffers in the status bar
    ;;; ---------------------------------------------------------
    (define-configuration status-buffer
      ((style (str:concat %slot-default%
               (theme:themed-css (theme *browser*)
                 ("#buffer-list"
                  :display "flex"
                  :flex-grow "1"
                  :overflow-x "auto"
                  :white-space "nowrap"))))))

    (define-configuration window
      ((status-formatter
        (lambda (window)
          (let ((buffer (current-buffer window)))
            (markup:markup
             (:div :id "container"
              (:div :id "buffer-list"
               (loop for buf in (buffer-list)
                     collect
                     (markup:markup
                      (:span :class (if (eq buf buffer) "current-buffer" "other-buffer")
                             :style (if (eq buf buffer)
                                        "padding:2px 8px;font-weight:bold;border-bottom:2px solid;"
                                        "padding:2px 8px;opacity:0.6;")
                             (title buf)))))
              (:div :id "url"
               (render-url (url buffer)))))))))

    ;;; ---------------------------------------------------------
    ;;; Disable session restore (clean starts)
    ;;; ---------------------------------------------------------
    (define-configuration browser
      ((restore-session-on-startup-p nil)))

    ;;; Force dark mode on web content
    (define-configuration web-buffer
      ((default-modes (pushnew 'nyxt/mode/style:dark-mode %slot-value%))))
  '';
}

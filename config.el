;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yu Yang Chee"
      user-mail-address "yuyangchee98@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Menlo" :size 14 :weight 'regular)
       doom-variable-pitch-font (font-spec :family "Menlo" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Yu Yang's inclusions
;; CS magic that's supposed to fix the error "File mode specification error: (wrong-type-argument stringp |)"
(defun doom-buffer-has-long-lines-p ()
  (when comment-use-syntax
    (so-long-detected-long-line-p)))
(setq so-long-predicate #'doom-buffer-has-long-lines-p)
;;
;; "Hey that file change on disk; I'll reload"
(global-auto-revert-mode 1)
;; Org-capture enable
(server-start)
;; Org agenda files
(setq org-agenda-files (directory-files-recursively "~/Dropbox/org/" "\.org$"))
;; Org TODO keywords. Note ! for timestamping
(after! org
  (setq org-todo-keywords
        '((type "TODO(t!)" "WAITING(w!)" "CURRENT(c!)" "|" "DONE(d!)" "CANCELLED(x!)")
          (type "HABIT(h!)" "SUCCESS(s!)" "|" "FAILURE(f!)"))))
;; Org capture templates
(after! org
(setq org-capture-templates '(
("d" "Start your day" entry (function org-journal-find-location)
"* %(format-time-string org-journal-time-format) Episode: %^{Name your day}
* %(format-time-string org-journal-time-format) Planned day
** [/] Morning
- [ ] %?
- [ ]

** [/] Afternoon
- [ ]
- [ ]

** [/] Night
- [ ]
- [ ]

** [/] Habits
- [ ] Pocket
- [ ] Book
")
("j" "Journal" entry (function org-journal-find-location)
"* %(format-time-string org-journal-time-format) %^{Story name}
:Tags:
[[file:../Journal.org][Journal]]
:End:
%?")
("m" "Movies" entry (function org-journal-find-location)
"* %(format-time-string org-journal-time-format) Movie: %^{Movie Name}
:Tags:
[[file:../Movies.org][Movies]]
:End:

:Summary:
:End:

:Ratings:
/10
:End:

:Review:
%?
:End:")
("t" "TV Shows" entry (function org-journal-find-location)
"* %(format-time-string org-journal-time-format) TV Show and Episode: %^{TV Show and episode name}
:Tags:
[[file:../TV.org][TV]]
:End:

:Summary:
:End:

:Ratings:
/10
:End:

:Review:
%?
:End:")
("r" "Random thoughts" entry (function org-journal-find-location)
"* %(format-time-string org-journal-time-format) Random Thoughts: %^{Title}
:Tags:
[[file:../RandomThoughts.org][Random Thoughts]]
:End:
%?")
("L" "Links" entry (function org-journal-find-location)
 "* %(format-time-string org-journal-time-format) %? [[%:link][%:description]] \nCaptured On: %U")
("p" "Partial link" entry (function org-journal-find-location)
 "* %(format-time-string org-journal-time-format) %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
("o" "Others" entry (function org-journal-find-location)
"* %(format-time-string org-journal-time-format) %^{Title}
:Tags:
%?
:End:
%?"))))
;; Org roam
;;   Configure package
(use-package org-roam
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/Dropbox/org")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-show-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))))
;;   Index file
(setq org-roam-index-file "~/Dropbox/org/index.org")
;;   Org-roam completion system
(setq org-roam-completion-system 'default)
;;   Org-roam capturing template
(setq org-roam-capture-templates '(("d" "default" plain (function org-roam--capture-get-point)
     "%?"
     :file-name "${slug}"
     :head "#+TITLE: ${title}\n#+DATE: %<%Y-%m-%d %H:%M:%S>"
     :unnarrowed t)))
;; Org-journal
;; Org journal carry over list
(setq org-journal-carryover-items "TODO=\"TODO\"|TODO=\"HABIT\"")
;; Org journal configuration
(use-package org-journal
      :bind
      ("C-c n j" . org-journal-new-entry)
      :custom
      (org-journal-dir "~/Dropbox/org/daily")
      (org-journal-date-prefix "#+TITLE: ")
      (org-journal-file-format "%Y-%m-%d.org")
      (org-journal-date-format "%A, %d %B %Y"))
;; Org-super-agenda
(use-package org-super-agenda
  :after org-agenda
  :bind
  ("C-c a" . org-agenda)
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:log t)
                            (:name "Next to do"
                                   :todo "NEXT"
                                   :order 1)
                            (:name "Today's tasks"
                                   :file-path "daily/")
                            (:name "Due Today"
                                   :deadline today
                                   :order 2)
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 8)
                            (:name "Overdue"
                                   :deadline past
                                   :order 7)
                            (:discard (:not (:todo "TODO")))))))))))
  :config
  (org-super-agenda-mode))
;; Org journal custom templates using org capture
(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))
;; Org capture hotkey
(use-package org
  :bind
  ("C-c c" . org-capture))
;;
;; Deft
(use-package deft
      :after org
      :bind
      ("C-c n d" . deft)
      :custom
      (deft-recursive t)
      (deft-use-filter-string-for-filename t)
      (deft-default-extension "org")
      (deft-directory "~/Dropbox/org"))

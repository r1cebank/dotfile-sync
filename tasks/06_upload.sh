#!/usr/bin/env bash

function upload_init() {
  task_setup "upload" "Upload" "Upload settings" "gathering_info gnome_settings dotfiles dotconfig packages app_setting"
}

function upload_run() {
  PLATFORM=$(settings_get "PLATFORM")
  if [ "$PLATFORM" = "linux" ]; then
        # Get temp dir
        tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
        branch_name="$(date +"%m-%d-%y")-$(cat /proc/sys/kernel/hostname)"
        commit_message="$(date +"%m-%d-%y %H:%M:%S")"
        git_repo=$(enter_variable " - Where is the data repo? (git@github.com:r1cebank/dotfile-sync-data.git)" "git@github.com:r1cebank/dotfile-sync-data.git")
        git clone $git_repo $tmp_dir
        ( cd $tmp_dir; git checkout -b $branch_name; )
        cp -r ./settings $tmp_dir
        ( cd $tmp_dir; git add -A; )
        ( cd $tmp_dir; git commit -m "$commit_message"; )
        ( cd $tmp_dir; git push -u origin $branch_name; )
        log_info "Data pushed to repo"
  else
    log_warning "Unsupported OS"
  fi
  return ${E_SUCCESS}
}

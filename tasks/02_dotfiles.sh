#!/usr/bin/env bash

function dotfiles_init() {
  task_setup "dotfiles" "Dotfiles" "Copy settings" "gathering_info"
}

function dotfiles_run() {
  PLATFORM=$(settings_get "PLATFORM")
  if [ "$PLATFORM" = "linux" ]; then
    # Copy over dotfiles
    mkdir -p ./settings/dotfiles
    while read in; do
        [[ $in == !* ]] && continue
        cp "$HOME/$in" ./settings/dotfiles
    done < ./dotfiles/dotfile_paths
  else
    log_warning "Unsupported OS"
  fi
  return ${E_SUCCESS}
}

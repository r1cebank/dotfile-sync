#!/usr/bin/env bash

function dotconfig_init() {
  task_setup "dotconfig" ".config" "Copy .config" "gathering_info"
}

function dotconfig_run() {
  PLATFORM=$(settings_get "PLATFORM")
  if [ "$PLATFORM" = "linux" ]; then
    # Copy over configs
    mkdir -p ./settings/config/Code
    mkdir -p ./settings/config/plank
    mkdir -p ./settings/config/fcitx
    mkdir -p ./settings/config/gnupg
    while read in; do
        [[ $in == !* ]] && continue
        cp "$HOME/.config/$in" ./settings/config/Code
    done < ./code/config_paths
    while read in; do
        [[ $in == !* ]] && continue
        cp -r "$HOME/.config/$in" ./settings/config/plank
    done < ./plank/dock_paths
    while read in; do
        [[ $in == !* ]] && continue
        cp -r "$HOME/.config/$in" ./settings/config/fcitx
    done < ./fcitx/config_paths
    while read in; do
        [[ $in == !* ]] && continue
        cp -r "$HOME/$in" ./settings/config/gnupg
    done < ./gnupg/config_paths
  else
    log_warning "Unsupported OS"
  fi
  return ${E_SUCCESS}
}

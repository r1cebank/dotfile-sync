#!/usr/bin/env bash

function packages_init() {
  task_setup "packages" "Packages" "Get package list" "gathering_info"
}

function packages_run() {
  PLATFORM=$(settings_get "PLATFORM")
  if [ "$PLATFORM" = "linux" ]; then
        # Check os type
        if hash apt >/dev/null 2>&1; then
            makdir -p ./settings/apt
            apt list --installed > ./settings/apt/apt.list
        fi
        if hash pacman >/dev/null 2>&1; then
            mkdir -p ./settings/pacman
            pacman -Qm | cut -f 1 -d " " > ./settings/pacman/aur.list
            pacman -Q | cut -f 1 -d " " > ./settings/pacman/pacman.list
        fi
  else
    log_warning "Unsupported OS"
  fi
  return ${E_SUCCESS}
}

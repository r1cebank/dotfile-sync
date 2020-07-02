#!/usr/bin/env bash

function gnome_settings_init() {
  task_setup "gnome_settings" "Gnome" "Export Gnome settings" "gathering_info"
}

function gnome_settings_run() {
  PLATFORM=$(settings_get "PLATFORM")
  if [ "$PLATFORM" = "linux" ]; then
    # Dump dconf settings
    mkdir -p ./settings/gnome
    while read in; do
        [[ $in == !* ]] && continue
        dconf dump $in > "./settings/gnome/$(sed 's/\//_/g' <<< $in)"
    done < ./gnome/dconf_paths
  else
    log_warning "Unsupported OS"
  fi
  return ${E_SUCCESS}
}

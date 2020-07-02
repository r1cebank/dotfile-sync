#!/usr/bin/env bash

function app_setting_init() {
  task_setup "app_setting" "App settings" "Get app settings" "gathering_info"
}

function app_setting_run() {
  PLATFORM=$(settings_get "PLATFORM")
  if [ "$PLATFORM" = "linux" ]; then
    if hash code >/dev/null 2>&1; then
        mkdir -p ./settings/code
        code --list-extensions > ./settings/code/extensions.list
    else
        log_warning "Did not find code, skipping..."
    fi
    if hash gnome-shell >/dev/null 2>&1; then
        mkdir -p ./settings/gnome
        sed -E -e "s/\[|\]| //g" <<< $(sed "s/'//g" <<< $(sed "s/',/\n/g" <<< $(gsettings get org.gnome.shell enabled-extensions))) > ./settings/gnome/extensions.list
    else
        log_info "Did not find gnome, skipping..."
    fi
    if hash npm >/dev/null 2>&1; then
        mkdir -p ./settings/npm
        npm list -g --depth 0 --parseable | awk '{gsub(/\/.*\//,"",$1); print}'| sort -u > ./settings/npm/packages.list
    else
        log_info "Did not find npm, skipping..."
    fi
  else
    log_warning "Unsupported OS"
  fi
  return ${E_SUCCESS}
}

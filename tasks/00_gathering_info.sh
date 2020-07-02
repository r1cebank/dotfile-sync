#!/usr/bin/env bash

function gathering_info_init() {
  task_setup "gathering_info" "Gather Info" "Gather system info"

  settings_init ".settings"
}

function gathering_info_run() {
  # Platform detection
  # Mainly to differentiate between OS X, Ubuntu and CentOS
  PLATFORM=$(uname | tr "[:upper:]" "[:lower:]")
  settings_set "PLATFORM" $PLATFORM

  # Create directory
  mkdir -p ./settings

  return ${E_SUCCESS}
}

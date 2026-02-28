#!/usr/bin/env bash

export LOG_FILE="/var/log/exarchy-install.log"
touch "$LOG_FILE"

run_logged() {
  local script="$1"
  info "Running: $(basename "$script")"
  bash "$script" 2>&1 | tee -a "$LOG_FILE"
}

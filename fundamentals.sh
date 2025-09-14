#!/usr/bin/env bash
# fundamentals.sh - Small interactive script demonstrating Linux basics for DevOps practice
# Author: Pallavi (you can replace the name)
# Usage: ./fundamentals.sh

# Safety: fail on error, undefined var, and catch pipe errors
set -o errexit
set -o nounset
set -o pipefail

# ---------- helper functions ----------

print_header() {
  printf "\n=== Linux Fundamentals Utility ===\n"
  printf "Topics: ps, kill, chmod, package-install (brew), vim\n\n"
}

print_menu() {
  cat <<'MENU'
Choose an option:
  1) List running processes (ps)
  2) Start a test background process (sleep) for experiment
  3) Kill a process by PID
  4) Show file permissions (ls -l)
  5) Change file permissions (chmod)
  6) Install a package (uses brew on macOS if available)
  7) Open a file in vim
  8) Show environment variables (printenv)
  9) Exit
MENU
}

list_processes() {
  # show a compact list and hint how to use grep
  echo "Listing top processes (ps aux | head -n 20):"
  ps aux | head -n 20
  echo -e "\nTip: to find a process, use: ps aux | grep <name>"
}

start_test_process() {
  # start a background sleep process (for testing kill)
  echo "Starting test background process: sleep 600 &"
  sleep 600 &
  echo "Started sleep process (background). Use option 1 to see it and option 3 to kill it."
}

kill_process_by_pid() {
  read -rp "Enter PID to kill: " pid
  if [[ ! "$pid" =~ ^[0-9]+$ ]]; then
    echo "Invalid PID. Only numbers allowed."
    return
  fi
  echo "Process info (ps -p $pid -o pid,user,cmd):"
  ps -p "$pid" -o pid,user,cmd
  read -rp "Are you sure you want to send SIGTERM to PID $pid? (y/N) " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    kill -15 "$pid" && echo "SIGTERM sent to $pid"
    sleep 1
    if ps -p "$pid" > /dev/null 2>&1; then
      echo "Process still running. You may force kill with SIGKILL (kill -9)."
      read -rp "Force kill now? (y/N) " fk
      if [[ "$fk" =~ ^[Yy]$ ]]; then
        kill -9 "$pid" && echo "SIGKILL sent to $pid"
      fi
    else
      echo "Process terminated."
    fi
  else
    echo "Cancelled."
  fi
}

show_permissions() {
  read -rp "Enter file path to view permissions: " f
  if [[ ! -e "$f" ]]; then
    echo "File does not exist: $f"
    return
  fi
  ls -l "$f"
}

change_permissions() {
  read -rp "Enter file path to change permissions: " f
  if [[ ! -e "$f" ]]; then
    echo "File does not exist: $f"
    return
  fi
  echo "Current permissions:"
  ls -l "$f"
  read -rp "Enter chmod mode (e.g. 644 or u+x or a-w): " mode
  echo "About to run: chmod $mode $f"
  read -rp "Proceed? (y/N) " c
  if [[ "$c" =~ ^[Yy]$ ]]; then
    chmod "$mode" "$f" && echo "Permissions updated:" && ls -l "$f"
  else
    echo "Cancelled."
  fi
}

install_package() {
  read -rp "Enter package name to install (e.g., wget): " pkg
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew detected. Installing with: brew install $pkg"
    brew install "$pkg"
  else
    echo "Homebrew not found on this system."
    echo "Simulating install: you'd run 'brew install $pkg' on macOS, or 'apt install $pkg' on Debian/Ubuntu, 'yum install $pkg' on RHEL/CentOS."
  fi
}

open_vim() {
  read -rp "Enter file path to open in vim (it will be created if missing): " f
  if [[ -z "$f" ]]; then
    echo "No file provided."
    return
  fi
  vim "$f"
}

show_env() {
  echo "Environment variables (printenv | sort | head -n 50):"
  printenv | sort | head -n 50
}

# ---------- main loop ----------
while true; do
  print_header
  print_menu
  read -rp "Enter choice [1-9]: " choice
  case "$choice" in
    1) list_processes ;;
    2) start_test_process ;;
    3) kill_process_by_pid ;;
    4) show_permissions ;;
    5) change_permissions ;;
    6) install_package ;;
    7) open_vim ;;
    8) show_env ;;
    9) echo "Goodbye!"; exit 0 ;;
    *) echo "Invalid option. Enter 1-9." ;;
  esac
  echo
  read -rp "Press Enter to continue..." dummy
done


#!/usr/bin/env bash
# OMNix - System Management Menu
# A simple TUI menu for common NixOS management tasks.

# ANSI ESCAPE SEQUENCES
RESET="\033[0m"
BOLD="\033[1m"

FG="\033[38;2;"
BG="\033[48;2;"

DARK_GRAY="40;42;46m"
GRAY="55;59;65m"
WHITE="255;255;255m"

function print_menu {
  local cols
  cols=$(tput cols)
  local rows
  rows=$(tput lines)

  local pos_x
  pos_x=$((cols / 2 - 39))
  local pos_y
  pos_y=$((rows / 2 - 16))

  clear

  tput cup $((pos_y)) $((pos_x))
  printf "${RESET}${FG}${GRAY}"
  printf "┌───────────────────┬──────────────────┬──────────────────┬──────────────────┐"
  tput cup $((pos_y + 1)) $((pos_x))
  printf "│                   │                  │                  │                  │"
  tput cup $((pos_y + 2)) $((pos_x))
  printf "└───────────────────┴──────────────────┴──────────────────┴──────────────────┘"

  tput cup $((pos_y + 1)) $((pos_x + 8))
  printf "${RESET}${BOLD}${FG}${WHITE}OMNix"
}

print_menu

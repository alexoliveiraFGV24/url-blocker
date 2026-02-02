#!/bin/bash

ENV_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.env"

if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo ".env não encontrado"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BLOCK_SCRIPT="$SCRIPT_DIR/block.sh"
UNBLOCK_SCRIPT="$SCRIPT_DIR/unblock.sh"

START_HOUR=22
END_HOUR=6

HOSTS_FILE="/etc/hosts"
START_MARK="# >>> URL-BLOCKER START >>>"

if [ "$EUID" -ne 0 ]; then
  echo "Execute com sudo"
  exit 1
fi

CURRENT_HOUR=$(date +%H)

is_block_active() {
  grep -q "$START_MARK" "$HOSTS_FILE"
}

should_block() {
  if [ "$START_HOUR" -lt "$END_HOUR" ]; then
    [ "$CURRENT_HOUR" -ge "$START_HOUR" ] && [ "$CURRENT_HOUR" -lt "$END_HOUR" ]
  else
    [ "$CURRENT_HOUR" -ge "$START_HOUR" ] || [ "$CURRENT_HOUR" -lt "$END_HOUR" ]
  fi
}

if should_block; then
  if ! is_block_active; then
    "$BLOCK_SCRIPT"
  fi
else
  if is_block_active; then
    "$UNBLOCK_SCRIPT"
  fi
fi
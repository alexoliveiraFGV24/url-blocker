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

HOSTS_FILE="/etc/hosts"
START_MARK="# >>> URL-BLOCKER START >>>"
END_MARK="# <<< URL-BLOCKER END <<<"

# Precisa ser root
if [ "$EUID" -ne 0 ]; then
  echo "Execute com sudo"
  exit 1
fi

sed -i "/$START_MARK/,/$END_MARK/d" "$HOSTS_FILE"

echo "URLs desbloqueadas com sucesso."
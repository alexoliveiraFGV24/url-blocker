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

# Diretório raiz do projeto
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC_DIR="$ROOT_DIR/src"

case "$1" in
  block)
    sudo "$SRC_DIR/block.sh"
    ;;
  unblock)
    sudo "$SRC_DIR/unblock.sh"
    ;;
  auto)
    sudo "$SRC_DIR/scheduler.sh"
    ;;
  status)
    if grep -q "# >>> URL-BLOCKER START >>>" /etc/hosts; then
      echo "Status: BLOQUEIO ATIVO"
    else
      echo "Status: BLOQUEIO INATIVO"
    fi
    ;;
  *)
    echo "Uso:"
    echo "  ./main.sh block"
    echo "  ./main.sh unblock"
    echo "  ./main.sh auto"
    echo "  ./main.sh status"
    ;;
esac
#!/usr/bin/env bash
# Quick entry into the lab container.
set -euo pipefail

if ! docker compose ps --services --filter status=running | grep -q ubuntu-learn; then
  echo "Container is not running. Starting it…"
  docker compose up -d
fi

exec docker compose exec ubuntu-learn zsh

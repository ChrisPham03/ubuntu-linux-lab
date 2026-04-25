#!/usr/bin/env bash
# ============================================================================
#  Ubuntu Linux Lab — first-time setup script
#  Checks prerequisites, builds the image, and starts the container.
# ============================================================================
set -euo pipefail

bold()  { printf "\033[1m%s\033[0m\n" "$*"; }
ok()    { printf "\033[32m✓\033[0m %s\n" "$*"; }
warn()  { printf "\033[33m!\033[0m %s\n" "$*"; }
err()   { printf "\033[31m✗\033[0m %s\n" "$*" >&2; }

bold "Ubuntu Linux Lab — setup"
echo

# 1) Docker present?
if ! command -v docker >/dev/null 2>&1; then
  err "Docker is not installed."
  echo "   Install Docker Desktop for Mac:"
  echo "   https://www.docker.com/products/docker-desktop/"
  echo "   Or the faster OrbStack alternative:"
  echo "   https://orbstack.dev"
  exit 1
fi
ok "Docker found: $(docker --version)"

# 2) Docker running?
if ! docker info >/dev/null 2>&1; then
  err "Docker daemon is not running. Please start Docker Desktop (or OrbStack)."
  exit 1
fi
ok "Docker daemon is running"

# 3) Architecture info (nice-to-know)
ARCH="$(uname -m)"
case "$ARCH" in
  arm64|aarch64) ok "Detected Apple Silicon (arm64) — native performance" ;;
  x86_64)        warn "Detected Intel Mac (x86_64) — will still work" ;;
  *)             warn "Unknown architecture: $ARCH" ;;
esac

# 4) Build image
echo
bold "Building lab image (first run takes a few minutes)…"
docker compose build

# 5) Start container
echo
bold "Starting the lab…"
docker compose up -d

echo
ok "Done!"
echo
echo "  Enter the lab with:    make shell"
echo "  Stop the lab with:     make down"
echo "  All commands:          make help"
echo

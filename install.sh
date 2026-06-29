#!/usr/bin/env bash

set -euo pipefail

BASH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_success()  {
    echo -e "${GREEN}[✓]${NC} $*";
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $*";
}

log_error() {
    echo -e "${RED}[✗]${NC} $*";
}

log_info()  {
    echo -e "${BLUE}[INFO]${NC} $*";
}

log_header()  {
    echo -e "\n${MAGENTA}═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}";
    echo -e "${MAGENTA}  $*${NC}";
    echo -e "${MAGENTA}═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}\n";
}

cmd_exists() {
    command -v "$1" &>/dev/null
}

service_active() {
    systemctl is-active --quiet "$1" 2>/dev/null
}

random_password() {
    openssl rand -base64 24 | tr -dc 'a-zA-Z0-9!@#$%^&*()_+' | head -c 24
}

system_check() {
# Check os
echo $(cat /etc/os-release 2>/dev/null || lsb_release -a 2>/dev/null || uname -a)

# Check existing package manager and installed LAMP packages
echo $(which apt dpkg yum dnf pacman zypper emerge 2>/dev/null;)

# Check current user
echo $(whoami)

# Check if any LAMP packages are installed
echo $(apt list --installed 2>/dev/null | grep -iE 'apache|mysql|mariadb|php|node|nginx' | head -20)

# Check sudo access
echo $(sudo -n echo "can sudo" 2>&1 || echo "no passwordless sudo")
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

backup_server() {
    local server="$1"

    if [[ -e "$server" ]]; then
        mkdir -p "$BASH_DIR/backup"
        
        local file
        file="${BASH_DIR}/backup/$(date +%s).zip"

        zip -r "$file" "$server"

        log_info "Backed up $file"
    fi
}

confirm() {
    local prompt="${1:-Continue?} [Y/n] "
    local reply
    read -r -p "$(echo -e "${YELLOW}${prompt}${NC}")" reply
    case "$reply" in
        [nN][oO]|[nN]) return 1 ;;
        *) return 0 ;;
    esac
}

run_setup() {
    local path="$1"
    local setup_path="$BASH_DIR/scripts/$path"

    if [[ ! -f "$setup_path" ]]; then
        log_warn "Setup '$path' not found, skipping"
        return 1
    fi

    log_header "Setup: ${path}"
    source "$setup_path"
    log_success "Setup '${path}' completed"
}

# ─── Run setup ──────────────────────────────────────────────────────────────

echo "Running..."
sleep 1

apt-get update && apt-get upgrade -y

apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano quota ufw

run_setup "00.env.sh"
run_setup "01.software.sh"
run_setup "02.openserver.sh"

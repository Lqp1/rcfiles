#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        -d|--dry-run)
            DRY_RUN=true
            ;;
    esac
done

echo -e "${BLUE}=== Starting rcfiles Uninstallation Script ===${NC}"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}*** DRY RUN MODE ENABLED *** (No files will be modified or deleted)${NC}\n"
else
    echo -e "${YELLOW}This script will remove configuration files and settings added by the rcfiles Ansible playbook.${NC}"
    echo -e "${YELLOW}Note: Directories will not be deleted (except font and cliclick directories), only individual files/symlinks.${NC}"
    read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Uninstallation aborted.${NC}"
        exit 1
    fi
fi

# Wrapper to check if a path is a symlink pointing to the Nix store
is_nix_store_link() {
    local target="$1"
    if [ -L "$target" ]; then
        local link_target
        # Try to resolve to absolute path using realpath first (cross-platform), fallback to readlink
        link_target=$(realpath "$target" 2>/dev/null || readlink "$target" 2>/dev/null || true)
        if [[ "$link_target" == /nix/store/* ]]; then
            return 0 # True
        fi
    fi
    return 1 # False
}

# safe_remove wrapper function (only removes files and symlinks, unless allow_dir is true)
safe_remove() {
    local target="$1"
    local allow_dir="${2:-false}"
    
    # Check if target exists (or is a broken symlink)
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        return 0
    fi

    # Check if it is a symlink to the Nix store
    if is_nix_store_link "$target"; then
        echo -e "${BLUE}[Skipped] $target is a symlink to Nix store (${NC}$(readlink "$target")${BLUE})${NC}"
        return 0
    fi
    
    # Check if it is a directory (and not a symlink)
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        if [ "$allow_dir" != "true" ]; then
            echo -e "${BLUE}[Skipped] $target is a directory (directories are not removed)${NC}"
            return 0
        fi
        
        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}[Dry-run] Would remove directory: $target${NC}"
        else
            rm -rf "$target"
            echo -e "${GREEN}[Removed directory] $target${NC}"
        fi
        return 0
    fi
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[Dry-run] Would remove file: $target${NC}"
    else
        rm -f "$target"
        echo -e "${GREEN}[Removed file] $target${NC}"
    fi
}

# 1. Clean up Zsh & Oh My Zsh files
echo -e "${YELLOW}Cleaning up Zsh configurations...${NC}"
safe_remove "$HOME/.zshrc"
safe_remove "$HOME/.zshenv"
safe_remove "$HOME/.zprofile"

# 2. Clean up Vim files
echo -e "${YELLOW}Cleaning up Vim configurations...${NC}"
safe_remove "$HOME/.vimrc"
safe_remove "$HOME/.vim/colors/solarized.vim"
safe_remove "$HOME/.vim/autoload/plug.vim"

# 3. Clean up other core configuration files
echo -e "${YELLOW}Cleaning up core configuration files...${NC}"
safe_remove "$HOME/.screenrc"
safe_remove "$HOME/.ripgreprc"
safe_remove "$HOME/.bash_aliases"
safe_remove "$HOME/.curlrc"
safe_remove "$HOME/.gitignore"
safe_remove "$HOME/.gitattributes"
safe_remove "$HOME/.bash_profile"
safe_remove "$HOME/.bashrc"
safe_remove "$HOME/.profile"
safe_remove "$HOME/.ansible_git_commit"

# 4. Clean up copied/templated files inside custom directories
echo -e "${YELLOW}Cleaning up custom directory files...${NC}"
safe_remove "$HOME/.aliases/fzf-git.sh"
safe_remove "$HOME/.aliases/10vgrep"
safe_remove "$HOME/.aliases/11bat"
safe_remove "$HOME/.aliases/05secrets"
safe_remove "$HOME/.aliases/00common"
safe_remove "$HOME/.config/eza/theme.yml"
safe_remove "$HOME/.profile.d/10kitty"
safe_remove "$HOME/.profile.d/20nix"
safe_remove "$HOME/bin/cliclick"
safe_remove "$HOME/.local/cliclick" "true"
safe_remove "/tmp/cliclick-$(whoami).zip"
safe_remove "$HOME/bin/haz-nix-release"

# 5. Clean up UI configuration files (Window Manager, Bar, Terminals, Aesthetics)
echo -e "${YELLOW}Cleaning up UI configuration files...${NC}"
safe_remove "$HOME/.config/kitty/current-theme.conf"
safe_remove "$HOME/.config/i3/config"
safe_remove "$HOME/.config/picom.conf"
safe_remove "$HOME/.config/kitty/kitty.conf"
safe_remove "$HOME/.config/polybar/config.ini"
safe_remove "$HOME/.config/dunst/dunstrc"
safe_remove "$HOME/.config/rofi/config.rasi"
safe_remove "$HOME/.config/kitty/ssh.conf"
safe_remove "$HOME/.config/redshift.conf"
safe_remove "$HOME/.Xresources"
safe_remove "$HOME/.config/xfce4/terminal/accels.scm"
safe_remove "$HOME/.sshbashrc"
safe_remove "$HOME/.config/systemd/user/i3-session.target"
safe_remove "$HOME/.config/polybar/custom"
safe_remove "$HOME/.config/i3/autostart.sh"
safe_remove "$HOME/.gtkrc-2.0"
safe_remove "$HOME/.config/gtk-3.0/settings.ini"

# macOS Specific Cocoa Keyboard Layout configuration cleanup
safe_remove "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

# 6. Clean up installed font files and directories
echo -e "${YELLOW}Removing fonts installed by the playbook...${NC}"
safe_remove "$HOME/.local/share/fonts/fira-code" "true"
safe_remove "$HOME/.local/share/fonts/NotoSansMono" "true"
safe_remove "$HOME/.local/share/fonts/NotoColorEmoji.ttf"
safe_remove "$HOME/.local/share/fonts/Fira Code Nerd Font.ttf"

if command -v fc-cache &> /dev/null; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[Dry-run] Would update system font cache (fc-cache -f)${NC}"
    else
        echo -e "${YELLOW}Updating system font cache...${NC}"
        fc-cache -f
    fi
fi

# 7. Clean up user desktop and shortcut files
echo -e "${YELLOW}Cleaning up Desktop shortcut launchers and configurations...${NC}"
# Handle both French (Bureau) and English (Desktop) default layouts
safe_remove "$HOME/Bureau/tv.desktop"
safe_remove "$HOME/Desktop/tv.desktop"
safe_remove "$HOME/Bureau/Fake.desktop"
safe_remove "$HOME/Desktop/Fake.desktop"
safe_remove "$HOME/.smount/01personal"

# 8. Clean up Git configuration file
echo -e "${YELLOW}Removing Git global configuration file (~/.gitconfig)...${NC}"
safe_remove "$HOME/.gitconfig"

echo -e "${GREEN}=== Uninstallation Finished! ===${NC}"

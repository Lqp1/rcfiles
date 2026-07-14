# rcfiles

> [!IMPORTANT]
> **This repository is archived.**
> The contents of this repository have been migrated directly to [lqp1/nix-configs](https://github.com/lqp1/nix-configs).

This repository previously hosted personal dotfiles and system configurations managed via Ansible. All system-wide and user-side configurations (including dotfiles and CLI environment settings) have been unified and rewritten using Nix and Home Manager.

For the latest configurations, please visit [lqp1/nix-configs](https://github.com/lqp1/nix-configs).

---

# Original README (Archived)

My personal, reproducible dotfiles and system configurations managed via Ansible.

This repository is a **user-side complement** to my system-wide configuration. While system-wide packages, services, and core OS configurations are managed entirely by Nix (via NixOS or nix-darwin) in my [nix-configs repository](https://github.com/Lqp1/nix-configs/), *this* repository uses Ansible to automate the deployment of my personal dotfiles, command-line environment, and desktop UI (like i3).

*(Note: In the future, the contents of this repository will likely be migrated into a [Home Manager](https://github.com/nix-community/home-manager) module to unify the configuration stack).*

## 📦 Features & Roles

The playbook is structured into modular roles:

### `common` (CLI Environment)
Sets up the core terminal experience:
* **Shell**: ZSH with Oh-My-ZSH, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `zsh-autoenv`.
* **Tools**: `eza` (modern `ls` replacement), `fzf` (fuzzy finder), and optimized `git` & `curl` configs.
* **Editors**: Neovim (with LazyVim config) and classic Vim.
* **macOS specific**: Installs `cliclick` for automation.

### `common_ui` (Desktop Environment)
Configures a complete tiling window manager setup (primarily for Linux):
* **Window Manager**: i3wm with `i3autotiling`.
* **Bar & Notifications**: Polybar and Dunst.
* **Terminal**: Kitty terminal with custom themes and hints config.
* **Launchers & Menus**: Rofi (custom xresources theme) and Splatmoji.
* **Aesthetics**: Picom compositor, GTK 2/3 themes (Arc-Dark, Papirus), and custom cursors.
* **Fonts**: Fira Code, Noto Sans Mono, Noto Color Emoji, and Nerd Fonts (securely downloaded with SHA256 verification).

### `user` (Personal Setup)
Configures user-specific tools and integrations:
* **Networking**: SSH bastion jump hosts, Samba/CIFS mounts (`user_smount_config`).
* **Security & Checking**: Clones tools like `spectre-meltdown-checker` and `kconfig-hardened-check`.

### `nix` (Nix Environment)
Integrates the system with the Nix package manager:
* Sets up Nix profile variables.
* (Assumes Nix is already installed on the target system).

## 🚀 Usage

### 1. Clone the repository
Make sure your SSH keys are in place, then clone the repo with all its submodules (used for Vim and FZF plugins):
```bash
git clone --recursive https://github.com/lqp1/rcfiles
cd rcfiles
```

### 2. Configure variables
Review the variables before running:
```bash
# Edit global variables
vim group_vars/all.yml

# Remove or edit local overrides
rm host_vars/localhost.yml 
```

### 3. Deploy
Run the Ansible playbook to provision your system:
```bash
ansible-playbook deploy.yml --ask-vault-pass
```

> [!TIP]
> **Minimal Mode**: You can run the playbook with the `minimal: true` variable to install a lightweight version. This skips Oh-My-Zsh, FZF, Splatmoji, and all UI configurations, making it perfect for servers or constrained environments.

## 🔒 Security & Maintenance

* **Automated Updates**: This repository uses a custom Python script (`scripts/detect_bumps.py`) running via GitHub Actions to automatically detect and bump third-party package and font versions every week.
* **Checksum Verification**: External downloads (fonts, zipped binaries) are verified against strict SHA256 checksums to protect against supply chain attacks.

## 📸 Screenshots

Here are a few glimpses of the desktop environment:

<div align="center">
  <img src="https://github.com/lqp1/rcfiles/blob/master/doc/screenshot.png?raw=true" alt="i3 and polybar setup" width="250"/>
  <img src="https://github.com/lqp1/rcfiles/blob/master/doc/screenshot2.png?raw=true" alt="exa listing" width="250"/>
  <img src="https://github.com/lqp1/rcfiles/blob/master/doc/screenshot3.png?raw=true" alt="vgrep and fzf setup" width="250"/>
</div>

## 🙏 Credits

* The Polybar theme is heavily inspired by [adi1090x/polybar-themes](https://github.com/adi1090x/polybar-themes) with slight modifications.
* A huge thanks to the creators of the awesome fonts used here (Noto, Fira Code, and Nerd Fonts).

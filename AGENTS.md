# AGENTS.md - Exarchy Project Guidelines

This document provides guidelines for agents working on the Exarchy project - an Arch Linux installation automation system.

## Project Overview

Exarchy is a Bash-based Arch Linux installation automation system. It provides a modular, phase-based installation process for setting up Arch Linux with encryption, CachyOS repositories, and Hyprland desktop environment.

## Build/Test Commands

### Main Installation
```bash
# Run the full installation (requires root, will format disks)
sudo ./install.sh

# Run in dry-run/test mode (check syntax without executing)
bash -n install.sh
bash -n install/*.sh
bash -n install/**/*.sh
```

### Single Module Testing
```bash
# Test a single module (e.g., disk-setup)
source install/helpers/all.sh
run_logged install/disk-setup/all.sh

# Test a specific component within a module
bash -x install/disk-setup/partition.sh

# Test with environment variables set
export DISK="/dev/vda"
export HOSTNAME="exarchy-test"
export USERNAME="testuser"
export PASSWORD="testpass"
source install/disk-setup/all.sh
```

### VM Testing (Safe Destructive Operations)
```bash
# Create test VM with virtual disk (e.g., using QEMU/VirtualBox)
# Download repo to Arch installation medium in VM
git clone https://github.com/yourusername/exarchy.git
cd exarchy

# Test installation with safe disk (e.g., /dev/vdb or /dev/sdb)
# Simulate disk operations without actual hardware
export DISK="/dev/null"
bash -x install/disk-setup/partition.sh
```

### Shell Script Testing
```bash
# Check shell script syntax (install shellcheck first)
sudo pacman -S shellcheck

# Run shellcheck on specific files
shellcheck install.sh
shellcheck install/*.sh
shellcheck install/**/*.sh

# Run shellcheck on a single file
shellcheck install/helpers/prompts.sh

# Run specific script with debugging enabled
bash -x install/helpers/prompts.sh 2>&1 | tee debug.log

# Test LUKS module simulation (without actual disk operations)
echo "testpassword" | cryptsetup luksFormat --test-passphrase /dev/null
```

### Pre-flight Checks
```bash
# Check if running as root (required for installation)
[ "$EUID" -eq 0 ] && echo "Running as root" || echo "Not root"

# Verify UEFI system
ls /sys/firmware/efi/efivars

# Check network connectivity
ping -c 3 archlinux.org
```

### Git Operations
```bash
# View recent changes
git log --oneline -10

# Check staged changes
git diff --cached

# View working directory status
git status

# View changes in a specific file
git diff -- install.sh
```

## Code Style Guidelines

### Bash Scripting
- **Shebang**: Always use `#!/usr/bin/env bash`
- **Error handling**: Use `set -eEo pipefail` at the top of scripts
- **Exit traps**: Implement error traps in main scripts (see `install/helpers/errors.sh`)
- **Variable naming**: Use UPPERCASE_SNAKE_CASE for exported variables and configuration
- **Local variables**: Use lowercase_with_underscores for local script variables
- **Function naming**: Use lowercase_with_underscores for function names
- **Quoting**: Always quote variables and paths: `"$VARIABLE"`, `"$PATH/file.sh"`

### File Organization
- **Module structure**: Each feature goes in its own directory under `install/`
- **Entry points**: Each directory has an `all.sh` that sources its components
- **Helper functions**: Common utilities go in `install/helpers/`
- **Logging**: All scripts should use the `run_logged` function from helpers
- **Environment**: Configuration is passed via environment variables from `prompts.sh`

### Import/Inclusion Patterns
```bash
# Correct way to source helpers
source "$EXARCHY_INSTALL/helpers/all.sh"

# Correct way to source module components  
source "$EXARCHY_INSTALL/module-name/component.sh"

# Environment variable usage
export EXARCHY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export EXARCHY_INSTALL="$EXARCHY_PATH/install"
```

### Error Handling
```bash
# Standard error handling pattern
set -eEo pipefail
trap 'error_msg "Command failed at line $LINENO. Installation aborted."; exit 1' ERR

# Function usage for user feedback
info "Starting operation..."
success "Operation completed"
warn "Potential issue detected"
error_msg "Critical failure occurred"
```

### Presentation/Output
- **Colors**: Use the color definitions from `presentation.sh`
- **Logging**: Output goes to `/var/log/exarchy-install.log` via `tee -a`
- **User prompts**: Use the `read -p` pattern from `prompts.sh`
- **Progress indication**: Use `info`, `success`, `warn`, `error_msg` functions

### Security Practices
- **Password handling**: Use `read -s` for password input, never echo
- **LUKS passwords**: Pass via pipe `echo -n "$PASSWORD" | cryptsetup` or temporary keyfiles
- **Password cleanup**: Clear sensitive variables after use with `unset`
- **Temporary files**: Store sensitive data in `/tmp/` with `chmod 600`
- **Cleanup**: Remove temporary files with `shred -u` after use
- **Environment files**: Source from known locations only

### Commit Conventions
- **Commit messages**: Use conventional commits: `feat:`, `fix:`, `refactor:`, `chore:`
- **Scope**: Include affected module in commit message when appropriate
- **Atomic commits**: Each commit should do one logical thing
- **Examples**:
  - `feat: add disk encryption support`
  - `fix: correct partition alignment in disk-setup`
  - `refactor: move helper functions to dedicated directory`
  - `chore: update documentation`

## Project Structure

```
exarchy/
├── install.sh                    # Main installation script
├── install/                      # All installation modules
│   ├── helpers/                  # Common utilities
│   │   ├── all.sh               # Sources all helpers
│   │   ├── presentation.sh      # Color/output functions
│   │   ├── errors.sh           # Error handling setup
│   │   ├── logging.sh          # Logging utilities
│   │   └── prompts.sh          # User input collection
│   ├── preflight/               # Live environment checks
│   ├── disk-setup/              # Disk partitioning/encryption
│   ├── base-system/            # Pacstrap and basic setup
│   ├── chroot-system/          # System configuration in chroot
│   ├── chroot-general/         # General packages/services
│   ├── hardware-daemons/       # Hardware-specific services
│   ├── desktop-hyprland/       # Hyprland desktop setup
│   ├── user-space/             # User account configuration
│   └── dotfiles/               # Dotfiles installation
└── LICENSE
```

## Development Workflow

1. **Test syntax**: Run `shellcheck` on modified scripts
2. **Dry run**: Use `bash -n` to check for syntax errors
3. **Module testing**: Test individual modules with logging enabled
4. **Integration test**: Run the full script in a VM for major changes
5. **Commit**: Follow commit conventions, include clear message

## Important Notes

- This is a **destructive** installation system - it formats disks
- Always test changes in a VM before committing
- The system assumes UEFI with GPT partitioning
- Encryption uses LUKS with the same password for everything
- Target environment is Arch Linux with CachyOS repositories
- Desktop environment is Hyprland Wayland compositor

## Cursor/Copilot Rules

No specific Cursor rules (`.cursor/` or `.cursorrules`) or Copilot rules (`.github/copilot-instructions.md`) were found in the repository. Follow the guidelines in this document when using AI-assisted development.
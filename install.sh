#!/bin/bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

file_exists() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

file_contains() {
    if file_exists "$1" && grep -q "$2" "$1"; then
        return 0
    else
        return 1
    fi
}

backup_file() {
    if file_exists "$1"; then
        log_warn "Backing up $1 to $1.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

safe_append() {
    local file="$1"
    local content="$2"
    local description="$3"
    
    if [ -z "$description" ]; then
        description="$content"
    fi
    
    if ! file_exists "$file"; then
        log_info "Creating $file"
        touch "$file"
    fi
    
    if file_contains "$file" "$content"; then
        log_warn "Content already exists in $file, skipping: $description"
    else
        log_info "Appending to $file: $description"
        echo "$content" >> "$file"
    fi
}

safe_download() {
    local url="$1"
    local dest="$2"
    local filename=$(basename "$dest")
    
    if file_exists "$dest"; then
        log_warn "File already exists: $dest, skipping download"
        return 0
    fi
    
    log_info "Downloading $filename to $dest"
    if wget -P "$(dirname "$dest")" "$url"; then
        log_info "Successfully downloaded $filename"
    else
        log_error "Failed to download $filename"
        return 1
    fi
}

# Check prerequisites
log_info "Checking prerequisites..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

# Setup Homebrew
log_info "=== Setting up Homebrew ==="

if check_command brew; then
    log_warn "Homebrew is already installed"
else
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        log_info "Adding Homebrew to PATH (Apple Silicon)"
        safe_append ~/.zprofile 'eval "$(/opt/homebrew/bin/brew shellenv)"' "Homebrew shellenv"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install wget
if check_command wget; then
    log_warn "wget is already installed"
else
    log_info "Installing wget..."
    brew install wget
fi

# Upgrade all brew packages
log_info "Upgrading all installed brew packages..."
brew upgrade

# Install fonts
log_info "=== Installing MesloLGS NF Fonts ==="
FONT_DIR="$HOME/Library/Fonts"

fonts=(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf|MesloLGS NF Regular.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf|MesloLGS NF Bold.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf|MesloLGS NF Italic.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf|MesloLGS NF Bold Italic.ttf"
)

for font_info in "${fonts[@]}"; do
    IFS='|' read -r url filename <<< "$font_info"
    dest="$FONT_DIR/$filename"
    safe_download "$url" "$dest"
done

# Configure VS Code settings
log_info "=== Configuring VS Code/Cursor settings ==="
VSCODE_SETTINGS="/Users/$USER/Library/Application Support/Cursor/User/settings.json"

# Create directory if it doesn't exist
mkdir -p "$(dirname "$VSCODE_SETTINGS")"

# Initialize settings.json if it doesn't exist
if ! file_exists "$VSCODE_SETTINGS"; then
    log_info "Creating $VSCODE_SETTINGS"
    echo '{}' > "$VSCODE_SETTINGS"
fi

# Check and add terminal font family
if ! file_contains "$VSCODE_SETTINGS" '"terminal.integrated.fontFamily"'; then
    log_info "Adding terminal font family to settings.json"
    # This is a simplified approach - for complex JSON manipulation, consider using jq
    backup_file "$VSCODE_SETTINGS"
    python3 << EOF
import json
import sys

settings_path = "$VSCODE_SETTINGS"

try:
    with open(settings_path, 'r') as f:
        settings = json.load(f)
except:
    settings = {}

settings.setdefault('window', {})['commandCenter'] = True
settings.setdefault('workbench', {})['colorTheme'] = 'Cursor Dark High Contrast'
settings.setdefault('terminal', {}).setdefault('integrated', {})['fontFamily'] = 'MesloLGS NF'
settings.setdefault('terminal', {}).setdefault('integrated', {})['minimumContrastRatio'] = 1

color_customizations = settings.setdefault('workbench', {}).setdefault('colorCustomizations', {})
color_customizations['terminal.ansiGreen'] = '#00ff00'
color_customizations['terminal.ansiBrightGreen'] = '#00ff00'
color_customizations['terminal.ansiYellow'] = '#ffff00'
color_customizations['terminal.ansiBrightYellow'] = '#ffff00'
color_customizations['terminal.selectionBackground'] = '#ff0087'
color_customizations['terminal.selectionForeground'] = '#000000'

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=4)

print("Settings updated successfully")
EOF
else
    log_warn "Terminal font family already configured in settings.json"
fi

# Install Oh My Zsh
log_info "=== Installing Oh My Zsh ==="
if [ -d "$HOME/.oh-my-zsh" ]; then
    log_warn "Oh My Zsh is already installed"
else
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Oh My Zsh plugins
log_info "=== Installing Oh My Zsh plugins ==="
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log_warn "zsh-autosuggestions plugin already installed"
else
    log_info "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    log_warn "zsh-syntax-highlighting plugin already installed"
else
    log_info "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install Powerlevel10k
log_info "=== Installing Powerlevel10k ==="
if check_command brew && brew list powerlevel10k &> /dev/null; then
    log_warn "Powerlevel10k is already installed via Homebrew"
else
    log_info "Installing Powerlevel10k via Homebrew..."
    brew install powerlevel10k
fi

# Configure .zshrc
log_info "=== Configuring .zshrc ==="
if ! file_exists "$HOME/.zshrc"; then
    log_info "Creating .zshrc file"
    touch "$HOME/.zshrc"
fi

# Add Oh My Zsh configuration
if ! file_contains "$HOME/.zshrc" "ZSH="; then
    safe_append "$HOME/.zshrc" 'export ZSH="$HOME/.oh-my-zsh"' "Oh My Zsh path"
fi

if ! file_contains "$HOME/.zshrc" "compinit"; then
    safe_append "$HOME/.zshrc" "autoload -Uz compinit
compinit" "compinit configuration"
fi

if ! file_contains "$HOME/.zshrc" "zsh-autosuggestions"; then
    safe_append "$HOME/.zshrc" "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" "zsh-autosuggestions source"
fi

if ! file_contains "$HOME/.zshrc" "plugins=("; then
    safe_append "$HOME/.zshrc" "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" "Oh My Zsh plugins"
fi

# Add Powerlevel10k source
if ! file_contains "$HOME/.zshrc" "powerlevel10k.zsh-theme"; then
    log_info "Adding Powerlevel10k to .zshrc"
    if check_command brew; then
        echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> "$HOME/.zshrc"
    fi
fi

# Add eza alias configuration
if ! file_contains "$HOME/.zshrc" 'alias ls="eza'; then
    log_info "Adding eza alias configuration to .zshrc"
    cat >> "$HOME/.zshrc" << 'EOF'
alias ls="eza -l --group --icons --color=always"
export EZA_COLORS="\
di=38;5;44:fi=38;5;208:ex=38;5;129:ln=38;5;45:or=38;5;196:\
uu=38;2;255;0;135:un=38;2;255;0;135:\
gu=38;2;255;255;0:gn=38;2;255;255;0:\
ur=38;2;29;255;149:gr=38;2;29;255;149:tr=38;2;29;255;149:\
uw=38;2;255;172;186:gw=38;2;255;172;186:tw=38;2;255;172;186:\
ux=38;2;165;213;255:gx=38;2;165;213;255:tx=38;2;165;213;255:\
ue=38;2;165;213;255:ge=38;2;165;213;255:te=38;2;165;213;255"
EOF
fi

# Install eza
log_info "=== Installing eza ==="
if check_command eza; then
    log_warn "eza is already installed"
else
    log_info "Installing eza..."
    brew install eza
fi

# Configure Powerlevel10k colors
log_info "=== Configuring Powerlevel10k colors ==="
P10K_FILE="$HOME/.p10k.zsh"

if ! file_exists "$P10K_FILE"; then
    log_warn ".p10k.zsh does not exist. Run 'p10k configure' first to generate it."
    log_info "You can configure Powerlevel10k colors later by running: p10k configure"
else
    log_info "Applying custom Powerlevel10k colors..."
    backup_file "$P10K_FILE"
    
    sed -i '' \
      -e 's/POWERLEVEL9K_OS_ICON_FOREGROUND=.*/POWERLEVEL9K_OS_ICON_FOREGROUND=0/' \
      -e 's/POWERLEVEL9K_OS_ICON_BACKGROUND=.*/POWERLEVEL9K_OS_ICON_BACKGROUND=255/' \
      -e 's/POWERLEVEL9K_DIR_BACKGROUND=.*/POWERLEVEL9K_DIR_BACKGROUND=198/' \
      -e 's/POWERLEVEL9K_DIR_FOREGROUND=.*/POWERLEVEL9K_DIR_FOREGROUND=231/' \
      -e 's/POWERLEVEL9K_VCS_CLEAN_BACKGROUND=.*/POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2/' \
      -e 's/POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=.*/POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=220/' \
      -e 's/POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=.*/POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=220/' \
      -e 's/POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=.*/POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=196/' \
      -e 's/POWERLEVEL9K_VCS_LOADING_BACKGROUND=.*/POWERLEVEL9K_VCS_LOADING_BACKGROUND=14/' \
      "$P10K_FILE"
    
    log_info "Powerlevel10k colors updated"
fi

# Final instructions
log_info "=== Installation Complete ==="
echo ""
log_info "Next steps:"
echo "  1. If Powerlevel10k configuration is new, run: p10k configure"
echo "  2. Reload your shell configuration: source ~/.zshrc"
echo "  3. Or restart your terminal"
echo ""
log_info "If you want to manually configure Powerlevel10k colors, edit ~/.p10k.zsh"

#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Bootstrapping new Mac from $DOTFILES_DIR"

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "==> Installing Homebrew packages..."
brew bundle install --file="$DOTFILES_DIR/Brewfile"

# 2. Shell
echo "==> Copying shell configs..."
cp "$DOTFILES_DIR/shell/.zshrc" ~/.zshrc
cp "$DOTFILES_DIR/shell/.zprofile" ~/.zprofile

# 3. Git
echo "==> Copying git configs..."
cp "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
cp "$DOTFILES_DIR/git/.gitignore_global" ~/.gitignore_global

# 4. Neovim
echo "==> Copying nvim config..."
mkdir -p ~/.config/nvim
rsync -av --delete "$DOTFILES_DIR/nvim/" ~/.config/nvim/

# 5. macOS WM
echo "==> Copying macOS WM configs..."
mkdir -p ~/.config/karabiner
cp "$DOTFILES_DIR/mac/karabiner.json" ~/.config/karabiner/karabiner.json
mkdir -p ~/.config/skhd
cp -r "$DOTFILES_DIR/mac/skhd/." ~/.config/skhd/
cp "$DOTFILES_DIR/mac/yabairc" ~/.config/yabai/yabairc 2>/dev/null || \
  (mkdir -p ~/.config/yabai && cp "$DOTFILES_DIR/mac/yabairc" ~/.config/yabai/yabairc)

# 6. VS Code
echo "==> Copying VS Code settings..."
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
cp "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER/settings.json"
cp "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"

# 7. Claude Code
echo "==> Copying Claude Code settings..."
mkdir -p ~/.claude
cp "$DOTFILES_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
cp "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
cp "$DOTFILES_DIR/claude/claude-powerline.json" ~/.claude/claude-powerline.json
cp "$DOTFILES_DIR/claude/statusline-command.sh" ~/.claude/statusline-command.sh

# 8. Node via nvm
echo "==> Installing Node..."
if ! command -v nvm &>/dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
fi
nvm install 20
nvm use 20
npm install -g @google/gemini-cli @playwright/mcp

echo ""
echo "==> Done. Reminders:"
echo "  - Generate new SSH keys: ssh-keygen -t ed25519 -C 'emil.n.larsson@fortnox.se'"
echo "  - Add public key to GitHub: cat ~/.ssh/id_ed25519.pub | pbcopy"
echo "  - Add key to any remote servers you SSH into"
echo "  - gh auth login"
echo "  - Open nvim to let lazy.nvim install plugins"

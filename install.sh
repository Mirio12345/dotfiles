#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# 1. Install System Packages via yay
echo "Installing core dependencies..."
yay -S hyprland swaync hyprpaper kitty zsh rofi waybar-git nwg-look \
  bibata-cursor-theme-bin papirus-icon-theme papirus-folders \
  hyprpolkitagent cliphist wl-clipboard hyprpicker grim slurp \
  networkmanager-dmenu-git pavucontrol hyprlock hypridle nvim \
  wl-freeze-git --needed

# 2. Configure System and UI Defaults
echo "Setting up system settings..."
systemctl --user enable --now hyprpolkitagent
xdg-user-dirs-update
papirus-folders -C black

# 3. Automated Install of Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh smoothly..."
    # --unattended: Stops it from launching interactive prompts or changing shell instantly
    # --keep-zshrc: Prevents it from nuking/overwriting your custom .zshrc
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
    echo "Oh My Zsh already installed. Skipping..."
fi

# 4. Safely Setup and Clone Powerlevel10k
echo "Installing Powerlevel10k theme..."
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM_DIR/themes"

if [ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
else
    echo "Powerlevel10k repository already exists. Skipping..."
fi

#5. Install zsh-autosuggestions
echo "Installing zsh-suggestions Plugin ..."
mkdir -p "$ZSH_CUSTOM_DIR/plugins"

if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-auto-suggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions repository already exists. Skipping..."
fi

# 6. Switch System Default Shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh (you may be prompted for your sudo/user password)..."
    chsh -s "$(which zsh)"
fi

# 7. Linking your Managed Dotfiles
DOTFILES_DIR="$HOME/dotfiles"

echo "Backing up existing configuration baselines..."
mv ~/.zshrc ~/.zshrc.bak 2>/dev/null || true
mv ~/.p10k.zsh ~/.p10k.zsh.bak 2>/dev/null || true

echo "Forging symlinks for Zsh configurations..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/.themes" "$HOME/.themes"

echo "Forging symlinks for .config apps..."
mkdir -p "$HOME/.config"

for folder in "$DOTFILES_DIR/.config"/*; do
    # Skip processing if it's an accidental loose file instead of a directory
    [ -d "$folder" ] || continue
    
    target_dir="$HOME/.config/$(basename "$folder")"
    
    # Optional backup safety if old stock app configs already exist in ~/.config
    if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
        echo "Moving existing non-symlink config folder to backup: $target_dir"
        mv "$target_dir" "${target_dir}.bak"
    fi

    ln -sfn "$folder" "$target_dir"
done

echo "========================================="
echo "   Dotfiles installation complete!       "
echo " Please log out or restart your session. "
echo "========================================="

#!/bin/bash

# echo -e "This script needs $(gum style --bold --foreground 9 'sudo') priveledges to run smoothly. $(gum style --bold --foreground 9 'Do not enter your password if you are unsure of what this script does.')"
# password=$(gum input --password --placeholder "Please enter your password")

# Clear the screen
tput clear

# Check gum install
if ! command -v gum > /dev/null; then
  echo -e "$(gum style --bold --foreground 13 'gum') $(gum style --bold --foreground 255 'is not installed on your system')"
  echo -e "$(gum style --bold --foreground 255 'Please see https://github.com/charmbracelet/gum#installation for instructions.')"
fi

# Package manager check
if command -v dnf >/dev/null; then
  # Fedora
  PM="dnf"
  PM_CMD="dnf install"
  PM_NAME="Fedora"
elif command -v apt >/dev/null; then
  # Debian/Ubuntu
  PM="apt"
  PM_CMD="apt install"
  PM_NAME="Debian/Ubuntu"
elif command -v pacman >/dev/null; then
  # Arch/Manjaro
  PM="pacman"
  PM_CMD="pacman -S"
  PM_NAME="Arch/Manjaro"
fi

# Initialize
echo -e "You seem to be using a $(gum style --bold --foreground 6 \'${PM_NAME}\') system. What would you like to install using $(gum style --bold --foreground 6 \'${PM}\')?"
echo -e "$(gum style --bold --foreground 238 'Press space to select an item, a to select everything, or use left and right arrow keys to paginate.')\n"
options=$(gum choose --no-limit --cursor.foreground="220" --selected.foreground="220" alacritty btop exa ffmpeg Flathub fzf GeoIP gh git lazygit nnn nethogs oh-my-zsh p10k playerctl polybar rofi tldr xinput xset zsh-autosuggestions zsh-syntax-highlighting zsh)

# Commands
for option in ${options}; do
  if [ "$option" == "Flathub" ]; then
    echo -e "📦 $(gum style --bold --foreground 2 'Enabling') $(gum style --bold --foreground 9 'Flathub') $(gum style --bold --foreground 2 'repository')\n"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo -e "✅ $(gum style --bold --foreground 2 'Flathub repository is enabled.')\n"
  elif [ "$option" == "lazygit" ]; then
    echo -e -n "⚠️ This installation only works on Fedora (dnf). Are you using Fedora? [y/n]: "
    read lazy_answer
      if [ "$lazy_answer" = "y" ]; then
        echo -e "\n⬇️ $(gum style --bold --foreground 9 'Installing') $(gum style --bold --foreground 2 \'${option}\')\n"
        sudo dnf copr enable atim/lazygit -y
        sudo dnf install lazygit -y
        echo -e "\n✅ $(gum style --bold --foreground 9 \'${option}\') $(gum style --bold --foreground 2 'has been installed!')\n"
      elif [ "$lazy_answer" = "n" ]; then
        echo -e "😔 Alright."
      else
        echo -e "\n❌ $(gum style --bold --foreground 9 \'${lazy_answer}\') is not a valid answer. Quiting the script.\n"
        exit
      fi  
  elif [ "$option" == "oh-my-zsh" ]; then
    echo -e "\n⬇️ $(gum style --bold --foreground 9 'Installing') $(gum style --bold --foreground 2 \'${option}\')\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "\n"
  elif [ "$option" == "p10k" ]; then
    echo -e "\n⬇️ $(gum style --bold --foreground 9 'Installing') $(gum style --bold --foreground 2 \'${option}\')\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "⚠️ $(gum style --bold --foreground 2 'Do not forget to add') $(gum style --bold --foreground 9 'ZSH_THEME="powerlevel10k/powerlevel10k"') $(gum style --bold --foreground 2 'to your .zshrc file!')\n"
  elif [ "$option" == "zsh-autosuggestions" ]; then
    echo -e "\n⬇️ $(gum style --bold --foreground 9 'Installing') $(gum style --bold --foreground 2 \'${option}\')\n"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "\n⚠️ $(gum style --bold --foreground 2 'Do not forget to add') $(gum style --bold --foreground 9 'zsh-autosuggestions') $(gum style --bold --foreground 2 'to your .zshrc file!')\n"
  elif [ "$option" == "zsh-syntax-highlighting" ]; then
    echo -e "\n⬇️ $(gum style --bold --foreground 9 'Installing') $(gum style --bold --foreground 2 \'${option}\')\n"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo -e "⚠️ $(gum style --bold --foreground 2 'Do not forget to add') $(gum style --bold --foreground 9 'zsh-syntax-highlighting') $(gum style --bold --foreground 2 'to your .zshrc file!')\n"
  else
    echo -e "\n⬇️ $(gum style --bold --foreground 9 'Installing') $(gum style --bold --foreground 2 \'${option}\')\n"
    sudo ${PM_CMD} ${option}
    echo -e "\n✅ $(gum style --bold --foreground 9 \'${option}\') $(gum style --bold --foreground 2 'has been installed!')\n"
  fi
done
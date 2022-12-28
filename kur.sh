#!/bin/bash

# Import colors
. kur/src/colors.sh

# Check package manager
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
elif command -v brew >/dev/null; then
  # macOS/Linux
  PM="brew"
  PM_CMD="brew install"
  PM_NAME="macOS"
else
  # Manually declare package manager if necessary
  echo -e -n "\n\033[${HighBoldWhite}What package manager do you use? (e.g. dnf, apt, pacman, brew): \033[0m"
  read PM
  PM_NAME="Custom"
fi

# Package manager output and the initial question
echo -e "\n\033[${HighBoldWhite}You seem to be using a \033[${HighBoldBlue}$PM_NAME\033 \033[${HighBoldWhite} system. What would you like to install using\033 \033[${HighBoldBlue} $PM\033 \033[${HighBoldWhite}?\033[0m\n"

# Options
echo -e "0. \033[${HighBoldRed}Nothing\033[0m"
echo -e "1. \033[${HighBoldGreen}Everything\033[0m\n"

echo -e "2. \033[${HighBoldYellow}Polybar\033[0m"
echo -e "3. \033[${HighBoldYellow}Rofi\033[0m"
echo -e "4. \033[${HighBoldYellow}zsh\033[0m"
echo -e "5. \033[${HighBoldYellow}GeoIP\033[0m"
echo -e "6. \033[${HighBoldYellow}git\033[0m"
echo -e "7. \033[${HighBoldYellow}gh\033[0m"
echo -e "8. \033[${HighBoldYellow}oh-my-zsh\033[0m"
echo -e "9. \033[${HighBoldYellow}p10k\033[0m"
echo -e "10. \033[${HighBoldYellow}zsh-autosuggestions\033[0m"
echo -e "11. \033[${HighBoldYellow}zsh-syntax-highlighting\033[0m"
echo -e "12. \033[${HighBoldYellow}Alacritty\033[0m"
echo -e "13. \033[${HighBoldYellow}xinput\033[0m"
echo -e "14. \033[${HighBoldYellow}xset\033[0m"
echo -e "15. \033[${HighBoldYellow}playerctl\033[0m"
echo -e "16. \033[${HighBoldYellow}ffmpeg\033[0m"
echo -e "17. \033[${HighBoldYellow}Flathub repository\033[0m"
echo -e "18. \033[${HighBoldYellow}dotfiles\033[0m\n"

# Selection
echo -e -n "\033[${HighBoldWhite}Type in your selection, with a space in between: \033[0m"
read selection

# Commands
for opt in $selection
do
    case $opt in
        1)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing everything...\033[0m\n"
            sudo $PM_CMD polybar rofi zsh geoip git gh alacritty xinput xset playerctl ffmpeg -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        2)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing Polybar...\033[0m\n"
            sudo $PM_CMD polybar -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        3)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing Rofi...\033[0m\n"
            sudo $PM_CMD rofi -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        4)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing zsh...\033[0m\n"
            sudo $PM_CMD zsh -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        5)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing GeoIP...\033[0m\n"
            sudo $PM_CMD geoip -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        6)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing git...\033[0m\n"
            sudo $PM_CMD git -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        7)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing gh...\033[0m\n"
            sudo $PM_CMD gh -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        8)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing oh-my-zsh...\033[0m\n"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        9)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing p10k...\033[0m\n"
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
            echo -e "\n\033[${HighBoldWhite} ❗ Add\033[0m \033[${HighBoldRed}ZSH_THEME="powerlevel10k/powerlevel10k"\033[0m \033[${HighBoldWhite}to your .zshrc file!\033[0m\n"
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        10)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing zsh-autosuggestions...\033[0m\n"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            echo -e "\n\033[${HighBoldWhite} ❗ Add\033[0m \033[${HighBoldRed}zsh-autosuggestions\033[0m \033[${HighBoldWhite}to your .zshrc file's plugin section!\033[0m\n"
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        11)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing zsh-syntax-highlighting...\033[0m\n"
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            echo -e "\n\033[${HighBoldWhite} ❗ Add\033[0m \033[${HighBoldRed}zsh-syntax-highlighting\033[0m \033[${HighBoldWhite}to your .zshrc file's plugin section!\033[0m\n"
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        12)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing Alacritty...\033[0m\n"
            sudo $PM_CMD alacritty -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        13)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing xinput...\033[0m\n"
            sudo $PM_CMD xinput -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        14)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing xset...\033[0m\n"
            sudo $PM_CMD xset -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        15)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing playerctl...\033[0m\n"
            sudo $PM_CMD playerctl -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        16)
            echo -e "\n\033[${HighBoldGreen} 🌀 Installing ffmpeg...\033[0m\n"
            sudo $PM_CMD ffmpeg -y
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        17)
            echo -e "\n\033[${HighBoldGreen} 📦 Enabling Flathub repository...\033[0m\n"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            echo -e "\n ▲ ▲ ▲ \n"
            ;;
        18)
            echo -e -n "\033[${HighBoldWhite}Are you starting from scratch? (see: https://github.com/aloglu/dotfiles#installation) (y/n): \033[0m"
            read answer
                if [ "$answer" = "y" ]; then
                    git init --bare $HOME/.dotfiles &&
                    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' &&
                    dotfiles config --local status.showUntrackedFiles no &&
                    echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc &&
                    dotfiles add .zshrc &&
                    dotfiles commit -m "Add .zshrc" &&
                    dotfiles push
                elif [ "$answer" = "n" ]; then
                    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'{:.bash} &&
                    echo ".dotfiles" >> .gitignore &&
                    git clone --bare https://github.com/aloglu/dotfiles $HOME/.dotfiles &&
                    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' &&
                    mkdir -p .dotfiles-backup && \
                    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
                    xargs -I{} mv {} .dotfiles-backup/{} &&
                    dotfiles checkout &&ech
                    dotfiles config --local status.showUntrackedFiles no
                else
                    echo -e "\n\033[${HighBoldRed}$answer\033[0m \033[${HighBoldWhite}is not a valid option. Quitting the script.\033\n"
                    exit
                fi
            ;;
        0)
            echo -e "\n\033[${HighBoldWhite}Okay, then. 👋\033[0m\n"
            exit
            ;;
        *)
            echo -e "\n\033[${HighBoldRed}$opt\033[0m \033[${HighBoldWhite}is not a valid option. Quitting the script.\033\n"
            ;;
    esac
done
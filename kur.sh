#!/bin/bash

# Import variables
. ./src/var.sh
. ./src/colors.sh

# Options
echo -e "\n\033[${BIWhite}What would you like to install?\033[0m\n"

echo -e "0. \033[${BIRed}Nothing\033[0m"
echo -e "1. \033[${BIBlue}Everything\033[0m\n"

echo -e "2. \033[${BIYellow}Polybar\033[0m"
echo -e "3. \033[${BIYellow}Rofi\033[0m"
echo -e "4. \033[${BIYellow}zsh\033[0m"
echo -e "5. \033[${BIYellow}GeoIP\033[0m"
echo -e "6. \033[${BIYellow}git\033[0m"
echo -e "7. \033[${BIYellow}gh\033[0m"
echo -e "8. \033[${BIYellow}oh-my-zsh\033[0m"
echo -e "9. \033[${BIYellow}p10k\033[0m"
echo -e "10. \033[${BIYellow}zsh-autosuggestions\033[0m"
echo -e "11. \033[${BIYellow}zsh-syntax-highlighting\033[0m"
echo -e "12. \033[${BIYellow}Alacritty\033[0m"
echo -e "13. \033[${BIYellow}xinput\033[0m"
echo -e "14. \033[${BIYellow}xset\033[0m"
echo -e "15. \033[${BIYellow}playerctl\033[0m"
echo -e "16. \033[${BIYellow}ffmpeg\033[0m"
echo -e "17. \033[${BIYellow}Flathub repository\033[0m"
echo -e "18. \033[${BIYellow}dotfiles\033[0m\n"

# Selection
echo -e -n "\033[${BIWhite}Type in your selection, preferably with a space in between: \033[0m"
read selection

# Commands
for opt in $selection
do
    case $opt in
        1)
            sudo dnf install polybar rofi zsh geoip git gh alacritty xinput xset playerctl ffmpeg
            ;;
        2)
            echo -e "\n\033[${BIGreen} 🌀 Installing Polybar...\033[0m\n"
            sudo dnf install polybar
            echo -e "\n $trid \n"
            ;;
        3)
            echo -e "\n\033[${BIGreen} 🌀 Installing Rofi...\033[0m\n"
            sudo dnf install rofi
            echo -e "\n $trid \n"
            ;;
        4)
            echo -e "\n\033[${BIGreen} 🌀 Installing zsh...\033[0m\n"
            sudo dnf install zsh
            echo -e "\n $trid \n"
            ;;
        5)
            echo -e "\n\033[${BIGreen} 🌀 Installing GeoIP...\033[0m\n"
            sudo dnf install geoip
            echo -e "\n $trid \n"
            ;;
        6)
            echo -e "\n\033[${BIGreen} 🌀 Installing git...\033[0m\n"
            sudo dnf install git
            echo -e "\n $trid \n"
            ;;
        7)
            echo -e "\n\033[${BIGreen} 🌀 Installing gh...\033[0m\n"
            sudo dnf install gh
            echo -e "\n $trid \n"
            ;;
        8)
            echo -e "\n\033[${BIGreen} 🌀 Installing oh-my-zsh...\033[0m\n"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            echo -e "\n $trid \n"
            ;;
        9)
            echo -e "\n\033[${BIGreen} 🌀 Installing p10k...\033[0m\n"
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
            echo -e "\n\033[${BIWhite} ❗ Add\033[0m \033[${BIRed}ZSH_THEME="powerlevel10k/powerlevel10k"\033[0m \033[${BIWhite}to your .zshrc file!\033[0m\n"
            echo -e "\n $trid \n"
            ;;
        10)
            echo -e "\n\033[${BIGreen} 🌀 Installing zsh-autosuggestions...\033[0m\n"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            echo -e "\n\033[${BIWhite} ❗ Add\033[0m \033[${BIRed}zsh-autosuggestions\033[0m \033[${BIWhite}to your .zshrc file's plugin section!\033[0m\n"
            echo -e "\n $trid \n"
            ;;
        11)
            echo -e "\n\033[${BIGreen} 🌀 Installing zsh-syntax-highlighting...\033[0m\n"
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            echo -e "\n\033[${BIWhite} ❗ Add\033[0m \033[${BIRed}zsh-syntax-highlighting\033[0m \033[${BIWhite}to your .zshrc file's plugin section!\033[0m\n"
            echo -e "\n $trid \n"
            ;;
        12)
            echo -e "\n\033[${BIGreen} 🌀 Installing Alacritty...\033[0m\n"
            sudo dnf install alacritty
            echo -e "\n $trid \n"
            ;;
        13)
            echo -e "\n\033[${BIGreen} 🌀 Installing xinput...\033[0m\n"
            sudo dnf install xinput
            echo -e "\n $trid \n"
            ;;
        14)
            echo -e "\n\033[${BIGreen} 🌀 Installing xset...\033[0m\n"
            sudo dnf install xset
            echo -e "\n $trid \n"
            ;;
        15)
            echo -e "\n\033[${BIGreen} 🌀 Installing playerctl...\033[0m\n"
            sudo dnf install playerctl
            echo -e "\n $trid \n"
            ;;
        16)
            echo -e "\n\033[${BIGreen} 🌀 Installing ffmpeg...\033[0m\n"
            sudo dnf install ffmpeg
            echo -e "\n $trid \n"
            ;;
        17)
            echo -e "\n\033[${BIGreen} 📦 Enabling Flathub repository...\033[0m\n"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            echo -e "\n $trid \n"
            ;;
        18)
            echo -e -n "\033[${BIWhite}Are you starting from scratch? (see: https://github.com/aloglu/dotfiles#installation) (y/n): \033[0m"
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
                    echo -e "\n\033[${BIRed}$answer\033[0m \033[${BIWhite}is not a valid option. Quitting the script.\033\n"
                    exit
                fi
            ;;
        0)
            echo -e "\n\033[${BIWhite}Okay, then.\033[0m\n"
            exit
            ;;
        *)
            echo -e "\n\033[${BIRed}$opt\033[0m \033[${BIWhite}is not a valid option. Quitting the script.\033\n"
            ;;
    esac
done
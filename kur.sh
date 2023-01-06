#!/bin/bash

# Imports
. $HOME/kur/src/pm.sh
. $HOME/kur/src/func.sh
. $HOME/kur/src/colors.sh

# Clear the screen
tput clear

# Package manager output and the initial question
echo -e "\n\033[${HighBoldWhite}You seem to be using a \033[${HighBoldCyan}$PM_NAME\033 \033[${HighBoldWhite} system. What would you like to install using\033 \033[${HighBoldCyan} $PM\033 \033[${HighBoldWhite}?\033[0m\n"

# Options
echo -e "0.  \033[${HighBoldRed}Nothing\033[0m"
echo -e "1.  \033[${HighBoldGreen}Everything\033[0m\n"

echo -e "    \033[${HighBoldBlue}Terminal\033[0m"
echo -e "2.  \033[${HighBoldYellow}Alacritty\033[0m"
echo -e "3.  \033[${HighBoldYellow}zsh\033[0m"
echo -e "4.  \033[${HighBoldYellow}oh-my-zsh\033[0m"
echo -e "5.  \033[${HighBoldYellow}p10k\033[0m"
echo -e "6.  \033[${HighBoldYellow}fzf\033[0m"
echo -e "7.  \033[${HighBoldYellow}zsh-autosuggestions\033[0m"
echo -e "8.  \033[${HighBoldYellow}zsh-syntax-highlighting\033[0m\n"

echo -e "    \033[${HighBoldBlue}Utilities\033[0m"
echo -e "9.  \033[${HighBoldYellow}btop\033[0m"
echo -e "10. \033[${HighBoldYellow}mc\033[0m"
echo -e "11. \033[${HighBoldYellow}exa\033[0m"
echo -e "12. \033[${HighBoldYellow}git\033[0m"
echo -e "13. \033[${HighBoldYellow}gh\033[0m"
echo -e "14. \033[${HighBoldYellow}tldr-pages\033[0m"
echo -e "15. \033[${HighBoldYellow}GeoIP\033[0m\n"

echo -e "    \033[${HighBoldBlue}System\033[0m"
echo -e "16. \033[${HighBoldYellow}xinput\033[0m"
echo -e "17. \033[${HighBoldYellow}xset\033[0m"
echo -e "18. \033[${HighBoldYellow}Enable Flathub repository\033[0m\n"

echo -e "    \033[${HighBoldBlue}Media\033[0m"
echo -e "19. \033[${HighBoldYellow}ffmpeg\033[0m"
echo -e "20. \033[${HighBoldYellow}playerctl\033[0m\n"

echo -e "    \033[${HighBoldBlue}Customization\033[0m"
echo -e "21. \033[${HighBoldYellow}Polybar\033[0m"
echo -e "22. \033[${HighBoldYellow}Rofi\033[0m"
echo -e "23. \033[${HighBoldYellow}dotfiles\033[0m\n"

# Selection
echo -e -n "\033[${HighBoldWhite}Type in your selection, with a space in between: \033[0m"
read selection

# Commands
for opt in $selection
do
    case $opt in
        1)
            everything
            ;;
        2)
            alacritty
            ;;
        3)
            zsh
            ;;
        4)
            oh-my-zsh
            ;;
        5)
            p10k
            ;;
        6)
            fzf
            ;;
        7)
            zsh-autosuggestions
            ;;
        8)
            zsh-syntax-highlighting
            ;;
        9)
            btop
            ;;
        10)
            mc
            ;;
        11)
            exa
            ;;
        12)
            git
            ;;
        13)
            gh
            ;;
        14)
            tldr
            ;;
        15)
            geoip
            ;;
        16)
            xinput
            ;;
        17)
            xset
            ;;
        18)
            flathub
            ;;
        19)
            ffmpeg
            ;;
        20)
            playerctl
            ;;
        21)
            polybar
            ;;
        22)
            rofi
            ;;
        23)
            dotfiles
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
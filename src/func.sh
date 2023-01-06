#!/bin/bash

function everything() {
    alacritty;
    zsh;
    oh-my-zsh;
    p10k;
    fzf;
    zsh-autosuggestions;
    zsh-syntax-highlighting;
    btop;
    mc;
    exa;
    git;
    gh;
    tldr;
    geoip;
    xinput;
    xset;
    flathub;
    ffmpeg;
    playerctl;
    polybar;
    rofi
}

function alacritty() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing Alacritty...\033[0m\n"
    sudo $PM_CMD alacritty -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function zsh() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing zsh...\033[0m\n"
    sudo $PM_CMD zsh -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function oh-my-zsh() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing oh-my-zsh...\033[0m\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function p10k() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing p10k...\033[0m\n"
    command git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "\n\033[${HighBoldWhite} ❗ Add\033[0m \033[${HighBoldRed}ZSH_THEME="powerlevel10k/powerlevel10k"\033[0m \033[${HighBoldWhite}to your .zshrc file!\033[0m"
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function fzf() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing fzf...\033[0m\n"
    sudo $PM_CMD fzf -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function zsh-autosuggestions() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing zsh-autosuggestions...\033[0m\n"
    command git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "\n\033[${HighBoldWhite} ❗ Add\033[0m \033[${HighBoldRed}zsh-autosuggestions\033[0m \033[${HighBoldWhite}to your .zshrc file's plugin section!\033[0m"
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function zsh-syntax-highlighting() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing zsh-syntax-highlighting...\033[0m\n"
    command git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo -e "\n\033[${HighBoldWhite} ❗ Add\033[0m \033[${HighBoldRed}zsh-syntax-highlighting\033[0m \033[${HighBoldWhite}to your .zshrc file's plugin section!\033[0m"
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function btop() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing btop...\033[0m\n"
    sudo $PM_CMD btop -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function mc() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing Midnight Commander...\033[0m\n"
    sudo $PM_CMD mc -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function exa() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing exa...\033[0m\n"
    sudo $PM_CMD exa -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function git() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing git...\033[0m\n"
    sudo $PM_CMD git -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function gh() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing gh...\033[0m\n"
    sudo $PM_CMD gh -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function tldr() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing tldr-pages...\033[0m\n"
    sudo $PM_CMD tldr -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function geoip() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing GeoIP...\033[0m\n"
    sudo $PM_CMD geoip -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function xinput() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing xinput...\033[0m\n"
    sudo $PM_CMD xinput -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function xset() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing xset...\033[0m\n"
    sudo $PM_CMD xset -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function flathub() {
    echo -e "\n\033[${HighBoldGreen} 📦 Enabling Flathub repository...\033[0m\n"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &&
    echo -e "\033[${HighBoldWhite} ✅ Done\033[0m"
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function ffmpeg() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing ffmpeg...\033[0m\n"
    sudo $PM_CMD ffmpeg -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function playerctl() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing playerctl...\033[0m\n"
    sudo $PM_CMD playerctl -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function polybar() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing Polybar...\033[0m\n"
    sudo $PM_CMD polybar -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function rofi() {
    echo -e "\n\033[${HighBoldGreen} 🌀 Installing rofi...\033[0m\n"
    sudo $PM_CMD rofi -y
    echo -e "\n\033[${HighBoldGreen} ▲ ▲ ▲ \n\033[0m\n"
}

function dotfiles() {
    echo -e -n "\n\033[${HighBoldWhite}Are you starting from scratch? (see: https://github.com/aloglu/dotfiles#installation) (y/n): \033[0m"
    read answer
        if [ "$answer" = "y" ]; then
            command git init --bare $HOME/.dotfiles &&
            alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' &&
            dotfiles config --local status.showUntrackedFiles no &&
            echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc &&
            dotfiles add .zshrc &&
            dotfiles commit -m "Add .zshrc" &&
            dotfiles push
        elif [ "$answer" = "n" ]; then
            alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'{:.bash} &&
            echo ".dotfiles" >> .gitignore &&
            command git clone --bare https://github.com/aloglu/dotfiles $HOME/.dotfiles &&
            alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' &&
            mkdir -p .dotfiles-backup && \
            dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
            xargs -I{} mv {} .dotfiles-backup/{} &&
            dotfiles checkout &&
            dotfiles config --local status.showUntrackedFiles no
        else
            echo -e "\n\033[${HighBoldRed}$answer\033[0m \033[${HighBoldWhite}is not a valid option. Quitting the script.\033\n"
            exit
        fi
    ;;
}
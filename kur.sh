#!/bin/bash
# kur - Fedora Linux Setup Script

# --- Gum Dependency Check ---
if ! command -v gum &> /dev/null; then
    echo -e "\033[38;5;212mkur\033[0m requires \033[1m'gum'\033[0m for its user interface."
    echo -en "Would you like to install it now via dnf? (y/N): "
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo dnf install -y gum
        if [ $? -ne 0 ]; then
            echo "Installation failed. Please install 'gum' manually and run the script again."
            exit 1
        fi
        clear
    else
        echo "Exiting. 'gum' is required to run this script."
        exit 1
    fi
fi

# --- Configuration ---
# Colors
COLOR_INSTALL="46"    # Bright Green
COLOR_UNINSTALL="196" # Bright Red
COLOR_PRIMARY="212"   # Pink/Purple (Brand color)
COLOR_TEXT="255"      # White

# ANSI Escapes for cursor arrows (using Bash escape strings)
CUR_INSTALL=$'\e[38;5;'"${COLOR_INSTALL}"$'m>\e[0m '
CUR_UNINSTALL=$'\e[38;5;'"${COLOR_UNINSTALL}"$'m>\e[0m '
CUR_PRIMARY=$'\e[38;5;'"${COLOR_PRIMARY}"$'m>\e[0m '

# --- Production & Logging Setup ---

LOG_DIR="$HOME/.local/share/kur"
LOG_FILE=$(mktemp) # Ephemeral log for current session only
DB_FILE="$LOG_DIR/installed_apps.txt"
mkdir -p "$LOG_DIR"
touch "$DB_FILE"

log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

track_install() {
    local app="$1"
    # Append only if not already in the database
    if ! grep -Fxq "$app" "$DB_FILE"; then
        echo "$app" >> "$DB_FILE"
    fi
}

untrack_app() {
    local app="$1"
    # Remove the app line from the database if it exists
    if [ -f "$DB_FILE" ]; then
        sed -i "/^${app}$/d" "$DB_FILE"
    fi
}

# --- ASCII Art ---
ASCII_HEADER='
  ▄▄▄▄   ▄▄▄    ▄▄▄  ▄▄     ▄▄▄▄▄▄   
 █▀ ██  ██     █▀██  ██    █▀██▀▀▀█▄ 
    ██ ██        ██  ██      ██▄▄▄█▀ 
    █████        ██  ██      ██▀▀█▄  
    ██ ██▄       ██  ██    ▄ ██  ██  
  ▀██▀  ▀██▄     ▀█████▄   ▀██▀  ▀██▀'

# --- Functions ---

style_header() {
    echo "" # Tighter top padding
    gum style \
        --foreground "$COLOR_PRIMARY" \
        --align center \
        "$ASCII_HEADER"
}

style_rainbow_header() {
    local rainbow=("196" "208" "226" "82" "39" "21" "165")
    local i=0
    local out=""
    local first=true
    
    # Preserve the exact line structure of ASCII_HEADER
    while IFS= read -r line || [ -n "$line" ]; do
        if [ "$first" = true ]; then
            first=false
        else
            out+=$'\n'
        fi

        if [[ "$line" =~ [^[:space:]] ]]; then
            local color=${rainbow[$i % ${#rainbow[@]}]}
            out+=$'\e[38;5;'"$color"$'m'"$line"$'\e[0m'
            ((i++))
        else
            out+="$line"
        fi
    done <<< "$ASCII_HEADER"

    echo "" # Tighter top padding
    gum style --align center "$out"
}

check_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "fedora" ]; then
            gum style --foreground "$COLOR_UNINSTALL" --bold "❌ Error: This script is strictly for Fedora Linux."
            exit 1
        fi
    else
        echo "❌ Error: Cannot detect OS."
        exit 1
    fi
}

require_sudo() {
    if sudo -n true 2>/dev/null; then
        gum style --foreground "$COLOR_INSTALL" "🔓 sudo credentials are cached. No further authentication should be needed."
    else
        gum style --foreground "$COLOR_PRIMARY" "🔒 Authentication Required"
        local PASS
        PASS=$(gum input --password --placeholder "Enter your password to cache sudo credentials...")
        
        if [ -z "$PASS" ]; then
             echo ""
             gum style --foreground "$COLOR_UNINSTALL" "❌ Authentication cancelled. Exiting."
             exit 1
        fi

        if echo "$PASS" | sudo -S -v &>/dev/null; then
            unset PASS
            # Refresh look to wipe the gum input and return to a clean state
            clear
            style_header
            # Standardizing bottom air for the refresh
            echo -e "\n\n"
            gum style --foreground "$COLOR_INSTALL" "🔓 sudo credentials cached. No further authentication should be needed."
        else
            echo ""
            gum style --foreground "$COLOR_UNINSTALL" "❌ Authentication failed. Exiting."
            exit 1
        fi
    fi
    # Keep sudo alive in background
    ( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null & )
}

# --- Repository Management ---

manage_repositories() {
    local G="\e[38;5;${COLOR_INSTALL}m" 
    local R="\e[38;5;${COLOR_UNINSTALL}m" 
    local X="\e[0m"    

    while true; do
        clear
        style_header
        # Synchronized spacer block
        echo -e "\n\n"
        require_sudo
        echo ""

        gum spin --spinner dot --title "Checking repositories..." -- sleep 0.5

        # Single source of truth for detecting presence
        # We use variables to ensure the UI and the Logic branches always agree.
        local IS_FREE=false
        rpm -qa | grep -qi "rpmfusion-free-release" && IS_FREE=true

        local IS_NONFREE=false
        rpm -qa | grep -qi "rpmfusion-nonfree-release" && IS_NONFREE=true

        local IS_TERRA=false
        rpm -qa | grep -qi "terra-release" && IS_TERRA=true

        local IS_FLATHUB=false
        flatpak remote-list | grep -q "flathub" && IS_FLATHUB=true

        # UI Indicators based on Truth
        HAS_FREE=$([ "$IS_FREE" = true ] && echo -e "${G}✓${X}" || echo -e "${R}x${X}")
        HAS_NONFREE=$([ "$IS_NONFREE" = true ] && echo -e "${G}✓${X}" || echo -e "${R}x${X}")
        HAS_TERRA=$([ "$IS_TERRA" = true ] && echo -e "${G}✓${X}" || echo -e "${R}x${X}")
        HAS_FLATHUB=$([ "$IS_FLATHUB" = true ] && echo -e "${G}✓${X}" || echo -e "${R}x${X}")

        REPO_OPTS=(
            "$HAS_FREE RPM (free) - Freeware/Open Source"
            "$HAS_NONFREE RPM (non-free) - Proprietary software"
            "$HAS_TERRA Terra - Extra packages/tools"
            "$HAS_FLATHUB Flathub - Universal App Store"
        )

        # No bottom margin to connect closely with our custom footer
        echo ""
        CHOICE=$(gum choose --header "$(gum style --foreground "$COLOR_PRIMARY" --bold "Manage Repositories")" \
            --cursor "$CUR_PRIMARY" --cursor.foreground "$COLOR_TEXT" \
            --selected.foreground "$COLOR_PRIMARY" \
            "${REPO_OPTS[@]}") || return

        case "$CHOICE" in
            *"RPM (free)"*)
                if [ "$IS_FREE" = true ]; then
                    if gum confirm "RPM Fusion (free) is enabled. Disable?"; then
                        gum spin --spinner dot --title "Removing..." -- sudo dnf remove -y rpmfusion-free-release
                    fi
                else
                    if gum confirm "Enable RPM Fusion (free)?"; then
                        gum spin --spinner dot --title "Enabling..." -- sudo dnf install -y "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
                    fi
                fi
                ;;
            *"RPM (non-free)"*)
                if [ "$IS_NONFREE" = true ]; then
                    if gum confirm "RPM Fusion (non-free) is enabled. Disable?"; then
                        gum spin --spinner dot --title "Removing..." -- sudo dnf remove -y rpmfusion-nonfree-release
                    fi
                else
                    if gum confirm "Enable RPM Fusion (non-free)?"; then
                        gum spin --spinner dot --title "Enabling..." -- sudo dnf install -y "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
                    fi
                fi
                ;;
            *"Terra"*)
                if [ "$IS_TERRA" = true ]; then
                    if gum confirm "Terra is enabled. Disable?"; then
                        gum spin --spinner dot --title "Removing..." -- sudo dnf remove -y terra-release
                    fi
                else
                    if gum confirm "Enable Terra Repository?"; then
                        gum spin --spinner dot --title "Enabling..." -- bash -c "sudo dnf install -y --nogpgcheck --repofrompath \"terra,https://repos.fyralabs.com/terra\$(rpm -E %fedora)\" terra-release"
                    fi
                fi
                ;;
            *"Flathub"*)
                if [ "$IS_FLATHUB" = true ]; then
                    if gum confirm "Flathub is enabled. Disable?"; then
                       gum spin --spinner dot --title "Removing..." -- sudo flatpak remote-delete flathub
                    fi
                else
                    if gum confirm "Enable Flathub Repository?"; then
                        gum spin --spinner dot --title "Enabling..." -- sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                    fi
                fi
                ;;
            "Back to Main Menu") return ;;
        esac
    done
}

# --- Action Processors ---

confirm_action() {
    local action="$1"
    local count="$2"
    local color="$3"
    local list_str="$4"
    
    # ANSI components for a vibrant, high-end feel
    local BOLD="\e[1m"
    local RESET="\e[0m"
    local CLR="\e[38;5;${color}m"
    local GREY="\e[38;5;244m"
    local GOLD="\e[38;5;220m" # Gold for dry-run/preview
    
    # Context-aware icons
    local ICON="✨"
    [ "$action" == "INSTALL" ] && ICON="📦"
    [ "$action" == "UNINSTALL" ] && ICON="🗑️"
    [ "$action" == "MAINTENANCE" ] && ICON="🛠️"
    
    # Assemble the descriptive block
    local output="${CLR}${BOLD}${ICON} ${action} SUMMARY${RESET}\n\n"
    if [ "$action" == "MAINTENANCE" ]; then
        output+="You are about to execute the following task:\n"
    else
        output+="You have selected ${BOLD}${count}${RESET} packages for processing:\n"
    fi
    output+="${GREY}${list_str}${RESET}"
    


    # Render with a single piped call
    echo -e "$output" | gum style \
        --border rounded \
        --border-foreground "$color" \
        --padding "1 3" \
        --margin "1 0"
        
    echo ""
    gum confirm "Execute the planned ${action,,}?" || return 1
    return 0
}

system_maintenance() {
    while true; do
        clear
        style_header
        # Synchronized spacer block
        echo -e "\n\n"
        require_sudo
        echo ""
        
        local MAINT_OPTS=(
            "🚀 Update System (DNF)"
            "🧹 Cleanup System (Autoremove/Cache)"
            "📦 Update Flatpaks"
        )
        
        local CHOICE
        echo ""
        CHOICE=$(gum choose --header "$(gum style --foreground "$COLOR_PRIMARY" --bold "System Maintenance")" \
            --cursor "$CUR_PRIMARY" --cursor.foreground "$COLOR_TEXT" \
            --selected.foreground "$COLOR_PRIMARY" \
            "${MAINT_OPTS[@]}") || return
        
        case "$CHOICE" in
            *"Update System"*)
                confirm_action "MAINTENANCE" "1" "$COLOR_INSTALL" "Full System Upgrade (dnf upgrade)" || continue
                local SESSION_LOG=$(mktemp)
                
                gum style --foreground "$COLOR_INSTALL" "🚀 Starting Update..."
                echo ""
                log_action "Started system update"
                if gum spin --spinner dot --title.foreground "$COLOR_INSTALL" --title "Updating system (this may take a while)..." -- bash -c "sudo dnf upgrade -y --refresh >> \"$SESSION_LOG\" 2>&1"; then
                    log_action "Completed system update"
                    gum style --foreground "$COLOR_INSTALL" "   ✓ Update complete"
                else
                    log_action "System update failed"
                    gum style --foreground "$COLOR_UNINSTALL" "   x Update failed"
                fi
                post_process_menu "$SESSION_LOG"
                ;;
            *"Cleanup System"*)
                confirm_action "MAINTENANCE" "1" "$COLOR_UNINSTALL" "System Cleanup (autoremove & clean)" || continue
                local SESSION_LOG=$(mktemp)
                
                gum style --foreground "$COLOR_UNINSTALL" "🧹 Starting Cleanup..."
                echo ""
                log_action "Started system cleanup"
                if gum spin --spinner dot --title.foreground "$COLOR_UNINSTALL" --title "Cleaning system..." -- bash -c "(sudo dnf autoremove -y && sudo dnf clean all) >> \"$SESSION_LOG\" 2>&1"; then
                    log_action "Completed system cleanup"
                    gum style --foreground "$COLOR_UNINSTALL" "   ✓ Cleanup complete"
                else
                    log_action "System cleanup failed"
                    gum style --foreground "$COLOR_UNINSTALL" "   x Cleanup failed"
                fi
                post_process_menu "$SESSION_LOG"
                ;;
            *"Update Flatpaks"*)
                confirm_action "MAINTENANCE" "1" "$COLOR_INSTALL" "Flatpak Update" || continue
                local SESSION_LOG=$(mktemp)
                
                gum style --foreground "$COLOR_INSTALL" "📦 Starting Flatpak Update..."
                echo ""
                log_action "Started flatpak update"
                if gum spin --spinner dot --title.foreground "$COLOR_INSTALL" --title "Updating flatpaks..." -- bash -c "flatpak update -y >> \"$SESSION_LOG\" 2>&1"; then
                    log_action "Completed flatpak update"
                    gum style --foreground "$COLOR_INSTALL" "   ✓ Update complete"
                else
                    log_action "Flatpak update failed"
                    gum style --foreground "$COLOR_UNINSTALL" "   x Update failed"
                fi
                post_process_menu "$SESSION_LOG"
                ;;

        esac
    done
}

post_process_menu() {
    local session_log="$1"
    while true; do
        echo ""
        if gum confirm --affirmative "Back to Menu" --negative "View Log" "🍻 Process complete. What's next?"; then
            return 0
        else
            if [ -f "$session_log" ]; then
                gum pager < "$session_log"
            else
                gum style --foreground "196" "Log file not found."
                sleep 1
            fi
        fi
    done
}

process_install() {
    local apps=("$@")
    [ ${#apps[@]} -eq 0 ] && return
    local list_str=""
    for app in "${apps[@]}"; do list_str+="- $app"$'\n'; done
    confirm_action "INSTALL" "${#apps[@]}" "$COLOR_INSTALL" "$list_str" || return
    
    local SESSION_LOG=$(mktemp)

    gum style --foreground "$COLOR_INSTALL" "🚀 Starting Installation..."
    echo ""
    
    for app in "${apps[@]}"; do
        local install_cmd=""
        local repo_name=""
        local repo_setup_cmd=""
        local app_type="DNF" 

        case "$app" in
            "1Password")
                repo_name="1Password"
                repo_setup_cmd="sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc && sudo sh -c 'echo -e \"[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\\\"https://downloads.1password.com/linux/keys/1password.asc\\\"\" > /etc/yum.repos.d/1password.repo'"
                install_cmd="sudo dnf install -y 1password 1password-cli"
                ;;
            "Mullvad")
                repo_name="Mullvad VPN"
                repo_setup_cmd="sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo"
                install_cmd="sudo dnf install -y mullvad-vpn"
                ;;
            "ghostty")
                repo_name="Terra (Fyra Labs)"
                if ! rpm -q terra-release &>/dev/null; then
                     repo_setup_cmd="sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$(rpm -E %fedora)' terra-release"
                fi
                install_cmd="sudo dnf install -y ghostty"
                ;;
            "Zed")
                repo_name="Terra (Fyra Labs)"
                if ! rpm -q terra-release &>/dev/null; then
                     repo_setup_cmd="sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$(rpm -E %fedora)' terra-release"
                fi
                install_cmd="sudo dnf install -y zed"
                ;;
            "Discord")
                app_type="Flatpak"
                install_cmd="flatpak install -y flathub com.discordapp.Discord"
                ;;
            "Spotify")
                app_type="Flatpak"
                install_cmd="flatpak install -y flathub com.spotify.Client"
                ;;
            "Obsidian")
                app_type="Flatpak"
                install_cmd="flatpak install -y flathub md.obsidian.Obsidian"
                ;;
            "Dropbox")
                app_type="Flatpak"
                install_cmd="flatpak install -y flathub com.dropbox.Client"
                ;;
            "mpv")
                app_type="Flatpak"
                install_cmd="flatpak install -y flathub io.mpv.Mpv"
                ;;
            "Steam")
                app_type="Flatpak"
                install_cmd="flatpak install -y flathub com.valvesoftware.Steam"
                ;;
            "Neovim")
                install_cmd="sudo dnf install -y neovim"
                ;;
            "btop")
                install_cmd="sudo dnf install -y btop"
                ;;
            "fzf")
                install_cmd="sudo dnf install -y fzf"
                ;;
            "Timeshift")
                install_cmd="sudo dnf install -y timeshift"
                ;;
            *)
                install_cmd="sudo dnf install -y $app"
                ;;
        esac
        
        # Auto-detect Flathub requirement for Flatpak apps
        if [ "$app_type" == "Flatpak" ]; then
            if ! flatpak remote-list | grep -q "flathub"; then
                repo_name="Flathub"
                repo_setup_cmd="sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
            fi
        fi

        if [ -n "$repo_name" ] && [ -n "$repo_setup_cmd" ]; then
            # Double check if we actually need to run the setup command
            # The case statement above attempts to clear repo_setup_cmd if installed, 
            # but let's be safe.
            gum style --foreground "$COLOR_PRIMARY" "⚠️  Setup Required for $app"
            echo "This app requires the ${repo_name} repository."
            if gum confirm "Enable ${repo_name} and proceed?"; then
                 # Capture output to log to see failures
                 if ! gum spin --spinner dot --title "Enabling ${repo_name}..." -- bash -c "$repo_setup_cmd >> \"$SESSION_LOG\" 2>&1"; then
                     gum style --foreground "$COLOR_UNINSTALL" "❌ Failed to enable repository. Check log."
                     continue
                 fi
            else
                 gum style --foreground "$COLOR_UNINSTALL" "Skipping $app."
                 continue
            fi
        fi

        log_action "Installing $app"
        local title_msg="Installing $app..."
        [ "$app_type" == "Flatpak" ] && title_msg="Installing $app (Flatpak)..."

        if gum spin --spinner dot --title.foreground "$COLOR_INSTALL" --title "$title_msg" -- bash -c "$install_cmd >> \"$SESSION_LOG\" 2>&1"; then
            track_install "$app"
            local icon=$(gum style --foreground "$COLOR_INSTALL" --bold "✓")
            local colored_app=$(gum style --foreground "$COLOR_INSTALL" "$app")
            echo -e "   $icon $colored_app installed successfully"
        else
            local icon=$(gum style --foreground "$COLOR_UNINSTALL" --bold "x")
            local colored_app=$(gum style --foreground "$COLOR_UNINSTALL" "$app")
            echo -e "   $icon $colored_app installation failed"
        fi
    done
    post_process_menu "$SESSION_LOG"
}

process_uninstall() {
    local apps=("$@")
    [ ${#apps[@]} -eq 0 ] && return
    local list_str=""
    for app in "${apps[@]}"; do list_str+="- $app"$'\n'; done
    confirm_action "UNINSTALL" "${#apps[@]}" "$COLOR_UNINSTALL" "$list_str" || return
    
    local SESSION_LOG=$(mktemp)

    gum style --foreground "$COLOR_UNINSTALL" "🗑️ Starting Removal..."
    echo ""
    for app in "${apps[@]}"; do
        local remove_cmd=""
        local is_flatpak=false
        
        if flatpak list --app --columns=application | grep -q "$app" || flatpak list --app --columns=name | grep -qi "$app"; then
            local flatpak_id=$(flatpak list --app --columns=application,name | grep -i "$app" | head -n1 | awk '{print $1}')
            if [ -n "$flatpak_id" ]; then
                remove_cmd="flatpak uninstall -y $flatpak_id"
                is_flatpak=true
            fi
        fi

        if [ -z "$remove_cmd" ]; then
            # Check RPM (Case Insensitive)
            if rpm -qa | grep -qi "^${app}"; then
                # Get exact package name
                local pkg_name=$(rpm -qa --queryformat '%{NAME}\n' | grep -i "^${app}$" | head -n1)
                 # Fallback if exact match fails but loose match worked
                [ -z "$pkg_name" ] && pkg_name="$app"
                remove_cmd="sudo dnf remove -y $pkg_name"
            fi
        fi

        if [ -z "$remove_cmd" ]; then
             local icon=$(gum style --foreground "220" --bold "!")
             local colored_app=$(gum style --foreground "240" "$app")
             echo -e "   $icon $colored_app not found on system (skipping)"
             continue
        fi

        log_action "Uninstalling $app"
        local title_msg="Uninstalling $app..."
        [ "$is_flatpak" = true ] && title_msg="Uninstalling $app (Flatpak)..."

        if gum spin --spinner minidot --title.foreground "$COLOR_UNINSTALL" --title "$title_msg" -- bash -c "$remove_cmd >> \"$SESSION_LOG\" 2>&1"; then
            untrack_app "$app"
            local icon=$(gum style --foreground "$COLOR_UNINSTALL" --bold "✓")
            local colored_app=$(gum style --foreground "$COLOR_UNINSTALL" "$app")
            echo -e "   $icon $colored_app removed successfully"
        else
            local icon=$(gum style --foreground "$COLOR_UNINSTALL" --bold "x")
            local colored_app=$(gum style --foreground "$COLOR_UNINSTALL" "$app")
            echo -e "   $icon $colored_app removal failed"
        fi
    done
    post_process_menu "$SESSION_LOG"
}

get_installed_candidates() {
    local candidates=("$@")
    local installed=()
    local all_rpms=$(rpm -qa --queryformat '%{NAME}\n')
    local all_flatpaks=$(flatpak list --app --columns=name)
    local all_flatpak_ids=$(flatpak list --app --columns=application)

    for app in "${candidates[@]}"; do
        if echo "$all_rpms" | grep -Fixq "$app"; then
            installed+=("$app")
        elif echo "$all_flatpaks" | grep -Fiq "$app"; then
            installed+=("$app")
        elif echo "$all_flatpak_ids" | grep -Fiq "$app"; then
             installed+=("$app")
        fi
    done
    echo "${installed[@]}"
}

select_apps() {
    local header="$1"
    local cursor="$2"
    local sel_color="$3"
    local sel_prefix="${4:-> }"
    shift 4
    local options=("$@")
    local final_apps=()
    SELECTED_APPS=() # Global result array
    
    while true; do
        local selected_csv=""
        [ ${#final_apps[@]} -gt 0 ] && selected_csv=$(IFS=,; echo "${final_apps[*]}")

        clear
        style_header
        # Synchronized spacer block
        echo -e "\n\n"
        require_sudo
        echo ""
        echo ""
        
        local choices
        choices=$(gum choose --no-limit \
            --header "$(gum style --foreground "$COLOR_PRIMARY" --bold "$header")" \
            --cursor "$cursor" --cursor.foreground "$COLOR_TEXT" \
            --selected.foreground "$sel_color" --selected-prefix "$sel_prefix" \
            --selected="$selected_csv" "${options[@]}") || return 1
        
        local needs_custom=false
        final_apps=()
        IFS=$'\n' read -d '' -r -a selected_array <<< "$choices" || true
        
        for item in "${selected_array[@]}"; do
            if [ "$item" == "➕ ADD CUSTOM APP..." ]; then needs_custom=true
            else final_apps+=("$item"); fi
        done

        if [ "$needs_custom" = true ]; then
            echo ""
            local custom_input
            custom_input=$(gum input --placeholder "Type apps here (vlc, gimp, steam)...")
            
            if [ -n "$custom_input" ]; then
                IFS=',' read -ra custom_split <<< "$custom_input"
                for app in "${custom_split[@]}"; do
                    app=$(echo "$app" | xargs)
                    if [ -n "$app" ]; then
                        local exists=false
                        for opt in "${options[@]}"; do [ "$opt" == "$app" ] && exists=true; done
                        if [ "$exists" = false ]; then
                            options=("$app" "${options[@]}")
                        fi
                        local in_final=false
                        for f_app in "${final_apps[@]}"; do [ "$f_app" == "$app" ] && in_final=true; done
                        [ "$in_final" = false ] && final_apps+=("$app")
                    fi
                done
                gum spin --spinner dot --title "Refreshing menu..." -- sleep 0.4
            fi
            continue
        else
            break
        fi
    done
    SELECTED_APPS=("${final_apps[@]}")
    return 0
}

show_system_info() {
    gum spin --spinner dot --title "Gathering detailed system information..." -- sleep 0.8
    local OS_NAME=$(. /etc/os-release && echo "$PRETTY_NAME")
    local KERNEL=$(uname -sr)
    local ARCH=$(uname -m)
    local CPU=$(lscpu | grep "Model name" | sed 's/Model name: *//' | xargs)
    local RAM=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')
    local UPTIME=$(uptime -p | sed 's/up //')
    local DE=${XDG_CURRENT_DESKTOP:-"Unknown"}
    local SESSION_TYPE=${XDG_SESSION_TYPE:-"Unknown"}
    local SELINUX=$(getenforce 2>/dev/null || echo "Not found")
    local SHELL_VAL=$(basename "$SHELL")
    local DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}' | xargs)
    local GPU_INFO="Not detected"
    if command -v glxinfo &>/dev/null; then
        # Best accuracy: Use glxinfo (requires mesa-utils)
        # Strips "Device:" prefix and any trailing parenthesis details
        GPU_INFO=$(glxinfo -B 2>/dev/null | grep "Device:" | sed 's/.*Device: //;s/ (.*//' | xargs)
    elif command -v lspci &>/dev/null; then
        # Fallback: Basic lspci parsing
        local RAW_GPU=$(lspci 2>/dev/null | grep -i 'vga\|3d\|display' | head -n 1)
        GPU_INFO=$(echo "$RAW_GPU" | cut -d ':' -f3- | xargs)
    fi
    local PKG_RPM=$(rpm -qa | wc -l)
    local PKG_FLAT=$(flatpak list | wc -l 2>/dev/null || echo 0)
    local TIME_NOW=$(date +"%Y-%m-%d %H:%M:%S")

    clear
    style_rainbow_header
    echo -e "\n\n"
    gum style \
        --border rounded --border-foreground "$COLOR_PRIMARY" --padding "1 2" --margin "0 0" --width 65 \
        "$(gum style --foreground "$COLOR_PRIMARY" --bold "💻 Detailed System Information")" "" \
        "$(gum style --foreground "$COLOR_PRIMARY" "OS:")           $OS_NAME ($ARCH)" \
        "$(gum style --foreground "$COLOR_PRIMARY" "Kernel:")       $KERNEL" \
        "$(gum style --foreground "$COLOR_PRIMARY" "Shell:")        $SHELL_VAL" \
        "$(gum style --foreground "$COLOR_PRIMARY" "DE/Session:")   $DE ($SESSION_TYPE)" \
        "$(gum style --foreground "$COLOR_PRIMARY" "SELinux:")      $SELINUX" \
        "$(gum style --foreground "$COLOR_PRIMARY" "CPU:")          $CPU" \
        "$(gum style --foreground "$COLOR_PRIMARY" "GPU:")          $GPU_INFO" \
        "$(gum style --foreground "$COLOR_PRIMARY" "RAM:")          $RAM" \
        "$(gum style --foreground "$COLOR_PRIMARY" "Disk (/):")     $DISK_USAGE" \
        "$(gum style --foreground "$COLOR_PRIMARY" "Packages:")     $PKG_RPM (rpm), $PKG_FLAT (flatpak)" \
        "$(gum style --foreground "$COLOR_PRIMARY" "Time:")         $TIME_NOW" \
        "$(gum style --foreground "$COLOR_PRIMARY" "Uptime:")       $UPTIME"
    
    echo ""
    echo ""
    tput civis  # Hide cursor
    read -rsn1
    tput cnorm  # Restore cursor
}

# --- Main Logic ---
check_distro

while true; do
    clear
    style_header
    
    # Reduced gap below the message
    echo -e "\n\n"
    require_sudo
    echo ""
    

    echo ""
    ACTION=$(gum choose --header "$(gum style --foreground "$COLOR_PRIMARY" --bold "Main Menu")" \
        --cursor "$CUR_PRIMARY" --cursor.foreground "$COLOR_TEXT" \
        "📦 Install Software" \
        "🗑️ Uninstall Software" \
        "🛠️ System Maintenance" \
        "🌐 Manage Repositories" \
        "📜 Action Log" \
        "💻 System Info" \
        "🚪 Quit") || exit 0
    
    case "$ACTION" in
        *"Install Software")
            INSTALL_OPTS=(
                "1Password"
                "btop"
                "Discord"
                "Dropbox"
                "fzf"
                "ghostty"
                "mpv"
                "Mullvad"
                "Neovim"
                "Obsidian"
                "Spotify"
                "Steam"
                "Timeshift"
                "Zed"
                "➕ ADD CUSTOM APP..."
            )
            if select_apps "Select apps to INSTALL" "$CUR_INSTALL" "$COLOR_INSTALL" "✓ " "${INSTALL_OPTS[@]}"; then
                if [ ${#SELECTED_APPS[@]} -gt 0 ]; then
                    process_install "${SELECTED_APPS[@]}"
                else gum style --foreground "240" "No selection made."; fi
            fi
            ;;
        *"Uninstall Software")
            # Dynamic Load: Defaults + Database
            DEFAULTS=("firefox" "libreoffice" "gnome-software" "gnome-weather" "gnome-contacts" "gnome-maps" "gnome-calculator" "gnome-calendar" "gnome-tour" "totem" "rhythmbox" "simple-scan" "cheese" "baobab" "yelp" "mediawriter")
            TRACKED=()
            [ -f "$DB_FILE" ] && mapfile -t TRACKED < "$DB_FILE"
            
            # Combine known candidates
            IFS=$'\n' CANDIDATES=($(printf "%s\n" "${DEFAULTS[@]}" "${TRACKED[@]}" | sort -u | grep -v "^$"))
            unset IFS
            
            # Check availability (Filter)
            gum spin --spinner dot --title "Scanning installed applications..." -- sleep 0.5
            
            # Filter matches
            INSTALLED_LIST=()
            # Use read -r -a to parse the space-separated string back to array
            read -r -a INSTALLED_LIST <<< "$(get_installed_candidates "${CANDIDATES[@]}")"
            
            if [ ${#INSTALLED_LIST[@]} -eq 0 ]; then
                gum style --foreground "240" "No likely apps found to uninstall."
                sleep 2
                continue
            fi

            UNINSTALL_OPTS=("${INSTALLED_LIST[@]}" "➕ ADD CUSTOM APP...")
            if select_apps "Select apps to UNINSTALL" "$CUR_UNINSTALL" "$COLOR_UNINSTALL" "x " "${UNINSTALL_OPTS[@]}"; then
                if [ ${#SELECTED_APPS[@]} -gt 0 ]; then
                    process_uninstall "${SELECTED_APPS[@]}"
                else gum style --foreground "240" "No selection made."; fi
            fi
            ;;
        *"System Maintenance") system_maintenance ;;
        *"Manage Repositories") manage_repositories ;;
        *"Action Log")
            if [ -f "$LOG_FILE" ]; then
                gum pager < "$LOG_FILE"
            else
                gum style --foreground "$COLOR_UNINSTALL" "No log file found yet."
                sleep 2
            fi
            ;;
        *"System Info") show_system_info ;;
        *"Quit")
            clear
            GOODBYES=("Goodbye" "Au revoir" "Adiós" "Arrivederci" "Adeus" "さようなら (Sayonara)" "再见 (Zài jiàn)" "नमस्ते (Namaste)" "Bi xatirê te" "Ցտեսություն (Ctesutyun)" "Güle güle")
            RANDOM_INDEX=$((RANDOM % ${#GOODBYES[@]}))
            MSG="${GOODBYES[$RANDOM_INDEX]}, 'til next time!"
            gum style --foreground "$COLOR_PRIMARY" "$MSG"
            exit 0 
            ;;
    esac
done

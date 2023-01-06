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
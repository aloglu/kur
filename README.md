# kur
`kur` is a personalized shell script to help me set up a new Fedora system. It can also be used on other systems, as it's package manager agnostic.

Since the script installs specific applications, I don't expect it to be used by anyone else but me. That being said, feel free to customize it to your needs.

# Usage
The script should be executable out of the box but if it isn't, go to the folder you cloned the repository into and then type `chmod +x kur.sh`. You can then type `./kur.sh` to run it.

# Notes
`kur` includes a set up of my [`dotfiles`](https://github.com/aloglu/dotfiles), but it's optional. `dotfiles` is excluded from the option that installs everything.

`gur` is the exact same script, but unlike `kur` it uses [`gum`](https://github.com/charmbracelet/gum) so it's [prettier](https://raw.githubusercontent.com/aloglu/kur/master/screenshots/gur.png).
# Get root of dotfiles repo
declare -r REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
declare -r SHARED_DIR="$REPO_DIR/general"
declare -r LINUX_DIR="$REPO_DIR/linux"
declare -r MACOS_DIR="$REPO_DIR/macOS"

# Array of packages to install
declare -a packages
declare -a pip_packages

# Adds a dotfiles choice to an array if the command exists
# dotfiles_addconfig my_choices bash on
dotfiles_addconfig() {
  local -n array=$1
  setdown_hascmd "$2" && array+=($2 $3)
}

# Determines if a package is installed via pip
# if pip_haspkg flask; then echo "has flask"; fi
pip_haspkg() { pip show "$1" >/dev/null; }

# Adds a pip package choice to an array if the pip package is not installed
# pip_addpkg my_choices flask on
pip_addpkg() {
  local -n array=$1
  pip_haspkg "$2" || array+=($2 $3)
}

# Asks the user to select packages and adds them to the pip package array
# pkg_choices=(flask on numpy off)
# pip_getpkgs 'Select pip packages to install' pkg_choices
pip_getpkgs() {
  declare -a choices=$(setdown_getopts "$1" $2)
  pip_packages+=("${choices[@]}")
}

# Determines if a package is installed on Arch Linux
# if arch_haspkg firefox; then echo 'has firefox'; fi
arch_haspkg() { pacman -Qq $1 >/dev/null 2>&1; }

# Adds a package choice to an array if the package is not installed
# arch_addpkg my_choices firefox on
arch_addpkg() {
  local -n array=$1
  arch_haspkg "$2" || array+=($2 $3)
}

# Asks the user to select packages and adds them to the package array
# pkg_choices=(bash on ctags off dmenu on)
# arch_getpkgs 'Select software to install' pkg_choices
arch_getpkgs() {
  declare -a choices=$(setdown_getopts "$1" $2)
  packages+=("${choices[@]}")
}

# Include setdown.sh
source "$REPO_DIR/setdown.sh"

# Install dialog if missing
! setdown_hascmd dialog && sudo pacman -S dialog

#
# Ask to install yaourt if not present
#

if ! setdown_hascmd yaourt && setdown_getconsent "Install yaourt?"; then
  pacman --noconfirm -S base-devel

  git clone https://aur.archlinux.org/package-query.git
  cd package-query; makepkg -si; cd ..

  git clone https://aur.archlinux.org/yaourt.git
  cd yaourt; makepkg -si; cd ..

  rm -rf yaourt* package-query*
fi

setdown_hascmd yaourt && has_yaourt=true || has_yaourt=false

#
# Ask to install X (input, backlight, server, xinit) if not present
#

if ! setdown_hascmd X && setdown_getconsent "Install X?"; then
  packages+=(xf86-input-libinput xorg-xbacklight xorg-server xorg-xinit)
  has_X=true
else
  setdown_hascmd X && has_X=true || has_X=false
fi

#
# Ask which software groups to install
#

declare -a groups

groups+=(Audio on)
declare -a audio_packages
arch_addpkg audio_packages alsa-lib on
arch_addpkg audio_packages alsa-utils on
arch_addpkg audio_packages pulseaudio-alsa on
arch_addpkg audio_packages mpd on
arch_addpkg audio_packages ncmpcpp on

groups+=(Email on)
declare -a email_packages
arch_addpkg email_packages gnome-keyring on
arch_addpkg email_packages msmtp on
$has_yaourt || arch_addpkg email_packages mutt on
$has_yaourt && arch_addpkg email_packages mutt-sidebar on
arch_addpkg email_packages offlineimap on
arch_addpkg email_packages python2-keyring on
arch_addpkg email_packages python2-keyrings-alt on
arch_addpkg email_packages python2-gnomekeyring on
$has_yaourt && arch_addpkg email_packages urlview on
  
groups+=(Programming on)
declare -a programming_packages
arch_addpkg programming_packages ctags on
$has_X && arch_addpkg programming_packages gvim on
arch_addpkg programming_packages python-pip on
arch_addpkg programming_packages python2-pip on
arch_addpkg programming_packages texlive-core off
arch_addpkg programming_packages texlive-humanities off
arch_addpkg programming_packages texlive-pictures off

groups+=(Utility on)
declare -a utility_packages
$has_X && arch_addpkg utility_packages accountsservice on
arch_addpkg utility_packages bash-completion on
$has_yaourt && arch_addpkg utility_packages dropbox on
arch_addpkg utility_packages git on
arch_addpkg utility_packages htop on
arch_addpkg utility_packages ntp on
arch_addpkg utility_packages openssh on
arch_addpkg utility_packages rfkill on
arch_addpkg utility_packages rsync on
arch_addpkg utility_packages tmux on
arch_addpkg utility_packages unzip on
arch_addpkg utility_packages wpa_actiond on

groups+=(Extras on)
declare -a extra_packages
arch_addpkg extra_packages calc on
arch_addpkg extra_packages dictd on
$has_yaourt && arch_addpkg extra_packages gcalcli on
$has_yaourt && $has_X && arch_addpkg extra_packages gcalert on
$has_x && arch_addpkg extra_packages xdotool on # For sxhkd
$has_yaourt && $has_X && arch_addpkg extra_packages xdo-git on # For sxhkd
$has_x && arch_addpkg extra_packages xorg-xdpyinfo # For lemonbar

if $has_X; then
  groups+=(Fonts on)
  declare -a font_packages
  arch_addpkg font_packages adobe-source-sans-pro-fonts on
  $has_yaourt && arch_addpkg font_packages otf-meslo-powerline-git on
  $has_yaourt && arch_addpkg font_packages ttf-mplus on

  groups+=(Browsers on)
  declare -a browser_packages
  arch_addpkg browser_packages chromium off
  arch_addpkg browser_packages firefox on
  $has_yaourt && arch_addpkg browser_packages google-chrome off

  groups+=(Desktop on)
  declare -a desktop_packages
  arch_addpkg desktop_packages bspwm on
  arch_addpkg desktop_packages compton on
  arch_addpkg desktop_packages dmenu on
  arch_addpkg desktop_packages dunst on
  arch_addpkg desktop_packages feh on
  $has_yaourt && arch_addpkg desktop_packages gtk-theme-iris-dark-git on
  $has_yaourt && arch_addpkg desktop_packages lemonbar-xft-git on
  arch_addpkg desktop_packages lightdm-gtk-greeter off
  $has_yaourt && arch_addpkg desktop_packages lightdm-webkit-theme-tendou on
  $has_yaourt && arch_addpkg desktop_packages numix-circle-icon-theme-git on
  arch_addpkg desktop_packages rxvt-unicode on
  arch_addpkg desktop_packages scrot on
  arch_addpkg desktop_packages sxhkd on
  arch_addpkg desktop_packages zathura-pdf-mupdf on

  groups+=('Shell Scripts' on)
  declare -a script_packages
  $has_yaourt && arch_addpkg script_packages i3lock-lixxia-git on
  arch_addpkg script_packages imagemagick on
  arch_addpkg script_packages scrot on
  arch_addpkg script_packages tmux on
  $has_yaourt && arch_addpkg script_packages xss-lock on
fi

#
# Ask which packages to each install from each group
#

declare -a choices=$(setdown_getopts 'Package groups to install' groups)
for choice in "${choices[@]}"; do
  case "$choice" in
    Audio)
      arch_getpkgs 'Audio packages' audio_packages ;;
    Email)
      arch_getpkgs 'Email packages' email_packages ;;
    Programming)
      arch_getpkgs 'Programming packages' programming_packages ;;
    Utility)
      arch_getpkgs 'Utility packages' utility_packages ;;
    Extras)
      arch_getpkgs 'Extra packages' extra_packages ;;
    Fonts)
      arch_getpkgs 'Font packages' font_packages ;;
    Browsers)
      arch_getpkgs 'Browser packages' browser_packages ;;
    Desktop)
      arch_getpkgs 'Desktop packages' desktop_packages ;;
    'Shell Scripts')
      arch_getpkgs 'Shell script packages' script_packages ;;
  esac
done

# Install software if packages were selected
if [ "${#packages[@]}" -gt 0 ]; then
  if setdown_sudo 'Enter password to install packages'; then
    $has_yaourt && pkg_manager=yaourt || pkg_manager='sudo pacman'
    setdown_putcmd $pkg_manager --noconfirm -Syyu "${packages[@]}"

    # Clean up any orphaned packages
    [ -n "$($pkg_manager -Qqtd)" ] && \
      setdown_putcmd $pkg_manager -Rns "$($pkg_manager -Qqtd)"
  else
    setdown_putstr_ok 'Skipping install'
  fi
fi

#
# Post installation setup
#

# Install pypi packages if pip is installed
if setdown_hascmd pip; then
  declare -a pip_package_choices
  pip_addpkg pip_package_choices colorz on
  pip_addpkg pip_package_choices zenbu on

  pip_getpkgs 'Pypi packages to install' pip_package_choices
fi

# 
# Ask which dotfiles to set up
#

declare -a dotfile_choices
dotfiles_addconfig dotfile_choices bash on
dotfiles_addconfig dotfile_choices compton on
dotfiles_addconfig dotfile_choices gcalert on
dotfiles_addconfig dotfile_choices git on
dotfiles_addconfig dotfile_choices lightdm on
dotfiles_addconfig dotfile_choices mpd on
setdown_hascmd msmtp && dotfile_choices+=('msmtp templates' off)
setdown_hascmd mutt && dotfile_choices+=('mutt templates' off)
dotfiles_addconfig dotfile_choices ncmpcpp on
dotfiles_addconfig dotfile_choices offlineimap on
setdown_hascmd offlineimap && dotfile_choices+=('offlineimap templates' off)
dotfiles_addconfig dotfile_choices screen on
dotfile_choices+=('shell scripts' on)
dotfiles_addconfig dotfile_choices tmux on
dotfiles_addconfig dotfile_choices vim on
dotfiles_addconfig dotfile_choices X on
dotfiles_addconfig dotfile_choices zenbu on
 
declare -a choices=$(setdown_getopts 'Dotfiles to set up' dotfile_choices)
for choice in "${choices[@]}"; do
  case "$choice" in
    bash)
      setdown_link $SHARED_DIR/bashrc ~/.bashrc
      ;;
    compton)
      setdown_link $LINUX_DIR/compton.conf ~/.compton.conf
      ;;
    gcalert)
      mkdir -p ~/.config/gcalertrc/
      setdown_link $LINUX_DIR/config/gcalert/gcalertrc ~/.config/gcalertrc/
      ;;
    git)
      setdown_link $SHARED_DIR/gitignore ~/.gitignore
      git config --global core.excludesfile ~/.gitignore
      git config --global core.editor vim
      git config --global user.name \
        "$(setdown_getstr 'Git name:' 'Kate Hart')"
      git config --global user.email \
        "$(setdown_getstr 'Git email:' 'codehearts@users.noreply.github.com')"
      ;;
    lightdm)
      if setdown_hascmd systemctl; then
        if [ "$(systemctl is-enabled lightdm)" != "enabled" ]; then
          if setdown_sudo 'Enter password to enable lightdm'; then
            sudo systemctl enable lightdm.service
          else
            setdown_putstr_ok 'Skipping lightdm service enable'
          fi
        fi
      fi
      ;;
    mpd)
      mkdir -p ~/.mpd/playlists
      mkdir -p ~/.mpd/tmp
      touch ~/.mpd/{database,log,pid,state}
      setdown_link $SHARED_DIR/mpd.conf ~/.mpd/
      ;;
    'msmtp templates')
      mkdir -p ~/.msmtp
      setdown_copy $REPO_DIR/msmtprc-sample ~/.msmtprc-sample
      setdown_link $SHARED_DIR/msmtp/msmtp-gnome-tool.py ~/.msmtp/
      ;;
    'mutt templates')
      mkdir -p ~/.mutt
      setdown_copy $SHARED_DIR/muttrc-sample ~/.muttrc-sample
      setdown_copy $SHARED_DIR/mutt/custom_config ~/.mutt/
      setdown_copy $SHARED_DIR/mutt/school_config ~/.mutt/
      setdown_copy $SHARED_DIR/mutt/gmail_config ~/.mutt/
      setdown_copy $SHARED_DIR/mutt/mailcap-sample ~/.mutt/
      setdown_link $SHARED_DIR/mutt/add_sender_to_aliases.sh ~/.mutt/
      setdown_link $SHARED_DIR/mutt/loveless-theme ~/.mutt/
      ;;
    ncmpcpp)
      mkdir -p ~/.ncmpcpp
      setdown_link $SHARED_DIR/ncmpcpp/config ~/.ncmpcpp/
      setdown_link $SHARED_DIR/ncmpcpp/keys ~/.ncmpcpp/
      ;;
    offlineimap)
      if setdown_hascmd systemctl; then
        mkdir -p ~/.config/systemd/user/
        setdown_copy $LINUX_DIR/config/systemd/user/offlineimap.service \
          ~/.config/systemd/user/
        setdown_copy $LINUX_DIR/config/systemd/user/offlineimap.timer \
          ~/.config/systemd/user/

        systemctl --user daemon-reload
        systemctl --user start offlineimap.timer
        systemctl --user start offlineimap.service
        systemctl --user enable offlineimap.timer
        systemctl --user enable offlineimap.service
      fi
      ;;
    'offlineimap templates')
      setdown_copy $SHARED_DIR/offlineimaprc-sample ~/.offlineimaprc-sample
      setdown_link $SHARED_DIR/offlineimap.py ~/.offlineimap.py
      ;;
    screen)
      setdown_link $SHARED_DIR/screenrc ~/.screenrc
      ;;
    'shell scripts')
      if setdown_sudo 'Enter password to copy scripts to /usr/local/sbin'; then
        for script in $LINUX_DIR/shell-scripts/*; do
          setdown_sudo_copy "$script" /usr/local/sbin/
        done
      else
        setdown_putstr_ok 'Skipping shell script copy'
      fi
      ;;
    tmux)
      setdown_link $SHARED_DIR/tmux.conf ~/.tmux.conf
      ;;
    vim)
      mkdir -p ~/.vim/autoload/
      setdown_link $SHARED_DIR/vimrc ~/.vimrc
      setdown_copy $SHARED_DIR/vim/autoload/plug.vim ~/.vim/autoload/
      ;;
    X)
      setdown_link $LINUX_DIR/xinitrc ~/.xinitrc
      ;;
    zenbu)
      setdown_link $LINUX_DIR/config/zenbu/ ~/.config/
      zenbu soft-pink
      ;;
  esac
done

setdown_putstr_ok "Setup complete!"
clear

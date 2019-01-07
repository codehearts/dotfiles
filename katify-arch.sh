# Uses setdown.sh to install packages I want.
#
# Author: Kate Hart (https://github.com/codehearts)
# Depends: pacman, setdown.sh, sudo

# Determines if a package is installed on Arch Linux
# if arch_haspkg firefox; then echo 'has firefox'; fi
arch_haspkg() { pacman -Qq $1 >/dev/null 2>&1; }

# Adds a package choice to an array if the package is not installed
# arch_addpkg my_choices firefox on
arch_addpkg() { local -n array=$1; arch_haspkg "$2" || array+=($2 $3); }

# Asks the user to select packages and adds them to the package array
# arch_getpkgs 'Select software to install' my_choices
arch_getpkgs() {
  declare -a choices=$(setdown_getopts "$1" $2)
  packages+=("${choices[@]}")
}

# Install dialog if missing
! setdown_hascmd dialog && sudo pacman --noconfirm -S dialog

#
# Ask to install yaourt if not present
#

if ! setdown_hascmd yaourt && setdown_getconsent "Install yaourt?"; then
  if setdown_sudo 'Enter password to install yaourt'; then
    pacman --noconfirm -S base-devel

    git clone https://aur.archlinux.org/package-query.git
    cd package-query; makepkg -si; cd ..

    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt; makepkg -si; cd ..

    rm -rf yaourt* package-query*
  else
    setdown_putstr_ok 'Skipping yaourt install'
  fi
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
# Define software groups
#

declare -a groups

groups+=(Audio on)
declare -a audio_packages
arch_addpkg audio_packages alsa-lib        on
arch_addpkg audio_packages alsa-utils      on
arch_addpkg audio_packages pulseaudio-alsa on
arch_addpkg audio_packages mpd             on
arch_addpkg audio_packages ncmpcpp         on

groups+=(Email on)
declare -a email_packages
arch_addpkg email_packages                gnome-keyring        on
arch_addpkg email_packages                msmtp                on
arch_addpkg email_packages                neomutt              on
arch_addpkg email_packages                offlineimap          on
arch_addpkg email_packages                python2-keyring      on
arch_addpkg email_packages                python2-keyrings-alt on
arch_addpkg email_packages                python2-gnomekeyring on
$has_yaourt && arch_addpkg email_packages urlview              on
  
groups+=(Programming on)
declare -a programming_packages
arch_addpkg programming_packages           ctags              on
$has_X && arch_addpkg programming_packages gvim               on
arch_addpkg programming_packages           python-pip         on
arch_addpkg programming_packages           python2-pip        on
arch_addpkg programming_packages           texlive-core       off
arch_addpkg programming_packages           texlive-humanities off
arch_addpkg programming_packages           texlive-pictures   off

groups+=(Utility on)
declare -a utility_packages
$has_X && arch_addpkg utility_packages      accountsservice on
arch_addpkg utility_packages                bash-completion on
$has_yaourt && arch_addpkg utility_packages dropbox         on
arch_addpkg utility_packages                git             on
arch_addpkg utility_packages                htop            on
arch_addpkg utility_packages                ntp             on
arch_addpkg utility_packages                openssh         on
arch_addpkg utility_packages                rfkill          on
arch_addpkg utility_packages                rsync           on
arch_addpkg utility_packages                tmux            on
arch_addpkg utility_packages                unzip           on
arch_addpkg utility_packages                wpa_actiond     on

groups+=(Extras on)
declare -a extra_packages
arch_addpkg extra_packages                          calc          on
arch_addpkg extra_packages                          dictd         on
$has_yaourt && arch_addpkg extra_packages           gcalcli       on
$has_yaourt && $has_X && arch_addpkg extra_packages gcalert       on
$has_x && arch_addpkg extra_packages                xdotool       on # sxhkd
$has_yaourt && $has_X && arch_addpkg extra_packages xdo-git       on # sxhkd
$has_x && arch_addpkg extra_packages                xorg-xdpyinfo on # lemonbar

if $has_X; then
  groups+=(Fonts on)
  declare -a font_packages
  $has_yaourt && arch_addpkg font_packages ttf-mplus                   on

  groups+=(Browsers on)
  declare -a browser_packages
  arch_addpkg browser_packages                chromium      off
  arch_addpkg browser_packages                firefox       on
  $has_yaourt && arch_addpkg browser_packages google-chrome off

  groups+=(Desktop on)
  declare -a desktop_packages
  arch_addpkg desktop_packages                arc-gtk-theme               on
  arch_addpkg desktop_packages                arc-icon-theme              on
  arch_addpkg desktop_packages                bspwm                       on
  arch_addpkg desktop_packages                compton                     on
  arch_addpkg desktop_packages                dmenu                       on
  arch_addpkg desktop_packages                dunst                       on
  arch_addpkg desktop_packages                feh                         on
  $has_yaourt && arch_addpkg desktop_packages lemonbar-xft-git            on
  arch_addpkg desktop_packages                lightdm-gtk-greeter         off
  $has_yaourt && arch_addpkg desktop_packages ly                          on
  arch_addpkg desktop_packages                rxvt-unicode                on
  arch_addpkg desktop_packages                scrot                       on
  arch_addpkg desktop_packages                sxhkd                       on
  arch_addpkg desktop_packages                zathura-pdf-mupdf           on

  groups+=('Shell Scripts' on)
  declare -a script_packages
  $has_yaourt && arch_addpkg script_packages i3lock-lixxia-git on
  arch_addpkg script_packages                imagemagick       on
  arch_addpkg script_packages                scrot             on
  arch_addpkg script_packages                tmux              on
  $has_yaourt && arch_addpkg script_packages xss-lock          on
fi

#
# Ask which packages to install from each group
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

#
# Install selected software packages
#

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

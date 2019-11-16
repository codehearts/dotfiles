## Dotfiles and Setup Scripts

This repo is mostly for my own convenience, but might be of interest to those working on their own configurations. Check out the [Wiki](https://github.com/nejsan/dotfiles/wiki) for more information on some of the configs and how the setup script is used.

### macOS Quick Setup

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install git && git clone https://github.com/codehearts/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./katify.sh --macOS
```

## Commit Legend

| macOS | Shell | Vim |
| ----- | ----- | --- |
| 🍎   | 🐚   |🖍  |

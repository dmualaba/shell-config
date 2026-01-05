# shell-config
Creation of a customized zshell prompt. 

## Requirements to get the prompt shown below:
- VS code (Cursor)
- Xcode
- homebrew
- OhMyZsh
- powerlevel10k

<img width="430" height="29" alt="image" src="https://github.com/user-attachments/assets/3eeff40b-39b3-4f8d-b470-7b8ee748abd0" />


# Software installation

## Setup Brew (package manager for macOS)

### Install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

### Homebrew to PATH (Apple Silicon)

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

### install wget

brew update

### upgrade all installed brew packages to the latest version

brew upgrade

### uninstall an existing package

brew uninstall font-meslo-lg-nerd-font 


## Ohmyzsh

### install fonts

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf 

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"




## Powerlevel10k
brew install powerlevel10k









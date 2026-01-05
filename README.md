# shell-config
My customized zsh prompt.

<img width="429" height="137" alt="image" src="https://github.com/user-attachments/assets/3d974ef3-4fec-4ed0-9868-d92aa8568b77" />

## ⚠️ Requirements to get the prompt shown below:
- VS code (Cursor)
- Xcode
- homebrew
- OhMyZsh
- powerlevel10k

<img width="430" height="29" alt="image" src="https://github.com/user-attachments/assets/3eeff40b-39b3-4f8d-b470-7b8ee748abd0" />


# 🔧 Software installation

## Setup Brew (package manager for macOS)

### install

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

### brew to PATH (Apple Silicon)

```echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile ```
```eval "$(/opt/homebrew/bin/brew shellenv)" ```

### install wget

```brew install wget```

### upgrade all installed brew packages to the latest version

```brew upgrade```

### uninstall an existing package

```brew uninstall font-meslo-lg-nerd-font```

## Ohmyzsh

### install fonts

```bash
wget \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
```


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"




## Powerlevel10k
brew install powerlevel10k









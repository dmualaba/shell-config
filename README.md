# shell-config
My customized zsh prompt.

The customized prompt can be installed manually or
through the ```bash install.sh``` script.

If you run the install.sh script don't forget the next steps.

<img width="429" height="137" alt="image" src="https://github.com/user-attachments/assets/3d974ef3-4fec-4ed0-9868-d92aa8568b77" />

## ⚠️ Software Requirements
- VS code (Cursor)
- Xcode
- homebrew
- OhMyZsh
- powerlevel10k
- eza


# 🔧 Software installation

## Setup Brew (package manager for macOS)

### install

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### brew to PATH (Apple Silicon)

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### install wget

```bash
brew install wget
```

### upgrade all installed brew packages to the latest version

```bash
brew upgrade
```

### uninstall an existing package

```bash
brew uninstall font-meslo-lg-nerd-font
```

## Ohmyzsh

### install fonts

```bash
wget -P ~/Library/Fonts/ \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf \
  https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
```

To make the fonts available in your vscode, you have to edit the settings.json file.

```bash
echo '{
    "window.commandCenter": true,
    "workbench.colorTheme": "Cursor Dark High Contrast",
    "terminal.integrated.fontFamily": "MesloLGS NF",

```

### install ohmyzsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### install ohmyzsh plugins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### reload ohmyzsh

```bash
omz reload
```

## Powerlevel10k

```bash
brew install powerlevel10k
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
omz reload
```

## eza
```bash
brew install eza
```


# 🔧 Configuration

## Ohmyzsh

```bash
nano ~/.zshrc
```

```bash
autoload -Uz compinit
compinit
export ZSH="$HOME/.oh-my-zsh"
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

## Powerlevel10k

follow the wizard of the following command:
```bash
p10k configure
```

# 🎨 Adding customized colors

It is recommended to add the configuration below to your ```settings.json```, as vscode may override your color selections.
For example, if vscode already defines a similar color with slight differences, it may enforce its own value. Additionally, if vscode determines that your chosen color negatively affects readability, it may ignore your selection and retain its default color. To prevent this behavior, you must add the following configuration parameters. 
These are my color parameters.

```bash
echo '{
"terminal.integrated.minimumContrastRatio": 1,
    "workbench.colorCustomizations": {
        "terminal.ansiGreen": "#00ff00",
        "terminal.ansiBrightGreen": "#00ff00",
        "terminal.ansiYellow": "#ffff00",
        "terminal.ansiBrightYellow": "#ffff00",
        "terminal.selectionBackground": "#ff0087",
        "terminal.selectionForeground": "#000000"
    }

}' >> /Users/$USER/Library/Application\ Support/Cursor/User/settings.json
```

## Adding your prompt colors

Edit the ```.p10k.zsh``` file and add your own color values, or run the following command to apply my color settings:

```bash
sed -i '' \
  -e 's/POWERLEVEL9K_OS_ICON_FOREGROUND=.*/POWERLEVEL9K_OS_ICON_FOREGROUND=0/' \
  -e 's/POWERLEVEL9K_OS_ICON_BACKGROUND=.*/POWERLEVEL9K_OS_ICON_BACKGROUND=255/' \
  -e 's/POWERLEVEL9K_DIR_BACKGROUND=.*/POWERLEVEL9K_DIR_BACKGROUND=198/' \
  -e 's/POWERLEVEL9K_DIR_FOREGROUND=.*/POWERLEVEL9K_DIR_FOREGROUND=231/' \
  -e 's/POWERLEVEL9K_VCS_CLEAN_BACKGROUND=.*/POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2/' \
  -e 's/POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=.*/POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=220/' \
  -e 's/POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=.*/POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=220/' \
  -e 's/POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=.*/POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=196/' \
  -e 's/POWERLEVEL9K_VCS_LOADING_BACKGROUND=.*/POWERLEVEL9K_VCS_LOADING_BACKGROUND=14/' \
  ~/.p10k.zsh
```

To apply the changes:
```bash 
source  ~/.p10k.zsh
```

## Customized LS-output

Edit the ```.zshrc``` file
```bash
echo 'alias ls="eza -l --group --icons --color=always"
export EZA_COLORS="\
di=38;5;44:fi=38;5;208:ex=38;5;129:ln=38;5;45:or=38;5;196:\
uu=38;2;255;0;135:un=38;2;255;0;135:\
gu=38;2;255;255;0:gn=38;2;255;255;0:\
ur=38;2;29;255;149:gr=38;2;29;255;149:tr=38;2;29;255;149:\
uw=38;2;255;172;186:gw=38;2;255;172;186:tw=38;2;255;172;186:\
ux=38;2;165;213;255:gx=38;2;165;213;255:tx=38;2;165;213;255:\
ue=38;2;165;213;255:ge=38;2;165;213;255:te=38;2;165;213;255"' >> vi ~/.zshrc 
```

To apply changes:

```bash
source vi ~/.zshrc 
````



















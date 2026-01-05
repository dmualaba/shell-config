# Line-by-Line Explanation of install.sh

## Header and Setup (Lines 1-9)

**Line 1:** `#!/bin/bash`
- Shebang: tells the system to use bash to execute this script

**Line 3:** `set -e`
- Exit immediately if any command returns a non-zero exit status (fails)

**Lines 6-9:** Color definitions for terminal output
- `RED`, `GREEN`, `YELLOW`: ANSI color codes for colored output
- `NC`: Reset to default color
- Used to make log messages visually distinct

---

## Helper Functions (Lines 11-94)

### Logging Functions (Lines 12-22)

**Lines 12-14:** `log_info()`
- Prints green `[INFO]` messages
- `echo -e`: enables interpretation of escape sequences (like colors)

**Lines 16-18:** `log_warn()`
- Prints yellow `[WARN]` messages for warnings

**Lines 20-22:** `log_error()`
- Prints red `[ERROR]` messages for errors

### Utility Functions (Lines 24-53)

**Lines 24-30:** `check_command()`
- Checks if a command exists in PATH
- `command -v "$1"`: finds the path to command `$1`, returns non-zero if not found
- `&> /dev/null`: redirects stdout and stderr to /dev/null (silences output)
- Returns 0 (success) if found, 1 (failure) if not

**Lines 32-38:** `file_exists()`
- Checks if a file exists and is a regular file
- `-f`: test if file exists and is a regular file
- Returns 0 if exists, 1 if not

**Lines 40-46:** `file_contains()`
- Checks if a file exists AND contains a specific string
- `grep -q`: searches for pattern, `-q` makes it quiet (no output)
- Returns 0 if found, 1 if not

**Lines 48-53:** `backup_file()`
- Creates a timestamped backup of a file
- `$(date +%Y%m%d_%H%M%S)`: generates timestamp (e.g., 20241215_143022)
- `cp`: copies file to backup location

### Safe Operations (Lines 55-94)

**Lines 55-75:** `safe_append()`
- Safely appends content to a file without duplicating
- Parameters:
  - `$1`: file path
  - `$2`: content to append
  - `$3`: description (optional)
- `local`: creates local variables (function-scoped)
- Creates file if it doesn't exist with `touch`
- Checks if content already exists before appending
- Prevents duplicate entries

**Lines 77-94:** `safe_download()`
- Downloads a file only if it doesn't already exist
- `basename "$dest"`: extracts filename from full path
- `wget -P "$(dirname "$dest")"`: downloads to directory of destination
- `$(dirname "$dest")`: extracts directory path from full path

---

## Prerequisites Check (Lines 96-103)

**Line 97:** Logs that prerequisites are being checked

**Lines 100-103:** macOS check
- `$OSTYPE`: environment variable containing OS type
- `"darwin"*`: pattern matching for macOS (darwin is macOS kernel name)
- Exits with error code 1 if not macOS

---

## Homebrew Setup (Lines 105-132)

**Line 106:** Section header log

**Lines 108-120:** Homebrew installation check
- Checks if `brew` command exists
- If not installed: downloads and runs Homebrew installer script
- For Apple Silicon (ARM64) Macs: adds Homebrew to PATH in `.zprofile`
- `eval "$(/opt/homebrew/bin/brew shellenv)"`: sets up Homebrew environment

**Lines 122-128:** wget installation
- Checks if `wget` exists, installs via Homebrew if not

**Lines 130-132:** Upgrades all Homebrew packages to latest versions

---

## Font Installation (Lines 134-149)

**Line 135:** Section header

**Line 136:** Sets font directory path (standard macOS fonts location)

**Lines 138-143:** Font array definition
- Array of font URL and filename pairs
- `%20`: URL encoding for spaces
- Format: `"url|filename"`

**Lines 145-149:** Font download loop
- `"${fonts[@]}"`: expands array to all elements
- `IFS='|'`: sets Internal Field Separator to pipe (splits on `|`)
- `read -r url filename`: reads URL and filename from split string
- `<<<`: here-string (feeds string to command)
- Downloads each font using `safe_download`

---

## VS Code/Cursor Configuration (Lines 151-201)

**Line 152:** Section header

**Line 153:** Sets path to Cursor settings.json file
- Uses `$USER` environment variable (current username)

**Line 156:** Creates directory structure if it doesn't exist
- `mkdir -p`: creates parent directories as needed

**Lines 159-162:** Initializes settings.json if missing
- Creates empty JSON object `{}` if file doesn't exist

**Lines 165-201:** Adds terminal font and color settings
- Checks if font family is already configured
- Backs up existing settings file
- Uses Python3 to safely merge JSON (preserves existing settings)
- Python script:
  - Loads existing settings or starts with empty dict
  - `setdefault()`: creates nested dicts if they don't exist
  - Sets terminal font, colors, and theme
  - Writes formatted JSON back to file

---

## Oh My Zsh Installation (Lines 203-230)

**Line 204:** Section header

**Lines 205-210:** Oh My Zsh installation check
- Checks if `.oh-my-zsh` directory exists
- If not: runs official installer script
- `--unattended`: prevents interactive prompts

**Lines 213-230:** Plugin installation
- `ZSH_CUSTOM`: custom directory for Oh My Zsh plugins
- `${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}`: uses ZSH_CUSTOM if set, otherwise default
- Checks if plugin directories exist before cloning
- Clones from GitHub:
  - `zsh-autosuggestions`: command autocomplete
  - `zsh-syntax-highlighting`: syntax highlighting

---

## Powerlevel10k Installation (Lines 232-239)

**Lines 232-239:** Powerlevel10k theme installation
- Checks if installed via Homebrew (`brew list` checks package list)
- Installs via Homebrew if not found

---

## .zshrc Configuration (Lines 241-288)

**Line 242:** Section header

**Lines 243-246:** Creates `.zshrc` if it doesn't exist

**Lines 248-264:** Adds Oh My Zsh configuration
- Checks if each configuration exists before adding:
  - `ZSH` environment variable
  - `compinit` (completion system)
  - Plugin source lines
  - Plugin list
- Uses `safe_append` to prevent duplicates

**Lines 266-272:** Adds Powerlevel10k theme source
- Checks if theme is already sourced
- `$(brew --prefix)`: gets Homebrew installation prefix
- Appends source line to `.zshrc`

**Lines 274-288:** Adds eza alias configuration
- Creates alias: `ls` → `eza` with options
- Sets `EZA_COLORS` environment variable for custom colors
- Uses heredoc (`<< 'EOF'`): `'EOF'` prevents variable expansion
- Color codes format: `di=38;5;44` (directory, color index 44)

---

## eza Installation (Lines 290-297)

**Lines 290-297:** Installs eza (modern `ls` replacement)
- Checks if command exists, installs via Homebrew if not

---

## Powerlevel10k Color Configuration (Lines 299-323)

**Line 300:** Section header

**Line 301:** Sets path to Powerlevel10k config file

**Lines 303-323:** Applies custom colors
- Checks if `.p10k.zsh` exists
- If not: warns user to run `p10k configure` first
- If exists: backs up file and applies color changes using `sed`
- `sed -i ''`: in-place editing (macOS requires empty string for backup suffix)
- `-e`: expression (substitution command)
- Pattern: `s/OLD/NEW/` replaces OLD with NEW
- `.*`: matches any characters (entire line)
- Updates 9 color variables with specific values

---

## Final Instructions (Lines 325-334)

**Lines 326-334:** Completion message
- Prints installation complete message
- Provides next steps:
  1. Run `p10k configure` if needed
  2. Reload shell config
  3. Restart terminal

---

## Key Safety Features Summary

1. **File existence checks**: Never overwrites existing files without backup
2. **Content duplication prevention**: Checks if content exists before adding
3. **Command availability**: Checks if tools are installed before using
4. **Backup creation**: Creates timestamped backups before modifications
5. **Platform validation**: Ensures script only runs on macOS
6. **Error handling**: `set -e` stops script on any error


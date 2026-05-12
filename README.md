# wezterm-wsl2-config

> A WezTerm configuration designed to deliver a **macOS-like terminal experience on Windows + WSL2 + zsh**, with carefully reviewed keybindings that don't conflict with common CLI tools (vim, nano, less, bash readline).

Switching from a Mac to Windows shouldn't mean losing your terminal muscle memory. This config keeps the Cmd+C/V feel via smart `Ctrl+C/V`, adds vim-style pane navigation, and uses a clear **`Ctrl` for primary actions, `Ctrl+Shift` for secondary actions** convention to avoid hijacking essential shell shortcuts.

---

## ✨ Features

- **🍎 Mac-style copy/paste** — Smart `Ctrl+C` (copies when text is selected, sends SIGINT otherwise) and `Ctrl+V` for paste
- **🎨 Dracula theme + custom tab bar** — Clear visual distinction between active and inactive tabs
- **📊 Informative tab titles** — Auto-displays as `● 1 │ zsh │ ~/project` (indicator, number, process, directory)
- **⚡ vim block visual compatible** — `Ctrl+Q` passes through to vim/shell for block selection
- **🔀 vim-style pane management** — Move between panes with `Ctrl+Shift+HJKL`
- **🚀 Auto-launches WSL** — Opens directly into Ubuntu zsh
- **🛡️ CLI-safe keybindings** — Reviewed against vim, nano, less, and bash readline conventions

---

## 📷 Preview

```
┌──────────────────────────────────────────────────────────┐
│  ❯ python train.py                                       │
│  epoch  1 │ loss 0.342 │ lr 1e-4                         │
│  epoch  2 │ loss 0.318 │ lr 1e-4                         │
├──────────────────────────────────────────────────────────┤
│  ❯ watch -n 1 nvidia-smi                                 │
│  GPU 0: A6000  │ 78°C │ 42GB/48GB                        │
└──────────────────────────────────────────────────────────┘
[ ● 1 │ python │ ~/project ]  [ ○ 2 │ vim │ ~/configs ]
```

---

## 🔧 Prerequisites

This config assumes the following are already set up:

- ✅ **Windows 10/11**
- ✅ **WSL2 + Ubuntu** (this config targets Ubuntu 24.04 by default)
- ✅ **zsh** installed and set as the default shell
- ✅ **WezTerm** installed — see [official Windows guide](https://wezterm.org/install/windows.html)

If you don't have WSL2/zsh yet, follow [Microsoft's WSL setup guide](https://learn.microsoft.com/en-us/windows/wsl/install) and install [oh-my-zsh](https://ohmyz.sh/) first.

---

## 📦 Installation

### 1. Clone the repo

```bash
git clone https://github.com/<your-username>/wezterm-wsl2-config.git
cd wezterm-wsl2-config
```

### 2. Place the config file

In **PowerShell**:

```powershell
# Create WezTerm config directory
mkdir -Force "$env:USERPROFILE\.config\wezterm"

# Copy the config
Copy-Item wezterm.lua "$env:USERPROFILE\.config\wezterm\wezterm.lua"
```

Or place `wezterm.lua` manually at:
```
C:\Users\<your-username>\.config\wezterm\wezterm.lua
```

### 3. Match your WSL distribution name

In PowerShell:

```powershell
wsl -l -v
```

Example output:
```
  NAME             STATE           VERSION
* Ubuntu-24.04     Running         2
```

Update `wezterm.lua` to match your `NAME`:

```lua
default_domain = "WSL:Ubuntu-24.04",
```

### 4. Configure your shell (one-time setup)

In your WSL zsh:

```bash
# Disable terminal flow control so Ctrl+Q passes through to vim
# (guarded so it only runs in interactive shells, avoiding "Inappropriate ioctl" errors)
echo '[[ $- == *i* ]] && stty -ixon' >> ~/.zshrc
source ~/.zshrc
```

### 5. Launch WezTerm

WezTerm will auto-launch into your WSL Ubuntu shell. The `wezterm.lua` reloads automatically on save.

---

## ⌨️ Keybindings Cheatsheet

### Copy / Paste

| Shortcut | Action |
|---|---|
| `Ctrl + C` | Smart: copies selection if any, otherwise sends SIGINT |
| `Ctrl + V` | Paste from clipboard |
| `Ctrl + Shift + C` / `V` | Standard copy/paste (always safe backup) |

### Tabs

| Shortcut | Action |
|---|---|
| `Ctrl + T` | New tab |
| `Ctrl + Shift + T` | Close tab |
| `Ctrl + Tab` / `Ctrl + Shift + Tab` | Next / previous tab |

### Panes

| Shortcut | Action |
|---|---|
| `Ctrl + \` | Split vertically (new pane below) |
| `Ctrl + Alt + \` | Split horizontally (new pane to the right) |
| `Ctrl + Shift + W` | Close current pane |
| `Ctrl + Shift + H/J/K/L` | Navigate panes (vim-style) |
| `Ctrl + Shift + Alt + H/J/K/L` | Resize pane (1 cell per press) |

### Window / Search / Misc

| Shortcut | Action |
|---|---|
| `Ctrl + Shift + N` | New window |
| `Ctrl + Shift + F` | Search in scrollback |
| `Ctrl + Shift + A` | Select semantic zone at cursor |
| `Ctrl + Shift + X` | Enter Copy Mode (keyboard-based selection) |
| `Ctrl + =` / `Ctrl + -` / `Ctrl + 0` | Increase / decrease / reset font size |
| `Ctrl + Q` | Passes through to shell (vim block visual) |

> 📖 For detailed usage with workflow examples, see [docs/USAGE.md](./docs/USAGE.md).

---

## 🎯 Design Rationale: Why `Ctrl+Shift+` for some actions?

This config explicitly avoids hijacking `Ctrl+` shortcuts that CLI tools depend on:

| Reserved for CLI | Why |
|---|---|
| `Ctrl + W` | bash `kill-word-backward` (heavily used while editing commands), vim's window prefix |
| `Ctrl + F` | vim page-down, `less` page-forward |
| `Ctrl + N` | bash `next-history`, vim completion |
| `Ctrl + X` | nano exit, bash readline prefix |

The convention is simple:
- **`Ctrl + <key>`**: Frequent Mac-like actions that don't break essential CLI shortcuts (copy, paste, new tab, font size)
- **`Ctrl + Shift + <key>`**: Less frequent terminal-specific actions (close tab, search, copy mode, new window)

---

## 🛠️ Customization

### Change the WSL distribution

```lua
default_domain = "WSL:Ubuntu-22.04",  -- or whatever your `wsl -l -v` shows
```

### Use a Nerd Font

If you want powerline/devicon support:

```powershell
choco install jetbrainsmono-nerd-font
```

```lua
local font_name = "JetBrainsMono Nerd Font"
```

### Change the color theme

Browse [WezTerm's built-in color schemes](https://wezterm.org/colorschemes/index.html):

```lua
color_scheme = "Tokyo Night",  -- or "Catppuccin Mocha", "Nord (base16)", etc.
```

### Add custom keybindings

Append to the `keys = { ... }` array:

```lua
-- Example: jump to first/last tab
{ key = "1", mods = "CTRL", action = wezterm.action({ ActivateTab = 0 }) },
{ key = "9", mods = "CTRL", action = wezterm.action({ ActivateTab = -1 }) },
```

---

## ❓ Troubleshooting

### WezTerm opens PowerShell instead of WSL

Your `default_domain` doesn't match the actual WSL distribution name. Run `wsl -l -v` in PowerShell and copy the `NAME` value exactly.

### Korean (or other CJK) characters render as boxes

Add a CJK font to the fallback chain:

```lua
local function font_with_fallback(name, params)
    local names = { name, "D2Coding", "Nanum Gothic Coding", "Apple Color Emoji" }
    return wezterm.font_with_fallback(names, params)
end
```

### `Ctrl + Q` doesn't activate vim block visual

Check that `stty -ixon` is in your `~/.zshrc`:

```bash
grep ixon ~/.zshrc
stty -a | grep ixon  # should show "-ixon" (with leading dash)
```

### `stty: 'standard input': Inappropriate ioctl for device` on shell startup

Your `stty -ixon` line isn't guarded for non-interactive shells. Replace it:

```bash
sed -i 's|^stty -ixon$|[[ $- == *i* ]] \&\& stty -ixon|' ~/.zshrc
```

### Clipboard sync isn't working in WSL

Confirm `clip.exe` is reachable from WSL:

```bash
which clip.exe
echo "test" | clip.exe
```

If `clip.exe not found`, check that `/etc/wsl.conf` doesn't have `appendWindowsPath = false`.

### `Ctrl + C` doesn't interrupt the running process

There's likely a text selection somewhere. Press `Esc` to clear it, then `Ctrl + C` again.

---

## 📂 Repository Structure

```
wezterm-wsl2-config/
├── README.md           # This file
├── wezterm.lua         # WezTerm configuration
├── docs/
│   └── USAGE.md        # Detailed usage guide with examples
├── LICENSE             # MIT
└── .gitignore
```

---

## 🤝 Contributing

Issues and PRs welcome. Variations for other shells (fish, nushell) or alternate themes are especially appreciated.

---

## 📚 References

- [WezTerm documentation](https://wezterm.org/)
- [WezTerm keybinding reference](https://wezterm.org/config/keys.html)
- [Dracula theme for WezTerm](https://draculatheme.com/wezterm)
- [Microsoft WSL guide](https://learn.microsoft.com/en-us/windows/wsl/)

---

## 📄 License

MIT

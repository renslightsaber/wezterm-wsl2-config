# WezTerm Usage Guide

> Detailed reference for the wezterm-wsl2-config setup.
> Assumes WSL2 + Ubuntu + zsh on Windows.

---

## 🚀 Quick Start

When you launch WezTerm, it automatically opens a **WSL Ubuntu zsh shell**. If you see PowerShell or CMD instead, your `default_domain` setting needs to match the output of `wsl -l -v`.

Config file location: `C:\Users\<username>\.config\wezterm\wezterm.lua`
Open config in editor: `Ctrl + Shift + ,`

Changes save instantly thanks to `automatically_reload_config = true`.

---

## 📋 Copy / Paste

| Shortcut | Action | Notes |
|---|---|---|
| `Ctrl + C` | Smart: copies selection if any, else SIGINT | Mac `Cmd+C` feel |
| `Ctrl + V` | Paste from clipboard | Mac `Cmd+V` feel |
| `Ctrl + Shift + C` | Standard copy | Backup (always safe) |
| `Ctrl + Shift + V` | Standard paste | Backup |

### How to use

1. **Copy**: Select text with mouse drag, then press `Ctrl + C`
2. **Paste**: Press `Ctrl + V`
3. **Interrupt a process** (e.g. stop `python train.py`): With no selection active, press `Ctrl + C`

### Why two shortcuts?

The smart `Ctrl + C` is convenient but can be confusing if you accidentally have a selection active when you meant to send SIGINT. The `Ctrl + Shift + C/V` bindings always behave the standard way as a reliable backup.

> 💡 If `Ctrl + C` doesn't interrupt your process, you probably have an active selection. Press `Esc` to clear it and try again.

---

## 🗂️ Tabs

| Shortcut | Action |
|---|---|
| `Ctrl + T` | New tab |
| `Ctrl + Shift + T` | Close tab |
| `Ctrl + Tab` | Next tab |
| `Ctrl + Shift + Tab` | Previous tab |

### Tab title format

Tabs display as:
```
[ ● 1 │ zsh │ ~ ]  [ ○ 2 │ vim │ flowtex ]  [ ○ 3 │ python │ tpex_eval ]
```

- `●` / `○`: Active / inactive indicator
- Number: Tab index (1-based)
- Process: Current foreground process (`zsh`, `vim`, `python`, `ssh`, etc.)
- Directory: Current working directory (last component only, home shown as `~`)

This auto-updates as you `cd` between directories or run different commands.

---

## 🪟 Panes (split-screen within a tab)

### Splitting

| Shortcut | Action | Visual |
|---|---|---|
| `Ctrl + \` | Split vertically (new pane below) | Top/Bottom |
| `Ctrl + Alt + \` | Split horizontally (new pane to the right) | Left/Right |
| `Ctrl + Shift + W` | Close current pane | — |

> 💡 The naming is counterintuitive — WezTerm calls "splits where the new pane goes below" `SplitVertical` (because the split line is vertical-ish from the layout perspective). Just remember by the visual outcome: `Ctrl+\` = up/down, `Ctrl+Alt+\` = left/right.

### Navigation (vim-style hjkl)

| Shortcut | Direction |
|---|---|
| `Ctrl + Shift + H` | ← Left |
| `Ctrl + Shift + J` | ↓ Down |
| `Ctrl + Shift + K` | ↑ Up |
| `Ctrl + Shift + L` | → Right |

### Resize

| Shortcut | Direction |
|---|---|
| `Ctrl + Shift + Alt + H` | ← 1 cell |
| `Ctrl + Shift + Alt + J` | ↓ 1 cell |
| `Ctrl + Shift + Alt + K` | ↑ 1 cell |
| `Ctrl + Shift + Alt + L` | → 1 cell |

### Pane vs Tab — When to use which

- **Pane**: Same task context (e.g. code + training log + GPU monitor side by side)
- **Tab**: Completely different task (e.g. training project / config editing / paper writing)

---

## 🔍 Copy Mode (keyboard-only text selection)

| Shortcut | Action |
|---|---|
| `Ctrl + Shift + X` | Enter Copy Mode |

### Inside Copy Mode

| Key | Action |
|---|---|
| `h` `j` `k` `l` or arrow keys | Move cursor |
| `v` | Start visual selection |
| `V` | Line-wise selection |
| `y` or `Enter` | Copy and exit |
| `/` | Forward search |
| `?` | Backward search |
| `n` / `N` | Next / previous search result |
| `Esc` or `q` | Cancel |

### When to use Copy Mode

- Selecting a precise text range from long logs without mouse imprecision
- SSH sessions where mouse selection breaks on line wraps
- Searching scrollback (use `/` after entering Copy Mode)
- Keyboard-only workflows

---

## ⚡ vim Block Visual (`Ctrl + Q`)

`Ctrl + Q` is configured to pass through to the shell, which is essential for vim's powerful block-wise editing.

### Prerequisite

`~/.zshrc` must contain:
```bash
[[ $- == *i* ]] && stty -ixon
```

This disables terminal flow control (`Ctrl+Q` = XON historically), which was blocking the key from reaching vim.

Verify:
```bash
stty -a | grep ixon  # should show "-ixon"
```

### Entering block visual mode

In vim normal mode, press `Ctrl + Q`. The status line shows `-- VISUAL BLOCK --`.

### Operations inside block visual

| Key | Action |
|---|---|
| `d` | Delete block |
| `c` | Delete and enter insert mode |
| `y` | Yank (copy) block |
| `I` | Insert text **before** the block (applied to all lines) |
| `A` | Append text **after** the block (applied to all lines) |
| `r<char>` | Replace block with single character |
| `$` | Extend selection to end of line (variable-width) |
| `Esc` | Exit |

> 💡 `I` and `A` followed by typing then `Esc` is the killer feature — the text gets applied to every line in the block simultaneously.

### Example: Comment out multiple Python lines

Starting state:
```python
print("epoch:", epoch)
print("loss:", loss.item())
print("lr:", lr)
```

Steps:
1. Place cursor on first `p` of line 1
2. `Ctrl + Q` → enter block visual
3. `jj` → extend selection down 2 lines
4. `I` → enter insert-before mode
5. Type `# ` (hash + space)
6. `Esc` → applies to all 3 lines

Result:
```python
# print("epoch:", epoch)
# print("loss:", loss.item())
# print("lr:", lr)
```

### Example: Strip prefix from log lines

Starting state:
```
2026-01-15 14:23:01 | epoch 12 | loss 0.342
2026-01-15 14:23:18 | epoch 13 | loss 0.318
2026-01-15 14:23:35 | epoch 14 | loss 0.291
```

Steps:
1. Cursor at start of line 1 (`gg0`)
2. `Ctrl + Q`
3. `jj` to extend down
4. `21l` to extend right by 21 columns (covering the timestamp + ` | `)
5. `d` → deletes the timestamp column on all selected lines

### Example: Append to end of variable-length lines

Starting state:
```python
x = 1
yy = 22
zzz = 333
```

Steps:
1. Cursor on `x`
2. `Ctrl + Q`
3. `2j` → 3 lines selected
4. `$` → extend to end of each line (variable width!)
5. `A` → append mode
6. Type `  # noqa`
7. `Esc`

Result:
```python
x = 1  # noqa
yy = 22  # noqa
zzz = 333  # noqa
```

This works because `$` gives WezTerm-style "go to end of each line individually" rather than a fixed column.

---

## 🎨 Appearance

| Setting | Value |
|---|---|
| Theme | Dracula (with custom tab bar) |
| Font | Cascadia Code, 12pt |
| Opacity | 90% |
| Cursor | Blinking block |
| Tab bar | Bottom-aligned, always visible |
| Active tab | Bold purple |
| Auto-reload | Yes — save `wezterm.lua` for instant update |

---

## 🛠️ Debugging

### Keys aren't responding

Press `Ctrl + Shift + L` to open the debug overlay. Any key you press shows up there, with the action that gets triggered. If you see nothing, WezTerm isn't capturing the key.

### Force reload config

Should reload automatically on save. If not:
- Restart WezTerm completely (close all windows)
- Check `wezterm.lua` for syntax errors (look at the bottom-right corner for red error messages)

### Inspect all active keybindings

From PowerShell:
```powershell
wezterm.exe show-keys
```

---

## 🔄 One-time shell setup

Add to `~/.zshrc` if not already present:

```bash
# 1. For vim block visual via Ctrl+Q
[[ $- == *i* ]] && stty -ixon

# 2. Conda env name in prompt (auto-added by `conda init zsh`)
# >>> conda initialize >>> ... <<< conda initialize <<<
```

Apply:
```bash
source ~/.zshrc
```

---

## 📐 Workflow Example: Training Monitoring Setup

A common pattern for ML/AI training workflows:

```
1. Ctrl + T          ← new tab "training"

2. Ctrl + \          ← split vertical
   ┌──────────────────────┐
   │ python train.py      │  ← top pane: training script
   ├──────────────────────┤
   │ watch nvidia-smi     │  ← bottom pane: GPU monitor
   └──────────────────────┘

3. Ctrl + Shift + K  ← focus top pane

4. Ctrl + Alt + \    ← split horizontal
   ┌──────────┬───────────┐
   │ train.py │ tail wandb│  ← right pane: log tail
   ├──────────┴───────────┤
   │ nvidia-smi           │
   └──────────────────────┘

5. Ctrl + T          ← new tab "code"
   open vim/code here

6. Ctrl + Tab        ← switch tabs while iterating
```

---

## ⚠️ Common Pitfalls

| Issue | Cause | Fix |
|---|---|---|
| `Ctrl + C` doesn't interrupt | Active text selection | Press `Esc` first |
| Tab bar invisible | Config syntax error | Check bottom-right of WezTerm; restart if needed |
| vim `Ctrl + Q` not working | `stty -ixon` missing | Add to `~/.zshrc` (with `[[ $- == *i* ]] &&` guard) |
| Korean chars are boxes | Font fallback missing | Add CJK font to `font_with_fallback` chain |
| Clipboard not syncing | `clip.exe` not in WSL PATH | Check `/etc/wsl.conf` for `appendWindowsPath = false` |
| `stty: Inappropriate ioctl` error | Non-interactive shell hit `stty -ixon` | Add `[[ $- == *i* ]] &&` guard before `stty -ixon` |

---

## 📚 Further Reading

- [WezTerm Official Docs](https://wezterm.org/)
- [Keybinding Reference](https://wezterm.org/config/keys.html)
- [Lua API Reference](https://wezterm.org/config/lua/general.html)
- [Built-in Color Schemes Gallery](https://wezterm.org/colorschemes/index.html)

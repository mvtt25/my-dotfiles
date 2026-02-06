# My Dotfiles

A curated collection of **dotfiles**, **Zsh utilities**, and **Bash scripts** to automate daily tasks, improve productivity, and customize the development environment.

---

## Repository Structure

```
.
├── .zshrc                  # Zsh configuration (aliases, functions, utilities)
├── dotfiles/
│   ├── fastfetch/          # Fastfetch system info display config
│   ├── nvim/               # Neovim (LazyVim) configuration and plugins
│   ├── starship/           # Starship prompt configuration
│   └── wezterm/            # WezTerm terminal configuration
├── scripts/
│   ├── ai-commit.sh        # AI-powered conventional commit messages using Claude
│   ├── backup_auto.sh      # Automated folder backups
│   ├── iplookup.sh         # IP address geolocation lookup
│   ├── pswgen.sh           # Password generator with entropy scoring
│   └── tmpcleaner.sh       # Temporary file cleaner
└── aesthetic-wallpaper/    # Wallpaper collection
```

---

## Dotfiles

| Tool         | Description                                                        |
| ------------ | ------------------------------------------------------------------ |
| `fastfetch`  | System info display — shows OS, CPU, memory, and more at startup.  |
| `nvim`       | Neovim config built on LazyVim with Copilot, Neogit, and more.    |
| `starship`   | Fast, minimal, and highly customizable shell prompt.               |
| `wezterm`    | GPU-accelerated terminal with 144 FPS rendering and Tab-Bar plugin.|

## Scripts

| Script           | Description                                                      |
| ---------------- | ---------------------------------------------------------------- |
| `ai-commit.sh`   | Generates conventional commit messages using Claude Code.        |
| `backup_auto.sh` | Creates timestamped backups of specified folders.                |
| `iplookup.sh`    | Fetches geolocation data for a given IP address.                 |
| `pswgen.sh`      | Generates passwords with configurable length and charset.        |
| `tmpcleaner.sh`  | Removes temporary files (`.tmp`, `.bak`, `.swp`, `.log`, etc.). |

## Zsh Utilities (`.zshrc`)

| Function / Alias | Description                                                    |
| ----------------- | -------------------------------------------------------------- |
| `lsf` / `pf`     | Fuzzy-find files (`ls`) or processes (`ps aux`) with fzf.      |
| `history-search`  | Search Zsh history interactively with fzf.                     |
| `search-bigdir`   | Find and navigate to the largest subdirectories.               |
| `ports`           | Browse listening TCP ports — kill process or open in browser.   |
| `work` / `rest`   | Pomodoro timer (60 min work / 15 min break) with notifications.|
| `Arc`             | Open Arc browser or perform a Google search.                   |
| `pswgen`          | Interactive password generator with entropy scoring.           |
| `iplookup`        | IP geolocation lookup via ipwho.is API.                        |
| `tmpcleaner`      | Clean temporary files with optional dry-run.                   |
| `awsp`            | Switch AWS profiles interactively with fzf.                    |

---

## Requirements

- [Neovim](https://neovim.io/) (>= 0.9) — for the LazyVim configuration
- [WezTerm](https://wezfurlong.org/wezterm/) — GPU-accelerated terminal emulator
- [Starship](https://starship.rs/) — cross-shell prompt
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) — system info display
- [fzf](https://github.com/junegunn/fzf) — fuzzy finder (used by many Zsh utilities)
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/) — terminal font with icons
- `curl`, `git`, `jq` — common CLI dependencies

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/mvtt25/my-dotfiles.git
   cd my-dotfiles
   ```

2. Symlink dotfiles to their expected locations:
   ```bash
   # Neovim
   ln -s "$(pwd)/dotfiles/nvim" ~/.config/nvim

   # WezTerm
   ln -s "$(pwd)/dotfiles/wezterm" ~/.config/wezterm

   # Starship
   ln -s "$(pwd)/dotfiles/starship/starship.toml" ~/.config/starship.toml

   # Fastfetch
   ln -s "$(pwd)/dotfiles/fastfetch" ~/.config/fastfetch
   ```

3. Source the Zsh configuration:
   ```bash
   cp .zshrc ~/.zshrc   # or merge into your existing .zshrc
   source ~/.zshrc
   ```

4. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```

> Always review scripts and configs before running them to ensure they match your environment.

---

## Contributing

Contributions are welcome! Feel free to open pull requests with useful scripts or improvements. Please make sure:

- Scripts are well-documented
- You follow a consistent formatting style
- Dotfiles are organized and include a brief README if needed

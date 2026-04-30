# 🖤 karamazovjk/dotfiles

<div align="center">

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)
![Samsung NP530XBB](https://img.shields.io/badge/Samsung_NP530XBB-Celeron_N4000-grey?style=for-the-badge)

*Personal dotfiles — Arch Linux + Hyprland rice*

[PT-BR](#pt-br) · [EN](#en)

</div>

---

## PT-BR

Configurações pessoais do meu setup Arch Linux com Hyprland. Migrei do Windows em 2025 em uma decisão impulsiva mas sem arrependimentos. O setup roda em um **Samsung NP530XBB** (Celeron N4000, 4GB RAM) — prova de que dá pra fazer um rice decente em hardware modesto.

### 📦 Estrutura do repo

```
dotfiles/
├── hypr/          # Hyprland — WM, keybinds, gestures, animações
├── waybar/        # Barra de status customizada
├── rofi/          # Launcher de aplicativos
├── kitty/         # Emulador de terminal (Wayland nativo)
├── zsh/           # Shell — oh-my-zsh + Powerlevel10k
├── vscodium/      # Editor de código (fork open-source do VSCode)
├── hyprpaper/     # Wallpaper daemon do Hyprland
├── hyprpanel/     # Painel/widgets do Hyprland
├── swaylock/      # Lockscreen
├── fastfetch/     # Fetch do sistema customizado
├── hyde/          # HyDE — framework de theming
├── scripts/
│   └── arch-cleanup.sh   # Script de limpeza do sistema
└── install.sh     # Backup e restore das configs
```

### 🛠️ Apps principais

| App | Função | Pacote |
|-----|--------|--------|
| **Hyprland** | Window manager (Wayland) | `hyprland` |
| **Waybar** | Barra de status | `waybar` |
| **Rofi** | Launcher de apps | `rofi` |
| **Kitty** | Terminal | `kitty` |
| **VSCodium** | Editor de código | `vscodium-bin` |
| **Brave** | Navegador | `brave-bin` |
| **Joplin** | Notas | `joplin` |
| **Spotify** | Música | `spotify` |
| **btop** | Monitor do sistema | `btop` |
| **fastfetch** | System fetch | `fastfetch` |
| **HyDE** | Framework de theming | `hyde-cli-git` |
| **hyprpaper** | Wallpaper daemon | `hyprpaper` |
| **hyprpanel** | Painel/widgets | `hyprpanel` |
| **swaylock** | Lockscreen | `swaylock-effects-git` |
| **ProtonVPN** | VPN | `proton-vpn-gtk-app` |
| **Flatpak** | Apps sandboxed | `flatpak` |
| **zsh** | Shell | `zsh` |
| **oh-my-zsh** | Framework zsh | `oh-my-zsh-git` |
| **Powerlevel10k** | Tema do prompt | `zsh-theme-powerlevel10k-git` |
| **yay** | AUR helper | `yay` |
| **paccache** | Limpeza do cache pacman | `pacman-contrib` |

### 🚀 Como usar

**Fazer backup das suas configs atuais:**
```bash
git clone https://github.com/karamazovjk/dotfiles
cd dotfiles
./install.sh backup
git add -A && git commit -m "chore: backup $(date +%d/%m/%Y)"
git push
```

**Restaurar em uma instalação nova:**
```bash
git clone https://github.com/karamazovjk/dotfiles
cd dotfiles
./install.sh restore
hyprctl reload
```

**Ver status das configs:**
```bash
./install.sh status
```

### 🧹 Script de limpeza

O repo inclui um script de manutenção do sistema em `scripts/arch-cleanup.sh`:

```bash
arch-cleanup.sh
```

Limpa: cache do pacman, órfãos, lixeira, cache do usuário, runtimes Flatpak não usados, logs antigos e cache do uv (Python).

---

## EN

Personal configuration files for my Arch Linux + Hyprland setup. Switched from Windows in 2025 on an impulsive but zero-regrets decision. Running on a **Samsung NP530XBB** (Celeron N4000, 4GB RAM) — proof that a decent rice is possible on modest hardware.

### 📦 Repo structure

```
dotfiles/
├── hypr/          # Hyprland — WM, keybinds, gestures, animations
├── waybar/        # Custom status bar
├── rofi/          # Application launcher
├── kitty/         # Terminal emulator (Wayland native)
├── zsh/           # Shell — oh-my-zsh + Powerlevel10k
├── vscodium/      # Code editor (open-source VSCode fork)
├── hyprpaper/     # Hyprland wallpaper daemon
├── hyprpanel/     # Hyprland panel/widgets
├── swaylock/      # Lockscreen
├── fastfetch/     # Customized system fetch
├── hyde/          # HyDE — theming framework
├── scripts/
│   └── arch-cleanup.sh   # System cleanup script
└── install.sh     # Backup and restore configs
```

### 🛠️ Main apps

| App | Purpose | Package |
|-----|---------|---------|
| **Hyprland** | Window manager (Wayland) | `hyprland` |
| **Waybar** | Status bar | `waybar` |
| **Rofi** | App launcher | `rofi` |
| **Kitty** | Terminal | `kitty` |
| **VSCodium** | Code editor | `vscodium-bin` |
| **Brave** | Browser | `brave-bin` |
| **Joplin** | Notes | `joplin` |
| **Spotify** | Music | `spotify` |
| **btop** | System monitor | `btop` |
| **fastfetch** | System fetch | `fastfetch` |
| **HyDE** | Theming framework | `hyde-cli-git` |
| **hyprpaper** | Wallpaper daemon | `hyprpaper` |
| **hyprpanel** | Panel/widgets | `hyprpanel` |
| **swaylock** | Lockscreen | `swaylock-effects-git` |
| **ProtonVPN** | VPN | `proton-vpn-gtk-app` |
| **Flatpak** | Sandboxed apps | `flatpak` |
| **zsh** | Shell | `zsh` |
| **oh-my-zsh** | Zsh framework | `oh-my-zsh-git` |
| **Powerlevel10k** | Prompt theme | `zsh-theme-powerlevel10k-git` |
| **yay** | AUR helper | `yay` |
| **paccache** | Pacman cache cleanup | `pacman-contrib` |

### 🚀 Usage

**Backup your current configs:**
```bash
git clone https://github.com/karamazovjk/dotfiles
cd dotfiles
./install.sh backup
git add -A && git commit -m "chore: backup $(date +%d/%m/%Y)"
git push
```

**Restore on a fresh install:**
```bash
git clone https://github.com/karamazovjk/dotfiles
cd dotfiles
./install.sh restore
hyprctl reload
```

**Check config status:**
```bash
./install.sh status
```

### 🧹 Cleanup script

The repo includes a system maintenance script at `scripts/arch-cleanup.sh`:

```bash
arch-cleanup.sh
```

Cleans: pacman cache, orphan packages, trash, user cache, unused Flatpak runtimes, old logs and uv (Python) cache.

---

<div align="center">
<sub>Arch Linux · Hyprland · Samsung NP530XBB · Est. 2025</sub>
</div>

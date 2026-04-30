#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║              dotfiles/install.sh                     ║
# ║   Backup ou restaura configs — github.com/karamazovjk ║
# ╚══════════════════════════════════════════════════════╝
#
# Uso:
#   ./install.sh backup    → copia configs do sistema pro repo
#   ./install.sh restore   → copia configs do repo pro sistema
#   ./install.sh status    → mostra diferenças entre repo e sistema

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

separator() { echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }
ok()        { echo -e "  ${GREEN}✓${NC} $1"; }
warn()      { echo -e "  ${YELLOW}⚠${NC} $1"; }
info()      { echo -e "  ${CYAN}i${NC} $1"; }
err()       { echo -e "  ${RED}✗${NC} $1"; }

# ─── Mapa: destino no sistema → pasta no repo ────────────────
declare -A CONFIGS=(
    ["$HOME/.config/hypr"]="hypr"
    ["$HOME/.config/waybar"]="waybar"
    ["$HOME/.config/rofi"]="rofi"
    ["$HOME/.config/kitty"]="kitty"
    ["$HOME/.config/VSCodium"]="vscodium"
    ["$HOME/.config/hyprpaper"]="hyprpaper"
    ["$HOME/.config/hyprpanel"]="hyprpanel"
    ["$HOME/.config/swaylock"]="swaylock"
    ["$HOME/.config/fastfetch"]="fastfetch"
    ["$HOME/.config/hyde"]="hyde"
    ["$HOME/.zshrc"]="zsh/.zshrc"
    ["$HOME/.p10k.zsh"]="zsh/.p10k.zsh"
)

header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
    echo "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
    echo "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
    echo "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
    echo "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
    echo "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
    echo -e "${NC}"
    echo -e "${BOLD}  karamazovjk — Arch + Hyprland dotfiles${NC}"
    echo -e "  $(date '+%d/%m/%Y %H:%M')"
    separator
}

# ─── BACKUP ─────────────────────────────────────────────────
do_backup() {
    echo -e "\n${BOLD}${YELLOW}  Modo: BACKUP  (sistema → repo)${NC}\n"

    for src in "${!CONFIGS[@]}"; do
        dest="$DOTFILES_DIR/${CONFIGS[$src]}"

        if [ -e "$src" ]; then
            # Se for arquivo (ex: .zshrc), copia direto
            if [ -f "$src" ]; then
                mkdir -p "$(dirname "$dest")"
                cp "$src" "$dest"
                ok "$src → ${CONFIGS[$src]}"
            # Se for diretório, sincroniza
            elif [ -d "$src" ]; then
                mkdir -p "$dest"
                rsync -a --delete "$src/" "$dest/"
                ok "$src/ → ${CONFIGS[$src]}/"
            fi
        else
            warn "$src não encontrado, pulando"
        fi
    done

    # Copia script de limpeza
    if [ -f "$HOME/.local/bin/arch-cleanup.sh" ]; then
        cp "$HOME/.local/bin/arch-cleanup.sh" "$DOTFILES_DIR/scripts/"
        ok "arch-cleanup.sh → scripts/"
    fi

    separator
    echo -e "\n${GREEN}${BOLD}  Backup concluído!${NC}"
    echo -e "  Agora rode: ${CYAN}cd $DOTFILES_DIR && git add -A && git commit -m 'chore: backup $(date +%d/%m/%Y)'${NC}\n"
}

# ─── RESTORE ────────────────────────────────────────────────
do_restore() {
    echo -e "\n${BOLD}${YELLOW}  Modo: RESTORE  (repo → sistema)${NC}"
    echo -e "  ${RED}⚠ Isso vai sobrescrever suas configs atuais!${NC}"
    echo -e "\n  Continuar? [s/N] \c"
    read -r confirm
    [[ "$confirm" =~ ^[Ss]$ ]] || { info "Cancelado."; exit 0; }
    echo ""

    for src in "${!CONFIGS[@]}"; do
        repo_path="$DOTFILES_DIR/${CONFIGS[$src]}"

        if [ -e "$repo_path" ]; then
            if [ -f "$repo_path" ]; then
                mkdir -p "$(dirname "$src")"
                cp "$repo_path" "$src"
                ok "${CONFIGS[$src]} → $src"
            elif [ -d "$repo_path" ]; then
                mkdir -p "$src"
                rsync -a --delete "$repo_path/" "$src/"
                ok "${CONFIGS[$src]}/ → $src/"
            fi
        else
            warn "${CONFIGS[$src]} não encontrado no repo, pulando"
        fi
    done

    # Restaura script de limpeza
    if [ -f "$DOTFILES_DIR/scripts/arch-cleanup.sh" ]; then
        mkdir -p "$HOME/.local/bin"
        cp "$DOTFILES_DIR/scripts/arch-cleanup.sh" "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/arch-cleanup.sh"
        ok "arch-cleanup.sh → ~/.local/bin/"
    fi

    separator
    echo -e "\n${GREEN}${BOLD}  Restore concluído!${NC}"
    echo -e "  Rode ${CYAN}hyprctl reload${NC} para aplicar as configs do Hyprland.\n"
}

# ─── STATUS ─────────────────────────────────────────────────
do_status() {
    echo -e "\n${BOLD}  Status das configs:${NC}\n"

    for src in "${!CONFIGS[@]}"; do
        repo_path="$DOTFILES_DIR/${CONFIGS[$src]}"
        label="${CONFIGS[$src]}"

        if [ ! -e "$repo_path" ]; then
            err "$label — não existe no repo"
        elif [ ! -e "$src" ]; then
            warn "$label — não existe no sistema"
        else
            echo -e "  ${GREEN}✓${NC} $label"
        fi
    done
    echo ""
}

# ─── Main ────────────────────────────────────────────────────
header

case "${1:-}" in
    backup)  do_backup  ;;
    restore) do_restore ;;
    status)  do_status  ;;
    *)
        echo -e "\n  ${BOLD}Uso:${NC}"
        echo -e "    ${CYAN}./install.sh backup${NC}   → sistema → repo"
        echo -e "    ${CYAN}./install.sh restore${NC}  → repo → sistema"
        echo -e "    ${CYAN}./install.sh status${NC}   → ver diferenças\n"
        ;;
esac

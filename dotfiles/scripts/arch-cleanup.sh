#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║         arch-cleanup.sh                  ║
# ║  Script de limpeza — Arch + Hyprland     ║
# ║  github.com/karamazovjk                  ║
# ╚══════════════════════════════════════════╝

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

separator() { echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "  ██████╗██╗     ███████╗ █████╗ ███╗   ██╗"
    echo " ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║"
    echo " ██║     ██║     █████╗  ███████║██╔██╗ ██║"
    echo " ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║"
    echo " ╚██████╗███████╗███████╗██║  ██║██║ ╚████║"
    echo "  ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝"
    echo -e "${NC}"
    echo -e "${BOLD}  Arch Linux System Cleanup${NC}"
    echo -e "  $(date '+%d/%m/%Y %H:%M')"
    separator
}

section() { echo -e "\n${YELLOW}▶ $1${NC}"; }
ok()      { echo -e "  ${GREEN}✓${NC} $1"; }
info()    { echo -e "  ${CYAN}i${NC} $1"; }

# ─── Espaço antes ───────────────────────────────────────────
before=$(df / | awk 'NR==2 {print $3}')

header

# ─── 1. Cache do pacman ─────────────────────────────────────
section "Cache do pacman"
if command -v paccache &>/dev/null; then
    sudo paccache -rk1 -q && ok "Mantida 1 versão por pacote"
    sudo paccache -ruk0 -q && ok "Cache de pacotes removidos limpo"
else
    info "paccache não encontrado — instale pacman-contrib"
fi

# ─── 2. Orphans do pacman ───────────────────────────────────
section "Pacotes órfãos"
orphans=$(pacman -Qtdq 2>/dev/null)
if [ -n "$orphans" ]; then
    echo "$orphans"
    echo -e "\n${YELLOW}  Remover os órfãos acima? [s/N]${NC} \c"
    read -r confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        sudo pacman -Rns $orphans --noconfirm
        ok "Órfãos removidos"
    else
        info "Pulado"
    fi
else
    ok "Nenhum órfão encontrado"
fi

# ─── 3. Lixeira ─────────────────────────────────────────────
section "Lixeira"
trash_size=$(du -sh ~/.local/share/Trash/ 2>/dev/null | cut -f1)
info "Tamanho atual: ${trash_size:-0}"
rm -rf ~/.local/share/Trash/*
ok "Lixeira esvaziada"

# ─── 4. Cache do usuário ────────────────────────────────────
section "Cache do usuário (~/.cache)"
cache_size=$(du -sh ~/.cache/ 2>/dev/null | cut -f1)
info "Tamanho atual: ${cache_size:-0}"
echo -e "${YELLOW}  Limpar ~/.cache? [s/N]${NC} \c"
read -r confirm
if [[ "$confirm" =~ ^[Ss]$ ]]; then
    rm -rf ~/.cache/*
    ok "Cache limpo"
else
    info "Pulado"
fi

# ─── 5. Flatpak orphans ─────────────────────────────────────
section "Runtimes órfãos do Flatpak"
if command -v flatpak &>/dev/null; then
    flatpak uninstall --unused -y && ok "Runtimes não utilizados removidos"
else
    info "Flatpak não instalado"
fi

# ─── 6. Logs do systemd ─────────────────────────────────────
section "Logs do systemd"
log_size=$(journalctl --disk-usage 2>/dev/null | awk '{print $NF}')
info "Tamanho atual: ${log_size:-desconhecido}"
sudo journalctl --vacuum-time=7d -q
ok "Logs com mais de 7 dias removidos"

# ─── 7. Cache do uv (Python) ────────────────────────────────
section "Cache do uv (Python)"
if [ -d ~/.local/share/uv/cache ]; then
    uv_size=$(du -sh ~/.local/share/uv/cache 2>/dev/null | cut -f1)
    info "Tamanho: ${uv_size}"
    echo -e "${YELLOW}  Limpar cache do uv? [s/N]${NC} \c"
    read -r confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        rm -rf ~/.local/share/uv/cache
        ok "Cache do uv limpo"
    else
        info "Pulado"
    fi
else
    ok "Nenhum cache do uv encontrado"
fi

# ─── Resultado final ─────────────────────────────────────────
separator
after=$(df / | awk 'NR==2 {print $3}')
freed=$(( (before - after) / 1024 ))
used_pct=$(df / | awk 'NR==2 {print $5}')

echo -e "\n${BOLD}  Resultado:${NC}"
echo -e "  ${GREEN}✓ Espaço liberado: ~${freed} MB${NC}"
echo -e "  ${CYAN}i Disco usado: ${used_pct}${NC}"
separator
echo ""

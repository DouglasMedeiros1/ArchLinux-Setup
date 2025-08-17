#!/bin/bash

# ==========================================================
# Script de setup completo para Arch/Artilhino Linux
# ==========================================================
# Ele instala pacotes, restaura configs e dotfiles
# ==========================================================

# ----- Função de cores para mensagens -----
GREEN='\033[0;32m'
NC='\033[0m' # sem cor

echo -e "${GREEN}=== Iniciando setup completo do Linux ===${NC}"

# ----------------------------------------------------------
# 1️⃣ Instalar pacotes do Pacman
# ----------------------------------------------------------
if [ -f pkglist/pacman.txt ]; then
    echo -e "${GREEN}Instalando pacotes do Pacman...${NC}"
    sudo pacman -Syu --needed - < pkglist/pacman.txt
else
    echo "Arquivo pkglist/pacman.txt não encontrado, pulando..."
fi

# ----------------------------------------------------------
# 2️⃣ Instalar pacotes do AUR (via yay)
# ----------------------------------------------------------
if [ -f pkglist/aur.txt ]; then
    echo -e "${GREEN}Instalando pacotes do AUR...${NC}"
    yay -S --needed - < pkglist/aur.txt
else
    echo "Arquivo pkglist/aur.txt não encontrado, pulando..."
fi

# ----------------------------------------------------------
# 3️⃣ Instalar pacotes Flatpak
# ----------------------------------------------------------
if [ -f pkglist/flatpak.txt ]; then
    echo -e "${GREEN}Instalando pacotes Flatpak...${NC}"
    while read app; do
        flatpak install flathub "$app" -y
    done < pkglist/flatpak.txt
else
    echo "Arquivo pkglist/flatpak.txt não encontrado, pulando..."
fi

# ----------------------------------------------------------
# 4️⃣ Instalar pacotes Snap
# ----------------------------------------------------------
if [ -f pkglist/snap.txt ]; then
    echo -e "${GREEN}Instalando pacotes Snap...${NC}"
    while read app; do
        sudo snap install "$app"
    done < pkglist/snap.txt
else
    echo "Arquivo pkglist/snap.txt não encontrado, pulando..."
fi

# ----------------------------------------------------------
# 5️⃣ Copiar configs e dotfiles para home
# ----------------------------------------------------------
echo -e "${GREEN}Copiando configs e dotfiles...${NC}"

# Configs do sistema
if [ -d config ]; then
    cp -r config/* ~/.config/
else
    echo "Pasta config/ não encontrada, pulando..."
fi

# Dotfiles
if [ -d dotfiles ]; then
    cp -r dotfiles/.* ~/
else
    echo "Pasta dotfiles/ não encontrada, pulando..."
fi

# Ajustar permissões
sudo chown -R $USER:$USER ~/

echo -e "${GREEN}=== Setup completo finalizado! Faça logout/login para aplicar todas as configs ===${NC}"

#!/bin/bash

set -e  # Interrompe o script em caso de erro

echo "▶️ Iniciando a restauração do ambiente Arch + Hyperland..."

# Atualizar o sistema
echo "📦 Atualizando pacotes do sistema..."
sudo pacman -Syu --noconfirm

# Instalar pacotes do pacman
if [[ -f pacman-packages.txt ]]; then
    echo "📥 Instalando pacotes do Pacman..."
    sudo pacman -S --needed --noconfirm - < pacman-packages.txt
else
    echo "⚠️ Arquivo 'pacman-packages.txt' não encontrado!"
fi

# Instalar yay se não existir
if ! command -v yay &> /dev/null; then
    echo "⚙️ Instalando yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Instalar pacotes do AUR
if [[ -f aur-packages.txt ]]; then
    echo "📥 Instalando pacotes do AUR com yay..."
    yay -S --needed --noconfirm - < aur-packages.txt
else
    echo "⚠️ Arquivo 'aur-packages.txt' não encontrado!"
fi

# Criar diretórios se não existirem
mkdir -p ~/.config/hypr
mkdir -p ~/.config/Thunar

# Restaurar arquivos .conf para ~/.config/hypr
echo "🔁 Copiando arquivos .conf para ~/.config/hypr..."
cp -v ./*.conf ~/.config/hypr/

# Restaurar dotfiles do Hyprland e Thunar
echo "📂 Restaurando dotfiles do Hyprland..."
cp -rv dotfiles/hypr/* ~/.config/hypr/

echo "📂 Restaurando dotfiles do Thunar..."
cp -rv dotfiles/Thunar/* ~/.config/Thunar/

echo "✅ Configurações restauradas com sucesso!"
echo "🔄 Recomenda-se reiniciar a sessão ou o sistema."

#!/bin/bash
# =====================================================
# Script Unificado: Descargar-Instalar Minecraft Launcher (NOBARA/FEDORA)
# Version: 0.3
# Creator: VemaFest
# =====================================================

set -e

# 1. Verificar que NO se ejecute como root
if [ "$EUID" -eq 0 ]; then
  echo "❌ ERROR: No ejecutes este script como root (usa tu usuario normal)"
  exit 1
fi

echo "Instalando dependencias necesarias..."
sudo dnf install -y \
  wget \
  nss \
  libXScrnSaver \
  alsa-lib \
  libXcursor \
  libXrandr \
  mesa-libGL

# 2. Directorios
INSTALL_DIR="$HOME/Minecraft"
DESKTOP_FILE="$HOME/.local/share/applications/minecraft.desktop"
TMP_FILE="/tmp/Minecraft.tar.gz"

# 3. Limpieza previa
if [ -d "$INSTALL_DIR" ]; then
  echo "⚠️ Instalación previa detectada, eliminando..."
  rm -rf "$INSTALL_DIR"
fi

echo "Descargando Minecraft Launcher..."
wget -q --show-progress -O "$TMP_FILE" \
https://launcher.mojang.com/download/Minecraft.tar.gz

echo "Extrayendo archivos..."
mkdir -p "$INSTALL_DIR"
tar -xf "$TMP_FILE" -C "$INSTALL_DIR" --strip-components=1

echo "Descargando icono..."
wget -q -O "$INSTALL_DIR/minecraft-icon.png" \
https://minecraft.wiki/images/thumb/Minecraft_social_icon.png/1024px-Minecraft_social_icon.png?fcb53

echo "Asignando permisos..."
chmod +x "$INSTALL_DIR/minecraft-launcher"

echo "Creando acceso directo..."
mkdir -p "$HOME/.local/share/applications"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Name=Minecraft
Comment=Launcher de Minecraft Java Edition
Exec=$INSTALL_DIR/minecraft-launcher
Icon=$INSTALL_DIR/minecraft-icon.png
Terminal=false
Categories=Game;
Keywords=mojang;minecraft;java;
EOF

# 4. Actualizar base de datos solo si existe
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$HOME/.local/share/applications"
fi

# 5. Limpieza final
rm -f "$TMP_FILE"

echo "========================================="
echo "✅ Instalación completada correctamente"
echo "🎮 Busca 'Minecraft' en el menú"
echo "========================================="

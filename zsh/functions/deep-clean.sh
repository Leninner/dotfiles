#!/bin/bash

set -e

echo "🔧 Ejecutando limpieza profunda del sistema..."

# 1. Limpieza de apt
echo "🧼 Limpiando caché de apt..."
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y

# 2. Limpieza de logs
echo "🧼 Borrando logs antiguos..."
sudo journalctl --vacuum-time=3d
sudo rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*.log.old

# 3. Archivos temporales del sistema
echo "🧼 Eliminando archivos temporales..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# 4. Miniaturas (si usas GNOME/KDE/XFCE)
echo "🧼 Eliminando miniaturas obsoletas..."
rm -rf ~/.cache/thumbnails/*

# 5. Limpieza de caché del usuario
echo "🧼 Eliminando caché del usuario..."
rm -rf ~/.cache/*

echo "✅ Limpieza completa."

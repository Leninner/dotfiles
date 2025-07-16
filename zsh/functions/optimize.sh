#!/bin/bash

set -e

echo "🔧 Optimización del sistema Ubuntu iniciada..."

# Verifica si eres root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Por favor ejecuta como root."
  exit 1
fi

echo "📦 Actualizando paquetes..."
apt update && apt upgrade -y

echo "🧹 Eliminando paquetes innecesarios..."
apt autoremove -y
apt autoclean -y

echo "🧽 Limpiando cache de apt..."
rm -rf /var/cache/apt/archives/*.deb

echo "🗑️ Limpiando archivos temporales..."
rm -rf /tmp/*
rm -rf ~/.cache/thumbnails/*
journalctl --vacuum-time=5d

echo "🧠 Ajustando swappiness..."
sysctl vm.swappiness=10
echo 'vm.swappiness=10' > /etc/sysctl.d/99-swappiness.conf

echo "📂 Verificando uso de disco:"
df -h

echo "🔄 Recargando demonios y servicios..."
systemctl daemon-reexec
systemctl daemon-reload

echo "✅ Optimización completada exitosamente."

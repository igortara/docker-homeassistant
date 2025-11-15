#!/bin/bash

# --- 1. Настройка системы ---
echo "Обновление пакетов и установка необходимых зависимостей..."
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt updatesermod -aG docker $USER

# --- 7. Завершение ---
echo "---"
echo "✅ Установка Docker завершена!"
echo "⚠️ ВАЖНО: Для применения изменений прав доступа (чтобы использовать 'docker' без 'sudo'), пожалуйста, выйдите и снова войдите в систему."
echo "Проверьте установку после перезапуска командой: docker run hello-world"
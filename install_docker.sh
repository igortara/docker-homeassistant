#!/bin/bash

# --- 1. Очистка старых версий (запросит подтверждение) ---
echo "Поиск и удаление старых/конфликтующих пакетов Docker..."
# Удален флаг -y
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc 2>/dev/null | cut -f1)

# --- 2. Добавление официального репозитория Docker ---
echo "Обновление и подготовка к добавлению репозитория Docker..."
sudo apt update
sudo apt install ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Добавление репозитория
echo "Добавление репозитория Docker Engine..."
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# --- 3. Установка Docker Engine (запросит подтверждение) ---
echo "Обновление списка пакетов и подготовка к установке Docker Engine..."
sudo apt update
# Удален флаг -y. Здесь будет запрошено подтверждение: "Do you want to continue? [Y/n]"
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- 4. Запуск и настройка ---
echo "Запуск службы Docker и добавление пользователя в группу..."
sudo systemctl status docker
sudo systemctl start docker

# Добавление текущего пользователя в группу docker
sudo usermod -aG docker $USER

# --- 5. Проверка установки ---
echo "Проверка установки с помощью 'hello-world' (требуется sudo, если сессия не перезапущена):"
sudo docker run hello-world

echo "---"
echo "✅ Установка Docker завершена!"
echo "⚠️ ВАЖНО: Для использования 'docker' без 'sudo' вам нужно **выйти и снова войти** в систему."
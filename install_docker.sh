#!/bin/bash

# --- 1. Настройка системы ---
echo "Обновление пакетов и установка необходимых зависимостей..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# --- 2. Добавление официального GPG ключа Docker ---
echo "Добавление GPG ключа Docker..."
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# --- 3. Добавление репозитория Docker ---
echo "Добавление официального репозитория Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- 4. Установка Docker Engine ---
echo "Обновление индекса пакетов и установка Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- 5. Запуск службы и включение автозагрузки ---
echo "Запуск службы Docker и включение автозагрузки..."
sudo systemctl start docker
sudo systemctl enable docker

# --- 6. Настройка прав доступа ---
echo "Добавление текущего пользователя ($USER) в группу docker..."
sudo usermod -aG docker $USER

# --- 7. Завершение ---
echo "---"
echo "✅ Установка Docker завершена!"
echo "⚠️ ВАЖНО: Для применения изменений прав доступа (чтобы использовать 'docker' без 'sudo'), пожалуйста, выйдите и снова войдите в систему."
echo "Проверьте установку после перезапуска командой: docker run hello-world"
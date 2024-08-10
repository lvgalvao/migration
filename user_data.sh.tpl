#!/bin/bash
# Atualizar os pacotes do sistema
sudo apt update -y

# Instalar o Git
sudo apt install git -y

# Clonar o repositório
git clone https://github.com/lvgalvao/migration /home/ubuntu/migration

# Instalar o Docker
sudo apt install docker.io -y

# Iniciar e habilitar o Docker
sudo systemctl start docker
sudo systemctl enable docker

# Adicionar o usuário ao grupo Docker
sudo usermod -aG docker ${USER}

# Mudar para o diretório do repositório
cd /home/ubuntu/migration

# Construir a imagem Docker
docker build -t fastapi-app .

# Configurar variáveis de ambiente para o banco de dados
export DATABASE_URL="mssql+pyodbc://${db_username}:${db_password}@${db_address}:1433/${db_name}?driver=ODBC+Driver+17+for+SQL+Server"

# Executar o contêiner Docker com a variável de ambiente configurada
docker run -p 80:80 \
  -e DB_USER="${db_username}" \
  -e DB_PASSWORD="${db_password}" \
  -e DB_HOST="${db_address}" \
  -e DB_NAME="${db_name}" fastapi-app

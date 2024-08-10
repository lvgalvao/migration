#!/bin/bash
sudo dnf update -y
sudo dnf install git -y
git clone https://github.com/lvgalvao/migration /home/ec2-user/migration
sudo dnf install docker -y
git checkout azure
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
cd /home/ec2-user/migration

# Configurar a variável de ambiente para o banco de dados
export DATABASE_URL="mssql+pyodbc://${db_username}:${db_password}@${db_address}:1433/${db_name}?driver=ODBC+Driver+17+for+SQL+Server"

# Construir a imagem Docker
docker build -t fastapi-app .

# Executar o contêiner Docker com a variável de ambiente configurada
docker run -p 80:80 \
  -e DB_USER="${db_username}" \
  -e DB_PASSWORD="${db_password}" \
  -e DB_HOST="${db_address}" \
  -e DB_NAME="${db_name}" fastapi-app

#!/bin/bash

echo "🚀 Iniciando deploy do sistema Loomi..."

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker-compose down -v

# Remover imagens antigas
echo "🧹 Limpando imagens antigas..."
docker system prune -f

# Build das imagens
echo "🔨 Fazendo build das imagens..."
docker-compose build --no-cache

# Iniciar serviços
echo "▶️ Iniciando serviços..."
docker-compose up -d

# Aguardar serviços ficarem prontos
echo "⏳ Aguardando serviços ficarem prontos..."
sleep 30

# Executar migrações
echo "🗄️ Executando migrações do banco de clientes..."
docker-compose exec clients-service npx prisma migrate deploy

echo "🗄️ Executando migrações do banco de transações..."
docker-compose exec transactions-service npx prisma migrate deploy

# Executar seeds
echo "🌱 Executando seeds..."
docker-compose exec clients-service npm run prisma:seed
docker-compose exec transactions-service npm run prisma:seed

echo "✅ Deploy concluído!"
echo "📊 Serviços disponíveis:"
echo "   - Clientes: http://localhost:3001"
echo "   - Transações: http://localhost:3002"
echo "   - RabbitMQ Management: http://localhost:15672"
echo "   - Redis: localhost:6379"

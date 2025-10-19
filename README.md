# Sistema Loomi - Infraestrutura Docker

Este diretório contém toda a configuração Docker para o sistema Loomi, incluindo os microserviços de clientes e transações.

## Arquitetura

- **clients-service**: Microserviço de gerenciamento de clientes (Porta 3001)
- **transactions-service**: Microserviço de transações (Porta 3002)
- **postgres-clients**: Banco PostgreSQL para clientes (Porta 5433)
- **postgres-transactions**: Banco PostgreSQL para transações (Porta 5434)
- **redis**: Cache e sessões (Porta 6379)
- **rabbitmq**: Mensageria (Portas 5672, 15672)

## Como usar

### 1. Configuração inicial

```bash
# Copiar arquivo de ambiente
cp env.example .env

# Editar variáveis conforme necessário
nano .env
```

### 2. Deploy completo

```bash
# Executar script de deploy
./deploy.sh
```

### 3. Comandos úteis

```bash
# Ver logs dos serviços
docker-compose logs -f clients-service
docker-compose logs -f transactions-service

# Acessar banco de dados
docker-compose exec postgres-clients psql -U admin -d clients_db
docker-compose exec postgres-transactions psql -U admin -d transactions_db

# Executar migrações manualmente
docker-compose exec clients-service npx prisma migrate deploy
docker-compose exec transactions-service npx prisma migrate deploy

# Executar seeds
docker-compose exec clients-service npm run prisma:seed
docker-compose exec transactions-service npm run prisma:seed

# Parar todos os serviços
docker-compose down

# Parar e remover volumes
docker-compose down -v
```

## URLs dos serviços

- **Clientes API**: http://localhost:3001/api
- **Transações API**: http://localhost:3002/api/v1
- **Documentação Clientes**: http://localhost:3001/api/docs
- **RabbitMQ Management**: http://localhost:15672
- **Health Check Clientes**: http://localhost:3001/api/health
- **Health Check Transações**: http://localhost:3002/api/v1/health

## Desenvolvimento

Para desenvolvimento local, você pode usar:

```bash
# Apenas infraestrutura (bancos, redis, rabbitmq)
docker-compose up postgres-clients postgres-transactions redis rabbitmq

# Rodar os serviços localmente
cd ../client && npm run start:dev
cd ../transactions && npm run start:dev
```

## Estrutura de arquivos

```
infra/
├── docker-compose.yml          # Configuração principal do Docker Compose
├── deploy.sh                   # Script de deploy automatizado
├── env.example                 # Arquivo de exemplo de variáveis de ambiente
├── README.md                   # Este arquivo
└── init-scripts/               # Scripts de inicialização dos bancos
    ├── clients/
    │   └── 01-init.sql
    └── transactions/
        └── 01-init.sql
```

## Variáveis de ambiente

As principais variáveis de ambiente que podem ser configuradas:

- `NODE_ENV`: Ambiente de execução (development/production)
- `POSTGRES_CLIENTS_*`: Configurações do banco de clientes
- `POSTGRES_TRANSACTIONS_*`: Configurações do banco de transações
- `CLIENTS_PORT`: Porta do serviço de clientes (padrão: 3001)
- `TRANSACTIONS_PORT`: Porta do serviço de transações (padrão: 3002)
- `JWT_SECRET`: Chave secreta para JWT
- `CORS_ORIGIN`: Configuração de CORS

## Troubleshooting

### Problemas comuns

1. **Erro de conexão com banco**: Verifique se os containers dos bancos estão rodando
2. **Erro de migração**: Execute `docker-compose exec [service] npx prisma migrate deploy`
3. **Porta já em uso**: Altere as portas no arquivo `.env`

### Logs detalhados

```bash
# Ver logs de todos os serviços
docker-compose logs

# Ver logs de um serviço específico
docker-compose logs clients-service
docker-compose logs transactions-service

# Seguir logs em tempo real
docker-compose logs -f
```

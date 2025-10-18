# Infraestrutura do Projeto

## Subir o ambiente

```bash
cd infra
docker-compose up --build
```

## Serviços disponíveis

### Bancos de dados
- **PostgreSQL Clients**: `localhost:5433`
  - Usuário: `admin`
  - Senha: `admin`
  - Database: `clients_db`

- **PostgreSQL Transactions**: `localhost:5434`
  - Usuário: `admin`
  - Senha: `admin`
  - Database: `transactions_db`

### Cache e Message Broker
- **Redis**: `localhost:6379`
- **RabbitMQ Management**: `http://localhost:15672`
  - Usuário padrão: `guest`
  - Senha padrão: `guest`

### Microsserviços
- **Clients Service**: `http://localhost:3001`
- **Transactions Service**: `http://localhost:3002`

## Comandos úteis

### Parar todos os serviços
```bash
docker-compose down
```

### Parar e remover volumes (cuidado: apaga dados)
```bash
docker-compose down -v
```

### Ver logs de um serviço específico
```bash
docker-compose logs -f clients-service
docker-compose logs -f transactions-service
```

### Rebuild apenas um serviço
```bash
docker-compose up --build clients-service
```

## Estrutura dos volumes

Os dados dos bancos PostgreSQL são persistidos em volumes Docker:
- `clients_data`: dados do banco de clientes
- `transactions_data`: dados do banco de transações

## Variáveis de ambiente

Copie o arquivo `.env.example` para `.env` nos diretórios dos microsserviços e ajuste conforme necessário.

# GLPI Faculdade

Sistema GLPI (gestão de chamados e ativos de TI) rodando com Docker Compose, com banco de dados MySQL e backup local dos dados.

## Estrutura

```
.
├── docker-compose.yml   # Define os serviços glpi e db
├── database/            # Backups do banco (não versionado — ver .gitignore)
│   ├── glpi.sql               # Dump SQL do banco
│   ├── glpi_files.tar.gz      # Arquivos enviados pelos usuários
│   └── mysql_data.tar.gz      # Dados completos do MySQL
└── .env                 # Variáveis de ambiente (não versionado)
```

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) e Docker Compose
- Arquivo `.env` com as variáveis do banco:

```env
GLPI_DB_NAME=glpi
GLPI_DB_USER=glpi
GLPI_DB_PASSWORD=suasenha
```

## Como subir

```bash
docker compose up -d
```

O GLPI ficará disponível em **http://localhost:8080**.

## Restaurar o backup

Os arquivos em `database/` contêm o dump do banco e os dados do MySQL. Para restaurar:

```bash
# Subir os containers
docker compose up -d

# Restaurar o dump SQL no container do banco
docker compose exec -T db mysql -u root -p < database/glpi.sql
```

> ⚠️ O dump `glpi.sql` e os arquivos de `database/` contêm dados sensíveis e **não são versionados** no Git (ver `.gitignore`).

## Serviços

| Serviço | Imagem        | Porta  | Descrição              |
| ------- | ------------- | ------ | ---------------------- |
| glpi    | glpi/glpi     | 8080   | Aplicação web do GLPI  |
| db      | mysql         | interna| Banco de dados MySQL   |

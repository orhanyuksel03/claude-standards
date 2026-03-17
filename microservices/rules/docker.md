# Docker & Container Standards

## Container Naming

- **Container names:** `{project}-{service-name}` (qrphoto-auth-service)
- **Network:** `{project}-network`
- **Volume naming:** `{project}_{service}_data`

## Port Allocation Strategy

Servislere ardisik port ata:

```text
Infrastructure:
  PostgreSQL:     5432
  Redis:          6379
  RabbitMQ:       5672 (AMQP), 15672 (Management)
  pgAdmin:        5050
  Redis Commander: 8081
  API Gateway:    5000

Microservices: 5001-5010 (ardisik)
```

## Docker Compose Strategy

```text
docker-compose.dev.yml       → Development (tum servisler)
docker-compose.core.yml      → Core moduller (auth + license + notification)
docker-compose.{module}.yml  → Modul bazli (events, payment, etc.)
```

### Module-Based Deployment

```bash
# Customer A - Basic Package
docker-compose -f docker-compose.core.yml \
               -f docker-compose.qr.yml up -d

# Customer B - Premium Package
docker-compose -f docker-compose.core.yml \
               -f docker-compose.qr.yml \
               -f docker-compose.events.yml \
               -f docker-compose.payment.yml up -d
```

## Connection Strings

```text
# Container → Container (mikroservislerden)
Host=postgres;Port=5432;Database={service}_db;...
redis:6379,password=redis123
amqp://admin:admin123@rabbitmq:5672/{project}

# Host → Container (development)
Host=localhost;Port=5432;Database={service}_db;...
localhost:6379,password=redis123
```

## Kurallar

1. **Her servis kendi Dockerfile'ina sahip**
2. **Multi-stage build** kullan (build + runtime)
3. **Environment variable** ile konfigurasyonu yonet
4. **Health check** endpoint ekle (`/health`)
5. **Log'lari stdout'a yaz** (container log driver yakalayacak)
6. **Non-root user** ile container calistir

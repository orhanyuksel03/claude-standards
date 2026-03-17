# Microservices Standards - Mikroservis Projeleri Icin

> Mikroservis mimarisine ozel kurallar. Tekil .NET projeleri icin `dotnet/` standartlari yeterlidir.
> Bu kurallar sadece birden fazla servisin birlikte calistigi projeler icindir.

---

## Temel Prensipler

1. **Database per Service** - Her servis kendi database'ine sahip
2. **Event-Driven Communication** - Servisler arasi asenkron iletisim
3. **API Gateway** - Dis dunya ile tek giris noktasi
4. **Independent Deployment** - Her servis bagimsiz deploy edilebilir
5. **Module-Based Licensing** - Her servis bagimsiz bir modul olarak satilabilir

## Servis Tipleri

- **Core Module:** Zorunlu (tum musteriler icin gerekli) - auth, license, notification
- **Optional Module:** Opsiyonel (musteri bazli satin alinabilir)

## Proje Yapisi

```text
project-root/
├── services/
│   ├── auth-service/          → Core Module
│   ├── license-service/       → Core Module
│   ├── notification-service/  → Core Module
│   ├── event-service/         → Optional Module
│   └── ...
├── infrastructure/
│   └── docker/
│       ├── docker-compose.dev.yml
│       ├── docker-compose.core.yml
│       └── docker-compose.{module}.yml
├── docs/
├── .claude/
│   ├── memory/MEMORY.md
│   └── instructions/
└── CHANGELOG.md
```

## Detayli Kurallar

- `rules/event-driven.md` - RabbitMQ, domain events
- `rules/docker.md` - Container ve compose kurallari
- `rules/api-design.md` - API versioning, cross-service impact
- `rules/database-per-service.md` - DB izolasyonu

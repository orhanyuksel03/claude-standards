# Database Per Service Standards

## Temel Prensip

Her mikroservis kendi database'ine sahiptir. Servisler birbirinin database'ine dogrudan erisemez.

## Database Naming

```text
{service}_db

Ornekler:
  auth_db
  license_db
  event_db
  notification_db
```

## Veri Paylasimi

### ❌ Yapma: Dogrudan database erisimi

```text
Service A → Service B's Database  ← ASLA YAPMA
```

### ✅ Yap: API veya Event ile

```text
Service A → HTTP Request → Service B → Response
Service A → Publish Event → Service B → Consume Event
```

## Data Consistency

### Eventual Consistency (Tercih Edilen)

```text
Auth Service: User created → Publish UserRegisteredEvent
Notification Service: Consume event → Send welcome email
```

Event islenmesi biraz gecikebilir ama sonunda tutarli olacaktir.

### Strong Consistency (Gerektiginde)

Synchronous HTTP call ile - sadece kritik durumlarda:

```text
Payment Service → HTTP → License Service: Validate license
```

## Migration Yonetimi

- Her servis kendi migration'larini yonetir
- Migration'lar servis deploy'u ile birlikte calisir
- Servisler arasi migration conflict olmaz (ayri database)

## Kurallar

1. **Her servis kendi database'ini yonetir**
2. **Baska servisin database'ine dogrudan baglanma**
3. **Veri paylasimi icin API veya Event kullan**
4. **Eventual consistency** tercih et
5. **Her servis kendi connection string'ine sahip**
6. **Database schema degisiklikleri backward compatible olmali**

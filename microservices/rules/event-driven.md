# Event-Driven Architecture Standards

## Messaging: RabbitMQ

### Event Tipleri

**1. Domain Events (Internal)**

Servis icinde, entity uzerinde gerceklesen onemli aksiyonlar:

- User registered, email verified, password changed
- Event created, updated, deleted
- Payment completed, failed

**2. Integration Events (Cross-Service)**

Diger servisleri ilgilendiren aksiyonlar:

- `UserRegisteredEvent` → Notification Service (welcome email)
- `EventCreatedEvent` → QR Service (generate QR codes)
- `PaymentCompletedEvent` → License Service (activate module)

### Event Naming Convention

Pattern: `{Entity}{Action}Event`

```text
UserRegisteredEvent
UserLoggedInEvent
PasswordChangedEvent
EventCreatedEvent
PaymentCompletedEvent
SuspiciousActivityEvent
```

### Event Publishing Strategy

```csharp
// After SaveChangesAsync - ALWAYS
foreach (var domainEvent in entity.DomainEvents)
{
    await _eventPublisher.PublishAsync(domainEvent, cancellationToken);
}
entity.ClearDomainEvents();
```

### Event Payload

Her event minimum su bilgileri icermeli:

```csharp
public record UserRegisteredEvent(
    Guid UserId,
    string Email,
    DateTime OccurredAt  // UTC
);
```

## Kurallar

1. **SaveChangesAsync'den SONRA event publish et**
2. **Event payload'u minimal tut** (sadece gerekli bilgi)
3. **Idempotent consumer'lar yaz** (ayni event birden fazla islenmeli)
4. **Dead letter queue** konfigure et (basarisiz event'ler icin)
5. **Event'leri versiyon** (breaking change olursa v2 event olustur)
6. **Servisler birbirini dogrudan cagirmamali** (event-driven tercih et)

## Synchronous vs Asynchronous

### Synchronous (HTTP/REST)

- Critical, immediate response gereken durumlar
- Ornek: License validation, user authentication
- Pattern: API Gateway → Service

### Asynchronous (RabbitMQ Events)

- Non-critical, eventual consistency yeterli
- Ornek: Email notifications, analytics, audit logs
- Pattern: Service → Event → Service

**Kural: Mumkun oldugunca asenkron tercih et.**
